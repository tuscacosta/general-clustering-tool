server <- function(input, output) {
  data_raw <- ""
  data_scaled <- ""
  
  observeEvent(input$import_data_button,{
    # read input variables
    raw_data_link <- input$raw_data_link
    
    data_raw <- read.csv2(raw_data_link, header = FALSE, sep = "")
    data_raw <- na.omit(data_raw)
    colnames(data_raw) <- c("x", "y")
    
    output$raw_plot <- renderPlot(
      ggplot() +
        geom_point(data = data_raw, aes(x = x, y = y))
    )
    
    data_raw <<- data_raw
  })
  
  observeEvent(input$scale_data_button, {
    data_scaled <- data_raw
    
    for(i in 1:ncol(data_scaled)){
      data_scaled[,i] <- (data_scaled[,i] - min(data_scaled[,i]))/(max(data_scaled[,i]) - min(data_scaled[,i]))
    }
    
    output$scaled_plot <- renderPlot(
      ggplot() +
        geom_point(data = data_scaled, aes(x = x, y = y))
    )
    data_scaled <<- data_scaled
    
  })
  
  observeEvent(input$cluster_data_button, {
    fit <- cascadeKM(data_scaled[, c("x", "y")], 1, 30, iter = 1000)
    
    for(i in 1:1000){
      cluster_model <- kmeans(data_scaled[,c("x", "y")], as.numeric(which.max(fit$results[2,])), 1000)
      
      if(i == 1){
        cluster_model_final <- cluster_model
        
      }else{
        if(cluster_model$tot.withinss < cluster_model_final$tot.withinss){
          cluster_model_final <- cluster_model
          number_of_executions <- i
        }
      }
    }
    
    print(number_of_executions)
    
    output$cluster_plot <- renderPlot(
      fviz_cluster(cluster_model_final, data = data_scaled[, c("x", "y")])
    )
    
    
    output$suggested_cluster_number <- renderText(print(paste0("The suggested number of clusters is: ", as.numeric(which.max(fit$results[2,])))))
    
  })
  
  # data_raw <- read.csv2("http://cs.joensuu.fi/sipu/datasets/a1.txt", header = FALSE, sep = " ")
  # data_raw <- data_raw[, c("V4", "V7")]
  # data_raw <- data_raw[, c("V4", "V7")]
  # colnames(data_raw) <- c("x", "y")
  # data_raw <- na.omit(data_raw)
  # 
  # 
  # output$raw_plot <- renderPlot(
  #   ggplot() +
  #     geom_point(data = data_raw, aes(x = x, y = y))
  # )
  
}
