# **Spécification Technique : Méthode de Développement IA "Lite" (Aurelius)**

## **1. Vision et Philosophie**

Cette méthode est une adaptation simplifiée de BMAD (**Build More, Architect Dreams**), conçue pour être **agnostique** (Gemini CLI / Claude Code) et **native**. Elle repose sur trois piliers :

1.  **Kanban-as-Code :** L'état du projet est dicté par des fichiers Markdown dans `backlog/`.
2.  **Contextes Segmentés :** Séparation entre Vision (`productContext.md`), Carte Technique (`context-map.md`) et Spécifications (`PRD`, `Architecture`).
3.  **Minimalisme (KISS) :** Priorité à la solution la plus simple. Refus catégorique du sur-engineering et de l'optimisation prématurée.

## **2. Architecture du Projet (File System)**

.
├── .gemini/
│   ├── commands/aurelius/  # Workflows (bootstrap, plan, dev, finalize...)
│   ├── skills/             # Personas (pm, po, arch, dev, reviewer, designer)
│   └── policies/           # Auto-approbation des outils (Policies TOML)
├── specs/                  # La Vérité (Documentation vivante)
│   ├── productContext.md   # Vision haute et Tech Stack (System Prompt)
│   ├── context-map.md      # Index technique (Feature -> Fichiers)
│   ├── 00-BRIEF.md         # Objectifs et cibles
│   ├── 01-PRD.md           # Règles métier
│   ├── 02-UX-DESIGN.md     # Design textuel et flux écrans
│   ├── 03-ARCHITECTURE.md  # Patterns, Standards (KISS, Clean Code)
│   └── 04-EPICS.md         # Roadmap des grandes fonctionnalités
├── backlog/                # TODO, WIP, DONE
└── templates/              # Squelettes pour l'initialisation

## **3. Les Rôles (Skills)**

*   **Product Manager :** Discovery, bootstrapping des specs et de l'architecture initiale.
*   **Product Owner :** Découpage des Epics en User Stories (INVEST) avec critères d'acceptation testables (Given/When/Then).
*   **Architecte :** Gardien de la cohérence technique, de la `context-map.md` et du grooming des tickets. Détecte l'impact UI.
*   **Designer UX :** Définit les parcours et l'interface de manière textuelle.
*   **Developer :** Implémente via TDD. Applique KISS et Clean Code. Gère le passage en `WIP`.
*   **Reviewer :** Vérifie la qualité, la modernité et archive vers `DONE`.

## **4. Workflows (Namespace `aurelius:`)**

### **A. Initialisation**
*   **Setup :** `./init-or-update-project.sh <target>` (Installe les dossiers, les skills et les policies).
*   **aurelius:bootstrap-specs :** Initialise tous les documents de `specs/` à partir d'une idée.

### **B. Planification & Design**
*   **aurelius:design :** (Optionnel) Définit l'UX globale ou spécifique à un ticket.
*   **aurelius:plan :** Point d'entrée unique pour toute modification (Feature, Refacto, Infra). Met à jour les specs et crée les Epics.
*   **aurelius:gen-tickets :** Découpe un Epic spécifique en User Stories dans `backlog/TODO/`.
*   **aurelius:groom-ticket :** Prépare un ticket (Notes techniques + Context Map) et le passe à `READY`.

### **C. Réalisation & Qualité**
*   **aurelius:dev-ticket :** Implémente (TDD). Déplace vers `WIP`. **Interdiction de déplacer vers DONE.**
*   **aurelius:finalize-ticket :** Review technique, Commit conventionnel et archivage vers `DONE`.
*   **aurelius:hotfix :** Correction urgente, bypass les specs mais respecte l'architecture.

### **D. Modes de fonctionnement**
*   **Mode Interactif (Par défaut) :** L'agent pose des questions en cas d'ambiguïté.
*   **Mode Auto :** En ajoutant `auto` dans les arguments, l'agent prend des décisions basées sur les meilleures pratiques et liste ses hypothèses.

## **5. Hygiène et Performance**

1.  **Clear Context :** Recommandé entre chaque changement de rôle pour éviter la pollution de mémoire.
2.  **Policies d'Approbation :** Utilisation de `.gemini/policies/aurelius-tools.toml` pour autoriser automatiquement les outils de base (`ls`, `mv`, `mkdir`, `npm test`, etc.) et maintenir la fluidité malgré les resets de contexte.
