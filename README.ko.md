# wowclaude

**한 번 설치하면, Claude Code 응답 품질이 영구적으로 개선됩니다.**

다층 hook을 사용하여 근거 기반 품질 원칙을 주입하는 Claude Code 플러그인. 설정 불필요.

## TL;DR

Claude Code는 내부 구현 상세(비트 플래그, private API 등)를 물어보면 그럴듯하게 지어냅니다. 이 플러그인은 그런 위험한 질문을 감지해서 "iirc" 마커를 강제하고, 파일을 읽지 않고 수정하는 것도 방지합니다. hook 3개, 설정 0개, 프롬프트 주입량 총 ~150 단어.

## 설치

```bash
/plugin marketplace add jbj338033/wowclaude
/plugin install wowclaude
```

## 5가지 원칙

| # | 원칙 | 설명 |
|---|------|------|
| 1 | **certainty** | 고위험 주제에서 허구 생성을 방지. 검증되지 않은 내부 상세에 "iirc" 마커 강제. |
| 2 | **investigation** | 작성 전 읽기를 강제. 도구로 검증, 불가하면 불가하다고 말함. |
| 3 | **reasoning** | 어려운 문제에서 step-back 추론. 왜인지 이해 후 해결. |
| 4 | **precision** | 복잡도에 맞는 응답. 거짓 자신감보다 한정어와 함께 짧게. |
| 5 | **verification** | 최종 답변 전 원래 요청과 대조 자가 점검. |

## 아키텍처

```
┌─────────────────────────────────────────────────────────┐
│                    wowclaude hooks                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  SessionStart          → 기본 품질 원칙                  │
│  │                       (항상 활성)                     │
│  ▼                                                      │
│  UserPromptSubmit      → 메시지별 위험 감지              │
│  │  ├─ CRITICAL 단계   → 내부 구현, 비트 플래그           │
│  │  ├─ CAUTION 단계    → 버전별 동작, deprecated          │
│  │  └─ (트리거 없음)    → 일반 쿼리는 통과                │
│  ▼                                                      │
│  PreToolUse            → 편집 가드                       │
│     └─ Edit/Write      → "이 파일을 읽었나요?"           │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Hook 상세

| Hook | 이벤트 | 트리거 | 주입량 |
|------|--------|--------|--------|
| **session-start.sh** | `SessionStart` | 매 세션 | 5가지 품질 원칙 (~90 단어) |
| **user-prompt.sh** | `UserPromptSubmit` | 매 메시지 | CRITICAL: ~60 단어 / CAUTION: ~40 단어 / 없음 |
| **pre-tool-use.sh** | `PreToolUse` | Edit/Write 전 | investigation 리마인더 (~20 단어) |

### 다단계 위험 감지

**CRITICAL** — 내부 구현 상세 (최고 허구 생성 위험):
- 비트 플래그, enum 값, struct 필드, 바이트코드 형식
- 비공개/문서화되지 않은 API, 컴파일러 내부
- 런타임 플래그, syscall 테이블, fiber 내부

**CAUTION** — 버전별/플랫폼별 동작:
- 호환성 변경, deprecated 기능, 마이그레이션 경로
- 버전 경계 동작, 플랫폼 차이

**Safe** — 일반 쿼리에는 개입 없음.

## 테스트 결과

플러그인 설치 전후 동일 프롬프트로 테스트:

| 테스트 | wowclaude 없이 | wowclaude 적용 |
|--------|---------------|----------------|
| "React fiber 플래그 비트 값 나열" | 구체적 hex 값을 사실로 나열 | "iirc" 접두사, 소스 파일 안내 |
| "`process._linkedBinding` 시그니처" | 전체 API를 자신있게 나열 | 미검증 명시, 소스 확인 권장 |
| "git stash는 뭐야?" | 간결한 답변 | 간결한 답변 (불필요한 개입 없음) |

## 포함하지 않은 것 (그리고 이유)

- **전문가 페르소나** — 정확도 향상 효과 없음. 응답만 길어짐.
- **"단계별로 생각하세요"** — 이미 내부적으로 chain-of-thought 수행. 중복 지시.
- **마법의 문구** — 일반화 가능한 효과 없음.
- **강제 장문 추론** — 짧고 집중된 체인이 더 나은 성능.

## 연구 자료

[docs/research.md](docs/research.md)에서 상세한 인용 및 근거를 확인하세요.

## 비활성화 / 제거

```bash
/plugin disable wowclaude    # 일시적으로 비활성화
/plugin enable wowclaude     # 다시 활성화
/plugin uninstall wowclaude  # 완전히 제거
```

## 라이선스

[MIT](LICENSE)
