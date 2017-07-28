FROM alpine:3.6
MAINTAINER Mario Siegenthaler <mario.siegenthaler@linkyard.ch>

RUN apk add --update --no-cache ca-certificates git

ENV VERSION v2.5.1
ENV FILENAME helm-${VERSION}-linux-amd64.tar.gz

WORKDIR /

RUN apk add --update -t deps curl tar gzip \
  && curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} | tar zxv -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm \
  && apk del --purge deps curl tar gzip \
  && rm -rf /tmp

ENTRYPOINT ["/bin/helm"]
