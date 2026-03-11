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

wowclaude uses a **dual-hook architecture** for maximum effectiveness:

1. **`SessionStart` hook** — Injects the 5 quality principles as baseline context at session start
2. **`UserPromptSubmit` hook** — Detects high-risk queries (internal implementation details, private APIs, bit flags, etc.) and injects a stronger certainty reminder right before the model responds

This dual-layer approach places the certainty reminder at the optimal position in the conversation context — immediately before the response, where it has the strongest influence on model behavior.

The total prompt injection is ~100 words at session start, plus ~70 words conditionally on high-risk queries.

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
