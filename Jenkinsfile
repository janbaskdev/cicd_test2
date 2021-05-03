  
pipeline {
    agent any

	stages {
	stage('Clone repository') {
	steps {
        git branch: "master", url: "https://github.com/janbaskdev/cicd_test2.git", credentialsId: "edc817c3-ceb6-41e0-a0d6-6fe4450539e2"
    }}
	stage('Build Image') {
	steps {
	    
        sh "docker build --build-arg APP_NAME=cicd_test -t 217261290616.dkr.ecr.us-east-1.amazonaws.com/cicd_test2:cicd_test2-v_'${BUILD_NUMBER}' -f Dockerfile ."
		
		
    }}
    stage('Pushing Image to ECR') {
	steps {
		 sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 217261290616.dkr.ecr.us-east-1.amazonaws.com"
		 sh "docker push 217261290616.dkr.ecr.us-east-1.amazonaws.com/cicd_test2:cicd_test2-v_'${BUILD_NUMBER}'"
                
    }}
	stage('Deploy to ECS') {
	steps {
        sh "chmod +x ${WORKSPACE}/ci-cd/cicd_test-ecs.sh"
		sh "${WORKSPACE}/ci-cd/cicd_test-ecs.sh"
        cleanWs()
    }}

  }
}
