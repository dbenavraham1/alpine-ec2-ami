ALL_SCRIPTS := $(wildcard scripts/*)
CORE_PROFILES := $(wildcard profiles/*/*)
TARGET_PROFILES := $(wildcard profiles/*.conf)
PROFILE := default
BUILD :=

.PHONY: amis clean

amis: build build/profile build/packer.json
	build/make-amis $(BUILD)

build: $(SCRIPTS)
	[ -d build ] || mkdir build
	python3 -m venv build/.py3
	build/.py3/bin/pip install pyhocon pyyaml boto3
	(cd build; for i in $(ALL_SCRIPTS); do ln -sf ../$$i .; done)

build/profile: build build/resolve-profile.py $(CORE_PROFILES) $(TARGET_PROFILES)
	build/resolve-profile.py $(PROFILE)

build/packer.json: build packer.conf
	build/.py3/bin/pyhocon -i packer.conf -f json > build/packer.json

%.py: %.py.in build
	sed "s|@PYTHON@|#!`pwd`/build/.py3/bin/python|" $< > $@
	chmod +x $@

clean:
	rm -rf build scrub-old-amis.py gen-readme.py
