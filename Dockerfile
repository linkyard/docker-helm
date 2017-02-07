FROM alpine:3.5
MAINTAINER Mario Siegenthaler <mario.siegenthaler@linkyard.ch>

RUN apk add --update --no-cache ca-certificates git

ENV VERSION v2.1.3
ENV FILENAME helm-${VERSION}-linux-amd64.tar.gz

WORKDIR /

ADD http://storage.googleapis.com/kubernetes-helm/${FILENAME} /tmp

RUN tar -zxvf /tmp/${FILENAME} -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm \
  && rm -rf /tmp

ENTRYPOINT ["/bin/helm"]
