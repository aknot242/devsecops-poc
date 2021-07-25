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



#### Build NAP WAF + DoS Container and push to ACR
``` bash
cd app-protect
az login
az acr build -t nginx-app-protect-waf-dos:3.3 -t nginx-app-protect-waf-dos:latest -r aknot242 -f Base-Dockerfile .
```

Original author (@RKSelvi) solution blog:
- [Blog post link](https://www.ais.com/devsecops-with-github-actions/)