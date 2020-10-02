sankey_surver <- function(input, output, session) {
  
  # cats <- list()
  # cats$iso3 <- c("MWI", "ZMB", "ZWE", "MOZ", "ETH")
  # cats$age_groups <- get_age_groups() %>% filter(age_group_id %in% 4:17) %>% .$age_group
  # cats$sex <- c("female", "male", "both")
  # cats$period <- 1980:2018
  # 
  # links <<- crossing(
  #           "iso3" = cats$iso3,
  #           "period" = cats$period,
  #           "sex" = cats$sex,
  #           "age_group" = cats$age_groups,
  #           "source_label" = paste0("Disease", 0:10),
  #           "type" = "garbage",
  #           "target_label" = "HIV intermediate")
  # 
  # links <- links %>%
  #   mutate("value"=sample(1:100, nrow(.), replace=TRUE))
  # 
  # links <- links %>%
  #   bind_rows(
  #     links %>%
  #       group_by(iso3, age_group, period, sex, target_label) %>%
  #       summarise(value = sum(value)) %>%
  #       ungroup %>%
  #       rename(source_label = target_label) %>%
  #       bind_cols(target_label = "HIV final") %>%
  #       mutate(type = "intermediate")
  #   )
  # 
  # links <- links %>%
  #   bind_rows(
  #     crossing(
  #       "iso3" = cats$iso3,
  #       "period" = cats$period,
  #       "sex" = cats$sex,
  #       "age_group" = cats$age_group,
  #       "source_label" = paste0("Disease", 12:22),
  #       "type" = "misclassify",
  #       "target_label" = "HIV final") %>%
  #       mutate("value"=sample(1:100, nrow(.), replace=TRUE))
  #   ) %>%
  #   as.data.frame() %>%
  #   type.convert()
  
  links <<- read.csv("example_data.csv")
  
  nodes_sankey <- reactive(
    links %>%
      filter(iso3 == input$country,
             age_group %in% input$age,
             sex == input$sex,
             period == as.integer(input$period)
      ) %>%
      # filter(iso3 == "MWI",
      #        age_group %in% "20-24",
      #        sex == "both",
      #        period == 2016
      # ) %>%
      select(source_label, type) %>%
      bind_rows(data.frame(source_label = "HIV final", type="final")) %>%
      rename(name = source_label) %>%
      mutate(source = row_number()-1)
  )
  
  links_sankey <- reactive(
    links %>%
      filter(iso3 == input$country,
             age_group %in% input$age,
             sex == input$sex,
             period == as.integer(input$period)
      ) %>%
      # filter(iso3 == "MWI",
      #        age_group %in% "20-24",
      #        sex == "both",
      #        period == 2016
      # ) %>%
      left_join(nodes_sankey() %>% select(-type), by=c("source_label" = "name")) %>%
      left_join(nodes_sankey() %>% select(-type) %>% rename(target = source), by=c("target_label" = "name"))
      
  )
  
  output$links_sankey_df <- renderDT({
    links_sankey() %>%
      rename(Country = iso3,
             Year = period,
             Sex = sex,
             "Age Group" = age_group,
             "Origin COD" = source_label,
             "Reallocated COD" = target_label,
             Deaths = value
             ) %>%
      select(-c(X, type, source, target)) %>%
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
  
  sn <- sankeyNetwork(Links = links_sankey(), Nodes = nodes_sankey(), Source = "source",
                Target = "target", Value = "value", NodeID = "name",
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