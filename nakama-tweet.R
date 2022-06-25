message("Load the collections and rtweet library")
library(mongolite)
library(rtweet)

message("Retrieve random character")
onepiece_conn <- mongo(collection=Sys.getenv("MONGO_CLOUD_COLLECTION"), 
                             db=Sys.getenv("MONGO_CLOUD_DB"), 
                             url=Sys.getenv("MONGO_CLOUD_URL"))
selected_fig <- onepiece_conn$aggregate('[{ "$sample": { "size": 1 } }]')

message("Set status and random hash tag")
## Hash Tag
hashtag <- c("MDS","MongoDB","rtweet","bot","OnePiece", "nakama", "Fandom", "Anime", "Manga", "rvest", "scraping", "japanese")
samp_word <- sample(hashtag, 3)

if(nrow(selected_fig) > 0){
  ## Status Message
  status_details <- paste0(
    "🈁 Halo Para Nakama! Karakter One Piece kali ini adalah\n", 
    "Nama: ", selected_fig$name, "\n",
    "Nama Jepang: ", selected_fig$japanese_name, "\n",
    "Afiliasi: ", selected_fig$affiliations, "\n",
    "Peran: ", selected_fig$occupations, "\n",
    "Tahun Debut: ", selected_fig$year, " pada edisi Manga ke-", selected_fig$debut_manga, " dan Anime ke-", selected_fig$debut_anime, "\n",
    "\n", selected_fig$url, "\n",
    paste0("#", samp_word, collapse = " "))
  
  ## Create Twitter token
  token <- create_token(
    app = Sys.getenv("TWITTER_APPS"),
    consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
    consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
    access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
    access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
  )
  
  message("Post the status to twitter")
  ## Post the status to Twitter
  post_tweet(
    status = status_details,
    token = token
  )
}
