library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinyBS)
library(shinyWidgets)

library(plotly)
library(ggplot2)

library(dplyr)
library(DT)

getConditionColNames <- function(data, condition){
  names(data)[vapply(data, condition, logical(1))]
}
