# IaC for 食養

## Quickstart

```shell
op account list
op read --account <ACCOUNT_ID> --out-file ./secrets.tfvars op://6t4gl3xctfbovazac73xnlkaum/jqbtbtgjxwejeesytqlvibvkvq/secrets.tfvars
```

```shell
terraform plan -var-file=secrets.tfvars
terraform apply -var-file=secrets.tfvars
```