# Redmine
## Requirements

1. Git
2. Virtual Box
3. Vagrant 
4. Vagrant NFS plugin (vagrant plugin install vagrant-winnfsd)

## Install

1. Clone the repository:

    ```
    git clone git@github.com:marius-balteanu/redmine_docker
    ```

2. Add a file named `env.list` in the `docker/env` folder, containing the
following:

    ```
    RAILS_ENV=development
    SECRET_TOKEN=thisisarandomstringthatmustbereplacedwithaproppersecrettoken
    ```

3. Run `docker-compose up -d` inside the project root to start the containers

4. Run the following commands to set up a fresh database:

    ```
    docker exec -it -u 1000 redmine_web_1 /entry \
      bundle exec rake db:create db:migrate redmine:load_default_data REDMINE_LANG=en
    ```

5. To reload the entire application run:

    ```
    docker-compose stop && docker-compose up -d
    ```
    
## View logs

Run `docker logs -f --tail=100 redmine_web_1`

## Execute commands inside a contaier

Make sure it is running and then run:

```
docker exec -it -u 1000 redmine_web_1 /entry bundle install
```
