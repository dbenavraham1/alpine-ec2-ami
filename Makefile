ALL_SCRIPTS := $(wildcard scripts/*)
ALL_PROFILES := $(shell find profiles -name '*.yaml' -type f)
CORE_PROFILES := $(shell for i in base version arch; do ls profiles/$$i/*.yaml | sort -V; done)
PROFILE := default
BUILD :=

.PHONY: amis
amis: build build/profile build/packer.json
	build/make-amis $(BUILD)

build: $(SCRIPTS)
	[ -d build ] || mkdir build
	python3 -m venv build/.py3
	build/.py3/bin/pip install pyyaml boto3
	(cd build; for i in $(ALL_SCRIPTS); do ln -sf ../$$i .; done)

build/profile: build build/resolve-profile.py $(ALL_PROFILES)
	cat $(CORE_PROFILES) profiles/$(PROFILE).yaml | build/resolve-profile.py $(PROFILE)

build/packer.json: build build/yaml2json.py packer.yaml
	build/yaml2json.py packer.yaml > build/packer.json

%.py: %.py.in build
	sed "s|@PYTHON@|#!`pwd`/build/.py3/bin/python|" $< > $@
	chmod +x $@

clean:
	rm -rf build scrub-old-amis.py gen-readme.py
