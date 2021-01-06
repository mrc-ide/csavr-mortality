library(shiny)
library(tidyverse)
library(DT)
library(shinyjs)
library(htmlwidgets)
library(networkD3)
library(countrycode)
library(naomi)
library(writexl)

# source("src/data_manip.R") 

# source("src/server/data_prep_server.R")
source("src/server/select_options_surver.R")
source("src/server/methods_server.R")
source("src/server/sankey_server.R")


source("src/ui/navigation.R")
source("src/ui/introduction.R")
source("src/ui/visualise.R")
source("src/ui/methods.R")

shiny::shinyAppDir("src")