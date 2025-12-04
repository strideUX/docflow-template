# User Flows

<!--
AGENT INSTRUCTIONS:
- Document key user journeys through the application
- Update as new features are added or flows change
- Reference when implementing features to ensure flow continuity
- Use these to validate that features connect properly
-->

Map out the critical paths users take through the application. Helps ensure features work together as a cohesive experience.

---

## Flow Template

For each flow, document:
- **Flow Name** - Clear, descriptive title
- **Persona** - Which user type(s) use this flow
- **Goal** - What the user is trying to accomplish
- **Entry Points** - Where can users start this flow?
- **Steps** - Sequence of actions and screens
- **Success State** - How the flow completes successfully
- **Failure States** - What can go wrong and how it's handled
- **Related Features** - What specs/features support this flow

---

## Core Flows

### [Flow Name 1] - [One-line description]

**Example: "Create New Project" - User sets up a new project from scratch**

**Persona:** [Which user persona]  
**Goal:** [What they want to accomplish]  
**Priority:** [High | Medium | Low]

**Entry Points:**
- [Where users can start this flow]
- [Alternative entry point]

**Steps:**
1. **[Screen/Action 1]**
   - User does: [Action]
   - System shows: [Response]
   - Next: [Where they go]

2. **[Screen/Action 2]**
   - User does: [Action]
   - System shows: [Response]
   - Next: [Where they go]

3. **[Screen/Action 3]**
   - User does: [Action]
   - System shows: [Response]
   - Next: [Where they go]

**Success State:**
- [What happens when flow completes successfully]
- [What the user sees/experiences]
- [Where they land]

**Failure States:**
- **Error 1:** [What went wrong] → [How it's handled]
- **Error 2:** [What went wrong] → [How it's handled]
- **User abandons:** [Can they resume? What happens to partial work?]

**Related Features:**
- [feature-name.md] - [How it relates]
- [feature-name-2.md] - [How it relates]

**Notes:**
- [Any special considerations]
- [Edge cases to handle]
- [Performance considerations]

---

### [Flow Name 2] - [One-line description]

**Persona:** [User type]  
**Goal:** [Objective]  
**Priority:** [Level]

**Entry Points:**
- [Entry point]

**Steps:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Success State:**
- [Completion state]

**Failure States:**
- [Error handling]

**Related Features:**
- [feature-name.md]

---

## Secondary Flows

### [Flow Name 3] - [Brief description]

**Quick Summary:**
- **Persona:** [User]
- **Goal:** [Objective]
- **Key Steps:** [Step 1] → [Step 2] → [Step 3]
- **Success:** [End state]

---

## Flow Intersections

**Where flows overlap or connect:**

**[Flow 1] → [Flow 2]:**
- [How users transition between flows]
- [What data carries over]

**[Flow 3] interrupts [Flow 1]:**
- [What happens when flows interrupt each other]
- [How users resume]

---

## Using User Flows in Development

**When implementing features:**
1. Identify which flows the feature supports
2. Verify all steps in the flow are covered
3. Ensure smooth transitions between steps
4. Handle all documented failure states

**When reviewing implementations:**
- Walk through the flow end-to-end
- Verify success state is reachable
- Test all failure states
- Check that related features connect properly

**When planning sprints:**
- Group features by flow for better UX
- Implement flows end-to-end when possible
- Avoid leaving flows partially complete

**When testing:**
- Test complete flows, not just individual features
- Verify transitions between flows work
- Test failure states and recovery
- Confirm success states are clear to users

---

## Flow Diagram Notation

```
[Screen/Page Name]
    ↓
User Action
    ↓
[Next Screen/Page]
    ↓
Decision Point?
    ├─ Yes → [Success Path]
    └─ No → [Alternative Path]
```

---

**Last Updated:** YYYY-MM-DD  
**Flows Documented:** [Count]  
**Personas Covered:** [List]

