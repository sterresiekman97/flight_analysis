
airport_busyness_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "Busyness of New York airports throughout the year",
    plotly::plotlyOutput(ns("busyness_plot"))
  )
}

airport_busyness_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    airports <- nycflights13::airports
    flights <- nycflights13::flights
    
    for_plot <- reactive({
      seats_per_plane <- nycflights13::planes %>% 
        dplyr::select(tailnum, seats)
      
      NY_airports <- unique(flights$origin)
      NY_airport_names <- airports[airports$faa %in% NY_airports, c("faa", "name")]
      timezone_NY <- unique(airports$tzone[airports$faa %in% NY_airports])
      
      busyness <- dplyr::left_join(flights,
                                   seats_per_plane,
                                   by = "tailnum") %>% 
        dplyr::left_join(.,
                         NY_airport_names,
                         by = c("origin" = "faa")) %>% 
        dplyr::mutate(departure_date = as.Date(time_hour, tz = timezone_NY)) %>% 
        dplyr::group_by(name,
                        departure_date) %>% 
        dplyr::summarise(n = sum(seats,
                                 na.rm = TRUE))
      
      return(busyness)
    })
    
    busyness_plot <- reactive({
      req(for_plot())
      
      plot <- ggplot2::ggplot(for_plot(),
                              ggplot2::aes(x = departure_date, 
                                           y = n,
                                           color = name,
                                           text = paste0(
                                             "Number of people: ",
                                             n,
                                             "\nDeparture date: ",
                                             departure_date,
                                             "\nAirport: ",
                                             name
                                           ),
                                           group = 1 # to avoid text aesthetic 
                                           # causing an error
                                           )) +
        ggplot2::geom_line() +
        ggplot2::scale_color_discrete(name = "Airport") +
        ggplot2::theme_bw() +
        ggplot2::ylab("Number of departing passengers") +
        ggplot2::xlab("Date of departure")
    })
    
    output$busyness_plot <- plotly::renderPlotly({
      req(busyness_plot())
      plotly::ggplotly(busyness_plot(),
                       tooltip = "text")
    })
    
    outputOptions(output, 
                  "busyness_plot",
                  priority = 2)
    
  })
}