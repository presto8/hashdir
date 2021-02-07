package main

import "fmt"
import "os"
import "path/filepath"
import "log"

func walk_path(toppath string) {
	err := filepath.Walk(toppath,
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
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
