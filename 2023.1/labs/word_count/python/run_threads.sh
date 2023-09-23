#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nome_do_dataset"
    exit 1
fi

dataset_dir="../$1"

python3 word_count_conc.py "$dataset_dir"
