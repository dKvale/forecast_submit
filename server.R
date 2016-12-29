library(shiny)
library(googlesheets)
library(DT)

shinyServer(function(input, output, session) {
  
  observeEvent(input$reset,
    {
     googlesheets::gs_auth(token = "shiny_app_token.rds")
     ss <- gs_title("forecast_table")
     gs_delete(ss)
      
     #s_name <- gsub(" |[:]", "_", as.character(Sys.time()))
     #gs_upload(paste0(s_name, ".csv"), "forecast_table")
     
     googlesheets::gs_auth(token = "shiny_app_token.rds")
     gs_new("forecast_table", input = reset_content)
     
     #googlesheets::gs_auth(token = "shiny_app_token.rds")
     #gs_upload("reset_content.csv", "forecast_table")
     #gs_new(s_name, input = reset_content)
     
    }
  )
  
  observeEvent(input$delete,
               { 
                 googlesheets::gs_auth(token = "shiny_app_token.rds")
                 ss <- gs_title("forecast_table")
                 new_tbl <- gs_read(ss)
                 
                 new_tbl <- subset(new_tbl, (date != input$d_date) | (city != input$d_city))
                 
                 googlesheets::gs_auth(token = "shiny_app_token.rds")
                 gs_delete(ss)
                 
                 googlesheets::gs_auth(token = "shiny_app_token.rds")
                 gs_new("forecast_table", input = new_tbl)
                 
               }
  )
  
  observeEvent(input$submit, {
    ss <- gs_title("forecast_table")
    gs_add_row(ss, 
               input = c(as.character(input$f_date),
                         input$city[[1]],
                         trimws(strsplit(input$f_values, ",")[[1]]), 
                         input$description[[1]]
                         )
               )
    })
  
  the_data <- eventReactive({input$submit | input$delete},
                            { googlesheets::gs_auth(token = "shiny_app_token.rds")
                              ss <- gs_title("forecast_table")
                              forecast_tbl <- gs_read(ss)
                              forecast_tbl[order(forecast_tbl$date, forecast_tbl$city), ]},
                            ignoreNULL = FALSE)
                            
  
  output$table <- DT::renderDataTable({
       #aqi_cats  <- cut(as.numeric(unlist(the_data()[ , 3:8])), breaks = c(0,50,100,150,200,1000), labels = c("#9BF59B", "#ffff00", "#ff7e00", "#ff0000", "#99004c"))
         
       data <- datatable(the_data(), rownames = FALSE, options = list(searching=F, paging=F, scrollX=T))
               
       data <- formatStyle(data, 
                           c('today','day1','day2','day3','day4','day5'),
                           fontWeight = styleInterval(c(50), c("normal","bold")),
                           backgroundColor =  styleInterval(c(0,50,100,150,200), c("#FFF","#9BF59B", "#ffff00", "#ff7e00", "#ff0000", "#99004c"))) #syleInterval(aqi_cats, aqi_colors))
       
  })
                                    
                                                                                            
  
})