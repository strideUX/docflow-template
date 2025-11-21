# DocFlow Workflow & Commands

This document explains the three-agent workflow model and available commands.

---

## Three-Agent Model

DocFlow uses a **three-agent orchestration model** for efficient, focused work:

```
┌──────────────────────────────────────────────────┐
│  🎯 PM/Planning Agent (DocFlow)                  │
│  Role: Orchestration & Planning                  │
│  • Refines specs and captures work              │
│  • Activates work for implementation             │
│  • Reviews and closes completed work             │
│  Commands: /start-session, /capture, /review,   │
│           /activate, /close, /wrap-session       │
└──────────────────────────────────────────────────┘
                        ↓
              Activates spec for implementation
                        ↓
┌──────────────────────────────────────────────────┐
│  💻 Implementation Agent                         │
│  Role: Build the thing                           │
│  • Picks up active specs                         │
│  • Implements features/fixes                     │
│  • Auto-marks for review when complete           │
│  Commands: /implement, /block                    │
└──────────────────────────────────────────────────┘
                        ↓
          Auto-sends to validation when done
                        ↓
┌──────────────────────────────────────────────────┐
│  ✅ QE/Validation Agent                          │
│  Role: Validate with user                        │
│  • Performs code review                          │
│  • Works iteratively with user to test          │
│  • Finds issues or approves                      │
│  • Sends back to impl or marks approved          │
│  Commands: /validate                             │
└──────────────────────────────────────────────────┘
                        ↓
            User approves: "looks good!"
                        ↓
┌──────────────────────────────────────────────────┐
│  🎯 PM/Planning Agent (DocFlow)                  │
│  • Closes and archives the spec                 │
│  • Queues next priority work                     │
│  Commands: /close, /start-session                │
└──────────────────────────────────────────────────┘
```

---

## Commands by Agent Role

### 🎯 PM/Planning Agent Commands

**`/start-session`** - Begin your planning session
- Check ACTIVE.md for current state
- Show work in QE testing (ready for you to approve)
- Show work being implemented
- Show backlog priorities
- Identify what needs attention

**`/capture`** - Quick capture new work
- Create feature/bug/chore/idea specs
- Add to backlog without context switching
- Keep focus on current work

**`/review [spec-name]`** - Refine backlog item
- Load and refine spec details
- Ask clarifying questions
- Fill out acceptance criteria
- Add technical notes
- Leave in backlog when complete

**`/activate [spec-name]`** - Ready for implementation
- Move spec from backlog → active
- Set status=READY
- Assign to developer
- **This is the handoff to Implementation agent**

**`/close [spec-name]`** - Archive completed work
- For QE_TESTING specs that user approved
- Move to complete/YYYY-QQ/
- Update tracking files
- Show next priority

**`/wrap-session`** - End planning session
- Summary of work in flight
- What's ready for QE testing
- What's queued for implementation
- Save state for next session

---

### 💻 Implementation Agent Commands

**`/implement [spec-name]`** or **`/start`** - Pick up and build
- Checks active/ for status=READY specs
- If multiple: infers from context or asks
- Loads spec + stack.md + standards.md
- Sets status=IMPLEMENTING
- Builds the feature/fix
- **Auto-marks for review when complete** (no wrap command needed)

**`/block`** - Hit a blocker
- Document blocker in spec
- Set status=REVIEW (hands back to PM)
- Explain what's blocking progress

---

### ✅ QE/Validation Agent Commands

**`/validate [spec-name]`** or **`/test`** - Test and validate
- Checks active/ for status=REVIEW specs
- Loads spec with Implementation Notes
- Performs DocFlow code review
- Sets status=QE_TESTING
- Generates testing checklist for user
- Works iteratively with user
- Documents issues OR waits for approval
- If issues: sends back to IMPLEMENTING
- If approved: marks ready for PM to close

**User approval phrases:**
- "looks good" / "approve" / "ship it"
- "works great" / "all good"
- "QE passed" / "verified"

---

### 🔍 All Agents

**`/status`** - Check current state
- Show active specs and their status
- Show work assigned to you
- Show work in QE testing
- Show blockers
- Show next priorities

---

## Example Workflows

### Happy Path: Feature Implementation

```
1. PM Agent (Long-running thread)
   User: "let's start"
   PM: /start-session
   → Shows backlog, current work, priorities

2. PM Agent
   User: "let's build the user dashboard"
   PM: /review feature-user-dashboard
   → Refines spec with user

3. PM Agent
   User: "ready to build this"
   PM: /activate feature-user-dashboard
   → Moves to active/, assigns to developer, status=READY

4. Implementation Agent (Fresh, focused thread)
   User: "start work"
   Impl: /implement
   → Picks up feature-user-dashboard
   → Implements the feature
   → Auto-marks status=REVIEW when complete

5. QE Agent (Fresh thread)
   User: "validate the dashboard"
   QE: /validate feature-user-dashboard
   → Reviews code quality
   → Sets status=QE_TESTING
   → Guides user through testing

6. QE Agent (continued)
   User: [tests feature] "looks great!"
   QE: → Marks approved, ready for closure

7. PM Agent (returns to long-running thread)
   User: "let's wrap up"
   PM: /start-session
   → Sees approved work
   PM: /close feature-user-dashboard
   → Archives spec, shows next priority
```

### With Feedback Loop

```
5. QE Agent
   User: [tests] "the button doesn't work on mobile"
   QE: → Documents issue, sets status=IMPLEMENTING

6. Implementation Agent (back to focused thread)
   User: "fix the mobile issue"
   Impl: /implement feature-user-dashboard
   → Picks up again, reads QE notes
   → Fixes the issue
   → Auto-marks REVIEW

7. QE Agent (returns)
   User: "test again"
   QE: /validate feature-user-dashboard
   → Tests the fix
   User: "perfect! approve it"
   QE: → Approved

8. PM Agent
   PM: /close feature-user-dashboard
   → Done!
```

---

## Natural Language Support

You **don't need to type /commands** explicitly. Agents recognize natural language:

**Instead of typing `/start-session`, just say:**
- "let's start"
- "what's next"
- "where are we"

**Instead of `/capture`, just say:**
- "capture that idea"
- "add this to backlog"
- "found a bug"

**Instead of `/activate`, just say:**
- "ready to build [spec]"
- "activate [spec] for implementation"

**Instead of `/implement`, just say:**
- "let's work on [spec]"
- "build [spec]"
- "start implementation"

**Instead of `/validate`, just say:**
- "let's test this"
- "review the implementation"

**Instead of `/close`, just say:**
- "close [spec]"
- "archive this"

**For approval during QE:**
- "looks good!"
- "approve it"
- "ship it"
- "all good"

---

## Agent Handoff Points

**Critical transitions:**

1. **PM → Implementation**: `/activate` sets status=READY
2. **Implementation → QE**: Auto-marks status=REVIEW when done
3. **QE → Implementation**: Sets status=IMPLEMENTING if issues found
4. **QE → PM**: User approval makes it ready for /close
5. **Implementation → PM**: `/block` hands back for input

---

## Best Practices

### For PM Agent (Long-running thread)
- Keep one thread for the entire session
- Use for planning, reviewing, orchestrating
- Check status at start and end of session
- Review implementations before QE
- Close work after user approval

### For Implementation Agent (Fresh thread)
- Start fresh thread for focused work
- Let agent auto-complete when done
- Use /block if you need PM input
- Keep thread focused on one spec

### For QE Agent (Fresh thread)
- Start fresh for each validation
- Work iteratively with user
- Document issues clearly
- Loop back to implementation if needed
- Wait for explicit user approval

### For All Agents
- Trust natural language triggers
- Use /status to check current state
- Keep work moving through the pipeline
- Document decisions as you go

---

## System Setup Commands

These are for setting up DocFlow initially, not day-to-day work:

**`/new-project`** - Set up new project with DocFlow
- Interactive setup conversation
- Creates all DocFlow structure
- Fills out context files
- Creates initial backlog

**`/scan-project`** - Retrofit DocFlow to existing codebase
- Analyzes existing code
- Documents what's there
- Creates spec for existing features
- Sets up DocFlow structure

Use these once per project, then use the workflow commands above for daily work.

---

**See Also:**
- `/docflow/README.md` - Quick reference
- `.cursor/rules/docflow.mdc` - Complete workflow rules
- `/docflow/specs/templates/README.md` - Spec templates guide

