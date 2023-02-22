
flights_from_NY_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "Flights from New York",
    plotly::plotlyOutput(ns("flights_map_plot"))
  )
}

flights_from_NY_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    world_map <- ggplot2::map_data("world")
    
    unique_flights <- reactive({
      airport_coordinates <- airports[ , c("faa", "lat", "lon", "name")]
      
      unique_flights <- flights %>% 
        dplyr::distinct(origin, dest) %>% 
        dplyr::left_join(.,
                         airport_coordinates,
                         by = c("origin" = "faa")) %>% 
        dplyr::left_join(.,
                         airport_coordinates,
                         by = c("dest" = "faa"),
                         suffix = c("_origin", "_dest"))
      return(unique_flights)
    })
    
    map_with_flights <- reactive({
      req(unique_flights)
      
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
                            data = unique_flights()) +
        ggplot2::geom_point(ggplot2::aes(x = lon_origin,
                                         y = lat_origin,
                                         color = origin,
                                         text = paste0(
                                           "New York airport: ",
                                           name_origin
                                         )),
                            data = unique_flights(),
                            shape = "square") +
        ggplot2::theme_void() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::coord_cartesian(xlim = c(-180, -50), ylim = c(0, 80))
    })
    
    output$flights_map_plot <- plotly::renderPlotly({
      req(map_with_flights())
      plotly::ggplotly(map_with_flights(), 
                       tooltip = "text")  
    })
    
  })
}