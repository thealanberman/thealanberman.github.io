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
# yq r "${yaml_file}" feedtemplate > feed.temp

sed -i '' -e "s/%%%000%%%/${NUMBER}/g" post.temp
sed -i '' -e "s/%%%TITLE%%%/${TITLE}/g" post.temp
sed -i '' -e "s^%%%TRACKLIST%%%^${HTMLTRACKLIST}^" post.temp
sed -i '' -e "s^%%%NOTES%%%^${HTMLNOTES}^" post.temp
sed -i '' -e "s^%%%NOTES%%%^\&^g" post.temp
# inject post.temp in index.html
# rm post.temp
