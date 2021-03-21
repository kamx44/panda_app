pipeline {
    agent any

    tools {
        maven "M3"
    }

    stages {
        stage ('build'){
            steps{
                echo "building application"
                git branch: 'test_local', credentialsId: 'git_credentials', url: 'https://github.com/kamx44/panda_app.git'
                sh "mvn install"
            }
        }

        stage('test'){
            steps{
                echo "mvn test -Pselenium"
            }
        }

        stage('deploy'){
            steps{
                echo "mvn deploy"
            }
        }

    }


}