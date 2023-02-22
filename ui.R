
library(shiny)
library(bs4Dash)

source("mod_airport_busyness.R")
source("mod_flights_from_NY.R")
source("mod_view_flight_data.R")
source("mod_model.R")

shiny::shinyUI(
    bs4Dash::dashboardPage(
        header = bs4Dash::dashboardHeader(
            title = "Take flight"
        ),
        sidebar = bs4Dash::dashboardSidebar(),
        body = bs4Dash::dashboardBody(
            fluidRow(
                airport_busyness_ui(id = "airport_busyness_1"),
                flights_from_NY_ui(id = "flights_from_NY_1")
            ),
            fluidRow(
              model_ui(id = "model_1")  
            ),
            fluidRow(
                view_flight_data_ui(id = "view_flight_data_1")
            )
        ),
        controlbar = bs4Dash::dashboardControlbar(),
        title = "Take flight"
    )
)
