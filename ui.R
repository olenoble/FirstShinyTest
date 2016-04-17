library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Strategy Visualization Tool"),
  
  sidebarLayout(
    position = "left",
    sidebarPanel(
      #h4("My sidebar"),
      #p("Some stuff to discuss here"),
      selectInput("stratselect", label = h3("Strategy Selection"), 
            choices = list("Apple" = "aapl", "Microsoft" = "msft", "Yahoo" = "yhoo"), 
            selected = "aapl"),
      br(),
      downloadButton('downloadData', 'Download Data'),
      br(), br(), br(),
      #div("test", style = "color:red"),
      #fluidRow(column(3, verbatimTextOutput("stratselect"))),
      fluidRow(column(5, tableOutput('metrics')))
      #code("Shiny-xxx")
    ),
    
    mainPanel(
      #h4("My main panel"),
      #a("Google", href="http://www.google.com"),
      #br(),
      #h4("Some other stuff"),
      #p("Good read:",
      #a("Python", href="https://www.continuum.io/")),
      #fluidRow(column(5, dataTableOutput('contents')))
      #plotOutput('plot', width = "auto")#, height = "100%")
      tabsetPanel(
        tabPanel("Plot", plotOutput("plot")),
        tabPanel("Data", dataTableOutput('contents')),
        tabPanel("YoY Return", plotOutput("YoYplot")))
    )
  )
))
