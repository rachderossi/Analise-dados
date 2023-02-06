library(shiny)
library(ggplot2)


dados <- diamonds

Categorical.Variables = c("cut",'color','clarity')

ui <- fluidPage(
  
  tabPanel("Diamonds dataset",
           titlePanel("Diamonds dataset"),
            p('A dataset containing the prices and other attributes of almost 54,000 diamonds.', style= "font-size: 16px;"),
            p('Choose between these 3 variables:', style="font-size: 14px; font-weight: bold"),
            p('cut: quality of the cut (Fair, Good, Very Good, Premium, Ideal)', style="font-size: 12px; color: #8E8C94",
              br(),
              'color: diamond colour, from D (best) to J (worst)',
              br(),
              'clarity: a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best)'),
              br(),
            
           
            selectInput("categorical_variable", label = "Select categorical variable:", choices = Categorical.Variables),
          
            plotOutput(outputId = "barplot", height = 500,width = 600)
                  
      )
    )

server <- function(input, output) {
  
  output$barplot <- renderPlot({
    ggplot(dados, aes(x=dados[[input$categorical_variable]], fill=as.factor(dados[[input$categorical_variable]])))  + 
      geom_bar() +
      scale_y_continuous() +
      geom_text(aes(y = (after_stat(count)),label =  scales::percent((after_stat(count))/sum(after_stat(count)))),
      stat="count",vjust=-1) +       
      geom_text(stat='count', aes(label=after_stat(count)), vjust=3) +
      theme(legend.position="none") +
      labs(title = "Frequency of each category",
           x = 'Categorical variable',
           y = 'Frequency') 
  
  })
}
  
shinyApp(ui = ui, server = server)
  