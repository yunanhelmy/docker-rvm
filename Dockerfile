FROM alpine:3.8
LABEL Maintainter=yunanhelmy

ENV RVM_USER    rvm
ENV RVM_GROUP   rvm

USER root

RUN addgroup $RVM_GROUP && \
    adduser -h /home/$RVM_USER -g 'RVM User' -s /bin/bash -G $RVM_GROUP -D $RVM_USER 

# Install bash
RUN apk update && apk add bash && rm -rf /var/cache/apk/*
RUN /bin/bash

SHELL ["/bin/bash", "-lc"]
CMD ["/bin/bash", "-l"]

# OS Dependencies 
RUN apk update \
  && apk add alpine-sdk gcc gnupg curl ruby procps musl-dev make linux-headers \
        zlib zlib-dev openssl openssl-dev libssl1.0 shadow openssh-client

USER rvm

# Install RVM
RUN gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
  && curl -sSL https://get.rvm.io | bash -s stable
RUN source /home/$RVM_USER/.rvm/scripts/rvm
RUN yes | rvm requirements

# Install ruby
RUN yes | yes | rvm install 2.6.3
RUN rvm use 2.6.3 --default

USER root
RUN apk del gcc gnupg curl ruby musl-dev make linux-headers \
  && rm -rf /var/cache/apk/*

USER rvm

WORKDIR /home/$RVM_USER