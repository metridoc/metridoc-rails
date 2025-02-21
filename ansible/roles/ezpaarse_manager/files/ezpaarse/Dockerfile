# Use ezpaarse as the source of the code
FROM ezpaarseproject/ezpaarse:3.10.5 AS ezpaarse

# Use this as the base of the build
FROM node:18.16.0

# Add the paths to the environment
ENV PATH /opt/ezpaarse/bin:/opt/ezpaarse/node_modules/.bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH

# Copy the code from ezpaarse docker image into the node container
COPY --from=ezpaarse /opt/ezpaarse /opt/ezpaarse

WORKDIR /opt/ezpaarse

# Minimal build of ezPAARSE
RUN make node-modules build-nuxt ; npm cache clear --force

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

WORKDIR /scripts/

COPY run_ezp.py /scripts/

RUN apt-get update && \
    apt-get install -y python3-psycopg2 && \
    rm -rf /var/lib/apt/lists/*

# Enabling EzMaster
# See: https://github.com/Inist-CNRS/ezmaster
RUN echo '{ \
  "httpPort": 59599, \
  "configPath": "/opt/ezpaarse/config.local.json" \
}' > /etc/ezmaster.json

WORKDIR /opt/ezpaarse

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["ezpaarse", "start", "--no-daemon"]
