# tokenize works

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["token", "dictionary_form", "normalized_form", "reading_form", "feature", "doc_id"]
        },
        "row.names": {
          "type": "integer",
          "attributes": {},
          "value": [1, 2, 3]
        },
        "class": {
          "type": "character",
          "attributes": {},
          "value": ["tbl_df", "tbl", "data.frame"]
        }
      },
      "value": [
        {
          "type": "character",
          "attributes": {},
          "value": ["test", "", ""]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["test", "", ""]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["テスト", "", ""]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["テスト", "", ""]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["名詞,普通名詞,サ変可能,*,*,*", ",,,,,", ",,,,,"]
        },
        {
          "type": "integer",
          "attributes": {
            "levels": {
              "type": "character",
              "attributes": {},
              "value": ["1", "2", "3"]
            },
            "class": {
              "type": "character",
              "attributes": {},
              "value": ["factor"]
            }
          },
          "value": [1, 2, 3]
        }
      ]
    }

---

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["doc_id", "meta", "token", "dictionary_form", "normalized_form", "reading_form", "feature"]
        },
        "row.names": {
          "type": "integer",
          "attributes": {},
          "value": [1, 2, 3]
        },
        "class": {
          "type": "character",
          "attributes": {},
          "value": ["tbl_df", "tbl", "data.frame"]
        }
      },
      "value": [
        {
          "type": "integer",
          "attributes": {
            "levels": {
              "type": "character",
              "attributes": {},
              "value": ["A", "B", "C"]
            },
            "class": {
              "type": "character",
              "attributes": {},
              "value": ["factor"]
            }
          },
          "value": [1, 2, 3]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["a", "b", "c"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["aaa", "bbb", "ccc"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["AAA", "bbb", "ccc"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["AAA", "bbb", "ccc"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["エーエーエー", "bbb", "ccc"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["名詞,普通名詞,一般,*,*,*", "名詞,普通名詞,一般,*,*,*", "名詞,普通名詞,一般,*,*,*"]
        }
      ]
    }

