# Research Notes

Evidence and reasoning behind each principle in wowclaude.

## 1. Certainty — Confabulation Prevention via Category Triggers

LLMs hallucinate when pressured to always provide an answer. But the deeper problem is that models often don't recognize they're uncertain — they reconstruct plausible-sounding details from training patterns and present them as fact.

The v1 "honesty" principle ("if you don't know, say so") assumes the model can detect its own uncertainty. Testing revealed this fails for **internal implementation details** — the model confidently listed specific React fiber flags that couldn't be verified, because the training data contains enough surrounding context to make reconstruction feel "certain."

The fix: explicitly enumerate high-risk categories (compiler internals, runtime flags, private APIs, undocumented behavior) so the model triggers uncertainty markers automatically, regardless of subjective confidence.

- Anthropic's own usage guidelines recommend instructing Claude to acknowledge uncertainty rather than guess: [Anthropic Documentation — Give Claude room to say "I don't know"](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct#give-claude-room-to-say-i-dont-know)
- Ji et al. (2023), "Survey of Hallucination in Natural Language Generation" — establishes that instruction-tuned models reduce hallucination rates when explicitly told uncertainty is acceptable.
- Kadavath et al. (2022), "Language Models (Mostly) Know What They Know" — shows models have some calibration ability but systematically overestimate confidence on details outside their reliable knowledge boundary.

## 2. Investigation — Read Before Write

In code assistance, acting on assumptions about file contents or API signatures is a primary source of errors. v2 strengthens this with "use tools to verify. if no tool can verify a claim, say so" — closing the gap where the model might skip verification and reconstruct from memory.

- Anthropic recommends providing Claude with relevant context and source material rather than expecting it to guess: [Anthropic Documentation — Use examples](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-examples)
- This principle is essentially "ground your responses in evidence" applied to the coding domain. The tool-use paradigm in Claude Code (Read, Grep, Glob) exists precisely for this purpose.

## 3. Reasoning — Step-Back Prompting

Step-back prompting asks the model to identify the underlying principle before solving a specific problem, improving accuracy on complex tasks.

- Zheng et al. (2023), "Take a Step Back: Evoking Reasoning via Abstraction in Large Language Models" — demonstrated that step-back prompting improves performance on STEM, knowledge QA, and multi-hop reasoning benchmarks. [arXiv:2310.06117](https://arxiv.org/abs/2310.06117)
- This is distinct from generic "think step by step" — it specifically asks for abstraction and principle identification, not just sequential reasoning.

## 4. Precision — Calibrated Verbosity

v1's "depth" principle focused on matching response length to complexity. v2's "precision" shifts the focus: when uncertain, say less with qualifiers rather than more with false confidence. This works in tandem with "certainty" — the model should prefer a shorter qualified statement over a longer confident-sounding one.

- Anthropic's prompt engineering guide recommends being specific about desired output length and detail level: [Anthropic Documentation — Be clear and direct](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct)
- Empirically, padding responses with unnecessary explanation increases the surface area for errors without adding value.

## 5. Verification — Self-Consistency Check

Having the model re-check its output against the original request catches drift and misinterpretation.

- Anthropic recommends asking Claude to verify its own work: [Anthropic Documentation — Ask Claude to think step by step](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/think-step-by-step)
- Madaan et al. (2023), "Self-Refine: Iterative Refinement with Self-Feedback" — showed that self-review passes improve output quality across tasks. [arXiv:2303.17651](https://arxiv.org/abs/2303.17651)

---

## Removed in v2

### Correction (v1 principle #6)

Testing showed Opus 4.6 already handles corrections well — it acknowledges errors directly and updates its approach without rationalization. Including this principle consumed word budget better allocated to "certainty," which addresses a weakness the model does not self-correct.

---

## What We Excluded (and Why)

### Expert Persona Prompting
"You are a world-class senior engineer..." — While role prompting can adjust tone, controlled studies show minimal impact on factual accuracy. It primarily increases verbosity.

### "Think Step by Step"
Modern Claude models (3.5 Sonnet, Opus, etc.) perform chain-of-thought reasoning internally via extended thinking. Adding this instruction is redundant and can actually degrade performance by forcing unnecessary verbosity on simple tasks.

### Magic Phrases
Phrases like "Take a deep breath", "This is very important to my career", or "I'll tip you $200" show no consistent, generalizable improvement. Viral examples are cherry-picked and don't replicate across diverse tasks.

### Forced Long Reasoning Chains
Wei et al. (2022) showed chain-of-thought helps, but subsequent work (e.g., Wang et al., 2022, "Self-Consistency") demonstrated that quality of reasoning matters more than quantity. Forcing lengthy chains can introduce more opportunities for error.
