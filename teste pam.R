library(cluster)
library(fpc)
library(factoextra)
library(ggplot2)
library(shinydashboardPlus)

install.packages("factoextra")

data_raw <- read.csv2("http://cs.joensuu.fi/sipu/datasets/a1.txt", header = FALSE, sep = " ")
data_raw <- data_raw[, c("V4", "V7")]
colnames(data_raw) <- c("x", "y")
data_raw <- na.omit(data_raw)

clustering_results <- NULL


for(i in 1:100){
  model_kmeans <- kmeans(data_raw[, c("x", "y")], i, 1000)
  
  clustering_results <- rbind(clustering_results, cbind(as.data.frame(model_kmeans$tot.withinss), i))
}

colnames(clustering_results) <- c("error", "clusters")
clustering_results$delta_error <- 0

for(i in 1:100){
  if(i > 1) clustering_results[i,]$delta_error <- (clustering_results[i,]$error/clustering_results[i-1,]$error-1)
}



ggplot() +
  geom_line(data = clustering_results, aes(x = clusters, y = error)) +
  scale_x_continuous("Clusters #", labels = (seq(from = 0, to = 100, by = 5)), breaks = (seq(from = 0, to = 100, by = 5)))

ggplot() +
  geom_line(data = clustering_results, aes(x = clusters, y = delta_error)) +
  scale_x_continuous("Clusters #", labels = (seq(from = 0, to = 100, by = 5)), breaks = (seq(from = 0, to = 100, by = 5)))

model_pam <- pamk(data_raw[, c("x", "y")], krange = 2:3, criterion = "asw")

model_clusters <- NULL
model_error <- NULL
execution_control <- 0

for(i in 1:100){
  model_kmeans <- kmeans(data_raw[, c("x", "y")], 19, 1000)
  
  if(i == 1){
    model_error <- model_kmeans$tot.withinss
    
  }else{
    if(model_kmeans$tot.withinss < model_error){
      model_error <- model_kmeans$tot.withinss
      model_kmeans_final <- model_kmeans
      execution_control <- i
    } 
  }
}

fviz_cluster(model_kmeans_final, data = data_raw[, c("x", "y")])
fviz_cluster(model_pam$pamobject, data = data_raw[, c("x", "y")])

# find max number of clusters using Calinski criterion
install.packages("vegan")
require(vegan)
fit <- cascadeKM(data_raw[, c("x", "y")], 1, 30, iter = 1000)
plot(fit, sortg = TRUE, grpmts.plot = TRUE)
calinski.best <- as.numeric(which.max(fit$results[2,]))
cat("Calinski criterion optimal number of clusters:", calinski.best, "\n")



