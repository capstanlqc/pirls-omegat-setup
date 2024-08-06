#!/bin/bash

app_root=$(dirname $(dirname $(readlink -fm $0)))
set -a && source $app_root/code/.env && set +a

locales="$app_root/config/locales-test.txt"

cd $app_root/repos

for target_lang in `cat $locales`;
do

    echo "============== $target_lang =============="
    # get project name and path
    omtprj_dname="${omtprj_dname_template/LOCALE/"$target_lang"}"
    omtprj_dpath=$app_root/repos/$omtprj_dname

    # check if repo exists
    git ls-remote https://github.com/capstanlqc-pirls/${omtprj_dname}.git -q >/dev/null 2>&1
    [ $? -eq 0 ] && continue

    # create repo
    gh repo create capstanlqc-pirls/$omtprj_dname --private --clone --team translators

    # create omegat project    
    cd $omtprj_dpath
    $jrebin_fpath -jar $omegat_jpath team init $source_lang $target_lang

    # add "*.xlf text" to .gitattributes
    echo "*.xlf text" >> .gitattributes

    # push the thing
    git add . 
    git commit -m "Initial commit: created omegat project"
    git push --set-upstream origin master

done