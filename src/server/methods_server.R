methods_server <- function(input, output, session) {
  
  citations <<- read.csv("citations.csv")
  
  `%then%` <- shiny:::`%OR%`

  output$info <- renderText({
    
    validate(
      need(input$country, "Please select a country and year") %then%
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
  
  
  
}