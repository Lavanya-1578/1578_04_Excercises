library(readxl)
SaleData <- read_excel("D:/Udemy_Learn/Takeaway Assignment - R _ Python/SaleData.xlsx")
View(SaleData)
dim(SaleData)
typeof(SaleData)
SaleData$year = as.numeric(format(as.Date(SaleData$OrderDate,'%Y/%m/%d'),'%Y'))
SaleData$current_date = Sys.Date()
head(SaleData$current_date)
str(SaleData)



library(dplyr)

#---1.Find least sales amount for each item-----
least_sales <- function(SaleData){
  a <- aggregate(SaleData$Sale_amt, by=list(SaleData$Item), FUN=min)
  colnames(a) <- c("Item","Sale_amnt")
  return(a)
  }
least_sales(SaleData)


#---2.compute total sales at each year X region-----
sales_year_region <- function(SaleData){
  a <- aggregate(SaleData$Sale_amt, by=list(SaleData$year,SaleData$Region,SaleData$Item)
                 , FUN=sum)
  colnames(a) <- c("year","Region","Item","Total_Sales")
  return(a)
}

sales_year_region(SaleData)


#--3.append column with no of days difference from present date to each order date--

days_diff <- function(SaleData){
  a <- data.frame(difftime(SaleData$current_date,as.Date(SaleData$OrderDate,format='%Y/%m/%d'),
                          units = "days"))
  colnames(a) <-c("days_diff")
  return(a)
}

days_diff(SaleData)

#----4.dataframe with manager and  salesman----

mgr_slsmn <- function(SaleData){
  a <- aggregate( SaleData$SalesMan , by = list( SaleData$Manager ) , 
                  function(x) paste0( (unique(x)) , collapse = "," ))
  colnames(a)<- c("Manager","list_of_salesmen")
  return(a)
}
mgr_slsmn(SaleData)



#--------5.For all regions find number of salesman and number of units--
slsmn_units <- function(SaleData){
  unique_Sales <- aggregate(SaleData$SalesMan, by = list(SaleData$Region),
                            function(x)(length(unique(x))))
  total_Sales <- aggregate(SaleData$Units,by = list(SaleData$Region),FUN=sum)
  a <- merge(total_Sales,unique_Sales,by=c("Group.1"))
  colnames(a)<-c("Region","total_units","salesmen_count")
  return(a)
}

slsmn_units(SaleData)

#----------6.Find total sales as percentage for each manager-----
sales_pct <- function(SaleData){
  df2 <- aggregate(SaleData$Sale_amt,by = list(SaleData$Manager),FUN=sum)
  a <- transform(df2, percent_sales = ave(df2$x,FUN = function(x) paste0(round(x/sum(x), 2)*100, "%")))
  colnames(a)<-c("Manager","total_Sales","percent_sales")
  return(a[,c("Manager","percent_sales")])
}

sales_pct(SaleData)

##########################################################################

imdb_data <- read_delim("D:/Udemy_Learn/Takeaway Assignment - R _ Python/imdb.csv", 
                        delim = ",", escape_backslash = TRUE,escape_double = FALSE)
dim(imdb_data)

#----7.get imdb rating for fifth movie of dataframe-------------
fifth_movie <- function(imdb_data){
  movie_set <- subset(imdb_data, type == "video.movie")
  a <- movie_set[5,"imdbRating"]
  return(a)
}
fifth_movie(imdb_data)


#----8.return titles of movies with shortest and longest run time-------------
movies <- function(imdb_data){
  movie_set <- subset(imdb_data, type == "video.movie")
  movie_min <- subset(movie_set, duration == min(movie_set$duration,na.rm = TRUE))
  movie_max <- subset(movie_set, duration == max(movie_set$duration,na.rm = TRUE))
  return(list(movie_min["title"],movie_max["title"]))
}
movies(imdb_data)

#---------9.sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
sort_df <- function(imdb_data){
  high_Rating <- imdb_data[order(imdb_data$year,-imdb_data$imdbRating),]
  return(high_Rating)
}
sort_df(imdb_data)


meta_data <- read.csv("D:/Udemy_Learn/Takeaway Assignment - R _ Python/movie_metadata.csv")
dim(meta_data)
#---------10.subset revenue more than 2 million and spent less than
# 1 million & duration between 30 mintues to 180 minutes-------#
subset_df <- function(meta_data){
  duration_range <- subset(meta_data, meta_data['duration'] >= 30 & meta_data['duration'] <= 180
                           & meta_data['gross'] > 20000000 & meta_data['budget']< 10000000)
  print(dim(duration_range))
  return(duration_range)
}
subset_df(meta_data)


####################################################################################

diamond_data = read.csv("D:/Udemy_Learn/Takeaway Assignment - R _ Python/diamonds.csv")
dim(diamond_data)
head(diamond_data)

#-----------11.count the duplicate rows of diamonds DataFrame.-----------
dupl_rows <- function(diamond_data){
  dup_count <- sum(duplicated(diamond_data))
  return(dup_count)
}
dupl_rows(diamond_data)


#----------12.droping those rows where any value in a row is missing in carat and cut columns----------------------------
drop_row <- function(diamond_data){
  omit_data<-diamond_data[!(is.na(diamond_data$carat) |diamond_data$carat== '' 
                  | is.na(diamond_data$cut)) | diamond_data$cut=="", ]
  return(omit_data)
}
drop_row(diamond_data)

#-----------13.subset only numeric columns---------
library(dplyr)
diamond_data$z<-as.integer(diamond_data$z)
diamond_data$carat<-as.integer(diamond_data$carat)

sub_numeric <- function(diamond_data){
  num_data<-select_if(diamond_data, is.numeric)
  return(num_data)
}
sub_numeric(diamond_data)


#-------14. compute volume as (x*y*z) when depth > 60 else 8------------
volume <- function(diamond_data){
  vol<-mutate(diamond_data,volume = ifelse(depth>60,x*y*z,8))
  return(vol)
}
volume(diamond_data)

#----------15. impute missing price values with mean-------------
impute <- function(diamond_data){
  average_missing <- data.frame(ifelse(is.na(diamond_data$price), 
                            mean(diamond_data$price, na.rm=TRUE), diamond_data$price))
  colnames(average_missing) <-c("price")
  return(average_missing)
}
impute(diamond_data)