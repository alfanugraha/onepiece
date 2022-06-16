message("Load the RPostgreSQL and rtweet library update")
library(RPostgreSQL)
library(rtweet)

message("Set timezone")
Sys.setenv(TZ = "Asia/Bangkok")

message("Connect to ElephantSQL database server")
con <- dbConnect(
  dbDriver("PostgreSQL"),
  dbname = Sys.getenv("ELEPHANT_SQL_DBNAME"),
  host = Sys.getenv("ELEPHANT_SQL_HOST"),
  port = 5432,
  user = Sys.getenv("ELEPHANT_SQL_USER"),
  password = Sys.getenv("ELEPHANT_SQL_PASSWORD")
)

message("Retrieve the information from table `public`.`prayer`")
prayer <- dbReadTable(con, "prayer")

today <- format(Sys.time(), "%d-%m-%Y")
tweetprayer <- prayer[which(today==prayer$date),]

message("Checking the availability of new prayers time ")
if(nrow(tweetprayer) != 0){
  hour <- strptime(format(Sys.time(), format = "%R"),
                   format = "%H:%M",
                   tz="Asia/Jakarta")
  all_time <- strptime(unlist(tweetprayer[, 6:11]), 
                       format = "%H:%M",
                       tz="Asia/Jakarta")
  
  message("Checking the time difference")
  # calculate time difference
  hourdiff <- which.min( abs(difftime(hour, all_time, units = "hours")) )
  
  message("Set status and random hash tag")
  ## 1st Hash Tag
  hashtag <- c("MDS","jsonlite","rtweet", "ElephantSQL","bot","prayers","RPostgreSQL", "sholat")
  samp_word <- sample(hashtag, 3)
  
  ## Status Message
  status_details <- paste0(
    "🕌 Akan tiba waktu ", names(hourdiff), " untuk ", tweetprayer$city, " dan sekitarnya pada pukul ", format(all_time[names(hourdiff)], format="%R"), "\n",
    "\n\n",
    paste0("#", samp_word, collapse = " "))
  
  ## Create Twitter token
  token <- create_token(
    app = "Sholat-Bot",
    consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
    consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
    access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
    access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
  )
  
  message("Post the status to twitter")
  ## Post the image to Twitter
  post_tweet(
    status = status_details,
    token = token
  )
  if(names(hourdiff)=="imsak"){
    status_details_fajr <- paste0(
      "🕌 Akan tiba waktu subuh untuk ", tweetprayer$city, " dan sekitarnya pada pukul ", format(all_time['fajr'], format="%R"), "\n",
      "\n\n",
      paste0("#", samp_word, collapse = " "))
    post_tweet(
      status = status_details_fajr,
      token = token
    )
  }
} 

message("Disconnect the database")
on.exit(dbDisconnect(con))
