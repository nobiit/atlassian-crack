ARG VERSION
FROM atlassian/confluence:${VERSION}

FROM krakatau

RUN apt-get -qq update && \
    apt-get -qq install openssl bsdmainutils jq

COPY --from=0 /opt/atlassian/ /opt/atlassian/
COPY docker-init.sh /usr/local/bin/
COPY replaces.json /
RUN docker-init.sh /opt/atlassian /replaces.json

ARG VERSION
FROM atlassian/confluence:${VERSION}
COPY --from=1 /opt/atlassian/ /opt/atlassian/
