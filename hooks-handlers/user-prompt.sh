#!/bin/bash
input=$(cat)
message=$(echo "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('message',''))" 2>/dev/null)

if echo "$message" | grep -qiE '(내부|internal|플래그|flag|비트|bit.?값|enum|struct|private.*(api|binding)|undocumented|_linkedBinding|compiler.*internal|runtime.*flag|바이트.*오프셋|byte.*offset|소스.*코드.*구조)'; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "CERTAINTY ALERT: this query involves internal implementation details — a high-confabulation zone. you are about to reconstruct specific values from training patterns, NOT from verified sources. RULES: (1) DO NOT present specific numeric values (bit flags, hex constants, enum values, byte offsets) as fact. (2) prefix EVERY unverified specific value with \"iirc\" — no exceptions. (3) if you cannot verify with a tool, state this explicitly and point to the source file. (4) prefer describing concepts and names WITHOUT numeric values over listing unverified numbers."
  }
}
EOF
else
  echo '{}'
fi
exit 0
