.PHONY: provision consul-ui nomad-ui

SAMPLE_HOST := 192.168.51.104
OSNAME := $(shell uname -s)
ifeq ($(OSNAME), Darwin)
	OPEN := open
endif
ifeq ($(OSNAME), Linux)
	OPEN := xdg-open
endif

provision:
	ansible-playbook -vv ansible/provision.yml

consul-ui:
	$(OPEN) http://$(SAMPLE_HOST):8500/ui/

nomad-ui:
	$(OPEN) http://$(SAMPLE_HOST):4646/ui/
