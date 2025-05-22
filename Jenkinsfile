pipeline {
    agent any
    stages {
        stage('Deploy API') {
            steps {
                script {
                    // Run the shell publish script (for Linux agents)
                    sh '''
                        chmod +x Publish_script.sh
                        ./Publish_script.sh
                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'API deployment completed successfully.'
        }
        failure {
            echo 'API deployment failed.'
        }
    }
}
