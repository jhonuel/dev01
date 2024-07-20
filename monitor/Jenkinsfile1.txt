pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'echo Construyendo la aplicación...'
                    // Agrega aquí los comandos reales para construir tu aplicación
                    // Ejemplo: sh 'mvn clean install'
                }
            }
        }
        stage('Tests') {
            steps {
                script {
                    sh 'echo Ejecutando pruebas...'
                    // Agrega aquí los comandos reales para ejecutar las pruebas
                    // Ejemplo: sh 'mvn test'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'docker-compose down -v'
                    sh 'docker-compose up -d --build'
                }
            }
        }
    }
    post {
        always {
            script {
                sh 'echo Limpiando...'
                // Agrega aquí los comandos para la limpieza post-pipeline
            }
        }
        success {
            script {
                sh 'echo Pipeline completada exitosamente.'
                // Puedes agregar notificaciones de éxito aquí
            }
        }
        failure {
            script {
                sh 'echo Pipeline fallida.'
                // Puedes agregar notificaciones de fallo aquí
            }
        }
    }
}
