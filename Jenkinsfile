#!/user/bin/env groovy

pipeline {

  agent any

  stages {

    stage('validate template') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'VSPHERE_CREDENTIALS', usernameVariable: 'VSPHERE_USERNAME', passwordVariable: 'VSPHERE_PASSWORD'), usernamePassword(credentialsId: 'root-Template', usernameVariable: 'SSH_USERNAME', passwordVariable: 'SSH_PASSWORD')]) {
          sh "packer validate -var='vsphere_username=${VSPHERE_USERNAME}' -var='vsphere_password=${VSPHERE_PASSWORD}' -var='vm_template=${TEMPLATE}' -var='vm_name=${VM_NAME} -var='ssh_username=${SSH_USERNAME}' -var='ssh_password=${SSH_PASSWORD}' rhel/rhel-7.json"
        }
      }
    }

    stage('build image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'VSPHERE_CREDENTIALS', usernameVariable: 'VSPHERE_USERNAME', passwordVariable: 'VSPHERE_PASSWORD'), usernamePassword(credentialsId: 'root-Template', usernameVariable: 'SSH_USERNAME', passwordVariable: 'SSH_PASSWORD')]) {
          sh "packer build -var='vsphere_username=${VSPHERE_USERNAME}' -var='vsphere_password=${VSPHERE_PASSWORD}' -var='vm_template=${TEMPLATE}' -var='vm_name=${VM_NAME}' -var='ssh_username=${SSH_USERNAME}' -var='ssh_password=${SSH_PASSWORD}' rhel/rhel-7.json"
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
