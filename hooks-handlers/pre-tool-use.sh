#!/bin/bash
input=$(cat)
tool_name=$(echo "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

case "$tool_name" in
  Edit|Write|NotebookEdit)
    cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "investigation check: have you read and understood this file before modifying it? do not edit code you have not read."
  }
}
EOF
    ;;
  *)
    echo '{}'
    ;;
esac
exit 0
