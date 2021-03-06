sankey_surver <- function(input, output, session) {

  sankey_inputs <<- reactiveValues()
  time_trend <- reactiveValues()
  tab_watcher <<- "time_trend"
  
  full_dat <<- readRDS("single_flow_testing_dat.rds")
  gbd19 <- read_csv("gbd19_hiv_deaths.csv")


  ##############################################################################
  ## Two step flow not being used, but keep commented for future use perhaps? ##
  ##############################################################################

  # observe({
  # 
  #   req(input$country, input$age, input$sex, input$period)
  #   
  #   shinyjs::show("titles")
  # 
  #   dat <- full_dat %>%
  #     filter(area_name == input$country,
  #            age_group == input$age,
  #            sex == input$sex,
  #            period == as.integer(input$period)
  #     )
  # 
  #   sum_intermediate <- dat %>%
  #     filter(flow == "Garbage") %>%
  #     group_by(iso3, area_name, period, age_group, sex, target) %>%
  #     summarise(deaths = sum(deaths)) %>%
  #     mutate(source = target,
  #            flow = "Intermediate",
  #            state = 2,
  #            source_state = 2,
  #            target_state = 3) %>%
  #     ungroup()
  # 
  #   dat <- dat %>%
  #     bind_rows(sum_intermediate)
  # 
  #   sankey_inputs$node_df <- dat %>%
  #     select(source, source_state) %>%
  #     rename(node = source, val = source_state) %>%
  #     bind_rows(
  #       dat %>%
  #         select(target, target_state) %>%
  #         rename(node = target, val = target_state)
  #     ) %>%
  #     distinct() %>%
  #     mutate(arr = ifelse(str_detect(node, "HIV/"), 1, 2)) %>%
  #     group_by(val) %>%
  #     arrange(val, arr, node) %>%
  #     ungroup %>%
  #     mutate(id = row_number()-1)
  # 
  #   sankey_inputs$links_dat <- dat %>%
  #     select(source, target, deaths, source_state, target_state) %>%
  #     left_join(
  #       sankey_inputs$node_df %>%
  #         rename(source_node_id = id),
  #       by=c("source" = "node", "source_state" = "val")
  #     ) %>%
  #     left_join(
  #       sankey_inputs$node_df %>%
  #         rename(target_node_id = id),
  #       by=c("target" = "node", "target_state" = "val")
  #     )
  # 
  # 
  # })
  
  ######################################
  
  observe({

    req(input$country, input$age, input$sex, input$period, input$tabs != "time_trend")

    dat <- full_dat %>%
      filter(area_name == input$country,
             age_group == input$age,
             sex == input$sex,
             period == as.integer(input$period)
      )
    
    sankey_inputs$node_df <- dat %>%
      select(source, source_state, flow) %>%
      rename(node = source, val = source_state) %>%
      bind_rows(
        dat %>%
          select(target, target_state) %>%
          rename(node = target, val = target_state)
      ) %>%
      distinct() %>%
      mutate(arr = ifelse(str_detect(node, "HIV/"), 1, 2)) %>%
      group_by(val) %>%
      arrange(val, flow, arr, node) %>%
      ungroup %>%
      mutate(id = row_number()-1,
             color = factor(1))

    sankey_inputs$links_dat <- dat %>%
      select(flow, source, target, deaths, source_state, target_state) %>%
      left_join(
        sankey_inputs$node_df %>%
          rename(source_node_id = id) %>%
          select(node, val, source_node_id),
        by=c("source" = "node", "source_state" = "val")
      ) %>%
      left_join(
        sankey_inputs$node_df %>%
          rename(target_node_id = id) %>%
          select(node, val, target_node_id),
        by=c("target" = "node", "target_state" = "val")
      ) %>%
      mutate(flow = factor(flow))


  })
  
  
  observe({
    
    req(input$tabs == "time_trend",
        input$country)
    
    time_trend$data <- full_dat %>%
      filter(area_name == input$country,
             age_group == "15+",
             sex == "both"
      )
    
    time_trend$gbd19 <- gbd19 %>%
      filter(area_name == input$country)
    
  })
  
  cod_df <- reactive({
    
    req(sankey_inputs$links_dat)
    
    sankey_inputs$links_dat %>%
      mutate(Country = input$country,
             "Age group" = input$age,
             Year = input$period,
             Sex = input$sex,
             ## Required for the two flow setup
             # Flow = ifelse(source_state == 1, "Garbage", "Misclassification"),
             # Flow = ifelse((source == target & Flow == "Garbage"), "-", Flow),
             # Flow = factor(Flow, levels = c("-", "Garbage", "Misclassification"))
      ) %>%
      # filter(!(Flow == "Misclassification" & source == target)) %>% ## Required for the two flow setup
      arrange(flow) %>%
      rename("Origin COD" = source,
             "Reallocated COD" = target,
             Deaths = deaths,
             Flow = flow
      ) %>%
      select(Country, Year, "Age group", Sex, Flow, "Origin COD", "Reallocated COD", Deaths)
    
  })
  
  output$time_trend_plot <- renderPlot({
    
    validate(
      need(time_trend$data, "Please select a country")
    )
    
    shinyjs::show("gbd_text")
    
    time_trend$data %>%
      group_by(period, flow) %>%
      summarise(deaths = sum(deaths)) %>%
      ungroup %>%
      mutate(flow = recode(flow, 
                           "Correctly coded" = "Deaths coded as HIV/AIDS",
                           "Garbage" = "Deaths coded as ‘garbage’ codes reallocated to HIV/AIDS",
                           "Misclassification" = "Deaths coded as other causes reclassified to HIV/AIDS"),
             flow = factor(flow, levels=c(
               "Deaths coded as HIV/AIDS",
               "Deaths coded as ‘garbage’ codes reallocated to HIV/AIDS",
               "Deaths coded as other causes reclassified to HIV/AIDS"
             ))
            ) %>%
      ggplot(aes(x=period, y=deaths)) +
      geom_col(aes(group=fct_rev(flow), fill=flow)) +
      geom_point(data = time_trend$gbd19, aes(color=source), size=1.2) +
      geom_line(data = time_trend$gbd19, aes(color=source), size=1) +
      theme_minimal() +
      scale_fill_manual(values=c("Deaths coded as HIV/AIDS" = "#3B9AB2",
                                 "Deaths coded as ‘garbage’ codes reallocated to HIV/AIDS" = "#E1AF00",
                                 "Deaths coded as other causes reclassified to HIV/AIDS" = "#F21A00")) +
      scale_color_manual(values = c("AIDS deaths" = "#000000")) +
      labs(y="AIDS deaths", x=element_blank(), fill = "Source of AIDS deaths", color = "GBD2019") +
      theme(
        legend.position = "bottom",
        text = element_text(size=14),
        axis.text = element_text(size=14)
      )
    
  })
  
  output$sankey <- renderSankeyNetwork({
    
    # req(sankey_inputs$links_dat)
    
    validate(
      need(sankey_inputs$links_dat, "Please select a country, year, age group, and sex")
    )
    
    my_color <- 'd3.scaleOrdinal() .domain(["Original", "Garbage", "Misclassification", "1"]) .range(["#3B9AB2", "#E1AF00", "#F21A00", "lightgrey"])'
    
    sn <- sankeyNetwork(Links = sankey_inputs$links_dat, Nodes = sankey_inputs$node_df, Source = "source_node_id",
                        Target = "target_node_id", Value = "deaths", NodeID = "node",
                        units = "deaths", fontSize = 14, nodePadding = 12, nodeWidth = 30, iterations = 0,
                        colourScale=my_color, LinkGroup="flow", NodeGroup="color",
                        margin=list("right" = 400))
    
    sn <- onRender(
      sn,
      '
          function(el,x){
            // select all our node text
            d3.select(el)
            .selectAll(".node text")
            // .filter(function(d) { return d.name.startsWith("Disease"); })
            .attr("x", x.options.nodeWidth - 40)
            .attr("text-anchor", "end");
          }
        '
    )
    
    return(sn)
    
  })


  output$links_sankey_df <- renderDT({

    # req(sankey_inputs$links_dat)
    
    validate(
      need(sankey_inputs$links_dat, "Please select a country, year, age group, and sex")
    )

    cod_df()
    
  }, options = list(pageLength = 1000, info = FALSE))
  
  output$download_data_table <- downloadHandler(
    
    filename = function() {
      paste(input$country, input$age, input$period, "cod.xlsx", sep="_")
    },
    content = function(file) {
      
      meta <- filter(citations, iso3 == countrycode(input$country, "country.name", "iso3c"), period == input$period)
      
      write_xlsx(x = list(
        "Metadata" = meta,
        "CoD data" = cod_df()
      ), file)
    }
  )


  
  



}