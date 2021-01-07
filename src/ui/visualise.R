visualise <- function() {
    div(style="margin-left:2%; margin-right: 2%",
        h2("Visualise data"),
        br(),
        fluidRow(
          column(2, uiOutput("country_option")),
          column(2, uiOutput("period_option")),
          column(2, uiOutput("age_option")),
          column(2, uiOutput("sex_option"))
          # column(3, 
          #        selectInput("country", "Country:",
          #                    sort(unique(full_dat$area_name)),
          #                    selected = "Albania"
          #                    # list(`Latin America` = list("ARG", "MEX"),
          #                    #      `EECA` = list("UKR", "KAZ"),
          #                    #      `MENA` = list("DZA")),
          #                    # selected = "ARG"
          #        )
          #        # selectInput("country1", "Country:",
          #        #                choices=list(
          #        #                  `EECA` = list("MWI", "ZMB", "ZWE", "MOZ", "ETH"),
          #        #                  `Latin America` = list("MWI", "ZMB", "ZWE", "MOZ", "ETH"),
          #        #                  `MENA` = list("MWI", "ZMB", "ZWE", "MOZ", "ETH"),
          #        #                  `WCENA` = list("MWI", "ZMB", "ZWE", "MOZ", "ETH")
          #        #                  )
          #        #                )
          #        ),
          # column(2, selectInput("period", "Year:", as.character(unique(full_dat$period))), selected="1987"),
          # column(2, selectInput("age", "Age group:", as.character(unique(full_dat$age_group))), selected="15-19"),
          # column(2, selectInput("sex", "Sex:", as.character(unique(full_dat$sex))), selected="female")
        ),
        # DTOutput("links_sankey_dt"),
        # DTOutput("nodes_sankey_dt"),
        # DTOutput("links_dt"),
        # textOutput("age_result"),
        # textOutput("period_result"),
        # textOutput("sex_result"),
        
        tabsetPanel(
          tabPanel(title = HTML("<b style='font-size:18px'>Sankey</b>"),
                   # fluidRow(
                   #     shinyjs::hidden(div(style="display:flex; justify-content: space-around",
                   #      id = "titles",
                   #      h3("Garbage"),
                   #      h3("Misclassification")
                   #      )   
                   # )),
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
                   downloadButton("download_data_table", "Download data"),
                   DTOutput("links_sankey_df")
          )
        )
    )

}
