FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.1
RUN elasticsearch-plugin install analysis-icu
RUN elasticsearch-plugin install analysis-kuromoji

USER root
RUN echo vm.max_map_count=262144 > /etc/sysctl.d/max_map_count.conf
