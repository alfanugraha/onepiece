message("Load the libraries")
# Set library ----
library(jsonlite)
library(RPostgreSQL)

# List of shalat sites
# https://www.islamicfinder.org/world/indonesia/
# https://aladhan.com/prayer-times-api

message("Get prayers timing from Aladhan API")
ind_city <- "Kota Padang"
ind_country <- "Indonesia"

city <- URLencode(ind_city)
country <- URLencode(ind_country)
method <- 8

url <- paste0("http://api.aladhan.com/v1/timingsByCity?city=", city, "&country=", country, "&method=", method)
get_timings <- fromJSON(url)

message("Connect to ElephantSQL database server")
# connect to database
con <- dbConnect(
  dbDriver("PostgreSQL"),
  dbname = Sys.getenv("ELEPHANT_SQL_DBNAME"),
  host = Sys.getenv("ELEPHANT_SQL_HOST"),
  port = 5432,
  user = Sys.getenv("ELEPHANT_SQL_USER"),
  password = Sys.getenv("ELEPHANT_SQL_PASSWORD")
)

message("Checking table `public`.`prayer` if exists")
# check table if exists
if(!dbExistsTable(con, "prayer")) {
  prayer <- data.frame(no=integer(), date=character(), city=character(), lat=character(), lng=character(), imsak=character(),
                       fajr=character(), dhuhr=character(), asr=character(), maghrib= character(), isha=character())
  dbCreateTable(con, "prayer", prayer)
} 

message("Retrieve the information from table `public`.`prayer`")
# read table
prayer <- dbReadTable(con, "prayer")
rows <- nrow(prayer)

# new input
message("Initiate all attribute")
date <- get_timings$data$date$gregorian$date
lat <- get_timings$data$meta$latitude
lng <- get_timings$data$meta$longitude
imsak<-get_timings$data$timings$Imsak
fajr <- get_timings$data$timings$Fajr
dhuhr <- get_timings$data$timings$Dhuhr
asr <- get_timings$data$timings$Asr
maghrib <- get_timings$data$timings$Maghrib
isha <- get_timings$data$timings$Isha
newprayer <- data.frame(no = rows + 1, date=date, city=ind_city, lat=lat, lng=lng, imsak=imsak,
                        fajr=fajr, dhuhr=dhuhr, asr=asr, maghrib=maghrib, isha=isha)

message("Insert new data to table `public`.`prayer`")
dbWriteTable(con = con, name = "prayer", value = newprayer, append = TRUE, row.names = FALSE, overwrite=FALSE)

message("Disconnect the database, see you again")
on.exit(dbDisconnect(con)) 


