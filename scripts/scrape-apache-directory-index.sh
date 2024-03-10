#!/bin/bash

set -e

if [ $# -ne 2 ]; then
  echo "usage: $0 <base_uri> <target_dir_path>"
  exit 1;
fi

BASE_URI=$1
TARGET_DIR_PATH=$2
INDEX_FILE='index.html'

fetch()
{
  echo "\$1 $1"
  INDEX_URI="${BASE_URI}${1}"
  DIR=`basename "${1}"`

  if [ ! -d "${DIR}" ]; then
    mkdir -pv "${DIR}"
  fi

  pushd "${DIR}" > /dev/null

  echo "INFO: Downloading $INDEX_URI"
  curl -o $INDEX_FILE -s -L "${INDEX_URI}"

  if [ $? -eq 0 ]; then
    TXTS=`grep '\[TXT\]' $INDEX_FILE | sed -e 's/.*href="\([^"]*\).*/\1/g'`
    PDFS=`grep '.PDF' $INDEX_FILE | sed -e 's/.*href="\([^"]*\).*/\1/g'`
    GIFS=`grep '.GIF' $INDEX_FILE | sed -e 's/.*href="\([^"]*\).*/\1/g'`
    UNKNOWNS=`grep '\[   \]' $INDEX_FILE | sed -e 's/.*href="\([^"]*\).*/\1/g'`
    DIRS=`grep '\[DIR\]' $INDEX_FILE | grep -v 'Parent Directory' | sed -e 's/.*href="\([^"]*\).*/\1/g'`

    for FILE in ${TXTS} ${PDFS} ${GIFS} ${UNKNOWNS}; do
      FILE_URI="${BASE_URI}${FILE}"
      echo "INFO: Downloading $FILE_URI"
      curl -O -s -L -R "${FILE_URI}"
      if  [ $? -ne 0 ]; then
        echo "WARN: Failed to download: $FILE_URI" 1>&2
      fi
    done

    for DIR in $DIRS; do
      fetch ${DIR}
    done

    rm -f $INDEX_FILE
  else
    echo "WARN: Failed to download directory index: $INDEX_URI" 1>&2
  fi

  popd > /dev/null
}

fetch "${TARGET_DIR_PATH}"
