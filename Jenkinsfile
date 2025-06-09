pipeline {
    agent any // You can specify a specific agent label if needed, e.g., agent { label 'terraform-agent' }

    environment {
        // No specific cloud provider credentials needed for local_file,
        // but you could define other environment variables here if required.
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Replace 'YOUR_GIT_REPOSITORY_URL' with your actual repository URL.
                // If your repository is private, also set credentialsId: 'your-jenkins-git-credential-id'
                git branch: 'main', credentialsId: '', url: 'YOUR_GIT_REPOSITORY_URL'
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
                    // Save the plan to a file for consistent application
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply (Manual Approval)') {
            steps {
                // This input step provides a manual gate before applying changes
                input message: 'Proceed with Terraform Apply for local_file?', ok: 'Apply'
                script {
                    // Apply the saved plan automatically
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        // Optional: Stage to destroy the resource
        stage('Terraform Destroy (Manual Approval)') {
            steps {
                // This input step provides a manual gate before destroying infrastructure
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
        }
        failure {
            echo 'local_file Terraform pipeline failed!'
        }
    }
}
