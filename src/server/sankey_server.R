sankey_surver <- function(input, output, session) {

  sankey_inputs <- reactiveValues()


  observe({

    req(input$country, input$age, input$sex, input$period)
    
    shinyjs::show("titles")

    dat <- full_dat %>%
      filter(area_name == input$country,
             age_group == input$age,
             sex == input$sex,
             period == as.integer(input$period)
      )

    sum_intermediate <- dat %>%
      filter(flow == "Garbage") %>%
      group_by(iso3, area_name, period, age_group, sex, target) %>%
      summarise(deaths = sum(deaths)) %>%
      mutate(source = target,
             flow = "Intermediate",
             state = 2,
             source_state = 2,
             target_state = 3) %>%
      ungroup()

    dat <- dat %>%
      bind_rows(sum_intermediate)

    sankey_inputs$node_df <- dat %>%
      select(source, source_state) %>%
      rename(node = source, val = source_state) %>%
      bind_rows(
        dat %>%
          select(target, target_state) %>%
          rename(node = target, val = target_state)
      ) %>%
      distinct() %>%
      mutate(arr = ifelse(str_detect(node, "HIV/"), 1, 2)) %>%
      group_by(val) %>%
      arrange(val, arr, node) %>%
      ungroup %>%
      mutate(id = row_number()-1)

    sankey_inputs$links_dat <- dat %>%
      select(source, target, deaths, source_state, target_state) %>%
      left_join(
        sankey_inputs$node_df %>%
          rename(source_node_id = id),
        by=c("source" = "node", "source_state" = "val")
      ) %>%
      left_join(
        sankey_inputs$node_df %>%
          rename(target_node_id = id),
        by=c("target" = "node", "target_state" = "val")
      )


  })


  output$links_sankey_df <- renderDT({

    req(sankey_inputs$links_dat)

    sankey_inputs$links_dat %>%
      mutate(Country = input$country,
             "Age group" = input$age,
             Year = input$period,
             Sex = input$sex,
             Flow = ifelse(source_state == 1, "Garbage", "Misclassification"),
             Flow = ifelse((source == target & Flow == "Garbage"), "-", Flow),
             Flow = factor(Flow, levels = c("-", "Garbage", "Misclassification"))
      ) %>%
      filter(!(Flow == "Misclassification" & source == target)) %>%
      arrange(Flow) %>%
      rename("Origin COD" = source,
             "Reallocated COD" = target,
             Deaths = deaths
             ) %>%
      select(Country, Year, "Age group", Sex, Flow, "Origin COD", "Reallocated COD", Deaths)
  }, options = list(pageLength = 1000, info = FALSE))


  output$sankey <- renderSankeyNetwork({

    req(sankey_inputs$links_dat)

      sn <- sankeyNetwork(Links = sankey_inputs$links_dat, Nodes = sankey_inputs$node_df, Source = "source_node_id",
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


}