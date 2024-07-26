#!/bin/bash

app_root=$(dirname $(dirname $(readlink -fm $0)))
set -a && source $app_root/code/.env && set +a

locales="$app_root/config/locales-test.txt"

for target_lang in `cat $locales`;
do  
    omtprj_dname="${omtprj_dname_template/LOCALE/"$target_lang"}"
    [ -d $app_root/repos/$omtprj_dname ] || continue

    omtprj_dpath=$app_root/repos/$omtprj_dname

    # copy config files
    cp $app_root/config/filters.xml $app_root/config/okf_xliff@pirls.fprm $omtprj_dpath/omegat

    # copy template omegat.project and update language, or
    # tweak options

    # add zwnb segmentation file
    # add znwb after trailing and before initial tags? (both in source and target)
    # if segment starts with <source><ph id="0">&lt;p&gt;</ph>
    # and ends with <ph id="\d+">&lt;/p&gt;</ph></source>
    # same in target
    # perhaps try adding these two segmentation rules to the srx that conversion uses
    # 


    # see EnjoymentSurvey_How_Did_We_Learn_To_Fly.Question.Prompt.A as example

    component="assessment"
    for fpath in $(find $source_per_lang/AM/$target_lang -name "*.json");
    do
        fname=$(basename $fpath)
        bash $open_xliff/convert.sh \
        -file $fpath \
        -srcLang $source_lang \
        -tgtLang $target_lang \
        -type JSON \
        -embed \
        # -srx $app_root/config/am_json.srx \
        -config $app_root/config/am_config.json \
        -xliff $omtprj_dpath/source/$component/$fname.xlf

        echo "----"
    done

    git add . 
    git commit -m "Initial commit: added/updated config and source files"
    git push

done

