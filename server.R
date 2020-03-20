library(shiny)
library(jsonlite)
library(googleVis)

# Obtain data - awesome work by Hammerbacher et al.
base_url = "https://covidtracking.com/api/states"
df <- fromJSON(base_url) %>% data.frame()

# Define server logic required to plot googlevis map
shinyServer(function(input, output) {
    
    output$gvis <- renderGvis({
        gvisGeoChart(df,
                     locationvar = "state", colorvar = input$metric,
                     options = list(region = "US", displayMode = "regions",
                                    resolution = "provinces",
                                    width = 500, height = 400,
                                    colorAxis = "{colors: ['#FFFFFF', '#0000FF']}"
                     ))
    })
})
