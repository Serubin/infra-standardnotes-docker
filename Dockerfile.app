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
    tzdata \
    bash

RUN git clone $PROJECT_REPO $PROJECT_DIR && \
    cd $PROJECT_DIR && \
    git checkout $PROJECT_TAG

WORKDIR $PROJECT_DIR

RUN wget https://raw.githubusercontent.com/Serubin/standardnotes-manifest-creator/master/sn-manifest.sh && chmod -x sn-manifest.sh

RUN bash sn-manifest.sh -s -a editor-editor -t Component https://github.com/sn-extensions/plus-editor.git public/extensions/plus-editor
RUN bash sn-manifest.sh -s -a editor-editor -t Component https://github.com/sn-extensions/simple-task-editor.git public/extensions/simple-task-editor
RUN git submodule update --init --force --remote

RUN gem install bundler
RUN bundle install
RUN npm install
RUN npm run build
RUN bundle exec rake assets:precompile

EXPOSE 3000

ENTRYPOINT [ "./docker/entrypoint" ]
CMD [ "start" ]
