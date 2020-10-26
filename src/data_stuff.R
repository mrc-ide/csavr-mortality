library(countrycode)
library(tidyverse)

group <- read.csv("src/ihme_mortality_group.csv")
group <- group %>%
  filter(area_name != "U.S. Virgin Isl") %>%
  mutate(iso3 = countrycode(area_name, "country.name", "iso3c"))

garbage <- read.csv("~/Dropbox/oli backup/clean_hiv_redistribution_data.csv") %>%
  filter(country == location_name,
         age_group_id %in% 8:18) %>%
  mutate(age_group = str_replace(age_group_name, " to ", "-"),
         iso3 = countrycode(country, "country.name", "iso3c"),
         area_name = countrycode(iso3, "iso3c", "country.name"),
         flow = "Garbage",
         state = 1,
         source_state = 1,
         target_state = 2) %>%
  select(-c(country, location_name, age_group_id, age_group_name)) %>%
  rename(period = year_id,
         target = acause,
         source = package_description,
         source_id = cause_id
  )
         
misclassification <- read.csv("~/Downloads/clean_hiv_correction_results.csv")
location <- read.csv("~/Downloads/ids_35_Model Results_Round 7.csv") %>%
  select(location_id, local_id)

misclassification <- misclassification %>%
  filter(age_group_id %in% 8:18) %>%
  mutate(age_group = str_replace(age_group_name, " to ", "-")) %>%
  select(-c(age_group_id, age_group_name)) %>%
  left_join(location) %>%
  filter(str_length(local_id) == 3, !grepl("[0-9]", .$local_id)) %>%
  mutate(iso3 = countrycode(location_name, "country.name", "iso3c"),
         area_name = countrycode(iso3, "iso3c", "country.name"),
         flow = "Misclassification",
         state = 2,
         source_state = 2,
         target_state = 3) %>%
  rename(period = year_id,
         target = target_acause,
         source = acause,
         source_id = cause_id,
         target_id = target_cause_id,
         deaths = deaths_moved_to_target
  ) %>%
  select(-c(location_name, local_id, location_id))

full_dat <- garbage %>%
  bind_rows(misclassification) %>%
  select(iso3, area_name, period, age_group, sex_id, flow, state, source_state, source, source_id, target, target_state, target_id, deaths) %>%
  left_join(group %>% select(iso3, group)) %>%
  filter(!is.na(group),
         target != "hiv_tb_other"
  )

dat <- reactive(
    full_dat %>%
      filter(iso3 == input$country,
             age_group %in% input$age,
             sex == input$sex,
             period == as.integer(input$period)
      )
  )


sum_intermediate <- reactive(
  dat %>%
    filter(flow == "Garbage") %>%
    group_by(iso3, area_name, period, age_group, sex_id, target) %>%
    summarise(deaths = sum(deaths)) %>%
    mutate(source = target,
           flow = "Intermediate",
           state = 2,
           source_state = 2,
           target_state = 3)
)

dat() <- dat() %>%
  bind_rows(sum_intermediate())

node_df <- reactive(
  dat %>%
    select(source, source_state) %>%
    rename(node = source, val = source_state) %>%
    bind_rows(
      dat %>%
        select(target, target_state) %>%
        rename(node = target, val = target_state)
    ) %>%
    distinct() %>%
    group_by(val) %>%
    mutate(n = row_number()) %>%
    arrange(val, desc(n)) %>%
    select(-n) %>%
    ungroup %>%
    mutate(id = row_number()-1)
)
  
# int %>%
#   select(target, state, source_state, target_state) %>%
#   distinct()
#   bind_rows(
#     int %>%
#       filter(flow == "Intermediate") %>%
#       mutate(state = 3) %>%
#       select(target, state, source_state, target_state)
#   ) %>%
#   rename(node = target) %>%
#   filter(state > 2) %>% # This will change when we get correct HIV deaths to be 1 or 3
#   bind_rows(int %>%
#               select(source, state, source_state, target_state) %>%
#               distinct() %>%
#               rename(node = source)
#               # mutate(source = TRUE) %>%
#               # filter(!node %in% c("hiv", "hiv_other"))) %>%
#   ) %>%
#   arrange(state) %>%
#   mutate(id = row_number()-1)

# node_df %>%
#   bind_rows(
#     node_df %>%
#       filter(node %in% c("hiv", "hiv_other"), state == 2) %>%
#       mutate(state = 3)
#   ) %>%
#   mutate(id = row_number()-1)

links_dat <- reactive(
  dat %>%
    select(source, target, deaths, source_state, target_state) %>%
    left_join(
      node_df %>%
        rename(source_node_id = id),
      by=c("source" = "node", "source_state" = "val")
    ) %>%
    left_join(
      node_df %>%
        rename(target_node_id = id),
      by=c("target" = "node", "target_state" = "val")
    )
)

sankeyNetwork(Links = links_dat(), Nodes = node_df(), Source = "source_node_id",
                    Target = "target_node_id", Value = "deaths", NodeID = "node",
                    units = "deaths", fontSize = 12, nodeWidth = 30, iterations = 0)
