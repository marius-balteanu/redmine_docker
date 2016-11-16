# For Linux

## Requirements

1. Git
2. Docker
3. Docker Compose

## Install

1. Add the following to your `/etc/hosts` file:

    ```
    # Redmine
    0.0.0.0		redmine.local
    ```

2. Add the following to your `~/.bashrc` file:

    ```bash
    export HOST_USER_UID=`id -u`
    export HOST_USER_GID=`id -g`

    alias docker-exec='docker exec -it -u `id -u`:`id -g`'
    alias docker-tail='docker logs -f --tail=100'
    ```

3. Source the new `~/.bashrc` file:

    ```bash
    source ~/.bash_profile
    ```

4. Clone this repository:

    ``` bash
    git clone https://github.com/marius-balteanu/redmine_docker.git
    ```

5. Go inside the `redmine_docker/project` directory and clone the redmine repository:

    ```bash
    cd redmine_docker/project

    # Using HTTPS
    git clone https://github.com/redmine/redmine.git

    # Using SSH
    git clone git@github.com:redmine/redmine.git
    ```

6. Add a file named `env.list` in the `secrets` directory.
See `/secrets/.env.list.sample` for what it should contain.

7. Copy the files in `project/config` to their right location:

    ```bash
    \cp -f ./config/Gemfile.local ./redmine/
    \cp -f ./config/additional_environment.rb ./redmine/config/
    \cp -f ./config/database.yml ./redmine/config/
    \cp -f ./config/secret_token.rb ./redmine/config/initializers
    ```

8. Build the containers:

    ```bash
    docker-compose -f docker/docker-compose.build.yml build

    # For development you will need to build the dev setup as well.
    docker-compose -f docker/docker-compose.build-dev.yml build
    ```

9. Start the containers:

    ```bash
    # For the production setup:
    docker-compose -f docker/docker-compose.production.yml up -d

    # For the development setup:
    docker-compose -f docker/docker-compose.yml up -d
    ```

10. To set up a fresh database run:

    ```bash
    docker-exec redmine_web /entry bundle exec rake db:create db:migrate
    ```

11. To reload the entire application run:

    ```bash
    docker-compose restart
    ```

## View logs

```bash
docker-tail redmine_web
```

## Execute commands inside a contaier

Make sure the container is running and execute:

```bash
docker-exec redmine_web /entry bundle install
```
