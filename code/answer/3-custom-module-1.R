library(teal)

tealmodule_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    shiny::selectInput(
      inputId = ns("datasets"),
      label = "Datasets",
      choices = NULL
    ),
    DT::dataTableOutput(ns("tbl"))
  )
}

tealmodule_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    updateSelectInput(
      inputId = "datasets",
      choices = names(data())
    )

    output$tbl <- DT::renderDataTable({
      req(input$datasets)
      data()[[input$datasets]]
    })

  })
}

custom_teal_module <- function(label = "My Custom Teal Module") {
  module(
    label = label,
    ui = tealmodule_ui,
    server = tealmodule_server,
    datanames = "all"
  )
}

library(teal)

data <- cdisc_data(
  ADSL = teal.data::rADSL,
  ADAE = teal.data::rADAE,
  code = "
    ADSL <- teal.data::rADSL
    ADAE <- teal.data::rADAE
  "
)

data <- verify(data)

app <- init(
  data = data,
  modules = modules(
    custom_teal_module()
  )
) |> modify_header(element = tags$div(h3("My teal app")))

shinyApp(app$ui, app$server)
