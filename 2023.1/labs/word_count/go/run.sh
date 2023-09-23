#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

directory=$1
numberOfWords=0

# Get all subdirectories in the given directory.
subdirs=$(find $directory -type d)

# Create a temporary file to store the results.
tempFile=$(mktemp)

# Iterate over each subdirectory and start a process to count the words.
for subdir in $subdirs; do
  if [ "$subdir" == "$directory" ]; then
      continue
  fi

  # Start a process to count the words in the subdirectory.
  go run ./word_count.go $subdir >> $tempFile &
done

# Wait for all processes to finish.
wait

# Sum up the results from each process.
while read line; do
  numberOfWords=$((numberOfWords + line))
done < $tempFile

rm $tempFile

echo $numberOfWords

