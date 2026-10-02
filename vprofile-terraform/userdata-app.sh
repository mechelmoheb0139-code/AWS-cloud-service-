#!/bin/bash

set -e

apt-get update -y

apt-get install -y \
  openjdk-17-jdk \
  wget \
  unzip \
  curl

echo "Java installation completed" > /tmp/app-install.log

java -version >> /tmp/app-install.log 2>&1
