#!/bin/bash

export FILE=".env"
export STATUS="./.status.dat"

echo 0 > $STATUS

if [ ! -f "$FILE" ]; then
    echo
    echo "ERROR: File '$FILE' does not exist. Please create this file (example shown below)"
    echo
    echo "------------------------------"
    cat .env
    echo "------------------------------"
else
    source $FILE

    terraform init
    # Update timestamp on credit_card AVRO schema
    UTC_NOW=`date -u +%s000`
    # jq -c . < ./schemas/credit_card.avsc | sed 's/"/\\"/g' | sed "s/9999999999/$UTC_NOW/" > ./schemas/credit_card_timestamp.avsc

    terraform plan
    terraform apply --auto-approve
    terraform output -json
    echo 1 > $STATUS
fi