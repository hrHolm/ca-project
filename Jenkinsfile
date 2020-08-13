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
          options {
            skipDefaultCheckout(true)
          }
          steps {
            sh 'echo Artifact'
            unstash 'code'
            sh 'mkdir archive'
            sh 'mkdir code'
            dir(path: 'archive') {
              unstash 'code'
            }

            zip(zipFile: 'code.zip', dir: 'archive', glob: '**/**.py|**/**.html')
            archiveArtifacts(artifacts: 'code.zip', fingerprint: true)
          }
        }

        stage('Test Application') {
          agent {
            docker {
              image 'python:rc-alpine'
            }

          }
          options {
            skipDefaultCheckout(true)
          }
          steps {
            unstash 'code'
            sh 'pip install -r ./requirements.txt'
            sh 'python ./tests.py'
          }
        }

      }
    }

    stage('Dockerize Application') {
      when {
        branch 'master'
      }
      environment {
        DOCKERCREDS = credentials('docker_login')
      }
      options {
        skipDefaultCheckout(true)
      }
      steps {
        unstash 'code'
        sh 'chmod +x ./sh/*'
        sh 'sh/docker-build.sh'
        sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin'
        sh 'sh/docker-push.sh'
      }
    }

  }
  environment {
    docker_username = 'fholm'
  }
}