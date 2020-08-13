pipeline {
  agent any
  stages {
    stage('Clone Down') {
      steps {
        stash(excludes: '.git/', name: 'code')
      }
    }
    stage('Parallel Execution') {
      parallel {
        stage('Create Artifact') {
          steps {
            sh 'echo Artifact'
            unstash 'code'
          }
          options {
            skipDefaultCheckout(true)
          }
        }

        stage('Test Application') {
          image: 'python'
          steps {
            unstash 'code'
            sh 'python ./tests.py'
          }
          options {
            skipDefaultCheckout(true)
          }
        }
      }
    }
  }
}