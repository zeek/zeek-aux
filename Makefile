
REPO=$$(cd $(CURDIR) && basename $$(git config --get remote.origin.url | sed 's/^[^:]*://g'))
VERSION_FULL=$(REPO)-$$(cd $(CURDIR) && cat VERSION)
GITDIR=$$(test -f .git && echo $$(cut -d" " -f2 .git) || echo .git)

all:
	mkdir -p build && cd build && cmake .. && make

install: all
	cd build && make install

test: all
	./test.sh

dist:
	@test -e ../$(VERSION_FULL) && rm -ri ../$(VERSION_FULL) || true
	@cp -R . ../$(VERSION_FULL)
	@for i in . $$(git submodule foreach -q --recursive realpath --relative-to=$$(pwd) .); do ((cd ../$(VERSION_FULL)/$$i && test -f .git && cp -R $(GITDIR) .gitnew && rm -f .git && mv .gitnew .git && sed -i.bak -e 's#[[:space:]]*worktree[[:space:]]*=[[:space:]]*.*##g' .git/config) || true); done
	@for i in . $$(git submodule foreach -q --recursive realpath --relative-to=$$(pwd) .); do (cd ../$(VERSION_FULL)/$$i && git reset -q --hard && git clean -ffdxq); done
	@(cd ../$(VERSION_FULL) && find . -name \.git\* | xargs rm -rf)
	@mv ../$(VERSION_FULL) .
	@tar -czf $(VERSION_FULL).tar.gz $(VERSION_FULL)
	@echo Package: $(VERSION_FULL).tar.gz
	@rm -rf $(VERSION_FULL)

.PHONY: all install test dist
