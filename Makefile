# Allow to use a different pandoc binary, e.g. when testing
PANDOC ?= pandoc

# Allow to adjust the diff command if necessary
DIFF = diff

# Use a POSIX sed with ERE ('v' is specific to GNU sed)
SED := sed $(shell sed v </dev/null >/dev/null 2>&1 && echo " --posix") -E

# Name of the filter file, *with* `.lua` file extension
FILTER_FILE := include-code-files.lua

# Name of the filter, *without* `.lua` file extension
FILTER_NAME = $(patsubst %.lua,%,$(FILTER_FILE))

# Current version (the latest tag).
VERSION = $(shell git tag --sort=-version:refname --merged | head -n1 | \
					sed -e 's/^v//' | tr -d "\n")

## Show available targets
# Comments preceding "simple" targets (those which do not use macro
# name) and introduced by two dashes are used as their description.
.PHONY: help
help:
	@tabs 22 ; $(SED) -ne \
	'/^## / h ; /^[^.$$#][^ ]+:/ { G; s/^(.*):.*##(.*)/\1@\2/; P ; h }' \
	$(MAKEFILE_LIST) | tr @ '\t'

## Test that running the filter on the sample input yields expected output
.PHONY: test
test: $(FILTER_FILE) test/input.md test/test.yml
	$(PANDOC) --defaults test/test.yml | \
		$(DIFF) test/expected.native -

## Re-generate the expected test output
# This file **must not** be a dependency of the `test` target, as that
# would cause it to be regenerated on each run, making the test
# pointless.
test/expected.native: $(FILTER_FILE) test/input.md test/test.yml
	$(PANDOC) --defaults test/test.yml --output=$@

## Generate an example from test/input.md
test/output.html: $(FILTER_FILE) test/input.md
	$(PANDOC) -s --lua-filter=$< test/input.md --output=$@

## Sets a new release using VERSION
.PHONY: release
release:
	git commit -am "Release $(FILTER_NAME) $(VERSION)"
	git tag v$(VERSION) -m "$(FILTER_NAME) $(VERSION)"

## Clean unnecessary files
.PHONY: clean
clean:
	-rm -f *~
