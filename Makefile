DOCKER = docker

label = 'dummy'
tag = 'gongzhitaao:v1'

host_user = $(shell whoami)
host_uid = $(shell id -u ${user})
host_gid = $(shell id -g ${user})
docker_user = dev

all : debug

build :
	$(DOCKER) build \
		--build-arg docker_gid=${host_gid} \
		--build-arg docker_uid=${host_uid} \
		--build-arg docker_user=${docker_user} \
		--file Dockerfile \
		--label ${label} \
		--rm \
		--tag ${tag} \
		.

debug :
	@echo "User: ${host_user}"
	@echo "UID: ${host_uid}"
	@echo "GID: ${host_gid}"

.PHONY : all build tmp
