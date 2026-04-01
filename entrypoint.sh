#!/bin/sh
mkdir -p /home/claude/.claude
[ -f /home/claude/.claude.json ] || echo '{}' > /home/claude/.claude.json

[ -n "$GIT_USER_EMAIL" ] && git config --global user.email "$GIT_USER_EMAIL"
[ -n "$GIT_USER_NAME" ] && git config --global user.name "$GIT_USER_NAME"

if [ "$YOLO" = "1" ]; then
    exec claude --dangerously-skip-permissions "$@"
else
    exec claude "$@"
fi
