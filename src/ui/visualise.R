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
                   fluidRow(
                          sankeyNetworkOutput("sankey")
                   )
          ),
          tabPanel(title = HTML("<b style='font-size:18px'>Table</b>"),
                   DTOutput("links_sankey_df")
          )
        )
    )

}
