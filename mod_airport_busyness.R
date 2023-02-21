
airport_busyness_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "Busyness of NY airports",
    plotOutput(ns("business_plot"))
  )
}

airport_busyness_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
  })
}