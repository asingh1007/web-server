# http_server
A dead simple Ruby web server.
Serves on port 80.
/healthcheck path returns "OK"
All other paths return "Well, hello there!"

`$ ruby webserver.rb`

# WebServer Deployment *Terraform/GKE/HELM*

Automated Deployment for WebServer

This document explains the deployment of Webserver and the approach for the deployment.

**Dockerfile:** There is a single Dockerfile contained in this repository containing the binary to be executed for the server. It runs the application as a non root user as mentioned.

**Helm:** The helm chart to deploy the application into kubernetes is contained inside the folder "webserver". The template folder consists the templates for kubernetes resources to be deployed.
  1) deployment.yaml - It will deploy the server component of the application as a deployment. It also consists of the probes that are required to configure the application properly. The replica count is 3 to make the app Highly Available.
  2) service.yaml - The service will expose the pods inside the deployment.
  4) ingress.yaml - It will create an ingress(Load Balancer) that will expose the endpoint to outer world. It will help achieving highly available and load balanced environment.


**Helmfile:** I am using Helmfile for deploying helm as it offers extra features from helm that are very much useful.
Please refer https://github.com/roboll/helmfile for more info.

**Terraform:** The terraform files to create a gke cluster are stored inside the terraform folder.
  To deploy a GKE cluster, The public module for GKE that is offered by Terraform and managed by Google is used. Using this module as it is reliable and saves time as it can be reused and takes care of all the dependent resources that are need to be created(Eg: node pools etc. needed in our case.
  The backend.tf file contains details of the bucket which will store the state file remotely and will also implement state locking so the statefile should not be overridden mistakenly. 
  (Note: Some values are directly been enetered inside gke.tf (due to the time constraint) but can be further variablised to make it more extensible)

**.github/workflows/actions** (Triggering the Automation):  This file contains the yaml content that is used for setting up the ci in GitHub.
  It will get triggered when the code is pushed to develop/main branch ( It can be further optimized for different pipelines to get triggered for different environments/branches.)
  - Firstly will create a docker image using the Dockerfile and will push it into the relevant docker registry.
  - Then will run the "terraform inti" & "terraform plan " that will be used to observe any changes in the infrastructure.
  - Once it is done, "Terraform Apply" will be triggered when the code is merged to "main" Branch.
  (It is done as to properly observe the plan and then execute it.)
  - The third job will trigger Helm Deploy using Helmfile. It will first setup the authentication with the gke cluster and will perform the helm deploy.
  - The Helfile Lint and diff shows the changes to be done to the Kubernetes Resources and provides an interactive way to see validate the changes
  - Helmfile sync will deploy the changes inside the Kubernetes Cluster.
  - Also, The sync will only run for the "main" Branch.
  
  All the credentials are saved as environment variables as GitHub Env Vars that provides a secure way to pass variables.
  For every change in the Dockerfile, Kubernetes will perform a rolling update for the new image.
  Currently the Application is not having the scaling feature but we can add a HPA to enable the pod scaling.

Triggering the Automation:

1) For every commit in develop/main branch the Automation will get triggered.
2) The successful terraform Plan can be viewed at : https://github.com/asingh1007/web-server/runs/2335892712?check_suite_focus=true#step:8:94
3) The successful helm lint and plan can be viewed at : https://github.com/asingh1007/web-server/runs/2336375517?check_suite_focus=true#step:10:31 