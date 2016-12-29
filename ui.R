library(shiny)
library(shinythemes)
library(DT)

shinyUI(
  fluidPage(
    theme = shinytheme("cosmo"),
    titlePanel("AQI forecast"),
    sidebarLayout(
      sidebarPanel(
        
        # Add record #
        div(style = "margin-top: 2px; margin-bottom: 12px; font-weight: 700; font-size: 22px;", "Add record"),
        wellPanel(
          dateInput("f_date", "Today's date", width = 140),
          selectInput("city", "City ", choices = city_list),
          textInput("f_values", "Forecast values", value = "50, 50, 50, 50, 50, 50", width = 180),
          textInput("description", "Description", value = "Today, "),
          actionButton("submit", "Submit", class = "btn-primary")
          ),
        
        br(),
        
        # Delete record #
        div(style = "margin-top: -15px; margin-bottom: 12px; font-weight: 700; font-size: 22px;", "Delete record"),
        wellPanel(
          fluidRow(
            column(4, dateInput("d_date", "Date", width = 140)),
            column(7, selectInput("d_city", "City",choices = city_list))
          ),
          actionButton("delete", "Delete", class = "btn-warning")
        ),
        
        #actionButton("reset", "reset", class = "btn-primary"),
        h6("Browse the data on ", a("Google sheets", href = ss$browser_url, target="_blank")),
        h6("View the Code on ", a("Github", href="https://github.com/dKvale/forecast_submit", target="_blank"))
      ),
      
      mainPanel(
        div(style = "margin-top: -22px;", h3("Recorded forecasts")),
        br(),
        div(style = "margin-top: -12px;",dataTableOutput("table"))
      )
    )
  ))