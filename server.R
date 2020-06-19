library(shiny)
library(curl)
library(jsonlite)
library(googleVis)
library(ggplot2)
library(shinyWidgets)
library(dplyr)

# Constants
states_terrs <- c("Alabama", "Alaska", "Arizona", "Arkansas",
                  "American Samoa", "California", "Colorado",
                  "Connecticut", "Delaware",
                  "District of Columbia", "Florida",
                  "Georgia", "Guam",
                  "Hawaii", "Idaho",
                  "Illinois", "Indiana",
                  "Iowa", "Kansas",
                  "Kentucky", "Louisiana",
                  "Maine", "Mariana Islands", "Maryland",
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

states_abbrevs <- c("AL", "AK", "AZ", "AR", "AS",
                  "CA", "CO", "CT", "DE",
                  "DC", "FL", "GA", "GU",
                  "HI", "ID", "IL", "IN",
                  "IA", "KS", "KY", "LA",
                  "ME", "MP", "MD", "MA", "MI",
                  "MN", "MS", "MO", "MT",
                  "NE", "NV", "NH", "NJ",
                  "NM", "NY", "NC", "ND",
                  "OH", "OK", "OR", "PA",
                  "PR", "RI", "SC", "SD",
                  "TN", "TX", "UT", "VT",
                  "VI", "VA", "WA", "WV",
                  "WI", "WY")

# Obtain data
# awesome work by Hammerbacher et al.
base_url <- "https://covidtracking.com/api/states"
json_source <- fromJSON(base_url)
covidtracking_df <- data.frame(json_source)
us_daily_df <- read.csv("https://covidtracking.com/api/v1/states/daily.csv")

# Johns Hopkins data put on data.world by Tableau
# dwapi::configure(auth_token = Sys.getenv("DW_AUTH_TOKEN"))
# owner_id <- "covid-19-data-resource-hub"
# dataset_id <- "covid-19-case-counts"
# sql_query <- "SELECT date, province_state AS State_Terr,
#   SUM(cases) AS number_of_deaths
#   FROM covid_19_cases
#   WHERE country_region = 'US' and case_type = 'Deaths'
#   GROUP BY date, State_Terr
#   ORDER BY date, State_Terr"
# tableau_jh_df <- data.frame(dwapi::sql(owner_id, dataset_id,
#                                       sql_query))

# Define server logic required to plot googlevis map,
# states/territories dropdown, and line plot
shinyServer(function(input, output) {

    output$gvis <- renderGvis({
        gvisGeoChart(covidtracking_df,
                     locationvar = "state", colorvar = input$metric,
                     options = list(region = "US", displayMode = "regions",
                                    resolution = "provinces",
                                    width = 500, height = 400,
                                    colorAxis = "{colors: ['#FFFFFF', '#000000']}"
                     ))
    })

    output$selections <- renderUI({
        pickerInput("states_abbrevs", "Select 1 or More States/Territories:",
                    states_abbrevs, multiple = TRUE) #, options = list("max-options" = 4), 
    })

    input_filter <- reactive({
        # tableau_jh_df %>% filter(State_Terr %in% input$states_terrs)
        us_daily_df %>% filter(state %in% input$states_abbrevs)
    })

    output$plot <- renderPlot({
        input_filter = input_filter()
        # ggplot(input_filter, aes(date, number_of_deaths, group = State_Terr,
        #                          col = State_Terr)) +
        ggplot(input_filter, aes(ymd(date), death, group = state,
                                 col = state)) +
        geom_line() +
        labs(x = "Date", y = "Number of Deaths") +
        theme(axis.title = element_text(size = 14),
              axis.text.x = element_text(angle = 45),
              axis.text.y = element_text(angle = 90),
              plot.margin = unit(c(1.5, 1, 1, 1.5), "cm"),
              legend.title = element_blank()) +
        scale_x_date(date_breaks = "2 weeks")
       })
})
