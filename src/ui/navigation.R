navigationPanel <- function() {
  navlistPanel(HTML("<b>CSAVR mortality data</b>"),
    widths = c(2, 10), well = FALSE,
    tabPanel("Introduction", introduction()),
    tabPanel("Visualise", visualise()),
    tabPanel("Methods", methods())
  )
}
                                
