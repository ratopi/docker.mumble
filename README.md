# Mumble-Server in Docker

A simple Dockerfile to run a mumble server (murmur) in a docker container.

Just start it by

	docker-compose up

Before first start you have to create the volume for holding the config file and database:

	docker volume create mumble_conf

Have fun
