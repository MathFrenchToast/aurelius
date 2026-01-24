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

*   **aurelius:plan-feature**
    *   *Skill:* Architect
    *   *Action:* Met à jour `PRD`, `Architecture` et `context-map.md`.
*   **aurelius:gen-tickets**
    *   *Skill:* Product Owner
    *   *Input:* Nom de l'Epic (ex: "Gestion Profils").
    *   *Action:* Génère les User Stories unitaires dans `backlog/TODO/`.
*   **aurelius:groom-ticket**
    *   *Skill:* Architect
    *   *Input:* Chemin du ticket dans `TODO`.
    *   *Action:* Ajoute les notes techniques, la context-map spécifique et passe le statut à `READY`.

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