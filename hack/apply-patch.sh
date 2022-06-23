#!/bin/bash

LAUNCH_DIR=$(pwd); SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; cd $SCRIPT_DIR; cd ..; SCRIPT_PARENT_DIR=$(pwd);

command=${1:-status}
patches_dir=${2:-$SCRIPT_PARENT_DIR/db/patches}
first_patch=${3:-1}
last_patch=${4:-99999}
# echo -e "$command\n $patches_dir\n $first_patch\n $last_patch"

set -o allexport
source $SCRIPT_PARENT_DIR/.env-docker
set +o allexport

DB_CONN_STRING="host=${DB_HOST} port=${DB_PORT} user=${DB_USER} password=${DB_PASSWORD} dbname=${DB_NAME} sslmode=${DB_SSL_MODE}"

go install github.com/pressly/goose/v3/cmd/goose@latest
goose -dir $patches_dir postgres "$DB_CONN_STRING" $command

 patch_files=$(ls $(pwd)/db/patches/*_stakesauce_api_patch.sql | sort -V)
 for patch_file in $patch_files; do
     patch=$(expr $(echo $patch_file | sed -e 's/.*[^0-9]\([0-9]\+\)[^0-9]*$/\1/') + 0)

     if [[ "$patch" > "$first_patch" || "$patch" == "$first_patch" ]]  && [[ "$patch" < "$last_patch" || "$patch" == "$last_patch" ]]
     then
         echo $patch
     fi
 done
