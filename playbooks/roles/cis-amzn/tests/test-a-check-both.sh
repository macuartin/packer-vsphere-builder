#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

yamllint ../../../../playbooks/cis-amzn.yml
yamllint ../../../../playbooks/roles/cis-amzn/tasks/remediation/*.yml
yamllint ../../../../playbooks/roles/cis-amzn/tasks/commons/*.yml

ansible-playbook ../../../../playbooks/cis-amzn.yml --syntax-check

ansible-playbook ../../../../playbooks/cis-amzn.yml -i test.ini --tags "$(cat test-a-check-tags.cfg|tr --delete [:space:])" -l test
