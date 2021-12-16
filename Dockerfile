FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

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

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k

ARG KUBECTX_VERSION=0.9.4

RUN OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/aarch64$/arm64/')" && \
    curl -fsSL "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_${OS}_${ARCH}.tar.gz" | \
    tar xvzC /usr/local/bin kubectx && \
    curl -fsSL "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_${OS}_${ARCH}.tar.gz" | \
    tar xvzC /usr/local/bin kubens

ARG K9S_VERSION=0.24.15

RUN OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/aarch64$/arm64/')" && \
    curl -fsSL "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_${OS}_${ARCH}.tar.gz" | \
    tar xvzC /usr/local/bin k9s

ARG KUSTOMIZE_VERSION=4.4.1

RUN OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/aarch64$/arm64/' | sed -e 's/x86_64$/amd64/')" && \
    curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_${OS}_${ARCH}.tar.gz" | \
    tar xvzC /usr/local/bin kustomize

WORKDIR /root

COPY dotfiles/zshrc .zshrc
COPY dotfiles/p10k.zsh .p10k.zsh
COPY dotfiles/gitconfig .gitconfig

CMD ["/bin/zsh"]