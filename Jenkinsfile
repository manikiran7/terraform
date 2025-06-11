pipeline {
    agent any

    tools {
        terraform 'terraform'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'github-manikiran7-pat', url: 'https://github.com/manikiran7/terraform.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Directly apply without manual input
                sh 'terraform apply -auto-approve tfplan'
            }
            when {
                expression { currentBuild.currentResult == null || currentBuild.currentResult == 'SUCCESS' }
            }
        }

        stage('Verify File Creation') {
            steps {
                echo 'Verifying if pets.txt was created...'
                sh 'ls -l pets.txt'
                sh 'cat pets.txt'
                echo 'File verification complete.'
            }
            when {
                expression { currentBuild.currentResult == null || currentBuild.currentResult == 'SUCCESS' }
            }
        }
    }

    post {
        always{
            cleanWs()
        }
        success {
            echo 'local_file Terraform pipeline completed successfully!'
            slackSend(
                channel: '#team',
                color: 'good',
                message: "SUCCESS: Terraform pipeline for ${env.JOB_NAME} build ${env.BUILD_NUMBER} completed successfully!\nJenkins URL: ${env.BUILD_URL}",
                tokenCredentialId: 'slack-token'
            )
        }
        failure {
            echo 'local_file Terraform pipeline failed!'
            slackSend(
                channel: '#team',
                color: 'danger',
                message: "FAILURE: Terraform pipeline for ${env.JOB_NAME} build ${env.BUILD_NUMBER} failed!\nJenkins URL: ${env.BUILD_URL}",
                tokenCredentialId: 'slack-token'
            )
        }
    }
}
