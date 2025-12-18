---
name: docflow-commands
description: "Reference for DocFlow slash commands and natural language triggers. Apply when user invokes commands, uses trigger phrases, or asks about available commands."
---

# DocFlow Commands Skill

This skill provides command reference and natural language trigger mapping.

## Command Reference

### PM/Planning Commands

| Command | Purpose | Key Actions |
|---------|---------|-------------|
| `/start-session` | Begin work session | Query Linear status, show dashboard |
| `/wrap-session` | End work session | Summarize progress, update issues |
| `/capture` | Create new issue | Gather info, apply template, save to Linear |
| `/refine [issue]` | Triage or refine | Classify type or improve details |
| `/activate [issue]` | Ready for work | Assign, set priority/estimate, move to In Progress |
| `/review [issue]` | Code review | Check implementation, approve or request changes |
| `/close [issue]` | Complete issue | Move to Done/Archived/Canceled |
| `/project-update` | Post update | Compose and post project health update |
| `/sync-project` | Sync to Linear | Update Linear project from context files |

### Implementation Commands

| Command | Purpose | Key Actions |
|---------|---------|-------------|
| `/implement [issue]` | Build feature | Load context, begin implementation |
| `/block` | Document blocker | Move to Blocked, add details |
| `/attach [file]` | Attach file | Link or upload file to issue |

### QE Commands

| Command | Purpose | Key Actions |
|---------|---------|-------------|
| `/validate [issue]` | Test implementation | Guide user through acceptance criteria |

### System Commands

| Command | Purpose | Key Actions |
|---------|---------|-------------|
| `/status` | Check status | Query Linear for current state |
| `/docflow-setup` | Initial setup | Configure Linear integration |
| `/docflow-update` | Update rules | Sync rules from source repo |

---

## Natural Language Triggers

### Session Management
- "let's start" / "what's next" → `/start-session`
- "wrap it up" / "I'm done" → `/wrap-session`
- "what's the status" → `/status`

### Capturing Work
- "capture that" / "add to backlog" → `/capture`
- "found a bug" / "new idea" → `/capture`

### Refining Work
- "refine [issue]" / "triage [issue]" → `/refine`
- "what needs triage" → Show triage queue
- "prepare [issue]" → `/refine`

### Implementation
- "let's build" / "implement this" → `/implement`
- "I'm blocked" / "can't proceed" → `/block`
- "attach [file]" → `/attach`

### Review & Validation
- "review [issue]" / "code review" → `/review`
- "test this" / "validate" → `/validate`

### Approval & Closing
- "looks good" / "approve" / "ship it" → QE approval
- "close [issue]" / "mark complete" → `/close` (Done)
- "archive [issue]" → `/close` (Archived)
- "cancel [issue]" → `/close` (Canceled)

### Project Management
- "post project update" → `/project-update`
- "sync project" → `/sync-project`
