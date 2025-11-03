.DEFAULT_GOAL := help

#help:  @ List available tasks on this project
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#pull_jec: @ Pull JEC base repo from Opsgenie
pull_jec:
	git clone https://github.com/atlassian/jec
