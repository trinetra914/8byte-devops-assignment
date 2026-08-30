pipeline {
    agent any

    environment {
        PYTHON = 'C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
        DOCKER = 'C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
        TRIVY  = 'C:\\Users\\trine\\AppData\\Local\\Microsoft\\WinGet\\Packages\\AquaSecurity.Trivy_Microsoft.Winget.Source_8wekyb3d8bbwe\\trivy.exe'

        AWS_REGION     = 'ap-south-1'
        ECR_REGISTRY   = '777040315554.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPOSITORY = '8byte-devops-app'
        IMAGE_TAG      = "${BUILD_NUMBER}"

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
                // Set exit-code 1 to enforce strict security gate check
                bat "\"${TRIVY}\" image --ignore-unfixed --severity HIGH,CRITICAL --exit-code 1 ${ECR_REPOSITORY}:${IMAGE_TAG}"
            }
        }

        stage('Tag & Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    bat """
                        "${DOCKER}" tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_IMAGE}
                        "${DOCKER}" push ${ECR_IMAGE}
                    """
                }
            }
        }

        stage('Staging Deployment') {
            steps {
                echo "Deploying container tag ${IMAGE_TAG} to Staging Environment..."
                bat """
                    "${DOCKER}" stop app-staging 2>nul || exit 0
                    "${DOCKER}" rm app-staging 2>nul || exit 0
                    "${DOCKER}" run -d --name app-staging -p 8080:5000 ${ECR_IMAGE}
                """
            }
        }

        stage('Manual Production Approval') {
            steps {
                input message: "Approve deployment of version ${IMAGE_TAG} to Production?",
                      ok: "Deploy to Production"
            }
        }

        stage('Production Deployment') {
            steps {
                echo "Deploying container tag ${IMAGE_TAG} to Production Environment..."
                bat """
                    "${DOCKER}" stop app-prod 2>nul || exit 0
                    "${DOCKER}" rm app-prod 2>nul || exit 0
                    "${DOCKER}" run -d --name app-prod -p 80:5000 ${ECR_IMAGE}
                """
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
            echo "Docker image pushed and deployed: ${ECR_IMAGE}"
        }

        failure {
            echo 'CRITICAL: Pipeline failed during execution! Check stage logs above for root cause.'
            // Optional Jenkins Email Notification Plugin block
            // mail to: 'admin@company.com', subject: "BUILD FAILED: ${JOB_NAME} #${BUILD_NUMBER}", body: "Execution details: ${BUILD_URL}"
        }
    }
}