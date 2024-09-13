# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

# cross
TARGET = thumbv7m-none-eabi

# dir
CWD   = $(CURDIR)
TMP   = $(CWD)/tmp
CAR   = $(HOME)/.cargo/bin
MOUNT = $(TMP)/mount

# tool
CURL   = curl -L -o
RUSTUP = $(CAR)/rustup
CARGO  = $(CAR)/cargo
GITREF = git clone --depth 1

# src
R += $(wildcard src/*.rs)

# all
.PHONY: run all
all: $(R)
	$(CARGO) build
run: lib/$(MODULE).ini $(R)
	mkdir -p tmp/mount ; $(CARGO) run -- $< tmp/mount

# format
.PHONY: format
format: tmp/format_rs
tmp/format_rs: $(R)
	$(CARGO) check && $(CARGO) fmt && touch $@

# doc
.PHONY: doc
doc: doc/The_Rust_Programming_Language.pdf

doc/The_Rust_Programming_Language.pdf: $(HOME)/doc/Rust/The_Rust_Programming_Language.pdf
	cd doc ; ln -fs ../../doc/Rust/The_Rust_Programming_Language.pdf The_Rust_Programming_Language.pdf
$(HOME)/doc/Rust/The_Rust_Programming_Language.pdf:
	$(CURL) $@ https://www.scs.stanford.edu/~zyedidia/docs/rust/rust_book.pdf

# install
.PHONY: install update ref gz
install: doc ref gz $(RUSTUP)
	$(MAKE) update rust
update: $(RUSTUP)
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	$(RUSTUP) self update ; $(RUSTUP) update stable
ref:
gz:

.PHONY: rust
rust: $(RUSTUP)
	$(RUSTUP) component add rustfmt
	$(RUSTUP) target add $(TARGET)
$(RUSTUP):
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
