FROM ruby:2.5.1

ENV LANG=C.UTF-8
ENV INSTALL_PATH /api

RUN echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y \
  build-essential \
  postgresql-client-9.6 \
  libpq-dev

WORKDIR $INSTALL_PATH

COPY Gemfile* $INSTALL_PATH/

RUN gem install bundler
RUN bundle install

COPY . .

EXPOSE 3001

CMD bundle exec puma -p 3001
