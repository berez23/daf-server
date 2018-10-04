pipeline {
    agent any
    environment {
        NEXUS_TEST = 'nexus.teamdigitale.test/daf-server'
        NEXUS_PROD = 'nexus.daf.teamdigitale.it/daf-server'
    }
    stages {
        stage('Build test ') {
            when { not { branch 'production' } }
            steps {
                slackSend (message: "BUILD START: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' CHECK THE RESULT ON: https://cd.daf.teamdigitale.it/blue/organizations/jenkins/daf-server/activity")
                sh '''COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker build . -t $NEXUS_TEST:$BUILD_NUMBER-$COMMIT_ID --network host'''
            }
        }
        stage('Build prod ') {
            when { branch 'production' }
            agent { label 'prod' }
            steps {
                slackSend (message: "BUILD START: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' CHECK THE RESULT ON: https://cd.daf.teamdigitale.it/blue/organizations/jenkins/daf-server/activity")
                sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker build . -t $NEXUS_PROD:$BUILD_NUMBER-$COMMIT_ID'
            }
        }
        stage('Test test') {
            when { not { branch 'production' } }
            steps {
                script {
                    sh '''
                       COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6);
                       CONTAINERID=$(docker run -d -p 3000:3000 $NEXUS_TEST:$BUILD_NUMBER-$COMMIT_ID);
                       sleep 5s;
                       docker stop $(docker ps -a -q);
                       docker rm $(docker ps -a -q)
                       '''
                }
            }
        }
        stage('Test prod') {
            when { branch 'production' }
            agent { label 'prod' }
            steps {
                script {
                    sh '''
                       COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6);
                       CONTAINERID=$(docker run -d -p 3000:3000 $NEXUS_PROD:$BUILD_NUMBER-$COMMIT_ID);
                       sleep 5s;
                       docker stop $(docker ps -a -q);
                       docker rm $(docker ps -a -q)
                       '''
                }
            }
        }
        stage('Upload test'){
            when { branch 'test' }
            steps {
                script {
                    if(env.BRANCH_NAME == 'test'  || env.BRANCH_NAME == 'production'){
                        sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker push $NEXUS_TEST:$BUILD_NUMBER-$COMMIT_ID'
                        sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker tag $NEXUS_TEST:$BUILD_NUMBER-$COMMIT_ID $NEXUS_TEST:latest; docker push $NEXUS_TEST:latest'
                        sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker rmi $NEXUS_TEST:$BUILD_NUMBER-$COMMIT_ID'
                        slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' https://cd.daf.teamdigitale.it/blue/organizations/jenkins/daf-server/activity")
                    }
                }
            }
        }
        stage('Upload prod') {
            when { branch 'production' }
            agent { label 'prod' }
            steps {
                script {
                    if(env.BRANCH_NAME == 'test'  || env.BRANCH_NAME == 'production'){
                        sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker push $NEXUS_PROD:$BUILD_NUMBER-$COMMIT_ID'
                        sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker tag $NEXUS_PROD:$BUILD_NUMBER-$COMMIT_ID $NEXUS_PROD:latest; docker push $NEXUS_PROD:latest'
                        sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker rmi $NEXUS_PROD:$BUILD_NUMBER-$COMMIT_ID'
                        slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' https://cd.daf.teamdigitale.it/blue/organizations/jenkins/daf-server/activity")
                    }
                }
            }
        }
    }
    post {
        failure {
            slackSend (color: '#ff0000', message: "FAIL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' https://cd.daf.teamdigitale.it/blue/organizations/jenkins/CI-MappaQuartiere/activity")
        }
    }
}
