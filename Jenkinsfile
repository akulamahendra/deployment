pipeline {
    agent any
    
    environment {
            AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
            AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
            AWS_REGION = 'ap-south-1'
    }
    stages{
        stage('clone repository'){
            steps{
                git 'https://github.com/akulamahendra/deployment.git'
            }
        }

        stage('terraform init'){
            steps{
                sh 'terraform init'
            }
        }

        stage('terraform apply'){
            steps{
                sh 'terraform apply --auto-approve'
            }
        }

        stage('docker image'){
            steps{
                sh 'docker built -t myapp .'
            }
        }

        stage('docker build container'){
            steps{
                sh 'docker run -d --name flaskapp -p 3000:80 myapp'
            }
        }
    }

}