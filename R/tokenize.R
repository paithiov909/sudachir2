#' Overriding `tagger_inner`...
#' @noRd
tagger_inner <- function(x, mode, config_file, resource_dir, dictionary_path) {
  res <-
    .Call(
      savvy_tagger_inner__impl,
      `x`, `mode`, `config_file`, `resource_dir`, `dictionary_path`
    )
  dplyr::as_tibble(res)
}

#' Wrapper that takes a tagger function
#'
#' @details
#' `tagger` is expected to be a function that takes single argument
#' (character vector to be tokenized) and returns a data.frame
#' containing the following columns:
#'
#' * `sentence_id`
#' * `token`
#' * `feature`
#'
#' @param sentences A character vector of sentences.
#' @param docnames A character vector of document names.
#' @param tagger A tagger function.
#' @returns A tibble.
#' @noRd
tagger_impl <- function(sentences, docnames, tagger) {
  res <- tagger(sentences)
  res %>%
    dplyr::mutate(
      doc_id = factor(.data$sentence_id, labels = docnames),
      .keep = "unused"
    ) %>%
    dplyr::relocate("doc_id", dplyr::everything())
}

#' Create a tagger function
#'
#' @details
#' This function just returns a wrapper function for tokenization,
#' i.e. does not actually create a tagger instance.
#' Even if arguments are invalid, this function does not raise any errors.
#'
#' @param dictionary_path A path to a dictionary file
#' such as `"system_core.dic"`.
#' @param config_file A path to a config file.
#' @param resource_dir A path to a resource directory.
#' @param mode Split mode for 'sudachi.rs'.
#' Either `"C"`, `"A"`, or `"B"`.
#' @returns A function inheriting class `purrr_function_partial`.
#' @export
create_tagger <- function(dictionary_path,
                          config_file = system.file("resources/sudachi.json", package = "sudachir2"), # nolint
                          resource_dir = system.file("resources", package = "sudachir2"), # nolint
                          mode = c("C", "A", "B")) {
  mode <- rlang::arg_match(mode)
  purrr::partial(
    tagger_inner,
    mode = mode,
    dictionary_path = dictionary_path,
    config_file = config_file,
    resource_dir = resource_dir
  )
}

#' Tokenize sentences using a tagger function
#'
#' @param x A data.frame like object or a character vector to be tokenized.
#' @param text_field <[`data-masked`][rlang::args_data_masking]>
#' String or symbol; column containing texts to be tokenized.
#' @param docid_field <[`data-masked`][rlang::args_data_masking]>
#' String or symbol; column containing document IDs.
#' @param tagger A tagger function out of [create_tagger()]
#' @returns A tibble.
#' @export
tokenize <- function(x, text_field = "text", docid_field = "doc_id", tagger) {
  UseMethod("tokenize")
}

#' @export
tokenize.default <- function(x,
                             text_field = "text",
                             docid_field = "doc_id",
                             tagger) {
  x <- dplyr::as_tibble(x)

  text_field <- enquo(text_field)
  docid_field <- enquo(docid_field)

  result <- tagger_impl(
    dplyr::pull(x, {{ text_field }}),
    dplyr::pull(x, {{ docid_field }}),
    tagger
  )

  # if it's a factor, preserve ordering
  col_names <- as_name(docid_field)
  if (is.factor(x[[col_names]])) {
    col_u <- levels(x[[col_names]])
  } else {
    col_u <- unique(x[[col_names]])
  }

  tbl <- x %>%
    dplyr::select(-!!text_field) %>%
    dplyr::mutate(dplyr::across(!!docid_field, ~ factor(., col_u))) %>%
    dplyr::rename(doc_id = {{ docid_field }}) %>%
    dplyr::left_join(
      result,
      by = c("doc_id" = "doc_id")
    )

  tbl
}

#' @export
tokenize.character <- function(x,
                               text_field = "text",
                               docid_field = "doc_id",
                               tagger) {
  nm <- names(x)
  if (is.null(nm)) {
    nm <- seq_along(x)
  }
  tagger_impl(x, nm, tagger)
}
