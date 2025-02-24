#' @keywords internal
#' @importFrom rlang enquo enquos ensym sym .data .env := as_name
#' @importFrom dplyr %>%
"_PACKAGE"

.onUnload <- function(libpath) {
  library.dynam.unload("sudachir2", libpath)
}
