# Host Setup

## Requirements

1. [Git](https://git-scm.com/download/linux)
2. [Docker](https://docs.docker.com/engine/installation/)
3. [Docker Compose](https://docs.docker.com/compose/install/)

## Preparation

Edit your `/etc/hosts` file with the following commands:
```bash
# First log in as root
sudo su -

cat <<- 'EOT' >> /etc/hosts
# Redmine
0.0.0.0 redmine.local
EOT

# Don't forget to exit root:
exit
```

Edit your `~/.bashrc` file with the following command:
```bash
cat <<- 'EOT' >> ~/.bashrc
export HOST_USER_UID=`id -u`
export HOST_USER_GID=`id -g`

alias docker-exec='docker exec -it -u `id -u`:`id -g`'
alias docker-tail='docker logs -f --tail=100'
EOT
```

Source the new `~/.bashrc` file:
```bash
source ~/.bashrc
```

Create and start an nginx reverse proxy:
``` bash
docker run                                    \
  --name nginx_reverse_proxy -d -p 80:80      \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  jwilder/nginx-proxy
```

Clone the repository:
``` bash
# Using HTTPS (not recommended, please use the SSH method below):
git clone https://github.com/marius-balteanu/redmine_docker.git

# Using SSH:
git clone git@github.com:marius-balteanu/redmine_docker.git
```

Go inside the `redmine_docker/project` directory and clone the redmine repository:
```bash
cd redmine_docker/project

# Using HTTPS (not recommended, please use the SSH method below):
git clone https://github.com/redmine/redmine.git

# Using SSH
git clone git@github.com:redmine/redmine.git
```


## Initial Setup

1. Go inside the `project` firectory from te repository root:
    ```bash
    cd project
    ```

2. You need to create the configuration files as following:
    * `environment/web.env`
    * `secrets/mysql_secrets.env`
    * `secrets/web_secrets.env`
    * `settings/web_settings.env`

    All of them have a corresponding `.sample` file in the same directory in which
    you can find more information about what each must contain. If you want the
    default values then siply copy them with the following commands:
    ```bash
    \cp -f ./environment/web.env.sample       ./environment/web.env
    \cp -f ./secrets/mysql_secrets.env.sample ./secrets/mysql_secrets.env
    \cp -f ./secrets/web_secrets.env.sample   ./secrets/web_secrets.env
    \cp -f ./settings/web_settings.env.sample ./settings/web_settings.env
    ```

2. Copy the files in `project/config` to their right location:
    ```bash
    \cp -f ./config/Gemfile.local             ./redmine/
    \cp -f ./config/additional_environment.rb ./redmine/config/
    \cp -f ./config/database.yml              ./redmine/config/
    \cp -f ./config/puma.rb                   ./redmine/tmp/
    \cp -f ./config/secret_token.rb           ./redmine/config/initializers
    ```

3. Build the containers:
    ```bash
    # First you build the production containers:
    docker-compose -f docker/build/build.yml build

    # If you want to do development you will have to execute the follwoing
    # command as well, otherwise skip it:
    docker-compose -f docker/build/build-dev.yml build
    ```

4. Make sure the reverse proxy is started:
    ```bash
    docker start nginx_reverse_proxy
    ```

5. Start the containers:
    For Development execute just this command below:
    ```bash
    docker-compose -p redmine up -d
    ```

    **Please DO NOT execute the commands below if you do not intend to bring up
    the PRODUCTION environment**

    For Production you will have to prefix all your commands with the
    `DEPLOYMENT_ENV=production` environment variable.
    ```bash
    DEPLOYMENT_ENV=production docker-compose -p redmine up -d
    ```

    If you do not run multiple environments on the same host you can also export
    the variable and just use the normal commands:
    ```bash
    export DEPLOYMENT_ENV=production

    docker-compose -p redmine up -d
    ```

    If you want the `DEPLOYMENT_ENV` variable to be permanent you need to set it
    in your `~/.bashrc` file:
    ```bash
    cat <<- 'EOT' >> ~/.bashrc
    export DEPLOYMENT_ENV=production
    EOT
    ```

    The possible values for the `DEPLOYMENT_ENV` variable are:
    * `DEPLOYMENT_ENV=development`
    * `DEPLOYMENT_ENV=production`

6. Connect the frontend network to the nginx reverse proxy:
    ```bash
    docker network connect redmine_frontend_network nginx_reverse_proxy
    ```

7. Initialize the database:
    ```bash
    docker-compose -p redmine exec web \
      /entry bundle exec rake db:create db:migrate
    ```

8. Restart the web service:
   ```bash
   docker-compose -p redmine restart web
   ```


## Cheatsheet

### Execute commands inside a contaier

Make sure the container is running and execute:

```bash
# To install gems use the version without `/enrty`
docker-compose -p redmine exec web bundle install

# Any other command that depends on the enviroment must pass trough `/entry`
docker-compose -p redmine exec web /entry rails c
```


### View logs

You can use the `docker-tail` alias:
```bash
docker-tail redmine_web_1
```

You can also use the full command:
``` bash
docker logs -f --tail=100 redmine_web_1
```


### Debugging

Place a `binding.pry` call where you would like the application to breakpoint.
Then attach to the container:

```bash
docker attach redmine_web_1
```

To detach from the container press `Ctrl+p Ctrl+q`.

>
#### NOTE!
If you press `Ctrl+c` while attached you will terminate the process and stop
the container. You will have to restart the container afterwards.
