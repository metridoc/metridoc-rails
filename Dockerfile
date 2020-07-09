FROM phusion/passenger-ruby25:1.0.9

COPY delayed-job-log-forwarder.sh /etc/service/delayed-job-log-forwarder/run

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
        wget \
        build-essential \
        libc6-dev \
        net-tools \
        postgresql-client \
        xsltproc \
        yarn && \
    chmod +x /etc/service/delayed-job-log-forwarder/run

RUN wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.27.tar.gz && \
    tar -xzf freetds-1.00.27.tar.gz

WORKDIR /freetds-1.00.27

RUN ./configure --prefix=/usr/local --with-tdsver=7.3 && \
    make && \
    make install

RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default

COPY webapp.conf /etc/nginx/sites-enabled/webapp

USER app
WORKDIR /home/app/webapp

COPY --chown=app:app Gemfile* ./

RUN gem install bundler && \
    bundle install

COPY --chown=app:app . .

RUN mv config/database.yml.example config/database.yml && \
    RAILS_ENV=production SECRET_KEY_BASE=x bundle exec rake assets:precompile

USER root

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
