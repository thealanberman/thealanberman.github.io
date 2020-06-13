#!/usr/bin/env bash

# Dependencies:
# go get -u github.com/gomarkdown/mdtohtml
# brew install yq

err(){
    echo "${1}"
    exit 1
}

yaml_file="mymisspentyouth.yaml"

[[ "${1}" ]] || err "USAGE: ${0} <episode>"
[[ -f "${yaml_file}" ]] || err "${yaml_file} is missing!"
EPISODE=$(( $1 - 1 ))
TITLE=$(yq r $yaml_file posts[${EPISODE}].name)
NUMBER=$(yq r $yaml_file posts[${EPISODE}].number)
TRACKLIST=$(yq r $yaml_file posts[${EPISODE}].tracklist)
NOTES=$(yq r $yaml_file posts[${EPISODE}].notes)
HTMLTRACKLIST=$(mdtohtml <<<"${TRACKLIST}" | tr -d '\n')
HTMLNOTES=$(mdtohtml <<<"${NOTES}" | tr -d '\n')
yq r "${yaml_file}" posttemplate > post.temp
yq r "${yaml_file}" feedtemplate > feed.temp

##############
# index.html 
##############
sed -i '' -e "s/%%%000%%%/${NUMBER}/g" post.temp
sed -i '' -e "s/%%%TITLE%%%/${TITLE}/g" post.temp
sed -i '' -e "s^%%%TRACKLIST%%%^${HTMLTRACKLIST}^" post.temp
sed -i '' -e "s^%%%NOTES%%%^${HTMLNOTES}^" post.temp
sed -i '' -e "s^%%%NOTES%%%^\&^g" post.temp
LINE=$(grep -n INSERT_NEW_HERE index.html | cut -d : -f 1)
sed -i '' -e "${LINE}r post.temp" index.html

##############
# feed.xml
##############
LINE=$(grep -n "UPDATE THIS" feed.xml | cut -d: -f1)
LINE=$(( LINE + 1 ))
PUBDATE=$(date -R)
sed -i '' -e "${LINE} s|.*|<pubDate>${PUBDATE}</pubDate>|" feed.xml
sed -i '' -e "s/DATE_HERE/${PUBDATE}/" feed.temp
sed -i '' -e "s/%%%000%%%/${NUMBER}/g" feed.temp
sed -i '' -e "s/%%%TITLE%%%/${TITLE}/g" feed.temp
printf "\n%s\n" "${NOTES}" > notes.temp
echo "${TRACKLIST}" > tracklist.temp
sed -i '' -e "s/^- //g" tracklist.temp
sed -i '' -e "/%%%TRACKLIST%%%/r tracklist.temp" feed.temp
sed -i '' -e "/%%%NOTES%%%/r notes.temp" feed.temp
sed -i '' -e "/%%%[A-Z]*%%%/d" feed.temp
LINE=$(grep -n "</item>" feed.xml | tail -1 | cut -d: -f1)
sed -i '' -e "${LINE}r feed.temp" feed.xml

# clean up
rm ./*.temp
