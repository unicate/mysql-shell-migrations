# MYSQL-SHELL-MIGRATIONS

## Install

    git clone https://github.com/unicate/mysql-shell-migrations.git mysql-shell-migrations

## Configuration
1. Rename the .config_default to .config.
2. Edit .config file and set all the required values.

## Initial Setup

Run the following in your shell:

    ./db.sh init

This creates all necessary config files and some sql files for creating and dropping the database.

> ATTENTION: This will overwrite existing config files.

## Usage

Basic usage:

    ./db.sh [init|run|drop|clean]

Arguments
- init: Starts the initial setup.
- run: Runs all DB migrations.
- drop: Drops the database.
- clean: Deletes all automatically created config files.

# Licence
Released under the MIT licence.
