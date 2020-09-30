library(shiny)
library(tidyverse)
library(DT)
library(shinyjs)

# source("src/data_manip.R") 

# source("src/server/data_tables.R")

source("src/ui/navigation.R")
source("src/ui/introduction.R")
source("src/ui/visualise.R")
source("src/ui/methods.R")

shiny::shinyAppDir("src")