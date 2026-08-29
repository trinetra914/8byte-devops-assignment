pipeline {
    agent any

    stages {

        stage('Test') {
            steps {
                echo 'Installing Python dependencies...'

                bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe" -m pip install -r app\\requirements.txt'

                echo 'Installing pytest...'

                bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe" -m pip install pytest'

                echo 'Running tests...'

                bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe" -m pytest tests'
            }
        }

        stage('Docker Check') {
            steps {
                echo 'Checking Docker...'

                bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" --version'

                bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" info'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'

                bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" build -t 8byte-devops-app:1.0 .'
            }
        }

        stage('AWS ECR Push') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    echo 'Checking AWS authentication...'

                    bat 'aws sts get-caller-identity'

                    echo 'Logging in to Amazon ECR...'

                    bat 'aws ecr get-login-password --region ap-south-1 | "C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" login --username AWS --password-stdin 777040315554.dkr.ecr.ap-south-1.amazonaws.com'

                    echo 'Tagging Docker image...'

                    bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" tag 8byte-devops-app:1.0 777040315554.dkr.ecr.ap-south-1.amazonaws.com/8byte-devops-app:1.0'

                    echo 'Pushing Docker image to ECR...'

                    bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" push 777040315554.dkr.ecr.ap-south-1.amazonaws.com/8byte-devops-app:1.0'
                }
            }
        }

    }
}