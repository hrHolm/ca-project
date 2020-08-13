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

            zip(zipFile: 'code.zip', dir: 'archive', glob: '**/**.py, **/**.html')
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
    stage('Parallel Deployment') {
      parallel {
        stage('Deploy Production') {
          when {
            branch 'master'
          }
          steps {
            unstash 'code'
            sshagent(credentials : ['ssh_login']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@34.78.121.112 "echo hello"'
                sh 'scp ./docker-compose.yml ubuntu@34.78.121.112:./'
                sh 'ssh ubuntu@34.78.121.112 "docker pull fholm/codechan:latest"'
                sh 'ssh ubuntu@34.78.121.112 "bash -s" < sh/deploy.sh'
            }
          }
          options {
            skipDefaultCheckout(true)
          }
        }
        stage('Deploy Test') {
          when { 
            branch 'master' 
          }
          steps {
            unstash 'code'
            sshagent(credentials : ['ssh_login']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@35.195.90.84 "echo hello"'
                sh 'scp ./docker-compose.yml ubuntu@35.195.90.84:./'
                sh 'ssh ubuntu@35.195.90.84 "docker pull fholm/codechan:latest"'
                sh 'ssh ubuntu@35.195.90.84 "bash -s" < sh/deploy.sh'
            }
          }
          options {
            skipDefaultCheckout(true)
          }
        }
      }
    }
  }
  environment {
    docker_username = 'fholm'
  }
}