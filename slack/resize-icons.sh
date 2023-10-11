#!/bin/sh
set -ex

cat > theme <<FRONTMATTER
Name=Slack Emoji Theme
Description=Slack colon codes and unicode characters
Icon=1f308.png
Author=Daniel Haskin

[default]
FRONTMATTER

tempfile=$(mktemp)

for i in $(ls -1A svg)
do
    lower_i=$(echo "${i}" | tr '[A-Z]' '[a-z]' | sed -e 's|.svg|.png|g')
    convert "svg/${i}" -resize 64x64 "${lower_i}"


    hexes=$(echo "${lower_i}" | sed -e 's|\.png||g' -e 's|^|0x|' -e 's|-| 0x|g')
    format_hexes=$(echo "${lower_i}" | sed -e 's|\.png||g' -e 's|[^-]\{1,\}|\\\\t\\\\U%08x|g' -e 's|-||g' -e 's|^|%%s|' -e 's|$|\\\\n|')
    printf $(printf "${format_hexes}" ${hexes}) "${lower_i}" >> "${tempfile}"
    error=$?
    if [ "${error}" -ne 0 ]
    then
        echo "Error!" >&2
        echo "Failed to convert \`svg/${i}\` to \`${lower_i}\`." >&2
        exit 1
    fi
done

cat "${tempfile}" slacks | sort -u >> theme