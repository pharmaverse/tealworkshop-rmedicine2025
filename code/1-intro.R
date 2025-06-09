# * Create teal app
# * use teal_data() to build data
# * Run the app, click the Show R Code
# * Verify the data object

library(teal)

### Using teal_data() to create data object
data <- teal_data(
  iris = iris,
  code = "
    iris <- iris
  "
)
# data <- verify(data)

### the preferrable way is to use within()
# data <- within(
#   teal_data(),
#   {
#     iris <- iris
#   }
# )

### Using cdisc_data() to create data object
# data <- cdisc_data(
#   ADSL = teal.data::rADSL,
#   code = "
#     ADSL <- teal.data::rADSL
#   "
# )
# data <- verify(data)
# join_keys(data)

# preferrable way is to use within()
# data <- within(
#   cdisc_data(),
#   {
#     ADSL <- teal.data::rADSL
#     ADAE <- teal.data::rADAE
#   }
# )
# join_keys(data) <- default_cdisc_join_keys[c("ADSL", "ADAE")]

app <- init(
  data = data,
  modules = modules(
    example_module(label = "my module")
  )
)

shinyApp(app$ui, app$server)
