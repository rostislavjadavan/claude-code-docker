# Claude Code Docker

Run multiple Claude Code accounts simultaneously on macOS.

## The Problem

On macOS, Claude Code stores authentication in the system Keychain, which is shared across the entire OS. This means you can only be logged in with one account at a time — switching between a personal and a work account requires logging out and back in every time.

## The Solution

Run Claude Code inside Docker containers. Each container gets its own isolated filesystem, bypassing the Keychain entirely. Authentication is stored in a plain directory on your host machine, and you can have as many independent accounts as you need — just point each container at a different config directory.

## Setup

**1. Build the image**

```bash
make build
```

**2. Add shell functions to your `.zshrc` or `.bashrc`**

Create one function per account. Each function maps a different host directory to `/root/.claude` inside the container, keeping credentials fully isolated.

```bash
# Personal account
claude-personal() {
  mkdir -p "$HOME/.claude-personal-docker"
  touch "$HOME/.claude-personal-docker.json"
  docker run -it --rm \
    -e TERM=xterm-256color \
    -v "$HOME/.claude-personal-docker:/root/.claude" \
    -v "$HOME/.claude-personal-docker.json:/root/.claude.json" \
    -v "$(pwd):/workspace" \
    claude-code-docker:latest "$@"
}

# Work account
claude-work() {
  mkdir -p "$HOME/.claude-work-docker"
  touch "$HOME/.claude-work-docker.json"
  docker run -it --rm \
    -e TERM=xterm-256color \
    -v "$HOME/.claude-work-docker:/root/.claude" \
    -v "$HOME/.claude-work-docker.json:/root/.claude.json" \
    -v "$(pwd):/workspace" \
    claude-code-docker:latest "$@"
}
```

**3. Reload your shell**

```bash
source ~/.zshrc
```

## Usage

Navigate to any project directory and run the account you want:

```bash
cd ~/projects/my-personal-project
claude-personal

cd ~/projects/work-project
claude-work
```

Each account logs in independently and stores its credentials in its own directory (`~/.claude-personal-docker` or `~/.claude-work-docker`). After the first login, subsequent runs start immediately without re-authenticating.

## Adding More Accounts

Duplicate any function, give it a new name, and point it at a new directory:

```bash
claude-client-x() {
  mkdir -p "$HOME/.claude-client-x-docker"
  touch "$HOME/.claude-client-x-docker.json"
  docker run -it --rm \
    -e TERM=xterm-256color \
    -v "$HOME/.claude-client-x-docker:/root/.claude" \
    -v "$HOME/.claude-client-x-docker.json:/root/.claude.json" \
    -v "$(pwd):/workspace" \
    claude-code-docker:latest "$@"
}
```
