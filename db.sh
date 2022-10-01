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
# Write Config files
############################
init() {
    echo ">>> Creating config files."
    echo "ATTENTION: This will overwrite existing config files!"

    read -r -p "Do you want to continue? [y/n] " response
    case "$response" in
      [yY])
      echo ">>> Writing config files."
      ;;
    *)
      echo ">>> Creating config files aborted."
      exit 0
      ;;
    esac

# Writing DB Config
cat > .db.cnf << EOL
[client]
database = "${DATABASE}"
user = "${USER}"
password = "${PASSWORD}"
EOL

# Writing Root Config
cat > .root.cnf << EOL
[client]
user = "${ROOT_USER}"
password = "${ROOT_PASSWORD}"
host = "${HOST}"
EOL

# Writing Create DB SQL
cat > ./sql/create_db.sql << EOL
DROP DATABASE IF EXISTS ${DATABASE};

DROP USER IF EXISTS '${USER}'@'localhost';
DROP USER IF EXISTS '${USER}'@'%';

CREATE DATABASE ${DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER '${USER}'@'localhost' IDENTIFIED BY '${PASSWORD}';
CREATE USER '${USER}'@'%' IDENTIFIED BY '${PASSWORD}';

GRANT ALL ON ${DATABASE}.* TO '${USER}'@'localhost';
GRANT ALL ON ${DATABASE}.* TO '${USER}'@'%';

FLUSH PRIVILEGES;

use ${DATABASE};
EOL

# Writing Drop DB SQL
cat > ./sql/drop_db.sql << EOL
DROP DATABASE IF EXISTS ${DATABASE};
EOL

  echo ">>> Completed."
}

############################
# Create Database
############################
create() {
  echo ">>> Create database '${DATABASE}'."
  $MYSQL_BIN < "$BASEDIR"/sql/create_db.sql --defaults-extra-file=./.root.cnf
  echo ">>> Completed."
}

############################
# Run DB Migrations
############################
migrate() {
  echo ">>> Execute migrations on database '${DATABASE}'."
  for fileName in $(ls "$BASEDIR"/sql/migrations/*.sql | sort -n); do
    echo ">>> Executing SQL" "$fileName"
    $MYSQL_BIN --defaults-extra-file=./.db.cnf < "$fileName"
  done
  echo ">>> Completed."
}

############################
# Drop Database
############################
drop() {
  echo ">>> Dropping database '${DATABASE}'."
  $MYSQL_BIN < "$BASEDIR"/sql/drop_db.sql --defaults-extra-file=./.root.cnf
  echo ">>> Completed."
}

############################
# Clean up generated files
############################
clean() {
  echo ">>> Cleanup generated files."
  rm ./.db.cnf
  rm ./.root.cnf
  rm ./sql/create_db.sql
  rm ./sql/drop_db.sql
  echo ">>> Completed."
}

############################
# Arguments
############################
case "$1" in
"init")
  init
  ;;
"run")
  create
  migrate
  ;;
"drop")
  drop
  ;;
"clean")
  clean
  ;;
*)
  echo 'Usage: ./db.sh [init|run|drop|clean]'
  exit 1
  ;;
esac
