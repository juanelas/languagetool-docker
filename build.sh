#!/bin/bash
scriptname=$(basename $0)
echo ""

usage() {
  cat <<EOL
Usage: $scriptname [opts]

Build docker images of juanelas/languagetool getting the latest stable release of LanguageTool.

Options:
  -h, --help                shows this help
  -p, --publish             publish generated images to docker hub
  
EOL
}

error_unknown_option() {
  echo "ERROR: unknown option $1"
  echo ""
  usage
  exit 1
}

error_duplicated_option() {
  echo "ERROR: duplicated option $1"
  echo ""
  usage
  exit 1
}

used_options=()
check_used_option() {
  local option=${1:1} # remove initial dash since it makes the search fail
  local regex="\<$option\>"
  if [[ ${used_options[@]} =~ $regex ]]; then
    error_duplicated_option "-$option"
  else
    used_options+=("$option")
  fi
}

publish=false

while [ "$#" -gt 0 ]; do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  -p | --publish)
    check_used_option "-p"
    publish=true
    shift 1
    ;;
  *)
    error_unknown_option $1
    ;;
  esac
done

TMPDIR=$(mktemp)

# Clean on exit
trap "rm -rf $TMPDIR LanguageTool" EXIT

# Dowload latest LanguageTool stable release
wget -P $TMPDIR https://languagetool.org/download/LanguageTool-stable.zip

# Unzip it
unzip -d $TMPDIR/extracted $TMPDIR/LanguageTool-stable.zip

# Get the actual version from the unziped directory (LanguageTool-<version>)
VERSION=$(ls $TMPDIR/extracted | awk -F'-' '{ print $2 }')

# Move the extracted dir to LanguageTool on the current dir
mv $TMPDIR/extracted/LanguageTool-$VERSION LanguageTool

# Build
docker build -t juanelas/languagetool --build-arg="VERSION=$VERSION" .

# Tag the image with the version
docker tag juanelas/languagetool juanelas/languagetool:$VERSION
docker tag juanelas/languagetool juanelas/languagetool:latest

# If requested publication (-p), publish to docker hub
if [ $publish = true ]; then
  docker push juanelas/languagetool:$VERSION
  docker push juanelas/languagetool:latest
fi