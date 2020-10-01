select_options_surver <- function(input, output) {
  
  output$country_option <- renderUI({
    selectizeInput(inputId = "country", label="Country:", choices=as.character(unique(data$iso3)), selected=data$iso3[1])
  })
  
  output$single_year_option <- renderUI({
    selectizeInput(inputId = "single_year", label = "2) Survey year", choices=NULL, selected=NULL)
  })
  
}