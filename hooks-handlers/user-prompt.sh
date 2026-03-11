#!/bin/bash
input=$(cat)
message=$(echo "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('message',''))" 2>/dev/null)

# tier 1: internal implementation details (highest confabulation risk)
if echo "$message" | grep -qiE '(내부.*(구현|구조|플래그|상수)|internal.*(flag|struct|layout|impl)|비트.*(값|마스크|플래그)|bit.?(flag|mask|value|field)|enum.*(variant|value|값)|private.*(api|binding|method)|undocumented|_linkedBinding|_internal|compiler.*(internal|flag|pass|phase)|runtime.*(flag|internal)|opcode|bytecode.*(format|struct)|fiber.*(flag|lane|tag)|syscall.*(number|table))'; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "CERTAINTY ALERT [CRITICAL]: this query targets internal implementation details — the highest confabulation risk zone. you WILL reconstruct plausible-looking values from training patterns. MANDATORY: (1) prefix EVERY specific numeric value with \"iirc\". (2) if listing constants/flags, add a disclaimer that values are from memory and may be inaccurate. (3) always point to the canonical source file. (4) prefer explaining concepts and architecture over listing specific values you cannot verify."
  }
}
EOF

# tier 2: version-specific, deprecated, or platform-specific behavior
elif echo "$message" | grep -qiE '(어떤.*버전|which.*version|deprecated|breaking.*change|removed.*in|added.*in|변경.*사항|차이점|differ|바뀌|changed.*between|migration|upgrade.*from|하위.*호환|backward.*compat|platform.*(specific|dependent)|os.*(specific|dependent)|아키텍처.*(차이|specific))'; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "CERTAINTY ALERT [CAUTION]: this query involves version-specific or platform-specific behavior, which changes across releases. state which version/platform you are referencing. if unsure about version boundaries, say \"iirc\" or recommend checking the changelog/release notes."
  }
}
EOF

else
  echo '{}'
fi
exit 0
