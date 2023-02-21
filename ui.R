
library(shiny)
library(bs4Dash)

source("mod_airport_business.R")

shiny::shinyUI(
    bs4Dash::dashboardPage(
        header = bs4Dash::dashboardHeader(
            title = "Take flight"
        ),
        sidebar = bs4Dash::dashboardSidebar(),
        body = bs4Dash::dashboardBody(
            airport_busyness_ui(id = "airport_busyness_1")
        ),
        controlbar = bs4Dash::dashboardControlbar(),
        title = "Take flight"
    )
)
