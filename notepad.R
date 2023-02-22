library(nycflights13)
library(ggplot2)
library(dplyr)

planes <- planes
flights <- flights
airports <- airports
airlines <- airlines


world_map <- map_data("world")
airport_coordinates <- airports[ , c("faa", "lat", "lon", "name")]

unique_flights <- flights %>% 
  distinct(origin, dest) %>% 
  left_join(.,
            airport_coordinates,
            by = c("origin" = "faa")) %>% 
  left_join(.,
            airport_coordinates,
            by = c("dest" = "faa"),
            suffix = c("_origin", "_dest"))

unique_flights %>% 
  group_by(dest) %>% 
  count(origin) %>% 
  pull(n) %>% 
  unique()
# Each destination is only reachable from one of the NY airports

p <- ggplot(world_map) +
  geom_polygon(aes(x = long, 
                   y = lat, 
                   group = group), 
               fill = "lightgrey", 
               color = "white") +
  geom_point(aes(x = lon_dest, 
                 y = lat_dest,
                 color = origin,
                 text = paste0(
                   "Destination: ",
                   name_dest,
                   "\nOrigin: ",
                   name_origin
                 )), 
             data = unique_flights) +
  geom_point(aes(x = lon_origin,
                 y = lat_origin,
                 color = origin,
                 text = paste0(
                   "New York airport: ",
                   name_origin
                   )),
             data = unique_flights,
             shape = "square") +
  # geom_curve(aes(x = lon_origin, 
  #                y = lat_origin, 
  #                xend = lon_dest, 
  #                yend = lat_dest,
  #                color = origin),
  #            data = unique_flights) +
  theme_void() +
  theme(legend.position = "none") +
  coord_cartesian(xlim = c(-180, -50), ylim = c(0, 80))

p

plotly::ggplotly(p, tooltip = "text")  
