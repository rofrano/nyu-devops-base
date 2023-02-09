# Image for a Python 3 development environment
FROM python:3.9-slim

# Add any tools that are needed beyond Python 3.9
RUN apt-get update && \
    apt-get install -y sudo vim make git zip tree curl wget jq procps net-tools && \
    apt-get install -y gcc libpq-dev && \
    apt-get autoremove -y && \
    apt-get clean -y

# Create a user for VSCode development
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user with passwordless sudo privileges
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && usermod -aG sudo $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME

# Set up the Python development environment
WORKDIR /app
RUN python -m pip install --upgrade pip && \
    pip install --upgrade wheel

ENV PORT 8080
EXPOSE $PORT

# Force color terminal for docker exec bash
ENV TERM=xterm-256color

# Become a regular user for development
USER $USERNAME
