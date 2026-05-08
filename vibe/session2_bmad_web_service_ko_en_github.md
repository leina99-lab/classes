# 2차시 수업교안: BMAD로 웹서비스·외부 프로젝트 체계 만들기

> 대상: 웹서비스, 앱, 외부 프로젝트, 클라이언트 프로젝트, SaaS MVP를 만들고 싶은 학습자  
> 핵심 흐름: `context → product brief → PRD`  
> 최종 산출물: `project-context.md`, `product-brief.md`, `PRD.md`, `README.md`

---

## 0. 이 자료를 따로 만든 이유

이 수업의 기본 예시는 Python-first AI/Data Lab이다. 하지만 모든 학습자가 데이터분석 프로젝트만 만들지는 않는다.

어떤 학습자는 다음과 같은 프로젝트를 만들고 싶을 수 있다.

```text
웹서비스
SaaS MVP
동아리/기관/회사 외부 프로젝트
예약 시스템
교육 플랫폼
대시보드 웹앱
회원가입과 로그인 기능이 있는 서비스
관리자 페이지가 있는 서비스
외부 API를 사용하는 서비스
```

이런 경우에는 `project-context.md`의 내용이 달라져야 한다.  
데이터분석 프로젝트에서는 `data/raw/`, `notebooks/`, `src/analysis/`가 중요하다.  
웹서비스 프로젝트에서는 `사용자`, `화면`, `API`, `인증`, `데이터베이스`, `배포`, `보안`, `테스트`가 중요하다.

따라서 이 자료는 웹서비스와 외부 프로젝트를 위한 2차시 교안이다.

---

## 1. 오늘 수업의 목적

오늘 목표는 코드를 바로 짜는 것이 아니다. 오늘 목표는 **AI가 앞으로 어떤 기준으로 웹서비스를 설계하고 구현해야 하는지 정하는 것**이다.

AI에게 바로 이렇게 말하면 프로젝트는 흔들린다.

```text
웹서비스 만들어줘.
```

이 말에는 중요한 결정이 빠져 있다.

```text
누가 사용하는 서비스인가?
사용자는 어떤 문제를 겪고 있는가?
핵심 화면은 무엇인가?
로그인이 필요한가?
사용자 역할은 몇 개인가?
데이터는 어디에 저장하는가?
외부 API를 사용하는가?
결제나 개인정보가 있는가?
배포는 어디에 할 것인가?
성공 기준은 무엇인가?
이번 버전에서 하지 않을 것은 무엇인가?
```

그래서 2차시에서는 세 가지 문서를 만든다.

```text
1. project-context.md
2. product-brief.md
3. PRD.md
```

---

## 2. 오늘 끝나면 있어야 하는 파일

```text
_bmad-output/
├── brainstorming-report.md     # 1차시 산출물
├── project-context.md          # 2차시 산출물 1
├── product-brief.md            # 2차시 산출물 2
└── PRD.md                      # 2차시 산출물 3

README.md                       # 과제로 보완할 파일
```

브레인스토밍 결과가 다른 위치에 저장되어 있다면, AI 코딩 도구에게 이렇게 요청한다.

```text
현재 브레인스토밍 결과가 docs/brainstorming/ 폴더에 저장되어 있습니다.
수업 산출물 구조와 맞추기 위해 _bmad-output 폴더를 만들고,
기존 브레인스토밍 내용을 바탕으로 _bmad-output/brainstorming-report.md를 만들어 주세요.
```

---

## 3. 입력 위치 구분

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | PowerShell, Mac Terminal | `cd my-web-service` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `bmad-help` |
| `[파일 내용]` | Markdown 파일 안에 들어갈 글 | `# Project Context` |

예를 들어 다음은 터미널에 입력한다.

```powershell
cd my-web-service
```

다음은 AI 코딩 도구 안에 입력한다.

```text
bmad-help
```

---

# Part A. 수업 시작 준비

## 4. 터미널 열기

### Windows PowerShell

```text
1. Windows 키를 누른다.
2. PowerShell이라고 입력한다.
3. Windows PowerShell을 클릭한다.
```

### Mac Terminal

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

---

## 5. 프로젝트 폴더로 이동하기

웹서비스 프로젝트 폴더 이름은 자유롭게 정할 수 있다. 예시는 `my-web-service`로 둔다.

```bash
cd ~
cd my-web-service
```

현재 위치를 확인한다.

```bash
pwd
```

폴더가 없다면 새로 만든다.

```bash
cd ~
mkdir my-web-service
cd my-web-service
```

---

## 6. BMAD 설치와 상태 확인

프로젝트 폴더 안에서 BMAD를 설치한다.

```bash
npx bmad-method install
```

설치 마법사 답변 기준:

| 마법사 질문 | 답변 | 이유 |
|---|---|---|
| Where should BMad files be installed? | Current directory | 지금 프로젝트 폴더에 설치 |
| Select modules to install | BMad Method | 핵심 BMAD workflow 사용 |
| Select tools to configure | Claude Code 또는 Gemini | 사용하는 AI 코딩 도구와 연결 |
| Shard PRD and Architecture? | Yes | 긴 문서를 AI가 다루기 쉽게 분리 |
| 나머지 질문 | Enter | 기본값 사용 |

AI 코딩 도구를 실행한다.

```bash
claude
```

또는:

```bash
gemini
```

AI 코딩 도구 안에서 입력한다.

```text
bmad-help
```

---

# Part B. 웹서비스 프로젝트에서 세 문서의 역할

## 7. 세 문서의 역할

| 문서 | 쉬운 비유 | 웹서비스에서의 핵심 질문 |
|---|---|---|
| `project-context.md` | 프로젝트 헌법 | 기술 스택, 보안, 인증, 배포, 협업 규칙은? |
| `product-brief.md` | 서비스 기획서 | 누구의 어떤 문제를 해결하는 서비스인가? |
| `PRD.md` | 기능 요구사항 문서 | 어떤 화면, 기능, API, 데이터 모델이 필요한가? |

웹서비스 프로젝트에서는 `project-context.md`가 특히 중요하다.  
AI가 마음대로 프론트엔드, 백엔드, 데이터베이스, 배포 방식을 바꾸지 못하게 해야 하기 때문이다.

---

## 8. 웹서비스용 project-context.md에 들어가야 하는 항목

웹서비스 또는 외부 프로젝트의 `project-context.md`에는 최소한 다음 항목이 들어간다.

```text
1. Project Type
2. Users and Business Goal
3. Core Stack
4. Frontend Policy
5. Backend and API Policy
6. Data and Database Policy
7. Authentication and Security Policy
8. Deployment Policy
9. Testing and Quality Policy
10. AI Collaboration Policy
```

각 항목의 의미는 다음과 같다.

| 항목 | 의미 |
|---|---|
| Project Type | 이 프로젝트가 어떤 서비스인지 정의 |
| Users and Business Goal | 사용자와 해결하려는 문제 |
| Core Stack | 사용할 프론트엔드, 백엔드, DB, 배포 도구 |
| Frontend Policy | 화면, 컴포넌트, 접근성, 반응형 규칙 |
| Backend and API Policy | API 설계와 서버 로직 규칙 |
| Data and Database Policy | 데이터베이스, 스키마, 개인정보 규칙 |
| Authentication and Security Policy | 로그인, 권한, 보안 규칙 |
| Deployment Policy | 배포와 환경변수 관리 규칙 |
| Testing and Quality Policy | 테스트와 코드 품질 규칙 |
| AI Collaboration Policy | AI가 협업할 때 지켜야 할 규칙 |

---

# Part C. 실습 1: 웹서비스용 project-context.md 만들기

## 9. project-context.md 한국어 예시

아래 예시는 **웹서비스 또는 외부 프로젝트용 한국어 버전**이다. 실제 프로젝트에 맞게 `[대괄호]` 부분을 바꾸면 된다.

```md
# AI 에이전트를 위한 프로젝트 맥락

## 1. 프로젝트 유형

이 프로젝트는 [서비스 이름] 웹서비스 프로젝트이다.
목표는 [대상 사용자]가 [해결하려는 문제]를 더 쉽게 해결하도록 돕는 것이다.
이 프로젝트는 단순한 실험 코드가 아니라, 실제 사용자를 고려한 외부 공개 또는 내부 운영용 서비스이다.

## 2. 사용자와 비즈니스 목표

주요 사용자는 다음과 같다.

- 일반 사용자: [일반 사용자가 하는 일]
- 관리자: [관리자가 하는 일]
- 운영자 또는 내부 담당자: [내부 담당자가 하는 일]

이 서비스의 목표는 다음과 같다.

- 사용자가 [핵심 작업]을 더 빠르게 수행하게 한다.
- 운영자가 [관리 작업]을 더 쉽게 처리하게 한다.
- 초기 버전에서는 핵심 사용자 흐름을 안정적으로 구현하는 것을 우선한다.

## 3. 핵심 기술 스택

- AI 코딩 도구: Claude Code 또는 Gemini CLI
- 프로젝트 workflow: BMAD
- 프론트엔드: [예: Next.js, React, TypeScript]
- 백엔드: [예: FastAPI, Node.js, Next.js API Routes]
- 데이터베이스: [예: PostgreSQL, SQLite, Supabase]
- 스타일링: [예: Tailwind CSS]
- 테스트: [예: pytest, Playwright, Vitest]
- 배포: [예: Vercel, Render, Railway, Docker]

아직 기술 스택이 확정되지 않았다면 AI는 임의로 선택하지 말고 먼저 질문해야 한다.

## 4. 프론트엔드 규칙

- 화면은 사용자의 핵심 작업 흐름을 기준으로 설계한다.
- 컴포넌트는 재사용 가능하게 작성한다.
- 모바일과 데스크톱에서 모두 사용할 수 있도록 반응형을 고려한다.
- 버튼, 입력창, 오류 메시지는 사용자가 이해하기 쉬운 문장으로 작성한다.
- 접근성을 고려하여 label, alt text, keyboard navigation을 가능하면 반영한다.

## 5. 백엔드와 API 규칙

- API는 명확한 요청과 응답 구조를 가져야 한다.
- 인증이 필요한 API와 공개 API를 구분한다.
- 오류 응답은 사용자가 이해할 수 있는 메시지와 개발자가 추적할 수 있는 정보를 포함한다.
- 비즈니스 로직은 프론트엔드에 과도하게 넣지 않는다.
- 외부 API를 사용할 경우 실패, 지연, rate limit을 고려한다.

## 6. 데이터와 데이터베이스 규칙

- 데이터 모델은 PRD의 기능 요구사항을 기준으로 설계한다.
- 개인정보나 민감정보는 최소한으로 수집한다.
- 비밀번호는 평문으로 저장하지 않는다.
- 데이터베이스 스키마 변경은 기록하고 설명한다.
- 테스트용 데이터와 실제 데이터는 구분한다.

## 7. 인증과 보안 규칙

- 로그인, 회원가입, 권한이 필요한 경우 역할을 명확히 구분한다.
- 일반 사용자와 관리자의 권한을 분리한다.
- 환경변수와 API key는 코드에 직접 적지 않는다.
- 민감정보는 GitHub에 올리지 않는다.
- AI는 보안 관련 결정을 임의로 하지 말고 먼저 질문한다.

## 8. 배포와 운영 규칙

- 로컬 개발 환경과 배포 환경을 구분한다.
- 환경변수는 .env 파일 또는 배포 플랫폼의 환경변수 기능으로 관리한다.
- 배포 대상 플랫폼이 정해지지 않았다면 AI는 먼저 질문한다.
- 초기 버전에서는 복잡한 운영 자동화보다 안정적인 MVP 배포를 우선한다.

## 9. 테스트와 품질 규칙

- 핵심 사용자 흐름은 테스트 대상이다.
- 중요한 API는 최소한의 테스트를 포함한다.
- 폼 검증, 권한 검증, 오류 처리는 반드시 확인한다.
- AI가 큰 변경을 제안할 때는 변경 이유와 위험을 설명해야 한다.

## 10. AI 협업 규칙

AI 에이전트는 다음 규칙을 지켜야 한다.

- 요구사항이 불명확하면 먼저 질문한다.
- 기술 스택을 임의로 바꾸지 않는다.
- 보안, 인증, 결제, 개인정보 관련 결정은 반드시 확인을 요청한다.
- 큰 구조 변경 전에는 장단점을 설명한다.
- 생성한 파일과 수정한 파일을 명확히 보고한다.
- 구현보다 먼저 사용자 흐름과 요구사항을 확인한다.
```

---

## 10. project-context.md English example

아래는 같은 내용을 영어로 쓴 버전이다.

```md
# Project Context for AI Agents

## 1. Project Type

This is a web service project for [service name].
The goal is to help [target users] solve [problem] more easily.
This is not just an experimental codebase. It is intended for an external-facing or internal operational service with real users in mind.

## 2. Users and Business Goal

Primary users:

- End users: [what end users do]
- Admin users: [what admins do]
- Operators or internal staff: [what internal staff do]

Business goals:

- Help users complete [core task] more efficiently.
- Help operators manage [administrative task] more easily.
- In the initial version, prioritize a stable implementation of the core user flow.

## 3. Core Stack

- AI coding tool: Claude Code or Gemini CLI
- Project workflow layer: BMAD
- Frontend: [e.g., Next.js, React, TypeScript]
- Backend: [e.g., FastAPI, Node.js, Next.js API Routes]
- Database: [e.g., PostgreSQL, SQLite, Supabase]
- Styling: [e.g., Tailwind CSS]
- Testing: [e.g., pytest, Playwright, Vitest]
- Deployment: [e.g., Vercel, Render, Railway, Docker]

If the stack is not decided, AI agents must ask before making assumptions.

## 4. Frontend Policy

- Design screens around the core user flow.
- Build reusable components.
- Consider responsive behavior for both mobile and desktop.
- Use clear labels, button text, form messages, and error messages.
- Consider accessibility, including labels, alt text, and keyboard navigation where possible.

## 5. Backend and API Policy

- APIs must have clear request and response structures.
- Distinguish authenticated APIs from public APIs.
- Error responses should include user-understandable messages and developer-useful debugging information.
- Do not put excessive business logic in the frontend.
- When using external APIs, account for failure, latency, and rate limits.

## 6. Data and Database Policy

- Data models should be designed from the PRD's functional requirements.
- Collect personal or sensitive data only when necessary.
- Never store passwords in plain text.
- Document database schema changes.
- Separate test data from real data.

## 7. Authentication and Security Policy

- If login, signup, or permissions are required, define user roles clearly.
- Separate end-user permissions from admin permissions.
- Do not hard-code environment variables or API keys.
- Do not commit sensitive information to GitHub.
- AI agents must ask before making security-related decisions.

## 8. Deployment and Operations Policy

- Separate local development from deployed environments.
- Manage environment variables through .env files or deployment platform settings.
- If the deployment platform is not chosen, AI agents must ask first.
- In the initial version, prioritize a stable MVP deployment over complex operations automation.

## 9. Testing and Quality Policy

- Core user flows should be covered by tests.
- Important APIs should have at least minimal tests.
- Form validation, permission checks, and error handling must be verified.
- Before proposing large changes, AI agents must explain the reason and risks.

## 10. AI Collaboration Policy

AI agents must:

- ask when requirements are unclear,
- avoid changing the stack without confirmation,
- ask before making decisions related to security, authentication, payments, or personal data,
- explain tradeoffs before major structural changes,
- report generated and modified files clearly,
- confirm user flows and requirements before implementation.
```

---

## 11. 실제 파일 만들기

AI 코딩 도구 안에서 입력한다.

```text
Create _bmad-output/project-context.md for a web service project.
Use the Korean version below as the main content.
Also include the English version as a reference section at the bottom.
Replace placeholder items only when I provide the information.
If the stack is unclear, ask me questions instead of inventing decisions.

[여기에 한국어 예시와 영어 예시를 붙여넣기]
```

AI가 파일을 만들었다고 하면 확인한다.

```text
Show me _bmad-output/project-context.md.
Check whether it clearly defines:
- project type
- target users
- core stack
- frontend policy
- backend/API policy
- data/database policy
- authentication/security policy
- deployment policy
- testing policy
- AI collaboration policy
```

파일을 못 만들면 직접 만든다.

### Windows PowerShell

```powershell
mkdir _bmad-output
notepad _bmad-output\project-context.md
```

### Mac Terminal

```bash
mkdir -p _bmad-output
nano _bmad-output/project-context.md
```

---

# Part D. 실습 2: product-brief.md 만들기

## 12. 웹서비스 Product Brief는 무엇을 정리하는가

웹서비스의 Product Brief는 다음 질문에 답한다.

```text
이 서비스는 누구를 위한 것인가?
사용자는 어떤 문제를 겪고 있는가?
서비스가 제공하는 핵심 가치는 무엇인가?
가장 중요한 사용자 흐름은 무엇인가?
초기 버전의 성공 기준은 무엇인가?
하지 않을 것은 무엇인가?
```

---

## 13. product brief 실행

AI 코딩 도구 안에서 입력한다.

```text
/clear
bmad-product-brief
```

또는:

```text
/clear
/bmad-product-brief
```

---

## 14. Mary에게 줄 한국어 답변 예시

```text
이 프로젝트는 [대상 사용자]를 위한 웹서비스입니다.
사용자는 현재 [문제 상황] 때문에 [불편함]을 겪고 있습니다.
이 서비스는 사용자가 [핵심 작업]을 더 쉽게 수행하도록 돕습니다.
초기 버전에서는 핵심 사용자 흐름 하나를 안정적으로 구현하는 것을 목표로 합니다.

초기 버전의 핵심 기능은 다음과 같습니다.
1. 사용자가 [작업 A]를 할 수 있다.
2. 사용자가 [작업 B]를 확인할 수 있다.
3. 관리자가 [관리 작업]을 할 수 있다.

초기 버전에서는 다음을 하지 않습니다.
- 복잡한 결제 시스템
- 대규모 관리자 기능
- 고급 통계 대시보드
- 다국어 지원
- 모바일 앱 별도 개발
```

---

## 15. English answer example for Mary

```text
This project is a web service for [target users].
Users currently experience [pain point] because of [problem situation].
The service helps users complete [core task] more easily.
The initial version will focus on implementing one stable core user flow.

Core features for the initial version:
1. Users can complete [task A].
2. Users can view [task B or key information].
3. Admins can manage [admin task].

Out of scope for the initial version:
- Complex payment system
- Large-scale admin features
- Advanced analytics dashboard
- Multi-language support
- Separate mobile app development
```

---

## 16. product-brief.md 확인

AI 코딩 도구 안에서 입력한다.

```text
Show me _bmad-output/product-brief.md.
Check whether it includes:
- target users
- user problem
- product value
- core user flow
- success criteria
- out of scope items
```

---

# Part E. 실습 3: PRD.md 만들기

## 17. 웹서비스 PRD에 들어가야 하는 항목

웹서비스 PRD에는 데이터분석 프로젝트와 다른 항목이 들어간다.

```text
1. Executive Summary
2. Problem Statement
3. Target Users and Roles
4. User Journeys
5. Pages or Screens
6. Functional Requirements
7. Non-functional Requirements
8. Data Model Requirements
9. API Requirements
10. Authentication and Authorization Requirements
11. Security and Privacy Requirements
12. Deployment Requirements
13. Success Criteria
14. In Scope
15. Out of Scope
16. Risks
17. Tasks
```

---

## 18. PRD 실행

AI 코딩 도구 안에서 입력한다.

```text
/clear
bmad-create-prd
```

또는:

```text
/clear
/bmad-create-prd
```

---

## 19. John에게 줄 한국어 기준 문장

```text
이 PRD는 웹서비스 또는 외부 프로젝트를 위한 요구사항 문서입니다.
PRD는 단순 아이디어 설명이 아니라, 개발자가 첫 구현 작업을 시작할 수 있을 만큼 구체적이어야 합니다.

PRD에는 반드시 다음 항목을 포함해 주세요.

1. Executive Summary
2. Problem Statement
3. Target Users and Roles
4. User Journeys
5. Pages or Screens
6. Functional Requirements
7. Non-functional Requirements
8. Data Model Requirements
9. API Requirements
10. Authentication and Authorization Requirements
11. Security and Privacy Requirements
12. Deployment Requirements
13. Success Criteria
14. In Scope
15. Out of Scope
16. Risks
17. Tasks

중요한 기준:
- 사용자의 핵심 흐름을 먼저 정의합니다.
- 화면 목록과 기능 요구사항을 연결합니다.
- 인증과 권한이 필요한 경우 역할을 명확히 나눕니다.
- 데이터 모델과 API 요구사항을 분리해서 작성합니다.
- 개인정보, 결제, 보안 관련 사항은 임의로 결정하지 말고 질문합니다.
- 초기 버전에서 하지 않을 것을 분명히 적습니다.
```

---

## 20. English instruction for John

```text
This PRD is for a web service or external project.
It should be specific enough for a developer to start the first implementation task.

The PRD must include:

1. Executive Summary
2. Problem Statement
3. Target Users and Roles
4. User Journeys
5. Pages or Screens
6. Functional Requirements
7. Non-functional Requirements
8. Data Model Requirements
9. API Requirements
10. Authentication and Authorization Requirements
11. Security and Privacy Requirements
12. Deployment Requirements
13. Success Criteria
14. In Scope
15. Out of Scope
16. Risks
17. Tasks

Important constraints:
- Define the core user flow first.
- Connect pages/screens to functional requirements.
- If authentication or permissions are required, define roles clearly.
- Separate data model requirements from API requirements.
- Do not make assumptions about privacy, payment, or security decisions without asking.
- Clearly state what is out of scope for the initial version.
```

---

## 21. 웹서비스 PRD 요구사항 예시

### Target Users and Roles 예시

```text
역할 1: 일반 사용자
- 회원가입 또는 로그인 후 서비스를 사용한다.
- 자신의 정보를 등록하거나 조회한다.
- 핵심 작업을 수행한다.

역할 2: 관리자
- 사용자 목록을 확인한다.
- 콘텐츠 또는 데이터를 관리한다.
- 신고, 오류, 요청을 처리한다.
```

### User Journey 예시

```text
UJ1. 사용자는 홈 화면에 접속한다.
UJ2. 사용자는 회원가입 또는 로그인을 한다.
UJ3. 사용자는 핵심 정보를 입력한다.
UJ4. 시스템은 결과 또는 추천을 보여준다.
UJ5. 사용자는 결과를 저장하거나 공유한다.
```

### Pages or Screens 예시

```text
- Home Page: 서비스 소개와 시작 버튼
- Login Page: 로그인
- Signup Page: 회원가입
- Dashboard Page: 사용자별 주요 정보 표시
- Detail Page: 개별 항목 상세 보기
- Admin Page: 관리자 전용 관리 화면
```

### Functional Requirements 예시

```text
FR1. 사용자는 회원가입을 할 수 있어야 한다.
FR2. 사용자는 로그인과 로그아웃을 할 수 있어야 한다.
FR3. 사용자는 [핵심 데이터]를 생성, 조회, 수정, 삭제할 수 있어야 한다.
FR4. 관리자는 사용자 목록을 조회할 수 있어야 한다.
FR5. 시스템은 사용자의 입력값을 검증하고 오류 메시지를 표시해야 한다.
FR6. 시스템은 핵심 결과를 저장하고 다시 불러올 수 있어야 한다.
```

### Non-functional Requirements 예시

```text
NFR1. 주요 페이지는 일반적인 네트워크 환경에서 3초 이내에 로딩되어야 한다.
NFR2. 모바일과 데스크톱 화면에서 모두 사용할 수 있어야 한다.
NFR3. 민감정보는 코드와 GitHub에 저장하지 않는다.
NFR4. API 오류는 사용자가 이해할 수 있는 메시지로 표시한다.
NFR5. 주요 사용자 흐름은 테스트 대상이다.
```

### Data Model Requirements 예시

```text
User
- id
- email
- name
- role
- created_at

Item
- id
- user_id
- title
- description
- status
- created_at
- updated_at
```

### API Requirements 예시

```text
GET /api/items
- 현재 사용자의 item 목록을 반환한다.

POST /api/items
- 새 item을 생성한다.

GET /api/items/{id}
- 특정 item의 상세 정보를 반환한다.

PATCH /api/items/{id}
- 특정 item을 수정한다.

DELETE /api/items/{id}
- 특정 item을 삭제한다.
```

### Out of Scope 예시

```text
초기 버전에서는 다음을 하지 않는다.

- 결제 시스템
- 다국어 지원
- 모바일 앱 별도 개발
- 고급 관리자 통계
- 대규모 트래픽 최적화
- 복잡한 권한 체계
```

---

## 22. PRD 확인

AI 코딩 도구 안에서 입력한다.

```text
Show me _bmad-output/PRD.md.
Check whether it includes:
- target users and roles
- user journeys
- pages or screens
- functional requirements
- non-functional requirements
- data model requirements
- API requirements
- authentication and authorization requirements
- security and privacy requirements
- deployment requirements
- success criteria
- in scope / out of scope
- risks
- tasks
```

---

# Part F. PRD 자기 점검

## 23. 웹서비스 PRD 품질 체크리스트

```text
[ ] 누가 사용하는 서비스인지 명확한가?
[ ] 사용자가 겪는 문제가 구체적인가?
[ ] 핵심 사용자 흐름이 단계별로 적혀 있는가?
[ ] 필요한 화면 목록이 있는가?
[ ] 기능 요구사항이 화면 또는 API와 연결되는가?
[ ] 데이터 모델이 최소한으로 정의되어 있는가?
[ ] 인증과 권한이 필요한지 명확한가?
[ ] 보안과 개인정보 관련 주의사항이 있는가?
[ ] 초기 버전에서 하지 않을 것이 명확한가?
[ ] 개발자가 첫 구현 작업을 시작할 수 있을 만큼 구체적인가?
```

---

## 24. PRD가 모호할 때 수정 요청

```text
PRD.md가 아직 너무 모호합니다.
웹서비스 PRD 기준으로 다시 보완해 주세요.

1. target users와 roles를 분리해 주세요.
2. core user journey를 단계별로 작성해 주세요.
3. pages/screens 목록을 작성해 주세요.
4. 각 화면과 연결되는 functional requirements를 작성해 주세요.
5. data model requirements를 최소한으로 정의해 주세요.
6. API requirements를 endpoint 중심으로 정리해 주세요.
7. authentication, authorization, privacy, security 요구사항을 분리해 주세요.
8. initial version의 out of scope를 명확히 써 주세요.
9. 내가 추가로 답해야 하는 질문이 있으면 먼저 물어봐 주세요.
```

---

# Part G. ChatGPT Projects 보조 공간 세팅

## 25. ChatGPT Projects의 역할

웹서비스 프로젝트에서 ChatGPT Projects는 코드 작성 중심 도구가 아니라 기획과 검토 보조 공간이다.

여기서 하는 일:

```text
사용자 흐름 정리
기능 아이디어 정리
PRD 문장 검토
화면 목록 점검
오류 메시지 문구 작성
사용자 테스트 질문 만들기
```

여기서 하지 않는 일:

```text
repo 파일 직접 수정
실제 배포 실행
보안 결정을 임의로 확정
API key 또는 비밀번호 관리
```

---

## 26. ChatGPT Projects 사용자 지정 지시

```text
이 프로젝트는 웹서비스 또는 외부 프로젝트 구축을 위한 기획 보조 공간이다.

역할:
- 사용자 문제 정리
- 사용자 흐름 설계
- 기능 요구사항 정리
- 화면 목록과 UX 문장 검토
- PRD와 project-context.md의 논리 점검
- 리스크와 out-of-scope 항목 점검

원칙:
- AI 코딩 도구로 관리하는 repo가 source of truth이다.
- ChatGPT는 보조 기획자와 리뷰어 역할이다.
- ChatGPT는 코드 파일을 직접 수정하지 않는다.
- 보안, 개인정보, 인증, 결제 관련 사항은 임의로 확정하지 않는다.
- 불확실한 부분은 가정과 질문으로 분리해서 제시한다.
- 사용자의 핵심 흐름을 가장 먼저 확인한다.
```

---

# Part H. README.md 작성

## 27. README.md 생성 요청

AI 코딩 도구에 입력한다.

```text
Create or update README.md for this web service project.
Use these files as the source of truth:
- _bmad-output/project-context.md
- _bmad-output/product-brief.md
- _bmad-output/PRD.md

README.md must include:
- Purpose
- Target Users
- Core Features
- Tech Stack
- Project Structure
- How to Run
- Rules

Keep it beginner-friendly.
Do not invent tools or folders that are not in the project plan.
If something is planned but not implemented yet, mark it as planned.
```

---

## 28. README.md 기본 구조

````md
# [Service Name]

## Purpose

이 서비스가 누구의 어떤 문제를 해결하는지 한 문단으로 설명한다.

## Target Users

- 일반 사용자:
- 관리자:
- 내부 운영자:

## Core Features

- 핵심 기능 1
- 핵심 기능 2
- 핵심 기능 3

## Tech Stack

- Frontend:
- Backend:
- Database:
- Styling:
- Testing:
- Deployment:

## Project Structure

- src/: 주요 소스 코드
- app/ 또는 pages/: 화면 또는 라우트
- components/: 재사용 컴포넌트
- api/ 또는 server/: API와 서버 로직
- tests/: 테스트
- docs/: 문서

## How to Run

아직 실행 가능한 명령이 없으면 planned라고 표시한다.

```bash
# planned
npm run dev
```

## Rules

- 민감정보는 GitHub에 올리지 않는다.
- API key는 코드에 직접 적지 않는다.
- 사용자 역할과 권한을 명확히 구분한다.
- 큰 구조 변경 전에는 이유와 위험을 문서화한다.
- 초기 버전의 범위를 지킨다.
````

---

# Part I. 최종 확인

## 29. 산출물 확인

터미널에서 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 파일이 보여야 한다.

```text
brainstorming-report.md
project-context.md
product-brief.md
PRD.md
```

AI 코딩 도구에서도 확인한다.

```text
Check whether the following files exist:

_bmad-output/brainstorming-report.md
_bmad-output/project-context.md
_bmad-output/product-brief.md
_bmad-output/PRD.md
README.md

If any file is missing, tell me exactly what command or workflow I should run next.
```

---

## 30. 웹서비스 2차시 품질 게이트

```text
[ ] project-context.md를 보고 어떤 웹서비스인지 알 수 있다.
[ ] target users와 roles가 명확하다.
[ ] product-brief.md를 보고 무엇을 왜 만드는지 알 수 있다.
[ ] PRD.md에 핵심 사용자 흐름이 있다.
[ ] PRD.md에 화면 또는 페이지 목록이 있다.
[ ] PRD.md에 기능 요구사항과 API 요구사항이 있다.
[ ] 인증, 권한, 보안, 개인정보 관련 기준이 있다.
[ ] 초기 버전에서 하지 않을 것이 명확하다.
[ ] README.md에 프로젝트 목적과 실행 방법이 적혀 있다.
```

---

# 부록. 한 장 요약

```text
1. 터미널 열기
2. 프로젝트 폴더로 이동
3. claude 또는 gemini 실행
4. bmad-help 실행
5. 웹서비스용 project-context.md 작성
6. /clear → bmad-product-brief
7. /clear → bmad-create-prd
8. 웹서비스 PRD 품질 점검
9. ChatGPT Projects 보조 공간 세팅
10. README.md 작성
```
