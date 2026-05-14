# Instructions Générales pour Gemini (Aurelius Method)

Ce fichier définit les standards de qualité et les principes de conception transverses attendus pour **chaque interaction** et **chaque ligne de code** générée dans le cadre de ce projet. Ces règles sont les fondations de la méthode Aurelius et s'appliquent systématiquement.

## 1. Simplicité et Pragmatisme (KISS & YAGNI)
- **KISS (Keep It Simple, Stupid) :** Privilégiez toujours la solution la plus évidente et la plus lisible. La complexité ne doit être introduite que si elle est strictement nécessaire pour répondre au besoin.
- **YAGNI (You Aren't Gonna Need It) :** Ne développez que ce qui est explicitement demandé dans les spécifications (`specs/`) ou les tickets (`backlog/`) actuels. N'anticipez pas de besoins futurs hypothétiques. **Refus catégorique de l'over-engineering**.
  - *Ressource : [YAGNI - Martin Fowler](https://martinfowler.com/bliki/Yagni.html)*

## 2. Architecture et Isolation (Principes SOLID)
- Le code doit s'inscrire dans le respect des **principes SOLID** (Single-Responsibility, Open-Closed, Liskov Substitution, Interface Segregation, Dependency Inversion) afin de garantir une architecture évolutive, avec une forte cohésion et un couplage faible.
- Assurez une **séparation stricte des préoccupations (Separation of Concerns)**. Isolez toujours la logique métier pure des interfaces utilisateur, des bases de données et des appels réseau.
  - *Ressource : [Les principes SOLID - Refactoring Guru](https://refactoring.guru/fr)*

## 3. Approche Moderne, Stable et Agnostique
- **Vérifiez toujours l'approche la plus moderne et fiable** pour résoudre un problème donné. 
- Utilisez systématiquement les versions récentes et **stables** des bibliothèques et frameworks. Évitez les APIs dépréciées.
- Privilégiez des outils et des architectures cloud-agnostiques (ex: Terraform plutôt que des solutions propriétaires) pour éviter tout *vendor lock-in* et maintenir la souveraineté de l'infrastructure.

## 4. Culture des Tests (TDD / BDD)
- **La testabilité n'est pas une option, c'est un pré-requis.** Concevez le code pour qu'il soit testable dès le premier jour (favorisez l'injection de dépendances, les fonctions pures).
- Chaque implémentation de User Story doit être systématiquement couverte par des tests (unitaires/intégration) prouvant que les *Acceptance Criteria* (Given/When/Then) sont remplis avec succès.

## 5. Clean Code et Lisibilité
- Le code est lu beaucoup plus souvent qu'il n'est écrit. 
- Adoptez un nommage intentionnel et explicite pour toutes les variables, classes et méthodes. Bannissez les abréviations cryptiques.
- Gardez des fonctions courtes, avec un seul niveau d'abstraction. Une fonction ne doit avoir qu'une seule raison de changer.
  - *Ressource : [Clean Code - Robert C. Martin (Uncle Bob)](https://blog.cleancoder.com/)*

## 6. Bonnes Pratiques d'Exécution Agentique
- **Privilégier le mode non-interactif :** Dans la mesure du possible, essayez d'anticiper les invites (prompts) du terminal qui pourraient suspendre l'exécution. Il est recommandé d'utiliser les drapeaux non-interactifs (ex: `npm init -y`, `--quiet`, `--force`) pour fluidifier l'autonomie.
- **Attention aux processus bloquants :** Soyez vigilant avec les processus continus au premier plan (serveurs de développement, *watchers*). Si l'environnement le permet, privilégiez leur exécution en arrière-plan, ou bien documentez simplement la commande pour que l'opérateur humain la lance dans un terminal séparé.
- **Gestion de la verbosité :** Gardez à l'esprit les limites de la fenêtre de contexte. Si une commande risque de générer une sortie standard très verbeuse, il est souvent plus judicieux de rediriger les logs vers un fichier dédié (ex: `> app.log`).
---
*Note à l'Agent : Ces directives agissent comme ton filtre de décision global. Avant de valider une proposition technique ou un bloc de code, assure-toi qu'elle ne viole aucune de ces règles fondamentales.*
