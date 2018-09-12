#!/bin/bash

apt-get update

apt-get --assume-yes upgrade

apt-get --assume-yes install openjdk-8-jdk

apt-get --assume-yes install wget curl apt-transport-https software-properties-common

curl -O https://artifacts.elastic.co/GPG-KEY-elasticsearch

apt-key add GPG-KEY-elasticsearch

echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" > /etc/apt/sources.list.d/elastic-6.x.list

apt-get update

apt-get --assume-yes install elasticsearch

sed -i -e 's/\#cluster\.name\:\ my\-application/cluster\.name\:\ ELK\-Demo/g' /etc/elasticsearch/elasticsearch.yml

sed -i -e 's/\#node\.name\:\ node\-1/node\.name\:\ elk-node\-one/g' /etc/elasticsearch/elasticsearch.yml

sed -i -e 's/\#network\.host\:\ 192\.168\.0\.1/network\.host\:\ 0\.0\.0\.0/g' /etc/elasticsearch/elasticsearch.yml

sed -i -e 's/\#http\.port\:\ 9200/http\.port\:\ 9200/g' /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch.service

systemctl restart elasticsearch.service

curl -XPUT -H "Content-Type: application/json" http://127.0.0.1:9200/_template/disablereplication -d '{"template":"*", "order":1, "settings":{"number_of_replicas":0}}'

apt-get --assume-yes install kibana

sed -i -e 's/\#server\.port\:\ 5601/server\.port\:\ 8080/g' /etc/kibana/kibana.yml

sed -i -e 's/\#server\.host\:\ \"localhost\"/server\.host\:\ 0\.0\.0\.0/g' /etc/kibana/kibana.yml

sed -i -e 's/\#server\.name\:\ \"your\-hostname\"/server\.name\:\ \"ELK\-Demo\"/g' /etc/kibana/kibana.yml

sed -i -e 's/\#elasticsearch\.url\:\ \"http\:\/\/localhost\:9200\"/elasticsearch\.url\:\ \"http\:\/\/127\.0\.0\.1\:9200\"/g' /etc/kibana/kibana.yml

systemctl enable kibana.service

systemctl restart kibana.service

apt-get --assume-yes install logstash

systemctl enable logstash.service

systemctl restart logstash.service
