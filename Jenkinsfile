pipeline {
    agent any
    environment {
        registry = "khadijafetoui/docker-spring-boot"
        registryCredential = 'dockerHub'
        dockerImage = ''
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Khadijaa123/gestion-station-skii.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_HOST_URL = 'http://localhost:9000'
                SONAR_LOGIN = credentials('sonar-token')
            }
            steps {
                sh 'mvn sonar:sonar -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_LOGIN'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("$registry:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "$registryCredential", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $registry:latest'
                }
            }
        }

        stage('Start Minikube') {
            steps {
                sh '''
                minikube start
                minikube status
                '''
            }
        }

        stage('Deploy Prometheus & Grafana') {
            steps {
                sh '''
                kubectl apply -f k8s/prometheus-deployment.yaml
                kubectl apply -f k8s/grafana-deployment.yaml
                '''
            }
        }

        stage('Deploy Spring Boot App to Minikube') {
            steps {
                sh '''
                kubectl apply -f k8s/springboot-deployment.yaml
                kubectl apply -f k8s/springboot-service.yaml
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
        success {
            echo "Pipeline succeeded!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
