#![allow(dead_code)]
#![allow(unused_variables)]
#![allow(unused_imports)]

mod config;
use config::*;

use std::{env, process::abort};

extern crate fuse;

use fuse::Filesystem;

struct NothingFilesystem;

impl Filesystem for NothingFilesystem {}

fn main() {
    let args = env::args().collect::<Vec<String>>();
    arg(0, &args[0]);
    for (argc, argv) in args.iter().skip(1).enumerate() {
        arg(argc, argv);
    }
    //
    let mount = match env::args().nth(2) {
        Some(path) => path,
        None => {
            eprintln!("Usage: {} <ini.file> <mountpoint>", args[0]);
            abort();
        }
    };
    fuse::mount(NothingFilesystem, &mount, &[]).unwrap();
}

fn arg(argc: usize, argv: &String) {
    eprintln!("argv[{argc}] = <{argv}>");
}
