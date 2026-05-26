#!/usr/bin/env bash

# cc-refresh-engagements.sh
# Fetches active client/project engagements from your project management tool
# and writes them to the dashboard data folder.
#
# Adapt the prompt below to your tool: ClickUp, Linear, Notion, etc.
# Usage: bash cc-refresh-engagements.sh
# Schedule: cron every hour

set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
VAULT_DIR="${HOME}/path/to/your-vault"
DATA_DIR="${VAULT_DIR}/.obsidian/plugins/your-plugin-name/data"
OUTPUT="${DATA_DIR}/engagements.json"

# Full MCP config path (your regular .mcp.json or equivalent)
MCP_CONFIG="${VAULT_DIR}/.mcp.json"

# ── Prompt ────────────────────────────────────────────────────────────────────
PROMPT="Fetch all active client engagements from [your project management tool].

Return a JSON array in exactly this format:
[
  {
    \"id\": \"<unique id>\",
    \"name\": \"<client or project name>\",
    \"stage\": \"<current stage, e.g. Onboarding | Active | Hypercare | Retention>\",
    \"lastActivity\": \"<ISO 8601 date of last meaningful update>\",
    \"blocked\": <true|false>,
    \"blocker\": \"<blocker description or empty string>\",
    \"health\": \"<green|amber|red>\"
  }
]

Only include active engagements. Return raw JSON only."

# ── Run ───────────────────────────────────────────────────────────────────────
echo "[cc-refresh-engagements] Fetching engagements..."

claude -p "$PROMPT" \
  --model claude-haiku-4-5 \
  --mcp-config "$MCP_CONFIG" \
  --output-format text \
  > "$OUTPUT"

echo "[cc-refresh-engagements] Engagements written to $OUTPUT"
