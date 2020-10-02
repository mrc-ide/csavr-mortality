data_prep_surver <- function(input, output, session) {
  # 
  # cats <- list()
  # cats$iso3 <- c("MWI", "ZMB", "ZWE", "MOZ", "ETH")
  # cats$age_groups <- get_age_groups() %>% filter(age_group_id %in% 4:17) %>% .$age_group
  # cats$sex <- c("female", "male", "both")
  # cats$period <- 1980:2018
  # 
  # links <- crossing(
  #   "iso3" = cats$iso3,
  #   "period" = cats$period,
  #   "sex" = cats$sex,
  #   "age_group" = cats$age_groups,
  #   "source_label" = paste0("Disease", 0:10),
  #   "type" = "garbage",
  #   "target_label" = "HIV intermediate")
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
  
  
}