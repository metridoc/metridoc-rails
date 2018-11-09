FROM phusion/passenger-ruby25:0.9.35

RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default
COPY webapp.conf /etc/nginx/sites-enabled/webapp

USER app

COPY Gemfile* /home/app/webapp/
WORKDIR /home/app/webapp
RUN bundle install

COPY --chown=app:app . /home/app/webapp
RUN RAILS_ENV=production SECRET_KEY_BASE=x bundle exec rake assets:precompile

USER root
