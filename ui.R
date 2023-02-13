## appearance

# Use shiny js

## with shinydashboard
header <- dashboardHeader(title = "Shinyapp")

sidebar <- dashboardSidebar(useShinyjs(),
                            sidebarMenu(
                              menuItem(
                                text = "Home",
                                tabName = "home",
                                icon = icon("home")
                              ),
                              menuItem(
                                text = "Plotly",
                                tabName = "plotly",
                                icon = icon("chart-line")
                              )
                            ))

body <- dashboardBody(tabItems(
  tabItem(
    tabName = "home",
    h3("Discovering the iris dataset"),
    fluidRow(
      box(
        title = strong("Load data"),
        solidHeader = TRUE,
        width = 4,
        status = "primary",
        fileInput(
          inputId = "file_upload",
          label = "Upload your local file",
          buttonLabel = "Click here!",
          accept = c(".csv", ".txt"),
          placeholder = "No file loaded"
        ),
        radioButtons(
          inputId = "file_separator",
          label = "Field separator",
          choiceNames = c("Comma (,)", "Semi-colon (;)"),
          choiceValues = c(",", ";"),
          selected = ";"
        )
      ),
    ),
    hidden(div(id = "filter_row", fluidRow(
      box(
        title = "Filtering the dataset",
        solidHeader = TRUE,
        width = 4,
        status = "primary",
        #primary, success, info, warning, danger
        checkboxGroupInput(
          inputId = "character_filter",
          label = "Select a species",
          choices = "",
          selected = "",
          inline = TRUE
        )
      )
    ))),
    br(),
    fluidRow(
      box(
        title = "Visualise data",
        solidHeader = TRUE,
        width = 12,
        status = "primary",
        textOutput("text_nb_lines"),
        br(),
        tabBox(
          width = 12,
          tabPanel(
            "Plot",
            actionBttn(
              inputId = "bttn_custom_plot",
              label = "Customise",
              size = "sm",
              color = "primary",
              style = "simple"
            ),
            bsModal(
              id = "customize_plot",
              title = "Custom the appearance of the plot",
              trigger = "bttn_custom_plot",
              size = "small",
              selectInput(
                inputId = 'x_variable',
                label = "Select the abscissa of the plot",
                choices = "",
                selected = ""
              ),
              selectInput(
                inputId = 'y_variable',
                label = "Select the ordinate of the plot",
                choices = list_quantitative_columns,
                selected = list_quantitative_columns[2]
              ),
              textInput(inputId = "plot_title",
                        label = "Enter here the title of the plot")
            ),
            plotOutput("plot_data"),
            actionBttn(
              inputId = "save_plot",
              label = "Save the plot",
              style = "simple",
              icon = icon("save"),
              size = "sm",
              color = "primary"
            )
          ),
          tabPanel("Table",
                   DT::dataTableOutput("table_data"))
        )
      )
    )
  ),
  tabItem(
    tabName = "plotly",
    h3("Discovering the {plotly} package"),
    fluidRow(
      box(
        title = strong("Graph with plotly package"),
        width = 12,
        status = "primary",
        solidHeader = TRUE,
        plotlyOutput("graph_plotly")
      )
    )
  )
))

dashboardPage(header = header,
              sidebar = sidebar,
              body = body)