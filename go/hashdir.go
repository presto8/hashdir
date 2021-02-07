package main

import (
	"crypto/sha256"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
    "strings"
    "sort"
)

func hash_path(path string) []byte {
	input := strings.NewReader(path)
	hash := sha256.New()
	if _, err := io.Copy(hash, input); err != nil {
		log.Fatal(err)
	}
	return hash.Sum(nil)
}

func walk_path(toppath string) []string {
	result := make([]string, 0)
	err := filepath.Walk(toppath,
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
            if ! info.IsDir() {
                hash := hash_path(path)
                path = strings.TrimPrefix(path, toppath)
                line := fmt.Sprintf("%x  .%s\n", hash, path)
                result = append(result, line)
            }
			return nil
		})

	if err != nil {
		log.Println(err)
	}

    sort.Strings(result)
    return result;
}

func main() {
    hashes := walk_path("../test_dir")
	finalhash := sha256.New()
    for _, hash := range hashes {
        fmt.Printf(hash)
        finalhash.Sum([]byte(hash))
    }
	fmt.Printf("%x", finalhash.Sum(nil))
}
