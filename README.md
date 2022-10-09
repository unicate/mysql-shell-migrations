# MYSQL-SHELL-MIGRATIONS

## Introduction

This shell script is an extremely simplified version of a database migration tool 
like [Flyway](https://flywaydb.org/) or [Phinx](https://phinx.org/).

It is simplified, because I believe it will be sufficient for 80 % of all cases, where you don't have 
to deal with millions of rows and hundreds of sql files.

You don't need down- or undo-migrations. In reality they will not work anyway and they just add complexity.
And really, down migrations are not meant to replace a proper backup and restore process for your database.
[Please read this note about 'undo-migrations' on the Flyway homepage.](https://flywaydb.org/documentation/concepts/migrations#undo-migrations)

So keep it simple, stupid! If some migrations fail, just fix the sql, reset and run migrations again from the start.

**The only way is up!**


## Install

    git clone https://github.com/unicate/mysql-shell-migrations.git mysql-shell-migrations

## Quickstart for Sample Database
Fist create config file.

    cp .config_default .config 

Then edit .config with your favorite text editor.

Set the absolute path to the mysql binary. Usually it's something like `/usr/bin/mysql`, `/usr/sbin/mysql` or `/usr/local/mysql`.
If you don't know try `which` or `whereis` commands.

In this example it is configured for MAMP under the following path:

    /Applications/MAMP/Library/bin/mysql

Make sure the MYSQL root user and password are set correctly. You can leave the rest unchanged.
    
    ROOT_USER="root"
    ROOT_PASSWORD="root"

> Please note: The default password 'root' is only for local development 
> and not recommended for production.

Start the initial setup. This will create config files and a database 'my_test' with a database-user 'test-user'.

    ./db.sh init

Now, run the migrations from the `sql/migrations` folder. If the migration was successfully applied the sql file will
be moved to `sql/migrations/done`.
    
    ./db.sh run

In case a migration fails it stays in the `sql/migrations` folder. Try to fix it and `run` again.
If your database has a certain complexity (dependencies, constraints, etc.) it's not always
easy to apply a failed sql migration. In this case try `reset` the database and the migrations.

    ./db.sh reset

This will drop and re-create the database. All sql migrations will be moved back from
`sql/migrations/done` to `sql/migrations`.

Now, you can just run all migrations again.

    ./db.sh run


## General Usage

    ./db.sh [init|run|reset|drop|clean]

### init
This creates all necessary config and sql files for creating and dropping the database and the then
creates the database.

> ATTENTION: This will overwrite existing config files and drops the database if it already exists.


### run
This runs all sql migrations from `sql/migrations`. If the migration was successful the sql file will
be moved to `sql/migrations/done`.

### reset
All sql migrations will be moved back from `sql/migrations/done` to `sql/migrations`. The database will be dropped and re-created.

### drop
Drops the database without further warning.

### clean
Deletes all automatically created config and sql files.


## Licence
Released under the MIT licence.
