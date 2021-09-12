FROM ubuntu:20.10

ARG USERNAME=dev

RUN apt-get update -y && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl && rm -rf /var/lib/apt/lists/*

RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] http://packages.cloud.google.com/apt/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update -y && apt-get install -y \
    curl \
    git \
    httpie \
    jq \
    kubectl \
    netcat \
    wget \
    zsh \
    && rm -rf /var/lib/apt/lists/*

RUN useradd \
    -m -d /home/${USERNAME} \
    -s /bin/zsh \
    ${USERNAME}

USER ${USERNAME}

RUN mkdir -p ~/.ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

WORKDIR /home/${USERNAME}

COPY dotfiles/zshrc .zshrc
COPY dotfiles/p10k.zsh .p10k.zsh
COPY dotfiles/gitconfig .gitconfig

CMD ["/bin/zsh"]