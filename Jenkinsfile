pipeline {

  agent any
        
  environment {
    SBOM_FILE = "angapp-bom.xml"
  }

  stages {

    stage ('Clean') {
      steps {
        script {
          cleanWs deleteDirs: true, patterns: [[pattern: 'node_modules', type: 'INCLUDE'], [pattern: 'package-lock.json', type: 'INCLUDE']]
        }
      }
    }
    stage('Install dependencies') {
      steps {
        sh 'npm install --omit=dev'
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
              iqApplication: selectedApplication('angapp-ci-dir2'), \
              iqScanPatterns: [[scanPattern: '**/*' ]],
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

}   
