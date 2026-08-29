pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '777040315554'
        ECR_REPOSITORY = '8byte-devops-app'
        IMAGE_TAG = '1.0'

        PYTHON = 'C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
        DOCKER = 'C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
    }

    stages {

        stage('Test') {
            steps {
                bat '"%PYTHON%" -m pip install -r app\\requirements.txt'
                bat '"%PYTHON%" -m pip install pytest'
                bat '"%PYTHON%" -m pytest tests'
            }
        }

        stage('Docker Build') {
            steps {
                bat '"%DOCKER%" build -t %ECR_REPOSITORY%:%IMAGE_TAG% .'
            }
        }

        stage('Docker Login to ECR') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    bat '''
                        aws configure set aws_access_key_id "%AWS_ACCESS_KEY_ID%"
                        aws configure set aws_secret_access_key "%AWS_SECRET_ACCESS_KEY%"
                        aws configure set region "%AWS_REGION%"

                        aws sts get-caller-identity

                        aws ecr get-login-password --region "%AWS_REGION%" | "%DOCKER%" login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
                    '''
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                bat '''
                    "%DOCKER%" tag %ECR_REPOSITORY%:%IMAGE_TAG% %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPOSITORY%:%IMAGE_TAG%
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                bat '''
                    "%DOCKER%" push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPOSITORY%:%IMAGE_TAG%
                '''
            }
        }

        stage('Verify ECR Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    bat '''
                        aws configure set aws_access_key_id "%AWS_ACCESS_KEY_ID%"
                        aws configure set aws_secret_access_key "%AWS_SECRET_ACCESS_KEY%"
                        aws configure set region "%AWS_REGION%"

                        aws ecr describe-images ^
                          --repository-name "%ECR_REPOSITORY%" ^
                          --image-ids imageTag="%IMAGE_TAG%" ^
                          --region "%AWS_REGION%"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '========================================'
            echo 'CI/CD PIPELINE SUCCESS'
            echo 'Docker image pushed to AWS ECR'
            echo '========================================'
        }

        failure {
            echo '========================================'
            echo 'PIPELINE FAILED'
            echo 'Check the stage that failed.'
            echo '========================================'
        }
    }
}