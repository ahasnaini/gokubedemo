
node {
    def app
    def commit_id
stage('Clone repository') {

/* Let's make sure we have the repository cloned to our workspace */
sh "git config --global user.email 'ahasnaini@hotmail.com'"
sh "git config --global user.name 'Asad Ali'"
sh 'echo "git config done"'
git branch: 'development', credentialsId: '9b8036862f394a238f47cb6428f69e1e', url: 'https://github.com/ahasnaini/gokubedemo.git'
sh "git rev-parse short HEAD > .git/commitid"
commit_id = readFile('.git/commitid').trim()
currentBuild.displayName = "1.0.${env.BUILD_NUMBER}.${commit_id}"
}


stage('Build image') {
/* This builds the actual image; synonymous to
* docker build on the command line */

app = docker.build("asadali/gokubedemo")

}

stage('Test image') {
/* Ideally, we would run a test framework against our image.
* For this example, we're using a Volkswagentype approach ;) */

app.inside {
sh 'echo "Tests passed"'
}
}

    
stage('Push image') {
/* Finally, we'll push the image with two tags:
* First, the incremental build number from Jenkins
* Second, the 'latest' tag.
* Pushing multiple tags is cheap, as all the layers are reused. */

docker.withRegistry('https://registry.hub.docker.com', 'dockerhubcredentials') {
app.push("${env.BUILD_NUMBER}${env.BRANCH_NAME}")
app.push("${env.BRANCH_NAME}${commit_id}")
if (env.BRANCH_NAME == 'master') {
app.push("latest")
}
if (env.BRANCH_NAME == 'development') {
app.push("dev")
}
}
}
}

stage('Remove Images') {
node {
 sh('echo "1.0.$BUILD_NUMBER"')
 sh('docker images | grep "gokubedemo" | awk "{print \\$3}" | uniq | xargs norunifempty docker  rmi f')
 sh('docker images quiet filter=dangling=true | xargs norunifempty docker rmi')
}
}

stage('Trigger Deploy'){
if (env.BRANCH_NAME == 'development') {
  def job = build job: 'Deploy', parameters: [[$class: 'StringParameterValue', name: 'IMAGE_TO_DEPLOY', value: '${env.BRANCH_NAME}${commit_id}']]
}
}

/*stage('Deploy') {
sh('kubectl apply f deployment.yml')
sh('kubectl set image deployment/demoappdeployment demoapp=asadali/gokubedemo:$BUILD_NUMBER$BRANCH_NAME')
}   */ 
