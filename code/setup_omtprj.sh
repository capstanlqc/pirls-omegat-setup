#!/bin/bash

app_root=$(dirname $(dirname $(readlink -fm $0)))
set -a && source $app_root/code/.env && set +a

locales="$app_root/config/locales-test.txt"
[ -d $common_dir ] || gh repo clone capstanlqc-pirls/common $common_dir
[ -d $final_dir ] || gh repo clone capstanlqc-pirls/final $final_dir
[ -d $common_dir ] && cd $common_dir && git pull && cd -
[ -d $final_dir ] && cd $final_dir && git pull && cd -

for target_lang in `cat $locales`;
do  
    omtprj_dname="${omtprj_dname_template/LOCALE/"$target_lang"}"
    [ -d $app_root/repos/$omtprj_dname ] || continue

    omtprj_dpath=$app_root/repos/$omtprj_dname

    # copy config files
    cp $app_root/config/filters.xml $omtprj_dpath/omegat
    cp $app_root/config/okf_xliff@pirls.fprm $omtprj_dpath/omegat
    cp $app_root/config/segmentation.conf $omtprj_dpath/omegat

    # copy assets
    mkdir -p $omtprj_dpath/tm/auto
    mkdir -p $omtprj_dpath/tm/enforce
    # any TMs (including T&A Notes), glossaries, etc.
    find $app_root/assets/dnt/ -name markup_${target_lang}.tmx -exec cp {} $omtprj_dpath/tm/enforce

    # optional step: insert znwj after trailing and before initial tags (both in source and target)
    # that is: replace 
    # (<(source|target)><ph id="0">&lt;p&gt;</ph>)([\s\S]+?)(<ph id="\d+">&lt;/p&gt;</ph></\2>)
    # with
    # $1‌$3$4
    # (inserting a zwnj between each captured group)
    # see EnjoymentSurvey_How_Did_We_Learn_To_Fly.Question.Prompt.A as example

    component="assessment"
    mkdir -p $omtprj_dpath/source/$component
    
    for fpath in $(find $source_per_lang/AM/$target_lang -name "*.json");
    do
        fname=$(basename $fpath)
        echo $fname
        bash $open_xliff/convert.sh \
        -file $fpath \
        -srcLang $source_lang \
        -tgtLang $target_lang \
        -type JSON \
        -embed \
        -config $app_root/config/am_config.json \
        -xliff $omtprj_dpath/source/$component/$fname.xlf
    done

    component="questionnaire"
    mkdir -p $omtprj_dpath/source/$component

    for fpath in $(find $source_per_lang/SE/$target_lang -name "*.json");
    do
        fname=$(basename $fpath)
        echo $fname
        bash $open_xliff/convert.sh \
        -file $fpath \
        -srcLang $source_lang \
        -tgtLang $target_lang \
        -type JSON \
        -embed \
        -config $app_root/config/se_config.json \
        -xliff $omtprj_dpath/source/$component/$fname.xlf
    done

    cd $omtprj_dpath
    git pull
    git add . 
    git commit -m "Initial commit: added/updated config and source files"
    git push
    echo "----"

done

