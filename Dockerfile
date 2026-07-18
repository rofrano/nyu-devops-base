##################################################
# Image for a Python 3 development environment
##################################################
# CSpell: disable
FROM python:3.12-slim

# Add any tools that are needed beyond Python 3.12
RUN apt-get update && apt-get upgrade && \
    apt-get install -y sudo vim git build-essential zip tree curl wget gpg gh jq procps net-tools iputils-ping && \
    apt-get autoremove -y && \
    apt-get clean -y

# Create a user for VSCode development
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user with passwordless sudo privileges
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash && \
    usermod -aG sudo $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME

# Set up the Python development environment
WORKDIR /app
RUN python -m pip install --upgrade pip wheel uv pipenv poetry && \
    poetry config virtualenvs.create false

ENV PORT=8080
EXPOSE $PORT

# Force color terminal for docker exec bash
ENV TERM=xterm-256color

# Become a regular user for development
USER $USERNAME
