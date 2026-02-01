# **Technical Specification: "Lite" AI Development Method (Aurelius)**

## **1. Vision and Philosophy**

This method is a simplified adaptation of BMAD (**Build More, Architect Dreams**), designed to be **agnostic** (Gemini CLI / Claude Code) and **native**. It is based on three pillars:

1.  **Kanban-as-Code:** The project state is dictated by Markdown files in `backlog/`.
2.  **Segmented Contexts:** Separation between Vision (`productContext.md`), Technical Map (`context-map.md`), and Specifications (`PRD`, `Architecture`).
3.  **Minimalism (KISS):** Priority to the simplest solution. Categorical refusal of over-engineering and premature optimization.

## **2. Project Architecture (File System)**

``` 
.
├── .gemini/
│   ├── commands/aurelius/  # Workflows (bootstrap, plan, dev, finalize...)
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
└── templates/              # Skeletons for initialization
```

## **3. Roles (Skills)**
...
*   **Reviewer:** Checks quality, modernity, and archives to `DONE`. In case of failure, moves the ticket to `REWORK` with detailed feedback.

## **4. Workflows (Namespace `aurelius:`)**
...
### **C. Implementation & Quality**
*   **aurelius:dev-ticket:** Implements (TDD). Moves to `WIP`. **Forbidden to move to DONE.**
*   **aurelius:finalize-ticket:** Technical review and Commit.
    *   **Success:** Move to `DONE` and archiving.
    *   **Failure:** Move to `REWORK`, adding review notes at the end of the US file. The ticket remains in `WIP`.
*   **aurelius:hotfix:** Urgent fix...

### **D. Operating Modes**
...

## **6. Ticket Lifecycle (Statuses)**
*   **TODO:** In the backlog, waiting.
*   **READY:** Groomed by the Architect, ready for Dev.
*   **IN_PROGRESS:** Currently under development (in `WIP/`).
*   **REWORK:** Review failure. The developer must fix the acceptance criteria (AC) or quality before a new review.
*   **DONE:** Validated and archived.