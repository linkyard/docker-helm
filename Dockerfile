FROM alpine:3.10 as build
LABEL maintainer="Mario Siegenthaler <mario.siegenthaler@linkyard.ch>"

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v2.15.2
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=a9d2db920bd4b3d824729bbe1ff3fa57ad27760487581af6e5d3156d1b3c2511

WORKDIR /

RUN apk add --update -t deps curl tar gzip
RUN curl -L https://get.helm.sh/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}


# The image we keep
FROM alpine:3.8

RUN apk add --update --no-cache git ca-certificates

COPY --from=build /tmp/linux-amd64/helm /bin/helm

ENTRYPOINT ["/bin/helm"]
