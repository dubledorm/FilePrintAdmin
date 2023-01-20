FROM ruby:2.6.6-alpine

ENV BUNDLER_VERSION=2.0.2
ENV SECRET_KEY_BASE='8b56cec9a10d0cf5423c191503a70f434f6371a81f2409959d696a3ff2313b63d0ae46ae0632a088dc28709a2dec833dab6ca224e32118201e4a3b3ab4ef717d'

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
#      python \
      tzdata \
      yarn

#RUN apk add imagemagick

# Настройка переменных окружения для production
ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_SERVE_STATIC_FILES=true


RUN gem install bundler -v 2.0.2

WORKDIR /app

COPY . ./
#COPY Gemfile Gemfile.lock ./

#RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install --without development test

#COPY package.json yarn.lock ./

RUN yarn install --check-files

RUN RAILS_ENV=production bundle exec ./bin/rake assets:precompile

# Установка часового пояса
ENV TZ=Europe/Moscow

# Проброс порта 3000
EXPOSE 3000

# Volume для лога
VOLUME ["/app/log", "/app/storage"]

#CMD ["bin/rails", "console"]

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
#ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
