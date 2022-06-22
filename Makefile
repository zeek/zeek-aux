#
# A simple static wrapper for a number of standard Makefile targets,
# mostly just forwarding to build/Makefile. This is provided only for
# convenience and supports only a subset of what CMake's Makefile
# to offer. For more, execute that one directly.
#

REPO=$$(cd $(CURDIR) && basename $$(git config --get remote.origin.url | sed 's/^[^:]*://g'))
VERSION_FULL=$(REPO)-$$(cd $(CURDIR) && cat VERSION)
GITDIR=$$(test -f .git && echo $$(cut -d" " -f2 .git) || echo .git)

all:
	mkdir -p build && cd build && cmake .. && make

install: all
	cd build && make install

test: all
	./test.sh

# The COPYFILE_DISABLE flag used in the tar command below is an undocumented feature
# of the tar binary on macOS. It causes tar to avoid including any of the special files
# that macOS litters around the repository directory, such as ._ resource files, none
# of which should be included in the distribution packages.
dist:
	@test -e ../$(VERSION_FULL) && rm -ri ../$(VERSION_FULL) || true
	@cp -R . ../$(VERSION_FULL)
	@for i in . $$(git submodule foreach -q --recursive realpath --relative-to=$$(pwd) .); do ((cd ../$(VERSION_FULL)/$$i && test -f .git && cp -R $(GITDIR) .gitnew && rm -f .git && mv .gitnew .git && sed -i.bak -e 's#[[:space:]]*worktree[[:space:]]*=[[:space:]]*.*##g' .git/config) || true); done
	@for i in . $$(git submodule foreach -q --recursive realpath --relative-to=$$(pwd) .); do (cd ../$(VERSION_FULL)/$$i && git reset -q --hard && git clean -ffdxq); done
	@(cd ../$(VERSION_FULL) && find . -name \.git\* | xargs rm -rf)
	@(cd ../$(VERSION_FULL) && find . -name \.idea -type d | xargs rm -rf)
	@(cd ../$(VERSION_FULL) && find . -maxdepth 1 -name build\* | xargs rm -rf)
	@mv ../$(VERSION_FULL) .
	@COPYFILE_DISABLE=true tar -czf $(VERSION_FULL).tar.gz $(VERSION_FULL)
	@echo Package: $(VERSION_FULL).tar.gz
	@rm -rf $(VERSION_FULL)

.PHONY: all install test dist
