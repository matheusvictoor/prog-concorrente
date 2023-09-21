#!/bin/bash

# Este script coordena a execução de múltiplos processos para contar palavras em paralelo.

# Verifica se o argumento com o diretório foi fornecido
if [ -z "$1" ]; then
    echo "Uso: $0 <diretório>"
    exit 1
fi

# Diretório raiz
root_dir=$1

# Inicializa a variável de contagem de palavras
WC_COUNT=0

# Função para contar as palavras em um diretório
count_words_in_dir () {
    local dir_path=$1
    local count=0

    for filepath in $dir_path/*; do
        if [ -f "$filepath" ]; then
            count=$((count + $(wc -w < "$filepath")))
        fi
    done

    echo $count
}

# Itera sobre os subdiretórios
for subdir in $root_dir/*; do
    if [ -d "$subdir" ]; then
        count=$(count_words_in_dir "$subdir")
        WC_COUNT=$((WC_COUNT + count))
    fi
done

# Imprime a contagem total
echo "Total de palavras encontradas: $WC_COUNT"

