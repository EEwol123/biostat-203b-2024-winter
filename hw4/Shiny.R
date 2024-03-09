library(shiny)
library(readr)

# Assuming mimic_icu_cohort is loaded elsewhere in your app
# mimic_icu_cohort <- read_rds("~/biostat-203b-2024-winter/hw4/mimiciv_shiny/mimic_icu_cohort.rds")

# Define UI
ui <- fluidPage(
  # Application title
  titlePanel("Shiny App with Select Inputs and Plots"),
  
  # Create tabs
  tabsetPanel(
    # First tab with a select input for choosing a column and a plot
    tabPanel("Patient characteristics",
             fluidRow(
               column(6, wellPanel(
                 h3("Select a Column to Plot"),
                 selectInput("selectedColumn", "Choose a column:",
                             choices = NULL) # Choices will be updated in server
               )),
               column(6, wellPanel(
                 h3("Column Value Distribution"),
                 plotOutput("columnPlot")
               ))
             )),
    # Second tab remains unchanged for this example
    tabPanel("Patient's ADT and ICU stay information",
             fluidRow(
               column(6, wellPanel(
                 h3("Panel 3"),
                 selectInput("select3", "Choose an option for Panel 3:",
                             choices = c("Option 7", "Option 8", "Option 9"))
               )),
               column(6, wellPanel(
                 h3("Panel 4"),
                 plotOutput("plot2") # Plot output for Panel 4 remains unchanged
               ))
             ))
  )
)

# Define server logic
server <- function(input, output, session) {
  # Load the dataset
  mimic_icu_cohort <- readRDS("~/biostat-203b-2024-winter/hw4/mimiciv_shiny/mimic_icu_cohort.rds")
  
  # Dynamically update the selectInput choices based on dataset columns
  updateSelectInput(session, "selectedColumn",
                    choices = names(mimic_icu_cohort))
  
  # Generate plot for the selected column based on its data type
  output$columnPlot <- renderPlot({
    selected <- input$selectedColumn
    if (!is.null(selected)) {
      # Check if the selected column is numeric
      if (is.numeric(mimic_icu_cohort[[selected]])) {
        # Plot a histogram for numeric data
        hist(mimic_icu_cohort[[selected]], main = paste("Distribution of", selected), xlab = selected)
      } else {
        # For non-numeric data, plot a bar chart showing counts of each category
        counts <- table(mimic_icu_cohort[[selected]])
        barplot(counts, main = paste("Count of", selected), xlab = selected, las = 2)
      }
    }
  })
  
  # The rest of the server logic remains unchanged
}

# Run the application
shinyApp(ui = ui, server = server)
