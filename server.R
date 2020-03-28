library(shiny)
library(curl)
library(jsonlite)
library(dwapi)
library(googleVis)
library(ggplot2)
library(dplyr)

# Obtain data
# awesome work by Hammerbacher et al.
base_url <- "https://covidtracking.com/api/states"
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

# Define server logic required to plot googlevis map and line plot
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
        # min_date <- as.Date("2020-01-20")
        # max_date <- NA
        ggplot(filter(tableau_jh_df, province_state == input$state_terr),
                      aes(date, number_of_cases, group = 1)) +
        geom_line() +
        labs(x = "Date", y = "Number of Cases") +
        theme(axis.text.x = element_text(angle = 45),
              axis.text.y = element_text(angle = 90),
              plot.margin = unit(c(1, 1, 1, 1), "cm")) + 
        scale_x_date(date_breaks = "weeks")
       })
})
