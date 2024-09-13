use std::env;

extern crate fuse;

fn main() {
    let args = env::args().collect::<Vec<String>>();
    arg(0, &args[0]);
    for (argc, argv) in args.iter().skip(1).enumerate() {
        arg(argc, argv);
    }
}

fn arg(argc: usize, argv: &String) {
    eprintln!("argv[{argc}] = <{argv}>");
}
