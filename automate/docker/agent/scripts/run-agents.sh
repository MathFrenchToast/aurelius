#!/bin/bash
# Usage: ./run-agent.sh "Le prompt" "claude|gemini"

PROMPT=$1
TOOL=${2:-claude}

echo "[$(date)] Exécution avec $TOOL" >> /workspace/agent_log.txt

if [ "$TOOL" == "claude" ]; then
    # --dangerously-skip-permissions est nécessaire pour le yolo-mode automatique
    claude -p "$PROMPT" --dangerously-skip-permissions
else
    gemini --yolo "$PROMPT"
fi