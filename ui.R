library(shiny)

# Define UI for application that visualizes Covid19US data on map
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid19 U.S."),

    # Sidebar with a dropdown box to select one of five metrics
    sidebarPanel(
            selectInput("metric", "Choose a metric from COVID Tracking Project:",
                        list("hospitalizedCurrently", "death", "positive",
                             "negative", "recovered")),
            br(),
            br(),
            h4("See below to plot curves by state/territory")
        ),

    # U.S. map at top; multiple-selection dropdown and line plot at bottom
    mainPanel(
            h4("The COVID Tracking Project data -
               https://covidtracking.com"),
            htmlOutput("gvis"),
            hr(),
            h4("US state/territory total deaths due to COVID19"),
            # h4("US state/territory total deaths - https://data.world/covid-19-data-resource-hub/covid-19-case-counts"),
            # Dropdown box to select US state/territory
            fluidRow(
                column(3, uiOutput("selections")),
            plotOutput("plot"),
            br(),
            br(),
            h6("John Humphreys [@johnpharmd] 2020", justify = "left")

))))
