
model_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "Factors affecting delays",
    width = 12,
    textOutput(ns("variables")),
    br(),
    uiOutput(ns("plots"))
  )
}

model_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    for_random_forest <- reactive({
      flights_with_weather <- dplyr::left_join(flights,
                                               weather)
      no_NAs <- flights_with_weather %>% 
        dplyr::select(-c("dep_time", "arr_time", "dep_delay")) %>% 
        dplyr::mutate(flight = as.character(flight)) %>% 
        dplyr::filter(!dplyr::if_any(.cols = dplyr::everything(),
                                     .fns = is.na))
      
      # I only use a small subset of data because laptop is too slow:
      set.seed(123)
      small_dataset <- dplyr::sample_n(no_NAs,
                                       size = 100)
      return(small_dataset)
    })
    
    delay_variables <- reactive({
      req(for_random_forest())
      predictors <- for_random_forest() %>% 
        dplyr::select(-arr_delay)
      
      set.seed(234)
      tune <- randomForest::tuneRF(x = predictors,
                                   y = for_random_forest()$arr_delay,
                                   ntreeTry = 500, 
                                   stepFactor = 2, 
                                   improve = 0.05,
                                   plot = FALSE)
      best_mtry <- tune[which.min(tune[ , 2]), 1]
      
      set.seed(345)
      VSURF_results <- VSURF::VSURF(x = predictors, 
                                    y = for_random_forest()$arr_delay,
                                    mtry = best_mtry,
                                    parallel = TRUE)
      variables <- colnames(predictors)[VSURF_results$varselect.pred]
      return(variables)
    })
    
    output$plots <- renderUI({
      req(delay_variables())
      
      plot_list <- purrr::map(delay_variables(),
                              function(variable) {
                                column(
                                  width = 6,
                                  plotOutput(ns(variable))
                                )
                              })
      
      do.call(fluidRow, plot_list)
    })
    
    
    observe({
      req(delay_variables())
      purrr::map(delay_variables(),
                 function(variable) {
                   output[[variable]] <- renderPlot({
                     
                     if (is.numeric(for_random_forest()[[variable]])) {
                       ggplot2::ggplot(for_random_forest()) +
                         ggplot2::geom_point(ggplot2::aes(x = arr_delay,
                                                          y = .data[[variable]]),
                                             color = "red") +
                         ggplot2::xlab("Arrival delay (minutes)") +
                         ggplot2::theme_bw()
                     } else {
                       ggplot2::ggplot(for_random_forest()) +
                         ggplot2::geom_boxplot(ggplot2::aes(y = arr_delay,
                                                            x = as.factor(.data[[variable]]))) +
                         ggplot2::ylab("Arrival delay (minutes)") +
                         ggplot2::theme_bw()
                     }
                   })
                 })
    })
    
    output$variables <- renderText({
      req(delay_variables())
      paste("The variable selection using random forests (VSURF) algorithm", 
            "identified the following variables as affecting arrival delays:",
            comma_and(delay_variables()))
    })
    
  })
}