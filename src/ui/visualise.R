visualise <- function() {
  div(style="margin-left:2%; margin-right: 2%",
      h2("Visualise data"),
      br(),
      fluidRow(
        column(3, uiOutput("country_option")),
        column(2, uiOutput("year_option")),
        column(2, uiOutput("age_option")),
        column(2, uiOutput("sex_option"))
      ),
      fluidRow(sankeyNetworkOutput("sankey"))
      # tabsetPanel(
      #   tabPanel(title = HTML("<b style='font-size:18px'>Sankey</b>"),
      #            fluidRow(
      #                     
      #            )
      #   ),
      #   tabPanel(title = HTML("<b style='font-size:18px'>Table</b>"),
      #   )
      # )
  )

  
}