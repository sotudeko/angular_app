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

    stage('Directory listing') {
      steps {
          sh 'ls -lrt'
      }
    }

    stage('Nexus IQ Scan (directory)') {
      steps {
        script {
            nexusPolicyEvaluation \
              advancedProperties: '', \
              enableDebugLogging: false, \
              failBuildOnNetworkError: false, \
              iqApplication: selectedApplication('angular_app'), \
              iqScanPatterns: [[scanPattern: '.']], 
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

    stage('Nexus IQ Scan (SBOM)') {
      steps {
        script {
            nexusPolicyEvaluation \
              advancedProperties: '', \
              enableDebugLogging: false, \
              failBuildOnNetworkError: false, \
              iqApplication: selectedApplication('angular_app'), \
              iqScanPatterns: [[scanPattern: "${SBOM_FILE}"]], 
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

  }
}   