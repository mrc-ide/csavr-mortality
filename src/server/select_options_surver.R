select_options_surver <- function(input, output, session) {
  
  output$country_option <- renderUI({
    selectizeInput(inputId = "country", label="1) Country:", choices = c("Choose a country" = "", sort(unique(full_dat$area_name))))
  })

  output$period_option <- renderUI({
    shinyjs::disabled(selectizeInput(inputId = "period", label = "2) Year:", choices=NULL, selected = ''))
  })

  output$age_option <- renderUI({
    shinyjs::disabled(selectizeInput(inputId = "age", label = "3) Age group:", choices=NULL, selected = ''))
  })

  output$sex_option <- renderUI({
    shinyjs::disabled(selectizeInput(inputId = "sex", label = "4) Sex:", choices= NULL, selected= ''))
  })
  
  observe({
    
    if(input$tabs == "time_trend") {
      
      shinyjs::disable("period")
      shinyjs::disable("age")
      shinyjs::disable("sex")
      
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "period", choices = "", selected = "")
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "age", choices = "15+", selected = "15+")
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "sex", choices = "both", selected = "both")
      
      tab_watcher <<- "time_trend"
      
    } else if(input$tabs != "time_trend" & tab_watcher == "time_trend") {
      
      shinyjs::enable("period")
      shinyjs::enable("age")
      shinyjs::enable("sex")
      
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "age", choices = "", selected = "")
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "sex", choices = "", selected = "")
      
      period_input_choices <- full_dat %>%
        select(area_name, period) %>%
        filter(area_name == input$country) %>%
        .$period %>%
        unique %>%
        as.numeric %>%
        sort(decreasing = FALSE)
      
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "period", choices = period_input_choices, selected = "")
      
      tab_watcher <<- "not_time_trend"
      
    } 
    
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
    
    if(input$tabs == "time_trend") {
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "period", choices = "", selected = "")
    } else {
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "period", choices = period_input_choices, selected = "")
    }
    
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
    
    if(input$tabs == "time_trend") {
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "age", choices = "15+", selected = "15+")
    } else {
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "age", choices = age_input_choices, selected = "")
    }
    
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
    
    if(input$tabs == "time_trend") {
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "sex", choices = "both", selected = "both")
    } else {
      updateSelectizeInput(session = getDefaultReactiveDomain(), inputId = "sex", choices = sex_input_choices, selected = "")
    }
    
    # enable("sex")
    
  })
  
}