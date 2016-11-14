# Before running `vagrant up`, please make sure you have the config.yaml file prepared in the same folder.
# A sample config file is already provided as, config.yaml.sample, so you can start from it .
Vagrant.configure(2) do |config|
	config.vm.box         = 'debian/jessie64'
  config.vm.box_version = '8.6.1'

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

  # Sync the sources folder with the machine
  # !! Make sure you have the vagrant nfs plugin installed if running on Windows
  # vagrant plugin install vagrant-winnfsd
  config.vm.synced_folder './', '/awesome/automation', type: 'nfs'

  # Set to true if you want automatic checks
  config.vm.box_check_update = false

  # Le awesome provisioning here
  config.vm.provision 'shell', run: 'always', inline: <<-SHELL
    # Install git if not present
    command -v git >/dev/null 2>&1
    if [ $? -eq 1 ]
    then
      echo 'Installing GIT'
      apt-get install -y --no-install-recommends git
    fi

    # Install curl if not present
    command -v curl >/dev/null 2>&1
    if [ $? -eq 1 ]
    then
      echo 'Installing CURL'
      apt-get install -y --no-install-recommends curl
    fi

    # Install docker if not present
    command -v docker >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
      echo 'Docker already installed!'
    else
      echo 'Installing Docker, please be patient!'
      curl -sSL https://get.docker.com/ | sh
      usermod -aG docker vagrant
      service docker restart
      echo 'Docker successfully installed.'
    fi

    # Install docker-compose if not present
    command -v docker-compose >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
      echo 'Docker Compose already installed!'
    else
      echo 'Installing Docker Compose, please be patient!'
      curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose --version | awk 'NR==1{print $NF}')/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
      echo 'Docker Compose successfully installed.'
    fi

    # Project folder management
    if [ ! -d /work ]
    then
      echo 'Creating the /work folder'
      mkdir /work
      chown vagrant:vagrant /work
    fi

    # Starting the Nginx reverse proxy
    docker run --name nginx -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
      echo 'Run: Nginx reverse proxy!'
    else
      docker start nginx >/dev/null 2>&1
      echo 'Start: Nginx reverse proxy!'
    fi

    echo 'Everything is ready!'
  SHELL
end
