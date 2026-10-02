#!/bin/bash

set -e

apt-get update -y

apt-get install -y curl gnupg apt-transport-https

curl -fsSL https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh \
  | bash

apt-get install -y rabbitmq-server

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

rabbitmq-plugins enable rabbitmq_management

rabbitmqctl add_user ${rabbitmq_username} ${rabbitmq_password}

rabbitmqctl set_user_tags ${rabbitmq_username} administrator

rabbitmqctl set_permissions -p / ${rabbitmq_username} ".*" ".*" ".*"

systemctl restart rabbitmq-server

echo "RabbitMQ installation completed" > /tmp/rabbitmq-install.log

systemctl status rabbitmq-server --no-pager >> /tmp/rabbitmq-install.log 2>&1
