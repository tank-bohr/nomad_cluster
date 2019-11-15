job "jenkins" {
  datacenters = ["dc1"]
  type = "service"

  group "example" {
    count = "1"

    volume "jenkins_home" {
      type      = "host"
      read_only = false
      source    = "jenkins_home"
    }

    task "jenkins-server" {
      driver = "java"
      user   = "vagrant"

      config {
        args        = ["--httpPort=${NOMAD_HOST_PORT_http}"]
        jar_path    = "/tmp/jenkins.war"
        # jvm_options = ["-Xmx2048m", "-Xms256m"]
      }

      artifact {
        source      = "http://mirrors.jenkins.io/war-stable/latest/jenkins.war"
        destination = "/tmp"
      }

      volume_mount {
        volume      = "jenkins_home"
        destination = "/var/jenkins_home"
        read_only   = false
      }

      env {
        JENKINS_HOME = "/var/jenkins_home"
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
