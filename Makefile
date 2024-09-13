# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

# dir
CWD = $(CURDIR)
CAR = $(HOME)/.cargo/bin

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
	$(CARGO) run -- $<

# format
.PHONY: format
format: tmp/format_rs
tmp/format_rs: $(R)
	$(CARGO) check && $(CARGO) fmt && touch $@

