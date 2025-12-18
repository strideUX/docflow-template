# DocFlow Setup (System)

Configure Linear integration for DocFlow Cloud.

## Steps

1. **Get Team ID** - Query Linear teams
2. **Get Project ID** - Query Linear projects (optional)
3. **Update Config** - Save to `.docflow/config.json`
4. **Verify** - Test Linear connection

## Configuration

Updates `.docflow/config.json`:
- `provider.teamId` - Required
- `provider.projectId` - Optional
- `provider.defaultMilestoneId` - Optional

## Requirements

- Linear MCP installed
- Or LINEAR_API_KEY in .env

## After Setup

Run `/sync-project` to sync context to Linear.
