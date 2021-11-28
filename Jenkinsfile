pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="065740665475"
        AWS_DEFAULT_REGION="us-east-2" 
        IMAGE_REPO_NAME="bharathpantala/demospringmonitor"
        ARTIFACT_NAME="demospringmonitor"
        IMAGE_TAG="v2021.11"
        REPOSITORY_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        AWS_CREDS_ID="aws-creds-ecr"
        DH_CREDS_ID="docker-hub-secret"
        K8S_SECRET="k8s-secret"
    }
    stages {
        // Building Docker images
        stage('Checkout SCM') {
            steps{
               git credentialsId: 'github-key', url: 'git@github.com:cloudrural/demospringmonitor.git'
            }
        }
        // Building Docker images
        stage('Building App') {
            steps{       
                sh "mvn clean package"
            }
        }
        // Building Docker images
        stage('Docker Image') {
            steps{
                script {
                sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."
                }
            }
        }
        stage('Logging into Docker Hub') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: env.DH_CREDS_ID, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                    sh "docker login --username $USERNAME -p $PASSWORD docker.io"
                    }
                }
            }
        }   
        // Uploading Docker images into AWS ECR
        stage('Pushing to Dockerhub') {
            steps{  
                script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push bharathpantala/demospringmonitor:${IMAGE_TAG}"
                }
            }
        }
/*
        stage('Logging into AWS ECR') {
            steps {
                script {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: env.AWS_CREDS_ID, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin 065740665475.dkr.ecr.us-east-2.amazonaws.com"
                    }
                }
            }
        }   
        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
            steps{  
                script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
*/
        // Uploading Docker images into AWS ECR
        stage('Deploy') {
            steps{  
                script {
                    sh "echo Deploying"
                    sh "helm upgrade --install $ARTIFACT_NAME deploymemt/helm/$ARTIFACT_NAME --namespace app"

                   //sh "helm upgrade --install $ARTIFACT_NAME deploymemt/helm/$ARTIFACT_NAME"
                }
            }
        }
    }
}

/*

withCredentials([file(credentialsId: 'secret', variable: 'KUBECONFIG')]) {

  // change context with related namespace
  sh "kubectl config set-context $(kubectl config current-context) --namespace=${namespace}"

  //Deploy with Helm
  echo "Deploying"
  sh "helm upgrade --install road-dashboard -f values.${ENV}.yaml --set tag=$TAG --namespace ${namespace}"
}
stage('Deploy to dev'){
         script{
             steps{
                 if(env.GIT_BRANCH.contains("dev")){

                        def namespace="dev"
                        def ENV="development"

                        withCredentials([file(credentialsId: ...)]) {
                        // change context with related namespace
                        sh "kubectl config set-context $(kubectl config current-context) --namespace=${namespace}"

                        //Deploy with Helm
                        echo "Deploying"
                        sh "helm upgrade --install road-dashboard -f values.${ENV}.yaml --set tag=$TAG --namespace ${namespace}"    
                 }
             }
         }
     }

    stage('Deploy to Test'){
        script{
            steps{
                 if(env.GIT_BRANCH.contains("test")){

                        def namespace="test"
                        def ENV="test"

                        withCredentials([file(credentialsId: ...)]) {
                        // change context with related namespace
                        sh "kubectl config set-context $(kubectl config current-context) --namespace=${namespace}"


                        //Deploy with Helm
                        echo "Deploying"
                        sh "helm upgrade --install road-dashboard -f values.${ENV}.yaml --set tag=$TAG --namespace ${namespace}"
                    }
                }
            }
        }
    }

    stage ('Deploy to Production'){

        when {
            anyOf{
                environment name: 'DEPLOY_TO_PROD' , value: 'true'
            }
        }

        steps{
            script{
                DEPLOY_PROD = false
                def namespace = "production"

                withCredentials([file(credentialsId: 'kube-config', variable: 'kubecfg')]){
                    //Change context with related namespace
                    sh "kubectl config set-context $(kubectl config current-context) --namespace=${namespace}"

                    //Deploy with Helm
                    echo "Deploying to production"
                    sh "helm upgrade --install road-dashboard -f values.${ENV}.yaml --set tag=$TAG --namespace ${namespace}"
                }
            }
        }
    }
*/