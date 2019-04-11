# Prepare Operate Distribution
FROM alpine:3.9.2 as prepare

ARG ZEEBE_VERSION=0.17.0
ARG OPERATE_VERSION=1.0.0-RC2

WORKDIR /tmp/operate

# download operate
RUN wget -O - https://github.com/zeebe-io/zeebe/releases/download/${ZEEBE_VERSION}/camunda-operate-${OPERATE_VERSION}.tar.gz | tar xzvf -
COPY notice.txt notice.txt
RUN sed -i '/^exec /i cat /usr/local/operate/notice.txt' bin/operate

# delete elastic search distro
RUN rm -rf server


# Operate Image
FROM openjdk:8u212-jre

EXPOSE 8080

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /bin/tini

RUN chmod +x /bin/tini

WORKDIR /usr/local/operate

COPY --from=prepare /tmp/operate /usr/local/operate

ENTRYPOINT ["/bin/tini", "--", "/usr/local/operate/bin/operate"]
