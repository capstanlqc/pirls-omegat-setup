#!/bin/bash

app_root=$(dirname $(dirname $(readlink -fm $0)))
set -a && source $app_root/code/.env && set +a

locales="$app_root/config/locales-test.txt"

for target_lang in `cat $locales`;
do  
    omtprj_dname="${omtprj_dname_template/LOCALE/"$target_lang"}"
    [ -d $app_root/repos/$omtprj_dname ] || continue

    # get project path
    omtprj_dpath=$app_root/repos/$omtprj_dname

    [ -d $omtprj_dpath ] || continue

    # if we don't trust users to have committed target files, then 
    # create offline version of repos/$omtprj_dpath: offline/$omtprj_dpath
    # $jrebin_fpath -jar $omegat_jpath offline/$omtprj_dpath --mode=console-translate --config-dir=$config_dpath  --script=$script_fpath

    # if we trust users, then just pull their target files

    # get target files and come back safely
    cd $omtprj_dpath
    git pull
    cd $app_root

    component="assessment"
    for fpath in $(find $source_per_lang/$component/$target_lang -name "*.json");
    do
        fname=$(basename $fpath)
        bash $open_xliff/merge.sh \
        -xliff $omtprj_dpath/target/$component/$fname.xlf \
        -target $final_dir/$component/$target_lang/$fname \
        -unapproved
    done

    component="questionnaire"
    for fpath in $(find $source_per_lang/$component/$target_lang -name "*.json");
    do
        fname=$(basename $fpath)
        echo "bash $open_xliff/merge.sh -xliff $omtprj_dpath/target/$component/$fname.xlf -target $final_dir/$component/$target_lang/$fname -unapproved"
        bash $open_xliff/merge.sh \
        -xliff $omtprj_dpath/target/$component/$fname.xlf \
        -target $final_dir/$component/$target_lang/$fname \
        -unapproved
    done

    # git add . 
    # git commit -m "Initial commit: created omegat project"
    # git push --set-upstream origin master
done

# todo:
# create target file's parent folder path chain