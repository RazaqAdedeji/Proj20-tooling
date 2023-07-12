[![nginx 1.17.2](https://img.shields.io/badge/nginx-1.17.2-brightgreen.svg?&logo=nginx&logoColor=white&style=for-the-badge)](https://nginx.org/en/CHANGES) [![php 7.3.8](https://img.shields.io/badge/php--fpm-7.3.8-blue.svg?&logo=php&logoColor=white&style=for-the-badge)](https://secure.php.net/releases/7_3_8.php)


## Introduction
This is a Dockerfile to build a debian based container image running nginx and php-fpm 7.3.x / 7.2.x / 7.1.x / 7.0.x & Composer.

### Versioning
| Docker Tag | GitHub Release | Nginx Version | PHP Version | Debian Version |
|-----|-------|-----|--------|--------|
| latest | master Branch |1.17.2 | 7.3.8 | buster |


## How to use this repository
The build is automatically triggered by a git push to your feature/[branch]

## First clone the repository to your workstation
```
$ git clone https://gitlab.com/propitix/microservices/php-frontend.git
$ cd frontend-propitix
```

Create a feature branch. # Always start with feature/[name of your branch]
```
git branch -b feature/add-css-style-to-about-us-page
```


Update the application code in
```
./html/
```

Then add/commit/push to gitlab

```
git status # to see your changes
```

```
git add --all # If you are satisfied with your changes and willing to push everything. Otherwise, select only the files to add
```

```
git commit -m "Put some message about this push here"
```

## Push your changes to gitlab, and merge to dev branch
```
git push --set-upstream origin feature/[Your branch name]
```

### Validate your changes have been triggered by gitlab-ci in
[propitix-scm] (https://gitlab.com/propitix/microservices/frontend-propitix)

### Check the image have been pushed to
[Google Container Registry] (https://console.cloud.google.com/gcr/images/non-prod-pdz/EU/frontend-propitix?project=non-prod-pdz&authuser=1&gcrImageListsize=30) (Depending on the environment. Either non-prod or prod)

## pulling the image
```
docker pull eu.gcr.io/$environment/frontend-propitix:$tag-version
```

## Running (You can do this step without the pulling the above as it will put down if not found locally)
To run the container:
```
$ docker run -d eu.gcr.io/$environment/frontend-propitix:$tag-version
```

Default web root:
```
/usr/share/nginx/html
```

## If you require permissions to GCP, or Gitlab resources, please talk to dare@propitix.com


############

Create the DB contain: 
​​docker network create --subnet=172.18.0.0/24 php_app_network

First, let us create an environment variable to store the root password:
$ export MYSQL_PW=

verify the environment variable is created 
echo $MYSQL_PW
Then, pull the image and run the container, all in one command like below:
$ docker run --network php_app_network -h mysqlserverhost --name=mysql-server -e MYSQL_ROOT_PASSWORD=$MYSQL_PW  -d mysql/mysql-server:latest


Dockerfile

FROM php:7-apache

# Install mysqli extension
RUN docker-php-ext-install mysqli pdo_mysql

# Install git
RUN apt-get update && apt-get install -y git

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Enable Apache mods
RUN a2enmod rewrite

# Set the working directory in the container
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the application into the container
COPY . .

# Copy .env.sample to .env
RUN cp .env.sample .env

# Install dependencies
RUN composer install

# Run Laravel's key generation
RUN php artisan key:generate

# Change owner of the application directory
RUN chown -R www-data:www-data /var/www/html/

# Make port 80 available to the world outside this container
EXPOSE 80

# Run artisan server when the container launches
CMD php artisan serve --host=0.0.0.0 --port=80



—-----Building image

docker build -t php-app:0.0.1 .

—----Run image 

docker run --network php_app_network -p 8085:80 -it php-app:0.0.1 


………

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
                    sh "/usr/local/bin/docker push razaqadedeji/tooling-proj20:${env.TAG}"
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


—------
Docker-compose file with Healthstatus

version: "3.9"
services:
  tooling_frontend:
    build: .
    ports:
      - "5000:80"
    volumes:
      - tooling_frontend:/var/www/html
    links:
      - db
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://localhost:5000", "||", "exit", "1"]
      interval: 1m
      retries: 5
      start_period: 20s
      timeout: 10s
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: toolingdb
      MYSQL_USER: Admin
      MYSQL_PASSWORD: Admin.com
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - db:/var/lib/mysql
volumes:
  tooling_frontend:
  db:



