job "epmd" {
  datacenters = ["dc1"]
  type = "service"

  group "epmd" {
    count = "4"

    task "epmd" {
      driver = "docker"

      config {
        image = "erlang:22.1.7-alpine"
        network_mode = "host"
        entrypoint = ["epmd"]
      }

      resources {
        network {
          mbits = 10
          port "epmd" {
            static = "4369"
          }
        }
      }

      service {
        name = "epmd"
        tags = ["epmd", "erlang"]
        port = "epmd"
        check {
          type     = "tcp"
          port     = "epmd"
          interval = "5s"
          timeout  = "10s"
        }
      }
    }
  }
}
