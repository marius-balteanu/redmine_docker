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
    # This will also install any required plugins so it is important to
    # run it before `vagrant up` the first time you interact with this
    # repository.
    vagrant status

    # Then continue executing commands as usual.
    vagrant up
    vagrant ssh
    ```

3. Adit your system's `hosts` file to contain the application's domain name:
    ```bash
    # This ip is the same form the `private_network` field in your `Vagrantfile`.
    # Make sure to update the value in the hosts file when you change it there.

    192.168.33.31 redmine.local
    ```

    The hosts file's location depends on your OS. Please consult your
    [favorite search engine](https://duckduckgo.com/) if you can not find it. A
    few common locations might include:
    * Windows: `C:\Windows\System32\drivers\etc\hosts`
    * Unix/Linux: `/etc/hosts`

4. Once you are SSH-ed inside the virtual machine you must continue with the
steps from the [Host Setup](host_setup.md) file.
