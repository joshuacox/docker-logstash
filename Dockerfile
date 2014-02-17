FROM ubuntu:precise
MAINTAINER P. Barrett Little <barrett@barrettlittle.com>

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US.UTF-8

# Update OS apt sources
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" \
    > /etc/apt/sources.list

# Perform base image updates
RUN apt-get update
RUN apt-get -yq upgrade

# Install dependencies
RUN apt-get install -yq \
    build-essential \
    ca-certificates \
    openjdk-7-jre-headless \
    wget

# Download version 1.3.3 of LogStash
RUN cd /opt && \
    wget https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar && \
    mv ./logstash-1.3.3-flatjar.jar ./logstash.jar

# Copy build files to container root
RUN mkdir /app
ADD . /app

# Elasticsearch
EXPOSE 9200

# Kibana
EXPOSE 9292

# Syslog
EXPOSE 514

# Start LogStash
ENTRYPOINT ["/app/bin/boot"]