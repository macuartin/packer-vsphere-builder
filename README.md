# infrastructure-as-code

## Packer

```bash
packer validate rhel-7.json

packer build -var-file="vars.json" rhel-7.json
```

## Terraform

```bash
terraform init

terraform plan -var-file="config/dev.tfvars"

terraform apply -var-file="config/dev.tfvars"
```

## Vagrant

```bash
vagrant up --provision

vagrant ssh hardened

vagrant halt hardened

vagrant destroy hardened
```
