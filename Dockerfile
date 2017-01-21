FROM ruby:2.3.3

LABEL maintainer "yyoshiki41@gmail.com"

RUN mkdir -p /app
ADD ./ /app
WORKDIR /app

EXPOSE 4000

RUN bundle update
RUN bundle install

CMD bash -c "bundle exec jekyll serve --watch --incremental --force_polling -H 0.0.0.0"
