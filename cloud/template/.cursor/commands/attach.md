# Attach (Implementation Agent)

## Overview
Attach files or links to a Linear issue. Supports GitHub links (recommended for committed files) and direct upload (for local/private content).

**Agent Role:** Implementation Agent (builder)  
**Frequency:** During implementation when adding reference materials

---

## Methods

### Method 1: GitHub Link (Recommended)
For files committed to git - stays in sync with repo.

### Method 2: Direct Upload
For local files not yet committed, private notes, or point-in-time snapshots.

---

## Steps

### 1. **Identify Target Issue**

**If user specified issue (LIN-XXX):**
- Use that issue ID

**If not specified:**
- Use current in-progress issue
- Or ask which issue to attach to

### 2. **Identify File to Attach**

Get from user:
- File path (local)
- Title for the attachment
- Optional: subtitle/description

### 3. **Determine Attachment Method**

**Ask or infer:**
```markdown
How should I attach this file?

1. **GitHub link** (recommended) - Links to repo, stays in sync
2. **Direct upload** - Uploads copy to Linear storage

Note: GitHub link requires file to be committed and pushed.
```

**Auto-select GitHub link if:**
- File is in a git repo
- File path matches known committed paths
- User says "link" or "reference"

**Auto-select upload if:**
- File is in temp/draft location
- User says "upload" or "copy"
- File contains sensitive/private content

---

## Method 1: GitHub Link

### Build GitHub URL

```bash
# Get repo info
REPO_URL=$(git remote get-url origin | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')
BRANCH=$(git branch --show-current)
FILE_PATH="relative/path/to/file.md"

# Construct URL
GITHUB_URL="${REPO_URL}/blob/${BRANCH}/${FILE_PATH}"
```

### Create Attachment

```bash
source .env

curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { attachmentCreate(input: { issueId: \"ISSUE_ID\", title: \"TITLE\", subtitle: \"SUBTITLE\", url: \"GITHUB_URL\" }) { success attachment { id url } } }"
  }'
```

---

## Method 2: Direct Upload

### Step 2a: Get Upload URL

```bash
source .env

FILE_PATH="path/to/file.md"
FILE_SIZE=$(wc -c < "$FILE_PATH" | tr -d ' ')
FILE_NAME=$(basename "$FILE_PATH")
CONTENT_TYPE="text/markdown"  # or appropriate mime type

UPLOAD_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"query\": \"mutation { fileUpload(filename: \\\"$FILE_NAME\\\", contentType: \\\"$CONTENT_TYPE\\\", size: $FILE_SIZE) { success uploadFile { uploadUrl assetUrl headers { key value } } } }\"
  }")

UPLOAD_URL=$(echo $UPLOAD_RESPONSE | jq -r '.data.fileUpload.uploadFile.uploadUrl')
ASSET_URL=$(echo $UPLOAD_RESPONSE | jq -r '.data.fileUpload.uploadFile.assetUrl')
RANGE_HEADER=$(echo $UPLOAD_RESPONSE | jq -r '.data.fileUpload.uploadFile.headers[] | select(.key == "x-goog-content-length-range") | .value')
```

### Step 2b: Upload File

```bash
curl -s -X PUT "$UPLOAD_URL" \
  -H "Content-Type: $CONTENT_TYPE" \
  -H "x-goog-content-length-range: $RANGE_HEADER" \
  --data-binary @"$FILE_PATH"
```

### Step 2c: Create Attachment

```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"query\": \"mutation { attachmentCreate(input: { issueId: \\\"ISSUE_ID\\\", title: \\\"TITLE\\\", subtitle: \\\"SUBTITLE\\\", url: \\\"$ASSET_URL\\\" }) { success attachment { id url } } }\"
  }"
```

---

## Content Type Reference

| Extension | Content Type |
|-----------|--------------|
| `.md` | `text/markdown` |
| `.txt` | `text/plain` |
| `.json` | `application/json` |
| `.png` | `image/png` |
| `.jpg` | `image/jpeg` |
| `.pdf` | `application/pdf` |

---

## Confirmation

```markdown
✅ Attached to LIN-XXX!

**File:** [filename]
**Method:** GitHub Link / Direct Upload
**Title:** [title]

[View attachment](url)
```

---

## Common Use Cases

### Attach Knowledge File (GitHub Link)
```
User: "attach the overview doc to this issue"

Agent: Attaching docflow/context/overview.md as GitHub link...
✅ Attached "Project Overview" to STR-29
```

### Attach Session Notes (Upload)
```
User: "upload my session notes to the issue"

Agent: Uploading session-notes.md to Linear...
✅ Attached "Session Notes - Dec 5" to STR-29
```

### Attach Design Reference (Link)
```
User: "link the figma to STR-15"

Agent: 
For Figma, I'll add the URL directly...
✅ Attached "Design Mockup" to STR-15
```

---

## Context to Load
- Current issue context
- `.env` file (for LINEAR_API_KEY)
- Git repo info (for GitHub links)

---

## Natural Language Triggers
User might say:
- "attach [file] to [issue]"
- "link [file] to the issue"
- "upload [file]"
- "add [file] as attachment"

**Run this command when detected.**

---

## Environment Requirements

Requires `LINEAR_API_KEY` from project `.env` file:

```bash
# .env
LINEAR_API_KEY=lin_api_xxxxx
```

---

## Outputs
- File attached to Linear issue
- GitHub link or uploaded copy
- Confirmation with link

---

## Checklist
- [ ] Identified target issue
- [ ] Got file path and title
- [ ] Determined attachment method
- [ ] For GitHub: Built repo URL, created attachment
- [ ] For Upload: Got upload URL, uploaded file, created attachment
- [ ] Provided confirmation

---

## Troubleshooting

**Upload fails with signature error:**
- Ensure using exact headers from API response
- Check file size matches what was declared

**GitHub link 404:**
- Verify file is committed and pushed
- Check branch name is correct

**"Unauthorized" error:**
- Verify LINEAR_API_KEY is set and valid




