pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'anandhukdevops'
        IMAGE_TAG = "${BUILD_NUMBER}"
        AWS_REGION = 'ap-south-1'
        CLUSTER_NAME = 'eks-cluster-final'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/anandhu-devops/project4.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh """
                docker build -t $DOCKERHUB_USER/user-service:$IMAGE_TAG ./user-service
                docker build -t $DOCKERHUB_USER/product-service:$IMAGE_TAG ./product-service
                docker build -t $DOCKERHUB_USER/order-service:$IMAGE_TAG ./order-service
                docker build -t $DOCKERHUB_USER/payment-service:$IMAGE_TAG ./payment-service
                """
            }
        }

        stage('Tag Latest Images') {
            steps {
                sh """
                docker tag $DOCKERHUB_USER/user-service:$IMAGE_TAG $DOCKERHUB_USER/user-service:latest
                docker tag $DOCKERHUB_USER/product-service:$IMAGE_TAG $DOCKERHUB_USER/product-service:latest
                docker tag $DOCKERHUB_USER/order-service:$IMAGE_TAG $DOCKERHUB_USER/order-service:latest
                docker tag $DOCKERHUB_USER/payment-service:$IMAGE_TAG $DOCKERHUB_USER/payment-service:latest
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                    docker push $DOCKERHUB_USER/user-service:$IMAGE_TAG
                    docker push $DOCKERHUB_USER/user-service:latest

                    docker push $DOCKERHUB_USER/product-service:$IMAGE_TAG
                    docker push $DOCKERHUB_USER/product-service:latest

                    docker push $DOCKERHUB_USER/order-service:$IMAGE_TAG
                    docker push $DOCKERHUB_USER/order-service:latest

                    docker push $DOCKERHUB_USER/payment-service:$IMAGE_TAG
                    docker push $DOCKERHUB_USER/payment-service:latest
                    """
                }
            }
        }

        stage('Deploy to Kubernetes (AWS EKS)') {
            steps {
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]
                ]) {
                    sh """
                    set -e

                    export AWS_DEFAULT_REGION=$AWS_REGION

                    echo "🔐 Verifying AWS identity..."
                    aws sts get-caller-identity

                    echo "🔄 Updating kubeconfig..."
                    aws eks update-kubeconfig \
                        --region $AWS_REGION \
                        --name $CLUSTER_NAME

                    echo "🚀 Deploying to Kubernetes..."
                    kubectl apply -f k8s/
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed! Check logs."
        }
    }
}