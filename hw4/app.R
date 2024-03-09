library(shiny)
library(tidyverse)
library(lubridate)
library(readr)

# Assuming your datasets are accessible and in the correct format
# You might need to adjust the loading mechanism based on your app's specifics
transfers <- read_csv("~/mimic/hosp/transfers.csv.gz")

# Filter the transfers data for a specific patient
ftransfers <- subset(transfers, subject_id == 10013310)
patient_id <- 10013310

csv_file_path <- "~/mimic/hosp/labevents.csv"
parquet_file <- "./labevents.parquet"

# Read the CSV file
labevents_dataset <- arrow::open_dataset(csv_file_path, format = "csv")

# Write the dataset to a Parquet file
arrow::write_dataset(labevents_dataset, parquet_file, format = "parquet")

# Open the Parquet dataset
parquet_dataset <- arrow::open_dataset(parquet_file)
# Open the Parquet dataset
data_dataset <- arrow::open_dataset(parquet_file)

# Filter the data for subject_id 10013310 without loading everything into memory
filtered_data <-  data_dataset %>% 
  filter(subject_id == patient_id ) %>%
  select()
  collect() # Use collect() to bring the filtered data into memory as a dataframe

# `filtered_data` now contains all the rows for subject_id 10013310



# UI definition
ui <- fluidPage(
  titlePanel("Patient Data Visualization"),
  sidebarLayout(
    sidebarPanel(
      # Input: Select a Subject ID
      selectInput("subject_id", "Select a Subject ID",
                  choices = unique(transfers$subject_id)),
      actionButton("plotData", "Plot Data")
    ),
    mainPanel(
      # Output: Plot
      plotOutput("labPlot")
    )
  )
)

# Server logic
server <- function(input, output) {
  observeEvent(input$plotData, {
    # Filter transfers for selected subject_id
    ftransfers <- subset(transfers, subject_id == input$subject_id)
    
    # Assuming data_dataset is prepared with 'subject_id' and 'patient_id' columns correctly set up
    filtered_data <- data_dataset %>%
      filter(subject_id == input$subject_id) %>%
      collect() # Ensure this is feasible given your dataset size
    
    # Generate the plot based on the selected subject_id
    output$labPlot <- renderPlot({
      # Basic plot setup, replace this with your actual plotting code
      transfer_plot <- ftransfers %>%
        filter(eventtype != "discharge") %>%
        ggplot() +
        geom_segment(aes(x = intime, xend = outtime, y = 1, yend = 1, color = careunit, 
                         size = str_detect(careunit, "ICU|CCU"))) +
        labs(x = "", y = "", title = paste("Patient", input$subject_id)) +
        guides(size = "none") # Example plot adjustments
      
      # Further adjustments and adding lab/procedure points as per your code
      # Make sure to replace `fprocedures` with filtered procedures data for the selected subject_id
      
      lab_plot <- transfer_plot +
        geom_point(data = filtered_data, aes(x = charttime, y = 0, color = "Lab"), 
                   shape = 3, size = 3) +
        # Add procedures points...
        labs(color = "", caption = "Calendar Time") +
        theme(legend.position = "bottom",
              aspect.ratio = 1/4,
              legend.box = "horizontal",
              plot.caption = element_text(hjust = 0.5))
      
      print(lab_plot) # Render the plot
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
