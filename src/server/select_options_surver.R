select_options_surver <- function(input, output, session) {
  
  output$country_option <- renderUI({
    selectizeInput(inputId = "country", label="Country:", 
                   choices=list(
                      `EECA` = as.character(unique(links$iso3)),
                      `Latin America` = as.character(unique(links$iso3)),
                      `MENA` = as.character(unique(links$iso3)),
                      `WCENA` = as.character(unique(links$iso3))
                    )
                   )
  })
  
  output$year_option <- renderUI({
    selectizeInput(inputId = "year", label = "Year:", choices=as.character(unique(links$period)))
  })
  
  output$age_option <- renderUI({
    selectizeInput(inputId = "age", label = "Age group:", choices=as.character(unique(links$age_group)))
  })

  output$sex_option <- renderUI({
    selectizeInput(inputId = "sex", label = "Sex:", choices=as.character(unique(links$sex), selected=NULL))
  })
  
}