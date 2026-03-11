# Research Notes

Evidence, test results, and reasoning behind wowclaude.

## Architecture Decisions

### Why Multi-Layered Hooks?

A single `SessionStart` injection placed the quality principles far from the actual response point. Testing showed this was insufficient to override the model's default behavior of confidently presenting reconstructed details.

The solution: **three hooks at different lifecycle stages**, each targeting a different failure mode.

| Hook | Lifecycle Stage | Failure Mode Addressed |
|------|----------------|----------------------|
| `SessionStart` | Session initialization | Baseline reasoning and verification habits |
| `UserPromptSubmit` | Per-message | Confabulation on high-risk queries |
| `PreToolUse` | Before file edits | Editing code without reading it first |

### Why `hookSpecificOutput` Wrapper?

Testing revealed that plain `{"additionalContext": "..."}` output from hook scripts is silently ignored by Claude Code. The correct format requires a `hookSpecificOutput` wrapper with `hookEventName`:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "..."
  }
}
```

This was discovered by comparing against working official plugins (e.g., `learning-output-style`).

### Why Multi-Tier Risk Detection?

Not all queries carry equal confabulation risk. Injecting a strong certainty alert on every message would be wasteful and could reduce the signal-to-noise ratio. The two-tier system (CRITICAL/CAUTION) targets the specific patterns where the model is most likely to confabulate:

- **CRITICAL**: Internal implementation details (bit flags, enum values, private APIs) — the model reconstructs plausible-looking specifics from training patterns
- **CAUTION**: Version-specific behavior — the model may conflate details across versions

---

## Principle Research

### 1. Certainty — Confabulation Prevention via Category Triggers

LLMs hallucinate when pressured to always provide an answer. But the deeper problem is that models often don't recognize they're uncertain — they reconstruct plausible-sounding details from training patterns and present them as fact.

The v1 "honesty" principle ("if you don't know, say so") assumes the model can detect its own uncertainty. Testing revealed this fails for **internal implementation details** — the model confidently listed specific React fiber flags that couldn't be verified, because the training data contains enough surrounding context to make reconstruction feel "certain."

The fix: explicitly enumerate high-risk categories and trigger uncertainty markers automatically, regardless of subjective confidence.

**Key finding**: Even with the category-trigger approach, a `SessionStart`-only injection was insufficient. Adding a `UserPromptSubmit` hook that detects high-risk queries and injects a stronger reminder immediately before the response was critical. This places the instruction at the optimal position in the attention window.

- Anthropic's own usage guidelines recommend instructing Claude to acknowledge uncertainty: [Anthropic Documentation — Give Claude room to say "I don't know"](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct#give-claude-room-to-say-i-dont-know)
- Ji et al. (2023), "Survey of Hallucination in Natural Language Generation" — instruction-tuned models reduce hallucination rates when explicitly told uncertainty is acceptable.
- Kadavath et al. (2022), "Language Models (Mostly) Know What They Know" — models have some calibration ability but systematically overestimate confidence on details outside their reliable knowledge boundary.

### 2. Investigation — Read Before Write

In code assistance, acting on assumptions about file contents or API signatures is a primary source of errors. The `PreToolUse` hook reinforces this at the exact moment of file modification — a micro-reminder that fires only when needed.

- Anthropic recommends providing Claude with relevant context and source material: [Anthropic Documentation — Use examples](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-examples)
- The tool-use paradigm in Claude Code (Read, Grep, Glob) exists precisely for this purpose.

### 3. Reasoning — Step-Back Prompting

Step-back prompting asks the model to identify the underlying principle before solving a specific problem.

- Zheng et al. (2023), "Take a Step Back: Evoking Reasoning via Abstraction in Large Language Models" — improved performance on STEM, knowledge QA, and multi-hop reasoning. [arXiv:2310.06117](https://arxiv.org/abs/2310.06117)
- Distinct from "think step by step" — asks for abstraction and principle identification, not just sequential reasoning.

### 4. Precision — Calibrated Verbosity

When uncertain, say less with qualifiers rather than more with false confidence. Works in tandem with "certainty" — prefer a shorter qualified statement over a longer confident-sounding one.

- Anthropic's prompt engineering guide recommends being specific about output length and detail: [Anthropic Documentation — Be clear and direct](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct)

### 5. Verification — Self-Consistency Check

Re-checking output against the original request catches drift and misinterpretation.

- Madaan et al. (2023), "Self-Refine: Iterative Refinement with Self-Feedback" — self-review passes improve output quality across tasks. [arXiv:2303.17651](https://arxiv.org/abs/2303.17651)

---

## Removed Principles

### Correction (v1 principle #6)

Testing showed Opus 4.6 already handles corrections well. Word budget was reallocated to "certainty."

### Depth (v1 principle #2)

Replaced by "precision." The model already handles response length well; the real issue was false confidence, not verbosity.

### Honesty (v1 principle #1)

Replaced by "certainty." "If you don't know, say so" requires self-awareness of uncertainty, which the model lacks for reconstructed details.

---

## What We Excluded (and Why)

### Expert Persona Prompting
Minimal impact on factual accuracy. Primarily increases verbosity.

### "Think Step by Step"
Modern Claude models perform chain-of-thought reasoning internally. Redundant and can degrade performance on simple tasks.

### Magic Phrases
No consistent, generalizable improvement. Cherry-picked examples don't replicate.

### Forced Long Reasoning Chains
Quality of reasoning matters more than quantity (Wang et al., 2022, "Self-Consistency"). Forcing length introduces more error opportunities.
