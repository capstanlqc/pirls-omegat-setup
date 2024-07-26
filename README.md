# PIRLS OmegaT setup

## Getting started

You will need: 

- [OpenXLIFF](https://github.com/rmraya/OpenXLIFF)

info: https://capstanlqc.github.io/ttt_docs/tools/omegat/team_projects/


Changed segmentation: <sentence_seg>false</sentence_seg>


- create
- setup
- merge

## Dislaimers

The key in JSON files must be edited to remove backslashes.

("key"\s*:\s*"[^\n]+)\\\\
$1.

--
pirls2021ft_zzd_en_TheInkDrinker.json:

,{"key":"TheInkDrinker\\Question14.PE51D14C","original_text":"\u003Cp\u003EReading a book can be a pleasure.\u003C\/p\u003E","current_translation":"\u003Cp\u003EReading a book can be a pleasure.\u003C\/p\u003E"}]},

--

what to do with line breaks? 
remove them before conversion

        {
            "key": "EnjoymentSurvey_MarieCurie.Question.Citation.A",
            "original_text": "<p>Adapted from <i>Marie Curie: Prize-Winning Scientist<\/i> by Lori Mortensen, illustrated by Susan Jaekel, and <br>published in 2008 by Picture Window Books. Reproduced by kind permission of the author and illustrator. <br>Ambulance illustration used with permission by Illustration B. Strickler and Images Doc / Bayard.<\/p>",
            "current_translation": "<p>Adapted from <i>Marie Curie: Prize-Winning Scientist<\/i> by Lori Mortensen, illustrated by Susan Jaekel, and <br>published in 2008 by Picture Window Books. Reproduced by kind permission of the author and illustrator. <br>Ambulance illustration used with permission by Illustration B. Strickler and Images Doc / Bayard.<\/p>"
        },


-- 

explain notes to PMs
--

veryfire: look for consistency of live segments:
- apply segmentation in the source -- get all possible trnslations in the target 
- look for repetitions of the segments -- get all possible translation in the target for every repetition
- flag cases where none matches

-- ask rodolfo to consider: 

- apply segmentation only when source and target are identical (it can be assumed that the unit is not translated)
or check why it segments 

--

style recommendations for RM

---

tips and tricks:
navigate history: Ctrl+Shift+N