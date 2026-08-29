pipeline {
    agent any

    stages {

        stage('Test') {
            steps {
                bat '"C:\\Users\\trine\\AppData\\Local\\Programs\\Python\\Python313\\python.exe" -m pytest tests'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t 8byte-devops-app:latest .'
            }
        }

    }
}