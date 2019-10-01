# Debugging file 
if(FALSE) {
  
  for (i in 1:length(articles$ID_Article)) {
    m <- m %>% add_rating("DEMO",
                          as.character(articles[i,1]),
                          0)
  }
  
  store_user_ratings(m)
  getRatingMatrix(m)
  
  rec <- Recommender(m, method = "SVD")
  names(getModel(rec))
  
  
  recom <- predict(rec, m["u3", ], n = 3)
  
  recs <- as(recom, "list")
  
  article_id <- recs[[1]] %>% as.numeric()
  
  #get first recommendation
  articles %>% filter(ID_Article %in% article_id)
  
  
  bm <- microbenchmark(write = {
    store_user_ratings(m)
  },
  read = {
    m <- read_user_ratings()
  })
  autoplot(bm)
  
  
  HybridRecommender(
    Recommender(m, method = "POPULAR"),
    Recommender(m, method = "RANDOM"),
    Recommender(m, method = "RERECOMMEND"),
    weights = c(.6, .1, .3)
  )
  dimnames(Bs) = list(rows,columns)
  
  dimnames(m)
  M <- matrix(rep(0,10), nrow = 1, ncol = 10)
}

