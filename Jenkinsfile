pipeline {
    agent any

    environment {
        PYTHON = 'C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
        DOCKER = 'C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'

        AWS_REGION = 'ap-south-1'
        ECR_REPO = '777040315554.dkr.ecr.ap-south-1.amazonaws.com/8byte-devops-app'
        IMAGE_TAG = '1.0'

        AWS_CREDENTIALS = 'aws-credentials'
    }

    stages {

        stage('Test') {
            steps {
                echo 'Installing application dependencies...'

                bat "\"%PYTHON%\" -m pip install -r app\\requirements.txt"

                echo 'Installing pytest...'

                bat "\"%PYTHON%\" -m pip install pytest"

                echo 'Running tests...'

                bat "\"%PYTHON%\" -m pytest tests"
            }
        }

        stage('Docker Check') {
            steps {
                echo 'Checking Docker...'

                bat "\"%DOCKER%\" --version"

                bat "\"%DOCKER%\" info"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'

                bat "\"%DOCKER%\" build -t %ECR_REPO%:%IMAGE_TAG% ."

                echo 'Docker image built successfully.'

                bat "\"%DOCKER%\" images"
            }
        }

        stage('AWS Check') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}",
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    bat "aws sts get-caller-identity"
                }
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}",
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {

                    echo 'Logging into Amazon ECR...'

                    bat """
                        aws ecr get-login-password --region %AWS_REGION% | "%DOCKER%" login --username AWS --password-stdin %ECR_REPO%
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}",
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {

                    echo 'Pushing Docker image to ECR...'

                    bat "\"%DOCKER%\" push %ECR_REPO%:%IMAGE_TAG%"

                    echo 'Docker image pushed successfully.'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}",
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {

                    dir('terraform') {
                        echo 'Initializing Terraform...'

                        bat 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}",
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {

                    dir('terraform') {
                        echo 'Creating Terraform plan...'

                        bat 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}",
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {

                    dir('terraform') {
                        echo 'Applying Terraform infrastructure...'

                        bat 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Deployment Information') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: "${AWS_CREDENTIALS}",
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {

                    dir('terraform') {

                        echo 'Getting Terraform outputs...'

                        bat 'terraform output'
                    }
                }
            }
        }
    }

    post {
        success {
            echo '=========================================='
            echo 'PIPELINE COMPLETED SUCCESSFULLY'
            echo '=========================================='
            echo 'Tests passed.'
            echo 'Docker image built.'
            echo 'Docker image pushed to ECR.'
            echo 'Terraform infrastructure deployed.'
            echo '=========================================='
        }

        failure {
            echo '=========================================='
            echo 'PIPELINE FAILED'
            echo 'Check the stage above for the error.'
            echo '=========================================='
        }
    }
}