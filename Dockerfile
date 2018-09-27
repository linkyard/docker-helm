FROM alpine:3.7 as build
MAINTAINER Mario Siegenthaler <mario.siegenthaler@linkyard.ch>

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v2.11.0
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=02a4751586d6a80f6848b58e7f6bd6c973ffffadc52b4c06652db7def02773a1

WORKDIR /

RUN apk add --update -t deps curl tar gzip
RUN curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}

# The image we keep
FROM alpine:3.7

RUN apk add --update --no-cache git ca-certificates

COPY --from=build /tmp/linux-amd64/helm /bin/helm

ENTRYPOINT ["/bin/helm"]
