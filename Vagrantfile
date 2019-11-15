Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y python-minimal
  SHELL

  workers_count = 7

  workers_count.times do |i|
    num = i + 1
    worker_name = sprintf("wk%03d", num)
    worker_addr = "192.168.51.#{ 100 + num }"
    config.vm.define worker_name do |worker|
      worker.vm.network "private_network", ip: worker_addr
      worker.vm.hostname  = worker_name
    end
  end

end
