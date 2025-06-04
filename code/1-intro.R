# * Create teal app
# * use teal_data() to build data
# * use cdisc_data() to build data object, use teal.data::rADSL and rADAE
# * Run the app, click the Show R Code
# * Verify the data object

library(teal)

data <- teal_data(
  iris = iris,
  code = "
    iris <- iris
  "
)

# data <- cdisc_data(
#   ADSL = teal.data::rADSL,
#   code = "
#     ADSL <- teal.data::rADSL
#   "
# )

data <- verify(data)

app <- init(
  data = data,
  modules = modules(
    example_module(label = "my module")
  )
) |> modify_header(element = tags$div(h3("My teal app")))

shinyApp(app$ui, app$server)
