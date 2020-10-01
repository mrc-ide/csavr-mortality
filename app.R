library(shiny)
library(tidyverse)
library(DT)
library(shinyjs)
library(htmlwidgets)
library(networkD3)

# source("src/data_manip.R") 

source("src/server/sankey_server.R")
source("src/server/select_options_surver.R")

source("src/ui/navigation.R")
source("src/ui/introduction.R")
source("src/ui/visualise.R")
source("src/ui/methods.R")

shiny::shinyAppDir("src")