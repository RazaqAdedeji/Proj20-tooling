pipeline {
    agent any

    stages {
        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker build "tooling-app:1.0:${env.BUILD_ID}"
                }
            }
        }
        stage('Docker Login') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com/r/razaqadedeji/tooling_application', 'docker-hub-razaq') {
                        // no steps needed here
                    }
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com/r/razaqadedeji/tooling_application', 'docker-hub-razaq') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}

