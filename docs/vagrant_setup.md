# Vagrant Setup

## Requirements

1. [Git](https://git-scm.com/downloads)
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. [Vagrant](https://www.vagrantup.com/downloads.html)

# Initial Setup

1. Clone this repository:
    ``` bash
    # HTTPS (not recommended, please use the SSH method below):
    git clone https://github.com/marius-balteanu/redmine_docker.git

    # SSH:
    git clone git@github.com:marius-balteanu/redmine_docker.git
    ```

2. Go inside the `redmine_docker` directory and run:
    ```bash
    vagrant up
    vagrant ssh
    ```

3. Once you are SSH-ed inside the virtual machine you must continue with the
steps from the [Host Setup](host_setup.md) file.
