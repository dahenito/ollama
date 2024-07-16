# syntax=docker/dockerfile:1

ARG VERSION=0.2.5

###
FROM alpine:3.20 AS git-clone
RUN apk add --no-cache bash git

ARG DOCKER_APP_BASE DOCKER_APP_PATH
ARG VERSION
ARG HOSTARCH HOSTOS
ARG USERGID USERHOME USERID USERNAME

WORKDIR /egress/src
# https://github.com/ollama/ollama/blob/main/docs/development.md
RUN git clone https://github.com/ollama/ollama.git /egress/src
RUN git checkout -b v${VERSION} v${VERSION}

#
COPY . /egress/
RUN /egress/env.sh > /egress/source.env && rm -f /egress/env.sh

CMD [ "/bin/ls", "-l", "/egress" ]
