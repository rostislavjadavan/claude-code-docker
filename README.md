# Claude Code Docker

Run multiple Claude Code accounts simultaneously on macOS.

macOS Claude Code stores auth in the system Keychain, so only one account can be logged in at a time. Running Claude Code in Docker gives each container its own isolated filesystem — point each container at a different config directory to run multiple accounts simultaneously.

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
  local profile="personal"
  docker run -it --rm \
    -e YOLO=0 \
    -v "$HOME/.claude-${profile}-docker:/home/claude/.claude" \
    -v "$HOME/.claude-${profile}-docker.json:/home/claude/.claude.json" \
    -v "$(pwd):/workspace" \
    claude-code-docker:latest "$@"
}

# Work account
claude-work() {
  local profile="work"
  docker run -it --rm \
    -e YOLO=0 \
    -v "$HOME/.claude-${profile}-docker:/home/claude/.claude" \
    -v "$HOME/.claude-${profile}-docker.json:/home/claude/.claude.json" \
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
