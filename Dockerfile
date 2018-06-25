FROM alpine:3.7 as build
MAINTAINER Mario Siegenthaler <mario.siegenthaler@linkyard.ch>

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v2.9.1
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=56ae2d5d08c68d6e7400d462d6ed10c929effac929fedce18d2636a9b4e166ba

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
