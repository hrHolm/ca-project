pipeline {
  agent any
  environment {
    docker_username = 'fholm'
  }
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
          agent {
            docker {
              image 'python:rc-alpine'
            }
          }
          steps {
            unstash 'code'
            sh 'pip install -r ./requirements.txt'
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