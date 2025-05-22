# Investment Bank API

This repository contains the API definitions and deployment scripts for the Investment Bank API suite. The APIs are designed to support various banking operations such as account enquiry, authentication, routing, transformation, and OAuth-based authorization.

## API Overview

- **Account Enquiry API**: Fetches account details for customers.
- **Routing and Transformation API**: Handles request routing, transformation, validation, and security checks.
- **Native OAuth API**: Provides OAuth 2.0 authentication and authorization.

API specifications are defined in the `catalog/products` directory as OpenAPI (Swagger) YAML files.

## Deployment

Deployment can be performed manually or via Jenkins CI/CD pipeline.

### Manual Deployment

Run the provided batch script in a command prompt:

```powershell
./Publish_script.bat
```

### Jenkins Pipeline Deployment

A Jenkins pipeline is provided to automate API deployment. The pipeline executes the `Publish_script.bat` script.

#### Jenkins Folder Structure

```
jenkins/
    Jenkinsfile
```

#### Jenkinsfile

The `Jenkinsfile` contains the pipeline definition:

```
pipeline {
    agent any
    stages {
        stage('Deploy API') {
            steps {
                script {
                    // Run the publish script
                    bat 'Publish_script.bat'
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
```

To use Jenkins for deployment:
1. Ensure Jenkins agent is running on Windows and has access to this repository.
2. Configure a Jenkins job to use the `jenkins/Jenkinsfile`.
3. Trigger the job to deploy the APIs automatically.

## Files and Structure

- `Publish_script.bat` – Batch script for manual deployment
- `jenkins/Jenkinsfile` – Jenkins pipeline for automated deployment
- `catalog/products/` – API product and definition YAML files

---
For any issues or questions, please contact the API development team.