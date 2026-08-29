pipeline {
    agent any

    environment {
        PYTHON = 'C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
        DOCKER = 'C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'

        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '777040315554'

        ECR_REPOSITORY = '8byte-devops-app'
        ECR_REGISTRY = '777040315554.dkr.ecr.ap-south-1.amazonaws.com'
        IMAGE_NAME = '8byte-devops-app'
        IMAGE_TAG = '1.0'
    }

    stages {

        stage('Test') {
            steps {
                echo '=============================='
                echo 'Running Python Tests'
                echo '=============================='

                bat """
                    "%PYTHON%" -m pip install -r app\\requirements.txt
                """

                bat """
                    "%PYTHON%" -m pip install pytest
                """

                bat """
                    "%PYTHON%" -m pytest tests
                """
            }
        }

        stage('Docker Check') {
            steps {
                echo '=============================='
                echo 'Checking Docker'
                echo '=============================='

                bat """
                    "%DOCKER%" --version
                """

                bat """
                    "%DOCKER%" info
                """
            }
        }

        stage('AWS Check') {
            steps {
                echo '=============================='
                echo 'Checking AWS Credentials'
                echo '=============================='

                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-credentials',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ]) {
                    bat """
                        aws sts get-caller-identity
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '=============================='
                echo 'Building Docker Image'
                echo '=============================='

                bat """
                    "%DOCKER%" build -t %IMAGE_NAME%:%IMAGE_TAG% .
                """
            }
        }

        stage('Docker Login to ECR') {
            steps {
                echo '=============================='
                echo 'Logging in to AWS ECR'
                echo '=============================='

                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-credentials',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ]) {
                    bat """
                        aws ecr get-login-password --region %AWS_REGION% | "%DOCKER%" login --username AWS --password-stdin %ECR_REGISTRY%
                    """
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                echo '=============================='
                echo 'Tagging Docker Image'
                echo '=============================='

                bat """
                    "%DOCKER%" tag %IMAGE_NAME%:%IMAGE_TAG% %ECR_REGISTRY%/%ECR_REPOSITORY%:%IMAGE_TAG%
                """
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                echo '=============================='
                echo 'Pushing Docker Image to ECR'
                echo '=============================='

                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-credentials',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ]) {
                    bat """
                        "%DOCKER%" push %ECR_REGISTRY%/%ECR_REPOSITORY%:%IMAGE_TAG%
                    """
                }
            }
        }

        stage('Verify ECR Image') {
            steps {
                echo '=============================='
                echo 'Verifying Image in ECR'
                echo '=============================='

                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-credentials',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ]) {
                    bat """
                        aws ecr describe-images ^
                            --repository-name %ECR_REPOSITORY% ^
                            --image-ids imageTag=%IMAGE_TAG% ^
                            --region %AWS_REGION%
                    """
                }
            }
        }
    }

    post {
        success {
            echo '======================================'
            echo 'PIPELINE SUCCESS'
            echo '======================================'
            echo 'Docker image successfully pushed to ECR.'
            echo 'Repository: 8byte-devops-app'
            echo 'Tag: 1.0'
        }

        failure {
            echo '======================================'
            echo 'PIPELINE FAILED'
            echo '======================================'
            echo 'Check the stage above for the error.'
        }
    }
}