pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        disableConcurrentBuilds()
    }
    environment {
        NVM_HOME = tool('nvm')
    }
    stages {
        stage('Build') {
            steps {
                sh """#!/bin/bash +x
                    source \${HOME}/.nvm/nvm.sh
                    nvm install 4
                    node --version
                """
            }
        }
    }
}