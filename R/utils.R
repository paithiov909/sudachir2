#' Create a list of tokens
#'
#' @param tbl A tibble of tokens out of `tokenize()`.
#' @param token_field <[`data-masked`][rlang::args_data_masking]>
#' Column containing tokens.
#' @param pos_field Column containing features
#' that will be kept as the names of tokens.
#' If you don't need them, give a `NULL` for this argument.
#' @param nm Names of returned list.
#' If left with `NULL`, "doc_id" field of `tbl` is used instead.
#' @returns A named list of tokens.
#' @export
as_tokens <- function(tbl,
                      token_field = "token",
                      pos_field = NULL,
                      nm = NULL) {
  token_field <- as_name(enquo(token_field))
  col_names <- as_name("doc_id")

  if (is.null(nm)) {
    if (is.factor(tbl[[col_names]])) {
      nm <- levels(tbl[[col_names]])
    } else {
      nm <- unique(tbl[[col_names]])
    }
  }

  if (is.null(pos_field)) {
    tbl[[token_field]] %>%
      split(tbl[[col_names]]) %>%
      rlang::set_names(nm)
  } else {
    rlang::set_names(tbl[[token_field]], tbl[[pos_field]]) %>%
      split(tbl[[col_names]]) %>%
      rlang::set_names(nm)
  }
}

#' Check if scalars are blank
#'
#' @param x Object to check its emptiness.
#' @param trim Logical.
#' @param ... Additional arguments for [base::sapply()].
#' @returns Logicals.
#' @export
#' @examples
#' is_blank(list(c(a = "", b = NA_character_), NULL))
is_blank <- function(x, trim = TRUE, ...) {
  if (!is.list(x)) {
    if (is.null(x)) {
      return(TRUE)
    }
    if (is.character(x) && trim) x <- stringi::stri_trim(x)
    is.blank(x)
  } else {
    if (length(x) == 0) {
      return(TRUE)
    }
    sapply(x, is_blank, trim = trim, ...)
  }
}

is.blank <- function(x) {
  UseMethod("is.blank", x)
}

#' @export
is.blank.default <- function(x) {
  is.na(x) | is.nan(x)
}

#' @export
is.blank.character <- function(x) {
  is.na(x) | stringi::stri_isempty(x)
}
