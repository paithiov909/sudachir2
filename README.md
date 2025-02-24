
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sudachir2 <img src="man/figures/logo.png" align="right" height="139" alt="sudachir2 logo" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

R bindings for
[sudachi.rs](https://github.com/WorksApplications/sudachi.rs).

## Usage

``` r
pkgload::load_all(export_all = FALSE)
#> ℹ Loading sudachir2

small_dict <-
  path.expand(
    file.path(
      fetch_dict(tempdir(), dict_version = "20240716", dict_type = "small"),
      "sudachi-dictionary-20240716",
      "system_small.dic"
    )
  )

dat <-
  dplyr::tibble(
    text = c("新しい朝が来た", "希望の朝だ", "喜びに胸を開け", "大空あおげ"),
    doc_id = seq_along(text)
  )

toks <-
  tokenize(
    dat, text, doc_id,
    tagger = create_tagger(dictionary_path = small_dict)
  )

toks
#> # A tibble: 16 × 6
#>    doc_id surface dictionary_form reading_form normalized_form feature          
#>    <fct>  <chr>   <chr>           <chr>        <chr>           <chr>            
#>  1 1      新しい  新しい          アタラシイ   新しい          形容詞,一般,*,*,形容詞,連…
#>  2 1      朝      朝              アサ         朝              名詞,普通名詞,副詞可能,*,*…
#>  3 1      が      が              ガ           が              助詞,格助詞,*,*,*,*……
#>  4 1      来      来る            キ           来る            動詞,非自立可能,*,*,カ行変…
#>  5 1      た      た              タ           た              助動詞,*,*,*,助動詞-タ,…
#>  6 2      希望    希望            キボウ       希望            名詞,普通名詞,サ変可能,*,*…
#>  7 2      の      の              ノ           の              助詞,格助詞,*,*,*,*……
#>  8 2      朝      朝              アサ         朝              名詞,普通名詞,副詞可能,*,*…
#>  9 2      だ      だ              ダ           だ              助動詞,*,*,*,助動詞-ダ,…
#> 10 3      喜び    喜び            ヨロコビ     喜び            名詞,普通名詞,一般,*,*,*…
#> 11 3      に      に              ニ           に              助詞,格助詞,*,*,*,*……
#> 12 3      胸      胸              ムネ         胸              名詞,普通名詞,一般,*,*,*…
#> 13 3      を      を              ヲ           を              助詞,格助詞,*,*,*,*……
#> 14 3      開け    開ける          アケ         開ける          動詞,一般,*,*,下一段-カ行…
#> 15 4      大空    大空            オオゾラ     大空            名詞,普通名詞,一般,*,*,*…
#> 16 4      あおげ  あおぐ          アオゲ       あおぐ          動詞,一般,*,*,五段-ガ行,…

prettify(toks)
#> # A tibble: 16 × 11
#>    doc_id surface dictionary_form reading_form normalized_form POS1  POS2  POS3 
#>    <fct>  <chr>   <chr>           <chr>        <chr>           <chr> <chr> <chr>
#>  1 1      新しい  新しい          アタラシイ   新しい          形容詞…… 一般  <NA> 
#>  2 1      朝      朝              アサ         朝              名詞  普通名詞… 副詞可能…
#>  3 1      が      が              ガ           が              助詞  格助詞…… <NA> 
#>  4 1      来      来る            キ           来る            動詞  非自立可… <NA> 
#>  5 1      た      た              タ           た              助動詞…… <NA>  <NA> 
#>  6 2      希望    希望            キボウ       希望            名詞  普通名詞… サ変可能…
#>  7 2      の      の              ノ           の              助詞  格助詞…… <NA> 
#>  8 2      朝      朝              アサ         朝              名詞  普通名詞… 副詞可能…
#>  9 2      だ      だ              ダ           だ              助動詞…… <NA>  <NA> 
#> 10 3      喜び    喜び            ヨロコビ     喜び            名詞  普通名詞… 一般 
#> 11 3      に      に              ニ           に              助詞  格助詞…… <NA> 
#> 12 3      胸      胸              ムネ         胸              名詞  普通名詞… 一般 
#> 13 3      を      を              ヲ           を              助詞  格助詞…… <NA> 
#> 14 3      開け    開ける          アケ         開ける          動詞  一般  <NA> 
#> 15 4      大空    大空            オオゾラ     大空            名詞  普通名詞… 一般 
#> 16 4      あおげ  あおぐ          アオゲ       あおぐ          動詞  一般  <NA> 
#> # ℹ 3 more variables: POS4 <chr>, cType <chr>, cForm <chr>
```
