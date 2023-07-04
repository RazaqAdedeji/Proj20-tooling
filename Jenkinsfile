pipeline {
    agent any
    stages { 
        stage('SCM Checkout') {
            steps {
                script {
                    checkout([
                        $class: 'GitSCM', 
                        userRemoteConfigs: [[url: 'https://github.com/RazaqAdedeji/Proj20-tooling.git']]
                    ])
                }
            }
        }

        stage('Build docker image') {
            steps {  
                sh 'docker build -t razaqadedeji/tooling:$BRANCH_NAME .'
            }
        }
        stage('Login to Docker Hub and Push Image') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-hub-razaq', 
                                                  passwordVariable: 'DOCKERHUB_PSW', 
                                                  usernameVariable: 'DOCKERHUB_USR')]) {
                    sh 'echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin'
                    sh 'docker push razaqadedeji/tooling:$BRANCH_NAME'
                }
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
