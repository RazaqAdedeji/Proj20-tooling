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
                sh '/usr/local/bin/docker build -t razaqadedeji/tooling:$BUILD_NUMBER .'
            }
        }
        stage('Login to Docker Hub and Push Image') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-hub-razaq', 
                                                  passwordVariable: 'DOCKERHUB_PSW', 
                                                  usernameVariable: 'DOCKERHUB_USR')]) {
                    sh 'echo $DOCKERHUB_PSW | /usr/local/bin/docker login -u $DOCKERHUB_USR --password-stdin'
                    sh '/usr/local/bin/docker push razaqadedeji/tooling:$BUILD_NUMBER'
                }
            }
        }
    }
    post {
        always {
            sh '/usr/local/bin/docker logout'
        }
    }
}
