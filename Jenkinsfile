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
            agent {
                docker {
                    image 'quay.io/projectquay/golang:1.20'
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    def targetOS = params.OS
                    def targetArch = params.ARCH
                    sh """
                        git config --global core.skipDoubtfulCheck true
                        make verbose
                        make build TARGET_OS=${targetOS} TARGET_ARCH=${targetArch}
                    """
                }
            }
        }
    }
}