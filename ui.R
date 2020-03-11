##### call libraries #####
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(factoextra)
library(ggplot2)
library(vegan)

ui <- dashboardPagePlus(
  dashboardHeader(title = "General clustering tool"),
  
  dashboardSidebar(
    # sidebarSearchForm("textId", "buttonId", label = "Search...",
    #                   icon = shiny::icon("search"))
    menuItem(text = "Import raw data",
             textInput(inputId = "raw_data_link", label = "Insert link"),
             actionButton(inputId = "import_data_button", label = "Import data")
             ), # end menu item to import data
    
    menuItem(text = "Scale data",
             actionButton(inputId = "scale_data_button", label = "Scale data")
    ),
    
    menuItem(text = "Cluster data",
             actionButton(inputId = "cluster_data_button", label = "Cluster data")
    )
    
  ),
  
  dashboardBody(
    fluidRow(
      box(title = "Raw graphic",
          plotOutput("raw_plot"),
          height = "100%"),
      box(title = "Scaled data",
          plotOutput("scaled_plot"),
          height = "100%")
    ),
    fluidRow(
      box(title = "Clustered data",
          plotOutput("cluster_plot"),
          textOutput(outputId = "suggested_cluster_number"),
          height = "100%")
    )
  ) # end dashboard body
  
) # end dashboard page
