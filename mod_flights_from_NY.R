
flights_from_NY_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "Flights from New York",
    plotly::plotlyOutput(ns("flights_map_plot"))
  )
}

flights_from_NY_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
  })
}