# Data Schemas

The plugin reads JSON files from the `data/` folder inside your plugin directory. Each card has its own file. These are the schemas.

All files are written by headless Claude scripts. Run each script once manually to create the initial file, then schedule it with cron.

---

## action-queue.json

Written by your daily brief skill. Each row is a recommended action the operator can approve or dismiss.

```json
[
  {
    "id": "1",
    "suggestion": "Send weekly status update to [client name]",
    "skill": "status-update",
    "args": { "client": "client-slug" },
    "priority": 1
  },
  {
    "id": "2",
    "suggestion": "Prepare check-in for Thursday call with [client name]",
    "skill": "checkin-prep",
    "args": { "client": "client-slug" },
    "priority": 2
  }
]
```

Fields:
- `id` — unique string identifier
- `suggestion` — plain text description shown in the card
- `skill` — slash command name (without the `/`) to fire when approved
- `args` — object passed to the skill as arguments
- `priority` — sort order (1 = highest)

---

## calendar.json

Written by `cc-refresh-calendar.sh`.

```json
{
  "generated": "2026-05-27T09:00:00+10:00",
  "events": [
    {
      "id": "abc123",
      "title": "Client strategy call",
      "start": "2026-05-27T10:00:00+10:00",
      "end": "2026-05-27T11:00:00+10:00",
      "allDay": false,
      "location": "Google Meet",
      "calendar": "work",
      "url": ""
    }
  ]
}
```

`calendar` field: `"work"` for client/external meetings, `"internal"` for everything else.

---

## engagements.json

Written by `cc-refresh-engagements.sh`.

```json
[
  {
    "id": "eng-001",
    "name": "Client Name",
    "stage": "Active",
    "lastActivity": "2026-05-26",
    "blocked": false,
    "blocker": "",
    "health": "green"
  }
]
```

`health` values: `"green"` (on track), `"amber"` (needs attention), `"red"` (blocked).

---

## scorecard.json

Write this manually or from a refresh script. Whatever metrics matter to your day.

```json
{
  "generated": "2026-05-27T09:00:00+10:00",
  "stats": [
    {
      "label": "Active Clients",
      "value": "8",
      "trend": "up"
    },
    {
      "label": "Tasks Due Today",
      "value": "3",
      "trend": "neutral"
    },
    {
      "label": "Instagram Followers",
      "value": "4,821",
      "trend": "up"
    }
  ]
}
```

`trend` values: `"up"`, `"down"`, `"neutral"`.

---

## gmail-highlights.json

Written by a headless Claude script that reads your Gmail via MCP.

```json
{
  "generated": "2026-05-27T09:00:00+10:00",
  "items": [
    {
      "id": "msg-001",
      "subject": "Invoice approved",
      "from": "client@example.com",
      "date": "2026-05-27",
      "snippet": "Hi, just approved the invoice for...",
      "threadId": "thread-abc"
    }
  ]
}
```

---

## skill-runs.json

Maintained by the plugin itself. Tracks recent skill button executions.

```json
[
  {
    "id": "run-001",
    "skill": "daily-brief",
    "args": {},
    "status": "complete",
    "startedAt": "2026-05-27T08:05:00+10:00",
    "completedAt": "2026-05-27T08:06:42+10:00",
    "outputPath": "Briefings/Daily/27th-May-Brief.md"
  }
]
```
