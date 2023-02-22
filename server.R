
library(shiny)
library(nycflights13)
library(dplyr)
library(plotly)
library(ggplot2)
library(DT)

shinyServer(function(input, output) {
  
  airport_busyness_server(id = "airport_busyness_1")
  flights_from_NY_server(id = "flights_from_NY_1")
  view_flight_data_server(id = "view_flight_data_1")
  model_server(id = "model_1")
  
})
