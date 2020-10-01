sankey_surver <- function(input, output) {

  links <- crossing("source" = 0:10,
           "target" = 11:13) %>%
    mutate("value"=sample(1:100, 33))
  
  links <- links %>% 
    bind_rows(
      crossing("source" = 14:24,
               "target" = 25:27) %>%
      mutate("value"=sample(1:100, 33))
    ) %>%
    bind_rows(
      links %>%
        group_by(target) %>%
        summarise(value = sum(value)) %>%
        ungroup %>%
        rename(source = target) %>%
        bind_cols(target = 25:27)
    ) %>%
    as.data.frame()
   
  nodes <- data.frame("name" = c(paste0("Garbage", 0:10), "HIV other", "HIV DR TB", "HIV", paste0("Misclassify", 0:10), "More HIV other", "More HIV DR TB", "More HIV")) %>%
    mutate(n = row_number()-1)
  
  output$sankey <- renderSankeyNetwork(
            sankeyNetwork(Links = links, Nodes = nodes, Source = "source",
                Target = "target", Value = "value", NodeID = "name",
                units = "TWh", fontSize = 12, nodeWidth = 30, iterations = 0)
  )

}

