pipeline{
    agent any

    environment {
        TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        max = 20
        random_num = "${Math.abs(new Random().nextInt(max+1))}"
//         docker_password = credentials('dockerhub_password')
    }

    stages{
        stage("Workspace Cleanup") {
            steps {
                dir("${WORKSPACE}") {
                    deleteDir()
                }
            }
        }

        stage('Checkout Git') {
            steps {
                git branch: 'main', credentialsId: 'docker-hub-razaq', url: 'https://github.com/RazaqAdedeji/Proj20-tooling.git'
            }
        }

        stage('Building application ') {
            steps {
                script {
                    
                    sh " docker login -u razaqadedeji -p ${env.PASSWORD}"
                    sh " docker build -t razaqadedeji/tooling-proj20:${env.TAG} ."
                }
            }
        }

        stage('Creating docker container') {
            steps {
                script {
                    sh " docker run -d --name todo-app-${env.random_num} -p 8000:8000 mrazaqadedeji/tooling-proj20:${env.TAG}"
                }
            }
        }

        stage("Smoke Test") {
            steps {
                script {
                    sh "sleep 60"
                    sh "curl -I 127.0.0.1:8000"
                }
            }
        }

        stage("Publish to Registry") {
            steps {
                script {
                    sh " docker push mshallom/todo-proj20:${env.TAG}"
                }
            }
        }

        stage ('Clean Up') {
            steps {
                script {
                    sh " docker stop tooling-app-${env.random_num}"
                    sh " docker rm tooling-app-${env.random_num}"
                    sh " docker rmi razaqadedeji/tooling-proj20:${env.TAG}"
                }
            }
        }

        stage ('logout Docker') {
            steps {
                script {
                    sh " docker logout"
                }
            }
        }
    }
   
}