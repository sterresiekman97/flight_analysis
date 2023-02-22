
library(shiny)
library(bs4Dash)

source("utils.R")
source("mod_airport_busyness.R")
source("mod_flights_from_NY.R")
source("mod_view_flight_data.R")
source("mod_model.R")

shiny::shinyUI(
    bs4Dash::dashboardPage(
        header = bs4Dash::dashboardHeader(
            title = "Take flight"
        ),
        sidebar = bs4Dash::dashboardSidebar(
            bs4Dash::sidebarMenu(
                bs4Dash::menuItem(
                    "Flight departures from New York",
                    tabName = "flights_info"
                ),
                bs4Dash::menuItem(
                    "Analysis of delays",
                    tabName = "delays"
                ),
                bs4Dash::menuItem(
                    "View the flights data",
                    tabName = "view_data"
                )
            )
        ),
        body = bs4Dash::dashboardBody(
            bs4Dash::tabItems(
                bs4Dash::tabItem(
                    tabName = "flights_info",
                    fluidRow(
                        airport_busyness_ui(id = "airport_busyness_1"),
                        flights_from_NY_ui(id = "flights_from_NY_1")
                    )
                ),
                bs4Dash::tabItem(
                    tabName = "delays",
                    fluidRow(
                        model_ui(id = "model_1")  
                    )
                ),
                bs4Dash::tabItem(
                    tabName = "view_data",
                    fluidRow(
                        view_flight_data_ui(id = "view_flight_data_1")
                    )
                )
            )
        ),
        controlbar = bs4Dash::dashboardControlbar(),
        title = "Take flight"
    )
)
