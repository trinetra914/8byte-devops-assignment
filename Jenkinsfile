pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                bat 'python -m pytest tests'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t 8byte-devops-app:latest .'
            }
        }
    }
}