# Research Notes

Evidence and reasoning behind each principle in wowclaude.

## 1. Honesty — Hallucination Prevention

LLMs hallucinate when pressured to always provide an answer. Explicitly permitting "I don't know" reduces confabulation.

- Anthropic's own usage guidelines recommend instructing Claude to acknowledge uncertainty rather than guess: [Anthropic Documentation — Give Claude room to say "I don't know"](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct#give-claude-room-to-say-i-dont-know)
- Ji et al. (2023), "Survey of Hallucination in Natural Language Generation" — establishes that instruction-tuned models reduce hallucination rates when explicitly told uncertainty is acceptable.

## 2. Depth — Adaptive Response Length

Overly verbose responses dilute accuracy and waste context window. Matching depth to complexity improves both precision and user experience.

- Anthropic's prompt engineering guide recommends being specific about desired output length and detail level: [Anthropic Documentation — Be clear and direct](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct)
- Empirically, padding responses with unnecessary explanation increases the surface area for errors without adding value.

## 3. Investigation — Read Before Write

In code assistance, acting on assumptions about file contents or API signatures is a primary source of errors.

- Anthropic recommends providing Claude with relevant context and source material rather than expecting it to guess: [Anthropic Documentation — Use examples](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-examples)
- This principle is essentially "ground your responses in evidence" applied to the coding domain. The tool-use paradigm in Claude Code (Read, Grep, Glob) exists precisely for this purpose.

## 4. Reasoning — Step-Back Prompting

Step-back prompting asks the model to identify the underlying principle before solving a specific problem, improving accuracy on complex tasks.

- Zheng et al. (2023), "Take a Step Back: Evoking Reasoning via Abstraction in Large Language Models" — demonstrated that step-back prompting improves performance on STEM, knowledge QA, and multi-hop reasoning benchmarks. [arXiv:2310.06117](https://arxiv.org/abs/2310.06117)
- This is distinct from generic "think step by step" — it specifically asks for abstraction and principle identification, not just sequential reasoning.

## 5. Verification — Self-Consistency Check

Having the model re-check its output against the original request catches drift and misinterpretation.

- Anthropic recommends asking Claude to verify its own work: [Anthropic Documentation — Ask Claude to think step by step](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/think-step-by-step)
- Madaan et al. (2023), "Self-Refine: Iterative Refinement with Self-Feedback" — showed that self-review passes improve output quality across tasks. [arXiv:2303.17651](https://arxiv.org/abs/2303.17651)

## 6. Correction — Error Acknowledgment

When models rationalize errors instead of accepting corrections, they compound mistakes. Direct acknowledgment breaks this pattern.

- Anthropic's documentation on multi-turn conversations emphasizes the importance of Claude updating its understanding based on user feedback: [Anthropic Documentation — Multi-turn conversations](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multi-turn-tips)
- This principle prevents the "sycophancy trap" where models agree superficially but don't actually change behavior.

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
