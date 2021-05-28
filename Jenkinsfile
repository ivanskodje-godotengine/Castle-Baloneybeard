pipeline {
    agent any 
    stages {
        stage('Export Game') {
            steps {
                echo 'Exporting GAME....' 
                sh 'godot --export web /var/www/game.ivsk.dev/index.html'
            }
        }
    }
}