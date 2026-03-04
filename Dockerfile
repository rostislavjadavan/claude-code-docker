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
