.PHONY: provision consul-ui nomad-ui observer run-node remsh edit-secrets

# SAMPLE_HOST := 192.168.51.104
SAMPLE_HOST := wk004.my-noodles.online

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

observer:
	erl -name observer@192.168.51.1 -setcookie very-secret-cookie -run observer

run-node:
	erl -name `uuidgen`@192.168.51.1 -setcookie very-secret-cookie

remsh:
	erl -name `uuidgen`@192.168.51.1 -setcookie very-secret-cookie -remsh noodles-0@192.168.51.104

edit-secrets: $(VAULT_PASSWORD_FILE)
	ansible-vault edit ansible/group_vars/all/vault

tf-init:
	make -C terraform init

tf-apply: terraform/my-noodles.tf
	make -C terraform apply

terraform/my-noodles.tf: ansible/roles/terraform/templates/my-noodles.tf.j2 ansible/group_vars/all/vars
	ansible-playbook -vv ansible/generate-terraform.yml

noodles:
	ansible-playbook ansible/noodles.yml
