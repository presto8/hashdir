package main

import (
	"crypto/sha256"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"io"
)

func hash_path(path string) {
	const BufferSize = 8096
	file, err := os.Open(path)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer file.Close()

	buffer := make([]byte, BufferSize)
	for {
		bytesread, err := file.Read(buffer)

		if err != nil {
			if err != io.EOF {
				fmt.Println(err)
			}

			break
		}

		fmt.Println("bytes read: ", bytesread)
		fmt.Println("bytestream to string: ", string(buffer[:bytesread]))
	}
}

func walk_path(toppath string) {
	result := make([]string, 0)
	err := filepath.Walk(toppath,
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			hash_path(path)
			hash := sha256.Sum256([]byte("hello world\n"))
			fmt.Printf("%x", hash)
			result = append(result, path)
			fmt.Println(path, info.Size())
			return nil
		})

	if err != nil {
		log.Println(err)
	}
}

func main() {
	walk_path("../test_dir")
}
