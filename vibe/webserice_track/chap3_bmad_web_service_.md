# 3회차 학습자 실습 매뉴얼: 웹서비스 트랙

# 웹서비스 repo 구조와 아키텍처
## Architecture → Epic/Story → 구현 준비도 → 서비스 설계 문서 → repo 골격

---

## 이 자료의 목적

3회차의 목표는 코드를 많이 작성하는 것이 아니다. 3회차의 목표는 2회차에서 만든 문서를 바탕으로 **실제로 구현 가능한 웹서비스 프로젝트 구조를 만드는 것**이다.

2회차에서는 다음 문서를 만들었다.

```text
_bmad-output/project-context.md
_bmad-output/product-brief.md
_bmad-output/PRD.md
README.md
```

3회차에서는 이 문서들을 바탕으로 다음 산출물을 만든다.

```text
1. architecture.md
2. Epic / Story 문서
3. 구현 준비도 검증 결과
4. 웹서비스 표준 repo 구조
5. docs/user-flow.md
6. docs/screen-map.md
7. docs/route-map.md
8. docs/data-model-draft.md
9. docs/api-contract-draft.md
10. docs/auth-and-security.md
11. docs/test-plan.md
```

오늘의 핵심 문장은 다음이다.

> PRD가 “어떤 서비스를 만들 것인가”를 말한다면, Architecture는 “그 서비스를 어떤 구조로 구현할 것인가”를 말한다.

3회차가 끝나면 프로젝트는 단순한 아이디어 문서가 아니라, 화면·경로·데이터·API·권한·테스트 기준이 정리된 웹서비스 저장소가 된다.

---

## 오늘 끝나면 있어야 하는 것

3회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
my-web-service/
├── _bmad-output/
│   ├── brainstorming-report.md
│   ├── project-context.md
│   ├── product-brief.md
│   ├── PRD.md
│   ├── architecture.md
│   └── epics-and-stories.md        # 이름은 BMAD 버전에 따라 다를 수 있음
├── docs/
│   ├── user-flow.md
│   ├── screen-map.md
│   ├── route-map.md
│   ├── data-model-draft.md
│   ├── api-contract-draft.md
│   ├── auth-and-security.md
│   └── test-plan.md
├── src/
│   ├── app/
│   ├── components/
│   ├── lib/
│   ├── server/
│   ├── types/
│   └── config/
├── tests/
│   ├── unit/
│   └── e2e/
├── public/
├── README.md
└── package.json                   # 실제 웹 프레임워크를 초기화한 경우 생성됨
```

> [!NOTE]
> BMAD가 만드는 산출물 이름은 설치 버전과 설정에 따라 조금 다를 수 있다. 핵심은 `Architecture 문서`와 `Epic/Story 문서`가 존재하고, 그 내용이 2회차의 `project-context.md` 및 `PRD.md`와 충돌하지 않는다는 점이다.

---

## 오늘 사용할 입력 위치를 구분하자

웹서비스 3회차에서는 입력 위치가 세 가지다.

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `cd my-web-service` |
| `[AI 코딩 도구]` | Gemini CLI 또는 Claude Code 안 | `bmad-create-architecture` |
| `[파일 내용]` | Markdown, TypeScript, 설정 파일 안에 들어갈 내용 | `# User Flow` |

앞으로 모든 실습에는 입력 위치를 표시한다.

예를 들어 아래 명령은 터미널에 입력한다.

```bash
pwd
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
bmad-help
```

---

# 0. 수업 시작 전 준비

## 0.1 터미널을 연다

Windows에서는 PowerShell을 연다.

```text
1. Windows 키를 누른다.
2. PowerShell이라고 입력한다.
3. Windows PowerShell을 클릭한다.
```

PowerShell이 열리면 보통 이런 모양이다.

```powershell
PS C:\Users\내이름>
```

Mac에서는 Terminal을 연다.

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

Mac 터미널이 열리면 보통 이런 모양이다.

```bash
내이름@MacBook ~ %
```

앞으로 “터미널”이라고 하면 Windows에서는 PowerShell, Mac에서는 Terminal을 뜻한다.

---

## 0.2 프로젝트 폴더로 이동한다

2회차에서 만든 웹서비스 프로젝트 폴더로 이동한다. 이 자료에서는 폴더 이름을 `my-web-service`라고 가정한다. 본인의 폴더 이름이 다르면 그 이름을 사용한다.

### Windows PowerShell

```powershell
cd $HOME
cd my-web-service
```

### Mac Terminal

```bash
cd ~
cd my-web-service
```

현재 위치를 확인한다.

```bash
pwd
```

정상이라면 대략 이런 결과가 나온다.

Windows 예시:

```text
C:\Users\내이름\my-web-service
```

Mac 예시:

```text
/Users/내이름/my-web-service
```

> [!IMPORTANT]
> 오늘 모든 명령은 프로젝트 폴더 안에서 실행한다. `pwd` 결과가 프로젝트 폴더가 아니면 먼저 프로젝트 폴더로 이동한다.

---

## 0.3 2회차 산출물이 있는지 확인한다

3회차는 2회차 산출물이 있어야 진행할 수 있다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 네 개 파일이 있어야 한다.

```text
brainstorming-report.md
project-context.md
product-brief.md
PRD.md
```

파일이 없다면 3회차를 바로 진행하지 않는다. 먼저 2회차 산출물을 보완해야 한다.

AI 코딩 도구에서 다음과 같이 확인할 수도 있다.

[AI 코딩 도구]

```text
Check whether the following files exist:

_bmad-output/brainstorming-report.md
_bmad-output/project-context.md
_bmad-output/product-brief.md
_bmad-output/PRD.md

If any file is missing, tell me exactly which previous workflow I should run.
```

---

## 0.4 AI 코딩 도구를 실행한다

Gemini CLI를 사용하는 경우, 터미널에서 다음을 입력한다.

```bash
gemini
```

Claude Code를 사용하는 경우, 터미널에서 다음을 입력한다.

```bash
claude
```

AI 코딩 도구가 열리면 다음 명령으로 현재 프로젝트 상태를 확인한다.

[AI 코딩 도구]

```text
bmad-help
```

정상적인 상황에서는 BMAD가 현재 프로젝트 상태를 읽고 다음 단계로 Architecture 생성을 권장해야 한다.

---

# 1. 2회차 과제 확인

## 1.1 PRD를 다시 읽었는가

웹서비스에서 PRD가 모호하면 구현 단계에서 AI가 임의의 결정을 하게 된다. 그러면 화면, API, 데이터베이스, 인증 방식이 서로 어긋난다.

3회차 시작 전에 다음 질문을 확인한다.

```text
1. 이 서비스의 대상 사용자는 명확한가?
2. 사용자 역할이 구분되어 있는가? 예: 일반 사용자, 관리자, 운영자
3. 핵심 사용자 흐름이 단계별로 적혀 있는가?
4. 필요한 화면 또는 페이지 목록이 있는가?
5. 기능 요구사항이 구체적인가?
6. 데이터 모델 요구사항이 최소한으로 정의되어 있는가?
7. API 요구사항이 있는가?
8. 인증과 권한이 필요한지 명확한가?
9. 개인정보, 보안, 결제 관련 주의사항이 적혀 있는가?
10. 초기 버전에서 하지 않을 것이 명확한가?
```

아직 모호하다면 AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구]

```text
Open _bmad-output/PRD.md and review it using this web service checklist:

1. Are target users clear?
2. Are user roles separated?
3. Is the core user journey described step by step?
4. Are pages or screens listed?
5. Are functional requirements concrete?
6. Are data model requirements specific enough?
7. Are API requirements present?
8. Are authentication and authorization requirements clear?
9. Are privacy, security, and payment concerns documented if relevant?
10. Are out-of-scope items clear?

If any item is weak, suggest a revision.
Do not implement yet.
Do not invent security, payment, or privacy decisions.
Ask me if a project decision is needed.
```

---

## 1.2 핵심 사용자 흐름이 있는가

웹서비스 4회차에서는 실제 MVP 골격을 구현하기 시작한다. 그러려면 3회차에서 핵심 사용자 흐름을 먼저 정해야 한다.

핵심 사용자 흐름 예시는 다음과 같다.

```text
1. 사용자가 홈 화면에 접속한다.
2. 사용자가 서비스의 목적을 이해한다.
3. 사용자가 회원가입 또는 로그인을 한다.
4. 사용자가 핵심 정보를 입력한다.
5. 시스템이 결과를 저장하거나 보여준다.
6. 사용자가 결과를 다시 조회한다.
7. 관리자가 필요한 경우 데이터를 확인하거나 상태를 변경한다.
```

사용자 흐름이 아직 없다면 AI 코딩 도구에서 다음을 입력한다.

[AI 코딩 도구]

```text
Based on _bmad-output/PRD.md, create a draft core user flow for this web service.

Rules:
- Use numbered steps.
- Identify the actor for each step.
- Identify the page or screen for each step.
- Identify what the system must do.
- Mark uncertain assumptions explicitly.
- Do not add payment, admin, or authentication features unless PRD requires them.
```

---

# 2. 실습 1 — Architecture 작성

## 2.1 Architecture는 무엇인가

PRD는 “무엇을 만들 것인가”를 정리한 문서다. Architecture는 “어떤 구조로 만들 것인가”를 정리한 문서다.

웹서비스 프로젝트에서 Architecture는 다음을 정한다.

```text
어떤 기술 스택을 사용할 것인가?
화면과 라우트는 어디에 둘 것인가?
컴포넌트는 어떻게 분리할 것인가?
API는 어떤 구조로 만들 것인가?
데이터 모델은 어떤 책임을 갖는가?
인증과 권한은 어디에서 검사할 것인가?
환경변수와 API key는 어떻게 관리할 것인가?
테스트는 어떤 수준에서 작성할 것인가?
배포 환경과 로컬 환경은 어떻게 구분할 것인가?
```

이 수업의 기본 방향은 다음이다.

```text
사용자 흐름을 먼저 정한다.
화면 목록을 사용자 흐름과 연결한다.
API 요구사항을 기능 요구사항과 연결한다.
데이터 모델을 API와 화면 요구사항에서 도출한다.
보안과 개인정보 관련 결정은 AI가 임의로 하지 않는다.
```

---

## 2.2 새 세션을 연다

BMAD workflow를 새로 시작할 때는 이전 대화 맥락을 지운다.

[AI 코딩 도구]

```text
/clear
```

그다음 Architecture workflow를 실행한다.

[AI 코딩 도구]

```text
bmad-create-architecture
```

BMAD의 Architect 역할은 보통 Winston이라고 불린다. Winston은 PRD와 project-context를 읽고 기술 구조를 설계한다.

---

## 2.3 Winston에게 답할 때의 기준

Winston이 질문하면 아래 기준으로 답한다. 실제 프로젝트에서 이미 정해진 기술 스택이 있다면 그 값을 사용한다. 정해지지 않았다면 수업 표준 스택을 사용한다.

| Winston의 질문 | 답변 기준 |
|---|---|
| 어떤 종류의 프로젝트인가? | 웹서비스 또는 SaaS MVP |
| 사용자는 누구인가? | PRD의 target users를 따른다 |
| 사용자 역할은 무엇인가? | 일반 사용자, 관리자, 운영자 등 PRD 기준 |
| 프론트엔드는 무엇을 사용할 것인가? | 수업 표준: Next.js, React, TypeScript |
| 스타일링은 무엇을 사용할 것인가? | 수업 표준: Tailwind CSS |
| 백엔드는 무엇을 사용할 것인가? | 수업 표준: Next.js API Routes 또는 서버 모듈 |
| 데이터베이스는 무엇을 사용할 것인가? | 미정이면 draft만 작성하고 확정하지 않음 |
| 인증은 필요한가? | PRD에 따라 결정. 미정이면 질문 필요 |
| 배포는 어디에 할 것인가? | 미정이면 배포 요구사항만 문서화 |
| 테스트는 무엇을 할 것인가? | 핵심 사용자 흐름, 폼 검증, API 오류, 권한 검사 |
| 결제나 개인정보가 있는가? | 있으면 별도 확인 필요. AI가 임의 결정 금지 |

---

## 2.4 Winston에게 줄 수 있는 답변 예시

Winston이 전체 구조를 묻거나 기술 방향을 확인하면 다음 답변을 사용할 수 있다.

[AI 코딩 도구]

```text
This project is a web service project, not a data analysis repository.

Use this architecture direction:

- Prioritize the core user flow from the PRD.
- Use a frontend-first MVP structure.
- Default teaching stack: Next.js, React, TypeScript, and Tailwind CSS.
- Keep API and server-side logic separated from UI components.
- Define pages/screens from the user journey.
- Define route map, data model draft, and API contract draft before implementation.
- If authentication is required, define roles and permission boundaries clearly.
- Do not make assumptions about privacy, payments, or sensitive data.
- Do not hard-code API keys or environment variables.
- Create tests for core user flows, form validation, API behavior, and authorization rules.
- If the database or deployment platform is not decided, document options and ask before choosing.

Please create an architecture that follows _bmad-output/project-context.md and _bmad-output/PRD.md.
```

---

## 2.5 Architecture 성공 기준

Architecture 문서에는 최소한 다음이 있어야 한다.

```text
1. 서비스 개요
2. 기술 스택
3. 사용자 역할과 권한 방향
4. 화면 또는 라우트 구조
5. 컴포넌트 구조
6. API 구조
7. 데이터 모델 방향
8. 인증과 보안 원칙
9. 환경변수 관리 원칙
10. 배포와 운영 방향
11. 테스트 전략
12. 구현 전 확인해야 할 미정 사항
```

AI 코딩 도구에 다음을 입력해 점검한다.

[AI 코딩 도구]

```text
Review the generated architecture.
Check whether it includes:

1. service overview
2. technology stack
3. user roles and permission direction
4. page or route structure
5. component structure
6. API structure
7. data model direction
8. authentication and security principles
9. environment variable management
10. deployment direction
11. test strategy
12. unresolved decisions

If anything is missing, revise the architecture.
Do not make privacy, payment, database, or authentication decisions without confirmation.
```

---

## 2.6 산출물 확인

터미널에서 `_bmad-output` 폴더를 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 중 하나가 보여야 한다.

```text
architecture.md
```

또는 BMAD 설정에 따라 architecture 관련 폴더나 조각 파일이 보일 수 있다.

AI 코딩 도구에서 이렇게 확인해도 된다.

[AI 코딩 도구]

```text
Find the architecture output file or files created by BMAD.
Show me their paths.
```

---

# 3. Epic과 Story 이해하기

## 3.1 Epic이란 무엇인가

Epic은 큰 작업 묶음이다. 책에 비유하면 “장”이다.

웹서비스 프로젝트의 Epic은 다음과 같을 수 있다.

```text
Epic 1. 프로젝트 골격과 개발 환경 정리
Epic 2. 사용자 흐름과 화면 구조 설계
Epic 3. 라우트와 페이지 구현 준비
Epic 4. 재사용 컴포넌트 설계
Epic 5. 데이터 모델과 API 계약 정리
Epic 6. 인증과 권한 구조 정리
Epic 7. 핵심 사용자 기능 구현 준비
Epic 8. 테스트와 품질 검증 준비
Epic 9. 배포와 운영 준비
```

Epic은 너무 작으면 안 된다. Epic 하나는 여러 개의 Story를 포함해야 한다.

---

## 3.2 Story란 무엇인가

Story는 Epic 안의 작은 작업 단위다. 책에 비유하면 “절”이다.

좋은 Story는 다음 질문에 답해야 한다.

```text
무엇을 만들 것인가?
어떤 파일을 만들거나 수정할 것인가?
완료 기준은 무엇인가?
어떤 테스트가 필요한가?
```

나쁜 Story 예시:

```text
로그인 만들기
```

좋은 Story 예시:

```text
Story: 로그인 화면의 입력 검증 기준을 작성한다.

목표:
docs/screen-map.md와 docs/test-plan.md에 로그인 화면의 필수 입력값, 오류 메시지, 성공 조건을 정의한다.

파일:
- docs/screen-map.md
- docs/test-plan.md

수용 기준:
- 이메일 입력 필드의 필수 여부가 명시되어 있다.
- 비밀번호 입력 필드의 필수 여부가 명시되어 있다.
- 잘못된 입력에 대한 오류 메시지 기준이 있다.
- 로그인 성공 후 이동할 화면이 명시되어 있다.

테스트 요구사항:
- 빈 이메일 입력 시 오류 메시지를 확인한다.
- 빈 비밀번호 입력 시 오류 메시지를 확인한다.
- 성공 시 대시보드로 이동하는 흐름을 확인한다.
```

---

## 3.3 좋은 Story의 구성 요소

| 항목 | 설명 |
|---|---|
| 목표 | 무엇을 만드는가 |
| 파일 목록 | 어떤 파일을 생성하거나 수정하는가 |
| 수용 기준 | 어떤 상태가 되면 완료인가 |
| 테스트 요구사항 | 어떤 테스트를 작성하는가 |
| 의존성 | 어떤 이전 Story가 먼저 완료되어야 하는가 |
| 위험 | 인증, 개인정보, 결제 등 확인이 필요한 요소 |

Story가 명확해야 AI가 구현할 때 길을 잃지 않는다.

---

# 4. 실습 2 — Epic/Story 생성

## 4.1 새 세션을 연다

[AI 코딩 도구]

```text
/clear
```

Epic/Story workflow를 실행한다.

[AI 코딩 도구]

```text
bmad-create-epics-and-stories
```

John은 PRD와 Architecture를 읽고 구현 가능한 Epic과 Story로 나눈다.

---

## 4.2 John에게 줄 수 있는 추가 지시

John이 범위를 확인하거나 Story 작성 기준을 물으면 다음을 입력할 수 있다.

[AI 코딩 도구]

```text
Create epics and stories for a web service MVP.

Use these rules:

- Minimum 8 epics
- Each epic should have 2 to 5 stories
- Each story must include goal, files to create or modify, acceptance criteria, and test requirements
- Stories must follow the architecture document
- Include stories for user flow, screen map, route map, data model draft, API contract draft, authentication/security rules, test plan, and README update
- Do not implement complex features before the structure is ready
- Do not add payment, advanced analytics, multi-language support, or mobile app development unless PRD explicitly requires them
- If privacy, payment, security, or authentication decisions are unclear, mark them as unresolved decisions instead of inventing them
```

---

## 4.3 Epic/Story 성공 기준

Epic/Story 문서는 다음 기준을 만족해야 한다.

```text
1. 최소 8개 Epic이 있다.
2. 각 Epic에는 2~5개 Story가 있다.
3. 각 Story에 목표가 있다.
4. 각 Story에 파일 경로가 있다.
5. 각 Story에 완료 기준이 있다.
6. 각 Story에 테스트 요구사항이 있다.
7. 화면, 라우트, API, 데이터 모델, 인증, 테스트 관련 Story가 포함되어 있다.
8. 초기 버전 범위를 벗어난 Story가 없다.
```

AI 코딩 도구에 다음을 입력해 점검한다.

[AI 코딩 도구]

```text
Review the generated epics and stories.
Check whether:

1. there are at least 8 epics,
2. each epic has 2 to 5 stories,
3. each story has goal, files, acceptance criteria, and test requirements,
4. screen, route, API, data model, authentication/security, and test planning are covered,
5. no out-of-scope features are included for the initial version.

If anything is missing, revise the epics and stories.
```

---

## 4.4 산출물 확인

AI 코딩 도구에서 다음을 입력한다.

[AI 코딩 도구]

```text
Find the epics and stories output created by BMAD.
Show me the file path or paths.
```

터미널에서도 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

보통 다음과 비슷한 파일 또는 폴더가 있어야 한다.

```text
epics-and-stories.md
stories/
```

BMAD 버전에 따라 이름은 다를 수 있다.

---

# 5. 실습 3 — 구현 준비도 검증

## 5.1 구현 준비도 검증이란 무엇인가

구현 준비도 검증은 다음 질문에 답한다.

> 지금 이 웹서비스 프로젝트는 실제 구현을 시작할 만큼 충분히 준비되었는가?

검증 결과는 보통 세 가지 중 하나다.

| 결과 | 의미 | 해야 할 일 |
|---|---|---|
| PASS | 문서가 일관적이고 구현을 시작할 수 있음 | 다음 단계로 진행 |
| CONCERNS | 일부 불일치나 누락이 있음 | 지적 사항 수정 후 재검증 |
| FAIL | 심각한 누락이 있음 | PRD 또는 Architecture로 돌아가 수정 |

웹서비스에서는 다음 문제가 자주 CONCERNS 또는 FAIL을 만든다.

```text
사용자 역할이 불명확함
인증 필요 여부가 불명확함
화면 목록과 기능 요구사항이 연결되지 않음
API 요구사항이 기능 요구사항과 연결되지 않음
데이터 모델이 너무 모호함
개인정보나 결제 관련 결정이 빠짐
초기 버전 범위가 너무 큼
```

---

## 5.2 새 세션을 열고 검증한다

[AI 코딩 도구]

```text
/clear
```

[AI 코딩 도구]

```text
bmad-check-implementation-readiness
```

AI가 문서를 읽고 PASS, CONCERNS, FAIL 중 하나를 제시한다.

---

## 5.3 CONCERNS가 나왔을 때

CONCERNS는 실패가 아니다. 수정해야 할 부분이 있다는 뜻이다.

AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구]

```text
The readiness check returned CONCERNS.
List each concern in a table with:

- concern
- affected document
- why it matters
- exact revision needed
- whether I should update PRD, architecture, or stories

Do not revise blindly.
Ask me when a decision is needed about authentication, privacy, payment, database, or deployment.
```

그다음 지적받은 문서를 수정하고 다시 검증한다.

[AI 코딩 도구]

```text
bmad-check-implementation-readiness
```

---

## 5.4 FAIL이 나왔을 때

FAIL은 구현을 시작하면 안 된다는 뜻이다. 보통 다음 문제가 있을 때 발생한다.

```text
PRD가 너무 모호함
Architecture가 PRD와 충돌함
Epic/Story가 구현 가능한 단위로 쪼개지지 않음
사용자 흐름이 없음
화면 목록이 없음
인증과 권한 요구사항이 불명확함
데이터 모델과 API가 없음
```

FAIL이 나오면 다음 프롬프트를 사용한다.

[AI 코딩 도구]

```text
The readiness check returned FAIL.
Do not proceed to implementation.

Identify the blocking issues and tell me exactly which workflow I should return to:

- PRD revision
- architecture revision
- epics/stories revision

For each blocking issue, explain what decision is missing.
Do not invent missing product decisions.
```

---

## 5.5 PASS가 나왔을 때

PASS가 나오면 Phase 4, 즉 구현 단계로 넘어갈 준비가 된 것이다.

하지만 오늘은 복잡한 구현을 바로 시작하지 않는다. 오늘은 4회차 MVP 골격 구현을 준비하기 위해 다음을 만든다.

```text
1. 표준 웹서비스 repo 구조
2. 사용자 흐름 문서
3. 화면 맵
4. 라우트 맵
5. 데이터 모델 초안
6. API 계약 초안
7. 인증과 보안 기준 문서
8. 테스트 계획
```

---

# 6. 실습 4 — 웹서비스 repo 구조 만들기

## 6.1 repo 구조가 중요한 이유

웹서비스 프로젝트는 처음에는 화면 하나로 시작할 수 있다. 그러나 화면, 컴포넌트, API, 데이터 모델, 인증 코드가 한곳에 섞이면 곧 문제가 생긴다.

```text
화면 수정이 API 오류를 만든다.
컴포넌트를 재사용하기 어렵다.
권한 검사가 누락된다.
테스트 대상을 정하기 어렵다.
AI가 파일 위치를 임의로 만든다.
```

그래서 3회차에서는 표준 repo 구조를 만든다.

---

## 6.2 AI에게 repo 구조 생성을 요청한다

[AI 코딩 도구]

```text
Using _bmad-output/project-context.md and the architecture document as the source of truth, create the project folder structure for this web service MVP.

Requirements:

- Create docs/
- Create docs/user-flow.md
- Create docs/screen-map.md
- Create docs/route-map.md
- Create docs/data-model-draft.md
- Create docs/api-contract-draft.md
- Create docs/auth-and-security.md
- Create docs/test-plan.md
- Create src/app/
- Create src/components/
- Create src/lib/
- Create src/server/
- Create src/types/
- Create src/config/
- Create tests/unit/
- Create tests/e2e/
- Create public/
- Add placeholder files with short comments only
- Do not implement complex UI yet
- Do not choose a database if it is not decided
- Do not add payment or authentication implementation unless PRD explicitly requires it
```

AI가 파일을 생성할 수 있는 환경이라면 이 요청만으로 구조가 만들어진다.

---

## 6.3 AI가 파일을 만들지 못할 때 — 직접 만드는 방법

AI 코딩 도구가 실제 파일을 만들지 못하면 터미널에서 직접 만든다.

### Windows PowerShell

[터미널]

```powershell
$dirs = @(
  "docs",
  "src/app",
  "src/components",
  "src/lib",
  "src/server",
  "src/types",
  "src/config",
  "tests/unit",
  "tests/e2e",
  "public"
)

foreach ($d in $dirs) {
  New-Item -ItemType Directory -Force $d | Out-Null
}

$files = @(
  "docs/user-flow.md",
  "docs/screen-map.md",
  "docs/route-map.md",
  "docs/data-model-draft.md",
  "docs/api-contract-draft.md",
  "docs/auth-and-security.md",
  "docs/test-plan.md",
  "src/components/.gitkeep",
  "src/lib/.gitkeep",
  "src/server/.gitkeep",
  "src/types/.gitkeep",
  "src/config/.gitkeep",
  "tests/unit/.gitkeep",
  "tests/e2e/.gitkeep",
  "public/.gitkeep"
)

foreach ($f in $files) {
  New-Item -ItemType File -Force $f | Out-Null
}
```

### Mac Terminal

[터미널]

```bash
mkdir -p docs
mkdir -p src/app src/components src/lib src/server src/types src/config
mkdir -p tests/unit tests/e2e public

touch docs/user-flow.md
 touch docs/screen-map.md
 touch docs/route-map.md
 touch docs/data-model-draft.md
 touch docs/api-contract-draft.md
 touch docs/auth-and-security.md
 touch docs/test-plan.md
 touch src/components/.gitkeep src/lib/.gitkeep src/server/.gitkeep
 touch src/types/.gitkeep src/config/.gitkeep
 touch tests/unit/.gitkeep tests/e2e/.gitkeep public/.gitkeep
```

> [!NOTE]
> `.gitkeep`은 비어 있는 폴더를 Git에 포함시키기 위해 사용하는 관례적 파일이다.

---

## 6.4 구조가 만들어졌는지 확인한다

### Windows PowerShell

[터미널]

```powershell
Get-ChildItem -Recurse -Depth 2 | Select-Object FullName
```

### Mac Terminal

[터미널]

```bash
find . -maxdepth 3 -type d | sort
```

다음 폴더가 보이면 정상이다.

```text
docs
src/app
src/components
src/lib
src/server
src/types
src/config
tests/unit
tests/e2e
public
```

---

# 7. 실습 5 — 서비스 설계 문서 작성

## 7.1 왜 설계 문서를 별도로 만드는가

웹서비스는 화면만으로 구성되지 않는다. 실제 서비스에는 사용자의 행동, 화면의 입력값, API의 요청과 응답, 데이터 저장 방식, 인증과 권한, 오류 처리 기준이 함께 존재한다.

따라서 3회차에서는 실제 코드를 작성하기 전에 다음 문서를 만든다.

```text
docs/user-flow.md           사용자 흐름
docs/screen-map.md          화면별 목적과 입력/출력
docs/route-map.md           URL 경로와 접근 권한
docs/data-model-draft.md    데이터 구조 초안
docs/api-contract-draft.md  API 요청/응답 초안
docs/auth-and-security.md   인증·권한·보안 기준
docs/test-plan.md           테스트 계획
```

---

## 7.2 AI에게 문서 생성을 요청한다

[AI 코딩 도구]

```text
Create the following web service design documents based on _bmad-output/PRD.md and the architecture document:

- docs/user-flow.md
- docs/screen-map.md
- docs/route-map.md
- docs/data-model-draft.md
- docs/api-contract-draft.md
- docs/auth-and-security.md
- docs/test-plan.md

Rules:
- Use the PRD as the source of truth.
- Mark uncertain assumptions explicitly.
- Do not invent payment, privacy, authentication, database, or deployment decisions.
- Keep the initial version small.
- Connect user flows to screens.
- Connect screens to routes.
- Connect routes to API requirements where relevant.
- Connect API requirements to data model requirements.
```

---

## 7.3 user-flow.md 기본 양식

AI가 문서를 만들지 못하면 `docs/user-flow.md`에 다음 양식을 붙여넣는다.

[파일 내용: `docs/user-flow.md`]

```md
# User Flow

## 1. 핵심 사용자 흐름

| Step | Actor | Screen | User Action | System Response | Notes |
|---|---|---|---|---|---|
| 1 | 일반 사용자 | Home | 서비스 소개를 확인한다 | 시작 버튼을 표시한다 | |
| 2 | 일반 사용자 | Signup/Login | 계정을 생성하거나 로그인한다 | 인증 결과를 반환한다 | 인증 필요 여부 확인 |
| 3 | 일반 사용자 | Dashboard | 주요 정보를 확인한다 | 사용자별 데이터를 표시한다 | |
| 4 | 일반 사용자 | Create/Edit | 핵심 정보를 입력한다 | 입력값을 검증하고 저장한다 | |
| 5 | 일반 사용자 | Detail | 저장된 결과를 확인한다 | 상세 정보를 표시한다 | |
| 6 | 관리자 | Admin | 관리 대상 목록을 확인한다 | 관리 데이터를 표시한다 | 관리자 기능이 필요한 경우만 |

## 2. 미정 사항

- 인증이 반드시 필요한가:
- 관리자 역할이 필요한가:
- 저장해야 하는 데이터는 무엇인가:
- 개인정보가 포함되는가:
```

---

## 7.4 screen-map.md 기본 양식

[파일 내용: `docs/screen-map.md`]

```md
# Screen Map

| Screen | Purpose | Main Fields | Main Actions | Auth Required | Related Requirements |
|---|---|---|---|---|---|
| Home | 서비스 목적 설명 | 없음 | 시작하기 | No | PRD-FR-1 |
| Signup | 계정 생성 | email, password, name | 가입 | TBD | PRD-FR-2 |
| Login | 로그인 | email, password | 로그인 | TBD | PRD-FR-3 |
| Dashboard | 핵심 정보 표시 | user data | 조회, 이동 | Yes/TBD | PRD-FR-4 |
| Detail | 개별 항목 상세 보기 | item fields | 수정, 삭제 | Yes/TBD | PRD-FR-5 |
| Admin | 관리자 관리 | user/item list | 상태 변경 | Admin only/TBD | PRD-FR-6 |

## 화면 설계 원칙

1. 사용자의 핵심 작업 흐름을 먼저 지원한다.
2. 입력 필드는 최소화한다.
3. 오류 메시지는 사용자가 이해할 수 있는 문장으로 작성한다.
4. 모바일과 데스크톱 화면을 모두 고려한다.
5. 관리자 화면은 필요한 경우에만 초기 버전에 포함한다.
```

---

## 7.5 route-map.md 기본 양식

[파일 내용: `docs/route-map.md`]

```md
# Route Map

| Route | Screen | Access | Purpose | Status |
|---|---|---|---|---|
| / | Home | Public | 서비스 소개와 시작 | Planned |
| /signup | Signup | Public/TBD | 회원가입 | Planned |
| /login | Login | Public/TBD | 로그인 | Planned |
| /dashboard | Dashboard | Auth/TBD | 사용자별 주요 정보 표시 | Planned |
| /items/new | Create Item | Auth/TBD | 핵심 데이터 생성 | Planned |
| /items/[id] | Item Detail | Auth/TBD | 핵심 데이터 상세 조회 | Planned |
| /admin | Admin | Admin/TBD | 관리자 기능 | Optional |

## 원칙

- 공개 라우트와 인증 필요 라우트를 구분한다.
- 관리자 전용 라우트는 일반 사용자 접근을 차단한다.
- 라우트가 PRD의 기능 요구사항과 연결되어야 한다.
```

---

## 7.6 data-model-draft.md 기본 양식

[파일 내용: `docs/data-model-draft.md`]

```md
# Data Model Draft

> 이 문서는 데이터베이스 확정 문서가 아니라 초기 데이터 구조 초안이다.

## User

| Field | Type | Required | Description |
|---|---|---|---|
| id | string | yes | 사용자 식별자 |
| email | string | yes | 로그인 또는 연락용 이메일 |
| name | string | TBD | 사용자 이름 |
| role | string | yes | user, admin 등 |
| created_at | datetime | yes | 생성 시각 |

## Item

| Field | Type | Required | Description |
|---|---|---|---|
| id | string | yes | 항목 식별자 |
| user_id | string | yes | 소유 사용자 |
| title | string | yes | 제목 |
| description | string | no | 설명 |
| status | string | yes | 상태 |
| created_at | datetime | yes | 생성 시각 |
| updated_at | datetime | yes | 수정 시각 |

## 미정 사항

- 실제 데이터베이스:
- 개인정보 포함 여부:
- 삭제 정책:
- 관리자 권한 범위:
```

---

## 7.7 api-contract-draft.md 기본 양식

[파일 내용: `docs/api-contract-draft.md`]

```md
# API Contract Draft

> 이 문서는 구현 전 API 계약 초안이다. 실제 구현 전에 PRD와 Architecture에 맞게 검토한다.

## GET /api/items

목적: 현재 사용자의 항목 목록을 반환한다.

Request:

```text
Auth: required/TBD
Query: optional filters
```

Response:

```json
{
  "items": [
    {
      "id": "string",
      "title": "string",
      "status": "string",
      "created_at": "datetime"
    }
  ]
}
```

## POST /api/items

목적: 새 항목을 생성한다.

Request:

```json
{
  "title": "string",
  "description": "string"
}
```

Response:

```json
{
  "id": "string",
  "title": "string",
  "status": "string",
  "created_at": "datetime"
}
```

## GET /api/items/{id}

목적: 특정 항목의 상세 정보를 반환한다.

## PATCH /api/items/{id}

목적: 특정 항목을 수정한다.

## DELETE /api/items/{id}

목적: 특정 항목을 삭제한다.

## 오류 응답 원칙

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "사용자가 이해할 수 있는 오류 메시지",
    "details": "개발자가 확인할 수 있는 제한적 정보"
  }
}
```
```

---

## 7.8 auth-and-security.md 기본 양식

[파일 내용: `docs/auth-and-security.md`]

```md
# Authentication and Security Policy

## 1. 사용자 역할

| Role | Description | Permissions |
|---|---|---|
| public | 로그인하지 않은 방문자 | 공개 페이지 조회 |
| user | 일반 사용자 | 자신의 데이터 생성, 조회, 수정 |
| admin | 관리자 | 관리 대상 조회와 제한적 관리 |

## 2. 인증 필요 여부

- 회원가입 필요 여부:
- 로그인 필요 여부:
- 관리자 기능 필요 여부:

## 3. 보안 원칙

1. API key와 비밀번호는 코드에 직접 작성하지 않는다.
2. 환경변수는 `.env` 또는 배포 플랫폼의 환경변수 설정으로 관리한다.
3. 민감정보는 GitHub에 올리지 않는다.
4. 관리자 권한은 일반 사용자 권한과 분리한다.
5. 개인정보나 결제 정보가 있으면 별도 검토 없이 구현하지 않는다.

## 4. 미정 사항

- 인증 제공자:
- 세션 관리 방식:
- 비밀번호 저장 방식:
- 개인정보 수집 범위:
- 결제 기능 여부:
```

---

## 7.9 test-plan.md 기본 양식

[파일 내용: `docs/test-plan.md`]

```md
# Test Plan

## 1. 핵심 사용자 흐름 테스트

| Test Case | Given | When | Then | Priority |
|---|---|---|---|---|
| Home page loads | 사용자가 홈에 접속 | / 경로를 연다 | 서비스 소개와 시작 버튼이 보인다 | High |
| Login validation | 사용자가 빈 입력값으로 로그인 | 로그인 버튼을 누른다 | 오류 메시지가 보인다 | High/TBD |
| Create item | 로그인 사용자가 입력값 작성 | 저장 버튼을 누른다 | 새 항목이 생성된다 | High |
| View item detail | 사용자가 항목을 선택 | 상세 화면으로 이동 | 상세 정보가 보인다 | Medium |
| Admin access control | 일반 사용자가 admin 접속 | /admin 접근 | 접근이 제한된다 | High/TBD |

## 2. API 테스트

- 목록 조회 API는 배열을 반환해야 한다.
- 생성 API는 필수 필드가 없을 때 오류를 반환해야 한다.
- 상세 조회 API는 권한 없는 접근을 차단해야 한다.

## 3. 화면 테스트

- 주요 버튼이 보이는가?
- 필수 입력값 검증이 되는가?
- 오류 메시지가 이해 가능한가?
- 모바일 화면에서 핵심 기능을 사용할 수 있는가?

## 4. 미정 사항

- 사용할 테스트 도구:
- E2E 테스트 범위:
- 인증 테스트 방식:
```

---

# 8. 실습 6 — 웹서비스 개발 환경 확인

## 8.1 Node.js와 npm이 있는지 확인한다

웹서비스 프로젝트에서는 보통 Node.js와 npm이 필요하다. 터미널에서 다음을 실행한다.

[터미널]

```bash
node -v
npm -v
```

정상이라면 버전이 출력된다.

```text
v20.x.x
10.x.x
```

오류가 나오면 아직 Node.js가 설치되지 않은 것이다. 이 경우에는 수업 중 교강사의 설치 안내를 따른다.

> [!NOTE]
> 3회차의 핵심은 구현이 아니라 설계와 구조화이다. Node.js가 없어도 문서 작성과 repo 구조 생성은 진행할 수 있다.

---

## 8.2 package.json이 있는지 확인한다

[터미널]

```bash
ls package.json
```

Windows PowerShell에서는 다음도 가능하다.

[터미널]

```powershell
dir package.json
```

파일이 없다면 아직 실제 웹 프레임워크 프로젝트가 초기화되지 않은 것이다. 3회차에서는 반드시 초기화하지 않아도 된다.

4회차에서 MVP 골격 구현을 시작할 때 다음 중 하나를 선택한다.

```text
선택 A: 현재 폴더를 Next.js 프로젝트로 초기화
선택 B: webapp/ 하위 폴더에 Next.js 프로젝트 생성
선택 C: 이미 존재하는 웹 프로젝트 구조에 BMAD 산출물을 연결
```

초보자 수업에서는 선택 B가 안전하다. 기존 BMAD 산출물과 충돌이 적기 때문이다.

---

# 9. GitHub에 올리기 전 안전 규칙

## 9.1 민감정보는 올리지 않는다

GitHub에 올리는 프로젝트에는 민감정보가 들어가면 안 된다.

올리면 안 되는 예:

```text
API key
비밀번호
실제 사용자 이메일
실제 사용자 전화번호
실제 주소
결제 정보
관리자 계정 정보
개인정보가 포함된 테스트 데이터
```

---

## 9.2 .gitignore를 확인한다

AI 코딩 도구에 다음을 요청한다.

[AI 코딩 도구]

```text
Create or update .gitignore for this web service project.

It should ignore:
- node_modules/
- .next/
- dist/
- build/
- .env
- .env.local
- log files
- OS temporary files
- test output files

Do not ignore docs/ or _bmad-output/ because those are class deliverables.
```

직접 만들려면 `.gitignore` 파일에 아래 내용을 넣는다.

[파일 내용: `.gitignore`]

```gitignore
# Dependencies
node_modules/

# Build outputs
.next/
dist/
build/
out/

# Environment variables
.env
.env.local
.env.*.local

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Test outputs
coverage/
playwright-report/
test-results/

# OS files
.DS_Store
Thumbs.db

# Temporary files
*.tmp
```

---

# 10. 오늘의 최종 품질 게이트

3회차가 끝나기 전에 다음을 모두 확인한다.

## 10.1 문서 게이트

```text
[ ] _bmad-output/architecture.md 또는 architecture 관련 산출물이 있다.
[ ] Epic/Story 산출물이 있다.
[ ] 구현 준비도 검증을 실행했다.
[ ] PASS 또는 수정 가능한 CONCERNS 상태다.
```

## 10.2 웹서비스 설계 게이트

```text
[ ] docs/user-flow.md가 있다.
[ ] docs/screen-map.md가 있다.
[ ] docs/route-map.md가 있다.
[ ] docs/data-model-draft.md가 있다.
[ ] docs/api-contract-draft.md가 있다.
[ ] docs/auth-and-security.md가 있다.
[ ] docs/test-plan.md가 있다.
```

## 10.3 repo 구조 게이트

```text
[ ] src/app/이 있다.
[ ] src/components/가 있다.
[ ] src/lib/가 있다.
[ ] src/server/가 있다.
[ ] src/types/가 있다.
[ ] src/config/가 있다.
[ ] tests/unit/이 있다.
[ ] tests/e2e/가 있다.
[ ] public/이 있다.
```

## 10.4 범위 관리 게이트

```text
[ ] 초기 버전에서 하지 않을 것이 명확하다.
[ ] 결제 기능을 임의로 추가하지 않았다.
[ ] 관리자 기능을 임의로 과도하게 확장하지 않았다.
[ ] 인증과 개인정보 관련 미정 사항이 문서화되어 있다.
[ ] 데이터베이스가 미정이면 임의로 확정하지 않았다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Check the current project against the Session 3 web service quality gates:

1. architecture output exists
2. epics/stories output exists
3. readiness check was completed
4. docs/user-flow.md exists
5. docs/screen-map.md exists
6. docs/route-map.md exists
7. docs/data-model-draft.md exists
8. docs/api-contract-draft.md exists
9. docs/auth-and-security.md exists
10. docs/test-plan.md exists
11. standard web service folders exist
12. no out-of-scope feature was added

Return PASS, CONCERNS, or FAIL.
For any concern, tell me the exact fix.
```

---

# 11. GitHub에 커밋하기

## 11.1 현재 변경 사항 확인

[터미널]

```bash
git status
```

아직 Git 저장소가 아니라는 메시지가 나오면 다음을 실행한다.

[터미널]

```bash
git init
```

다시 확인한다.

[터미널]

```bash
git status
```

---

## 11.2 파일 추가와 커밋

[터미널]

```bash
git add .
git commit -m "Add session 3 web service architecture and planning docs"
```

커밋이 성공하면 3회차 작업이 저장된 것이다.

> [!IMPORTANT]
> API key, 비밀번호, 실제 사용자 데이터, 결제 정보는 절대 커밋하지 않는다.

---

# 12. 과제 안내

## 과제 1. README.md에 Web Service Rules 섹션 추가

README.md에 다음 섹션을 추가한다.

[파일 내용: `README.md`에 추가]

```md
## Web Service Rules

1. 사용자의 핵심 흐름을 먼저 확인한다.
2. 화면, 라우트, API, 데이터 모델을 서로 연결해서 설계한다.
3. 민감정보와 API key는 코드에 직접 적지 않는다.
4. 인증과 권한이 필요한 경우 역할을 명확히 구분한다.
5. 보안, 개인정보, 결제 관련 결정은 임의로 확정하지 않는다.
6. 초기 버전의 범위를 지킨다.
7. 큰 구조 변경 전에는 이유와 위험을 문서화한다.
```

AI 코딩 도구에 요청하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Update README.md by adding a "Web Service Rules" section.

Include these rules:
1. Confirm the core user flow first.
2. Connect screens, routes, APIs, and data models.
3. Do not hard-code secrets or API keys.
4. Separate roles clearly when authentication or authorization is required.
5. Do not make privacy, security, or payment decisions without confirmation.
6. Keep the initial version scope small.
7. Document reasons and risks before major structural changes.
```

---

## 과제 2. 핵심 화면 3개 설명하기

`docs/screen-map.md`에서 가장 중요한 화면 3개를 고른다. 각 화면에 대해 다음을 적는다.

```text
1. 이 화면의 목적은 무엇인가?
2. 사용자는 이 화면에서 무엇을 하는가?
3. 필요한 입력값은 무엇인가?
4. 성공하면 사용자는 어디로 이동하는가?
5. 실패하면 어떤 오류 메시지가 필요한가?
```

예시:

```md
## 핵심 화면 후보 1

화면:
Dashboard

목적:
사용자가 자신의 주요 정보를 한눈에 확인하게 한다.

사용자 행동:
저장된 항목 목록을 확인하고, 새 항목 생성 화면으로 이동한다.

필요 입력값:
없음. 단, 필터 기능이 있으면 상태 또는 날짜 필터가 필요할 수 있다.

성공 후 이동:
항목을 클릭하면 Detail 화면으로 이동한다.

오류 메시지:
데이터를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.
```

---

## 과제 3. 사용자 테스트 질문 5개 만들기

`docs/user-flow.md`를 기준으로 실제 사용자에게 물어볼 질문을 5개 작성한다.

예시:

```text
1. 홈 화면을 보고 이 서비스가 무엇을 하는지 이해할 수 있었나요?
2. 시작 버튼을 누른 뒤 다음에 무엇을 해야 하는지 명확했나요?
3. 입력 양식에서 불필요하다고 느낀 항목이 있었나요?
4. 오류 메시지는 이해하기 쉬웠나요?
5. 결과 화면에서 가장 먼저 보고 싶은 정보는 무엇인가요?
```

---

# 13. 자주 생기는 문제와 해결법

## 13.1 `bmad-create-architecture`가 안 된다

가능한 원인:

```text
프로젝트 폴더 밖에서 AI 코딩 도구를 실행했다.
BMAD가 설치되지 않았다.
2회차 산출물이 없다.
```

해결:

[터미널]

```bash
pwd
```

프로젝트 폴더가 아니면 이동한다.

[터미널]

```bash
cd ~/my-web-service
```

다시 AI 코딩 도구를 실행한다.

[터미널]

```bash
gemini
```

또는:

```bash
claude
```

그다음:

[AI 코딩 도구]

```text
bmad-help
```

---

## 13.2 AI가 데이터분석 repo 구조를 만들려고 한다

이 프로젝트는 데이터분석 repo가 아니다. 즉시 멈추고 다음을 입력한다.

[AI 코딩 도구]

```text
Stop. This project is a web service project, not a data analysis repository.
Read _bmad-output/project-context.md again.
Revise the recommendation for a web service MVP.
Do not create data/raw, notebooks, src/analysis, or model training structure unless PRD explicitly requires data analysis features.
```

---

## 13.3 AI가 결제 기능을 추가하려고 한다

결제는 보안, 법적 책임, 사용자 신뢰와 관련된 고위험 기능이다. PRD에 명확히 없으면 초기 버전에 넣지 않는다.

[AI 코딩 도구]

```text
Stop. Payment is out of scope unless explicitly required by the PRD.
Remove payment-related implementation stories.
If payment is necessary, list the decisions I must make before implementation.
```

---

## 13.4 AI가 데이터베이스를 임의로 확정한다

데이터베이스가 정해지지 않았다면 AI가 임의로 선택하면 안 된다.

[AI 코딩 도구]

```text
The database choice is not confirmed.
Do not assume a database.
Document database options and the tradeoffs.
Keep the data model as a draft until I confirm the stack.
```

---

## 13.5 readiness check가 계속 CONCERNS를 낸다

CONCERNS가 반복되면 문서가 서로 충돌하는 경우가 많다.

[AI 코딩 도구]

```text
Compare these documents:

- _bmad-output/project-context.md
- _bmad-output/PRD.md
- architecture output
- epics/stories output
- docs/user-flow.md
- docs/screen-map.md
- docs/route-map.md
- docs/api-contract-draft.md

Find contradictions.
Use project-context.md as the source of truth.
List exact revisions needed.
Do not revise anything that requires my decision without asking first.
```

---

# 14. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> 웹서비스 Architecture는 PRD를 화면, 라우트, API, 데이터 모델, 인증, 테스트 구조로 번역하는 설계도이고, Epic/Story는 그 설계도를 구현 가능한 작은 작업으로 나누는 장치다.

3회차의 흐름은 다음과 같다.

```text
PRD 확인
→ Architecture 작성
→ Epic/Story 생성
→ 구현 준비도 검증
→ 웹서비스 repo 구조 생성
→ 사용자 흐름 문서 작성
→ 화면·라우트·API·데이터 모델 초안 작성
→ 테스트 계획 작성
```

4회차부터는 오늘 만든 구조를 바탕으로 실제 MVP 골격을 구현한다.

---

# 15. 3회차 최종 체크리스트

수업이 끝나기 전에 스스로 확인한다.

```text
[ ] 2회차 산출물 4개가 존재한다.
[ ] bmad-create-architecture를 실행했다.
[ ] Architecture 문서가 생성되었다.
[ ] Epic과 Story의 차이를 설명할 수 있다.
[ ] bmad-create-epics-and-stories를 실행했다.
[ ] bmad-check-implementation-readiness를 실행했다.
[ ] PASS/CONCERNS/FAIL의 의미를 이해한다.
[ ] 웹서비스 표준 repo 구조가 생성되었다.
[ ] docs/user-flow.md가 생성되었다.
[ ] docs/screen-map.md가 생성되었다.
[ ] docs/route-map.md가 생성되었다.
[ ] docs/data-model-draft.md가 생성되었다.
[ ] docs/api-contract-draft.md가 생성되었다.
[ ] docs/auth-and-security.md가 생성되었다.
[ ] docs/test-plan.md가 생성되었다.
[ ] README.md에 Web Service Rules를 추가할 수 있다.
```

---

## 부록 A. 오늘 사용하는 핵심 명령 모음

### 터미널 명령

```bash
pwd
ls _bmad-output
find . -maxdepth 3 -type d | sort
node -v
npm -v
git status
git add .
git commit -m "Add session 3 web service architecture and planning docs"
```

### AI 코딩 도구 명령

```text
bmad-help
/clear
bmad-create-architecture
/clear
bmad-create-epics-and-stories
/clear
bmad-check-implementation-readiness
```

---

## 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| Architecture | PRD를 실제 서비스 구조로 바꾸는 기술 설계도 |
| Epic | 큰 작업 묶음. 책의 장에 해당 |
| Story | Epic 안의 작은 구현 단위. 책의 절에 해당 |
| Acceptance Criteria | Story가 완료되었다고 판단하는 기준 |
| Implementation Readiness | 실제 구현을 시작해도 되는지 검증하는 단계 |
| User Flow | 사용자가 서비스를 이용하는 단계별 흐름 |
| Screen Map | 화면별 목적, 입력값, 동작을 정리한 문서 |
| Route Map | URL 경로와 접근 권한을 정리한 문서 |
| API Contract | API 요청과 응답의 약속 |
| Data Model | 서비스가 저장하고 다루는 데이터 구조 |
| Authentication | 사용자가 누구인지 확인하는 절차 |
| Authorization | 사용자가 무엇을 할 수 있는지 정하는 권한 체계 |
| source of truth | 여러 문서가 충돌할 때 기준이 되는 문서. 이 수업에서는 project-context.md |
