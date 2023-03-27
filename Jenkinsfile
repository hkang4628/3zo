pipeline {
    //agent any
    agent {
        node {
            label 'node1'
        }
    }

    environment {
        TF_VAR_aws_access_key = credentials('aws_access_key_id')
        TF_VAR_aws_secret_key = credentials('aws_secret_access_key')
    }

    
    stages {

        stage('Build') {
            steps {
                dir('terraform') {
                    sh 'echo ${TF_VAR_aws_access_key}'
                    sh 'echo ${TF_VAR_aws_secret_key}'
                    sh 'echo "Building the project"'
                    sh 'terraform init'
                }
            }
        }
        
        stage('Test') {
            steps {
                dir('terraform') {
                        sh 'echo "Running tests"'
                        sh "terraform plan"
                }
            }
        }

        stage('Deploy') {
            steps {
                dir('terraform') {
                    sh 'echo "Deploying the project"'
                    sh 'terraform apply --auto-approve'
                }
            }
        }
    }
}
