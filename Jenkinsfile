properties([
    buildDiscarder(logRotator(numToKeepStr: '5'))
])

timestamps() {
    timeout(time: 10, unit: 'MINUTES') {
        node {
            stage('Build') {
                withEnv(["JAVA_HOME=${tool 'jdk11'}", "PATH+MAVEN=${tool 'maven36'}/bin:${env.JAVA_HOME}/bin"]) {
                    checkout scm
                    sh 'mvn -B -V -U -e clean verify -Dsurefire.useFile=false -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"'
                    archiveArtifacts 'target/*.?ar'
                    junit 'target/**/*.xml'  // Requires JUnit plugin
                }
            }
        }
    }
}