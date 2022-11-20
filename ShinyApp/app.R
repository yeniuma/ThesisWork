set.seed(123)
library(shiny)
library(plotly)
library(readr)
library(dplyr)
library(slider)
library(DT)
forecast <- read_rds("D:/Suli/Szakdolgozat1/clean data/forecast.Rds")
ml_df <- read_rds("D:/Suli/Szakdolgozat1/clean data/training_df.Rds")
output_df <- select(forecast,c(ds,yhat_lower,yhat,yhat_upper))

ui <- fluidPage(
  
  titlePanel("Bitcoin exchange rate change forecast with Prophet"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      dateRangeInput(
        inputId = 'inputDate',
        label = 'Choose the date range to display:',
        min = '2019-01-01',
        max = '2022-05-29',
        start = '2019-01-01',
        end = '2019-05-01',
        language = 'hu'
      ),
      selectInput(
        inputId = 'inputCoinType',
        label = 'Select the cryptocurrency:',
        choices = 'Bitcoin'
      )
      
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot",plotlyOutput("bitcoin_forecast")),
        tabPanel("Dataset",DT::dataTableOutput("table"))      
        )
    )
  )
)

server <- function(input, output) {
  
  output$table <- DT::renderDataTable({
    datatable(output_df)
    }
    )
  
  output$bitcoin_forecast <- renderPlotly({
    startDate <- input$inputDate[1]
    endDate <- input$inputDate[2]
    
    rangeMax <- forecast[as.Date(forecast$ds) >= startDate & as.Date(forecast$ds) <= endDate,]$yhat_upper %>%
      max()
    
    
    plot_ly() %>%
      add_trace(data = forecast, x = ~ds, y = ~yhat, type = 'scatter', mode = 'lines',
                  line = list(color = 'rgba(59, 190, 215, 0)'), hoverinfo = 'none', showlegend = FALSE) %>%
      add_trace(data = forecast, x = ~ds, y = ~yhat_lower, type = 'scatter', fill = 'tonexty', name = 'Confidence',
                  fillcolor = 'rgba(231, 234, 241,.5)', hoverinfo = 'none',mode = 'none') %>%
      add_trace(data = forecast, x = ~ds, y = ~yhat_upper, type = 'scatter', fill = 'tonexty',
                  showlegend = FALSE, hoverinfo = 'none', fillcolor = 'rgba(231, 234, 241,.5)', mode = 'none') %>%
      add_trace(data = forecast, x = ~ds, y = ~yhat, name ="Forecast", type = 'scatter', mode = 'lines',
                  line = list(color = 'rgba(59, 190, 215, 1)', width = 3)) %>%
      add_trace(data = ml_df, x = ~ds, y = ~y, name = 'Actual',type = 'scatter',mode = 'markers',
                marker = list(color = '#fffaef', size = 4, line = list(color = '#000000', width = .75))) %>%
      layout(title = "Bitcoin exchange rate",
           margin = list(t = 100),
           legend = list(x = 1.05),
           paper_bgcolor='rgb(255, 255, 255)', plot_bgcolor='rgb(255, 255, 255)',
           xaxis = list(type = 'date', title = 'Date', range = list(startDate, endDate), tickformat = "%d %B<br>%Y"),
           yaxis = list(range = list(0, rangeMax), title = 'BTC/USD'))
      
    
  })
}


shinyApp(ui = ui, server = server)


