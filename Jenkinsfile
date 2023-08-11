pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "317007647612"
        AWS_DEFAULT_REGION = "us-east-1"
        IMAGE_APP_REPO_NAME = "python-app"
        IMAGE_MYSQL_REPO_NAME = "mysql-db"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        REPOSITORY_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
        SERVER_URL = "https://62ACD843BAB7125A14BBC8A09CF745A6.gr7.us-east-1.eks.amazonaws.com"
    }
   
    stages {
        stage('Connecting to ECR') {
            steps{
                script {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URL}"
                }
            }
        }
        stage('Building python-app-image') {
            steps{
                script {
                    sh "docker build -t ${REPOSITORY_URL}/${IMAGE_APP_REPO_NAME}:${env.BUILD_ID} ./Docker-part/FlaskApp/"
                }
            }
        }
        stage('Pushing python-app-image to ECR') {
            steps{
                script {
                    sh "docker push ${REPOSITORY_URL}/${IMAGE_APP_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Building mysql-image') {
            steps{
                script {
                    sh "docker build -t ${IMAGE_MYSQL_REPO_NAME}:${env.BUILD_ID} Docker-part/MySQL_Queries/."
                }
            }
        }
        stage('Pushing mysql-image to ECR') {
            steps{
                script {
                    sh "docker tag ${IMAGE_MYSQL_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URL}/${IMAGE_MYSQL_REPO_NAME}:${IMAGE_TAG}"
                    sh "docker push ${REPOSITORY_URL}/${IMAGE_MYSQL_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Updating deployment files'){
            steps {
                echo 'replacing old images with the new one'
                sh "sed -i \"s|image:.*|image: ${REPOSITORY_URL}/${IMAGE_APP_REPO_NAME}:${IMAGE_TAG}|g\" 'K8s Manifest'/app-definition-files/python-app-definition-file.yaml"
                sh "sed -i \"s|image:.*|image: ${REPOSITORY_URL}/${IMAGE_MYSQL_REPO_NAME}:${IMAGE_TAG}|g\" 'K8s Manifest'/app-definition-files/mysql-statefulset.yaml"
            }
        }
        stage('Deploy to K8s') {
            steps {
                echo 'Deploying to K8s' 
                sh "aws eks --region us-east-1 update-kubeconfig --name project"
                // This step is essential, because without it I won't be able to access the cluster, but I am still not authorized to deploy untill I use the secret created for the Service account
                withKubeCredentials([[credentialsId: 'Service-account-token', serverUrl: "${SERVER_URL}", clusterName: 'project']]){
                    script{
                        sh "kubectl get nodes"
                        sh "kubectl apply -f 'K8s Manifest'/Stored-variables"
                        sh "kubectl apply -f 'K8s Manifest'/PVs"
                        sh "kubectl apply -f 'K8s Manifest'/app-definition-files"
                        sh "kubectl apply -f 'K8s Manifest'/Services"
                        sh "kubectl get services -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}'"
                    }
                }
            }
        }
    }
}

// withKubeCredentials is used in the pipeline instead of "Configure Kubernetes CLI (kubectl) with multiple credentials" in the freestyle project