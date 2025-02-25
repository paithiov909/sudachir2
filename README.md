
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sudachir2 <img src="man/figures/logo.png" align="right" height="139" alt="sudachir2 logo" />

<!-- badges: start -->

[![sudachir2 status
badge](https://paithiov909.r-universe.dev/sudachir2/badges/version)](https://paithiov909.r-universe.dev/sudachir2)
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

To install from source package, the Rust toolchain is required.

``` r
install.packages("sudachir2", repos = c("https://paithiov909.r-universe.dev", "https://cloud.r-project.org"))
```

## Usage

To use the package, you need to download a dictionary first. You can use
`sudachir2::fetch_dict()` to download the
[SudachiDict](https://github.com/WorksApplications/SudachiDict).

``` r
library(sudachir2)

small_dict <-
  file.path(tempdir(),
    "sudachi-dictionary-20250129",
    "system_small.dic"
  )

if (!file.exists(small_dict)) {
  fetch_dict(tempdir(), dict_version = "20250129", dict_type = "small")
}
```

After downloading the dictionary, you can create a tagger function.
`sudachir2::create_tagger()` returns a function that can be used to
tokenize texts.

``` r
my_tagger <- create_tagger(small_dict, mode = "C")
my_tagger("新しい朝が来た")
#> # A tibble: 5 × 6
#>   sentence_id token  dictionary_form normalized_form reading_form feature       
#>         <int> <chr>  <chr>           <chr>           <chr>        <chr>         
#> 1           1 新しい 新しい          新しい          アタラシイ   形容詞,一般,*,*,形容…
#> 2           1 朝     朝              朝              アサ         名詞,普通名詞,副詞可能,…
#> 3           1 が     が              が              ガ           助詞,格助詞,*,*,*,…
#> 4           1 来     来る            来る            キ           動詞,非自立可能,*,*,…
#> 5           1 た     た              た              タ           助動詞,*,*,*,助動詞…
```

For convenience, you can use `sudachir2::tokenize()` to tokenize a
data.frame as well as a character vector with a tagger function, and
`sudachir2::prettify()` to parse comma-delimited features.

``` r
tokenize("新しい朝が来た", tagger = my_tagger)
#> # A tibble: 5 × 6
#>   doc_id token  dictionary_form normalized_form reading_form feature            
#>   <fct>  <chr>  <chr>           <chr>           <chr>        <chr>              
#> 1 1      新しい 新しい          新しい          アタラシイ   形容詞,一般,*,*,形容詞,連体形…
#> 2 1      朝     朝              朝              アサ         名詞,普通名詞,副詞可能,*,*,*…
#> 3 1      が     が              が              ガ           助詞,格助詞,*,*,*,*
#> 4 1      来     来る            来る            キ           動詞,非自立可能,*,*,カ行変格,…
#> 5 1      た     た              た              タ           助動詞,*,*,*,助動詞-タ,終止…

dat <-
  dplyr::tibble(
    text = c("新しい朝が来た", "希望の朝だ", "喜びに胸を開け", "大空あおげ"),
    doc_id = seq_along(text)
  )

toks <-
  tokenize(
    dat, text, doc_id,
    tagger = my_tagger
  )

str(toks)
#> tibble [16 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ doc_id         : Factor w/ 4 levels "1","2","3","4": 1 1 1 1 1 2 2 2 2 3 ...
#>  $ token          : chr [1:16] "新しい" "朝" "が" "来" ...
#>  $ dictionary_form: chr [1:16] "新しい" "朝" "が" "来る" ...
#>  $ normalized_form: chr [1:16] "新しい" "朝" "が" "来る" ...
#>  $ reading_form   : chr [1:16] "アタラシイ" "アサ" "ガ" "キ" ...
#>  $ feature        : chr [1:16] "形容詞,一般,*,*,形容詞,連体形-一般" "名詞,普通名詞,副詞可能,*,*,*" "助詞,格助詞,*,*,*,*" "動詞,非自立可能,*,*,カ行変格,連用形-一般" ...

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

This package is versioned by copying the version number of
[sudachi.rs](https://github.com/WorksApplications/sudachi.rs), where the
first three digits represent that version number and the fourth digit
(if any) represents the patch release for this package.
