## server logic
function(input, output, session) {
  # DATA MANIPULATION -------------------------------------------------------
  
  #Move showcase to the bottom to start
  runjs('toggleCodePosition();')
  
  ## To save the content of the ggplot
  plot_ggplot <- reactiveVal("")
  
  uploaded_data <- reactive({
    req(input$file_upload)
    
    df <- read.csv(
      file = input$file_upload$datapath,
      sep = input$file_separator,
      header = TRUE,
      stringsAsFactors = FALSE
    )
    
    if(length(getConditionColNames(df, is.numeric)) <= 2){
      
      showNotification("Data needs at least two numeric columns", type = "error")
      return()
    
    } else if(length(getConditionColNames(df, is.character)) < 1){
      
      showNotification("Data needs at least one character column", type = "error")
      return()
    }

    
    show("filter_div")
    show("density_div")
    show("frequency_div")
    show("plot_div")
    
    
    #Check for one character column and at least 2 numeric columns
    
    sendSweetAlert(
      session,
      title = "Great victory!",
      text = "File successfully loaded",
      type = "success",
      btn_labels = "Close window"
    )
    
    df
  })
  
  
  #### UPLOADED DATA FILTERING ####
  observe({
    req(uploaded_data())
    
    character_names = getConditionColNames(uploaded_data(), is.character)
    numeric_names = getConditionColNames(uploaded_data(), is.numeric)
    
    updateSelectInput(
      session,
      inputId = "character_select",
      choices = character_names,
      selected = character_names[1]
    )
    
    updateSelectInput(
      session,
      inputId = "density_num_select",
      choices = numeric_names,
      selected = numeric_names[1]
    )
    
  })
  
  
  observe({
    req(input$character_select)
    req(uploaded_data())
    
    char_options <-
      unique(uploaded_data()[, input$character_select])
    
    updatePickerInput(
      session,
      inputId = "character_filter",
      choices = char_options,
      selected = char_options,
    )
    
    numeric_cols <- sapply(uploaded_data(), is.numeric)
    numeric_names <- names(uploaded_data())[numeric_cols]
    
    updateSelectInput(
      session,
      inputId = "x_variable",
      choices = numeric_names,
      selected = numeric_names[1],
    )
    
    updateSelectInput(
      session,
      inputId = "y_variable",
      choices = numeric_names,
      selected = numeric_names[2],
    )
    
    
  })
  
  
  data <- reactive({
    req(uploaded_data())
    req(input$character_select)
    
    df <- uploaded_data()
    df[df[, input$character_select] %in% as.character(input$character_filter),]
  })
  
  
  # HOME - OUTPUT -----------------------------------------------------------
  
  output$density_plot <- renderPlot({
    
    dplot <- ggplot(data(), aes(x = !!as.symbol(input$density_num_select))) +
      geom_density()
    
    dplot
    
  })
  
  output$frequency_barchart <- renderPlot({
    fbplot <- ggplot(data(), aes(x = !!as.symbol(input$character_select))) + 
      geom_bar()
    
    fbplot
  })
  
  output$text_nb_lines <- renderText({
    nb_lines <- nrow(data())
    paste("The dataset contains", nb_lines, "rows")
  })
  
  output$plot_data <- renderPlot({
    req(data())
    req(input$character_filter)

    g <- ggplot(data(),
                aes(
                  x = data()[, as.character(input$x_variable)],
                  y = data()[, as.character(input$y_variable)],
                  colour = !!as.symbol(input$character_select)
                )) +
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
           plot = plot_ggplot(), )
    
    sendSweetAlert(session,
                   title = "Great victory!",
                   text = "Graph saved successfully",
                   type = "success")
    
  })
  
  
  output$table_data <- renderDataTable({
    datatable(data())
  })
  
  
}