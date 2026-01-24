# **Spécification Technique : Méthode de Développement IA "Lite"**

## **1. Vision et Philosophie**

Cette méthode est une adaptation simplifiée de BMAD (**Build More, Architect Dreams**), conçue pour être **agnostique** (compatible Gemini CLI / Claude Code) et **native** (sans dépendance Node.js/Python externe).
Elle supporte le cycle de vie complet du logiciel :

1.  **Greenfield :** Création depuis zéro (Vision -> Specs -> Code).
2.  **Brownfield / Maintenance :** Évolution et Hotfix (Code -> Specs -> Code).

Le principe clé est le **"Kanban-as-Code"** : l'état du projet est déterminé par l'emplacement et le contenu de fichiers Markdown (User Stories) dans le dépôt Git.

## **2. Architecture du Projet (File System)**

Tout projet utilisant la méthode Lite respectera cette structure :
.
├── .gemini/                # Configuration de l'IA
│   ├── commands/
│   │   └── aurelius/       # Les verbes (Namespaced Actions TOML)
│   └── skills/             # Les rôles (Prompts Système MD)
├── specs/                  # La "Vérité" (Living Documentation)
│   ├── productContext.md   # **Cerveau** : Vision globale et Architecture (System Prompt)
│   ├── context-map.md      # **Carte** : Index technique mapping Features -> Fichiers
│   ├── 01-PRD.md           # Règles métier détaillées
│   ├── 03-ARCHITECTURE.md  # Choix techniques et Conventions
│   └── ...
├── backlog/                # Le Flux de travail (TODO, WIP, DONE)
├── src/                    # Le Code Source
└── tests/                  # Les Tests Automatisés

## **3. Les Commandes (Workflows)**

Les commandes sont regroupées sous le namespace `aurelius:`.

### **A. Phase d'Initialisation & Update**

*   **Setup:** Exécuter `./init-or-update-project.sh <target-dir>` depuis le repo Aurelius.
*   **aurelius:bootstrap-specs**
    *   *Skill:* Product Manager
    *   *Input:* Idée brute (Concept) ou fichier `@spec.md`.
    *   *Action:* Remplit `productContext.md`, `00-BRIEF.md`, `01-PRD.md`, `03-ARCHITECTURE.md` (Standards & Patterns) et `04-EPICS.md`.

### **B. Cycle de Planification**

*   **aurelius:plan**
    *   *Skill:* Architect
    *   *Input:* Demande libre (Feature, Infra, Refacto).
    *   *Action:* Analyse, met à jour les specs (`PRD`, `Architecture`, `context-map`) et crée les Epics.
*   **aurelius:gen-tickets**
    *   *Skill:* Product Owner
    *   *Input:* Nom de l'Epic (ex: "Gestion Profils").
    *   *Action:* Génère les User Stories unitaires dans `backlog/TODO/` pour cet Epic uniquement.
*   **aurelius:groom-ticket**
    *   *Skill:* Architect
    *   *Input:* ID ou chemin du ticket.
    *   *Action:* Prépare techniquement le ticket (Context Map, Notes) et le passe à `READY`.

### **C. Cycle de Réalisation**

*   **aurelius:dev-ticket**
    *   *Skill:* Developer (Mode TDD)
    *   *Action:* Implémente le ticket actif (Move to WIP, Test -> Code -> Refactor).
*   **aurelius:finalize-ticket**
    *   *Skill:* Reviewer
    *   *Action:* Vérifie le travail, commit, et archive (Move to DONE).

### **D. Maintenance Urgente**

*   **aurelius:hotfix**
    *   *Skill:* Developer (Senior)
    *   *Action:* Correction chirurgicale avec test de non-régression.

## **4. Hygiène du Contexte et Autorisations**

Pour maintenir une efficacité maximale, cette méthode recommande :
1.  **Clear Context fréquent** : Nettoyer le contexte entre chaque changement de rôle (ex: après un `plan` et avant un `gen-tickets`).
2.  **Auto-approval** : Configurer le CLI pour autoriser sans confirmation les outils de base (`ls`, `mkdir`, `mv`, `rm`, `touch`, `sed`, `grep`, `npm test`). Cela permet de conserver la fluidité malgré les resets de session.