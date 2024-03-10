library(shiny)
library(readr)

# Assuming mimic_icu_cohort is loaded elsewhere in your app
# mimic_icu_cohort <- read_rds("~/biostat-203b-2024-winter/hw4/mimiciv_shiny/mimic_icu_cohort.rds")

library(bigrquery)
library(dbplyr)
library(DBI)
library(gt)
library(gtsummary)
library(tidyverse)
library(dplyr)
library(tidyr)
library(readr)

# path to the service account token 
satoken <- "biostat-203b-2024-winter-313290ce47a6.json"
# BigQuery authentication using service account
bq_auth(path = satoken)

# connect to the BigQuery database `biostat-203b-2024-winter.mimic4_v2_2`
con_bq <- dbConnect(
  bigrquery::bigquery(),
  project = "biostat-203b-2024-winter",
  dataset = "mimic4_v2_2",
  billing = "biostat-203b-2024-winter"
)
con_bq

# Load the dataset
mimic_icu_cohort <- readRDS("~/biostat-203b-2024-winter/hw4/mimiciv_shiny/mimic_icu_cohort.rds")

cat <- c('first_careunit', 'last_careunit', 'admission_type',
              'admission_location', 'discharge_location', 'insurance',
              'language', 'marital_status', 'race', 'hospital_expire_flag',
              'gender', 'dod')

cont <- c('temperature_fahrenheit', 'non_invasive_blood_pressure_diastolic',
               'respiratory_rate', 'non_invasive_blood_pressure_systolic',
               'heart_rate')

lab <- c('sodium', 'chloride', 'creatinine', 'potassium', 'glucose',
              'hematocrit', 'wbc', 'bicarbonate')

labevents = mimic_icu_cohort %>%
  select(lab) %>%
  pivot_longer(cols = everything(), names_to = "lab_metrics", values_to = "value")

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
                 textInput("text", label = h3("Text input"), value = "10013310")
               )),
               column(6, wellPanel(
                 h3("Panel 4"),
                 plotOutput("plot2"), 
                 plotOutput("plot3")
               ))
             ))
  )
)



# Define server logic
server <- function(input, output, session) {

  
  # Dynamically update the selectInput choices based on dataset columns
  updateSelectInput(session, "selectedColumn",
                    choices = c(names(mimic_icu_cohort), "Lab Events"))
  
  # Generate plot for the selected column based on its data type
  output$columnPlot <- renderPlot({
    selected <- input$selectedColumn
    if (!is.null(selected)) {
      # Check if the selected column is numeric
      if (is.numeric(mimic_icu_cohort[[selected]])) {
        # Plot a histogram for numeric data
        hist(mimic_icu_cohort[[selected]], main = paste("Distribution of", selected), xlab = selected)
      } 
      else if (selected == "Lab Events"){
        ggplot(data = labevents) +
          geom_boxplot(aes(y=value, x=lab_metrics))
      }
      else {
        # For non-numeric data, plot a bar chart showing counts of each category
        counts <- table(mimic_icu_cohort[[selected]])
        barplot(counts, main = paste("Count of", selected), xlab = selected, las = 2)
      }
    }
  })
  
  output$plot2 <- renderPlot({
    pati = as.numeric(input$text)
    
    diagt<-tbl(con_bq, "diagnoses_icd")%>%
      filter(subject_id==pati)%>%
      left_join(tbl(con_bq, "d_icd_diagnoses"),by=c("icd_code","icd_version")) %>%
      head(3)
    
    proct<-tbl(con_bq, "procedures_icd")%>%
      filter(subject_id==pati)%>%
      left_join(tbl(con_bq, "d_icd_procedures"),by = c("icd_code","icd_version"))
    
    labev<- tbl(con_bq, "labevents")%>%
      filter(subject_id==pati)%>%
      collect()
    
    admit<-tbl(con_bq, "admissions")%>%filter(subject_id==pati)
    
    infot<-tbl(con_bq, "patients")%>%filter(subject_id==pati)
    
    transt<-tbl(con_bq, "transfers")%>%filter(subject_id==pati)
    
    ggplot () +
      geom_segment(
        data = transt |> filter(eventtype != "discharge"),
        mapping = aes (
          x = intime,
          xend = outtime,
          y = "ADT",
          yend = "ADT",
          color = careunit,
          linewidth = str_detect(careunit, "(ICU|CCU)")
        ),
      )+
      
      geom_point (
        data = labev |> distinct(charttime, .keep_all = TRUE),
        mapping = aes(x = charttime, y = "Lab"),
        shape = '+',
        size = 5
      ) +
      
      geom_jitter(
        # only keep the ist procedure on the same day
        data = proct,
        mapping = aes (
          x = chartdate + hours (12),
          y = "Procedure",
          shape = str_sub(long_title, 1, 25)),size = 3,height = 0
      ) +
      
      labs(title = str_c(
        "Patient", pati,", ",
        infot %>% pull(gender), ", ",
        infot %>% pull(anchor_age)+year(admit%>%pull(admittime[1]))-infot %>% pull(anchor_year),
        " years old, ",
        str_to_lower(admit%>% pull(race[1]))
      ),
      subtitle = str_c(str_to_lower(diagt%>%pull(long_title)), collapse = "\n"),
      x = "Calendar Time",
      y="",
      color = "Care Unit",
      shape = "Procedure"
      ) +
      guides(linewidth = "none") +
      scale_y_discrete(limits = rev) +
      theme_light() +
      theme(legend.position = "bottom", legend.box = "vertical")
    
  })
  
  output$plot3 <- renderPlot({
    pati <- as.numeric(input$text)
    
    items = tbl(con_bq, "d_items") %>%
      filter(itemid %in% c(220045, 220179, 220180, 220210, 223761))
    
    ces = tbl(con_bq, "chartevents") %>% 
      filter(subject_id %in% pati, 
             itemid %in% c(220045, 220179, 220180, 220210, 223761))
    
    ads = left_join(ces, items)
    
    
     ggplot(ads, aes(x = charttime, y = valuenum, color = abbreviation, group = abbreviation)) +
      geom_line() +
      geom_point() +
      facet_grid(abbreviation ~ stay_id, scales = "free") +
      labs(title = str_c("Patient ", pati, " ICU stays - Vitals"),
           x = "",
           y = "")
  })
  # The rest of the server logic remains unchanged
}

# Run the application
shinyApp(ui = ui, server = server)
