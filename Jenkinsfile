pipeline {
    agent { label env.JOB_NAME.split('/')[0] }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 10, unit: 'MINUTES')
        timestamps()  // Requires the "Timestamper Plugin"
    }
    triggers {
        pollSCM('H/5 * * * *')
    }
    stages {
        stage('Build') {
            steps {
                withEnv(["JAVA_HOME=${tool 'jdk11'}", "PATH+MAVEN=${tool 'maven35'}/bin:${env.JAVA_HOME}/bin"]) {
                    sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -Dmaven.test.failure.ignore=true'
                    archiveArtifacts 'target/*.?ar'
                }
            }
            post {
                always {
                    junit 'target/**/*.xml'  // Requires JUnit plugin
                }
            }
        }
    }
    post {
        success {
            mail to: "me@ne.me", subject: "Build success - ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "Success of build: ${env.JOB_NAME} ${env.BUILD_NUMBER}\nSee results in Jenkins: <${env.BUILD_URL}>"
        }
        unstable {
            mail to: "tanja.meier@centrisag.ch", subject: "Build unstable - ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "Unstable build: ${env.JOB_NAME} ${env.BUILD_NUMBER}\nSee results in Jenkins: <${env.BUILD_URL}>"
        }
        failure {
            mail to: "me@ne.me", subject: "Build failure - ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "Build failed: ${env.JOB_NAME} ${env.BUILD_NUMBER}\nSee results in Jenkins: <${env.BUILD_URL}>"
        }
    }
}