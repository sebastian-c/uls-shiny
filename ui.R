## appearance

# Use shiny js

## with shinydashboard
header <- dashboardHeader(title = "Shinyapp")

sidebar <- dashboardSidebar(useShinyjs(),
                            sidebarMenu(menuItem(
                              text = "Home",
                              tabName = "home",
                              icon = icon("home")
                            )))

body <- dashboardBody(tabItems(tabItem(
  tabName = "home",
  h3("Discovering the iris dataset"),
  fluidRow(column(
    4,
    box(
      title = strong("Load data"),
      solidHeader = TRUE,
      width = 12,
      status = "primary",
      fileInput(
        inputId = "file_upload",
        label = "Upload your local file",
        buttonLabel = "Click to upload!",
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
    hidden(div(
      id = "filter_div",
      br(),
      box(
        title = "Filtering the dataset",
        solidHeader = TRUE,
        width = 12,
        status = "primary",
        #primary, success, info, warning, danger
        selectInput(
          inputId = "character_select",
          label = "Select a character column",
          choices = NULL,
          selected = NULL
        ),
        pickerInput(
          inputId = "character_filter",
          label = "Select factors to include",
          choices = NULL,
          multiple = TRUE,
          options = list(`actions-box` = TRUE)
        )
      )
    ))
  ),
  hidden(div(id = "density_div", column(
    4,
    box(
      title = "Density plot",
      solidHeader = TRUE,
      width = 12,
      status = "primary",
      selectInput(
        inputId = "density_num_select",
        label = "Select a numeric column",
        choices = NULL,
        selected = NULL
      ),
      plotOutput("density_plot")
    )
  ))),
  hidden(div(id = "frequency_div", column(
    4,
    box(
      title = "Frequency barchart",
      solidHeader = TRUE,
      width = 12,
      status = "primary",
      plotOutput("frequency_barchart")
    )
  )))),
  br(),
  hidden(div(id = "plot_div", fluidRow(
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
              choices = "",
              selected = ""
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
  )))
)))

dashboardPage(header = header,
              sidebar = sidebar,
              body = body)