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
├── backlog/                # TODO (Ready for Dev), WIP (In Progress/Review), DONE
└── templates/              # Squelettes pour l'initialisation

## **3. Les Rôles (Skills)**
...
*   **Reviewer :** Vérifie la qualité, la modernité et archive vers `DONE`. En cas d'échec, passe le ticket en `REWORK` avec feedback détaillé.

## **4. Workflows (Namespace `aurelius:`)**
...
### **C. Réalisation & Qualité**
*   **aurelius:dev-ticket :** Implémente (TDD). Déplace vers `WIP`. **Interdiction de déplacer vers DONE.**
*   **aurelius:finalize-ticket :** Review technique et Commit.
    *   **Succès :** Passage en `DONE` et archivage.
    *   **Échec :** Passage en `REWORK`, ajout des notes de review en fin de fichier US. Le ticket reste dans `WIP`.
*   **aurelius:hotfix :** Correction urgente...

### **D. Modes de fonctionnement**
...

## **6. Cycle de Vie d'un Ticket (Status)**
*   **TODO :** Dans le backlog, en attente.
*   **READY :** Groomé par l'Architecte, prêt pour le Dev.
*   **IN_PROGRESS :** En cours de développement (dans `WIP/`).
*   **REWORK :** Échec de review. Le développeur doit corriger les critères d'acceptation (AT) ou la qualité avant une nouvelle review.
*   **DONE :** Validé et archivé.
