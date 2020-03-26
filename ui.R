library(shiny)

# Define UI for application that visualizes Covid19US data on map
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid19 U.S. Data"),

    # Sidebar with a dropdown box to select one of five metrics
    sidebarPanel(
            selectInput("metric", "Choose a metric:",
                        list("positive", "negative", "pending",
                             "death", "total"))
        ),

    # Show the selected metric from side panel with U.S. map
    # below the selection
    mainPanel(
            h4("Map of The COVID Tracking Project data at
               https://covidtracking.com"),
            htmlOutput("gvis"),
            hr(),
            h4("Plot of selected metric from https://data.world/covid-19-data-resource-hub/covid-19-case-counts
               via Johns Hopkins/Tableau"),
            # selectInput("state", "Choose a State/Territory:",
            #             list())),
            plotOutput("plot")
        ),
    hr(),
    print("John Humphreys [@johnpharmd] 2020")
    
))    