# deploy-nodeApp-by-using-terraform-and-kubernetes

# Steps
1. create 3 namespaces dev,build and test
2. create a pod and service for jenkins and nexus in build namespace
3. create a pod for mysql in dev and test
4. creata a pipline for CI to push the node app image to dockerhub and nexus
5. create a pipline for CD to deploy the node app to K8s on specific namespace based on a parameter that was token from the user

# Files
1. infrastructure-terraform Directory:contain all resources of k8s creates using terraform
- namespaces dev, build, test
- jenkins pod  with kubectl and dockercli as init containers in it , service , PV and PVC for jenkins, Role ,Rolbinding and Service Account to access the Api of the minikube
- nexus pod, service , PV and PVC for jenkins
- mysql pod, service , PV and PVC for jenkins
2. CI Directory: contain the nodeapp and dockerfile and jenkinsfile to push image to dockerhub and nexus
3. CD Directory: contain the deployment for the nodeapp ,service to access it and ansible playbook for deployment

# Run 
1. inside infrastructure-terraform  to create resources
```
terraform init
terraform apply
```
2. create a pipline for CI and choose the commit number you want to build
3. create a pipline for CD and choose where to deploy the app in dev or test namesapce

# Output
![CI](https://github.com/SamarGooda/deploy-nodeApp-by-using-terraform-and-kubernetes/blob/master/screenshoot/ci-pipeline.png)

![CD](https://github.com/SamarGooda/deploy-nodeApp-by-using-terraform-and-kubernetes/blob/master/screenshoot/cd-pipeline2.png)
![nodeapp](https://github.com/SamarGooda/deploy-nodeApp-by-using-terraform-and-kubernetes/blob/master/screenshoot/node-app.png)
