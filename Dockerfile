FROM phusion/passenger-ruby25:0.9.35

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
  wget \
  build-essential \
  libc6-dev 

RUN wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.27.tar.gz

RUN tar -xzf freetds-1.00.27.tar.gz
WORKDIR freetds-1.00.27
RUN ls -la 
RUN ./configure --prefix=/usr/local --with-tdsver=7.3
RUN make
RUN make install

RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default
COPY webapp.conf /etc/nginx/sites-enabled/webapp

USER app

COPY Gemfile* /home/app/webapp/
WORKDIR /home/app/webapp

COPY --chown=app:app . /home/app/webapp
RUN bundle install

RUN cp config/secrets.examples.yml config/secrets.yml
RUN RAILS_ENV=production SECRET_KEY_BASE=x bundle exec rake assets:precompile

USER root

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

