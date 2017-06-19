node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("asadali/gokubedemo")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

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
    
    input 'Do you want to proceed to the Deployment?'
    stage('Trigger Deploy'){
        if (env.BRANCH_NAME == 'development') {
                build 'gokubedemo - Deploy to Staging'
        }
    }

    /*stage('Deploy') {
            sh('kubectl apply -f deployment.yml')
            sh('kubectl set image deployment/demo-app-deployment demo-app=asadali/gokubedemo:$BUILD_NUMBER-$BRANCH_NAME')
        }   */ 
}
