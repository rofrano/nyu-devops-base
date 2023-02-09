# NYU DevOps Base

This repository contains the base Docker image for the NYU DevOps Labs

The image contains the following packages on top of `python:3.9-slim`:

- sudo
- vim
- make
- git
- zip
- tree
- curl
- wget
- jq
- procps
- net-tools
- gcc
- libpq-dev

It also defines the user `vscode` which is needed for VSCode features to work properly
