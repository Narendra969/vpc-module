pipeline {
    agent {
        label 'tera-ans'
    }
    environment {
        GIT_CREDENTIALS = credentials('git_cred')
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_EC2_PRIVATE_KEY=credentials('k8s_servers_pvt_key')
    }
    stages {
        stage('CheckoutCode') {
            steps {
                git credentialsId: 'git_cred', 
                url: 'https://github.com/Narendra969/Jenkins-Terraform-Ansible.git'
            }
        }
        stage('CreateServers') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'git_cred',
                    usernameVariable: 'GIT_USERNAME',
                    passwordVariable: 'GIT_PASSWORD')
                    ])
                {
                    sh '''
                        terraform -chdir=Terraform init \\
                         -backend-config='access_key=$AWS_ACCESS_KEY_ID' \\
                         -backend-config='secret_key=$AWS_SECRET_ACCESS_KEY' \\
                         -backend-config='username=${GIT_USERNAME}' \\
                         -backend-config='password=${GIT_PASSWORD}'
                    '''
                }
            }
        }
    }
} 