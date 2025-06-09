pipeline {
    agent any // You can specify a specific agent label if needed, e.g., agent { label 'terraform-agent' }

    environment {
        // No specific cloud provider credentials needed for local_file.
        // If your Git repo is private, the 'credentialsId' will be used in the 'git' step.
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Using your specified Git URL and credential ID
                git branch: 'main', credentialsId: 'github-manikiran7-pat', url: 'https://github.com/manikiran7/terraform.git'
                // IMPORTANT: Ensure 'main' is the correct branch name. Change to 'master' if needed.
                // The 'github-manikiran7-pat' credential must be configured in Jenkins Credentials.
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply (Manual Approval)') {
            steps {
                input message: 'Proceed with Terraform Apply for local_file?', ok: 'Apply'
                script {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        // Optional: Stage to destroy the resource
        stage('Terraform Destroy (Manual Approval)') {
            steps {
                input message: 'DO YOU REALLY WANT TO DESTROY THE LOCAL FILE?', ok: 'Destroy'
                script {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up the Jenkins workspace after every build
        }
        success {
            echo 'local_file Terraform pipeline completed successfully!'
            // Send Slack notification on success
            slackSend(
                channel: '#your-slack-channel', // Replace with your Slack channel name, e.g., '#devops-alerts'
                color: 'good',
                message: "SUCCESS: Terraform pipeline for ${env.JOB_NAME} build ${env.BUILD_NUMBER} completed successfully!" +
                         "\nJenkins URL: ${env.BUILD_URL}",
                tokenCredentialId: 'slack-token' // Use your specified Slack token credential ID
            )
        }
        failure {
            echo 'local_file Terraform pipeline failed!'
            // Send Slack notification on failure
            slackSend(
                channel: '#your-slack-channel', // Replace with your Slack channel name
                color: 'danger',
                message: "FAILURE: Terraform pipeline for ${env.JOB_NAME} build ${env.BUILD_NUMBER} failed!" +
                         "\nJenkins URL: ${env.BUILD_URL}",
                tokenCredentialId: 'slack-token' // Use your specified Slack token credential ID
            )
        }
    }
}
