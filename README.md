# docker-devbox

[![Docker](https://github.com/bwilczynski/docker-devbox/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/bwilczynski/docker-devbox/actions/workflows/docker-publish.yml)

Disposable, dockerized Linux development environment (for MacOS) with various tools that I use regularly for development. Still work in progress.

## Installation

You need [Docker for Mac](https://docs.docker.com/desktop/mac/install/) in order to run it.
Add the following to your ~/.zshrc on a Mac:

```sh
DEVBOX_DOCKER_IMAGE=ghcr.io/bwilczynski/devbox:main
DEVBOX_HOME=/root
TZ=Europe/Warsaw

devbox() {
  cmd=$*

  docker run --pull always \
    -it --rm \
    -e TZ=$TZ \
    -v $HOME/.devbox_history:$DEVBOX_HOME/.zsh_history \
    -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
    -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.kube:$DEVBOX_HOME/.kube \
    -v $HOME/.config/git:$DEVBOX_HOME/.config/git \
    -v $PWD:$DEVBOX_HOME/shared \
    -w $DEVBOX_HOME/shared \
    $DEVBOX_DOCKER_IMAGE ${cmd}
}
```

Enjoy!
