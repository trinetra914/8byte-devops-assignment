pipeline {
    agent any

    environment {
        PYTHON = 'C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
        DOCKER = 'C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'

        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '777040315554'
        ECR_REPOSITORY = '8byte-devops-app'
        IMAGE_TAG = '1.0'
        ECR_REGISTRY = '777040315554.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_IMAGE = '777040315554.dkr.ecr.ap-south-1.amazonaws.com/8byte-devops-app:1.0'
    }

    stages {

        stage('Test') {
            steps {
                bat '"%PYTHON%" -m pip install -r app\\requirements.txt'
                bat '"%PYTHON%" -m pip install pytest'
                bat '"%PYTHON%" -m pytest tests'
            }
        }

        stage('Docker Check') {
            steps {
                bat '"%DOCKER%" --version'
                bat '"%DOCKER%" info'
            }
        }

        stage('AWS Check') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-credentials']
                ]) {
                    bat 'aws sts get-caller-identity'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '"%DOCKER%" build -t %ECR_REPOSITORY%:%IMAGE_TAG% .'
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-credentials']
                ]) {
                    bat 'aws ecr get-login-password --region %AWS_REGION% | "%DOCKER%" login --username AWS --password-stdin %ECR_REGISTRY%'
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                bat '"%DOCKER%" tag %ECR_REPOSITORY%:%IMAGE_TAG% %ECR_IMAGE%'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-credentials']
                ]) {
                    bat '"%DOCKER%" push %ECR_IMAGE%'
                }
            }
        }

        stage('Verify ECR Image') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-credentials']
                ]) {
                    bat 'aws ecr describe-images --repository-name %ECR_REPOSITORY% --image-ids imageTag=%IMAGE_TAG% --region %AWS_REGION%'
                }
            }
        }
    }

    post {
        success {
            echo '========================================'
            echo 'PIPELINE SUCCESS'
            echo 'Docker image pushed to AWS ECR'
            echo '========================================'
            echo "ECR Image: ${ECR_IMAGE}"
        }

        failure {
            echo '========================================'
            echo 'PIPELINE FAILED'
            echo 'Check the stage that failed above.'
            echo '========================================'
        }
    }
}