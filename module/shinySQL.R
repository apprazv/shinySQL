sqlUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(uiOutput("sql_gui" %>% ns()))
    )
}

sqlServer <- function(id,rv) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- NS(id)
      output$sql_gui <- renderUI({
        tagList(
          textInput(ns("driver"),"Driver",value = "SnowflakeDSIIDriver"),
          passwordInput(ns("uid"),"UID"),
          passwordInput(ns("pwd"),"PWD"),
          textInput(ns("role"),"Role","LINEAR_DATA_SCIENCE_USER"),
          textInput(ns("server"),"server","ted_cnn.us-east-1.snowflakecomputing.com"),
          textInput(ns("schema"),"Schema","DATABRICKS"),
          textInput(ns("warehouse"),"Warehouse","LINEAR_DATA_SCIENCE_USAGE"),
          textInput(ns("database"),"Database","LINEAR_ANALYTIC_TOOLS"),
          actionBttn(ns("sql_con"),"Connect to DB")
        )
      })
      
      observeEvent(input$sql_con,{
        shiny_con <- dbConnect(odbc(),
                               driver        = input$driver, # this is the driver name on my PC
                               # driver        = "Snowflake", # this is it on my Mac
                               uid           = input$uid,
                               pwd           = input$pwd,
                               role          = input$role,
                               server        = input$server,
                               schema        = input$schema,
                               warehouse     = input$warehouse,
                               database      = input$database)
        
        rv$sql_tables <- DBI::dbListTables(shiny_con) %>% as.data.frame(row.names = FALSE)
        sqlll_ <<- rv$sql_tables
        names(rv$sql_tables) <- c("TableNames")
        sqll <<- rv$sql_tables
        dbDisconnect(shiny_con)
        output$sql_tables <- renderDT({
          datatable(rv$sql_tables,rownames = FALSE)
        })
      })
      
      observeEvent(input$sql_tables_rows_selected,{
        print(input$sql_tables_rows_selected)
        rv$sql_preview <- rv$sql_tables %>%
          dplyr::slice(input$sql_tables_rows_selected) %>%
          dplyr::select(TableNames)
        sqlll <<- rv$sql_preview
        print(rv$sql_preview)
        shiny_con <- dbConnect(odbc(),
                               driver        = input$driver, # this is the driver name on my PC
                               # driver        = "Snowflake", # this is it on my Mac
                               uid           = input$uid,
                               pwd           = input$pwd,
                               role          = input$role,
                               server        = input$server,
                               schema        = input$schema,
                               warehouse     = input$warehouse,
                               database      = input$database)
        rv$sql_table <- dbReadTable(conn = shiny_con,name = rv$sql_preview$TableNames %>% as.character())
        print(rv$sql_table)
        output$sql_table <- renderDT({
          datatable(rv$sql_table,rownames = FALSE,options = list(scrollX = TRUE))
        })
      })
    })
}