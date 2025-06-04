# Run the app to see an example of teal app with multiple modules
# with pre-defined filters
library(teal.modules.clinical)

ADSL <- teal.modules.clinical::tmc_ex_adsl
ADAE <- teal.modules.clinical::tmc_ex_adae
ADTTE <- teal.modules.clinical::tmc_ex_adtte

data <- cdisc_data(
  ADSL = ADSL,
  ADAE = ADAE,
  ADTTE = ADTTE,
  code = "
      ADSL <- teal.modules.clinical::tmc_ex_adsl
      ADAE <- teal.modules.clinical::tmc_ex_adae
      ADTTE <- teal.modules.clinical::tmc_ex_adtte
    "
)
data <- verify(data)

app <- init(
  data = data,
  modules = modules(
    tm_t_summary(
      label = "Demographic Table",
      dataname = "ADSL",
      arm_var = choices_selected(choices = c("ARM", "ARMCD"), selected = "ARM"),
      summarize_vars = choices_selected(
        choices = c("SEX", "RACE", "BMRKR2", "EOSDY", "DCSREAS", "AGE"),
        selected = c("SEX", "RACE")
      )
    ),
    tm_t_events(
      label = "AE Table",
      dataname = "ADAE",
      arm_var = choices_selected(choices = c("ARM", "ARMCD"), selected = "ARM"),
      hlt = choices_selected(
        choices = variable_choices(ADAE, c("AEBODSYS", "AESOC")),
        selected = "AEBODSYS"
      ),
      llt = choices_selected(
        choices = variable_choices(ADAE, c("AETERM", "AEDECOD")),
        selected = c("AEDECOD")
      )
    ),
    tm_g_km(
      label = "KM Plot",
      dataname = "ADTTE",
      arm_var = choices_selected(
        choices = c("ARM", "ARMCD", "ACTARMCD"),
        selected = "ARM"
      ),
      paramcd = choices_selected(
        choices = value_choices(ADTTE, "PARAMCD", "PARAM"),
        selected = "OS"
      ),
      strata_var = choices_selected(
        choices = variable_choices(ADSL, c("SEX", "BMRKR2")),
        selected = NULL
      ),
      facet_var = choices_selected(
        choices = variable_choices(ADSL, c("SEX", "BMRKR2")),
        selected = NULL
      ),
      plot_height = c(600L, 400L, 5000L),
    )
  ),
  filter = teal_slices(
    teal_slice("ADSL", "SAFFL", id = "saffl", selected = "Y", fixed = TRUE, anchored = TRUE),
    teal_slice("ADAE", "AESER", anchored = TRUE),
    teal_slice("ADAE", id = "aerel", expr = "AEREL == 'Y' & AETOXGR %in% c('3', '4', '5')", title = "Grade 3+ Related Events"),
    teal_slice("ADSL", "SEX", id = "sex", fixed = TRUE),
    teal_slice("ADSL", id = "age", expr = "AGE >= 18 & AGE <= 30", title = "Young Adult"),
    module_specific = TRUE,
    mapping = list(
      "Demographic Table" = c("saffl"),
      "AE Table" = c("saffl", "aerel"),
      global_filters = c("sex", "age")
    ),
    count_type = "all"
  )
) |> modify_header(element = tags$div(h3("My teal app")))

shinyApp(app$ui, app$server)
