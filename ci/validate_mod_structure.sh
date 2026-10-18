#!/bin/sh

set -eu

error() {
    echo "$1" && exit 99
}

tag=${1:-}

expected_version=${tag:-"[0-9]{1,5}\.[0-9]{1,5}\.[0-9]{1,5}"}
expected_date=$([ -n "$tag" ] && date -I || echo "[0-9]{4}-[0-9]{2}-[0-9]{2}")
changelog_separator="---------------------------------------------------------------------------------------------------"

[ -f info.json ] || error "Missing info.json"
[ -n "$(jq .name info.json)" ] || error "Missing mod name"
jq .version info.json | grep -E $expected_version > /dev/null || error "Missing mod version"
[ -n "$(jq .title info.json)" ] || error "Missing mod title"
[ -n "$(jq .description info.json)" ] || error "Missing mod description"
[ -n "$(jq .author info.json)" ] || error "Missing mod author"
[ -n "$(jq .factorio_version info.json)" ] || error "Missing mod factorio_version"

[ -f changelog.txt ] || error "Missing changelog.txt"
[ $(head -n 1 changelog.txt) = $changelog_separator ] || error "Missing changelog separator"
head -n 2 changelog.txt | tail -n 1 | grep -E "Version: $expected_version" > /dev/null || error "Invalid changelog version"
head -n 3 changelog.txt | tail -n 1 | grep -E "Date: $expected_date" > /dev/null || error "Invalid changelog date"

[ -f thumbnail.png ] || error "Missing thumbnail.png"

# TODO Validate that all locales have all the keys

echo "Looks good to me"
