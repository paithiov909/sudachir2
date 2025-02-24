#' Download and unarchive a dictionary for 'Sudachi'
#'
#' @param exdir Directory where the dictionary will be unarchived.
#' @param dict_version Version of the dictionary to be downloaded.
#' @param dict_type Type of the dictionary to be downloaded.
#' Either `"small"`, `"core"`, or `"full"`.
#' @returns `exdir` is invisibly returned.
#' @export
fetch_dict <- function(exdir,
                       dict_version = "latest",
                       dict_type = c("small", "core", "full")) {
  dict_type <- rlang::arg_match(dict_type)
  dict_name <- paste0("sudachi-dictionary-", dict_version, "-", dict_type)
  url <- paste0(
    "https://d2ej7fkh96fzlu.cloudfront.net/sudachidict/",
    dict_name,
    ".zip"
  )
  temp <- tempfile(fileext = ".zip")
  utils::download.file(url, destfile = temp)
  utils::unzip(temp, exdir = exdir)
  return(invisible(exdir))
}
