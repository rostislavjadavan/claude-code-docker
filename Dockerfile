FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        git \
        curl \
        ca-certificates \
        ripgrep \
        fd-find \
        jq \
        less \
        gpg \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash claude

USER claude
RUN curl -fsSL https://claude.ai/install.sh | bash \
    && ln -s /usr/bin/fdfind /home/claude/.local/bin/fd

ENV PATH="/home/claude/.local/bin:$PATH"
ENV TERM=xterm-256color

COPY --chown=claude:claude entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
