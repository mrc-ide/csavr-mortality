select_options_surver <- function(input, output, session) {
  
  output$country_option <- renderUI({
    selectizeInput(inputId = "country", label="1) Country:", choices = sort(unique(full_dat$area_name)), selected = "")
  })

  output$period_option <- renderUI({
    selectizeInput(inputId = "period", label = "2) Year:", choices=sort(unique(full_dat$period), decreasing=FALSE), selected = "")
  })

  output$age_option <- renderUI({
    selectizeInput(inputId = "age", label = "3) Age group:", choices=as.character(unique(arrange(full_dat, age_group_id)$age_group)), selected = "")
  })

  output$sex_option <- renderUI({
    selectizeInput(inputId = "sex", label = "4) Sex:", choices=as.character(unique(full_dat$sex)), selected="")
  })
  
  observeEvent(input$country, {
    
    period_input_choices <- full_dat %>%
      filter(area_name == input$country) %>%
      .$period %>%
      unique %>%
      as.numeric %>%
      sort(decreasing = FALSE)
    
    updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "period", choices = period_input_choices, selected = "")
    
    # enable("period")
    # disable("age")
    # disable("sex")
    # # 
  })
  
  observeEvent(input$period, {
    
    age_input_choices <- full_dat %>%
      filter(area_name == input$country,
             period == input$period) %>%
      arrange(age_group_id) %>%
      .$age_group %>%
      unique
    
    updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "age", choices = age_input_choices, selected = "")
    
    # enable("age")
    # disable("sex")
    
  })
  
  observeEvent(input$age, {
    
    
    sex_input_choices <- full_dat %>%
      filter(area_name == input$country,
             period == input$period,
             age_group == input$age) %>%
      .$sex %>%
      unique
    
    updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "sex", choices = sex_input_choices, selected = "")
    
    # enable("sex")
    
  })
  
}