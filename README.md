# PIRLS OmegaT setup

## Summary

File preparation and project preparation for translation and verification tasks in OmegaT. \
The conversion involves bilingual extraction of source and target text from bilingual JSON files.

### Project preparation

Project preparation takes place *once* before any language tasks. The project preparation assumes bilingual (although not fully translated) JSON files as input and produces an omegat project for a translation/revision task.

> That omegat project can be used by the translator to produce/complete translations, and then by the verifier to revise the translator's version, or just the latter (if translation takes place elsewhere). 

### File preparation

File preparation takes place once if the translation task takes place in the omegat project. If that's not the case, then a second file preparation of fully translated files is necessary before the verification can start.

> There's no guarantee that countries will translate in the omegat project prepared to that effect for them. That's a crucial factor, and actions below depend on whether they do or not.

If the translator translates in OmegaT, the actions after translation is finalized are: 

- merge to produce translated JSON files
- upload (translated) target JSON files to the platform (TBC who does that in this case)

If the country does NOT use the omegat project, the actions after the translation is finalized are:

- add new (translated) JSON files to the `common/translated` repo/folder
- replace `$source_per_lang` with `$translated_per_lang` in `code/setup_omtprj.sh`
- file preparation of the new (translated) input file provided (which will overwrite the original source file in the project)

In any of the two scenarios above, before verification starts it is necessary to:

- revoke access rights from translator
- grant access rights to verifier

After the verification is finalized, the actions are: 

- upload (verified) target files to the platform (TBC who does that in this case)

### File clean-up

Prior to file preparation, some clean-up might be necessary in the source files, in order to:

- escape angle brackets in required adaptations, if they are not (e.g. `&lt;country&gt;`, not `<country>`)
- remove line breaks (`<br>`) in source text and target text (if still present)

See **Caveats** > **File clean-up** below for fixes in files that need to be done by (or in coordination with) content providers.

## Toolkit

You will need: 

- [OpenXLIFF](https://github.com/rmraya/OpenXLIFF)
- [Documentation about managing team projects on Github](https://capstanlqc.github.io/ttt_docs/tools/omegat/team_projects/)
- [OmegaT 5.7.2](https://github.com/capstanlqc/omegat/tree/main-capstan)

Clone this repository, make a copy of `code/.env.template*` as `code/.env`, and adapt the environment variables in your `code/.env` file according to your system.

## Tasks

#### 1. Project creation

To create the omegat team projects in the `capstanlqc-pirls` organization, first of all make sure that your local copy of the `common` folder/repo containing the source files is up to date with the latest versions.

Then, run:
```
bash code/create_omtprj.sh
```
#### 2. Project setup 

To set up the omegat team projects created in the step above, run:
```
bash code/setup_omtprj.sh
```
> Since source files are language-specific and might contain some translations, source files are to be committed directly in each project. There aren't original, common (version-neutral) files that all projects (for all target languages) may pull from a common repository.

Project settings (or user preferences) might need to be tweaked before setup depending on feedback from PMs or the client, so as to, e.g. 

- hide or protect untranslatable entities, e.g. `[Textbox 4]` (done!)
- flag forced adaptations (e.g. `<Lower secondary education— ISCED Level 2>`) in QA checks if the angle brackets have not been removed.

#### 3. Create deliverables

To create the deliverable files (e.g. target JSON files), run:
```
bash code/merge_omtprj.sh
```

## Caveats

### File clean-up

The `key` key in JSON files includes characters that are illegal in XLIFF IDs, such as spaces and backslashes. That needs to be addressed, in coordination with content maintainers and/or platform engineers, to avoid mismatches between delivered files and IDs expected by the platform. 

Proposed solution:

- Remove spaces
- Replace double backslashes (`\\`) with a dot.

### Language tags

Files must be identified using BCP47 language tags. The list of language tags corresponding to the languages in PIRLS 2026FT is available [here](config/locales.txt).

The full list of language tags for reference can be consulted here: https://capps.capstan.be/langtags.php

URLs to download team projects in all languages are available [here](docs/repos.md). 

### Segmentation

In FT, the input files supplied by the content provider (even before the translation task) have a bilingual strucuture (i.e. they contain source and target nodes) and may be in fact partially translated (or not). For example: 
```json
    {
        "key": "LibraryMouse\\Page5.Paragraph1",
        "original_text": "<p>Sam felt nervous. He was happy that the children liked his book. But mice are very shy! They don\u2019t like to be around people. Plus, Sam could not understand why people thought that making up stories was so hard. If only they would try, they might find out that writing is fun.<\/p>",
        "current_translation": "<p>Sam estaba muy nervioso. Estaba feliz de que a los niños les gustase su libro, ¡pero los ratones son muy vergonzosos! No les gusta estar junto con otras personas, además Sam no podía comprender porque crear historias era tan complicado para la gente. Si lo intentasen se darían cuenta de cuan divertido es escribir.<\/p>"
    },
```
That means 6 sentences in the source text:

    - Sam felt nervous. 
    - He was happy that the children liked his book. 
    - But mice are very shy! 
    - They don\u2019t like to be around people. 
    - Plus, Sam could not understand why people thought that making up stories was so hard. 
    - If only they would try, they might find out that writing is fun.

translated with 4 sentences: 

    - Sam estaba muy nervioso. 
    - Estaba feliz de que a los niños les gustase su libro, ¡pero los ratones son muy vergonzosos! 
    - No les gusta estar junto con otras personas, además Sam no podía comprender porque crear historias era tan complicado para la gente. 
    - Si lo intentasen se darían cuenta de cuan divertido es escribir.

That has a couple of practical implications: 

- the project preparation/settings requires bilingual import
- segmentation cannot be applied in text blocks where there's a discrepancy in the number of sentences between source and target text

Segmentation will be applied, however, in all other text blocks where there's no translation or where the number of sentences in the target text matches the number of sentences in the source text. 

<!-- 
Since segmentation is not applied, we can't guarantee sentence consistency throughout the project. Full segmentation and therefore sentence consistency would easy to apply provided that: 

- countries used the omegat project to translate, and
- we received fully untranslated source files or if it was okay to include current translations as a reference TM but without being expected that they are already populated in the project
-->

### Markup

If translations are produced in an environment other than a CAT tool, there will be no guarantee that markup will have been handled correctly in the tranlated files submitted for verification. 

> In other words, there's no guarantee that markup in the source text will have been maintained in the translation and, vice versa, no guarantee either that any markup used in the target text will actually be present in the source text.

This means that verifiers might need to add or remove tags in the target version to fix any tag issues. 

<!-- 
```json
    {
        "key": "TheOstrichAndTheHat.Page5.Paragraph2",
        "original_text": "<p>\"Ostriches may be strong, but they are not very bright.<br>I had remembered being told that if you put your hat on a stick and then held it up high, an ostrich would think that<br>the hat was your head. They would also think that you were much taller than they were, and so they would leave you well alone. And, do you know, it worked! The ostrich saw my hat and thought I must be a very tall and strong creature\u2014more than a match for her. So she backed off and I was able to continue on my way unkicked.\"<\/p>",
        "current_translation": "<pc id=\"t1\" dataRefStart=\"d1\" dataRefEnd=\"d3\">\"Ostriches may be strong, but they are not very bright.<br>the hat was your head. They would also think that you were much taller than they were, and so they would leave you well alone. And, do you know, it worked! The ostrich saw my hat and thought I must be a very tall and strong creature\u2014more than a match for her. So she backed off and I was able to continue on my way unkicked.\"<\/pc>"
    },
```
-->

### Label identifiers

In questionnaires, OmegaT will display the text block's `item_label` as identifier (ID). In assessmennts, OmegaT will display the text block's `key` as identifier (ID).

## To do / Pending

1. Investigate why the project may reload twice even though there are no changes in source files.
2. Discuss QA checks in VeryFire
3. Discuss T&A notes
4. Fix issue with parsing HTML entities, e.g. 

    JSON:
    ```json
    {
      "textblock_id": 23250,
      "item_label": "HQ_07_ar-IEA",
      "source_text": "<p>Your Child&#39;s School</p>",
      "target_text": "<p>Your Child&#39;s School</p>",
      "approved": "no",
      "comments": []
    }
    ```
    XLIFF:
    ```xml
    <trans-unit resname="HQ_07_ar-IEA" xml:space="preserve" id="23250">
        <source>Your Child&amp;#39;s School</source>
        <target>Your Child&amp;#39;s School</target>
    </trans-unit>
    ```
5. Pending updates in OpenXLIFF: 

    - config option `mergeTags` (expected in v. ^3.21) to fix issue with collapsed adjacent inline codes
    - config option `rawSegmentation` (expected in v. ^3.21) to split betweeen `</p><p>` and the like

6. Update setup script to fetch XLIFF files directly (without conversion) if no JSON is available
7. Put the convert block in a function that is called once for each component (once for assessments, once for questionnaires)
8. Create chain of ancestor paths where files are to be written