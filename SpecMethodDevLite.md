# **Spécification Technique : Méthode de Développement IA "Lite"**

## **1. Vision et Philosophie**

Cette méthode est une adaptation simplifiée de BMAD (**Build More, Architect Dreams**), conçue pour être **agnostique** (elle est pour l'instant instantiée pour Gemini Cli) et **native** (sans dépendance Node.js/Python externe).
Elle supporte le cycle de vie complet du logiciel :

1.  **Greenfield :** Création depuis zéro (Vision -> Specs -> Code).
2.  **Brownfield / Maintenance :** Évolution et Hotfix (Code -> Specs -> Code).

Le principe clé est le **"Kanban-as-Code"** : l'état du projet est déterminé par l'emplacement et le contenu de fichiers Markdown (User Stories) dans le dépôt Git.

## **2. Architecture du Projet (File System)**

Tout projet utilisant la méthode Lite respectera cette structure :
.
├── .gemini/                # Configuration de l'IA (ou .claude/)
│   ├── commands/           # Les verbes (Actions TOML numérotées)
│   └── skills/             # Les rôles (Prompts Système MD)
├── specs/                  # La "Vérité" (Living Documentation)
│   ├── productContext.md   # **Cerveau** : Vision globale et Architecture de haut niveau (System Prompt)
│   ├── context-map.md      # **Carte** : Index technique mapping Features -> Fichiers physiques
│   ├── 00-BRIEF.md         # Vision produit et cibles
│   ├── 01-PRD.md           # Règles métier détaillées (Functional Specs)
│   ├── 02-UX-DESIGN.md     # Description textuelle des écrans/flux
│   ├── 03-ARCHITECTURE.md  # Choix techniques, DB Schema, Conventions détaillées
│   ├── 04-EPICS.md         # Table des matières des fonctionnalités
│   └── diagrams/           # (Optionnel) Fichiers Excalidraw/Mermaid
├── backlog/                # Le Flux de travail
│   ├── TODO/               # Tickets prêts à être traités
│   ├── WIP/                # Tickets en cours d'implémentation
│   └── DONE/               # Tickets terminés (Archives)
├── src/                    # Le Code Source
└── tests/                  # Les Tests Automatisés

## **3. Les Rôles (Skills)**

*Ces fichiers sont stockés dans .gemini/skills/ au format Markdown.*

| **Fichier Skill** | **Rôle & Responsabilités** |
| :--- | :--- |
| **product-manager.md** | **Discovery & Definition.** Transforme une idée brute ou un prompt en documents structurés (Brief, PRD, Product Context). Initialise le projet. |
| **product-owner.md** | **Backlog Management.** Découpe les Epics en User Stories unitaires (INVEST). Gère la priorité. |
| **architect.md** | **Tech Keeper.** Gardien de `specs/context-map.md` (La Carte) et `specs/03-ARCHITECTURE.md`. Vérifie la cohérence technique. |
| **designer.md** | **UX/UI.** Traduit le fonctionnel en parcours écrans textuels (`specs/02-UX-DESIGN.md`). |
| **developer.md** | **Builder.** Codeur TDD. Lit `productContext.md` pour le sens et `context-map.md` pour le chemin. Ne code que le ticket actif. |
| **reviewer.md** | **Gatekeeper.** Vérifie le code vs Specs, passe les tests, et valide le "DONE". |

## **4. Les Commandes (Workflows)**

*Ces commandes sont implémentées en TOML pour Gemini CLI.*

### **A. Phase d'Initialisation & Update**

0.  **Installation/Update via Shell Script**
    *   *Action:* Exécuter `./init-or-update-project.sh <target-dir>` depuis le repo Aurelius.
    *   *Effet:* Synchronise les skills, commandes et templates dans le projet cible.

1.  *(Supprimé - Remplacé par le script shell)*
2.  **2-bootstrap-specs**
    *   *Skill:* Product Manager
    *   *Input:* Idée brute (Concept).
    *   *Action:* Remplit `productContext.md` (Vision), `00-BRIEF.md` et `01-PRD.md` initiaux.

### **B. Cycle de Planification (Specs & Backlog)**

3.  **3-plan-feature** (Mode Évolution)
    *   *Skill:* Architect
    *   *Input:* Demande utilisateur.
    *   *Action:* Met à jour la documentation (`PRD`, `Architecture`) et surtout la **`context-map.md`** pour préparer le terrain technique.
4.  **4-gen-tickets**
    *   *Skill:* Product Owner
    *   *Input:* `01-PRD.md` + `04-EPICS.md`.
    *   *Action:* Génère des fichiers User Story unitaires dans `backlog/TODO/`.

### **C. Cycle de Réalisation (Dev)**

5.  **5-dev-task**
    *   *Skill:* Developer (Mode TDD)
    *   *Input:* Un ticket dans `TODO`.
    *   *Action:* Déplace en `WIP`, lit `productContext.md` et `context-map.md`, implémente (Test -> Code -> Refactor).
6.  **6-finalize**
    *   *Skill:* Reviewer
    *   *Action:* Vérifie le travail (WIP), lance les tests, commit, et déplace dans `DONE`.

### **D. Maintenance Urgente**

9.  **9-hotfix**
    *   *Skill:* Developer (Mode Senior)
    *   *Input:* Bug critique.
    *   *Contrainte:* Bypass le cycle complet mais lit `context-map.md` pour éviter les dégâts collatéraux.

## **5. Détails des Templates Clés**

### **Product Context (`specs/productContext.md`)**
*Inspiré de Roo Code.*
C'est le "System Prompt" du projet. Il permet de redonner du contexte métier et produit sur chaque tâche. Il contient :
1.  Identité du Projet (Valeur, Cible).
2.  Architecture Haut Niveau (Stack, Patterns).
3.  Flux Métier Core (Les 3-4 parcours critiques).

### **Context Map (`specs/context-map.md`)**
*Inspiré de Aider.*
C'est l'index technique dynamique maintenu par l'Architecte, le but est d'éviter que chaque developpeur ne consulte toute la base de code
*   **Format :** Table mapping Feature -> Liste de fichiers/dossiers.
*   **But :** Permettre à l'IA de trouver `src/auth/login.ts` en cherchant "Auth" sans scanner tout le disque.

### **Template User Story (`backlog/template-us.md`)**
Chaque ticket inclut :
```markdown
# Context Map
> Reference @specs/context-map.md to find file paths.
```
