FROM alpine:3.8 as build
LABEL maintainer="Mario Siegenthaler <mario.siegenthaler@linkyard.ch>"

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v2.13.0
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=15eca6ad225a8279de80c7ced42305e24bc5ac60bb7d96f2d2fa4af86e02c794

WORKDIR /

RUN apk add --update -t deps curl tar gzip
RUN curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}


# The image we keep
FROM alpine:3.8

RUN apk add --update --no-cache git ca-certificates

COPY --from=build /tmp/linux-amd64/helm /bin/helm

ENTRYPOINT ["/bin/helm"]
