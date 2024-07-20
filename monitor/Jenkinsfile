pipeline {
    agent any
    environment {
        REPO_URL = 'https://github.com/jhonuel/dev01.git'
        DOCKER_IMAGE = 'jhonuel/monitor01:latest'
    }
    stages {
        stage('Checkout') {
            steps {
                git url: "${REPO_URL}", branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker run -d -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}'
                }
            }
        }
    }
    post {
        always {
            script {
                sh 'docker ps -a'
            }
        }
    }
}
