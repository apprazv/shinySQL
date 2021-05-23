source("global.R")
source("module/shinySQL.R")

## Basic App ##
ui <- fluidPage(sqlUI("sql_ns"))
server <- function(input,output,session){
  rv <- reactiveValues()
  sqlServer("sql_ns",rv)
}
app <- shinyApp(ui,server)
app %>% runApp() #%>% secure_app()
