message("Load the libraries")
library(mongolite)
library(tidyverse)
library(rvest)
library(janitor)

message("Define function to scrape OP character")
scrape_op_char <- function(char_url) {
  char_url %>%
    read_html() %>%
    {
      tibble(
        label = html_nodes(., ".pi-data-label") %>%
          html_text(),
        value = html_nodes(., ".pi-data-value") %>%
          html_text()
      )
    } %>%
    mutate(
      label = make_clean_names(label),
      label = recode(label,
                     japanese_name_2 = "devilfruit_jp_1",
                     english_name = "devilfruit_en_1",
                     meaning = "devilfruit_meaning_1",
                     type = "devilfruit_type_1",
                     japanese_name_3 = "devilfruit_jp_2",
                     english_name_2 = "devilfruit_en_2",
                     meaning_2 = "devilfruit_meaning_2",
                     type_2 = "devilfruit_type_2"
      ),
      value = str_remove_all(value, "\\[\\d+\\]")
    )
}

op_fandom_url <- "https://onepiece.fandom.com/wiki/List_of_Canon_Characters"

message("List all OP characters")
op_chars_list <-
  op_fandom_url %>%
  read_html() %>%
  html_elements(".wikitable") %>%
  html_table(fill = T, trim = T) 
op_chars_list <-
  op_chars_list %>%
  .[-length(op_chars_list)] %>%
  do.call('rbind',.) %>%
  as_tibble(.name_repair = make_clean_names) 

message("Get url for all of OP characters")
op_chars_urls_raw <-
  op_fandom_url %>%
  read_html() %>%
  html_elements(".wikitable > tbody > tr > td > a") %>%
  {
    tibble(
      name = html_attr(., "title"),
      url = str_c("https://onepiece.fandom.com", html_attr(., "href"))
    )
  }
op_chars_urls <-
  op_chars_list %>%
  left_join(op_chars_urls_raw, by="name") %>% 
  na.omit() 

message("Scrape all OP characters")
op_chars_raw <- map_dfr(op_chars_urls$url, scrape_op_char, .id = "id")

message("Prepare tidy dataset")
op_chars_urls <- 
  op_chars_urls %>%
  mutate(id = seq(nrow(op_chars_urls)))
op_chars_raw$id <- as.integer(op_chars_raw$id)
op_characters <-
  op_chars_raw %>%
  mutate(label = factor(label, levels = unique(label))) %>%
  spread(label, value) %>%
  mutate_all(~ na_if(.x, "N/A")) %>%
  unite("affiliations", matches("aff"), sep = ";") %>%
  mutate(affiliations = str_remove_all(affiliations, "(?:NA;NA|;NA)")) %>%
  mutate_all(~ na_if(.x, "")) %>%
  inner_join(op_chars_urls) %>%
  distinct(name, .keep_all = TRUE) %>%
  mutate(affiliations = str_remove_all(affiliations, "\\(.+\\)")) %>%
  # separate_rows(affiliations, sep = "(?:;|,)") %>%
  mutate_if(is.character, ~ str_trim(.x)) %>%
  select(name, debut_manga = chapter, debut_anime = episode, year, everything(), -debut) %>%
  select_if(~ mean(is.na(.x)) < 0.7)

message("Connect to MongoDB Cloud")
onepiece_conn <- mongo(collection=Sys.getenv("MONGO_CLOUD_COLLECTION"), 
                             db=Sys.getenv("MONGO_CLOUD_DB"), 
                             url=Sys.getenv("MONGO_CLOUD_URL"))

message("Store data frame into mongo cloud")
if(onepiece_conn$count() > 0)
  onepiece_conn$drop()
onepiece_conn$insert(op_characters)

rm(onepiece_conn)

