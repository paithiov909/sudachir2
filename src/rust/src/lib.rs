use savvy::{savvy, savvy_err, NotAvailableValue};
use savvy::{OwnedIntegerSexp, OwnedListSexp, OwnedStringSexp, StringSexp};

use std::path::PathBuf;
use std::str::FromStr;

use sudachi::analysis::stateful_tokenizer::StatefulTokenizer;
use sudachi::analysis::Mode;
use sudachi::config::Config;
use sudachi::dic::dictionary::JapaneseDictionary;
use sudachi::prelude::MorphemeList;
use sudachi::sentence_splitter::{SentenceSplitter, SplitSentences};


#[savvy]
fn tagger_inner(
    x: StringSexp,
    mode: StringSexp,
    config_file: StringSexp,
    resource_dir: StringSexp,
    dictionary_path: StringSexp,
) -> savvy::Result<savvy::Sexp> {
    let mode = mode.iter().last().ok_or(savvy_err!("Failed to get mode"))?;
    let mode = match Mode::from_str(mode) {
        Ok(m) => m,
        Err(e) => return Err(savvy_err!("Failed to parse mode: {}", e)),
    };

    // Config
    let config_file = config_file
        .iter()
        .last()
        .ok_or(savvy_err!("Failed to get config file"))?;
    let resource_dir = resource_dir
        .iter()
        .last()
        .ok_or(savvy_err!("Failed to get resource dir"))?;
    let dictionary_path = dictionary_path
        .iter()
        .last()
        .ok_or(savvy_err!("Failed to get dictionary path"))?;
    let config_file = Some(PathBuf::from(config_file));
    let resource_dir = Some(PathBuf::from(resource_dir));
    let dictionary_path = Some(PathBuf::from(dictionary_path));
    let config = Config::new(config_file, resource_dir, dictionary_path)?;
    let dict = JapaneseDictionary::from_cfg(&config)?;

    // Tokenizer
    let mut tokenizer = StatefulTokenizer::new(&dict, mode);
    let splitter = SentenceSplitter::with_limit(32 * 1024).with_checker(dict.lexicon());

    let mut sentence_id: Vec<i32> = Vec::new();
    let mut surface: Vec<String> = Vec::new();
    let mut dictionary_form: Vec<String> = Vec::new();
    let mut normalized_form: Vec<String> = Vec::new();
    let mut reading_form: Vec<String> = Vec::new();
    let mut part_of_speech: Vec<String> = Vec::new();

    for (i, line) in x.iter().enumerate() {
        let mut morphemes = MorphemeList::empty(&dict);
        if line.is_na() | line.is_empty() {
            sentence_id.push((i + 1) as _);
            surface.push("".to_string());
            dictionary_form.push("".to_string());
            normalized_form.push("".to_string());
            reading_form.push("".to_string());
            part_of_speech.push(",,,,,".to_string());
            continue;
        }
        for (_, sentence) in splitter.split(line) {
            tokenizer.reset().push_str(sentence);
            tokenizer.do_tokenize()?;

            morphemes.collect_results(&mut tokenizer)?;

            for m in morphemes.iter() {
                sentence_id.push((i + 1) as _);
                surface.push(m.surface().to_string());
                dictionary_form.push(m.dictionary_form().to_string());
                normalized_form.push(m.normalized_form().to_string());
                reading_form.push(m.reading_form().to_string());
                let pos = m.part_of_speech().join(",");
                part_of_speech.push(pos);
            }
        }
    }

    let mut out = OwnedListSexp::new(6, true)?;
    out.set_name_and_value(0, "sentence_id", OwnedIntegerSexp::try_from_slice(sentence_id)?)?;
    out.set_name_and_value(1, "token", OwnedStringSexp::try_from_slice(surface)?)?;
    out.set_name_and_value(
        2,
        "dictionary_form",
        OwnedStringSexp::try_from_slice(dictionary_form)?,
    )?;
    out.set_name_and_value(
        3,
        "normalized_form",
        OwnedStringSexp::try_from_slice(normalized_form)?,
    )?;
    out.set_name_and_value(
        4,
        "reading_form",
        OwnedStringSexp::try_from_slice(reading_form)?,
    )?;
    out.set_name_and_value(
        5,
        "feature",
        OwnedStringSexp::try_from_slice(part_of_speech)?,
    )?;

    Ok(out.into())
}
