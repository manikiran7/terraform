pipeline {
    agent any // You can specify a specific agent label if needed, e.g., agent { label 'terraform-agent' }

    // IMPORTANT: Add the 'tools' block here to tell Jenkins to use your configured Terraform installation
    tools {
        // 'terraform-usr' should match the 'Name' you gave in "Manage Jenkins > Global Tool Configuration"
        terraform 'terraform-usr'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Ensure the 'github-manikiran7-pat' credential is configured in Jenkins.
                // Double-check the branch name: 'main' vs. 'master' based on your repo's default branch.
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
                // Optionally, you might want to archive the plan artifact for review.
                // archiveArtifacts artifacts: 'tfplan', fingerprint: true
            }
        }

        stage('Terraform Apply (Manual Approval)') {
            steps {
                // Manual input for approval
                input message: 'Proceed with Terraform Apply for local_file?', ok: 'Apply'
                sh 'terraform apply -auto-approve tfplan' // Apply using the saved plan
            }
            // Add a 'when' condition if you only want this to run if the plan stage was successful
            when {
                expression { currentBuild.currentResult == null || currentBuild.currentResult == 'SUCCESS' }
            }
        }

        stage('Verify File Creation') {
            steps {
                echo 'Verifying if pets.txt was created...'
                // Use 'ls' to list files in the workspace (where pets.txt should be created)
                sh 'ls -l pets.txt'
                // Use 'cat' to display the content of the file
                sh 'cat pets.txt'
                echo 'File verification complete.'
            }
            // Only run this stage if the apply stage was successful
            when {
                expression { currentBuild.currentResult == null || currentBuild.currentResult == 'SUCCESS' }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up the Jenkins workspace after every build
        }
        success {
            echo 'local_file Terraform pipeline completed successfully!'
            // Ensure Slack plugin is installed and configured (Manage Jenkins -> Configure System -> Slack)
            // 'slack-token' must be a Secret Text credential in Jenkins.
            slackSend(
                channel: '#team', // Recommended a dedicated channel for alerts
                color: 'good',
                message: "SUCCESS: Terraform pipeline for ${env.JOB_NAME} build ${env.BUILD_NUMBER} completed successfully!" +
                         "\nJenkins URL: ${env.BUILD_URL}",
                tokenCredentialId: 'slack-token'
            )
        }
        failure {
            echo 'local_file Terraform pipeline failed!'
            slackSend(
                channel: '#team', // Recommended a dedicated channel for alerts
                color: 'danger',
                message: "FAILURE: Terraform pipeline for ${env.JOB_NAME} build ${env.BUILD_NUMBER} failed!" +
                         "\nJenkins URL: ${env.BUILD_URL}",
                tokenCredentialId: 'slack-token'
            )
        }
    }
}
