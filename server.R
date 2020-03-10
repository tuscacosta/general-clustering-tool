server <- function(input, output) {
  
  data_raw <- read.csv2("http://cs.joensuu.fi/sipu/datasets/a1.txt", header = FALSE, sep = " ")
  data_raw <- data_raw[, c("V4", "V7")]
  data_raw <- data_raw[, c("V4", "V7")]
  colnames(data_raw) <- c("x", "y")
  data_raw <- na.omit(data_raw)
  
  
  output$raw_plot <- renderPlot(
    ggplot() +
      geom_point(data = data_raw, aes(x = x, y = y))
  )
  
}
