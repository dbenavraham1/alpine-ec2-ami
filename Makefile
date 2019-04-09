.PHONY: ami

ami: convert
	packer build -var-file=build/variables.json build/alpine-ami.json

edge: convert
	@echo '{ "version": "edge", "release": "edge", "revision": "'-`date +%Y%m%d%H%M%S`'" }' > build/edge.json
	packer build -var-file=build/variables.json -var-file=build/edge.json build/alpine-ami.json

convert: build/convert
	[ -f variables.yaml ] || cp variables.yaml-default variables.yaml
	build/convert variables.yaml > build/variables.json
	build/convert alpine-ami.yaml > build/alpine-ami.json

build/convert:
	[ -d ".py3" ] || python3 -m venv .py3
	.py3/bin/pip install pyyaml boto3

	[ -d "build" ] || mkdir build

	# Make stupid simple little YAML/JSON converter so we can maintain our
	# packer configs in a sane format that allows comments but also use packer
	# which only supports JSON
	@echo "#!`pwd`/.py3/bin/python" > build/convert
	@echo "import yaml, json, sys" >> build/convert
	@echo "y = yaml.full_load(open(sys.argv[1]))" >> build/convert
	@echo "for k in ['ami_access','deploy_regions','add_repos','add_pkgs','add_svcs']:" >> build/convert
	@echo "  if k in y and isinstance(y[k], list):" >> build/convert
	@echo "    y[k] = ','.join(str(x) for x in y[k])" >> build/convert
	@echo "  if k in y and isinstance(y[k], dict):" >> build/convert
	@echo "    y[k] = ':'.join(str(l) + '=' + ','.join(str(s) for s in ss) for l, ss in y[k].items())" >> build/convert
	@echo "json.dump(y, sys.stdout, indent=4, separators=(',', ': '))" >> build/convert
	@chmod +x build/convert

%.py: %.py.in
	sed "s|@PYTHON@|#!`pwd`/.py3/bin/python|" $< > $@
	chmod +x $@

.PHONY: clean
clean:
	rm -rf build .py3 scrub-old-amis.py gen-readme.py

distclean: clean
	rm -f variables.yaml
