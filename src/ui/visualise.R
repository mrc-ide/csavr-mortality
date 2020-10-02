visualise <- function() {
    div(style="margin-left:2%; margin-right: 2%",
        h2("Visualise data"),
        br(),
        fluidRow(
          column(3, uiOutput("country_option")),
          column(2, uiOutput("year_option")),
          column(2, uiOutput("age_option")),
          column(2, uiOutput("sex_option"))
          # column(3, selectInput("country_option1", "foo", "foo")),
          # column(2, selectInput("country_option2", "foo", "foo")),
          # column(2, selectInput("country_option3", "foo", "foo")),
          # column(2, selectInput("country_option4", "foo", "foo"))
        ),
        sankeyNetworkOutput("sankey")
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
