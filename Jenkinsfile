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

        stage('Dockerize Application') {
          steps {
            sh 'echo Dockerize'
            sh 'unstash code'
          }
          options {
            skipDefaultCheckout(true)
          }
        }
      }
    }
  }
}