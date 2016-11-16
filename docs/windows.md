# For Windows

## Requirements

1. Git
2. VirtualBox
3. Vagrant
4. Vagrant NFS plugin: `vagrant plugin install vagrant-winnfsd`

# Install

1. Clone this repository:

    ``` bash
    git clone https://github.com/marius-balteanu/redmine_docker.git
    ```

2. Go inside the `redmine_docker` directory and run:

    ```bash
    vagrant up
    vagrant ssh
    ```

3. Continue with the instructions from [linux.md](linux.md)
