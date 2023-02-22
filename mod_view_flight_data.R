view_flight_data_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "View the flight data",
    width = 12,
    DT::dataTableOutput(ns("flight_data"))
  )
}

view_flight_data_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$flight_data <- DT::renderDataTable({
      DT::datatable(data = flights,
                    options = list(scrollX = TRUE),
                    filter = "top")
    })
    
  })
}
    