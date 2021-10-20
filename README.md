# DevSecOps POC
Forked and adapted from [RKSelvi/devsecops-poc](https://github.com/RKSelvi/devsecops-poc) for NGINX Sprint Conference, 2021.

This repo is intended to demonstrate how to integrate NGINX App Protect WAF and DoS products into a typical DevSecOps workflow leveraging open source tooling.

The repository is featured in the [Automate Application Security with NGINX](https://www.nginx.com/blog/demoing-nginx-at-sprint-2-0/#automate) conference session. A link to the session video will be included here once it airs.


## Solution Scope

- GitHub CI/CD has been leveraged for testing DevSecOps pipeline
- GitHub Actions pipeline has been implemented
- .NET code project built as docker container
- NGINX App Protect WAF and DoS are built into a docker container
- Containers are deployed to Azure Container Registry
- Application and App Protect proxy tiers are deployed to Azure Kubernetes Service
- CodeQL - GitHub's new code scanning workflow has been added for code scan
- Container linting, package vulnerability scanning
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
| `IP_ALLOW_LIST_STAGE`           | Used by the [ingress controller](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#whitelist-source-range) to limit traffic to one or more source CIDRs in the **stage** environment.|
| `IP_ALLOW_LIST_PROD`           | Used by the [ingress controller](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#whitelist-source-range) to limit traffic to one or more source CIDRs in the **prod** environment.|


#### Build NGINX App Protect WAF + DoS Container and push to ACR
The workflow requires an NGINX App Protect WAF + DoS base container to be present your the Azure Container Registry. Since these are commercially-licensed products, you will need to request a [free trial](https://www.nginx.com/free-trial-request/), and use this to build your own container.

``` bash
cd app-protect
az login --use-device-code
az acr login --name <your acr name>

DOCKER_BUILDKIT=1 docker build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t <your acr name>.azurecr.io/nginx-app-protect-waf-dos:3.6 -t <your acr name>.azurecr.io/nginx-app-protect-waf-dos:latest -f Base-Dockerfile .

docker push <your acr name>.azurecr.io/nginx-app-protect-waf-dos
```

#### Delete Old GitHub Actions Runs
Not specifically required, but deleting old GitHub workflow runs promotes cleanliness, especially when demoing.
Credit: This is a local copy of the [bash script](https://github.com/qmacro/dotfiles/blob/230c6df494f239e9d1762794943847816e1b7c32/scripts/dwr) by @qmacro
Requires: `jq`, `gh` and `fzf` packages.

``` bash

chmod +x delete-github-workflow-runs.sh
./util/delete-github-workflow-runs.sh <github id>/<repo name>
```

#### Troubleshooting Examples

Get pod names in a particular namespace:
``` bash
kubectl get pods -n devsecops-stage
```

SSH into one of the pods from the above command:
``` bash
kubectl exec --stdin --tty -n devsecops-stage nap-dotnetcorewebapp-stage-84dbbb5bbf-7xffw -- /bin/bash
```

#### Deleting Deployments
If you need to delete stage and prod deployments, use the following commands:

``` bash
kubectl delete deployment dotnetcorewebapp-stage -n devsecops-stage
kubectl delete deployment nap-dotnetcorewebapp-stage -n devsecops-stage

kubectl delete deployment nap-dotnetcorewebapp-prod -n devsecops-prod
kubectl delete deployment dotnetcorewebapp-prod -n devsecops-prod
```


Original author (@RKSelvi) solution blog:
- [Blog post link](https://www.ais.com/devsecops-with-github-actions/)
