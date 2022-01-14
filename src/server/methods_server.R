methods_server <- function(input, output, session) {
  
  citations <<- read.csv("citations.csv")
  group <- read.csv("ihme_mortality_group.csv")
  
  
  output$info <- renderText({
    
    validate(
      need(input$period, "Please select a country and year")
    )
    
    paste("Data for",
          # countrycode(input$country, "iso3c", "country.name"),
          str_to_sentence(input$country),
          "in",
          input$period,
          "was extracted from",
          filter(citations, iso3 == countrycode(input$country, "country.name", "iso3c"), period == input$period)$source_citation,
          filter(citations, iso3 == countrycode(input$country, "country.name", "iso3c"), period == input$period)$note
    )
  })
  
  output$group <- renderText({
    
    # browser()
    
    req(input$country)
    
    req(as.logical(nrow(filter(group, location_name == input$country))))
    
    paste0(
      "Mortality Group ",
      filter(group, location_name == input$country)$group
    )
    
  })
  
  output$group_explanation <- renderText({
    
    validate(
      need(input$country, "Please select a country")
    )
    
    paste0(
      input$country, 
      " is in IHME Mortality Group ",
      filter(group, location_name == input$country)$group,
      ". ",
      filter(group, location_name == input$country)$group_explanation
    )
    
  })
  
  
}