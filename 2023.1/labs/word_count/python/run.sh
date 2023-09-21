#!/bin/bash

root_directory="../dataset"
total_count=0

count_words() {
	local directory="$1"
	local temp_file="/tmp/count_$(echo "$directory" | tr / _)"
	local count=$(python3 word_count.py "$directory")
	echo "$count" > "$temp_file"
}

directories=$(find "$root_directory" -mindepth 1 -type d)
num_processes=4
bg_processes=()

for directory in $directories; do
	count_words "$directory" & 
	bg_processes+=($!)

	if (( ${#bg_processes[@]} >= num_processes )); then
		wait "${bg_processes[@]}"
		unset bg_processes
		bg_processes=()
	fi
done

wait "${bg_processes[@]}"

for temp_directory in $directories; do
	temp_file="/tmp/count_$(echo "$temp_directory" | tr / _)"
	count=$(cat "$temp_file" 2>/dev/null)
	if [ -n "$count" ]; then
		total_count=$((total_count + count))
		rm "$temp_file"
	fi
done

echo "Somatorio total das palavras: $total_count"
		






