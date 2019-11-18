job "jenkins" {
  datacenters = ["dc1"]
  type = "service"

  group "example" {
    count = "1"

    task "jenkins-docker" {
      driver = "docker"

      config {
        image = "jenkins/jenkins:lts"
        network_mode = "host"
        volumes = [
          "/data/services/jenkins:/var/jenkins_home"
        ]
      }
      env {
        JENKINS_OPTS = "--httpPort=${NOMAD_HOST_PORT_http}"
      }

      resources {
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "jenkins"
        tags = ["http", "jenkins"]
        port = "http"
      }
    }
  }
}
