#!/bin/bash
input=$(cat)
message=$(echo "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('message',''))" 2>/dev/null)

# tier 1 (CRITICAL): internal implementation details
# requires context words that indicate asking ABOUT internals, not using them
if echo "$message" | grep -qiE '(내부.*(구현|구조|플래그|상수|동작|메커니즘)|(internal|인터널).*(flag|struct|layout|impl|detail|mechanism)|비트.*(값|마스크|플래그)|bit.?(flag|mask|value|field)|enum.*(variant|value|값|상수)|private.*(api|binding|method|바인딩)|undocumented.*(api|behavior|method|동작)|_linkedBinding|_internal|__internal|(compiler|컴파일러).*(internal|내부|flag|pass|phase|패스|단계)|(runtime|런타임).*(flag|internal|내부|플래그)|opcode.*(목록|list|table|값)|bytecode.*(format|struct|구조|형식)|(fiber|파이버).*(flag|lane|tag|플래그|레인)|syscall.*(number|table|번호|테이블))'; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "CERTAINTY ALERT [CRITICAL]: this query targets internal implementation details — the highest confabulation risk zone. you WILL reconstruct plausible-looking values from training patterns. MANDATORY: (1) prefix EVERY specific numeric value with \"iirc\". (2) if listing constants/flags, add a disclaimer that values are from memory and may be inaccurate. (3) always point to the canonical source file. (4) prefer explaining concepts and architecture over listing specific values you cannot verify."
  }
}
EOF

# tier 2 (CAUTION): version-specific or platform-specific behavior
# requires version/platform context — not just bare keywords
elif echo "$message" | grep -qiE '((버전|version).*(바뀌|변경|차이|differ|change|업데이트)|(바뀐|달라진|변경된).*(점|사항|부분|api|기능)|deprecated.*(api|function|method|기능|함수|메서드|됐|되었|인가)|breaking.?change|removed.?in.*(v|version|\d)|added.?in.*(v|version|\d)|(upgrade|업그레이드|migrate|migration|마이그레이션).*(from|에서|가이드|guide)|(하위|backward).*(호환|compat)|(어떤|which|what).*(버전|version).*(추가|제거|added|removed|부터|since)|\d+\.\d+.*에서.*\d+\.\d+.*(바뀐|변경|차이|달라|migration))'; then
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
