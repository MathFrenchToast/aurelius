# Aurelius - SpecMethodDevLite

A light, IA-native development methodology for Gemini CLI and Claude Code.
Based on the **Kanban-as-Code** principle and split contexts.

## Installation / Update

To initialize a new project or update the methodology in an existing one:

1.  **Clone or Pull this repository** to your local machine (e.g., in `~/dev/aurelius`).
2.  **Run the initializer** pointing to your target project directory:

```bash
./init-or-update-project.sh ../path-to-my-project
```

This script will:
*   Install/Update `.gemini/` skills and namespaced commands (`/aurelius:...`).
*   Setup the `specs/` and `backlog/` folder structure.
*   Initialize template files if they don't already exist.

## Interactive vs. Auto Mode

The **Product Manager** and **Product Owner** roles support two modes of operation:

*   **Interactive Mode (Default):** The agent will pause and ask for clarification if a requirement is ambiguous, if business rules are missing, or if multiple architectural paths are possible. This ensures 100% alignment with your vision.
*   **Auto Mode:** By adding the keyword `auto` anywhere in your command arguments, you signal the agent to proceed autonomously.
    *   It will make logical assumptions based on industry best practices.
    *   It will fill in missing details (validation rules, error states) without interrupting.
    *   It will list its assumptions at the start of the output.

**Example:**
`gemini aurelius:gen-tickets "Auth System auto"`

## Self-Guided Workflow

Aurelius agents are "workflow-aware". At the end of each task, the agent will recommend the next logical step to keep the project moving.

```mermaid
graph TD
    User([User Idea]) --> PM[aurelius:bootstrap-specs]
    PM -->|Recommend| Arch_Plan[aurelius:plan]
    PM -->|Recommend| UX[aurelius:design]
    Arch_Plan -->|Recommend| PO[aurelius:gen-tickets]
    UX -->|Recommend| PO
    PO -->|Recommend| Arch_Groom[aurelius:groom-ticket]
    Arch_Groom -->|Status: READY| Dev[aurelius:dev-ticket]
    Dev -->|Status: WIP| Rev[aurelius:finalize-ticket]
    Rev -->|Status: DONE| Next{Backlog empty?}
    Next -->|No| Arch_Groom
    Next -->|Yes| Arch_Plan
```

## Workflow Summary

1.  **Init/Update:** `./init-or-update-project.sh <target>`
2.  **Bootstrap:** `gemini aurelius:bootstrap-specs "Description auto"`
3.  **Design (Optional):** `gemini aurelius:design "global auto"`
4.  **Plan:** `gemini aurelius:plan "Your request auto"`
5.  **Tickets:** `gemini aurelius:gen-tickets "Epic Name auto"`
6.  **Grooming:** `gemini aurelius:groom-ticket US-01-EPIC-001`
7.  **Dev:** `gemini aurelius:dev-ticket US-01-EPIC-001`
8.  **Finalize:** `gemini aurelius:finalize-ticket`

See `SpecMethodDevLite.md` for the full technical documentation.

if lost: 
/aurelius:plan "Explain where we are in this project"   



## references
- [gemini cli custom commands](https://geminicli.com/docs/cli/custom-commands/)
- [gemini cli settings](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/settings.md)