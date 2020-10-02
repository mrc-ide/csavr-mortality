select_options_surver <- function(input, output) {
  
  output$country_option <- renderUI({
    selectizeInput(inputId = "country", label="Country:", 
                   choices=list(
                      `EECA` = unique(links$iso3),
                      `Latin America` = unique(links$iso3),
                      `MENA` = unique(links$iso3),
                      `WCENA` = unique(links$iso3)
                    )
                   )
  })
  
  output$year_option <- renderUI({
    selectizeInput(inputId = "year", label = "Year:", choices=unique(links$period))
  })
  
  output$age_option <- renderUI({
    selectizeInput(inputId = "age", label = "Age group:", choices=unique(links$age_group))
  })

  output$sex_option <- renderUI({
    selectizeInput(inputId = "sex", label = "Sex:", choices=unique(links$sex), selected=NULL)
  })
  
}