pipeline{
    agent any
    stages{
        stage('Checkout SCM'){
            steps{
                git branch: 'main', url: 'https://github.com/sharonmathew13/Terraform-Jenkins-Ansible-AWS.git'
            }
        }
        stage('Checkout Ansible'){
            steps{
                ansiblePlaybook credentialsId: 'private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: '/tmp/aws_ec2.yaml', playbook: 'apache.yml'
                    }
        }
    }
}
