## server logic
function(input, output, session) {

# DATA MANIPULATION -------------------------------------------------------

  ## To save the content of the ggplot
  plot_ggplot <- reactiveVal("")
  
  uploaded_data <- reactive({
    #write.table(iris, "iris.csv", sep = ";", dec = ".", col.names = TRUE, row.names = FALSE)
    
    req(input$file_upload)
    
    df <- read.csv(file = input$file_upload$datapath,
                   sep = input$file_separator,
                   header = TRUE,
                   stringsAsFactors = FALSE) %>% as.data.frame()
    
    show("filter_row")
    
    sendSweetAlert(session,
                   title = "Great!",
                   text = "Your file is well loaded",
                   type = "success",
                   btn_labels = "Close the window")
    
    df
  })
  
  observe({
    req(uploaded_data())
    updateCheckboxGroupInput(session,
                             inputId = "species_filter",
                             choices = unique(uploaded_data()$Species),
                             selected = unique(uploaded_data()$Species),
                             inline = TRUE
    )
    
    numeric_cols <- sapply(uploaded_data(), is.numeric)
    numeric_names <- names(uploaded_data())[numeric_cols]
    
    updateSelectInput(session,
                      inputId = "x_variable",
                      choices = numeric_names,
                      selected = numeric_names[1],
    )
  })
  
  
  data <- reactive({
    req(uploaded_data())
    df <- uploaded_data() %>% filter(Species %in% as.character(input$species_filter))
    df
  })

  

# HOME - OUPTUT -----------------------------------------------------------

  output$text_nb_lines <- renderText({
    nb_lines <- nrow(data())
    paste("The dataset contains", nb_lines, "rows")
  })

  output$plot_iris <- renderPlot({
    # plot(data$Sepal.Length, data$Sepal.Width)
    g <- ggplot(data(),
           aes(x = data()[, as.character(input$x_variable)],
               y = data()[, as.character(input$y_variable)],
               color = Species)) +
      geom_point() +
      labs(title = as.character(input$plot_title)) +
      xlab(as.character(input$x_variable)) +
      ylab(as.character(input$y_variable)) + 
      theme(plot.title = element_text(hjust = 0.5,
                                      size = 14))
    
    plot_ggplot(g)
    
    g
  })
  
  observeEvent(input$save_plot, {
    filename = paste0("figure_", format(Sys.time(), "%Y%m%d%H%M%S"), ".png")
    ggsave(filename = filename,
           plot = plot_ggplot(),
           )
    
    sendSweetAlert(session,
                   title = "Great!",
                   text = "Your graph is well saved",
                   type = "success")
    
  })
  
  
  output$table_iris <- renderDataTable({
    datatable(data())
  })


# PLOTLY - OUTPUT ---------------------------------------------------------

  output$graph_plotly <- renderPlotly({
    data <- mtcars
    
    data <- data %>% mutate(car_name = rownames(data))
    
    plot_ly(data = data,
            x = ~hp,
            y = ~qsec,
            color = ~factor(cyl),
            type = "scatter",
            mode = "markers",
            hoverinfo = "text",
            text = ~paste0("Car: ", car_name, "<br>", gear, " gears")) %>%
      layout(xaxis = list(title = "horse power"),
             yaxis = list(title = "secondes for 1/4 miles"))
    
  })
  
}