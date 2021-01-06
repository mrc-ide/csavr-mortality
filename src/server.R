server <- function(input, output, session) {
  
  # data_prep_surver(input, output)
  select_options_surver(input, output, session)
  methods_server(input, output, session)
  sankey_surver(input, output, session)

  
}