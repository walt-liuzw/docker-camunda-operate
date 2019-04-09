# Camunda Operate Docker Image

## Legal Notice

This Operate Trial Version is for testing and non-production use only.
The General Terms and Conditions for the Operate Trial Version are available here: https://zeebe.io/legal/operate-evaluation-license/

## Login

To login into operate use the credentials:

- User: demo
- Password: demo

## Getting started

To get started with Zeebe and Camunda Operate follow the getting started guide
in the documentation: https://docs.zeebe.io/getting-started/README.html

## Run Operate

To configure operate mount a custom `application.yml` to the location
`/usr/local/operate/config/application.yml` inside the container.

```
docker run -d --name operate -v $PWD/application.yml:/usr/local/operate/config/application.yml camunda/operate:latest
```

Or set environment variables on startup, the most important ones are:
- `CAMUNDA_OPERATE_ELASTICSEARCH_HOST`: the Elasticsearch host for the Operate indices
- `CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_HOST`: the Elasticsearch host for the Zeebe exporter indices
- `CAMUNDA_OPERATE_ZEEBE_BROKERCONTACTPOINT`: the Zeebe gateway contact point

The following represents the default configuration:

```
# Operate configuration file

camunda.operate:
  # ELS instance to store Operate data
  elasticsearch:
    # Cluster name
    clusterName: elasticsearch
    # Host
    host: localhost
    # Transport port
    port: 9200
  # Zeebe instance
  zeebe:
    # Broker contact point
    brokerContactPoint: localhost:26500
  # ELS instance to export Zeebe data to
  zeebeElasticsearch:
    # Cluster name
    clusterName: elasticsearch
    # Host
    host: localhost
    # Transport port
    port: 9200
    # Index prefix, configured in Zeebe Elasticsearch exporter
    prefix: zeebe-record
logging:
  level:
    ROOT: INFO
    org.camunda.operate: DEBUG

#Spring Boot Actuator endpoints to be exposed
management.endpoints.web.exposure.include: health,info,conditions,configprops,prometheus
```
