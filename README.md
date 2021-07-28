# DevSecOps - POC for NGINX Sprint Conference, 2021

- GitHub CI/CD has been leveraged for testing DevSecOps pipeline
- GitHub Actions pipeline has been implemented
- .NET code project built as docker container
- NGINX App Protect WAF and DoS are built into a docker container
- Containers are deployed to Azure Container Registry
- Application and APp Protect proxy tiers is deployed to Azure Kubernetes
- CodeQL - GitHub's new code scanning workflow has been added for code scan
- Container scanning
- Selenium tests run
- OWASP ZAP DAST scan run
- Container action has been added

## Getting Started

The following are the high-level tasks needed to be able to run this POC yourself.

- Set up an Azure Container Registry
- Build and push The NGINX App Protect WAF + DoS container to the registry using the steps in the [section](#build-nap-waf-dos-container-and-push-to-acr) below
- Set up an Azure Kubernetes Server cluster with an HTTP ingress enabled
- Create both `devsecops-stage` and `devsecops-prod` namespaces in the Kubernetes cluster
- Set up the following GitHub repository secrets that the workflow requires:

| Secret                    | Description                                           |
|---------------------------|-------------------------------------------------------|
| `AZURE_CREDENTIALS`       | Azure credentials                                     |
| `AZURE_SUBSCRIPTION_ID`   | Azure Subscription ID                                 |
| `NGINX_CRT`               | Base 64 encoded version of the NGINX repo certificate |
| `NGINX_KEY`               | Base 64 encoded version of the NGINX repo key         |
| `REGISTRY_SERVERNAME`     | Host name of your Azure Container Registry            |
| `REGISTRY_USERNAME`       | User name for the Azure Container Registry            |
| `REGISTRY_PASSWORD`       | Password for the Azure Container Registry             |
| `PENDING_WEBHOOK_URL`     | Webhook URL to send workflow pending events to        |
| `SUCCESS_WEBHOOK_URL`     | Webhook URL to send workflow success events to        |
| `FAILURE_WEBHOOK_URL`     | Webhook URL to send workflow failure events to        |
| `WEBHOOK_SECRET`          | Secret used to hash the Webhook POST body             |


#### Build NAP WAF + DoS Container and push to ACR
``` bash
cd app-protect
az login
az acr build -t nginx-app-protect-waf-dos:3.3 -t nginx-app-protect-waf-dos:latest -r aknot242 -f Base-Dockerfile .
```

#### Delete Old GitHub Actions Runs
Not specifically required, but deleting old GitHub workflow runs promotes cleanliness, especially when demoing.
Credit: This is a local copy of the [bash script](https://github.com/qmacro/dotfiles/blob/230c6df494f239e9d1762794943847816e1b7c32/scripts/dwr) by @qmacro
Requires: `jq`, `gh` and `fzf` packages.

``` bash

chmod +x delete-github-workflow-runs.sh
./util/delete-github-workflow-runs.sh <github id>/<repo name>
```

Original author (@RKSelvi) solution blog:
- [Blog post link](https://www.ais.com/devsecops-with-github-actions/)