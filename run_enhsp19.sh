#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <problem-file>"
    exit 1
fi

PROBLEM_FILE="$1"
DOMAIN_FILE="maindomain.pddl"
ENHSP_DIR="enhsp-19/nbdist"

java -jar "$ENHSP_DIR/enhsp-19.jar" enhsp.Main -o "$DOMAIN_FILE" -f "$PROBLEM_FILE"
