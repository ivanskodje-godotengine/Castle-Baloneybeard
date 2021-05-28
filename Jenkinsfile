pipeline {
    agent any 
    stages {
        stage('Build') {
            steps {
                echo 'Compiling....' 
                sh 'godot --export web /var/www/test.ivsk.dev/index.html'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...' 
            }
        }
        stage('Deploy') {
            steps {
                echo 'Publishing... ' 
            }
        }
    }
}