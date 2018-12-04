#!groovy

def GIT_BRANCH = ''
def IMAGE_REF = ''
def IMAGE_TAG = ''
def VERSION = ''
def NAMESPACE = ''

pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git rev-parse HEAD > git-sha.txt'
                script {
                    GIT_COMMIT = readFile 'git-sha.txt'
                    GIT_SHA = git.getCommit()
                    IMAGE_REF=docker2.imageRef()
                    IMAGE_TAG=IMAGE_REF.split(':').last()
                    GIT_BRANCH = env.BRANCH_NAME.replace('/', '').replace('_', '').replace('-', '')

                    if (env.BRANCH_NAME == 'master') {
                        VERSION = env.BUILD_ID}
                    else {
                        VERSION = env.BUILD_ID +  GIT_BRANCH
                    }
                }
            }
        }

        stage('Build Docker images'){
            parallel {
                stage('unit test container') {
                    steps {
                        sh "docker build -f docker/tests.df . -t redis-lock-tests:${IMAGE_TAG}"
                    }
                }
                stage('package publisher container') {
                    steps {
                        sh "docker build -f docker/push-to-artifactory.df . -t redis-lock-publish:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Run tests') {
            steps {
                sh "docker run redis-lock-tests:${IMAGE_TAG}"
            }
        }

        stage('Push redis-lock package to artifactory') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Artifactory', usernameVariable: 'ARTI_NAME', passwordVariable: 'ARTI_PASS')]) {
                    sh "docker run -e ARTI_NAME=$ARTI_NAME -e ARTI_PASS=$ARTI_PASS redis-lock-publish:${IMAGE_TAG}"
                }
            }
        }
    }
}