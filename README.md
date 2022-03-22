# DevSecOps POC
Forked and adapted from [RKSelvi/devsecops-poc](https://github.com/RKSelvi/devsecops-poc) for NGINX Sprint Conference, 2021.

This repo is intended to demonstrate how to integrate NGINX App Protect WAF and DoS products into a typical DevSecOps workflow leveraging open source tooling.

The repository is featured in the [Automate Application Security with NGINX](https://www.nginx.com/blog/demoing-nginx-at-sprint-2-0/#automate) conference session. A link to the session video will be included here once it airs.


## Solution Scope

- GitHub CI/CD has been leveraged for testing DevSecOps pipeline
- GitHub Actions pipeline has been implemented
- .NET code project built as docker container
- NGINX Kubernetes Ingress Controller + App Protect WAF and DoS are built into a docker container
- Containers are deployed to Azure Container Registry
- Application is deployed to Azure Kubernetes Service
- CodeQL - GitHub's new code scanning workflow has been added for code scan
- Container linting, package vulnerability scanning
- Selenium tests run
- OWASP ZAP DAST scan run
- cert-manager has been installed to k8s cluster to manage the lifecycle of Let's Encrypt certificates
- cert-manager has been configured to update Azure DNS Zone with the DNS challenges for Let's Encrypt

## Getting Started

The following are the high-level tasks needed to be able to run this POC yourself.

- Set up an Azure Container Registry
- Build and push the NGINX Kubernetes Ingress Controller + App Protect WAF + DoS container to the registry using the steps in the [section](#build-nginx-ingress-controller+nap-waf-dos-container-and-push-to-acr) below
- Set up an Azure Kubernetes Server cluster
- Create both `devsecops-stage` and `devsecops-prod` namespaces in the Kubernetes cluster
- Install [cert-manager](https://cert-manager.io/) in the cluster
- Set up the following GitHub repository secrets that the workflow requires:

| Secret                    | Description                                                          |
|---------------------------|----------------------------------------------------------------------|
| `AZURE_CREDENTIALS`       | Azure credentials                                                    |
| `AZURE_SUBSCRIPTION_ID`   | Azure Subscription ID                                                |
| `NGINX_CRT`               | Base 64 encoded version of the NGINX repo certificate                |
| `NGINX_KEY`               | Base 64 encoded version of the NGINX repo key                        |
| `TLS_CRT`                 | Base 64 encoded version of the TLS certificate used for the demo app |
| `TLS_KEY`                 | Base 64 encoded version of the TLS key used for the demo app         |
| `REGISTRY_SERVERNAME`     | Host name of your Azure Container Registry                           |
| `REGISTRY_USERNAME`       | User name for the Azure Container Registry                           |
| `REGISTRY_PASSWORD`       | Password for the Azure Container Registry                            |
| `PENDING_WEBHOOK_URL`     | Webhook URL to send workflow pending events to                       |
| `SUCCESS_WEBHOOK_URL`     | Webhook URL to send workflow success events to                       |
| `FAILURE_WEBHOOK_URL`     | Webhook URL to send workflow failure events to                       |
| `WEBHOOK_SECRET`          | Secret used to hash the Webhook POST body                            |
| `ELASTIC_USERNAME`        | Elastic username used for deployment event logging script            |
| `ELASTIC_PASSWORD`        | Elastic password used for deployment event logging script            |
| `ELASTIC_URL`             | Base URL of Elastic API used for deployment event logging script. Example: https://my-elastic.example.com:9200            |
| `IP_ALLOW_LIST_STAGE`     | Used by the [ingress controller](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#whitelist-source-range) to limit traffic to one or more source CIDRs in the **stage** environment.|
| `IP_ALLOW_LIST_PROD`      | Used by the [ingress controller](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#whitelist-source-range) to limit traffic to one or more source CIDRs in the **prod** environment.|


#### Build NGINX Ingress Controller + NGINX App Protect WAF + DoS Container and push to ACR
The workflow requires an NGINX Ingress Controller + NGINX App Protect WAF + DoS base container to be present your the Azure Container Registry. Since these are commercially-licensed products, you will need to request a [free trial](https://www.nginx.com/free-trial-request/), and use this to build your own container.

``` bash
cd app-protect
az login --use-device-code
az acr login --name <your acr name>

make debian-image-nap-dos-plus PREFIX=<your acr name>.azurecr.io/nginx-plus-ingress-nap-waf-dos TARGET=download
```

Get the tag from the container built above: `docker image ls <your acr name>.azurecr.io/nginx-plus-ingress-nap-waf-dos`

``` bash
docker tag aknot242.azurecr.io/nginx-plus-ingress-nap-waf-dos:<the tag from above> aknot242.azurecr.io/nginx-plus-ingress-nap-waf-dos:latest

docker push <your acr name>.azurecr.io/nginx-plus-ingress-nap-waf-dos
```

#### Create Elastic and Kibana Dashboard Resources

This solution makes use of the [Elastic Cloud](https://www.elastic.co/cloud/), specifically Elastic and Kibana for NGINX App Protect WAF & DoS analytics. You can set up a free trial for this, or use an existing subscription. Once available, use the following script to install the resources needed:

``` bash
cd analytics && ./elastic-setup.sh -a \"https://my-deployment:9243\" -b \"elastic:mypassword\" -c \"https://my-deployment:9243\" -d \"elastic:mypassword\"
```

#### Create DNS Zones and Records

This is a manual process for now. Refer to [Azure DNS documentation](https://docs.microsoft.com/en-us/azure/dns/) for guidance in creating stage and prod DNS zones and records once AKS has assigned a public IP address to the k8s loadbalancers.


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

Show kustomization built configuration for stage environment:
``` bash
kustomize build manifests/overlays/stage
```

#### Deleting Deployments
If you need to delete stage and prod deployments, use the following commands:

``` bash
kubectl delete deployment dotnetcorewebapp-stage -n devsecops-stage

kubectl delete deployment dotnetcorewebapp-prod -n devsecops-prod
```


Original author (@RKSelvi) solution blog:
- [Blog post link](https://www.ais.com/devsecops-with-github-actions/)
