#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that visualizes Covid19US data on map
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid19 U.S. Data"),

    # Sidebar with a slider input for number of bins
    sidebarPanel(
            textInput("text1", "Enter a State:")
        ),

    # Show a plot of the generated distribution
    mainPanel(
            # h3("state"),
            htmlOutput("gvis")
        )
    )
)
