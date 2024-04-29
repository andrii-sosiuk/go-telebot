pipeline {
    agent {
        label 'built-in'
    }
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64', 'armv7'], description: 'Pick Architecture')
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