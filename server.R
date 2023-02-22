
library(shiny)
library(nycflights13)
library(dplyr)
library(plotly)
library(ggplot2)


shinyServer(function(input, output) {
  
  airport_busyness_server(id = "airport_busyness_1")
  flights_from_NY_server(id = "flights_from_NY_1")
  
})
