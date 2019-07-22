## 

library(tidyverse)
library(RSQLite)
library(rvest)
library(lubridate)

con <- dbConnect(RSQLite::SQLite(), "corpus.sqlite3")

dbListTables(con)


articles <- dbReadTable(con, "Articles")

strip_html <- function(x) {
  html_text(read_html(x)) %>% 
    str_replace_all("\\n", " ") %>% 
    str_replace_all("\\t", "") %>% 
    str_replace_all("\\\"", "\"")
}

get_h2_header <- function(x){
  x %>% read_html() %>% html_nodes("h2") %>% html_text() %>% paste(collapse = " ")
}

get_p_elems <- function(x, count = 5){
  x %>% read_html() %>% html_nodes("p") %>% html_text() %>% head(count) %>% paste(collapse = " ")
}

cleanarticles <- articles %>% 
  mutate(has_javascript = str_match(Body, "text/javascript") ) %>% 
  filter(is.na(has_javascript)) %>%  as_tibble() %>% 
  filter(!str_detect(Path, "Community")) %>% 
  filter(!str_detect(Path, "Diverses")) %>% 
  mutate(publishingDate = ymd_hms(publishingDate) %>% 
         lubridate::as_date() %>% 
           format("%d. %b %Y")) %>% 
  rowwise() %>% 
  mutate(subheading = get_h2_header(Body)) %>% 
  mutate(cleanbody = strip_html(Body)) 


# Debug get all Types
cleanarticles %>% mutate(path2 = factor(Path)) %>% count(path2) %>% arrange(-n) %>% View()


x <- runif(1,1,1000)
example <- cleanarticles[x,]

example$Title
example$Body %>% get_h2_header()
example$Body %>% get_p_elems(2)

example$Path
example$publishingDate 
example$ID_Article
