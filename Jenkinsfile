pipeline {
    agent any

    stages {
        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build -t "tooling-app:${env.BUILD_ID}"
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

