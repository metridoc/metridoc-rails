# Global Build Args ----------------------------------
# Image name
ARG IMAGE_NAME=ruby

# Image tag
ARG IMAGE_TAG=3.2.2-bookworm

# Rails env
ARG RAILS_ENV=development

# Build Stage ----------------------------------------
FROM ${IMAGE_NAME}:${IMAGE_TAG} AS base

ARG RUBY_MAJOR
ENV RUBY_MAJOR=3.2.0

ARG BUNDLE_HOME=vendor/bundle
ENV BUNDLE_HOME=${BUNDLE_HOME}

ARG PROJECT_ROOT=/home/app
ENV PROJECT_ROOT=${PROJECT_ROOT}

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV}

ENV BUNDLE_APP_CONFIG="${PROJECT_ROOT}/.bundle"
ENV GEM_HOME="${PROJECT_ROOT}/${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/"
ENV GEM_PATH="${PROJECT_ROOT}/${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/"
ENV NLS_LANG=$LANG
ENV PATH="${PROJECT_ROOT}/${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bin:${PATH}"

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    libc6-dev \
    net-tools \
    gosu \
    npm \
    postgresql-client \
    xsltproc && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/freetds

# Download and install FreeTDS
RUN wget -qO- ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.4.10.tar.gz | tar --strip-components=1 -zxf - && \
    ./configure --prefix=/usr/local --with-tdsver=7.3 && \
    make && make install
 
WORKDIR ${PROJECT_ROOT}

COPY Gemfile* ./

RUN bundle config path ${PROJECT_ROOT}/${BUNDLE_HOME} && \
    set -eux; \
    if [ "${RAILS_ENV}" = "development" ]; then \
    bundle config set with "development:test:assets"; \
    else \
    bundle config set without "development:test:assets"; \
    fi && \
    MAKE="make -j $(nproc)" bundle install && \
    rm -rf ${PROJECT_ROOT}/${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/cache/*.gem && \
    find ${PROJECT_ROOT}/${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/gems/ \( -name "*.c" -o -name "*.o" \) -delete

COPY . .

RUN addgroup app && useradd -m -d ${PROJECT_ROOT} -s /bin/bash -g app app && \
    mkdir -p ${PROJECT_ROOT}/tmp/pids && \
    mkdir -p ${PROJECT_ROOT}/app/assets/builds/

RUN find . -type d -exec chmod 755 {} + && \
    chmod 744 -R ./bin && \
    chmod +x -R ${PROJECT_ROOT}/${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bin/

RUN yarn install

RUN find . -type d -exec chown app:app {} \; && \
    find . -type f \( ! -name "*.key" \) -exec chown app:app {} \;

EXPOSE 3000
VOLUME ${PROJECT_ROOT}

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]

# Development Stage ----------------------------------
FROM base AS development

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV}

RUN SECRET_KEY_BASE=x bundle exec rake assets:precompile


# Production Stage -----------------------------------
FROM base AS production

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

# Set Rails env
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
RUN SECRET_KEY_BASE=x bundle exec rake assets:precompile
