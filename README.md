# wowclaude

**Install once, get better Claude Code responses forever.**

A Claude Code plugin that injects 6 evidence-based quality principles at every session start. No configuration needed.

## Installation

```bash
claude plugin add /path/to/wowclaude
```

## The 6 Principles

| # | Principle | What it does |
|---|-----------|-------------|
| 1 | **honesty** | Prevents hallucination. If Claude doesn't know, it says so instead of fabricating. |
| 2 | **depth** | Matches response length to question complexity. No padding, no over-explaining. |
| 3 | **investigation** | Forces reading before writing. No guessing at file contents or API signatures. |
| 4 | **reasoning** | Triggers step-back reasoning on hard problems. Understand why, then solve. |
| 5 | **verification** | Self-checks against the original request before finalizing. |
| 6 | **correction** | Accepts corrections without rationalizing. Updates approach immediately. |

## What's NOT Included (and Why)

- **Expert persona** ("You are a senior engineer...") — No measurable accuracy improvement. Just makes responses longer.
- **"Think step by step"** — Modern Claude models already do chain-of-thought internally. Redundant instruction.
- **Magic phrases** ("Take a deep breath", "This is important for my career") — No generalizable effect. Works in cherry-picked examples at best.
- **Forced long reasoning chains** — Research shows shorter, focused chains often outperform verbose ones.

## How It Works

1. Plugin registers a `SessionStart` hook via `hooks/hooks.json`
2. On every new Claude Code session, `hooks-handlers/session-start.sh` runs
3. The script outputs a JSON object with `additionalContext` to stdout
4. Claude Code injects this context as a `system-reminder`, making the principles active for the entire session

The total prompt injection is ~170 words — small enough to have negligible impact on context window usage.

## Research

See [docs/research.md](docs/research.md) for detailed citations and reasoning behind each principle.

## Toggle / Uninstall

```bash
# Disable temporarily
claude plugin disable wowclaude

# Re-enable
claude plugin enable wowclaude

# Remove completely
claude plugin remove wowclaude
```

## License

[MIT](LICENSE)
