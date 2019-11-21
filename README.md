# Infra

Kubernetes recipes for my services.

## Prerequsites

* [direnv](https://direnv.net)
* [sops](https://github.com/mozilla/sops)
* PGP key (for managing secrets)

## Setup

Download k3s binary and set environments.

```sh
./prepare.sh
```

To decrypt secure files, run commands below on your namespace directory. Please keep in mind that output files must be ended with`*.secure.yaml` so it would be ignored from git.

```sh
sops -d 00-secrets.enc.yaml > 00-secrets.secure.yaml
```
