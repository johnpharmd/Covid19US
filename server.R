#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(jsonlite)
library(googleVis)

# Obtain data - awesome work by Hammerbacher et al.
base_url = "https://covidtracking.com/api/states"
df <- fromJSON(base_url) %>% data.frame()

# Define server logic required to plot googlevis map
shinyServer(function(input, output) {
    
    # myState <- reactive({
    #     input$text1
    # })
    output$gvis <- renderGvis({
        gvisGeoChart(df,
                     locationvar = "state", colorvar = "positive",
                     options = list(region = "US", displayMode = "regions",
                                    resolution = "provinces",
                                    width = 500, height = 400,
                                    colorAxis = "{colors: ['#FFFFFF', '#0000FF']}"
                     ))
    })
})
