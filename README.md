# Python-and-MySQL-application
A small web app implemented using Python & MySQL that allows users to create account, login, and make a bucket list.

## Prerequisites
- An S3 bucket with the name specified in the backend.tf file
- Dynamodb table with the name specified in the backend.tf file & a partition key named LockID with type of String
- Key pair named Jenkins.pem

## Clone the project's repo
```bash
  git clone https://github.com/AbdoKhaled-2021/Final-Project-Devops.git
```

## Infrastructure Creation
- Creating the necessary infrastructure using terraform:
```bash
  terraform init
  terraform apply --var-file deployment.tfvars
```
- Update Jenkinfile:
  - Environment section:
    - SERVER_URL = "Cluster's API-server-endpoint"

## CI/CD Tool Installation:
#### Prerequisite
- Add the Jenkins-instances's Public_IP (generated after infrastructure creation) into inventory.yaml file (inside Jenkins-installation directory)

#### Installing Jenkins using ansible:
```bash
  cd Jenkins-installation
  ansible-playbook -i inventory.yaml --private-key Jenkins.pem Jenkins-installation-playbook.yaml
```
#### Configure Jenkins:
- SSH into Jenkins-instance
- Make sure "docker", "kubectl", "aws-cli" & "git" are installed on the Jenkins-instance (and its slave, if any)
```bash
docker version
kubectl version
aws --version
git --version
```
- Create the admin user & install suggested plugins after reaching Jenkins using the browser on "Jenkins-instance-Public_IP:8080"
- Install "Docker", "Docker pipeline", "K8s" and "K8s-CLI" plugins
- Create a credential for Github (username & token)

## NGINX Controller Installation
- Connect to the cluster
```bash
aws eks update-kubeconfig --region us-east-1 --name project
```
- Install NGINX controller and NLB in the default namespace
```bash
kubectl apply -f nginx-controller-and-NLB.yaml
```
- Get the NLB's EXTERNAL-IP/HOSTNAME (Would be used to access the application)
```bash
kubectl get services -o jsonpath="{.items[0].status.loadBalancer.ingress[0].hostname}"
```

## Application deployment
#### Deploying APP using Jenkins
##### On the Jenkins-instance
- Add Jenkins user as sudo
```bash
  sudo vim /etc/sudoers
  jenkins ALL=(ALL) NOPASSWD: ALL
```
##### Via Admin role (On the server used to create the cluster)
- Connect to the cluster (Only necessary if u skipped NGINX Controller Installation)
```bash
aws eks update-kubeconfig --region us-east-1 --name project
```
- Create Service Account (and its Secret), Clusterole & rolebinding to be used by Jenkins to deploy the APP on K8s
```bash
kubectl apply -f Jenkins-service-account.yaml
```
- Extract the token to the plugin:
```bash
kubectl describe secret jenkins-admin-serviceaccount-token
```
##### Using Jenkins GUI
- Add the secret token (genereated in the last step) as a credential named "Service-account-token" of type "Secret text"
- Add Kubernetes as a cloud:
  - Manage Jenkins -> Manage Nodes and Clouds -> Configure Clouds -> Add a new cloud -> Kubernetes -> Kubernetes Cloud Details
    - Kubernetes URL = Cluster's API_Server_Endpoint
    - Credential = Secret_text_credential created in the previous step
    - Checkmark the Disable https certificate check box
    - click on Test Connection, and you should get the Connected to Kubernetes message
  - Create a multibranch pipeline:
    - Branch Source (Github): Use the project's Github URL and the related credentials
    - Behaviour: Discover all branches
    - Bild configuration: Jenkinsfile

## Extras
#### Create a webhook to enable building through code pushing into Github
- In Github-project's settings --> Webhooks --> Add webhook:
    - Payload URL: http://[jenkins-url-including-port]/github-webhook/
    - Content type: application/json
    - Which events would you like to trigger this webhook?: select Just the push event
