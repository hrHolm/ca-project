pipeline {
  agent any
  stages {
    stage('Create Artifact') {
      parallel {
        stage('Create Artifact') {
          steps {
            sh 'echo hello'
          }
        }

        stage('Dockerize Application') {
          steps {
            sh 'echo yo'
          }
        }

      }
    }

  }
}