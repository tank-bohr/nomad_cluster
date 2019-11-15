.PHONY: provision

provision:
	ansible-playbook -vv ansible/provision.yml
