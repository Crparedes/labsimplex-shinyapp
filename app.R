library(shiny)
library(shinythemes)
library(shinyjs)
library(R.devices)
library(shinyWidgets)
library(shinycssloaders)
library(shinyMatrix)

ui <- fluidPage(
  fluidPage(
    useShinyjs(),
    theme = shinytheme("sandstone"),  
    headerPanel(
      list(HTML('<img src="logo.png"/ height="80"> Simplex algorithm for laboratory and process optimizations'))
    ),
    
    # Application title
    titlePanel("x "),
    
    # Sidebar
    sidebarLayout(
      sidebarPanel(
        sliderInput("bins",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 30)
      ),
      # Main panel  
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("New simplex",
                             sliderInput("dim", "Number of variables (dimensionality):",
                                         min = 1, max = 12, value = 3),
                             
                             selectInput("WayToBegin", "Select an option",
                                         choices = list("Regular simplex" = "RS_0", 
                                                        "User defined simplex" = "UDS_0")),
                             
                             conditionalPanel(condition = "input.WayToBegin == 'RS_0'",
                                              radioButtons("position_0", "Select start position parameter",
                                                           choices = c("Default" = "Default",
                                                                       "Centroid" = "Centroid",
                                                                       "Initial exp." = "StartingExp"),
                                                           select = 'Default')
                             ),
                             conditionalPanel(condition = "input.WayToBegin == 'UDS_0'",
                                              uiOutput("dimension")
                             )
                    )
        )
      )
    )
  )
)

server <- function(input, output) {
   
  output$dimension <- renderUI({
    dim <- input$dim
    matrixInput("usrdS", class = "numeric", paste = TRUE, copy = TRUE,
                value = matrix(ncol = dim, nrow = dim + 1, 
                               dimnames = list(row = paste0("Vertex.", 1:(dim + 1)),
                                               col = paste0("Var.", 1:dim))),
                rows = list(names = TRUE, editableNames = FALSE, names = TRUE),
                cols = list(names = TRUE, editableNames = TRUE, names = TRUE))
    #               data = matrix(letters[1:12], 3, 4)
  })
}

shinyApp(ui = ui, server = server)

