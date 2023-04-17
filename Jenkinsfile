pipeline {

  agent any
        
  environment {
    SBOM_FILE = "bom.xml"
  }

  stages {

    stage('Install dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('Generate SBOM') {
      steps {
          sh 'npx auditjs@latest sbom > ${SBOM_FILE}'
      }
    }

    stage('Nexus IQ Scan') {
      steps {
        script {
            nexusPolicyEvaluation advancedProperties: '', enableDebugLogging: false, failBuildOnNetworkError: false, iqApplication: selectedApplication('angular_app'), iqInstanceId: 'nexusiq', iqStage: 'build', jobCredentialsId: 'Sonatype'
        }
      }
    }

  }
}   