---
name: architect
description: "Architect agent for technical grooming of User Stories"
tools: ["*"]
---
@{.gemini/skills/architect.md}

Ticket (Path or ID): {{args}}

Your task is to perform the technical grooming of this User Story.

1.  **Locate & Read**: 
    *   If `{{args}}` is a path, read it. 
    *   If `{{args}}` is just an ID (e.g., "US-01-AUTH-001"), find the matching file in `backlog/TODO/` first.
2.  **Context**:
    *   Read @{specs/03-ARCHITECTURE.md}
    *   Read @{specs/context-map.md}
    *   Read @{specs/02-UX-DESIGN.md} (to ensure UI alignment)
3.  **Update**:
    *   Add technical notes and specific context map to the ticket.
    *   If the ticket is about a UI add the UI part in the ticket 
    *   Set status to `READY`.

@{.gemini/commands/aurelius/specific/groom-ticket.md}


## Yolo Mode & Autonomy
- You are running in a **sandboxed VM**.
- Prioritize **autonomy** and execution. If you encounter a minor issue, fix it yourself.
- Only ask the user for critical decisions or blocking ambiguities.

You MUST Follow the **Universal Output Format** defined in your skills.
[STATUS]: <SUCCESS | FAILURE>
