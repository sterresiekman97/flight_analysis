
flights_from_NY_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "Destinations of passengers flying out from New York airports",
    shinyWidgets::awesomeCheckbox(
      ns("show_n_passengers"),
      label = "Show the number of passengers as circle size.",
      value = TRUE
    ),
    plotly::plotlyOutput(ns("flights_map_plot"))
  )
}

flights_from_NY_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    world_map <- ggplot2::map_data("world")
    
    flights_with_coordinates <- reactive({
      seats_per_plane <- planes %>% 
        dplyr::select(tailnum, seats)
      airport_coordinates <- airports[ , c("faa", "lat", "lon", "name")]
      
      flights_with_coordinates <- dplyr::left_join(flights,
                                                   seats_per_plane) %>% 
        group_by(origin, dest) %>% 
        summarise(n_people = sum(seats, na.rm = TRUE)) %>% 
        dplyr::left_join(.,
                         airport_coordinates,
                         by = c("origin" = "faa")) %>% 
        dplyr::left_join(.,
                         airport_coordinates,
                         by = c("dest" = "faa"),
                         suffix = c("_origin", "_dest"))
      return(flights_with_coordinates)
    })
    
    map_with_flights <- reactive({
      req(flights_with_coordinates())
      
      if (input$show_n_passengers) {
        ggplot2::ggplot(world_map) +
          ggplot2::geom_polygon(ggplot2::aes(x = long, 
                                             y = lat, 
                                             group = group), 
                                fill = "lightgrey", 
                                color = "white") +
          ggplot2::geom_point(ggplot2::aes(x = lon_dest, 
                                           y = lat_dest,
                                           color = origin,
                                           size = n_people,
                                           alpha = 0.3,
                                           text = paste0(
                                             "Destination: ",
                                             name_dest,
                                             "\nOrigin: ",
                                             name_origin,
                                             "\nNumber of passengers: ",
                                             n_people
                                           )), 
                              data = flights_with_coordinates()) +
          ggplot2::geom_point(ggplot2::aes(x = lon_origin,
                                           y = lat_origin,
                                           color = origin,
                                           text = paste0(
                                             "New York airport: ",
                                             name_origin
                                           )),
                              data = flights_with_coordinates(),
                              shape = "square") +
          ggplot2::theme_void() +
          ggplot2::theme(legend.position = "none") +
          ggplot2::coord_cartesian(xlim = c(-180, -50), ylim = c(0, 80))
      } else {
        ggplot2::ggplot(world_map) +
          ggplot2::geom_polygon(ggplot2::aes(x = long, 
                                             y = lat, 
                                             group = group), 
                                fill = "lightgrey", 
                                color = "white") +
          ggplot2::geom_point(ggplot2::aes(x = lon_dest, 
                                           y = lat_dest,
                                           color = origin,
                                           text = paste0(
                                             "Destination: ",
                                             name_dest,
                                             "\nOrigin: ",
                                             name_origin
                                           )),
                              size = 0.8,
                              data = flights_with_coordinates()) +
          ggplot2::geom_point(ggplot2::aes(x = lon_origin,
                                           y = lat_origin,
                                           color = origin,
                                           text = paste0(
                                             "New York airport: ",
                                             name_origin
                                           )),
                              data = flights_with_coordinates(),
                              shape = "square") +
          ggplot2::theme_void() +
          ggplot2::theme(legend.position = "none") +
          ggplot2::coord_cartesian(xlim = c(-180, -50), ylim = c(0, 80))
      }
      
    })
    
    output$flights_map_plot <- plotly::renderPlotly({
      req(map_with_flights())
      plotly::ggplotly(map_with_flights(), 
                       tooltip = "text")
    })
    
    outputOptions(output, 
                  "flights_map_plot",
                  priority = 1)
    
  })
}