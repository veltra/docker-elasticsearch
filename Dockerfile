FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.0
RUN elasticsearch-plugin install analysis-icu
RUN elasticsearch-plugin install analysis-kuromoji
