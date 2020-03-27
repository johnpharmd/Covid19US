library(shiny)
library(curl)
library(jsonlite)
library(dwapi)
library(googleVis)
library(ggplot2)

# Obtain data
# awesome work by Hammerbacher et al.
base_url = "https://covidtracking.com/api/states"
json_source <- fromJSON(base_url)
covidtracking_df <- data.frame(json_source)

# Johns Hopkins data put on data.world by Tableau - amazing
dwapi::configure(auth_token = Sys.getenv("DW_AUTH_TOKEN"))
owner_id <- "covid-19-data-resource-hub"
dataset_id <- "covid-19-case-counts"
covid19_dataset <- dwapi::get_dataset(
  owner_id = owner_id,
  dataset_id = dataset_id)
sql_query <- "SELECT date, province_state, SUM(cases) AS number_of_cases
  FROM covid_19_cases WHERE country_region = 'US'
  GROUP BY date, province_state
  ORDER BY date, province_state"
tableau_jh_df <- data.frame(dwapi::sql(owner_id, dataset_id,
                                       sql_query))

# Define server logic required to plot googlevis map
shinyServer(function(input, output) {
    
    output$gvis <- renderGvis({
        gvisGeoChart(covidtracking_df,
                     locationvar = "state", colorvar = input$metric,
                     options = list(region = "US", displayMode = "regions",
                                    resolution = "provinces",
                                    width = 500, height = 400,
                                    colorAxis = "{colors: ['#FFFFFF', '#0000FF']}"
                     ))
    })
    
    output$plot <- renderPlot({
        ggplot(data = tableau_jh_df, aes("date",
                                         "number_of_cases",
                                         group = 1)) +
               geom_line() + geom_point() +
               theme(axis.text.x = element_text(size = 16)) +       
               theme(axis.text.y = element_text(size = 16,
                                                angle = 90)
               )
    })
})
