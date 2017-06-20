node {
    def app
    currentBuild.displayName = "1.0.${env.BUILD_NUMBER}"
    stage('Clone repository') {
        
        checkout scm
    }

    stage('Build image') {
        
        app = docker.build("asadali/gokubedemo")
    }

    stage('Test image') {
        
        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}-${env.BRANCH_NAME}")
            if (env.BRANCH_NAME == 'master') {
            app.push("latest")
            }
            if (env.BRANCH_NAME == 'development') {
            app.push("dev")
            }
        }
    }
    
    stage('Remove Images') {
                sh('docker images | grep "gokubedemo" | awk "{print \\$3}" | uniq | xargs --no-run-if-empty docker  rmi -f')
                sh('docker images --quiet --filter=dangling=true | xargs --no-run-if-empty docker rmi')
    }
    
    /*stage('Trigger Deploy'){
        if (env.BRANCH_NAME == 'development') {
                build 'gokubedemo - Deploy to Staging'
        }
    }

    stage('Deploy') {
            sh('kubectl apply -f deployment.yml')
            sh('kubectl set image deployment/demo-app-deployment demo-app=asadali/gokubedemo:$BUILD_NUMBER-$BRANCH_NAME')
        }   */ 
}
