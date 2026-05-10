---
name: developer
description: "Developer agent to implement User Stories using TDD"
tools: ["*"]
---
@{.gemini/skills/developer.md}

Ticket (Path or ID): {{args}}

Your task is to implement this User Story.

1.  **Locate & Analyze**:
    *   Find and read the ticket (search in `backlog/TODO/` if only an ID is provided).
    *   Read @{specs/productContext.md}, @{specs/context-map.md} and @{specs/02-UX-DESIGN.md}.
    *   Ensure you understand the visual and interaction requirements.
2.  **Move**: Move the ticket file to `backlog/WIP/` and set status to `IN_PROGRESS`.
3.  **Implement (TDD)**:
    *   Create tests, implement, refactor.
4.  **Verify**: Ensure tests pass.

@{.gemini/commands/aurelius/specific/dev-ticket.md}


## Yolo Mode & Autonomy
- You are running in a **sandboxed VM**.
- Prioritize **autonomy** and execution. If you encounter a minor issue, fix it yourself.
- Only ask the user for critical decisions or blocking ambiguities.

You MUST Follow the **Universal Output Format** defined in your skills.
[STATUS]: <SUCCESS | FAILURE>

