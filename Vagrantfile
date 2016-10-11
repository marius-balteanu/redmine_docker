#
# Before running "vagrant up", please make sure you have the config.yaml file prepared in the same folder.
# A sample config file is already provided as, config.yaml.sample, so you can start from it .
#
Vagrant.configure(2) do |config|
	config.vm.box      = "bento/ubuntu-16.04"
	config.vm.hostname = 'redmine'
	config.vm.network "private_network", ip: "192.168.33.31"

	#
	# Change the VM allocated resources to the one specified below.
	# Also change the name of the VM in the VirtualBox interface.
	#
	config.vm.provider "virtualbox" do |vb|
		vb.memory = "2048"
		vb.cpus = 1
		vb.name = "Redmine"
		vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
	end

  # Sync the sources folder with the machine
  # !! Make sure you have the vagrant nfs plugin installed if running on Windows
  # vagrant plugin install vagrant-winnfsd
  config.vm.synced_folder "./", "/awesome/automation", type: "nfs"

  # Set to true if you want automatic checks
  config.vm.box_check_update = false

  # Le awesome provisioning here
  config.vm.provision 'shell', run: 'always', inline: <<-SHELL
    # Install git if not present
    command -v git >/dev/null 2>&1
    if [ $? -eq 1 ]
    then
      echo 'Installing GIT'
      apt-get install  --assume-yes git
    fi

    # Install curl if not present
    command -v curl >/dev/null 2>&1
    if [ $? -eq 1 ]
    then
      echo 'Installing GIT'
      apt-get install  --assume-yes curl
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
    if [ ! -d /awesome ]
    then
      echo "Creating the /awesome folder"
      mkdir /awesome
      chown vagrant:vagrant /awesome
    fi

    if [ ! -d /awesome/redmine ]
    then
      echo "Cloning redmine repository"
      git clone https://github.com/redmine/redmine.git /awesome/redmine
      chown -R vagrant:vagrant /awesome/redmine
      cp /awesome/redmine/Gemfile /awesome/automation/files/
      cp /awesome/automation/files/Gemfile.local /awesome/redmine/
      cp /awesome/automation/files/database.yml /awesome/redmine/config/
      cp /awesome/automation/files/additional_environment.rb /awesome/redmine/config/
      cp /awesome/automation/files/secret_token.rb /awesome/redmine/config/initializers/
    fi

    # Installing samba if not present
    command -v samba >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
      echo 'Samba already installed!'
    else
      echo 'Installing and configuring Samba!'
      apt-get install samba -y --no-install-recommends >/dev/null 2>&1
    fi

    if [ ! -f /etc/samba/backsmb.conf ]
    then
      cp /etc/samba/smb.conf /etc/samba/backsmb.conf
      cat <<EOT >> /etc/samba/smb.conf
[awesome]
path = /awesome
available = yes
valid users = vagrant
read only = no
browseable = yes
public = yes
writable = yes
force user = vagrant
force group = vagrant
create mode = 0775
directory mode = 0775
EOT
      echo -e 'vagrant\nvagrant' | smbpasswd -as vagrant >/dev/null 2>&1
      /etc/init.d/samba reload >/dev/null 2>&1
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
