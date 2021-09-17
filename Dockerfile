FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ARG KUBECTX_VERSION=0.9.4

RUN apt-get update -y && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] http://packages.cloud.google.com/apt/ \
    kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null


RUN apt-get update -y && apt-get install -y \
    curl \
    dnsutils \
    docker-ce-cli \
    git \
    httpie \
    jq \
    kubectl \
    netcat \
    sudo \
    wget \
    zsh \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/.ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

RUN export OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    export ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    mkdir -p ~/.kubectx && \
    curl -fsSL "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_${OS}_${ARCH}.tar.gz" | \
    tar xvz -C ~/.kubectx && \
    curl -fsSL "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_${OS}_${ARCH}.tar.gz" | \
    tar xvz -C ~/.kubectx && \
    ln -s ~/.kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s ~/.kubectx/kubens /usr/local/bin/kubens

WORKDIR /root

COPY dotfiles/zshrc .zshrc
COPY dotfiles/p10k.zsh .p10k.zsh
COPY dotfiles/gitconfig .gitconfig

CMD ["/bin/zsh"]