FROM ubuntu:24.04
ARG MY_UID=1000
ARG MY_GID=1000

# Installation des outils de base
RUN apt-get update && apt-get install -y \
    curl git python3 nodejs npm sudo \
    && rm -rf /var/lib/apt/lists/*

# Création de l'utilisateur pour correspondre à l'hôte
RUN groupadd -g $MY_GID agentgroup && \
    useradd -u $MY_UID -g agentgroup -m agent && \
    echo "agent ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Installation des CLI (Exemple pour Gemini ou Claude Code)
RUN npm install -g @anthropic-ai/claude-code @google/gemini-cli

USER agent