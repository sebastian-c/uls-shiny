# UniLaSalle Shiny project

## Availability

This app is available on ShinyApps.io: https://pascalian.shinyapps.io/shiny_assessment/

## Setup

The app is ready to be run with Shiny. You can use Rstudio's "Run App" option or  `shiny::runApp` if you're old school and just like automation. If you'd like to generate some test files, `create_test_set.R` will generate some test files for you to use on the app.

## Features

The app starts with the showcase at the bottom so that the app displays properly across the width of the screen. The showcase can be brought back up with the button on its top-left.

The app contains:

- [X] Shinydashboard
- [X] Separator selection for uploaded files
- [X] Display of table content
- [X] Numeric column selection for densityplot
- [X] Character column selection for frequency bar chart
- [X] Select character cols and numeric cols for ggplot
- [ ] Submission of assignment
