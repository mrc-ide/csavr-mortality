sankey_surver <- function(input, output, session) {
  
  cats <- list()
  cats$iso3 <- c("MWI", "ZMB", "ZWE", "MOZ", "ETH")
  cats$age_groups <- get_age_groups() %>% filter(age_group_id %in% 4:17) %>% .$age_group
  cats$sex <- c("female", "male", "both")
  cats$period <- 1980:2018

  links <<- crossing(
            "iso3" = cats$iso3,
            "period" = cats$period,
            "sex" = cats$sex,
            "age_group" = cats$age_groups,
            "source" = 0:10,
            "target" = 11)

  links <- links %>%
    mutate("value"=sample(1:100, nrow(.), replace=TRUE))

  links <- links %>%
    bind_rows(
      links %>%
        group_by(iso3, age_group, period, sex, target) %>%
        summarise(value = sum(value)) %>%
        ungroup %>%
        rename(source = target) %>%
        bind_cols(target = 23)
    )

  df_sankey <- links %>%
    bind_rows(
      crossing(
        "iso3" = cats$iso3,
        "period" = cats$period,
        "sex" = cats$sex,
        "age_group" = cats$age_group,
        "source" = 12:22,
        "target" = 23) %>%
        mutate("value"=sample(1:100, nrow(.), replace=TRUE))
    ) %>%
    filter(iso3=="ETH", sex == "male", age_group == "15-19", period == 2018) %>%
    as.data.frame() %>%
    type.convert()

  nodes <- data.frame("name" = c(paste0("Garbage", 0:10), "HIV", paste0("Misclassify", 0:10), "More HIV")) %>%
    mutate(source_id = row_number()-1)
  
  output$sankey <- renderSankeyNetwork({
            sankeyNetwork(Links = df_sankey, Nodes = nodes, Source = "source",
                Target = "target", Value = "value", NodeID = "name",
                units = "TWh", fontSize = 12, nodeWidth = 30, iterations = 0)
  })

}