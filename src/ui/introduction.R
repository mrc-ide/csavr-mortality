introduction <- function() {
  div(style="margin-left:10%; margin-right: 40%; text-align: justify",
      h2("Cause of Death reallocation visualiser"),
      br(),
      p("This tool assists in visualising the reallocation of cause of death data, correcting for misclassification and unknown causes of death in vital registration systems"),
      p("Vital registration systems use the International Classification of Diseases (ICD) system to facilitate systematic recording of mortality data. Misclassification of deaths, however, is common: AIDS deaths can be recorded as an immediate cause of death (e.g. respiratory failure, cardiac arrest), or intermediate causes of death (e.g. sepsis, heart failure)."),
      p("The Case Surveillance and Vital Registration model (CSAVR) fits to AIDS death data, and will produce inaccurate results if mortality data that has not been adjusted for misclassification is used. UNAIDS recommends that countries use mortality data corrected for misclassification provided by the Institute of Health Metrics and Evaluation (IHME) when using CSAVR."),
      div(id="footer",
          img(id="footer_img", style="height:40%", src="unaids.png"),
          img(id="footer_img", style="height: 50%", src="ihme.jpg"),
          img(id="footer_img", style="height: 40%", src="MRC-GIDA-logo.png")
      )
  )
}