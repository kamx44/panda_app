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
                sh "mvn test -Pselenium"
            }
        }

        stage('deploy'){
            steps{
                configFileProvider([configFile(fileId: '868a2ddc-5619-43c6-94c4-f44181249d08', variable: 'MAVEN_SETTINGS')]) {
                    sh "mvn -s $MAVEN_SETTINGS deploy -Dmaven.test.skip=true"
                }
            }
        }

    }


}