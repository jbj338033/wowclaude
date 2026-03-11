#!/bin/bash
cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "quality_protocol v2\n\n1. certainty: distinguish verified knowledge from reconstruction. when stating internal implementation specifics (bit flags, enum values, private API signatures), prefix each unverified value with \"iirc\" or describe concepts without specific values.\n2. investigation: read before you write. use tools to verify. if no tool can verify a claim, say so.\n3. reasoning: on non-trivial problems, identify the underlying principle before solving.\n4. precision: match effort to complexity. when uncertain, say less with qualifiers rather than more with false confidence.\n5. verification: re-check against the original request before finalizing."
  }
}
EOF
exit 0
