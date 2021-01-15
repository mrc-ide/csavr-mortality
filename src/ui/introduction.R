introduction <- function() {
  div(style="margin-left:10%; margin-right: 40%; text-align: justify",
      h2(style="text-align: left", "AIDS Cause of Death reallocation visualiser"),
      br(),
      p("This tool visualises HIV/AIDS deaths recorded in national vital registration systems, including reallocation of deaths to HIV/AIDS that were initially classified as unknown causes or misclassified as other causes. Estimates of AIDS deaths adjusted for misclassification are produced for the Global Burden of Disease Study by the Institute for Health Metrics and Evaluation."),
      p("Vital registration systems use the International Classification of Diseases (ICD) system to facilitate systematic recording of mortality data. Misclassification of AIDS deaths, however, is common: deaths can be incorrectly recorded as an immediate cause of death (e.g. respiratory failure, cardiac arrest), or an intermediate cause of death (e.g. sepsis, heart failure)."),
      p("The Case Surveillance and Vital Registration model (CSAVR) uses data about the number of AIDS deaths in each year to back-calculate HIV infections and the number of people living with HIV. Estimates may be inaccurate if the input data about the number of AIDS deaths do not include those that have been initially misclassified as unknown or other causes. UNAIDS recommends to use mortality data corrected for misclassification provided by the Global Burden of Disease Study when using CSAVR."),
      p("This tool is best used in Google Chrome or Safari."),
      div(id="footer",
          img(id="footer_img", style="height:40%", src="unaids.png"),
          img(id="footer_img", style="height: 50%", src="ihme.jpg"),
          img(id="footer_img", style="height: 40%", src="MRC-GIDA-logo.png")
      )
  )
}