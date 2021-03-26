pipeline {
    agent {
		label 'Slave'
	}

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
    }
    
    environment{
		IMAGE = readMavenPom().getArtifactId()
		VERSION = readMavenPom().getVersion()
		ANSIBLE = tool name: 'Ansible', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
	}

	

    stages {
        stage('Test installation') {
			steps {
				sh 'terraform version'
				sh 'ansible version'
			}
		}
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
				sh "docker run -d --name pandaapp -p 0.0.0.0:8080:8080 -t ${IMAGE}:${VERSION}"
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
		stage('Run terraform') {
			steps {
				dir('infrastructure/terraform') { 
				sh 'terraform init && terraform apply -auto-approve -var-file example.tfvars'
				} 
			}
		}
		stage('Copy Ansible role') {
			steps {
				sh 'cp -R infrastructure/ansible/panda/ /etc/ansible/roles/'
			}
		}
		stage('Run Ansible') {
			steps {
				dir('infrastructure/ansible') { 
				sh 'chmod 600 ../panda.pem'
				sh 'ansible-playbook -i ./inventory playbook.yml'
				} 
			}
		}
		
    }
		
    post {
        always {
            sh "docker stop pandaapp"
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts 'target/*.jar'
            deleteDir()
        }
    }
    
}