#!/bin/bash
set -x
PATH=$PATH:/usr/local/bin; export PATH
REGION=us-east-1
REPOSITORY_NAME=cicd_test2
CLUSTER=dev3
FAMILY=cicd_test2
SERVICE_NAME=cicdservice3

#STORE REPOSITORY URL IN VARIBALE
REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | tr '"' ' '`

#REPLACE THE BUILD NUMBER AND REPOSITORY URI PLACEHOLDERS WITH THE CONSTANT ABOVE
cd ci-cd/
sed -e 's/latest/cicd_test2-v_'${BUILD_NUMBER}'/g' cicd_test2-taskdef.json > cicd_test2-v-${BUILD_NUMBER}.json

#REGISTER TASK DEFINATION IN THE REPOSITORY
aws ecs  register-task-definition --family ${FAMILY} --container-definitions file://cicd_test2-v-${BUILD_NUMBER}.json  --execution-role-arn ecsTaskExecutionRole  --network-mode bridge  --requires-compatibilities EC2 --region ${REGION}

SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]`

# GET LATEST REVISION
REVISION=`aws ecs describe-task-definition --task-definition ${FAMILY} --region ${REGION} | grep revision | tr "/" " " | awk '{print $2}' | sed 's/"$//'`

#UPDATE SERVICES

aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${FAMILY} --deployment-configuration maximumPercent=100,minimumHealthyPercent=0 --force-new-deployment



