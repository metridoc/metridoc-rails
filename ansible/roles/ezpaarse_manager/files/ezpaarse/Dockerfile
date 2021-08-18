FROM ezpaarseproject/ezpaarse:3.6.5

# install gosu
RUN set -eux; \
    apt-get update; \
    apt-get install -y gosu; \
    rm -rf /var/lib/apt/lists/*; \
    # verify that the binary works
    gosu nobody true

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# fix permissions
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    find . -group 0 -user 0 -print0 | xargs -P 0 -0 --no-run-if-empty chown node:node

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["ezpaarse", "start", "--no-daemon"]
