library(shiny)

# Define UI for application that visualizes Covid19US data on map
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid19 U.S."),

    # Sidebar with a dropdown box to select one of five metrics
    sidebarPanel(
            selectInput("metric", "Choose a metric from COVID Tracking Project:",
                        list("positive", "negative", "pending",
                             "death", "total")),
            br(),
            br(),
            h4("See Johns Hopkins data plotter below [via Tableau/datadotworld]")
        ),

    # U.S. map at top; multiple-selection dropdown and line plot at bottom
    mainPanel(
            h4("The COVID Tracking Project data -
               https://covidtracking.com"),
            htmlOutput("gvis"),
            hr(),
            h4("US state/territory total cases by week - https://data.world/covid-19-data-resource-hub/covid-19-case-counts"),
            # Dropdown box to select US state/territory
            fluidRow(
                column(3, uiOutput("selections")),
            plotOutput("plot"),
            br(),
            br(),
            print("John Humphreys [@johnpharmd] 2020", justify = "left")

))))
