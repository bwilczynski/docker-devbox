FROM ubuntu:20.10

ARG USERNAME=dev

RUN apt update -y && apt install -y \
    curl \
    git \
    httpie \
    jq \
    netcat \
    wget \
    zsh \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/${USERNAME} -s /bin/zsh ${USERNAME}

USER ${USERNAME}

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k && \
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc && \
    echo '[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh' >> ~/.zshrc

COPY p10k.zsh /home/${USERNAME}/.p10k.zsh
COPY gitconfig /home/${USERNAME}/.gitconfig

WORKDIR /home/${USERNAME}
CMD ["/bin/zsh"]