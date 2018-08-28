pipeline {
  agent any
  environment
  {    //it was in every stage
    IMAGE_NAME_SERVER = 'nexus.teamdigitale.test/daf-server'
  }
  stages {
    stage('Build') {
      steps { 
        script {    
          slackSend (message: "BUILD START: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' CHECK THE RESULT ON: https://cd.daf.teamdigitale.it/blue/organizations/jenkins/CI-MappaQuartiere/activity")             
           sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker build . -t $IMAGE_NAME_SERVER:$BUILD_NUMBER-$COMMIT_ID'
        }
      }
    }
    stage('Test') {
      steps { //sh' != sh'' only one sh command  
      script {         
         sh '''
	COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); 
        CONTAINERID=$(docker run -d -p 4000:4000 $IMAGE_NAME_SERVER:$BUILD_NUMBER-$COMMIT_ID);
        sleep 5s;
        docker stop $(docker ps -a -q); 
        docker rm $(docker ps -a -q)
	''' 
      }
    }
    }    
    stage('Upload'){
      steps {
        script {
          if(env.BRANCH_NAME == 'test' || env.BRANCH_NAME == 'production'){ 
            sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker push $IMAGE_NAME_SERVER:$BUILD_NUMBER-$COMMIT_ID'
            sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker tag $IMAGE_NAME_SERVER:$BUILD_NUMBER-$COMMIT_ID $IMAGE_NAME_SERVER:latest; docker push $IMAGE_NAME_SERVER:latest'  
            sh 'COMMIT_ID=$(echo ${GIT_COMMIT} | cut -c 1-6); docker rmi $IMAGE_NAME_SERVER:$BUILD_NUMBER-$COMMIT_ID;'
          }
        }       
      }
    }
/*    stage('Staging') {
      steps { 
        script {
          if(env.BRANCH_NAME=='test' ){
          sh ''' COMMIT_ID=$(echo ${GIT_COMMIT}|cut -c 1-6);
              sed "s#image: nexus.teamdigitale.test/daf-server.*#image: nexus.teamdigitale.test/daf-server:$BUILD_NUMBER-$COMMIT_ID#" mappa-quartiere.yaml > mappa-quartiere$BUILD_NUMBER.yaml;
              kubectl --kubeconfig=${JENKINS_HOME}/.kube/config.teamdigitale-staging apply -f mappa-quartiere$BUILD_NUMBER.yaml --force --validate=false; cat mappa-quartiere$BUILD_NUMBER.yaml; cat mappa-quartiere.yaml
              '''             
          slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' https://cd.daf.teamdigitale.it/blue/organizations/jenkins/CI-MappaQuartiere/activity")
          }
        }
      }
}*/
}
  post { 
        failure { 
            slackSend (color: '#ff0000', message: "FAIL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' https://cd.daf.teamdigitale.it/blue/organizations/jenkins/CI-MappaQuartiere/activity")
        }
    }
}