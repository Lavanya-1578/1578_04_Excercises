library(stringr)
library(dplyr)
library(readr)
imdb_data <- read_delim("D:/Udemy_Learn/Takeaway Assignment - R _ Python/imdb.csv", 
                        delim = ",", escape_backslash = TRUE,escape_double = FALSE)
dim(imdb_data)
imdb_data$len_of_movie <- str_length(imdb_data$title) 
str(imdb_data)

help(subset)

#---------------1.Genere combinations for each type year on year------------------------

find_combo <- function(imdb_data){
  df <- imdb_data %>% select('year','imdbRating','duration','Action', 'Adult', 'Adventure', 'Animation', 'Biography',
                            'Comedy', 'Crime', 'Documentary', 'Drama', 'Family', 'Fantasy',
                            'FilmNoir', 'GameShow', 'History', 'Horror', 'Music', 'Musical',
                            'Mystery', 'News', 'RealityTV', 'Romance', 'SciFi', 'Short', 'Sport',
                            'TalkShow', 'Thriller', 'War', 'Western')
  df[["duration"]][is.na(df[["duration"]])] <- 0
  df$genre_combo <- apply(df,1,function(x) paste0((colnames(df)[which(x==1)]),collapse=","))
  x <- df %>% group_by(year,genre_combo) %>% 
    summarize(avg_rating = mean(imdbRating), 
              min_rating = min(imdbRating),max_rating = max(imdbRating),
              total_run_time_mins = sum(duration))
  return(x)
}
find_combo(imdb_data)


######----------2.trend of the number of letters in movies titles over years-------------------------------------#########
library(descr)
library(dplyr)

genre_report <- function(df){
  report <- select(imdb_data,year,len_of_movie)
  plot(report$year,report$len_of_movie,col="blue")
  report1 <-  filter(imdb_data,type =='video.movie')
  print(dim(report1))
  score = quantile(report1$len_of_movie)
  print(score)
  df2 <- aggregate(report1$year,report1$len_of_movie,FUNcount)
  d = table(score,report1$year,report1$len_of_movie,data=report1,type="count")
  print(d)
  x <- report1 %>% group_by(year) %>% 
    summarize(min_length = min(len_of_movie), 
              max_length = max(len_of_movie),
              num_videos_less_than25Percentile=quantile(len_of_movie, probs = c(0.25)),
              num_videos_25_50Percentile = quantile(len_of_movie, probs = c(0.50)),
              num_videos_50_75Percentile = quantile(len_of_movie, probs = c(0.75)),
              num_videos_greaterthan75Precentile = quantile(len_of_movie, probs = c(1.00)))
  return(x)
}
genre_report(df)


##########------------------3.Represent the bins as a percentage of total-------------------------------------#############

diamond_data = read.csv("D:/Udemy_Learn/Takeaway Assignment - R _ Python/diamonds.csv")
dim(diamond_data)
head(diamond_data)
diamond_data[is.na(diamond_data)] <- 0


# Resulting bins have an equal number of observations in each group
volume <- function(diamond_data){
  vol<-mutate(diamond_data,volume = ifelse(depth>60,x*y*z,8))
  print(dim(vol))
  vol <- vol %>% mutate(bins = ntile(volume, 5))
  prop <- with(vol, table(vol$bins,vol$cut)) %>% prop.table()
  perc <- round(100*prop.table(prop),digits=3)
  #print(prop[,-1])
  return(perc[,-1])
}
volume(diamond_data)

########-----------4.number of top performing movies under each genere-----------------------------############
meta_data <- read.csv("D:/Udemy_Learn/Takeaway Assignment - R _ Python/movie_metadata.csv")
dim(meta_data)
colnames(meta_data)


high_gross <- function(meta_data){
    sort <- meta_data[order(meta_data$title_year,-meta_data$gross),]
    top_gross <- sort %>% group_by(sort$title_year)
    select(top_gross,title_year,gross)
    print(head(select(sort,title_year,gross)))
    top_10_gross <- sort %>% group_by(title_year,genres) %>%
      summarise(meanTop10rating = mean(imdb_score[imdb_score>=quantile(imdb_score, 0.9)]))  %>% 
      arrange(desc(title_year)) %>% top_n(10,title_year)
  return(top)
}
high_gross(meta_data)


###--------------------5.Top 3 geners of deciles using the duration-------------------------------------------
library(readr)
imdb_data <- read_delim("D:/Udemy_Learn/Takeaway Assignment - R _ Python/imdb.csv", 
                        delim = ",", escape_backslash = TRUE,escape_double = FALSE)
dim(imdb_data)


decile_movie <- function(imdb_data){
  df <- imdb_data %>% select('year','type','imdbRating','duration','Action', 'Adult', 'Adventure', 'Animation', 'Biography',
                             'Comedy', 'Crime', 'Documentary', 'Drama', 'Family', 'Fantasy',
                             'FilmNoir', 'GameShow', 'History', 'Horror', 'Music', 'Musical',
                             'Mystery', 'News', 'RealityTV', 'Romance', 'SciFi', 'Short', 'Sport',
                             'TalkShow', 'Thriller', 'War', 'Western')
  df[["duration"]][is.na(df[["duration"]])] <- 0
  df$genre_combo <- apply(df,1,function(x) paste0((colnames(df)[which(x==1)]),collapse=","))
  df$nrOfNominations= imdb_data$nrOfNominations
  df$nrOfWins= imdb_data$nrOfWins
  subset <-  filter(df,type =='video.movie')
  subset <- subset %>%
    mutate(quant = ntile(subset$duration, 10))
  #write.csv(subset,"D:/Udemy_Learn/Takeaway Assignment - R _ Python/rdecile.csv")
  #print(dim(subset))
  top_values <- subset %>% group_by(quant,genre_combo) %>% 
    summarize(nrOfNominations = sum(nrOfNominations), avg= n(),
              nrOfWins = sum(nrOfWins))  %>% arrange(quant,desc(avg)) %>% 
    top_n(n=3,wt=avg)
  return(top_values)
}
decile_movie(imdb_data)


##########-----------6.Insights from movie metadata set and the imdb data set-----------------------------------------
library(readr)
library(dplyr)
library(tidyr)
library(viridis)
library(ggcorrplot)
imdb_data <- read_delim("D:/Udemy_Learn/Takeaway Assignment - R _ Python/imdb.csv", 
                        delim = ",", escape_backslash = TRUE,escape_double = FALSE)
movie_data <- read.csv("D:/Udemy_Learn/Takeaway Assignment - R _ Python/movie_metadata.csv")
#substr(movie_data$url, 1, regexpr("\\?", movie_data$url)-1)
#sub("\\?ref_=fn_tt_tt_1","", movie_data$movie_imdb_link)


movie_data$url <- lapply(movie_data$movie_imdb_link, gsub, pattern = "?ref_=fn_tt_tt_1", replacement = "", fixed = TRUE)

#Merging both imdb and movie dataset
df <- merge(imdb_data,movie_data,by="url")
dim(df)
df$budget <- df$budget/1000000
df$revenue <- df$gross/1000000
#Budget vs revenue
ggplot(df,
       aes(x=budget,y=revenue)) + geom_point() + geom_smooth(se=FALSE) + 
  labs(title='Revenue vs. budget',x='budget',y='revenue')

#Runtime vs revenue
ggplot(data=df,aes(x=duration.x,y=revenue))+
  geom_point(alpha=0.5,color= 'blue') + scale_fill_viridis(discrete=F)+ 
  geom_smooth(color='red',se=FALSE) + 
  labs(title='Revenue vs. Runtime',x='runtime',y='revenue')

#Top 20 costliest movies
movies.cost <- df[order(-df$budget),] %>% head(n=20)
ggplot(movies.cost,aes(x=reorder(title,budget),y=budget)) +
  geom_point(size=2, alpha=0.6,color="blue") + 
  geom_segment(aes(x=title,xend=title,y=min(budget),yend=max(budget)),
               linetype="dashed",size=0.2)+
  labs(title="Top 20 costliest movies",
       y="budget",x="movie title")+ coord_flip()

#Top 20 grossing movies by revenue
movies.rev <- df[order(-df$revenue),] %>% head(n=20)
ggplot(movies.rev, aes(x=reorder(movie_title,revenue), y=revenue)) +
  geom_bar(stat="identity", width=.5,fill="tomato3") + 
  labs(title="Top 20 grossing movies",y="revenue",
       x="movie title")+coord_flip()

####country Vs budget
country_summary <- df %>%
  subset(country != "") %>%
  subset(country != "New Line") %>%
  group_by(country) %>%
  summarise(count=n(),
            avg_score=mean(imdb_score,na.rm="true"),
            avg_budget = mean(budget,na.rm="true"),
            avg_gross = mean(gross,na.rm="true"))
country_with_multiple_movies <- subset(country_summary,count>1)[1]
ggplot(country_summary[complete.cases(country_summary), ],
       aes(x=reorder(country,-avg_budget),avg_budget/1000000))+
  geom_bar(stat = "identity")+
  theme(axis.text.x=element_text(angle=45, hjust=1))+
  ylab("Average Movie Budget")+
  xlab("")+
  ggtitle("Average Movie Budget by Country")