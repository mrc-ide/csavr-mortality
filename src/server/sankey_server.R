sankey_surver <- function(input, output, session) {

  # browser()
  
  dat <- reactive(
    full_dat %>%
      filter(iso3 == input$country,
             age_group == input$age,
             sex == input$sex,
             period == as.integer(input$period)
      )
  )

  
  
  
  sum_intermediate <- reactive(
    dat() %>%
      filter(flow == "Garbage") %>%
      group_by(iso3, area_name, period, age_group, sex_id, target) %>%
      summarise(deaths = sum(deaths)) %>%
      mutate(source = target,
             flow = "Intermediate",
             state = 2,
             source_state = 2,
             target_state = 3)
  )
  
  dat_extend <- reactive(
    dat() %>%
      bind_rows(sum_intermediate())
  )
  
  node_df <- reactive(
    dat_extend() %>%
      select(source, source_state) %>%
      rename(node = source, val = source_state) %>%
      bind_rows(
        dat_extend() %>%
          select(target, target_state) %>%
          rename(node = target, val = target_state)
      ) %>%
      distinct() %>%
      group_by(val) %>%
      mutate(n = row_number()) %>%
      arrange(val, desc(n)) %>%
      select(-n) %>%
      ungroup %>%
      mutate(id = row_number()-1) %>%
      as.data.frame()
  )
  
  links_dat <- reactive(
    dat_extend() %>%
      select(source, target, deaths, source_state, target_state) %>%
      left_join(
        node_df() %>%
          rename(source_node_id = id),
        by=c("source" = "node", "source_state" = "val")
      ) %>%
      left_join(
        node_df() %>%
          rename(target_node_id = id),
        by=c("target" = "node", "target_state" = "val")
      )
  )
  
  output$links_sankey_df <- renderDT({
    links_dat() %>%
      mutate(Country = input$country,
             "Age group" = input$age_group,
             Year = input$period,
             Sex = input$sex,
             Flow = ifelse(source_state == 1, "Garbage", "Misclassification")) %>%
      rename("Origin COD" = source,
             "Reallocated COD" = target,
             Deaths = deaths
             ) %>%
      select(-c(source_state, target_state, source_node_id, target_node_id)) %>%
      mutate(Country = countrycode(Country, "iso3c", "country.name"))
  })
  
  # output$country_result <- renderText({input$country})
  # output$age_result <- renderText({input$age})
  # output$period_result <- renderText({input$period})
  # output$sex_result <- renderText({input$sex})
  # 
  # 
  # output$links_dt <- renderDT(links)
  # output$links_sankey_dt <- renderDT(links_sankey())
  # output$nodes_sankey_dt <- renderDT(nodes_sankey())

  # nodes <- data.frame("name" = c(paste0("Disease", 0:10), "HIV intermediate", paste0("Disease", 0:10), "HIV final")) %>%
  #   mutate(source_id = row_number()-1)
  # 
  # nodes_sankey <- reactive(
  #   nodes %>%
  #     filter(source_id %in% links_sankey()$source)
  # )
  
  output$sankey <- renderSankeyNetwork({
  
  sn <- sankeyNetwork(Links = links_dat(), Nodes = node_df(), Source = "source_node_id",
                      Target = "target_node_id", Value = "deaths", NodeID = "node",
                      units = "deaths", fontSize = 12, nodeWidth = 30, iterations = 0)
  
  # sn <- onRender(
  #   sn,
  #   '
  #     function(el,x){
  #       // select all our node text
  #       d3.select(el)
  #       .selectAll(".node text")
  #       .filter(function(d) { return d.name.startsWith("Disease"); })
  #       .attr("x", x.options.nodeWidth - 40)
  #       .attr("text-anchor", "end");
  #     }
  #   '
  # )
  
  return(sn)
  
  })
  
  # observe({
  #   req(input$width)
  #   
  #   sn_width <- input$width
  #   
  # })

}