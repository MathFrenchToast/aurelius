# IA dev env with n8n automation

Usage de docker compose 
avec deux service:
- n8n
- ubuntu + cli calling script


## organisation du projet

faire un git pull dans une VM ou une image WSL isolée du host 

/opt/ai-automation/
├── .env                  # Variables d'environnement (clés API, UID/GID)
├── docker-compose.yml     # Orchestration des services
├── n8n/
│   └── Dockerfile        # Image n8n + Docker CLI
├── agent/
│   ├── Dockerfile        # Image Ubuntu + Outils de dev + Agent IA
│   └── scripts/
│       └── run-agent.sh  # Wrapper pour les appels n8n
└── workspace/            # LE REPO DE CODE (Méthode Aurelius)
    ├── backlog/
    ├── specs/
    └── code/


## usage dans n8n

Dans n8n, pour chaque tâche de codage, tu utiliseras un seul nœud Execute Command.

La commande à configurer :
docker exec ai_agent /workspace/scripts/run-agent.sh "/aurelius:analyze analyse la spec US-04 dans /backlog et génère le code de test" "gemini"