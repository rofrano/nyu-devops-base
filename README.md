# NYU DevOps Base Image

[![Docker Repository on Quay](https://quay.io/repository/rofrano/nyu-devops-base/status "Docker Repository on Quay")](https://quay.io/repository/rofrano/nyu-devops-base)

This repository contains the base Docker image to create a consistent lab environment for the **NYU DevOps and Agile Methodologies CSCI-GA.2820-001** graduate class. It is intended to be used as a base image with [Visual Studio Code](https://code.visualstudio.com) along with the [Dev Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

For more information see the article [Developing inside a Container](https://code.visualstudio.com/docs/devcontainers/containers)

## Image contents

This image contains the following packages on top of python:3.11-slim: `sudo`, `vim`, `make`, `git`, `zip`, `tree`, `curl`, `wget`, `jq`, `procps`, `net-tools`

It also defines the user `vscode` which is needed for VSCode `features` to work properly. The `vscode` user has password-less `sudo` privileges. This teaches developers to not develop as `root` even when in a containerized environment.

## Usage

You can use this image with this starter `devcontainer.json` file:

```json
{
	"name": "NYU DevOps",
	"image": "rofrano/nyu-devops-base:latest"
}
```

This will create a Python 3.11 environment with all of the afore mentioned tools installed. The name will be **NYU DevOps** but you can change it to anything you'd like.

Feel free to add VSCode extensions that you want every developer to have:

```json
{
	"name": "NYU DevOps",
	"image": "rofrano/nyu-devops-base:latest",
	"customizations": {
		"vscode": {
			"extensions": [
				"ms-python.python",
				"ms-python.vscode-pylance",
				"ms-python.pylint"
			]
		}
	}
}
```

## Build instructions

Use `make` to build an push the images to Docker Hub:

```bash
make init
make build
```

`make init` will create a `qemu` builder for `buildx` and set it as the default builder

`make build` will build a multi-platform image for `linux/arm46` & `linux/amd64` and push it to Docker hub

*Note: If you want to push this to your own Docker registry, you will need to define an environment variable called `REGISTRY` and set it to your Docker account registry name*

For example:

```bash
export REGISTRY='my-account'
make build
```

That will tag the Docker image as `my-account/nyu-devops-base:latest` and push it to Docker hub.

If you use a different registry, just include that in the `REGISTRY` environment variable like this:

```bash
export REGISTRY='quay.io/my-account'
make build
```

That will tag the image as `quay.io/my-account/nyu-devops-base:latest` and push it to the Red Hat [Quay.io](https://quay.io/) registry.

## License

Copyright (c) 2020, 2024 [John Rofrano](https://www.linkedin.com/in/JohnRofrano/). All rights reserved.

Licensed under the Apache 2.0 License. See LICENSE

This repo is part of the NYU graduate division class: **CSCI-GA.2820-001 DevOps and Agile Methodologies** conceived, created and taught by [John Rofrano](https://cs.nyu.edu/~rofrano/)
