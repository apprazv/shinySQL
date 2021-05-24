# shinySQL
Shiny Module for SQL Querying

![Alt text](images/imgfile.png?raw=true "Title")

| Package | Description | Status |
|---|---|---|
| [shinySQL](https://github.com/apprazv/shinySQL) | 💡 Shiny Modules to Enable Database Pulls in Shiny Apps | WIP |
| [shinyAWS](https://github.com/apprazv/shinyAWS) | ⏬ Shiny Module for AWS| WIP |
| [shinyEDA](https://github.com/apprazv/shinyEDA) | ✅ Shiny Module for Exploratory Data Analysis | WIP |
| [shinyCRM](https://github.com/apprazv/shinyCRM/) | 📝 Shiny based CRM | WIP |

```r
library(DBI)
library(dplyr)
library(shiny)
library(DT)
```

```{r}
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
```
