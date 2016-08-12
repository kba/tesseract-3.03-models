#!/bin/bash
tpl='{
"author": "zdenop",
"author-email": "zdenop@gmail.com",
"license": "Apache 2.0",
"modified": "2015-06-25T12:25:00Z",
"name": "__NAME__",
"summary": "Tesseract 3.03 __NAME__ model",
"url": "https://github.com/tesseract-ocr/tessdata",
__FILES__
}'
declare -a dirs=($(find . -maxdepth 1 -type f -name '*.*'|sed -e 's,^\./,,' -e 's/\..*//'|sort|uniq))
for name in "${dirs[@]}";do
    mkdir -p "$name"
    declare -a files=($(find -name "$name.*"))
    tplFiles=$(echo "${files[@]}"|sed \
        -e 's,^\./,,' \
        -e 's/ /", "/g' \
        -e 's/^/"files": ["/' \
        -e 's/$/"]/')
    mv -t "$name/" "${files[@]}"
    echo "$tpl" |sed  \
        -e "s/__NAME__/$name/g" \
        -e "s@__FILES__@$tplFiles@g" > "$name/DESCRIPTION"
done
