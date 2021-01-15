group <- read.csv("src/ihme_mortality_group.csv")
group <- group %>%
  filter(area_name != "U.S. Virgin Isl") %>%
  mutate(iso3 = countrycode(area_name, "country.name", "iso3c"))

###############################################
#### DATA MANIPULATION FOR TWO STAGE FLOW #####
###############################################

# raw_hiv <- read.csv("~/Downloads/cod_raw.csv")
# 
# raw_hiv <- raw_hiv %>%
#   mutate(age_group = str_replace(age_group_name, " to ", "-")) %>%
#   rename(iso3 = ihme_loc_id, 
#          period = year_id) %>%
#   filter(str_length(iso3) == 3,
#          !grepl("[0-9]", .$iso3),
#          str_detect(age_group, "-"),
#          !str_detect(age_group, "months"),
#          !age_group %in% c("2-4", "5-9", "10-14")
#   ) %>%
#   mutate(area_name = countrycode(iso3, "iso3c", "country.name")) %>%
#   select(iso3, area_name, period, age_group, sex_id, deaths = deaths_raw) %>%
#   mutate(target = "hiv",
#          source = "hiv",
#          flow = "Garbage",
#          state = 1,
#          source_state = 1,
#          target_state = 2)
# 
# garbage <- read.csv("~/Dropbox/oli backup/clean_hiv_redistribution_data.csv") %>%
#   filter(country == location_name,
#          age_group_id %in% 8:18) %>%
#   mutate(age_group = str_replace(age_group_name, " to ", "-"),
#          iso3 = countrycode(country, "country.name", "iso3c"),
#          area_name = countrycode(iso3, "iso3c", "country.name"),
#          flow = "Garbage",
#          state = 1,
#          source_state = 1,
#          target_state = 2) %>%
#   select(-c(country, location_name, age_group_id, age_group_name)) %>%
#   rename(period = year_id,
#          target = acause,
#          source = package_description,
#          source_id = cause_id
#   )
# 
# garbage <- raw_hiv %>%
#   bind_rows(garbage)
#          
# misclassification <- read.csv("~/Downloads/clean_hiv_correction_results.csv")
# location <- read.csv("~/Downloads/ids_35_Model Results_Round 7.csv") %>%
#   select(location_id, local_id)
# 
# misclassification <- misclassification %>%
#   filter(age_group_id %in% 8:18) %>%
#   mutate(age_group = str_replace(age_group_name, " to ", "-")) %>%
#   select(-c(age_group_id, age_group_name)) %>%
#   left_join(location) %>%
#   filter(str_length(local_id) == 3, !grepl("[0-9]", .$local_id)) %>%
#   mutate(iso3 = countrycode(location_name, "country.name", "iso3c"),
#          area_name = countrycode(iso3, "iso3c", "country.name"),
#          flow = "Misclassification",
#          state = 2,
#          source_state = 2,
#          target_state = 3) %>%
#   rename(period = year_id,
#          target = target_acause,
#          source = acause,
#          source_id = cause_id,
#          target_id = target_cause_id,
#          deaths = deaths_moved_to_target
#   ) %>%
#   select(-c(location_name, local_id, location_id))
# 
# 
# full_dat <- garbage %>%
#   bind_rows(misclassification) %>%
#   select(iso3, area_name, period, age_group, sex_id, flow, state, source_state, source, source_id, target, target_state, target_id, deaths) %>%
#   # left_join(group %>% select(iso3, group)) %>%
#   # filter(!is.na(group)) %>%
#   mutate(sex = ifelse(sex_id == 1, "male", "female"),
#          source = recode(source, "hiv" = "HIV/AIDS",
#                                   "hiv_other" = "HIV/AIDS resulting in other disease",
#                                   "hiv_tb_other" = "HIV/TB resulting in other disease"),
#                   target = recode(target, "hiv" = "HIV/AIDS",
#                                   "hiv_other" = "HIV/AIDS resulting in other disease",
#                                   "hiv_tb_other" = "HIV/TB resulting in other disease")
#            ) 
# 
# 
# full_dat_both <- full_dat %>%
#   group_by(iso3, area_name, period, age_group, flow, state, source_state, source, source_id, target, target_state, target_id) %>%
#   summarise(deaths = sum(deaths)) %>%
#   mutate(sex = "both")
# 
# full_dat <- full_dat %>%
#   bind_rows(full_dat_both)
# 
# full_dat_15_plus <- full_dat %>%
#   group_by(iso3, area_name, period, sex, flow, state, source_state, source, source_id, target, target_state, target_id) %>%
#   summarise(deaths = sum(deaths)) %>%
#   mutate(age_group = "15+")
# 
# full_dat <- full_dat %>%
#   bind_rows(full_dat_15_plus)
# 
# df <- full_dat %>%
#   filter(deaths > 0.5) %>%
#   mutate(deaths = round(deaths, 1)) %>%
#   left_join(naomi::get_age_groups() %>% select(age_group_label, age_group_sort_order), by=c("age_group" = "age_group_label")) %>%
#   mutate(age_group_sort_order = ifelse(is.na(age_group_sort_order), 29, as.numeric(age_group_sort_order))) %>%
#   group_by(iso3, area_name, period, sex, age_group_sort_order, flow, state, source_state, source, source_id, target, target_state, target_id) %>%
#   summarise(deaths = sum(deaths)) %>%
#   left_join(naomi::get_age_groups() %>% select(age_group_label, age_group_sort_order)) %>%
#   rename(age_group = age_group_label) %>%
#   ungroup
# 
# saveRDS(df, "src/testing_dat.rds")

##################################

raw_hiv <- read.csv("~/Downloads/cod_raw.csv")

raw_hiv <- raw_hiv %>%
  mutate(age_group = str_replace(age_group_name, " to ", "-")) %>%
  rename(period = year_id) %>%
  separate(ihme_loc_id, into=c("iso3", "extra"), sep=3) %>%
  group_by(iso3, period, sex_id, age_group) %>%
  summarise(deaths = sum(deaths_raw)) %>%
  ungroup %>%
  filter(str_detect(age_group, "-"),
         !str_detect(age_group, "months"),
         !age_group %in% c("2-4", "5-9", "10-14")
  ) %>%
  mutate(area_name = countrycode(iso3, "iso3c", "country.name")) %>%
  # select(iso3, area_name, period, age_group, sex_id, deaths) %>%
  mutate(target = "hiv",
         source = "hiv",
         flow = "Correctly coded",
         # state = 1,
         source_state = 1,
         target_state = 2)

garbage <- read.csv("~/Dropbox/oli backup/clean_hiv_redistribution_data.csv") %>%
  filter(country == location_name,
         age_group_id %in% 8:18) %>%
  mutate(age_group = str_replace(age_group_name, " to ", "-"),
         iso3 = countrycode(country, "country.name", "iso3c"),
         area_name = countrycode(iso3, "iso3c", "country.name"),
         flow = "Garbage",
         # state = 1,
         source_state = 1,
         target_state = 2) %>%
  select(-c(country, location_name, age_group_id, age_group_name)) %>%
  rename(period = year_id,
         target = acause,
         source = package_description,
         source_id = cause_id
  )

garbage <- raw_hiv %>%
  bind_rows(garbage)

misclassification <- read.csv("~/Downloads/clean_hiv_correction_results.csv")
location <- read.csv("src/area_hierarchy.csv")
full_names <- read.csv("src/shorthand_to_full_cause_names.csv")

misclassification <- misclassification %>%
  filter(age_group_id %in% 8:18) %>%
  mutate(age_group = str_replace(age_group_name, " to ", "-")) %>%
  select(-c(age_group_id, age_group_name)) %>%
  left_join(location %>% select(location_id, ihme_loc_id)) %>%
  separate(ihme_loc_id, into=c("iso3", "extra"), sep=3) %>%
  group_by(iso3, year_id, acause, target_acause, sex_id, age_group) %>%
  summarise(deaths = sum(deaths_moved_to_target)) %>%
  ungroup %>%
  mutate(area_name = countrycode(iso3, "iso3c", "country.name"),
         flow = "Misclassification",
         # state = 2,
         source_state = 1,
         target_state = 2) %>%
  left_join(full_names) %>%
  rename(period = year_id,
         target = target_acause,
         source = cause_name,
         # source_id = cause_id,
         # target_id = target_cause_id,
         # deaths = deaths_moved_to_target
  ) %>%
  select(-acause)

full_dat <- garbage %>%
  bind_rows(misclassification) %>%
  select(iso3, area_name, period, age_group, sex_id, flow, source_state, source, target, target_state, deaths) %>%
  # left_join(group %>% select(iso3, group)) %>%
  # filter(!is.na(group)) %>%
  mutate(sex = ifelse(sex_id == 1, "male", "female"),
         source = recode(source, "hiv" = "HIV/AIDS",
                         "hiv_other" = "HIV/AIDS resulting in other disease",
                         "hiv_tb_other" = "HIV/TB resulting in other disease"),
         target = recode(target, "hiv" = "HIV/AIDS",
                         "hiv_other" = "HIV/AIDS resulting in other disease",
                         "hiv_tb_other" = "HIV/TB resulting in other disease")
  ) 


full_dat_both <- full_dat %>%
  group_by(iso3, area_name, period, age_group, flow, source_state, source, target, target_state) %>%
  summarise(deaths = sum(deaths)) %>%
  ungroup %>%
  mutate(sex = "both")

full_dat <- full_dat %>%
  bind_rows(full_dat_both)

full_dat_15_plus <- full_dat %>%
  group_by(iso3, area_name, period, sex, flow, source_state, source, target, target_state) %>%
  summarise(deaths = sum(deaths)) %>%
  ungroup %>%
  mutate(age_group = "15+")

full_dat <- full_dat %>%
  bind_rows(full_dat_15_plus) %>%
  mutate(flow = ifelse(str_detect(source, "HIV correction"), "Misclassification", flow))

df <- full_dat %>%
  filter(deaths > 0.5) %>%
  mutate(deaths = round(deaths, 1)) %>%
  left_join(naomi::get_age_groups() %>% select(age_group_label, age_group_sort_order), by=c("age_group" = "age_group_label")) %>%
  mutate(age_group_sort_order = ifelse(is.na(age_group_sort_order), 29, as.numeric(age_group_sort_order))) %>%
  group_by(iso3, area_name, period, sex, age_group_sort_order, flow, source_state, source, target, target_state) %>%
  summarise(deaths = sum(deaths)) %>%
  ungroup %>%
  left_join(naomi::get_age_groups() %>% select(age_group_label, age_group_sort_order)) %>%
  rename(age_group = age_group_label)

saveRDS(df, "src/single_flow_testing_dat.rds")

full_dat <- readRDS("src/single_flow_testing_dat.rds")


##########################
### TESTING THE SANKEY ###
##########################

dat <- full_dat %>%
  filter(iso3 == "BRA",
         # period == 2012,
         age_group == "15+",
         sex == "both")

node_df <- 
  dat %>%
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

links_dat <- 
  dat %>%
  select(flow, source, target, deaths, source_state, target_state) %>%
  left_join(
    node_df %>%
      rename(source_node_id = id) %>%
      select(node, val, source_node_id),
    by=c("source" = "node", "source_state" = "val")
  ) %>%
  left_join(
    node_df %>%
      rename(target_node_id = id) %>%
      select(node, val, target_node_id),
    by=c("target" = "node", "target_state" = "val")
  ) %>%
  mutate(flow = ifelse(source == target, "Original", flow),
         flow = factor(flow))

links$group <- as.factor(c("type_a","type_a","type_a","type_b","type_b","type_b"))


nodes$group <- as.factor(c("my_unique_group"))

my_color <- 'd3.scaleOrdinal() .domain(["Original", "Garbage", "Misclassification", "1"]) .range(["#3B9AB2", "#E1AF00", "#F21A00", "lightgrey"])'

sankeyNetwork(Links = links_dat, Nodes = node_df, Source = "source_node_id",
              Target = "target_node_id", Value = "deaths", NodeID = "node",
              units = "deaths", fontSize = 12, nodeWidth = 30, iterations = 0,
              colourScale=my_color, LinkGroup="flow", NodeGroup="color")


citations <- citations %>%
  separate(iso3, into=c("iso3", "extra"), sep=3) %>%
  select(-c(extra, area_name)) %>%
  distinct %>%
  mutate(area_name = countrycode(iso3, "iso3c", "country.name")) %>%
  select(iso3, area_name, period, source_citation, note)

readr::write_csv(citations, "src/citations.csv")

foo <- read_csv("src/citations.csv")

######################

gbd_19 <- read_csv("~/Downloads/IHME-GBD_2019_DATA-420db19e-1/IHME-GBD_2019_DATA-420db19e-1.csv")

df <- gbd_19 %>%
  group_by(location_name, year) %>%
  summarise(deaths = sum(val)) %>%
  ungroup %>%
  mutate(iso3 = countrycode(location_name, "country.name", "iso3c"),
         area_name = countrycode(iso3, "iso3c", "country.name"),
         source = "AIDS deaths"
  ) %>%
  select(-location_name) %>%
  rename(period = year)

write_csv(df, "src/gbd19_hiv_deaths.csv")
  
