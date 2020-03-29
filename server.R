library(shiny)
library(curl)
library(jsonlite)
library(dwapi)
library(googleVis)
library(ggplot2)
library(shinyWidgets)
library(dplyr)

# Constants
states_terrs <- c("Alabama", "Alaska", "Arizona", "Arkansas",
                  "California", "Colorado",
                  "Connecticut", "Delaware",
                  "District of Columbia", "Florida",
                  "Georgia", "Guam",
                  "Hawaii", "Idaho",
                  "Illinois", "Indiana",
                  "Iowa", "Kansas",
                  "Kentucky", "Louisiana",
                  "Maine", "Maryland",
                  "Massachusetts", "Michigan",
                  "Minnesota", "Mississippi",
                  "Missouri", "Montana",
                  "Nebraska", "Nevada",
                  "New Hampshire", "New Jersey",
                  "New Mexico", "New York",
                  "North Carolina", "North Dakota",
                  "Ohio", "Oklahoma",
                  "Oregon", "Pennsylvania",
                  "Puerto Rico", "Rhode Island",
                  "South Carolina", "South Dakota",
                  "Tennessee", "Texas",
                  "Utah", "Vermont",
                  "Virgin Islands", "Virginia",
                  "Washington", "West Virginia",
                  "Wisconsin", "Wyoming")

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

# Define server logic required to plot googlevis map,
# states/territories dropdown, and line plot
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

    output$selections <- renderUI({
        pickerInput("states_terrs", "Select up to 4 States/Territories:",
                    states_terrs, list("max-options" = 4), multiple = TRUE)
    })

    upto4_filter <- reactive({
        tableau_jh_df %>% filter(province_state %in% input$states_terrs)

    })

    output$plot <- renderPlot({
        upto4_filter = upto4_filter()
        ggplot(upto4_filter, aes(date, number_of_cases, group = province_state,
                                 col = province_state)) +
        geom_line() +
        labs(x = "Date", y = "Number of Cases") +
        theme(axis.text.x = element_text(angle = 45),
              axis.text.y = element_text(angle = 90),
              plot.margin = unit(c(1.5, 1, 1, 1.5), "cm")) +
        scale_x_date(date_breaks = "weeks")
       })
})
