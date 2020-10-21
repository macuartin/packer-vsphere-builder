#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

yamllint playbooks/cis-amzn.yml
yamllint playbooks/roles/cis-amzn/tasks/remediation/*.yml
yamllint playbooks/roles/cis-amzn/tasks/commons/*.yml

ansible-playbook playbooks/cis-amzn.yml --syntax-check

#ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --list-tasks | less

# Check for untagged tasks
#ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --list-tasks --skip-tags "apply,always,post" | less

# Check for mimatched apply tags
#ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --list-tasks --skip-tags "apply,always" | grep apply | less

# Check for mismathced post tags
#ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --list-tasks --skip-tags "post,always" | grep post | less

# Check for level-2 profile
#ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --list-tasks --skip-tags "always,level-1" | less

# Check for not_scored items
#ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --list-tasks --skip-tags "always,scored" | less

# Check for cis_scored tagging
ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --list-tasks --skip-tags "always,not_scored,scored" | less
