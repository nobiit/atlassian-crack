FROM atlassian/jira-software

FROM harbor.nobidev.com/library/krakatau

RUN apt-get -qq update && \
    apt-get -qq install openssl bsdmainutils

COPY --from=0 /opt/atlassian/ /opt/atlassian/
COPY dump.sh /usr/local/bin/
