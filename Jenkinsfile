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

        stage('Building application ') {
            steps {
                script {
                    sh "/usr/local/bin/docker login -u razaqadedeji -p ${env.PASSWORD}"
                    sh "/usr/local/bin/docker build -t razaqadedeji/tooling-proj20:${env.TAG} ."
                }
            }
        }

        stage('Creating docker container') {
            steps {
                script {
                    sh "/usr/local/bin/docker run -d --name todo-app-${env.random_num} -p 8000:8000 razaqadedeji/tooling-proj20:${env.TAG}"
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
                    sh "/usr/local/bin/docker push mshallom/todo-proj20:${env.TAG}"
                }
            }
        }

        stage ('Clean Up') {
            steps {
                script {
                    sh "/usr/local/bin/docker stop tooling-app-${env.random_num}"
                    sh "/usr/local/bin/docker rm tooling-app-${env.random_num}"
                    sh "/usr/local/bin/docker rmi razaqadedeji/tooling-proj20:${env.TAG}"
                }
            }
        }

        stage ('logout Docker') {
            steps {
                script {
                    sh "/usr/local/bin/docker logout"
                }
            }
        }
    }
   
}