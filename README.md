# Aurelius - SpecMethodDevLite

A light, AI-native development methodology for Gemini CLI and Claude Code.
Based on the **Kanban-as-Code** principle and split contexts.

## 1. Vision and Philosophy

This method is an adaptation of BMAD (**Build More, Architect Dreams**), designed to be **agnostic** (Gemini CLI / Claude Code) and **native**. It is based on three pillars:

1.  **Kanban-as-Code:** The project state is dictated by Markdown files in `backlog/`.
2.  **Segmented Contexts:** Separation between Vision (`productContext.md`), Technical Map (`context-map.md`), and Specifications (`PRD`, `Architecture`).
3.  **Kept Simple:** Priority to the simplest solution. Categorical refusal of over-engineering and premature optimization.

## 2. Installation / Update

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

## 3. Project Architecture (File System)

``` 
.
├── .gemini/
│   ├── commands/aurelius/  # Workflows (bootstrap, analyze, dev, finalize...)
│   ├── skills/             # Personas (pm, po, arch, dev, reviewer, designer)
│   └── policies/           # Tool auto-approval (TOML Policies)
├── specs/                  # The Truth (Living Documentation)
│   ├── productContext.md   # High-level Vision and Tech Stack (System Prompt)
│   ├── context-map.md      # Technical Index (Feature -> Files)
│   ├── 00-BRIEF.md         # Objectives and targets
│   ├── 01-PRD.md           # Business rules
│   ├── 02-UX-DESIGN.md     # Textual design and screen flows
│   ├── 03-ARCHITECTURE.md  # Patterns, Standards (KISS, Clean Code)
│   └── 04-EPICS.md         # Roadmap of major features
├── backlog/
│   ├── TODO                # TODO (Ready for grooming or Dev)
│   ├── WIP                 # In Progress or to be Reviewed
│   └── DONE                # Completed US
├── automate/               # Automation and isolation (Docker, VM, WSL, Scripts)
└── templates/              # Skeletons for initialization
```

## 4. Roles (Skills)

*   **Product Manager:** Transforms raw ideas into a structured Product Requirement Document (PRD). Responsible for `specs/01-PRD.md` and identifying missing business rules.
*   **Product Owner:** Transforms the PRD into atomic, testable User Stories (US) in the backlog. Ensures stories have binary and testable Acceptance Criteria (Given/When/Then).
*   **Architect:** Maintains technical coherence. Owns `specs/03-ARCHITECTURE.md` and `specs/context-map.md`. Grooms tickets with technical notes before they reach the developer.
*   **UX/UI Designer:** Translates functional requirements into text-based screen flows and interaction designs in `specs/02-UX-DESIGN.md`.
*   **Developer:** Implements features using TDD and Clean Code principles. Focuses on the simplest solution (KISS). Strictly follows `specs/03-ARCHITECTURE.md`.
*   **Reviewer:** Checks quality, modernity, and compliance with Acceptance Criteria. Responsible for archiving to `DONE` or sending back to `REWORK`.

## 5. Workflow Overview

Aurelius agents are "workflow-aware". At the end of each task, the agent will recommend the next logical step to keep the project moving.

```mermaid
graph TD
    User([User Idea]) --> PM[aurelius:bootstrap-specs]
    PM -->|Recommend| Arch_Analyze[aurelius:analyze]
    PM -->|Recommend| UX[aurelius:design]
    Arch_Analyze -->|Recommend| PO[aurelius:gen-tickets]
    UX -->|Recommend| PO
    PO -->|Recommend| Arch_Groom[aurelius:groom-ticket]
    Arch_Groom -->|Status: READY| Dev[aurelius:dev-ticket]
    Dev -->|Status: WIP| Rev[aurelius:finalize-ticket]
    Rev -->|Status: DONE| Next{Backlog empty?}
    Next -->|No| Arch_Groom
    Next -->|Yes| Arch_Analyze
```

## 6. Detailed Workflows (Namespace `aurelius:`)

1.  **Bootstrap:** `gemini aurelius:bootstrap-specs "Description"`
    *   Initializes project specs (`00-BRIEF`, `01-PRD`, `03-ARCHITECTURE`) from a raw idea.
2.  **Analyze:** `gemini aurelius:analyze "Your request"`
    *   Analyzes the current state and recommends the next strategic move (Design, Tickets, or Code).
3.  **Design (Optional):** `gemini aurelius:design "global"`
    *   Generates text-based UX/UI flows in `specs/02-UX-DESIGN.md`.
4.  **Tickets:** `gemini aurelius:gen-tickets "Epic Name"`
    *   Generates User Stories in `backlog/TODO/` based on the PRD and Epics.
5.  **Grooming:** `gemini aurelius:groom-ticket US-01-EPIC-001`
    *   Architect adds technical notes and checks feasibility. Moves ticket to `READY`.
6.  **Dev:** `gemini aurelius:dev-ticket US-01-EPIC-001`
    *   Developer implements the story (TDD). Moves ticket to `WIP`. **Forbidden to move to DONE.**
7.  **Finalize:** `gemini aurelius:finalize-ticket`
    *   Reviewer checks code and tests.
    *   **Success:** Moves to `DONE` and commits.
    *   **Failure:** Moves to `REWORK` with feedback.
8.  **Hotfix:** `gemini aurelius:hotfix "Critical bug description"`
    *   Urgent correction workflow bypassing standard grooming if necessary.

### Command vs. Specs Mapping

This table shows the interaction between Aurelius commands and the specification files in `specs/`.

| Command | Skill | PC | CM | BR | PR | UX | AR | EP |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| `bootstrap-specs` | Product Manager | ✏️ | | ✏️ | ✏️ | | ✏️ | ✏️ |
| `analyze` | Architect | ✏️ | ✏️ | | ✏️ | | ✏️ | ✏️ |
| `design` | Designer | 👁️ | | | 👁️ | ✏️ | | |
| `gen-tickets` | Product Owner | | | | 👁️ | | | 👁️ |
| `groom-ticket` | Architect | | 👁️ | | | 👁️ | 👁️ | |
| `dev-ticket` | Developer | 👁️ | 👁️ | | | 👁️ | | |
| `finalize-ticket` | Reviewer | | | | | | | |
| `hotfix` | Developer | | 👁️ | | | | 👁️ | |

**Legend:**
*   **PC:** `productContext.md` (Vision & Tech Stack)
*   **CM:** `context-map.md` (Technical Index)
*   **BR:** `00-BRIEF.md` (Objectives)
*   **PR:** `01-PRD.md` (Business Rules)
*   **UX:** `02-UX-DESIGN.md` (Design Flows)
*   **AR:** `03-ARCHITECTURE.md` (Standards)
*   **EP:** `04-EPICS.md` (Roadmap)
*   ✏️ : Create / Modify
*   👁️ : Read / Consult

## 7. Interactive Alignment

By default, Aurelius agents prioritize alignment over assumptions. If a requirement is ambiguous, if business rules are missing, or if multiple architectural paths are possible, the agent will list its questions and wait for your input. This ensures the generated specifications and code remain 100% aligned with your vision.

## 8. Ticket Lifecycle (Statuses)

*   **TODO:** In the backlog, waiting.
*   **READY:** Groomed by the Architect, ready for Dev.
*   **IN_PROGRESS:** Currently under development (in `WIP/`).
*   **REWORK:** Review failure. The developer must fix the acceptance criteria (AC) or quality before a new review.
*   **DONE:** Validated and archived.

## 9. Workflow Automation (Interoperability)

Every Aurelius agent response ends with a standardized footer to facilitate integration with external tools (scripts, CI/CD, workflow orchestrators).

```text
[SUMMARY]: <Short description of the work performed>
[NEXT_STEP]: <The recommended aurelius:command to continue the workflow>
```

When calling Gemini CLI with the `--json` flag, these markers can be easily parsed from the `content` field using regex to automate the next action.

Advanced automation scripts and isolation environments are available in the `/automate/` directory:

- **`docker/`**: Full stack isolation using Docker Compose, providing dedicated containers for agents and n8n.
- **`alternative-vm.md`**: Guide for setting up a dedicated Ubuntu VM (KVM) for maximum security and sandboxing.
- **`alternative-wsl.md`**: Instructions for Windows users to deploy isolated environments using WSL 2 and cloud-init.
- **`aurelius-n8n-workflow.json`**: Pre-configured n8n workflow for visual orchestration of the methodology.
- **`aurelius-yolo-workflow.sh`**: A lightweight bash script for rapid, automated execution of the command sequence.

## 10. References
- [gemini cli custom commands](https://geminicli.com/docs/cli/custom-commands/)
- [gemini cli settings](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/settings.md)
