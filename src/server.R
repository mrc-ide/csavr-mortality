server <- function(input, output, session) {
  
  data_prep_surver(input, output, session)
  sankey_surver(input, output, session)
  select_options_surver(input, output, session)
  
}