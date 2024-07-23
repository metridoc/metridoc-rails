FROM python:3.12

# create user
RUN groupadd -g 1000 app && useradd -g app -u 1000 -m -d /home/app app

# install gosu
RUN set -eux; \
    apt-get update; \
    apt-get install -y gosu; \
    rm -rf /var/lib/apt/lists/*; \
    # verify that the binary works
    gosu nobody true

WORKDIR /home/app

COPY . .

RUN mv docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    pip3 install -r requirements.txt && \
    chown -R app:app .

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["tail", "-f", "/dev/null"]
