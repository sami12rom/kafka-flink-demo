#!/bin/bash

export FILE=".env"
export STATUS="./.status.dat"
source $FILE

terraform destroy --auto-approve
echo 0 > $STATUS