# library(rsconnect)
# deployApp()


city_list <- c("Minneapolis - St. Paul",
               "Northern Metro",
               "Southern Metro",
               "Brainerd",
               "Bemidji",
               "Detroit Lakes",
               "Duluth",
               "Ely",
               "Fargo - Moorhead",
               "Fond du Lac - Cloquet",
               "Grand Forks",
               "Grand Portage",
               "Hibbing",
               "International Falls",
               "Mankato",
               "Marshall",
               "Red Lake Nation",
               "Rochester",
               "Saint Cloud")

## prepare the OAuth token and set up the target sheet:
##  - do this interactively
##  - do this EXACTLY ONCE

#library(googlesheets)
#shiny_token <- gs_auth() # authenticate w/ your desired Google identity here
#saveRDS(shiny_token, "shiny_app_token.rds")

## if you version control your app, don't forget to ignore the token file!
## e.g., put it into .gitignore
#sheets <- gs_ls()
#ss <- gs_title("forecast_table.csv")
googlesheets::gs_auth(token = "shiny_app_token.rds")

#ss <- googlesheets::gs_title("forecast_table")
#gs_delete(ss)
#gs_ls()

# Default table  ----------------------------#
#base_tbl <- tibble(date  = "2011-01-01", 
#                   city  = "Minneapolis - St. Paul",
#                   today = 0,
#                   day1 = 0,
#                   day2 = 0,
#                   day3 = 0,
#                   day4 = 0,
#                   day5 = 0,
#                   description = "Today, there will be no wind. We are terribly sorry.")

#write.csv(base_tbl, "forecast_table.csv", row.names = F)

# Load base table  ----------------------------#
#gs_upload("forecast_table.csv")

ss <- googlesheets::gs_title("forecast_table")
#gs_edit_cells(ss, input = "2011-01-01", anchor = "A2")

reset_content <- googlesheets::gs_read(ss, col_types = paste0(rep("c", 9), collapse = ""))

#write.csv(reset_content, "reset_content.csv", row.names = F)