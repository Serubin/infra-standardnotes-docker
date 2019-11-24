# Based on https://github.com/standardnotes/web/blob/master/Dockerfile

FROM ruby:alpine

ENV PROJECT_REPO=https://github.com/standardnotes/web
ENV PROJECT_TAG=master
ENV PROJECT_DIR=/app/

RUN apk add --update --no-cache \
    alpine-sdk \
    git \
    nodejs \
    nodejs-npm \
    tzdata

RUN git clone $PROJECT_REPO $PROJECT_DIR && \
    cd $PROJECT_DIR && \
    git checkout $PROJECT_TAG

RUN git clone https://github.com/sn-extensions/simple-task-editor.git /extensions/simple-task-editor && git clone https://github.com/sn-extensions/plus-editor.git /extensions/plus-editor && mv /extensions/* $PROJECT_DIR/public/extensions/

WORKDIR $PROJECT_DIR

RUN gem install bundler
RUN bundle install
RUN npm install
RUN npm run build
RUN bundle exec rake assets:precompile

EXPOSE 3000

ENTRYPOINT [ "./docker/entrypoint" ]
CMD [ "start" ]
