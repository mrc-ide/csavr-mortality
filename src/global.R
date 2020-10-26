# full_dat <- readRDS("src/clean_dat.rds")
full_dat <- readRDS("clean_dat.rds")


# group <- read.csv("src/ihme_mortality_group.csv")
# group <- group %>%
#   filter(area_name != "U.S. Virgin Isl") %>%
#   mutate(iso3 = countrycode(area_name, "country.name", "iso3c"))
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
# full_dat <- garbage %>%
#   bind_rows(misclassification) %>%
#   select(iso3, area_name, period, age_group, sex_id, flow, state, source_state, source, source_id, target, target_state, target_id, deaths) %>%
#   left_join(group %>% select(iso3, group)) %>%
#   filter(!is.na(group),
#          target != "hiv_tb_other"
#   )

# saveRDS(full_dat, "clean_dat.rds")
