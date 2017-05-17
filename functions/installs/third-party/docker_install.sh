#!/bin/bash

# Docker
function docker_install {
	sudo usermod -aG docker $(whoami)
	sudo systemctl enable docker
}
