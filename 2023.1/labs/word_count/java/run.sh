ROOT_DIRECTORY=../dataset/

RESULT=../tmp/result
mkdir -p $RESULT

count_word_dir() {
        directory="$1"
        resultado=$(gradle -q runApp --args="$directory")
        archive_name=$(echo "$directory" | cut -c 12-19)
        echo "$resultado"> "$RESULT/$archive_name.txt"
}

for pasta in $(find "$ROOT_DIRECTORY" -type d -links 2); do
        count_word_dir "$pasta" &
done

wait

total_palavras=0
for resultado_file in "$RESULT"/*.txt; do
        resultado=$(cat "resultado_file")
        total_palavras=$((total_palavras + resultado))
done

echo "$total_palavras"

rm -rf "../tmp"
