FROM mysql:5.7.19

ADD ./docker/services/mysql/entry /

RUN set -ex                             && \
                                           \
    echo 'Giving permissions to /entry' && \
    chmod +x /entry

# Uses the old entrypoint as a parameter to the new one
ENTRYPOINT ["/entry", "docker-entrypoint.sh"]

# Aparently you have to redefine the CMD from the parent image
CMD ["mysqld"]
