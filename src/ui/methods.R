methods <- function() {
  div(style="margin-left:10%; margin-right: 40%; text-align: justify",
      h2("Methods and sources"),
      br(),
      h3("Methods"),
      p("Data about the number of HIV/AIDS deaths corrected for unknown and misclassified causes of death are estimated as part of the Global Burden of Disease Study produced by the Institute of Health Metrics and Evaluation. Methods for estimating AIDS deaths include cause of death reallocation are described in <Hmwe's paper, other citations> and summarised below."),
      p("Deaths recorded in vital registration may be assigned immediate, contributing, and underlying causes of death classified according to the International Classification of Diseases (ICD) system. Most deaths for which HIV/AIDS was the underlying cause are correctly attributed to HIV/AIDS at the time of death. The cause of death reclassification process involves reassigning some deaths that were probably due to HIV/AIDS but for which AIDS was not recorded as the cause at the time of death."),
      p("This involves reclassification of deaths from two sources: (1) Deaths for which the immediate, intermediate, or ill-defined causes are incorrectly recorded as the underlying cause of death. These are often referred to as 'garbage' codes. (2) HIV/AIDS deaths for which the underlying cause was misclassified as a different cause of death."),
      h4("Garbage code correction"),
      p("Cases where ICD codes for immediate causes, intermediate causes, or ill-defined causes of death are recorded as the underlying cause of death are often referred to as ‘garbage codes’ as they do not represent the underlying cause of death that initiated the chain of events leading to death."),
      p("Correcting for garbage codes addresses three issues:"),
      tags$ul(
        tags$li("Reclassifying deaths which were incorrectly assigned intermediate causes (e.g., sepsis) or ill-defined causes (e.g. unknown causes of death, ill-defined intestinal infections) as the underlying cause of death."),
        tags$li("Reclassifying relevant garbage codes such as unspecified immunodeficiency as HIV/AIDS deaths."),
        tags$li("Reclassifying diseases that can mimic HIV infection (e.g., inflammatory bowel disease, some skin diseases) to HIV/AIDS deaths.")
      ),
      p("The reassignment of deaths to HIV/AIDS is based on the level of regional increase in the mortality rate of ICD codes relative to the rates observed during the pre-HIV era from 1980 to 1984. It is assumed that an increase of more than 5% is HIV/AIDS‐related, and the proportion of those excess deaths over 5% is reassigned to HIV/AIDS. This method is used for specific recorded causes of death, including bacterial infections and immunodeficiencies."),
      p("When causes of death are ill-defined, multiple causes of death recorded within the vital registration system are used to redistribute deaths to HIV/AIDS. Multiple causes of death data include a combination of an underlying cause of death and other causes such as immediate and intermediate causes that were included in the chain of events leading to death. Analysing multiple causes of death data can provide insight into identifying the true underlying cause of death when the recorded cause of death is ill-defined."),
      h4("Misclassification correction"),
      p("HIV deaths that were incorrectly assigned to other underlying causes such as tuberculosis and encephalitis are reallocated as follows:"),
      tags$ol(
        tags$li("Examine the age patterns of underlying causes in location and years with and without HIV epidemics and isolate the causes with age pattern shifts during the epidemic years"),
        tags$li("Compute the expected deaths by location, year and sex for each underlying cause with an age-pattern shift"),
        tags$li("Attribute expected deaths to the corresponding underlying cause"),
        tags$li("Compute the difference between observed and expected deaths and reallocate the difference to HIV/AIDS.")
      ),
      # img(width="100%", src="global_reallocation.png"),
      h3("Mortality group"),
      textOutput("group_explanation"),
      h3("Data sources"),
      textOutput("info"),
      br(),
      br(),
      h4("Citations"),
      p("<Some citations here>")
  )
}