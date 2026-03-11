# wowclaude

**Install once, get better Claude Code responses forever.**

A Claude Code plugin that uses multi-layered hooks to inject evidence-based quality principles. No configuration needed.

## Installation

```bash
/plugin marketplace add jbj338033/wowclaude
/plugin install wowclaude
```

## The 5 Principles

| # | Principle | What it does |
|---|-----------|-------------|
| 1 | **certainty** | Prevents confabulation on high-risk topics. Forces "iirc" markers on unverified internal details. |
| 2 | **investigation** | Forces reading before writing. Verify with tools, or say you can't. |
| 3 | **reasoning** | Step-back reasoning on hard problems. Understand why, then solve. |
| 4 | **precision** | Matches effort to complexity. Less with qualifiers > more with false confidence. |
| 5 | **verification** | Self-checks against the original request before finalizing. |

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    wowclaude hooks                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  SessionStart          → base quality principles        │
│  │                       (always active)                │
│  ▼                                                      │
│  UserPromptSubmit      → risk detection per message     │
│  │  ├─ CRITICAL tier   → internal details, bit flags    │
│  │  ├─ CAUTION tier    → version-specific, deprecated   │
│  │  └─ (no trigger)    → normal queries pass through    │
│  ▼                                                      │
│  PreToolUse            → edit guard                     │
│     └─ Edit/Write      → "did you read this file?"     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Hook Details

| Hook | Event | Trigger | Injection |
|------|-------|---------|-----------|
| **session-start.sh** | `SessionStart` | Every session | 5 quality principles (~90 words) |
| **user-prompt.sh** | `UserPromptSubmit` | Each message | CRITICAL: internal details (~60 words) / CAUTION: version-specific (~40 words) / none |
| **pre-tool-use.sh** | `PreToolUse` | Before Edit/Write | Investigation reminder (~20 words) |

### Multi-Tier Risk Detection

The `UserPromptSubmit` hook classifies queries into risk tiers:

**CRITICAL** — Internal implementation details (highest confabulation risk):
- Bit flags, enum values, struct fields, bytecode formats
- Private/undocumented APIs, compiler internals
- Runtime flags, syscall tables, fiber internals

**CAUTION** — Version-specific or platform-specific behavior:
- Breaking changes, deprecated features, migration paths
- Version-boundary behavior, platform differences

**Safe** — No intervention needed for general queries.

## Test Results

Tested with identical prompts before and after plugin installation:

| Test | Without wowclaude | With wowclaude |
|------|-------------------|----------------|
| "List React fiber flags with bit values" | Lists specific hex values as fact | Prefixes values with "iirc", points to source file |
| "What's `process._linkedBinding('http_parser')` signature?" | Lists full API surface confidently | States values are unverified, recommends source check |
| "What is git stash?" | Concise answer | Concise answer (no unnecessary intervention) |

## What's NOT Included (and Why)

- **Expert persona** ("You are a senior engineer...") — No measurable accuracy improvement. Just makes responses longer.
- **"Think step by step"** — Modern Claude models already do chain-of-thought internally. Redundant instruction.
- **Magic phrases** ("Take a deep breath", "This is important for my career") — No generalizable effect.
- **Forced long reasoning chains** — Shorter, focused chains often outperform verbose ones.

## Research

See [docs/research.md](docs/research.md) for detailed citations and reasoning.

## Toggle / Uninstall

```bash
/plugin disable wowclaude    # disable temporarily
/plugin enable wowclaude     # re-enable
/plugin uninstall wowclaude  # remove completely
```

## License

[MIT](LICENSE)
