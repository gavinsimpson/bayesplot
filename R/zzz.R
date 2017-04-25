.onAttach <- function(...) {
  ver <- utils::packageVersion("bayesplot")
  ## set the default theme
  ggplot2::theme_set(theme_default())
  packageStartupMessage("This is bayesplot version ", ver)
}
