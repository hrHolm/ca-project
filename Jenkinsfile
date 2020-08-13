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
    stage('Dockerize Application') {
      when { branch "master" }
      environment {
        // Retrieve credentials from the Jenkins server
        DOCKERCREDS = credentials('docker_login')
      }
      steps {
        unstash 'code'
        // Run the build-docker script.
        sh 'chmod +x ./sh/*'
        sh 'ls'
        sh './sh/docker-build.sh'
        sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin'
        sh './sh/docker-push.sh'
      }
      options {
        skipDefaultCheckout(true)
      }
    }
  }
}