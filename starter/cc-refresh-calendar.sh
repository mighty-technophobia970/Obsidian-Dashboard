#!/usr/bin/env bash

# cc-refresh-calendar.sh
# Headless Claude script that fetches Google Calendar events and writes
# them to the dashboard data folder.
#
# Usage: bash cc-refresh-calendar.sh
# Schedule: cron every hour, or trigger from the Calendar card's refresh button

set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
# Absolute path to your Obsidian vault
VAULT_DIR="${HOME}/path/to/your-vault"

# Plugin data output path (relative to vault root)
DATA_DIR="${VAULT_DIR}/.obsidian/plugins/your-plugin-name/data"

# Output file
OUTPUT="${DATA_DIR}/calendar.json"

# MCP config with ONLY the Google Calendar connector loaded.
# Loading the full MCP server set here causes a tool schema conflict
# that the API rejects. This file must exist and must only load
# the Google Calendar connector.
MCP_CONFIG="${VAULT_DIR}/.claude/scripts/cc-mcp-calendar.json"

# ── Prompt ────────────────────────────────────────────────────────────────────
PROMPT="Use the Google Calendar tool to list all events from 14 days ago through 21 days from now.

Return a JSON object in exactly this format:
{
  \"generated\": \"<ISO 8601 timestamp>\",
  \"events\": [
    {
      \"id\": \"<event id>\",
      \"title\": \"<event title>\",
      \"start\": \"<ISO 8601 datetime>\",
      \"end\": \"<ISO 8601 datetime>\",
      \"allDay\": <true|false>,
      \"location\": \"<location or empty string>\",
      \"calendar\": \"<work|internal>\",
      \"url\": \"<calendar event URL or empty string>\"
    }
  ]
}

For the calendar field:
- \"work\" for client meetings, external calls, anything with an external attendee
- \"internal\" for everything else (personal blocks, team meetings, admin)

Return only the raw JSON. No markdown fences, no explanation."

# ── Run ───────────────────────────────────────────────────────────────────────
echo "[cc-refresh-calendar] Starting calendar refresh..."

claude -p "$PROMPT" \
  --model claude-haiku-4-5 \
  --strict-mcp-config \
  --mcp-config "$MCP_CONFIG" \
  --output-format text \
  > "$OUTPUT"

echo "[cc-refresh-calendar] Calendar written to $OUTPUT"
echo "[cc-refresh-calendar] Done."
