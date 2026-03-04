#!/bin/sh
mkdir -p /home/claude/.claude
[ -f /home/claude/.claude.json ] || echo '{}' > /home/claude/.claude.json

if [ "$YOLO" = "1" ]; then
    exec claude --dangerously-skip-permissions "$@"
else
    exec claude "$@"
fi
