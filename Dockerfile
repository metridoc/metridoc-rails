FROM phusion/passenger-ruby32:2.6.2

COPY delayed-job-log-forwarder.sh /etc/service/delayed-job-log-forwarder/run
COPY webapp.conf /etc/nginx/sites-enabled/webapp

# Install deps
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -qq -y --no-install-recommends \
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
RUN wget -qO- ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.4.10.tar.gz | tar --strip-components=1 -zxf - && \
    ./configure --prefix=/usr/local --with-tdsver=7.3 && \
    make && make install

COPY --chown=app:app Gemfile* /home/app/webapp/
COPY --chown=app:app . /tmp/app

WORKDIR /home/app/webapp

USER app

# Add Application Files
RUN mv /tmp/app/* . && \
    mv config/database.yml.example config/database.yml

# Install gems and node modules
RUN gem install bundler && \
    yarn install && \
    bundle install

# Precompile Assets
RUN RAILS_ENV=production SECRET_KEY_BASE=x bundle exec rake assets:precompile

USER root

# Clean up
RUN rm -rf /tmp/* /var/tmp/*
