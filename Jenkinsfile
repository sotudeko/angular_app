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
              iqApplication: selectedApplication('angular_app-ci-dir'), \
              iqScanPatterns: [[scanPattern: '**/npm-shrinkwrap.json' ], [scanPattern: '**/package-lock.json'], [scanPattern: '**/yarn.lock'], [scanPattern: '**/pnpm-lock.yaml']],
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
              iqApplication: selectedApplication('angular_app-ci-sbom'), \
              iqScanPatterns: [[scanPattern: "${SBOM_FILE}"]], 
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

  }
}   