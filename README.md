
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sudachir2 <img src="man/figures/logo.png" align="right" height="139" alt="sudachir2 logo" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/paithiov909/sudachir2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/paithiov909/sudachir2/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

An R wrapper for ‘Sudachi’; a modern reimagining of
[uribo/sudachir](https://github.com/uribo/sudachir) and
[yutannihilation/fledgingr](https://github.com/yutannihilation/fledgingr)
that directly wraps
[sudachi.rs](https://github.com/WorksApplications/sudachi.rs) with
[savvy](https://github.com/yutannihilation/savvy).

## Installation

``` r
install.packages("sudachir2", repos = c("https://paithiov909.r-universe.dev", "https://cloud.r-project.org"))
```

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
    tagger = create_tagger(dictionary_path = small_dict, mode = "C")
  )

toks
#> # A tibble: 16 × 6
#>    doc_id token  dictionary_form normalized_form reading_form feature           
#>    <fct>  <chr>  <chr>           <chr>           <chr>        <chr>             
#>  1 1      新しい 新しい          新しい          アタラシイ   形容詞,一般,*,*,形容詞,連体…
#>  2 1      朝     朝              朝              アサ         名詞,普通名詞,副詞可能,*,*,…
#>  3 1      が     が              が              ガ           助詞,格助詞,*,*,*,*……
#>  4 1      来     来る            来る            キ           動詞,非自立可能,*,*,カ行変格…
#>  5 1      た     た              た              タ           助動詞,*,*,*,助動詞-タ,終…
#>  6 2      希望   希望            希望            キボウ       名詞,普通名詞,サ変可能,*,*,…
#>  7 2      の     の              の              ノ           助詞,格助詞,*,*,*,*……
#>  8 2      朝     朝              朝              アサ         名詞,普通名詞,副詞可能,*,*,…
#>  9 2      だ     だ              だ              ダ           助動詞,*,*,*,助動詞-ダ,終…
#> 10 3      喜び   喜び            喜び            ヨロコビ     名詞,普通名詞,一般,*,*,*……
#> 11 3      に     に              に              ニ           助詞,格助詞,*,*,*,*……
#> 12 3      胸     胸              胸              ムネ         名詞,普通名詞,一般,*,*,*……
#> 13 3      を     を              を              ヲ           助詞,格助詞,*,*,*,*……
#> 14 3      開け   開ける          開ける          アケ         動詞,一般,*,*,下一段-カ行,…
#> 15 4      大空   大空            大空            オオゾラ     名詞,普通名詞,一般,*,*,*……
#> 16 4      あおげ あおぐ          あおぐ          アオゲ       動詞,一般,*,*,五段-ガ行,命…

prettify(toks) |> str()
#> tibble [16 × 11] (S3: tbl_df/tbl/data.frame)
#>  $ doc_id         : Factor w/ 4 levels "1","2","3","4": 1 1 1 1 1 2 2 2 2 3 ...
#>  $ token          : chr [1:16] "新しい" "朝" "が" "来" ...
#>  $ dictionary_form: chr [1:16] "新しい" "朝" "が" "来る" ...
#>  $ normalized_form: chr [1:16] "新しい" "朝" "が" "来る" ...
#>  $ reading_form   : chr [1:16] "アタラシイ" "アサ" "ガ" "キ" ...
#>  $ POS1           : chr [1:16] "形容詞" "名詞" "助詞" "動詞" ...
#>  $ POS2           : chr [1:16] "一般" "普通名詞" "格助詞" "非自立可能" ...
#>  $ POS3           : chr [1:16] NA "副詞可能" NA NA ...
#>  $ POS4           : chr [1:16] NA NA NA NA ...
#>  $ cType          : chr [1:16] "形容詞" NA NA "カ行変格" ...
#>  $ cForm          : chr [1:16] "連体形-一般" NA NA "連用形-一般" ...
```

## Versioning

This package is versioned by copying the version number of ‘sudachi.rs’,
where the first three digits represent that version number and the
fourth digit (if any) represents the patch release for this package.
