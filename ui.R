
library(shiny)
library(bs4Dash)

shiny::shinyUI(
    bs4Dash::dashboardPage(
        header = bs4Dash::dashboardHeader(
            title = "Take flight"
        ),
        sidebar = bs4Dash::dashboardSidebar(),
        body = bs4Dash::dashboardBody(
            
        ),
        controlbar = bs4Dash::dashboardControlbar(),
        title = "Take flight"
    )
)
