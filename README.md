# wowclaude

**Install once, get better Claude Code responses forever.**

A Claude Code plugin that injects 5 evidence-based quality principles at every session start. No configuration needed.

## Installation

```bash
/plugin marketplace add jbj338033/wowclaude
/plugin install wowclaude
```

## The 5 Principles

| # | Principle | What it does |
|---|-----------|-------------|
| 1 | **certainty** | Prevents confabulation on high-risk topics (compiler internals, runtime flags, private APIs). Forces confidence markers like "iirc" or "likely" on uncertain claims. |
| 2 | **investigation** | Forces reading before writing. No guessing at file contents or API signatures. Uses tools to verify; if unverifiable, says so. |
| 3 | **reasoning** | Triggers step-back reasoning on hard problems. Understand why, then solve. |
| 4 | **precision** | Matches response effort to complexity. When uncertain, says less with qualifiers rather than more with false confidence. |
| 5 | **verification** | Self-checks against the original request before finalizing. |

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

The total prompt injection is ~147 words — small enough to have negligible impact on context window usage.

## Research

See [docs/research.md](docs/research.md) for detailed citations and reasoning behind each principle.

## Toggle / Uninstall

```bash
# Disable temporarily
/plugin disable wowclaude

# Re-enable
/plugin enable wowclaude

# Remove completely
/plugin uninstall wowclaude
```

## License

[MIT](LICENSE)
