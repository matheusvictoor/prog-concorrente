package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "os"
    "path/filepath"
    "strings"
    "sync"
)

func wc(fileContent string) int {
    words := strings.Fields(fileContent)
    return len(words)
}

func wc_file(filePath string) int {
    fileContent, err := ioutil.ReadFile(filePath)
    if err != nil {
        log.Fatal(err)
    }

    return wc(string(fileContent))
}

func wc_dir(directoryPath string) int {
    files, err := ioutil.ReadDir(directoryPath)
    if err != nil {
        log.Fatal(err)
    }

    var numberOfWords int
    for _, file := range files {
        if file.IsDir() {
            continue
        }

        filePath := filepath.Join(directoryPath, file.Name())
        numberOfWords += wc_file(filePath)
    }

    return numberOfWords
}

func main() {
    if len(os.Args) < 2 {
        fmt.Println("Usage: go run word_count.go <directory>")
        os.Exit(1)
    }

    directoryPath := os.Args[1]
    var numberOfWords int

    // Get all subdirectories in the given directory.
    subdirs, err := ioutil.ReadDir(directoryPath)
    if err != nil {
        log.Fatal(err)
    }

    // Create a WaitGroup to wait for all goroutines to finish.
    var wg sync.WaitGroup

    // Iterate over each subdirectory and start a goroutine to count the words.
    for _, subdir := range subdirs {
        if !subdir.IsDir() {
            continue
        }

        subdirPath := filepath.Join(directoryPath, subdir.Name())
        wg.Add(1)

        go func(subdirPath string) {
            defer wg.Done()
            numberOfWords += wc_dir(subdirPath)
        }(subdirPath)
    }

    // Wait for all goroutines to finish.
    wg.Wait()

    fmt.Println(numberOfWords)
}

