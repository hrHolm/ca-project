pipeline {
  agent any
  def remote = [:]
  remote.name = "host"
  remote.host = "34.78.202.204"
  remote.allowAnyHosts = true
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
    
    node {
        withCredentials([usernamePassword(credentialsId: 'ssh_login', passwordVariable: '', usernameVariable: 'ubuntu')]) {
            remote.user = userName
            remote.password = password

            stage("SSH Steps Rocks!") {
                writeFile file: 'test.sh', text: 'ls'
                sshCommand remote: remote, command: 'for i in {1..5}; do echo -n \"Loop \$i \"; date ; sleep 1; done'
                sshScript remote: remote, script: 'test.sh'
                sshPut remote: remote, from: 'test.sh', into: '.'
                sshGet remote: remote, from: 'test.sh', into: 'test_new.sh', override: true
                sshRemove remote: remote, path: 'test.sh'
            }
        }
    }
    stage('Deploy') {
      when {
        branch 'master'
      }
      environment {
        SSHCREDS = credentials('ssh_login')
      }
      steps {
        unstash 'code'
        sshagent(credentials : ['ssh_login']) {
            //sh 'scp ./docker-compose.yml ubuntu@34.78.202.204:./'
            //sh 'ssh ubuntu@34.78.202.204 "bash -s" < sh/deploy.sh'
            sh 'echo doesnt work yet'
        }

      }
    }

  }
  environment {
    docker_username = 'fholm'
  }
}