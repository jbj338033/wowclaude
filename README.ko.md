# wowclaude

**한 번 설치하면, Claude Code 응답 품질이 영구적으로 개선됩니다.**

매 세션 시작 시 근거 기반 품질 원칙 5가지를 주입하는 Claude Code 플러그인. 설정 불필요.

## 설치

```bash
/plugin marketplace add jbj338033/wowclaude
/plugin install wowclaude
```

## 5가지 원칙

| # | 원칙 | 설명 |
|---|------|------|
| 1 | **certainty** | 고위험 주제(컴파일러 내부, 런타임 플래그, 비공개 API)에서 허구 생성을 방지. 불확실한 주장에 "iirc", "likely" 등 신뢰도 표시를 강제. |
| 2 | **investigation** | 작성 전 읽기를 강제. 파일 내용이나 API 시그니처를 추측하지 않음. 도구로 검증하고, 검증 불가하면 그렇다고 말함. |
| 3 | **reasoning** | 어려운 문제에서 step-back 추론을 유도. 왜인지 이해한 후 해결. |
| 4 | **precision** | 복잡도에 맞게 응답 수준을 조절. 불확실할 때는 거짓 자신감보다 한정어와 함께 짧게 답변. |
| 5 | **verification** | 최종 답변 전 원래 요청과 대조하여 자가 점검. |

## 포함하지 않은 것 (그리고 이유)

- **전문가 페르소나** ("당신은 시니어 엔지니어입니다...") — 정확도 향상 효과 없음. 응답만 길어짐.
- **"단계별로 생각하세요"** — 최신 Claude 모델은 이미 내부적으로 chain-of-thought 추론을 수행. 중복 지시.
- **마법의 문구** ("심호흡하세요", "제 커리어에 매우 중요합니다") — 일반화 가능한 효과 없음. 체리픽된 예시에서만 작동.
- **강제 장문 추론 체인** — 연구에 따르면 짧고 집중된 체인이 장황한 것보다 더 나은 성능을 보임.

## 작동 방식

1. 플러그인이 `hooks/hooks.json`을 통해 `SessionStart` 훅을 등록
2. 매 Claude Code 세션 시작 시 `hooks-handlers/session-start.sh`가 실행
3. 스크립트가 `additionalContext`가 포함된 JSON 객체를 stdout으로 출력
4. Claude Code가 이 컨텍스트를 `system-reminder`로 주입하여 전체 세션에서 원칙이 활성화

총 프롬프트 주입량은 약 147단어 — 컨텍스트 윈도우에 미치는 영향이 무시할 수 있을 정도로 작음.

## 연구 자료

각 원칙의 상세한 인용 및 근거는 [docs/research.md](docs/research.md)를 참고하세요.

## 비활성화 / 제거

```bash
# 일시적으로 비활성화
/plugin disable wowclaude

# 다시 활성화
/plugin enable wowclaude

# 완전히 제거
/plugin uninstall wowclaude
```

## 라이선스

[MIT](LICENSE)
