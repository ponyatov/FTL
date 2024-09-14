#![allow(dead_code)]
#![allow(unused_variables)]
#![allow(unused_imports)]

//! <b>FTL</b>: NAND Flash translation layer

mod bib;
mod config;

#[cfg(feature = "nand")]
mod nand;

use std::{env, process::abort};

extern crate fuse;

use fuse::Filesystem;

struct NothingFilesystem;

impl Filesystem for NothingFilesystem {}

const PROGRAM_USAGE: &str = "Usage: FTL <ini.file> <mountpoint>";

/// program entry point
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
            eprintln!("{}", PROGRAM_USAGE);
            abort();
        }
    };
    fuse::mount(NothingFilesystem, &mount, &[]).unwrap();
}

/// print command line argument to stderr
/// @param[in] argc
/// @param[in] argv
fn arg(argc: usize, argv: &String) {
    eprintln!("argv[{argc}] = <{argv}>");
}
