# Aurelius - SpecMethodDevLite

A light, IA-native development methodology for Gemini CLI and Claude Code.
Based on the **Kanban-as-Code** principle and split contexts.
see [full spec here](./SpecMethodDevLite.md)


## Installation / Update

To initialize a new project or update the methodology in an existing one:

1.  **Clone or Pull this repository** to your local machine (e.g., in `~/dev/aurelius`).
2.  **Run the initializer** pointing to your target project directory:

```bash
./init-or-update-project.sh ../path-to-my-project
```

This script will:
*   Install/Update `.gemini/` skills and commands.
*   Setup the `specs/` and `backlog/` folder structure.
*   Initialize template files if they don't already exist.

## Workflow Summary

1.  **Init/Update:** `./init-or-update-project.sh <target>`
2.  **Bootstrap:** `gemini 2-bootstrap-specs --concept "Description..."`
3.  **Plan:** `gemini 3-plan-feature --request "Add Auth"`
4.  **Tickets:** `gemini 4-gen-tickets`
5.  **Dev:** `gemini 5-dev-task --ticket_path backlog/TODO/US-xxx.md`
6.  **Finalize:** `gemini 6-finalize`

