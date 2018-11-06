FROM phusion/passenger-ruby25:0.9.35

ADD . /home/app/metridoc
WORKDIR /home/app/metridoc

RUN bundle install
