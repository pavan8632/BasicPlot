library(shiny)
source("./PCAFunc.R")
shinyUI(pageWithSidebar( 
  headerPhomanel("Principal Component Analysis"),
  
  sidebarPanel(
    fileInput('file1','Choose CSV File', accept=c('text/csv,','.csv')),
    checkboxInput('header', 'Header', TRUE),
    checkboxInput('parse','Parse?',TRUE),
    selectInput('std','Std. Method',c(Log='Log',ZScore='z'),selected='z'),
    checkboxInput('all','Check to select all Columns',TRUE),
    uiOutput("col"),
    uiOutput("PCs"),
    uiOutput("FPlot"),
    checkboxInput("center","Center",TRUE),
    selectInput("scaling","Scale", list(none = "none", "unit variance" = "uv", pareto = "pareto")), 
    selectInput("method","Method",namel(listPcaMethods())),
    uiOutput("CutOff"),
    uiOutput("NumArr")
    
    ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Data",tableOutput("contents")),
      tabPanel("Parsed Data",tableOutput("parsed"),downloadButton('downloadParse','Download Calculation Data')),
      tabPanel("Scree Plot",plotOutput("screeplot",height = 280*2, width = 250*2)),
      tabPanel("Ferg Plot",plotOutput("BPlot"),downloadButton('downloadBplot','Download this plot')),
      tabPanel("Loadings Plot",plotOutput("loadings")) 
         ) 
  )
  
  
  
  
  
  ))
