.DEFAULT_GOAL := help

#help:  @ List available tasks on this project
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

## Variables
HASH := $(shell git rev-parse --short HEAD | tr -d '\n')

#local-dev: @ pull in secrets from bke-vo-secrets repo
local-dev:
	git clone git@github.com:BrownUniversity/bke-vo-secrets.git 
	cd bke-vo-secrets && make secrets
	mkdir robot
	cp ./bke-vo-secrets/robot/bke-vo-auto*.txt ./robot

#clean: @ remove local secrets and jec code
clean:
	rm -rf ./jec
	rm -rf ./bke-vo-secrets
	rm -rf ./robot

#pull_jec: @ Pull JEC base repo from Opsgenie
pull_jec:
	git clone https://github.com/atlassian/jec

#build: @ Build JEC base image
build:  pull_jec
	docker build --load ./jec -f ./Dockerfile \
	-t harbor.cis-qas.brown.edu/library/jec:$(HASH) \
	-t harbor.cis-qas.brown.edu/library/jec:latest \
	-t harbor.services.brown.edu/library/jec:$(HASH) \
	-t harbor.services.brown.edu/library/jec:latest \
	-t harbordr.services.brown.edu/library/jec:$(HASH) \
	-t harbordr.services.brown.edu/library/jec:latest

#push_qa: @ Push image to QA Harbor
push_qa:
	cat robot/bke-vo-auto_qa.txt | docker login -u 'bke-vo-auto' --password-stdin harbor.cis-qas.brown.edu
	docker push harbor.cis-qas.brown.edu/library/jec:$(HASH)
	docker push harbor.cis-qas.brown.edu/library/jec:latest

#push_prod: @ Push image to Prod Harbor
push_prod:
	cat robot/bke-vo-auto_prod.txt | docker login -u 'bke-vo-auto' --password-stdin harbor.services.brown.edu
	docker push harbor.services.brown.edu/library/jec:$(HASH)
	docker push harbor.services.brown.edu/library/jec:latest

#push_dr: @ Push image to DR Harbor
push_dr:
	cat robot/bke-vo-auto_dr.txt | docker login -u 'bke-vo-auto' --password-stdin harbordr.services.brown.edu
	docker push harbordr.services.brown.edu/library/jec:$(HASH)
	docker push harbordr.services.brown.edu/library/jec:latest
