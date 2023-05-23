library(tidyverse)
library(shiny)

search_data <- read.csv("data/wl_search_data_full.csv") %>% 
  select(2:4)

our_data <- readxl::read_excel("data/Master_1.xlsx",
                               sheet = "Lens_details")

function(input, output, session) {
  fullData <- eventReactive(input$wl | input$od, {
    req(input$wl >= 200 & input$wl <= 11000)
    fullData <- search_data %>% 
      filter(Wavelength == round(input$wl, digits=0),
             OD >= input$od) %>% 
      arrange(OD)
    req(input$od <= max(fullData$OD))
    updateNumericInput(inputId = "od",max = max(fullData$OD))
    map(unique(fullData$Lens), ~tibble(filter(our_data, Lens == .x)))
  })
  # prototype dynamic rendering of tables -> tables, images, links
  output$tables <- renderUI({
    req(fullData())
    map(1:length(fullData()), ~renderTable(bordered = T,
    align = "c",
    striped=T,
    hover = F,
    width = "100%",
    colnames = T, na = "-",{
      fullData()[[.x]] %>% 
      select(c("Lens", "OD", "CE", "VLT","Material", "Summary"))
      })
      )
  })
  output$links <- renderUI({
    req(fullData())
    map(1:length(fullData()), ~HTML(
      c('<a href="',
        fullData()[[.x]]$Website,
        '">',fullData()[[.x]]$Lens,'</a>'
      
    ))
    )
  })
  output$images <- renderUI({
    req(fullData())
    map(1:length(fullData()), ~HTML(
      c('<img src="',
        fullData()[[.x]]$Image,
        '", height = 65em>')
      ))
    
  })

}
