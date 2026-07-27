pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = '908209635299.dkr.ecr.ap-south-1.amazonaws.com/enterprise-cloud-platform'
        IMAGE_TAG = "${BUILD_NUMBER}"
        CLUSTER_NAME = 'fincore-dev-eks-cluster'
        HELM_RELEASE = 'enterprise-cloud-platform'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${ECR_REPO}:${IMAGE_TAG} ./docker
                '''
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin 908209635299.dkr.ecr.ap-south-1.amazonaws.com
                '''
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                docker push ${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy to EKS using Helm') {
            steps {
                sh '''
                aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}

                helm upgrade --install ${HELM_RELEASE} \
                  ./helm/enterprise-cloud-platform \
                  --set image.repository=${ECR_REPO} \
                  --set image.tag=${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl rollout status deployment/${HELM_RELEASE} -n demo
                kubectl get pods -n demo
                kubectl get svc -n demo
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }

        failure {
            echo 'Deployment Failed!'
        }
    }
}