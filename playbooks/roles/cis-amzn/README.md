# AMI Hardening PlayBook

**CIS Amazon Linux Benchmark | v2.1.0 - 12-27-2017**

**Amazon Linux 1**

---

## Overview

This book is intented to enforce AMI security according to CIS Amazon Linux Benchmark (v2.1.0 - 12-27-2017).

The playbook is intended to use with Packer on Amazon Linux 1.

It can be played in two modes:

* APPLY: actually apply CIS recommended changes to the OS
* POST: just check if the system is compliant

The **APPLY** mode is fully covered, while the **POST** mode is only partially covered.

APPLY mode is *NOT IDEMPOTENT*. The second "APPLY" run may damage the OS in subject.

It's safe to run the playbook in the POST mode several times in a ROW. When system state is not CIS compliant the playbook will fail at once on the non compliant check.

There is a report directory created during the each run. The path is like **./report/<random-uuid/**.
It's printed in logs at the very end of the playbook.

## Usage

Create a playbook like this:

```
- name: configure cis amzn
  hosts: all
  become: yes

  roles:
    - cis-amzn
```

Make an inventory like this (use your host and ssh-key):

```
[test]
test-001 ansible_port=22 ansible_host=*** ansible_user=ec2-user ansible_ssh_private_key_file=*** ansible_become=yes
```

To enforce OS hardening and check afterwards:

```
ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --skip-tags "apply"
```

To check the system state only: 

```
ansible-playbook playbooks/cis-amzn.yml -i test.ini -l test --skip-tags "apply"
```

Typical packer runtime (apply+post and post):

```
Tue Jul  9 21:04:24 UTC 2019
...
Tue Jul  9 21:52:51 UTC 2019

```

## Notice

There are several check which require operator's attention after all the changes are applyed, or an OS is validated in the POST mode.

* 6.1.1 Audit system file permissions (Not Scored). **See:** packages.txt in the report.
* 6.1.13 Audit SUID executables (Not Scored). **See:** suid-files.txt in the report.
* 6.1.14 Audit SGID executables (Not Scored). **See:** sgid-files.txt in the report.
* 1.6.1.6 Ensure no unconfined daemons exist (Scored). **See:** unconfined-daemons.txt in the report.

## Design&Development

Each CIS check is implemented as a separate file identified by CIS code. Each task is tagged as follows:

* always - always play the task
* apply - play a task in the APPLY mode
* post - play a task in the POST mode
* <cis_code> - CIS check code according to the book
* <cis_section> - CIS section according to the book
* <cis_profile> - CIS profile (level-1 or level-2)
* <cis_scored> - CIS scored tag (scored or not_scored)
* debug - Additional information

Tags always, apply, post are mutually exclusive. 

All the task tagged as always ot post *must not* change the system state. 

Only tasks tagged with apply may change an OS's state.

See [tests] dir for sample tests and checks.

Notice: [yamllint](https://github.com/adrienverge/yamllint) is used for validating \*.yaml files.

