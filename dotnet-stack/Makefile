SHELL := /bin/bash

PWD ?= pwd_unknown
PROJECT_NAME = $(notdir ${PWD})

ifeq ($(user),)
HOST_USER ?= $(strip $(if $(USER),$(USER),nodummy))
HOST_UID ?= $(strip $(if $(shell id -u),$(shell id -u),4000))
else
HOST_USER = $(user)
HOST_UID = $(strip $(if $(uid),$(uid),0))
endif

THIS_FILE := $(lastword $(MAKEFILE_LIST))

TARGETSCMDARG = run exec execroot

TARGETS = build rebuild up restart service clean rm log
.PHONY: $(TARGETS) prune

ifneq ($(filter $(word 1,$(MAKECMDGOALS)),$(TARGETS)), )
ENV_FILE=$(word 2,$(MAKECMDGOALS))
ACTION=$(word 1,$(MAKECMDGOALS))
else ifneq ($(filter $(word 2,$(MAKECMDGOALS)),$(TARGETS)), )
ENV_FILE=$(word 1,$(MAKECMDGOALS))
ACTION=$(word 2,$(MAKECMDGOALS))
endif


ifneq ($(filter $(ACTION),$(TARGETS)),)
ifeq ($(ENV_FILE),)
$(error Please defined an env file to use that command)
endif

SERVICE_TARGET := $(word 3,$(MAKECMDGOALS))
$(eval $(SERVICE_TARGET):;@true)

include $(ENV_FILE)

ifeq ($(CODE_PATH),)
$(info $(CODE_PATH))
$(error Your ENV file must have a code path variable CODE_PATH=)
endif

ifeq ($(PROJECT_NAME),)
PROJECT_NAME = $$(dirname $(PROJECT_NAME))
endif

UP_ARG = vscode

ifeq ($(FRONT_JS_FRAMEWORK),1)
UP_ARG += front-dev
WEB_APP=1
endif

ifeq ($(DUMP),)
DUMP=/tmp/dump
else
UP_ARG += database
endif

ifeq ($(USERNAME),)
USERNAME=developer
endif

ifeq ($(PATH_OPEN),)
PATH_OPEN="./"
endif

export

ifneq ($(filter $(ACTION),$(TARGETSCMDARG)),)
CMD_ARGUMENTS := $(word 4,$(MAKECMDGOALS))
$(eval $(CMD_ARGUMENTS):;@true)
endif

STACK_NAME = $(PROJECT_NAME)_$(notdir $(basename $(CODE_PATH)))_$(HOST_UID)

ifeq ($(SERVICE_TARGET),)
SERVICE_TARGET= $(UP_ARG)
endif

endif

define call_docker
	@docker-compose -p $(STACK_NAME) $(1) $(2) $(3)
endef

help:
	@echo ''
	@echo ''
	@echo 'Usage: make ENVFILE ACTION (SERVICE) (CMD)'
	@echo 'ACTION:'
	@echo '  build    	build docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  rebuild  	rebuild docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  up       	up for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  service   	run as service --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  clean    	remove docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  prune    	shortcut for docker system prune -af. Cleanup inactive containers and cache.'
	@echo 'Usage: make TARGET [EXTRA_ARGUMENTS]'
	@echo '  run    	run docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  exec       exec docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  exec       exec docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID)) for user root'
	@echo ''
	@echo 'Extra arguments:'
	@echo 'cmd=:	make cmd="whoami"'
	@echo '# user= and uid= allows to override current user. Might require additional privileges.'
	@echo 'user=:	make shell user=root (no need to set uid=0)'
	@echo 'uid=:	make shell user=dummy uid=4000 (defaults to 0 if user= set)'
	@echo ''


build:
	$(call call_docker,build, $(SERVICE_TARGET))

rebuild:
	$(call call_docker,build --no-cache, $(SERVICE_TARGET))

up: service log

restart: down up

service:
	$(call call_docker,up,$(SERVICE_TARGET))

log:
	$(call call_docker,logs -f, $(SERVICE_TARGET))

down:
	$(call call_docker,down, $(SERVICE_TARGET))

run:
ifeq ($(SERVICE_TARGET),)
	$(error Error no service target define)
endif
	@docker run -it --rm $(STACK_NAME)_$(SERVICE_TARGET) $(CMD_ARGUMENTS)

exec:
ifeq ($(SERVICE_TARGET),)
	$(error Error no service target define)
endif
ifneq ($(CMD_ARGUMENTS),)
	@docker exec -it $(STACK_NAME) $(CMD_ARGUMENTS)
else
	@docker exec -it $(STACK_NAME) sh
endif

execroot:
ifeq ($(SERVICE_TARGET),)
	$(error Error no service target define)
endif
ifneq ($(CMD_ARGUMENTS),)
	@docker exec -u=0 it $(STACK_NAME) $(CMD_ARGUMENTS)
else
	@docker exec -u=0 -it $(STACK_NAME) sh
endif

clean:
# remove created images
	$(call call_docker,down --remove-orphans --rmi,all)

rm: clean

prune:
# clean all that is not actively used
	@docker system prune -af
	@docker volume prune
	@docker network prune
