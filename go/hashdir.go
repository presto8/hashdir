package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

func hash_path(path string) []byte {
	f, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	hash := sha256.New()
	if _, err := io.Copy(hash, f); err != nil {
		log.Fatal(err)
	}

	return hash.Sum(nil)
}

func hash_link(path string) []byte {
	target, err := os.Readlink(path)
	if err != nil {
		return nil
	}
	hash := sha256.New()
	hash.Write([]byte(target))
	return hash.Sum(nil)
}

func walk_path(toppath string) []string {
	result := make([]string, 0)
	err := filepath.Walk(toppath,
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			hash := []byte("")
			if info.Mode()&os.ModeSymlink != 0 {
				hash = hash_link(path)
			} else if !info.IsDir() {
				hash = hash_path(path)
			} else {
				return nil
			}
			path = strings.TrimPrefix(path, toppath)
			line := fmt.Sprintf("%s  .%s\n", hex.EncodeToString(hash), path)
			result = append(result, line)
			return nil
		})

	if err != nil {
		log.Println(err)
	}

	sort.Strings(result)
	return result
}

func main() {
	path := os.Args[1]
	hashes := walk_path(path)
	finalhash := sha256.New()
	for _, hash := range hashes {
		finalhash.Write([]byte(hash))
	}
	fmt.Printf("%s  %s\n", hex.EncodeToString(finalhash.Sum(nil))[:8], path)
}
