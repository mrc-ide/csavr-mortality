methods <- function() {
  div(style="margin-left:10%; margin-right: 40%; text-align: justify",
      h2("Methods and sources"),
      br(),
      h3("Methods"),
      p("Vital registration data corrected for misclassified causes of death are kindly provided by the Institute of Health Metrics and Evaluation as part of the Global Burden of Disease study. Methods are fully detailed in <Hmwe's paper, other citations> and summarised below."),
      h4("Garbage code correction"),
      p("Immediate causes of death (e.g., respiratory failure, cardiac arrest) or intermediate causes of death (e.g., sepsis, heart failure) are frequently classified as the underlying cause of death. ICD codes for immediate causes, intermediate causes, or ill-defined causes of death are often referred to as ‘garbage codes’ as they do not represent the underlying cause of death that initiated the chain of events leading to death."),
      p("Correcting for garbage codes addresses three issues:"),
      tags$ul(
        tags$li("Incorrectly assigning intermediate causes (e.g., sepsis) or ill-defined causes (e.g. unknown causes of death, ill-defined intestinal infections) as the underlying cause of death"),
        tags$li("Assignment of HIV deaths to relevant garbage codes such as unspecified immunodeficiency"),
        tags$li("Allocation of HIV deaths to diseases that can mimic HIV infection (e.g., inflammatory bowel disease, some skin diseases)")
      ),
      p("The assignment of deaths to HIV/AIDS is based on the level of regional increase in the mortality rate of ICD codes relative to the rates observed during the pre-HIV era from 1980 to 1984. It is assumed that an increase of more than 5% is HIV/AIDS‐related, and the proportion of those excess deaths over 5% is reassigned to HIV/AIDS. This method is used for specific recorded causes of death, including bacterial infections and immunodeficiencies."),
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
      h3("Data sources"),
      textOutput("info")
  )
}