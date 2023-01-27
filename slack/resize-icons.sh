#!/bin/sh
set -e
for i in $(ls -1A svg)
do
    lower_i=$(echo "${i}" | tr '[A-Z]' '[a-z]' | sed -e 's|.svg|.png|g')
    convert "svg/${i}" -resize 32x32 "${lower_i}"
    error=$?
    if [ "${error}" -ne 0 ]
    then
        echo "Error!" >&2
        echo "Failed to convert \`svg/${i}\` to \`${lower_i}\`." >&2
        exit 1
    fi
done