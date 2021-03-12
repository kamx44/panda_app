pipeline {
    agent {
		label 'Slave'
	}

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }

    stages {
        
        stage('Cleaning app'){
			steps {
				sh "docker rm -f pandaapp || true"
			}
		}
		stage('Get code'){
			steps {
				checkout scm
			}
		}
		stage('Build application && JUnit'){
			steps {
				sh "mvn package -Pdocker -Dmaven.test.skip=true"
			}
		}
		stage('Start application'){
			steps {
				sh "docker run -d --name pandaapp -p 0.0.0.0:8080:8080 -t ${IMAGE}.{VERSION}"
			}
		}
		stage('Selenium test'){
			steps {
				sh "mvn test -Pselenium"
			}
		}
		stage('Artifactory'){
			steps {
                configFileProvider([configFile(fileId: 'f29de68e-76e8-492f-a2bc-b3ab0cb9c87b', variable: 'MAVEN_SETTINGS')]) {
                    sh "mvn -s $MAVEN_SETTINGS deploy -Dmaven.test.skip=true"
                }
			}
		}
    }
		
    post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
        always {
            sh "docker stop pandaapp"
            unit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts 'target/*.jar'
            deleteDir()
        }
    }
    
}
