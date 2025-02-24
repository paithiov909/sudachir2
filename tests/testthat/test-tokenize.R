test_that("tokenize works", {
  skip_on_cran()
  skip_if_offline()

  dict <- path.expand(
    file.path(
      fetch_dict(tempdir(), dict_version = "20240716", dict_type = "small"),
      "sudachi-dictionary-20240716",
      "system_small.dic"
    )
  )

  expect_snapishot_value(
    tokenize(
      c("test", "", NA_character_),
      tagger = create_tagger(dictionary_path = dict)
    ),
    style = "json2",
    cran = FALSE
  )
  expect_snapishot_value(
    tokenize(
      data.frame(
        doc_id = c("A", "B", "C"),
        text = c("aaa", "bbb", "ccc"),
        meta = c("a", "b", "c")
      ),
      tagger = create_tagger(dictionary_path = dict)
    ),
    style = "json2",
    cran = FALSE
  )
})
