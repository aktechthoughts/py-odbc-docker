pipeline {
  agent any
  stages {
        stage('Building image') {
            steps{
                script {
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
   }   
}
