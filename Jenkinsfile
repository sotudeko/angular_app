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
              script{
          
              try {
                  def policyEvaluation = nexusPolicyEvaluation advancedProperties: '', enableDebugLogging: false, failBuildOnNetworkError: false, iqApplication: selectedApplication('angular_app'), iqInstanceId: 'nexusiq', iqStage: 'build', jobCredentialsId: 'admin'
                  echo "Nexus IQ scan succeeded: ${policyEvaluation.applicationCompositionReportUrl}"
                  IQ_SCAN_URL = "${policyEvaluation.applicationCompositionReportUrl}"
              } 
              catch (error) {
                  def policyEvaluation = error.policyEvaluation
                  echo "Nexus IQ scan vulnerabilities detected', ${policyEvaluation.applicationCompositionReportUrl}"
                  throw error
              }
          }
        }
    }

  }
}   