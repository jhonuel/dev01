pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo Construyendo la aplicación...'
                // Agrega aquí los comandos reales para construir tu aplicación
                // Ejemplo: sh 'mvn clean install'
            }
        }
        stage('Tests') {
            steps {
                sh 'echo Ejecutando pruebas...'
                // Agrega aquí los comandos reales para ejecutar las pruebas
                // Ejemplo: sh 'mvn test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker-compose down -v'
                sh 'docker-compose up -d --build'
            }
        }
    }
    post {
        always {
            sh 'echo Limpiando...'
            // Agrega aquí los comandos para la limpieza post-pipeline
        }
        success {
            sh 'echo Pipeline completada exitosamente.'
            // Puedes agregar notificaciones de éxito aquí
        }
        failure {
            sh 'echo Pipeline fallida.'
            // Puedes agregar notificaciones de fallo aquí
        }
    }
}
