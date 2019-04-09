pipeline {

  agent {
    kubernetes {
      cloud 'zeebe-ci'
      label "zeebe-ci-build_${env.JOB_BASE_NAME}-${env.BUILD_ID}"
      defaultContainer 'jnlp'
      yaml '''\
apiVersion: v1
kind: Pod
metadata:
  labels:
    agent: zeebe-ci-build
spec:
  nodeSelector:
    cloud.google.com/gke-nodepool: slaves
  tolerations:
    - key: "slaves"
      operator: "Exists"
      effect: "NoSchedule"
  containers:
    - name: docker
      image: docker:18.09.4-dind
      args: ["--storage-driver=overlay2"]
      securityContext:
        privileged: true
      tty: true
      resources:
        limits:
          cpu: 1
          memory: 1Gi
        requests:
          cpu: 500m
          memory: 512Mi
'''
    }
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timestamps()
    timeout(time: 15, unit: 'MINUTES')
  }

  parameters {
    string(name: 'OPERATE_VERSION', defaultValue: '1.0.0-RC2', description: 'Operate Version')
    string(name: 'ZEEBE_VERSION', defaultValue: '0.17.0', description: 'Zeebe Version')
    booleanParam(name: 'IS_LATEST', defaultValue: false, description: 'Also tag as latest version?')
  }

  environment {
      DOCKER_HUB = credentials("camunda-dockerhub")
      ZEEBE_VERSION = "${params.ZEEBE_VERSION}"
      OPERATE_VERSION = "${params.OPERATE_VERSION}"
      IS_LATEST = "${params.IS_LATEST}"
      IMAGE = "camunda/operate"
  }

  stages {
    stage('Prepare') {
      steps {
        container('docker') {
            sh 'docker login --username ${DOCKER_HUB_USR} --password ${DOCKER_HUB_PSW}'
        }
      }
    }

    stage('Build') {
      steps {
        container('docker') {
            sh 'docker build --no-cache --build-arg ZEEBE_VERSION=${ZEEBE_VERSION} --build-arg OPERATE_VERSION=${OPERATE_VERSION} -t ${IMAGE}:${OPERATE_VERSION} .'
        }
      }
    }

    stage('Upload') {
      steps {
        container('docker') {
            sh '''\
docker push ${IMAGE}:${OPERATE_VERSION}

if ${IS_LATEST}; then
    docker tag ${IMAGE}:${OPERATE_VERSION} ${IMAGE}:latest
    docker push ${IMAGE}:latest
fi
'''
        }
      }
    }
  }
}
