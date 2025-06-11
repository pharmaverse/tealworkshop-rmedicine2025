# * Create teal app
# * Look at init manual
# * use teal_data() to build data
# * Verify the data object
# * Run the app, click the Show R Code
# * Intro to filter argument

library(teal)

### Using teal_data() to create data object
# data <- teal_data(
#   iris = iris,
#   mtcars = mtcars,
#   code = "
#     iris <- iris
#     mtcars <- mtcars
#   "
# )
# data <- verify(data)

### the preferable way is to use within()
### ?teal.code::within.qenv
data <- within(
  teal_data(),
  {
    iris <- iris
    mtcars <- mtcars
  }
)

### Using cdisc_data() to create data object
# data <- cdisc_data(
#   ADSL = teal.data::rADSL,
#   ADAE = teal.data::rADAE,
#   code = "
#     ADSL <- teal.data::rADSL
#     ADAE <- teal.data::rADAE
#   "
# )
# data <- verify(data)
# join_keys(data)

# preferable way is to use within()
# data <- within(
#   cdisc_data(),
#   {
#     ADSL <- teal.data::rADSL
#     ADAE <- teal.data::rADAE
#   }
# )
# join_keys(data) <- default_cdisc_join_keys[c("ADSL", "ADAE")]

# try teal.modules.general::tm_data_table

library(teal.modules.general)

app <- init(
  data = data,
  modules = modules(
    example_module(label = "my module"),
    tm_data_table()
  ),
  filter = teal_slices(
    teal_slice(
      dataname = "iris",
      varname = "Species",
      selected = "virginica",
      fixed = TRUE,
      anchored = TRUE
    )
  )
)

shinyApp(app$ui, app$server)
