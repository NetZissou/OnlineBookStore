library(tidyverse)
library(DBI)
library(RSQLite)
library(lubridate)

# ================================================================ #
# ------------------------- Data Schema --------------------------
# ================================================================ #
customer <- tibble(
  account_id = numeric(),
  name = character(),
  phone_number = numeric()
)

book <- tibble(
  ISBN = numeric(),
  category = character(),
  title = character(),
  price = numeric(),
  publisher_name = character(),
  publication_date = Date()
)

publisher <- tibble(
  name = character(),
  email = character(),
  phone = numeric(),
  address = character()
)

warehouse <- tibble(
  w_id = numeric(),
  city = character(),
  address = character(),
  phone_number = numeric()
)

shopping_cart <- tibble(
  user_id = numeric(),
  ISBN = numeric(),
  quantity = numeric(),
  price = numeric(),
  date = Date()
)

purchase_history <- tibble(
  user_id = numeric(),
  ISBN = numeric(),
  transaction_id = numeric(),
  quantity = numeric(),
  price = numeric(),
  date = Date()
)

storage <- tibble(
  ISBN = numeric(),
  w_id = numeric(),
  amount = numeric()
)

# ================================================================ #
# ------------------------- Pseudo Data --------------------------
# ================================================================ #

goodread_books <- read_csv("data/books.csv") %>%
  mutate(publication_date = mdy(publication_date)) %>%
  na.omit()

categories <- c(
  'Action and Adventure',
  'Classics',
  'Comic Book or Graphic Novel',
  'Detective and Mystery',
  'Fantasy',
  'Historical Fiction',
  'Horror',
  'Literary Fiction'
)

book <- goodread_books %>%
  mutate(
    price = ceiling(rnorm(nrow(goodread_books), mean = 75, sd = 30)),
    category = sample(categories, nrow(goodread_books), replace = T)
  ) %>%
  select(ISBN = isbn, category, title, price, 
         publisher_name = publisher, publication_date)


national_names <- read_csv("data/NationalNames.csv")

N_CUSTOMER = 1000
pseduo_id <- sample(
  ceiling(rnorm(10000, mean = 16000, sd = 1000)),
  size = N_CUSTOMER,
  replace = F
)
pseduo_name <- sample(
  national_names %>% distinct(Name) %>% pull(),
  size = N_CUSTOMER,
  replace = T
)
pseduo_phone <- sample(
  ceiling(rnorm(10000, mean = 18007678, sd = 800)),
  size = N_CUSTOMER,
  replace = F
)
customer <-   tibble(
    account_id = pseduo_id,
    name = pseduo_name,
    phone_number = pseduo_phone
  )

publisher <- tibble(
  name = book %>% distinct(publisher_name) %>% pull(),
  email = NA,
  phone = NA,
  address = NA
)

warehouse <- tibble(
  w_id = c(1, 2, 3, 4, 5),
  city = c("Columbus", "New York City", "Boston", "Columbus", "Miami"),
  address = NA,
  phone_number = NA
)

unique_book <- book %>% distinct(ISBN) %>% pull()
storage <- tibble(
  ISBN = unique_book,
  w_id = sample(c(1, 2, 3, 4, 5), length(unique_book), replace = T),
  amount = ceiling(rnorm(length(unique_book), mean = 60, 18))
)

N_PURCHASE_HISTORY <- 10
purchase_history <- tibble(
  user_id = c(17243, 17243, 17243, 16653, 14872, 14872, 14177, 14951, 16373, 13278),
  ISBN = sample(unique_book, N_PURCHASE_HISTORY, replace = F),
  datetime = ymd_hm(c(202103281010, 202103281010, 202103280810, 202103281010, 202103281111,
                      202103281305, 202103261705, 202103261608, 202103261505, 202103281050)),
  transaction_id = str_c(user_id, as.numeric(datetime)),
  quantity = ceiling(runif(10, 1, 10))
)

shopping_cart <- tibble(
  user_id = c(14872, 14872, 14177, 14951, 16373, 13278, 17243, 17243, 17243, 16653),
  ISBN = sample(unique_book, N_PURCHASE_HISTORY, replace = F),
  datetime = ymd_hm(c(202103281010, 202103281010, 202103280810, 202103281010, 202103281111,
                      202103281305, 202103261705, 202103261608, 202103261505, 202103281050)),
  quantity = ceiling(runif(10, 1, 10))
)

# ================================================================ #
# ------------------------- SQLite Setup -------------------------
# ================================================================ #

# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), "data/onlineBookStore.sqlite")
dbWriteTable(con, "CUSTOMER", customer, overwrite = TRUE)
dbWriteTable(con, "BOOK", book, overwrite = TRUE)
dbWriteTable(con, "PUBLISHER", publisher, overwrite = TRUE)
dbWriteTable(con, "WAREHOUSE", warehouse, overwrite = TRUE)
dbWriteTable(con, "SHOPPING_CART", shopping_cart, overwrite = TRUE)
dbWriteTable(con, "PURCHASE_HISTORY", purchase_history, overwrite = TRUE)
dbWriteTable(con, "STORAGE", storage, overwrite = TRUE)

# Disconnect from the database
dbDisconnect(con)






