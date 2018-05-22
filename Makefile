.PHONY: test build

include .env

build:
	docker build -t veltra/elasticsearch .

test: build
	docker run -p 9200:9200 -e "discovery.type=single-node" -d --name elasticsearch veltra/elasticsearch; sleep 20
	docker run --network container:elasticsearch appropriate/curl --retry 10 --retry-connrefused -u $(ELASTICSEARCH_USERNAME):$(ELASTICSEARCH_PASSWORD) http://localhost:9200
