FROM ruby:2.2.5

ARG HOST_USER_UID=900
ARG HOST_USER_GID=900

ADD docker/* /work/docker/
ADD files/Gemfile* /work/
ADD files/additional_environment.rb /work/config/
ADD files/database.yml /work/config/
ADD docker/entry /

RUN set -ex                                                 && \
                                                               \
    echo 'Creating notroot user and group from host'        && \
    groupadd -g $HOST_USER_GID notroot                      && \
    useradd -lm -u $HOST_USER_UID -g $HOST_USER_GID notroot && \
                                                               \
    echo 'Giving permissions to files'                      && \
    chmod +x /entry                                         && \
    chown -R notroot:notroot /work                          && \
                                                               \
    echo 'Installing required packages'                     && \
    apt-get update                                          && \
    apt-get install -y --no-install-recommends                 \
      git                                                      \
      libmagickwand-dev                                        \
      libpq-dev                                                \
      nodejs                                                && \
                                                               \
    echo 'Installing gems as notroot'                       && \
    runuser notroot -c 'cd /work && bundle install --force' && \
                                                               \
    echo 'Removing unnecessary content'                     && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entry"]
