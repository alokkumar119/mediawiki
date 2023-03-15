# mediawiki
## Very first step will be craete a Azure AD App registration 
## All the credetial will applied via enviroment variable in IDE such as 
 - $env:ARM_CLIENT_ID
 - $env:ARM_CLIENT_SECRET
 - $env:ARM_TENANT_ID
 - $env:ARM_SUBSCRIP TION_ID
### or can be pass via sh file with export command for bash enviroment
 
## There are two section in it first section is for basic infra which will have code for 
 - Resource Group
 - Virtual Network
 - Azure Keyvault
 - Azure container registry
 - Azure Kubernetes Cluster
## Snap
![screenshot](mediawiki-rg.png)
## Second Section is for 
 - CI/CD for Application with Helm Chart
## CI/CD Steps
 - we are having helm chart in local repository
 - we pakage the helm chart and push it to acr
 - we fetch the help chart from acr 
 - install into aks cluster
 
## How to run the automation
 -you need to create a service connection in to azure devops
 - then you can directly used pipeline to deploy
 - this has been tested using azure devops 
