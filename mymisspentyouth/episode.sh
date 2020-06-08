#!/usr/bin/env bash
EPISODE=${1}
TITLE=${2}

usage(){
    echo "${0} <episode> <title> <tracklist>"
    echo "e.g. ${0} 005 \"Speckled Frogs\""
}

[[ ${1} ]] || usage
[[ ${2} ]] || usage
[[ ${3} ]] || usage


sed -e "s/%%%000%%%/${EPISODE}/g" -e "s/%%%TITLE%%%/${TITLE}/g" template-episode.txt
