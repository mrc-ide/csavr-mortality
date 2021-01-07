select_options_surver <- function(input, output, session) {
  
  output$country_option <- renderUI({
    selectizeInput(inputId = "country", label="1) Country:", choices = sort(unique(full_dat$area_name)), selected = "")
  })

  output$period_option <- renderUI({
    selectizeInput(inputId = "period", label = "2) Year:", choices=NULL, selected = '')
    # selectizeInput(inputId = "period", label = "2) Year:", choices=sort(unique(full_dat$period), decreasing=FALSE), selected = "")
  })

  output$age_option <- renderUI({
    # selectizeInput(inputId = "age", label = "3) Age group:", choices=naomi::get_age_groups() %>% 
    #                                                                    filter(age_group_sort_order %in% c(3, 16:29)) %>%
    #                                                                    arrange(age_group_sort_order) %>%
    #                                                                    .$age_group_label, 
    #                selected = "")
    selectizeInput(inputId = "age", label = "3) Age group:", choices=NULL, selected = '')
  })

  output$sex_option <- renderUI({
    selectizeInput(inputId = "sex", label = "4) Sex:", choices= NULL, selected= '')
  })
  
  observeEvent(input$country, {
    
    sankey_inputs$links_dat <- NULL
    sankey_inputs$node_df <- NULL
    
    period_input_choices <- full_dat %>%
      select(area_name, period) %>%
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
    
    sankey_inputs$links_dat <- NULL
    sankey_inputs$node_df <- NULL
    
    age_input_choices <- full_dat %>%
      select(area_name, period, age_group_sort_order, age_group) %>%
      filter(area_name == input$country,
             period == input$period) %>%
      arrange(age_group_sort_order) %>%
      .$age_group %>%
      unique
    
    updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "age", choices = age_input_choices, selected = "")
    
    # enable("age")
    # disable("sex")
    
  })
  
  observeEvent(input$age, {
    
    sankey_inputs$links_dat <- NULL
    sankey_inputs$node_df <- NULL
    
    sex_input_choices <- full_dat %>%
      select(area_name, period, age_group_sort_order, age_group, sex) %>%
      filter(area_name == input$country,
             period == input$period,
             age_group == input$age) %>%
      .$sex %>%
      unique
    
    updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "sex", choices = sex_input_choices, selected = "")
    
    # enable("sex")
    
  })
  
}