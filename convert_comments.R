## 

library(tidyverse)
library(RSQLite)
library(rvest)
library(lubridate)
library(tidytext)
library(recommenderlab)
con <- dbConnect(RSQLite::SQLite(), "corpusfull.sqlite3")

dbListTables(con)

articles <- read_rds(paste0("./articles.rds"))
posts <- dbReadTable(con, "Posts")


selected <- posts %>% filter(ID_Article %in% articles$ID_Article) %>% filter(Status == "online") %>% filter(is.na(ID_Parent_Post))

#head(selected) %>% View()


sentiws_pos <- "senti/SentiWS_v2.0_Positive.txt"
sentiws_neg <- "senti/SentiWS_v2.0_Negative.txt"
negativ <- read.table(sentiws_neg, fill = TRUE, stringsAsFactors = F)
positiv <- read.table(sentiws_pos, fill = TRUE, stringsAsFactors = F)

sentiws <- bind_rows(negativ, positiv)
names(sentiws) <- c("stamm", "sentiment", "flektionen")

sentiws <- sentiws %>% 
  separate(stamm, into=c("word","art"), sep="\\|") %>%  # Split first column
  separate(flektionen, into=paste0("f",1:33 ), sep=",", fill="right" ) %>%            # Split flektions into individual columns (max. 33)
  gather(key, value, -art, -sentiment) %>%              # gather the columns 
  select(-key) %>%  # drop the key column
  arrange(-sentiment) %>% # for 
  filter(value!="") %>% 
  rename(word = value) %>% select(word, sentiment, art) %>% mutate(word = tolower(word)) %>% unique()


token_df <- selected %>% unnest_tokens(word, Body) 

ratings <- token_df %>% inner_join(sentiws) %>% group_by(ID_Post, ID_Article, ID_User) %>% summarise(sentiment = mean(sentiment)) %>% 
  ungroup() %>% 
  mutate(rating = round(sentiment * 2 + 3)) %>% select(user = ID_User, item = ID_Article, rating)


#ratings %>% count(user) %>% arrange(-n)

# empty rRM
entry <- data.frame(user = character(0L), item = character(0L), rating = numeric(0L), stringsAsFactors = F)
m <- entry %>% as("realRatingMatrix")


# as data_frame
entry <- data.frame(ratings, stringsAsFactors = F) %>% sample_n(10000, FALSE)
m <- entry %>% as("realRatingMatrix")

entry %>% count(item)


  m %>% as("data.frame") %>% write_feather(paste0("./ratings_comments.feather"))
  