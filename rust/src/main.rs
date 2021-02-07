use structopt::StructOpt;
use walkdir::WalkDir;
use std::path::{Path, PathBuf};
use std::io::{BufReader, Read};
use std::fs;
use ring::digest::{Context, SHA256};

#[derive(StructOpt)]
struct Cli {
    /// The path to compute the hashdir for
    #[structopt(parse(from_os_str))]
    path: PathBuf,
}

fn hash_path(path: &Path) -> String {
    let file = fs::File::open(path).unwrap();
    let mut reader = BufReader::new(&file);
    let mut hasher = Context::new(&SHA256);
    let mut buffer = [0; 8096];
    loop {
        let n = reader.read(&mut buffer).unwrap();
        if n == 0 { break; }
        hasher.update(&buffer[0..n]);
    }
    let result = hasher.finish();
    hex::encode(&result.as_ref())
}

fn hash_link(path: &Path) -> String {
    let contents = path.read_link().unwrap();
    let mut hasher = Context::new(&SHA256);
    hasher.update(contents.to_str().unwrap().as_bytes());
    let result = hasher.finish();
    hex::encode(&result.as_ref())
}

fn walk_fs(path: &Path) -> Vec<String> {
    let mut result = Vec::new();
    for entry in WalkDir::new(path)
            .into_iter()
            .filter_map(|v| v.ok())
            .filter(|e| !e.file_type().is_dir()) {
                let hash = {
                    if entry.file_type().is_symlink() {
                        hash_link(entry.path())
                    } else {
                        hash_path(entry.path())
                    }
                };
                let relpath = entry.path().strip_prefix(path).unwrap();
                let line = format!("{}  ./{}\n", hash, relpath.display());
                result.push(line);
            }
    result.sort();
    result
}

fn main() {
    let args = Cli::from_args();
    let hashes = walk_fs(&args.path);
    let mut hasher = Context::new(&SHA256);
    for hash in &hashes {
        hasher.update(hash.as_bytes());
        // print!("{}", hash);
    }
    let result = hasher.finish();
    let megahash = hex::encode(&result.as_ref());
    println!("{}  {}", &megahash[..8], args.path.display());
}
