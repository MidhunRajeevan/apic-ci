pipeline {
    agent any
    environment {
        server = 'apic-mgmt-api-manager-tars-apic.apps.tars.ucmcswg.com'
    }
    stages {
        stage('Validate API and Product') {
            steps {
                script {
                    def validationStatus = catchError(buildResult: 'FAILURE', stageResult: 'FAILURE', catchInterruptions: true) {
                        sh '''
                            echo "Validating Product definition..."
                            apic validate catalog/products/subscription/subscription-approval-product_1.0.0.yaml
                        '''
                    }

                    if (validationStatus == null) {
                        echo "Validation successful."
                    } else {
                        echo "Validation failed."
                    }
                }
            }
        }

        stage('Deploy API') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'apic-creds', usernameVariable: 'user', passwordVariable: 'password')]) {
                        sh '''
                            chmod +x Publish_script.sh
                            ./Publish_script.sh "$user" "$password" "$server"
                        '''
                    }
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
