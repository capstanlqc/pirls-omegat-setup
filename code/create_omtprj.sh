#!/bin/bash

app_root=$(dirname $(dirname $(readlink -fm $0)))
set -a && source $app_root/code/.env && set +a

locales="$app_root/config/locales-test.txt"

cd $app_root/repos

for locale in `cat $locales`;
do
    # get project name and path
    omtprj_dname="${omtprj_dname_template/LOCALE/"$locale"}"
    omtprj_dpath=$app_root/repos/$omtprj_dname

    # create repo
    gh repo create capstanlqc-pirls/$omtprj_dname --public --clone --team translators

    # create omegat project    
    cd $omtprj_dpath
    $jrebin_fpath -jar $omegat_jpath team init $source_lang $target_lang

    # push the thing
    git add . 
    git commit -m "Initial commit: created omegat project"
    git push --set-upstream origin master

done