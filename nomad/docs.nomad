job "docs" {
  datacenters = ["dc1"]

  group "example" {
    count = "3"
    task "server" {
      driver = "exec"

      config {
        command = "/usr/local/bin/http-echo"
        args = [
          "-listen", ":${NOMAD_PORT_http}",
          "-text", "hello world",
        ]
      }

      resources {
        network {
          mbits = 10
          port "http" {}
        }
      }
    }
  }
}
