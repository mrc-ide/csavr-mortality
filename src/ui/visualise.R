visualise <- function() {
    div(style="margin-left:2%; margin-right: 2%",
        h2("Visualise data"),
        br(),
        fluidRow(
          column(2, uiOutput("country_option")),
          column(2, uiOutput("period_option")),
          column(2, uiOutput("age_option")),
          column(2, uiOutput("sex_option")),
          column(2, style="margin-top: 30px", tags$b(textOutput("group")))
        ),
        tabsetPanel(id="tabs",
            tabPanel(title = HTML("<b style='font-size:18px'>Time trend</b>"),
                     value="time_trend",
                     br(),
                     br(),
                     plotOutput("time_trend_plot", width = "80%")
                     
            ),
            tabPanel(title = HTML("<b style='font-size:18px'>Sankey</b>"),
                     value="sankey",
                       fluidRow(
                           br(),
                           p(
                               tags$b(
                                   "Deaths coded as HIV/AIDS are " , tags$span(style="color: #3B9AB2", "blue. "),
                                   "Deaths coded as garbage codes reallocated to HIV/AIDS are ", tags$span(style="color: #E1AF00", "yellow. "),
                                   "Deaths coded as other causes reclassified to HIV/AIDS are ", tags$span(style="color: #F21A00", " red.")
                               )
                             ),
                              sankeyNetworkOutput("sankey")
                       )
          ),
          tabPanel(title = HTML("<b style='font-size:18px'>Table</b>"),
                   value = "table",
                   downloadButton("download_data_table", "Download data"),
                   DTOutput("links_sankey_df")
          )
        )
    )

}
