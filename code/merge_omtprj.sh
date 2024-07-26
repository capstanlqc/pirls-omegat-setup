#!/bin/bash

app_root=$(dirname $(dirname $(readlink -fm $0)))
set -a && source $app_root/code/.env && set +a

locales="$app_root/config/locales-test.txt"

for target_lang in `cat $locales`;
do  
    omtprj_dname="${omtprj_dname_template/LOCALE/"$target_lang"}"
    [ -d $app_root/repos/$omtprj_dname ] || continue

    omtprj_dpath=$app_root/repos/$omtprj_dname

    # $jrebin_fpath -jar $omegat_jpath team init en gl $omtprj_dpath --mode=console-translate --config-dir=$config_dpath  --script=$script_fpath

    component="assessment"
    bash $app_root/merge.sh \
    -file $omtprj_dpath/orig/$fname \
    -xliff $omtprj_dpath/target/$fname.xlf \
    -target $omtprj_dpath/done/$fname \
    -unapproved

    for fpath in $(find $source_per_lang/AM/$target_lang -name "*.json");
    do
        fname=$(basename $fpath)
        bash $open_xliff/merge.sh \
        -xliff $omtprj_dpath/target/$component/$fname.xlf \
        -target $final_dir/AM/$target_lang/$fname \
        -unapproved
    done

    # git add . 
    # git commit -m "Initial commit: created omegat project"
    # git push --set-upstream origin master

done

