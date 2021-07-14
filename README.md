# DevSecOps - POC for Presentation/Blog post

- GitHub CI/CD has been leveraged for testing DevSecOps pipeline
- GitHub Actions pipeline has been implemented
- .NET code project built as docker container
- Container is deployed to Azure Container Registry
- Application is deployed to Azure Container Instance
- CodeQL - GitHub's new code scanning workflow has been added for code scan
- Container scanning
  - Container action has been added
- [Blog post link](https://www.ais.com/devsecops-with-github-actions/)


#### Build NAP WAF + DoS Container and push to ACR
``` bash
cd app-protect
az login
az acr build --image nginx-app-protect-waf-dos:3.3 --registry aknot242 --file Base-Dockerfile .
```
