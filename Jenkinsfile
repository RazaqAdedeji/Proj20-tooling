pipeline {
    agent any
    stages { 
        stage('SCM Checkout') {
            steps {
                script {
                    checkout([
                        $class: 'GitSCM', 
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[url: 'https://github.com/RazaqAdedeji/Proj20-tooling.git']]
                    ])
                }
            }
        }

        stage('Build docker image') {
            steps {  
                sh 'docker-compose -f tooling.yaml build'
            }
        }

        stage('Test') {
            steps {
                sh 'curl --fail http://localhost:5000 || exit 1'
            }
        }  

        stage('Login to Docker Hub and Push Image') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-hub-razaq', 
                                                  passwordVariable: 'DOCKERHUB_PSW', 
                                                  usernameVariable: 'DOCKERHUB_USR')]) {
                    sh 'echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin'
                    sh 'docker push razaqadedeji/tooling-docker-compose:$BUILD_NUMBER'
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker-compose -f tooling.yaml down -v'
            }
        }

    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
