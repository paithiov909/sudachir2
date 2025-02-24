#' Prettify tokenized output
#'
#' Turns a single character column into features
#' while separating with delimiter.
#'
#' @param tbl A data.frame that has feature column to be prettified.
#' @param col <[`data-masked`][rlang::args_data_masking]>
#' Column containing features to be prettified.
#' @param into Character vector that is used as column names of
#' features.
#' @param col_select Character or integer vector that will be kept
#' in prettified features.
#' @param delim Character scalar used to separate fields within a feature.
#' @returns A data.frame.
#' @export
#' @examples
#' prettify(
#'   data.frame(x = c("x,y", "y,z", "z,x")),
#'   col = "x",
#'   into = c("a", "b"),
#'   col_select = "b"
#' )
prettify <- function(tbl,
                     col = "feature",
                     into = c("POS1", "POS2", "POS3", "POS4", "cType", "cForm"),
                     col_select = seq_along(into),
                     delim = ",") {
  if (is.numeric(col_select) && max(col_select) <= length(into)) {
    col_select <- which(seq_along(into) %in% col_select, arr.ind = TRUE)
  } else {
    col_select <- which(into %in% col_select, arr.ind = TRUE)
  }
  if (rlang::is_empty(col_select)) {
    rlang::abort("Invalid columns have been selected.")
  }

  col <- enquo(col)

  suppressWarnings({
    ## ignore warnings when there are missing columns.
    features <-
      c(
        paste0(into, collapse = ","),
        dplyr::pull(tbl, {{ col }})
      ) %>%
      I() %>%
      readr::read_delim(
        delim = delim,
        col_types = paste0(rep("c", length(into)), collapse = ""),
        col_select = col_select,
        na = c("*", "NA", ""),
        progress = FALSE,
        show_col_types = FALSE
      )
  })
  dplyr::bind_cols(dplyr::select(tbl, -!!col), features)
}
