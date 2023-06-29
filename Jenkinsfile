pipeline {
    agent any

    stages {
        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build("razaqadedeji/tooling_application:${env.BUILD_ID}")
                }
            }
        }
        stage('Docker Login') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-razaq') {
                        // no steps needed here
                    }
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-razaq') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}

