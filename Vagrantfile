# Automatically installs required plugin on Windows.
if Vagrant::Util::Platform.windows?
  plugin = 'vagrant-winnfsd'

  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin?(plugin)
end

# Configures virtual machine
Vagrant.configure(2) do |config|
  config.vm.box         = 'debian/stretch64'
  config.vm.box_version = '9.1.0'

  config.vm.network 'private_network', ip: '192.168.33.31'

  # Change the VM allocated resources to the one specified below.
  # Also change the name of the VM in the VirtualBox interface.
  config.vm.provider 'virtualbox' do |vb|
    vb.name   = 'Redmine'
    vb.memory = 2048
    vb.cpus   = 1

    vb.customize [
      'setextradata',
      :id,
      'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root',
      '1'
    ]
  end

  # Sync the sources folder with the machine.
  synced_folder_type = Vagrant::Util::Platform.windows? ? 'nfs' : nil
  config.vm.synced_folder '.', '/vagrant', type: synced_folder_type

  # Set to true if you want automatic checks.
  config.vm.box_check_update = false

  # Le awesome provisioning here
  config.vm.provision 'shell', run: 'always', inline: <<-SHELL
    set -x

    # Install curl if not present
    command -v curl >/dev/null 2>&1
    if [ $? -eq 1 ]
    then
      echo 'Installing CURL'
      apt-get update
      apt-get install -y --no-install-recommends curl
    fi

    # Install docker if not present
    command -v docker >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
      echo 'Docker already installed!'
    else
      echo 'Installing Docker, please be patient!'

      set -e

      apt-get update
      apt-get install -y           \
        apt-transport-https        \
        ca-certificates            \
        software-properties-common

      curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -
      apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
      add-apt-repository                         \
        "deb https://apt.dockerproject.org/repo/ \
        debian-$(lsb_release -cs)                \
        main"

      apt-get update
      apt-get -y install docker-engine

      usermod -aG docker vagrant
      service docker restart

      set +e

      echo 'Docker successfully installed.'
    fi

    # Install docker-compose if not present
    command -v docker-compose >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
      echo 'Docker Compose already installed!'
    else
      echo 'Installing Docker Compose, please be patient!'

      curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

      echo 'Docker Compose successfully installed.'
    fi

    echo 'Everything is ready!'
  SHELL

  # Provision the machine (install software prerequisites)
	config.vm.provision "ansible_local" do |ansible|
		ansible.playbook = "ansible/provision.yml"
  end
end
