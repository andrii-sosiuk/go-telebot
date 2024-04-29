pipeline {
    agent built-in 
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS', defaultValue: 'linux')
        choice(name: 'ARCH', choices: ['amd64', 'arm64', 'armv7'], description: 'Pick Architecture', defaultValue: 'amd64')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                script {
                    def targetOS = params.OS
                    def targetArch = params.ARCH
                    sh "make build TARGET_OS=${targetOS} TARGET_ARCH=${targetArch}"
                }
            }
        }
    }
}