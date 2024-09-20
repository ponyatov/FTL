# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

# version

# cross
TARGET = thumbv7m-none-eabi

# dir
CWD   = $(CURDIR)
TMP   = $(CWD)/tmp
CAR   = $(HOME)/.cargo/bin
REF   = $(CWD)/ref
GZ    = $(HOME)/gz
MOUNT = $(TMP)/mount

# tool
CURL   = curl -L -o
CF     = clang-format
RUSTUP = $(CAR)/rustup
CARGO  = $(CAR)/cargo
GITREF = git clone --depth 1

# src
R += $(wildcard src/*.rs)
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)

# all
.PHONY: run all
all: $(R)
	$(CARGO) build
run: lib/$(MODULE).ini $(R)
	( sleep 2 ; umount tmp/mount ) &
	mkdir -p tmp/mount ; $(CARGO) run -- $< tmp/mount

# format
.PHONY: format
format: tmp/format_rs
tmp/format_rs: $(R)
	$(CARGO) check && $(CARGO) fmt && touch $@

# rule

# doc
.PHONY: doc
doc: doc/The_Rust_Programming_Language.pdf

doc/The_Rust_Programming_Language.pdf: $(HOME)/doc/Rust/The_Rust_Programming_Language.pdf
	cd doc ; ln -fs ../../doc/Rust/The_Rust_Programming_Language.pdf The_Rust_Programming_Language.pdf
$(HOME)/doc/Rust/The_Rust_Programming_Language.pdf:
	$(CURL) $@ https://www.scs.stanford.edu/~zyedidia/docs/rust/rust_book.pdf

.PHONY: doxy
doxy: $(R)
	$(CARGO) doc --no-deps --document-private-items \
					--workspace --target-dir docs

# install
.PHONY: install update ref gz
install: doc ref gz $(RUSTUP)
	$(MAKE) rust update
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

# merge
MERGE += Makefile README.md apt.txt LICENSE
MERGE += .clang-format .doxygen .gitignore
MERGE += .vscode bin doc lib inc src tmp ref
MERGE += .cargo Cargo.* *.toml

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)

.PHONY: shadow
shadow:
	git push -v
	git checkout $@
	git pull -v

.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v --tags
	$(MAKE) shadow

.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(NOW)_$(REL).src.zip \
	HEAD
