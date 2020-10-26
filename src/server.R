server <- function(input, output) {
  
  # data_prep_surver(input, output)
  sankey_surver(input, output, session)
  select_options_surver(input, output, session)
  
}