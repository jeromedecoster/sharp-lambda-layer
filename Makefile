help:
	grep --extended-regexp '^[a-zA-Z]+:.*#[[:space:]].*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN { FS = ":.*#[[:space:]]*" } { printf "\033[1;32m%-8s\033[0m%s\n", $$1, $$2 }'

setup: # docker pull lambci/lambda-base-2:build
	echo "\033[1;4;32mdocker pull\033[0m \033[1;33mlambci/lambda-base-2:build\033[0m"
	docker pull lambci/lambda-base-2:build

build: # build sharp lambda layer with node LTS
	echo "\033[1;4;32mdocker run\033[0m \033[1;33mlambci/lambda-base-2:build entrypoint.sh\033[0m"
	docker run \
		--interactive \
		--tty \
		--rm \
		--volume $(PWD):/var/task \
		--env "HOST_USER=$(shell whoami)" \
		--entrypoint /bin/bash \
		--workdir /tmp \
		lambci/lambda-base-2:build \
		/var/task/entrypoint.sh

.SILENT: 