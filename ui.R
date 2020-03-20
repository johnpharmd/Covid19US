library(shiny)

# Define UI for application that visualizes Covid19US data on map
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid19 U.S. Data, from https://covidtracking.com"),

    # Sidebar with a dropdown box to select one of five metrics
    sidebarPanel(
            selectInput("metric", "Choose a metric:",
                        list("positive", "negative", "pending",
                             "death", "total"))
        ),

    # Show the selected metric from side panel with U.S. map
    # below the selection
    mainPanel(
            h3("Fully updated daily at 1700hrs EDT"),
            htmlOutput("gvis")
        ),
    hr(),
    print("John Humphreys [@johnpharmd] 2020")
    
))    