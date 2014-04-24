ifndef TAG
export TAG := $(shell git describe)
endif

TAG_PARTS = $(subst -, , $(TAG))
ifeq ($(words $(TAG_PARTS)), 3)
	export VERSION := $(word 1, $(TAG_PARTS))
	export RELEASE := $(word 2, $(TAG_PARTS))
endif

all: 

src:
	[ -d tmp/SOURCES ] || mkdir -p tmp/SOURCES
	[ -f $(CURDIR)/tmp/SOURCES/haproxy-1.5-dev23.tar.gz ] || wget -O $(CURDIR)/tmp/SOURCES/haproxy-1.5-dev23.tar.gz http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev23.tar.gz
	cp $(CURDIR)/conf/* $(CURDIR)/tmp/SOURCES/

package: src all
	rpmbuild \
		-D "_topdir $(CURDIR)/tmp" \
		-D "version $(VERSION)"\
		-D "release $(RELEASE)"\
		-D "SRCDIR $(CURDIR)"\
		-bb spec/haproxy.spec

clean:
	rm -rf $(CURDIR)/tmp
