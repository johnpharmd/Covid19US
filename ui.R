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
            hr(),
            hr(),
            h4("See Johns Hopkins data below [via Tableau/datadotworld]")
        ),
    
    # Show the selected metric from side panel with U.S. map
    # below the selection
    mainPanel(
            h4("The COVID Tracking Project data -
               https://covidtracking.com"),
            htmlOutput("gvis"),
            hr(),
            h4("US state/territory total cases by week - https://data.world/covid-19-data-resource-hub/covid-19-case-counts"),
            # Dropdown box to select US state/territory
            fluidRow(
                column(3,
                       selectInput("state_terr", "Choose a State/Territory:",
                                   list("Alabama", "Alaska", "Arizona", "Arkansas",             
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
                                        "Wisconsin", "Wyoming")),
                )),
            plotOutput("plot"),
    
    print("John Humphreys [@johnpharmd] 2020")
    
)))
