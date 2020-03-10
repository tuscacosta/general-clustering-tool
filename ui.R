##### call libraries #####
library(shiny)
library(shinydashboard)
library(ggplot2)

ui <- dashboardPagePlus(
  dashboardHeader(title = "General clustering tool"),
  
  dashboardSidebar(),
  
  dashboardBody(
    fluidRow(
      box(plotOutput("raw_plot", height = 250))
    ) 
  ) # end dashboard body
  
) # end dashboard page
