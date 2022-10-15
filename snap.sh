#!/bin/bash

clear
: '
**********************************
***** MYSQL SHELL MIGRATIONS *****
**********************************

MIT Licence
Copyright (c) 2022 unicate.ch

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the “Software”), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'

# Reading config file
. ./.config

# Setting global vars
MYSQL_BIN=${MYSQL_BIN}
BASEDIR=$(dirname "$0")

############################
# Create Snapshot
############################
snapshotCreate() {
  echo ">>> Enter snapshot name:"
  read -r input
  FILE_NAME=$(date "+%Y-%m-%d_%H%M%S")_snapshot_${input}.sql
  echo ">>> Creating snapshot '${FILE_NAME}' of database '${DATABASE}'."
  DUMP_FILE="$BASEDIR"/sql/snapshots/${FILE_NAME}
  $MYSQLDUMP_BIN --defaults-extra-file=./.root.cnf --add-drop-table "${DATABASE}" >"$DUMP_FILE"
  echo ">>> Completed."
}

############################
# Load Snapshot
############################
snapshotLoad() {
  unset options i
  echo ">>> Available snapshots from database '${DATABASE}'."
  for fileName in $(ls "$BASEDIR"/sql/snapshots/*.sql | sort -n); do
    options[i++]="$fileName"
    echo "[$i]" "$fileName"
  done

  len=${#options[@]}
  echo ">>> Select snapshot to load:"
  read -n1 -r -s input

  if [ "$input" -le "$len" ]; then
    echo ">>> Creating database '${DATABASE}'."
    $MYSQL_BIN <"$BASEDIR"/sql/create_db.sql --defaults-extra-file=./.root.cnf

    echo ">>> Loading snapshot '${options[$input - 1]}'."
    $MYSQL_BIN --defaults-extra-file=./.db.cnf <"${options[$input - 1]}"
    echo ">>> Completed."
  else
    echo ">>> Invalid selection."
  fi
}

############################
# Arguments
############################
case "$1" in
"init")
  ./db.sh init
  ;;
"create")
  snapshotCreate
  ;;
"load")
  snapshotLoad
  ;;
*)
  echo 'Usage: ./db.sh [init|create|load]'
  exit 1
  ;;
esac
