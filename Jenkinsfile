
node {
    def app
    def commit_id
stage('Clone repository') {

/* Let's make sure we have the repository cloned to our workspace */
git branch: 'development', credentialsId: 'github', url: 'https://github.com/ahasnaini/gokubedemo.git'
checkout scm
sh "git rev-parse --short HEAD > .git/commit-id"
commit_id = readFile('.git/commit-id').trim()
currentBuild.displayName = "1.0.${env.BUILD_NUMBER}"
sh "printenv"
}


stage('Build image') {
/* This builds the actual image; synonymous to
* docker build on the command line */
app = docker.build("asadali/gokubedemo")

}

stage('Test image') {
app.inside {
sh 'echo "Tests passed"'
}
}

    
stage('Push image') {
/* Finally, we'll push the image with two tags:
* First, the incremental build number from Jenkins
* Second, the 'latest' tag.
* Pushing multiple tags is cheap, as all the layers are reused. */

docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
    
         app.push("1.0.${env.BUILD_NUMBER}.${env.JOB_BASE_NAME}")
             app.push("latest")
    
}
}
}

stage('Remove Images') {
    node('master'){
sh('echo "1.0.$BUILD_NUMBER"')
sh('docker images | grep "gokubedemo" | awk "{print \\$3}" | uniq | xargs --no-run-if-empty docker  rmi -f')
sh('docker images --quiet --filter=dangling=true | xargs --no-run-if-empty docker rmi')
}
}

 stage('Trigger Deploy'){
     node('master') {
         git branch: 'development', credentialsId: 'github', url: 'https://github.com/ahasnaini/gokubedemo.git'
         checkout scm
         if(env.JOB_NAME=="GoKubeDemo/Master")
     {
         def job = build job: 'GoKubeDemo/PrepareDeploy', parameters: [[$class: 'StringParameterValue', name: 'IMAGE_TO_DEPLOY', value: currentBuild.displayName]]
     }
     if(env.JOB_NAME=="GoKubeDemo/Development")
     {
         sh('echo "Deploying to kube"')
         sh('export PATH=$PATH:/var/jenkins_home/ && kubectl --context=dev.kubernetes.asadali.net apply -f deployment.yml')
         sh('export PATH=$PATH:/var/jenkins_home/ && kubectl --context=dev.kubernetes.asadali.net set image deployment/demo-app-deployment demo-app=asadali/gokubedemo:1.0.$BUILD_NUMBER.$JOB_BASE_NAME')
     }
     }
    }
/*stage('Deploy') {
sh('kubectl apply f deployment.yml')
sh('kubectl set image deployment/demoappdeployment demoapp=asadali/gokubedemo:$BUILD_NUMBER$BRANCH_NAME')
}   */ 
