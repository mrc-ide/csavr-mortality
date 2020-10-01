visualise <- function() {
  div(style="margin-left:2%; margin-right: 2%",
      h2("Visualise data"),
      br(),
      fluidRow(
        column(3, 
               selectInput("country", "Country:",
                    list(
                         `EECA` = list("Ukraine", "Albania", "Belarus"),
                         `Latin America` = list("Argentina", "Chile", "Brazil"),
                         `MENA` = list("Algeria", "Egypt", "Jordan"),
                         `WCENA` = list("Austria", "Australia", "Estonia")
                         )
          )
        ),
        column(2,
               selectInput("year", "Year:", 1980:2020)
        ),
        column(2, 
               selectInput("sex", "Sex:", c("Female", "Male", "Both"))
        ),
        column(3, 
               selectInput("age_group", "Age group:", 
                           c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80+", "15-49"),
                           multiple = TRUE,
                           selected = "15-49")
        )
      ),
      tabsetPanel(
        tabPanel(title = HTML("<b style='font-size:18px'>Sankey</b>"),
                 fluidRow(
                   column(10,
                          sankeyNetworkOutput("sankey")
                   )
                 )
        ),
        tabPanel(title = HTML("<b style='font-size:18px'>Table</b>"),
        )
      )
  )

  
}