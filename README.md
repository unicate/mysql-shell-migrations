# MYSQL-SHELL-MIGRATIONS

## Install

    git clone https://github.com/unicate/mysql-shell-migrations.git mysql-shell-migrations

## Quickstart for Sample Database
Fist create config file.

    cp .config_default .config 

Then edit .config with your favorite text editor.

Make sure the MYSQL root user and password are set correctly.

> Please note: The default password 'root' is only for local development 
> and not recommended for production.

Start the initial setup.

    ./db.sh init

And then create the database and run migrations. 

This will create a database 'my_test' with a database-user 'test-user'.

    ./db.sh run

You can run this command as many times you want. 
The database will always be dropped first and all migrations 
are executed from the beginning.

## General Usage

### Configuration
1. Rename the .config_default to .config.
2. Edit .config file and set all the required values.

### Initial Setup

Run the following in your shell:

    ./db.sh init

This creates all necessary config files and some sql files for creating and dropping the database.

> ATTENTION: This will overwrite existing config files.

### Commands

Basic usage:

    ./db.sh [init|run|drop|clean]

Arguments
- init: Starts the initial setup.
- run: Runs all DB migrations.
- drop: Drops the database.
- clean: Deletes all automatically created config files.

## Licence
Released under the MIT licence.
