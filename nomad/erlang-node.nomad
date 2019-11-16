job "erlang-node" {
  datacenters = ["dc1"]
  type = "service"

  group "erlang-node" {
    count = "6"

    task "erlang-node" {
      driver = "docker"

      config {
        image = "erlang:22.1.7-alpine"
        network_mode = "host"
        entrypoint = ["erl",
          "-noshell",
          "-name", "noodles-${NOMAD_ALLOC_INDEX}@${attr.unique.network.ip-address}",
          "-kernel", "inet_dist_listen_min", "${NOMAD_PORT_port_dist}",
                     "inet_dist_listen_max", "${NOMAD_PORT_port_dist}",
          "-start_epmd", "false",
          "-setcookie", "very-secret-cookie"
        ]
      }

      resources {
        network {
          mbits = 10
          port "port_dist" {}
        }
      }

      service {
        name = "erlang-node"
        tags = ["erlang", "distribution"]
        port = "port_dist"
        check {
          type     = "tcp"
          port     = "port_dist"
          interval = "5s"
          timeout  = "10s"
        }
      }
    }
  }
}
