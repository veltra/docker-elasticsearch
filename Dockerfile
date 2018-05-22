FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.4
RUN elasticsearch-plugin install analysis-icu
RUN elasticsearch-plugin install analysis-kuromoji
