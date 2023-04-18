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
              iqApplication: selectedApplication('angapp-ci-dir'), \
              iqScanPatterns: [[scanPattern: '**/*' ]],
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

     stage('Nexus IQ Scan (target)') {
      steps {
        script {
            nexusPolicyEvaluation \
              advancedProperties: '', \
              enableDebugLogging: false, \
              failBuildOnNetworkError: false, \
              iqApplication: selectedApplication('angapp-ci-target'), \
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
              iqApplication: selectedApplication('angapp-ci-sbom'), \
              iqScanPatterns: [[scanPattern: "${SBOM_FILE}"]], 
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

    stage('Nexus IQ Scan (CLI)'){
      steps {
        sh 'java -jar /opt/nxiq/nexus-iq-cli -t build -s http://localhost:8070 -a admin:admin123 -i angapp-ci-cli .'
      }
    }

  }
}   