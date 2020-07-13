FROM phusion/passenger-ruby25:1.0.9

COPY delayed-job-log-forwarder.sh /etc/service/delayed-job-log-forwarder/run
COPY webapp.conf /etc/nginx/sites-enabled/webapp

# Install deps
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
        wget \
        build-essential \
        libc6-dev \
        net-tools \
        postgresql-client \
        xsltproc \
        yarn && \
    chmod +x /etc/service/delayed-job-log-forwarder/run && \
    rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

WORKDIR /tmp/freetds

# Download and install FreeTDS
RUN wget -qO- ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.27.tar.gz | tar --strip-components=1 -zxf - && \
    ./configure --prefix=/usr/local --with-tdsver=7.3 && \
    make && make install

COPY --chown=app:app Gemfile* /home/app/webapp/
COPY --chown=app:app . /tmp/app

WORKDIR /home/app/webapp

USER app

# Install gems, add application files, and precompile assets
RUN gem install bundler && \
    bundle install && \
    mv /tmp/app/* . && \
    mv config/database.yml.example config/database.yml && \
    RAILS_ENV=production SECRET_KEY_BASE=x bundle exec rake assets:precompile

USER root

# Clean up
RUN rm -rf /tmp/* /var/tmp/*
