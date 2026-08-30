pipeline {
    agent any

    environment {
        PYTHON = 'C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
        DOCKER = 'C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
        TRIVY = 'C:\\Users\\trine\\AppData\\Local\\Microsoft\\WinGet\\Packages\\AquaSecurity.Trivy_Microsoft.Winget.Source_8wekyb3d8bbwe\\trivy.exe'

        AWS_REGION = 'ap-south-1'
        ECR_REGISTRY = '777040315554.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPOSITORY = '8byte-devops-app'
        IMAGE_TAG = '1.0'

        ECR_IMAGE = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
    }

    stages {

        stage('Test') {
            steps {
                bat "\"${PYTHON}\" -m pip install -r app\\requirements.txt"
                bat "\"${PYTHON}\" -m pip install pytest"
                bat "\"${PYTHON}\" -m pytest tests"
            }
        }

        stage('Docker Check') {
            steps {
                bat "\"${DOCKER}\" --version"
                bat "\"${DOCKER}\" info"
            }
        }

        stage('AWS Check') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    bat 'aws sts get-caller-identity'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    bat """
                        aws ecr get-login-password --region ${AWS_REGION} | "${DOCKER}" login --username AWS --password-stdin ${ECR_REGISTRY}
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                    "${DOCKER}" build -t ${ECR_REPOSITORY}:${IMAGE_TAG} .
                """
            }
        }

  stage('Vulnerability Scan') {
    steps {
        bat "\"${TRIVY}\" image --severity HIGH,CRITICAL --exit-code 1 ${ECR_REPOSITORY}:${IMAGE_TAG}"
    }
}

        stage('Tag Docker Image') {
            steps {
                bat """
                    "${DOCKER}" tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_IMAGE}
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    bat """
                        "${DOCKER}" push ${ECR_IMAGE}
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
            echo "Docker image pushed: ${ECR_IMAGE}"
        }

        failure {
            echo 'Pipeline failed. Check the stage logs above.'
        }
    }
}