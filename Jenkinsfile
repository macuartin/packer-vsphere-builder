#!/user/bin/env groovy

pipeline {

  agent any

  stages {

    stage('validate template') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'VSPHERE_CREDENTIALS', usernameVariable: 'VSPHERE_USERNAME', passwordVariable: 'VSPHERE_PASSWORD')]) {
          sh """packer validate \
                -var='vsphere-user=${VSPHERE_USERNAME}' \
                -var='vsphere-password=${VSPHERE_PASSWORD}' \
                -var='vm-name=${VM_NAME} \
                -var='iso_url=${ISO_URL}' \
                rhel/rhel-7.json"""
        }
      }
    }

    stage('build image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'VSPHERE_CREDENTIALS', usernameVariable: 'VSPHERE_USERNAME', passwordVariable: 'VSPHERE_PASSWORD')]) {
          sh """packer build \
                -var='vsphere-user=${VSPHERE_USERNAME}' \
                -var='vsphere-password=${VSPHERE_PASSWORD}' \
                -var='vm-name=${VM_NAME} \
                -var='iso_url=${ISO_URL}' \
                rhel/rhel-7.json"""
        }
      }
    } 
  }

  post { 
    always { 
      cleanWs()
    }
  }
}
