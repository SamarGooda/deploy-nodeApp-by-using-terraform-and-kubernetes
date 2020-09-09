resource "kubernetes_pod" "jenkins" {
  metadata {
    name      = "jenkins-example"
    namespace = "build"
    labels = {
      app = "jenkins-server"
    }
  }

  spec {
    container {
      # image = "jenkins/jenkins:lts"
      image = "samargooda/installansible"
      name  = "jenkins"
    
  
      port {
        container_port = 8080
      }
      volume_mount {
        name       = "jenkins-home"
        mount_path = "/var/jenkins_home"
      }
      volume_mount {
        name       = "kubectl"
        mount_path = "/var/kubectl"
      }
  
      volume_mount {
        name       = "docker"
        mount_path = "/usr/bin/docker"
      }
      volume_mount {
        name       = "dockersock"
        mount_path = "/var/run/docker.sock"
      }

    }
    # to make a token to service account , it is must
    service_account_name            = "jenkins"
    automount_service_account_token = "true"
    # volume for jenkins
    volume {
      name = "jenkins-home"
      persistent_volume_claim {
        claim_name = "pvc-jenkins"
      }
    }

    security_context {
      fs_group = "1000"
    }
    # init container to install kubectl , we use image's eslam 
    init_container {
      name    = "install-kubectl"
      # image   = "allanlei/kubectl"
      image = "eslamkarim/jenkins-ansible-kubectl"
      command = ["cp", "/usr/local/bin/kubectl", "/data/kubectl"]

      volume_mount {
        name       = "kubectl"
        mount_path = "/data/kubectl"
      }
    }
    volume {
      name = "kubectl"
      empty_dir {}
    }


  #  volume for docker cli
        volume{
          name = "docker"
          host_path{
             path = "/usr/bin/docker"
        }
     }
    #  volume for docker socket , it must to operate docker
       volume{
          name = "dockersock"
          host_path{
             path = "/var/run/docker.sock"
        }
     }
  }
}

  # Node-port-service for jenkins , it helps me to access jenkins from external
resource "kubernetes_service" "jenkins-service" {
  metadata {
    name      = "jenkins-service"
    namespace = "build"
  }
  spec {
    selector = {
      app = "${kubernetes_pod.jenkins.metadata.0.labels.app}"
    }
    port {
      port        = "8080"
      target_port = "8080"
      node_port   = "31000"
    }
    type = "NodePort"
  }
}
