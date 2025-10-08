@Library('jenkins-techlab-exercise-library') _

pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Timestamper Plugin
        // disableConcurrentBuilds() managed by locks and milestones
    }
    environment{
        ARTIFACT = "${env.JOB_NAME.split('/')[0]}-hello"
        REPO_URL = 'https://artifactory.puzzle.ch/artifactory/ext-release-local'
    }
    tools {
        jdk 'jdk11'
        maven 'maven36'
    }
    stages {
        stage('Build') {
            steps {
                milestone(10)  // The first milestone step starts tracking concurrent build order
                sh 'mvn -B -V -U -e clean verify -DskipTests'
            }
        }
        stage('Test') {
            steps {
                // Only one build is allowed to use test resources, newest builds run first
                lock(resource: 'myResource', inversePrecedence: true) {  // Lockable Resources Plugin
                    sh 'mvn -B -V -U -e verify -Dsurefire.useFile=false -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"'
                    milestone(20)  // Abort all older builds that didn't get here
                }
            }
            post {
                always {
                    archiveArtifacts 'target/*.?ar'
                    junit 'target/**/*.xml'  // JUnit Plugin
                }
            }
        }
        stage('Deploy') {
            steps {
                input "Deploy?"
                milestone(30)  // Abort all older builds that didn't get here
                echo 'deploy to artifactory'
                echo 'deploy on test server'
            }
        }
    }
    post {
        always {
            notifyPuzzleChat()
        }
    }
}