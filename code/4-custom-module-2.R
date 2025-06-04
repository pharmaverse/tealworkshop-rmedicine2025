# * Add a plot to our custom module
# * load ggplot2 library
# * Create selectInput for the dataset's column, set the choices to NULL
# * Create sliderInput for binwidth
# * Create plotOutput
# * Create observeEvent to react when input$datasets changes
# * Only pull numerical variables
#
# * Update teal_data object to include the logic to create the plot
#### Here's the plot's code
# my_plot <- ggplot(input_dataset, aes(x = input_vars)) +
#   geom_histogram(binwidth = input_binwidth, fill = "skyblue", color = "black")
####
# * Build a reactive teal_data object using within()
# * Use within third argument to assign input value
# * create renderPlot statement calling the plot's object name in the new reactive teal_data object

library(teal)
library(ggplot2)

tealmodule_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    shiny::selectInput(
      inputId = ns("datasets"),
      label = "Datasets",
      choices = NULL
    ),
    # Add code here
  )
}

tealmodule_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    shiny::updateSelectInput(
      inputId = "datasets",
      choices = names(data())
    )

    # Add code here

  })
}

my_custom_module <- function(label = "My Custom Teal Module") {
  module(
    label = label,
    ui = tealmodule_ui,
    server = tealmodule_server,
    datanames = "all"
  )
}

data <- cdisc_data(
  ADSL = teal.data::rADSL,
  ADAE = teal.data::rADAE,
  code = "
    ADSL = teal.data::rADSL
    ADAE = teal.data::rADAE
  "
)

data <- verify(data)

app <- init(
  data = data,
  modules = modules(
    my_custom_module()
  )
) |> modify_header(element = tags$div(h3("My teal app")))

shinyApp(app$ui, app$server)
