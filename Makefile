NAME = bsmithyman/jupyterhub-uwoseis

.PHONY: all build

all: build

build:
	docker build -t $(NAME) .
