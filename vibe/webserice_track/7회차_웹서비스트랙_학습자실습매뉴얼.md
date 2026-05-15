# 7회차 학습자 실습 매뉴얼: 웹서비스 트랙

# 테스트·보안·배포 준비
## 인증·권한·데이터 저장 → 테스트 전략 → 보안 점검 → 배포 준비 → Preview 배포 → 최종 품질 게이트

---

## 이 자료의 목적

7회차의 목표는 단순히 웹서비스를 인터넷에 올리는 것이 아니다. 7회차의 목표는 6회차에서 만든 인증·권한·데이터 저장 구조를 바탕으로, **사용자에게 공개해도 되는 최소 품질 기준**을 갖추는 것이다.

6회차에서는 다음 산출물을 만들었다.

```text
1. Supabase 프로젝트
2. .env.local 환경변수 파일
3. profiles 테이블
4. items 테이블
5. Row Level Security 정책
6. Supabase SSR client 설정
7. 회원가입 기능
8. 로그인 기능
9. 로그아웃 기능
10. 로그인 사용자별 데이터 저장
11. 관리자 권한의 기본 구조
12. 인증·권한·데이터 저장 테스트 체크리스트
```

7회차에서는 이 구조를 바탕으로 다음을 만든다.

```text
1. docs/test-plan.md
2. docs/security-review.md
3. docs/deployment-checklist.md
4. docs/release-notes.md
5. docs/env-guide.md
6. Playwright E2E 테스트 환경
7. 핵심 사용자 흐름 E2E 테스트
8. 권한·보안 수동 점검표
9. 배포 전 build 검증
10. Vercel Preview 배포 준비
11. README 배포·테스트 섹션 보완
12. 최종 품질 게이트 결과
```

오늘의 핵심 문장은 다음이다.

> 배포는 파일을 업로드하는 행위가 아니라, 검증된 상태의 서비스를 사용자 환경에 공개하는 절차이다.

7회차가 끝나면 학습자는 다음 질문에 답할 수 있어야 한다.

```text
이 서비스의 핵심 사용자 흐름은 테스트되었는가?
로그인하지 않은 사용자가 보호된 페이지에 접근할 수 없는가?
사용자 A가 사용자 B의 데이터를 볼 수 없는가?
관리자 권한이 일반 사용자 권한과 분리되어 있는가?
환경변수와 API key가 GitHub에 올라가지 않는가?
배포 전 npm run build가 성공하는가?
Preview 배포에서 최소 smoke test를 수행했는가?
서비스를 공개해도 되는지 판단할 근거가 있는가?
```

> [!IMPORTANT]
> 이 자료는 초보 학습자가 그대로 따라 할 수 있도록 명령을 단계별로 제공한다. 그러나 내부 기준은 실제 웹서비스 개발에서 사용하는 품질 기준을 따른다. 즉, 단순 실행 확인이 아니라 **테스트 전략, 인증 검증, 권한 검증, RLS 검증, 환경변수 보안, 배포 전 검증, 릴리스 문서화**를 모두 포함한다.

---

## 오늘 끝나면 있어야 하는 것

7회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
my-web-service/
├── docs/
│   ├── test-plan.md
│   ├── security-review.md
│   ├── deployment-checklist.md
│   ├── release-notes.md
│   ├── env-guide.md
│   └── manual-qa-checklist.md
├── tests/
│   ├── e2e/
│   │   ├── home.spec.ts
│   │   ├── auth.spec.ts
│   │   ├── protected-routes.spec.ts
│   │   ├── items.spec.ts
│   │   └── admin.spec.ts
│   └── unit/
│       └── item-validation.test.ts
├── playwright.config.ts
├── src/
│   └── lib/
│       └── validation/
│           └── item.ts
├── .env.local
├── .env.local.example
├── .env.test.local              # 실제 테스트 계정이 들어갈 수 있으므로 GitHub에 올리지 않음
├── README.md
└── package.json
```

> [!NOTE]
> 프로젝트 구조는 4~6회차에서 만든 Next.js App Router 구조를 기준으로 한다. 만약 본인의 프로젝트가 `src/app`이 아니라 `app` 폴더를 루트에 두고 있다면, 경로만 본인 프로젝트에 맞게 조정한다.

---

## 오늘 사용할 입력 위치를 구분하자

7회차에서는 입력 위치가 다섯 가지다.

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `npm run build` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `Create Playwright tests` |
| `[Supabase SQL Editor]` | Supabase 웹사이트의 SQL Editor | `select * from pg_policies;` |
| `[Vercel Dashboard]` | Vercel 웹사이트 설정 화면 | 환경변수 입력 |
| `[파일 내용]` | Markdown, TypeScript 파일 안에 들어갈 내용 | `test('home page loads', ...)` |

아래 명령은 터미널에 입력한다.

```bash
npm run build
```

아래 SQL은 Supabase SQL Editor에 입력한다.

```sql
select schemaname, tablename, policyname, cmd, roles, qual, with_check
from pg_policies
where schemaname = 'public';
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create a deployment readiness checklist for this web service project.
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

Mac에서는 Terminal을 연다.

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

앞으로 “터미널”이라고 하면 Windows에서는 PowerShell, Mac에서는 Terminal을 뜻한다.

---

## 0.2 프로젝트 폴더로 이동한다

이 자료에서는 프로젝트 폴더 이름을 `my-web-service`라고 가정한다. 본인의 폴더 이름이 다르면 실제 폴더 이름을 사용한다.

### Windows PowerShell

[터미널]

```powershell
cd $HOME
cd my-web-service
```

### Mac Terminal

[터미널]

```bash
cd ~
cd my-web-service
```

현재 위치를 확인한다.

[터미널]

```bash
pwd
```

정상이라면 다음과 비슷한 결과가 나온다.

```text
C:\Users\내이름\my-web-service
```

또는:

```text
/Users/내이름/my-web-service
```

> [!IMPORTANT]
> 오늘 모든 명령은 프로젝트 폴더 안에서 실행한다. `pwd` 결과가 프로젝트 폴더가 아니면 먼저 이동한다.

---

## 0.3 6회차 산출물을 확인한다

7회차는 6회차에서 만든 인증·권한·데이터 저장 기능이 있어야 진행할 수 있다.

[터미널]

```bash
npm run dev
```

브라우저에서 다음 주소를 연다.

```text
http://localhost:3000
```

다음이 가능해야 한다.

```text
[ ] 회원가입 화면에 접속할 수 있다.
[ ] 로그인 화면에 접속할 수 있다.
[ ] 로그인 후 dashboard에 접속할 수 있다.
[ ] item을 생성할 수 있다.
[ ] item 목록을 볼 수 있다.
[ ] 로그아웃할 수 있다.
[ ] 로그아웃 후 보호된 페이지에 들어가면 로그인 화면으로 이동한다.
```

문제가 있으면 7회차로 바로 넘어가지 말고 6회차 산출물을 먼저 보완한다.

AI 코딩 도구에 다음을 입력해 현재 상태를 점검할 수 있다.

[AI 코딩 도구 - English prompt]

```text
Review the current project as the starting point for Session 7.
Check whether the project has:

1. Supabase authentication setup,
2. protected dashboard route,
3. item create/read/update/delete flow,
4. user-specific data ownership,
5. admin role structure,
6. .env.local.example,
7. README instructions.

Return PASS, CONCERNS, or FAIL.
For any concern, explain the exact fix.
Do not change files yet.
```

[한국어 번역]

```text
현재 프로젝트를 7회차 시작 상태로 검토해 주세요.
다음 항목이 있는지 확인해 주세요.

1. Supabase 인증 설정
2. 보호된 dashboard 라우트
3. item 생성·조회·수정·삭제 흐름
4. 사용자별 데이터 소유권
5. 관리자 역할 구조
6. .env.local.example
7. README 실행 안내

PASS, CONCERNS, FAIL 중 하나로 판정해 주세요.
문제가 있으면 정확한 수정 방법을 설명해 주세요.
아직 파일은 수정하지 마세요.
```

---

# 1. 테스트·보안·배포의 큰 그림

## 1.1 왜 테스트가 필요한가

초보자는 “브라우저에서 한 번 눌러 봤는데 되면 성공”이라고 생각하기 쉽다. 그러나 실제 웹서비스에서는 다음 문제가 자주 발생한다.

```text
수정 후 기존 기능이 갑자기 깨진다.
로그인하지 않은 사용자가 보호된 페이지에 접근한다.
사용자 A가 사용자 B의 데이터를 볼 수 있다.
환경변수가 빠져서 배포 환경에서만 오류가 난다.
로컬에서는 되지만 Vercel에서는 build가 실패한다.
관리자 페이지가 일반 사용자에게 노출된다.
```

따라서 테스트는 “귀찮은 절차”가 아니라, 서비스가 망가지지 않았음을 확인하는 안전장치다.

---

## 1.2 오늘 사용할 테스트의 종류

| 테스트 종류 | 초보자용 설명 | 오늘 하는 일 |
|---|---|---|
| 수동 테스트 | 사람이 직접 눌러 보는 테스트 | 핵심 화면 점검 |
| 단위 테스트 | 작은 함수 하나를 검증하는 테스트 | item 입력값 검증 함수 테스트 |
| E2E 테스트 | 사용자의 실제 흐름을 브라우저로 자동 실행하는 테스트 | 로그인, 보호 라우트, item 흐름 테스트 |
| 보안 점검 | 위험한 노출이나 권한 문제를 확인하는 점검 | 환경변수, RLS, 권한, 오류 메시지 점검 |
| 배포 검증 | 공개 환경에 올리기 전 확인 | build, preview, smoke test |

---

## 1.3 전문가 관점의 품질 기준

이번 차시에서 지향하는 품질 기준은 다음과 같다.

```text
1. 핵심 사용자 흐름은 E2E 테스트로 검증한다.
2. 인증과 권한은 별도로 검증한다.
3. 데이터 소유권은 RLS와 애플리케이션 로직에서 동시에 확인한다.
4. 환경변수와 secret은 GitHub에 커밋하지 않는다.
5. 배포 전에는 build와 smoke test를 실행한다.
6. Preview 환경과 Production 환경을 구분한다.
7. 릴리스 여부는 체크리스트로 판단한다.
```

---

# 2. 실습 1 — 테스트 계획서 만들기

## 2.1 테스트 계획서란 무엇인가

테스트 계획서는 “무엇을 테스트할 것인가”를 정리한 문서다. 코드를 작성하기 전에 테스트 계획을 만들면, 무엇이 중요한 기능인지 분명해진다.

웹서비스의 테스트 계획서에는 다음이 들어가야 한다.

```text
1. 테스트 범위
2. 테스트하지 않는 범위
3. 핵심 사용자 흐름
4. 권한별 테스트 시나리오
5. 데이터 소유권 테스트
6. 보안 점검 항목
7. 배포 전 점검 항목
8. 통과 기준
```

---

## 2.2 AI에게 테스트 계획서 생성을 요청한다

[AI 코딩 도구 - English prompt]

```text
Create docs/test-plan.md for this web service project.

Use the existing PRD, architecture, user-flow, screen-map, route-map, api-contract, and auth/security documents as the source of truth.

The test plan must include:

1. testing goals,
2. in-scope tests,
3. out-of-scope tests,
4. core user flows,
5. role-based scenarios,
6. authentication scenarios,
7. authorization scenarios,
8. data ownership scenarios,
9. security checks,
10. deployment readiness checks,
11. pass/fail criteria.

Keep the language beginner-friendly, but make the structure professional.
Do not invent features that are not in the project.
```

[한국어 번역]

```text
이 웹서비스 프로젝트를 위한 docs/test-plan.md 파일을 만들어 주세요.

기존 PRD, architecture, user-flow, screen-map, route-map, api-contract, auth/security 문서를 기준 자료로 사용해 주세요.

테스트 계획서에는 다음 항목을 포함해 주세요.

1. 테스트 목표
2. 테스트 범위
3. 테스트하지 않는 범위
4. 핵심 사용자 흐름
5. 역할별 시나리오
6. 인증 시나리오
7. 권한 시나리오
8. 데이터 소유권 시나리오
9. 보안 점검 항목
10. 배포 준비도 점검 항목
11. 통과/실패 기준

문장은 초보자도 이해할 수 있게 작성하되, 구조는 전문적으로 만들어 주세요.
프로젝트에 없는 기능을 임의로 만들지 마세요.
```

---

## 2.3 직접 작성할 때 사용할 양식

AI가 파일을 만들지 못하면 직접 만든다.

### Windows PowerShell

[터미널]

```powershell
mkdir docs
notepad docs\test-plan.md
```

### Mac Terminal

[터미널]

```bash
mkdir -p docs
nano docs/test-plan.md
```

아래 내용을 붙여넣는다.

[파일 내용: `docs/test-plan.md`]

```md
# Test Plan

## 1. Testing Goals

이 테스트 계획의 목표는 웹서비스의 핵심 사용자 흐름, 인증, 권한, 데이터 소유권, 배포 준비 상태를 검증하는 것이다.

## 2. In Scope

- 홈 화면 표시
- 회원가입
- 로그인
- 로그아웃
- 보호된 페이지 접근 제한
- item 생성
- item 목록 조회
- item 상세 조회
- item 수정
- item 삭제
- 사용자별 item 데이터 분리
- 관리자 화면 접근 제한
- 환경변수와 secret 노출 점검
- 배포 전 build 확인

## 3. Out of Scope

- 실제 결제 테스트
- 대규모 부하 테스트
- 외부 침투 테스트
- 다국어 테스트
- 모바일 앱 테스트

## 4. Core User Flows

### Flow 1. Anonymous Visitor

1. 사용자는 홈 화면에 접속한다.
2. 사용자는 로그인하지 않은 상태로 dashboard에 접근한다.
3. 시스템은 사용자를 로그인 화면으로 이동시킨다.

### Flow 2. Authenticated User

1. 사용자는 회원가입 또는 로그인을 한다.
2. 사용자는 dashboard에 접속한다.
3. 사용자는 item을 생성한다.
4. 사용자는 자신의 item 목록을 확인한다.
5. 사용자는 item을 수정하거나 삭제한다.
6. 사용자는 로그아웃한다.

### Flow 3. Admin User

1. 관리자는 로그인한다.
2. 관리자는 관리자 화면에 접근한다.
3. 일반 사용자는 관리자 화면에 접근할 수 없다.

## 5. Role-Based Scenarios

| Role | Allowed | Not Allowed |
|---|---|---|
| anonymous | home, login, signup | dashboard, items, admin |
| user | own dashboard, own items | other users' items, admin |
| admin | admin page, operational view | bypassing security rules |

## 6. Pass Criteria

- 모든 핵심 E2E 테스트가 통과한다.
- 로그인하지 않은 사용자는 보호된 페이지에 접근할 수 없다.
- 일반 사용자는 관리자 페이지에 접근할 수 없다.
- 사용자별 데이터 소유권이 유지된다.
- `npm run build`가 성공한다.
- secret이 GitHub에 커밋되지 않는다.

## 7. Fail Criteria

- 인증 없이 보호된 페이지 접근이 가능하다.
- 일반 사용자가 관리자 페이지에 접근할 수 있다.
- 사용자 A가 사용자 B의 데이터를 조회할 수 있다.
- `.env.local` 또는 service role key가 GitHub에 올라간다.
- Production build가 실패한다.
```

---

# 3. 실습 2 — 수동 QA 체크리스트 만들기

## 3.1 수동 QA란 무엇인가

QA는 Quality Assurance의 약자다. 여기서는 “서비스가 의도한 대로 작동하는지 확인하는 절차”라고 이해하면 된다.

초보자는 자동 테스트부터 바로 이해하기 어렵다. 그래서 먼저 사람이 직접 눌러 보는 수동 QA 체크리스트를 만든다.

---

## 3.2 manual-qa-checklist.md 만들기

[AI 코딩 도구 - English prompt]

```text
Create docs/manual-qa-checklist.md.

The checklist must be written for a beginner tester who will manually open the browser and click through the service.

Include sections for:

1. pre-check,
2. anonymous user flow,
3. signup flow,
4. login flow,
5. item create/read/update/delete flow,
6. logout flow,
7. protected route check,
8. admin access check,
9. error message check,
10. mobile layout quick check.

Each checklist item must have:
- action,
- expected result,
- pass/fail field.
```

[한국어 번역]

```text
docs/manual-qa-checklist.md 파일을 만들어 주세요.

이 체크리스트는 브라우저를 열고 직접 클릭하며 테스트하는 초보 테스터를 위한 문서여야 합니다.

다음 섹션을 포함해 주세요.

1. 사전 확인
2. 비로그인 사용자 흐름
3. 회원가입 흐름
4. 로그인 흐름
5. item 생성·조회·수정·삭제 흐름
6. 로그아웃 흐름
7. 보호된 라우트 확인
8. 관리자 접근 확인
9. 오류 메시지 확인
10. 모바일 레이아웃 빠른 확인

각 체크 항목에는 다음이 있어야 합니다.
- 수행 행동
- 기대 결과
- PASS/FAIL 기록 칸
```

---

## 3.3 직접 붙여넣을 예시

[파일 내용: `docs/manual-qa-checklist.md`]

```md
# Manual QA Checklist

## 1. Pre-check

| Action | Expected Result | PASS/FAIL |
|---|---|---|
| `npm run dev`를 실행한다. | 개발 서버가 오류 없이 시작된다. |  |
| 브라우저에서 `http://localhost:3000`을 연다. | 홈 화면이 표시된다. |  |
| `.env.local`이 존재하는지 확인한다. | Supabase URL과 anon key가 들어 있다. |  |

## 2. Anonymous User Flow

| Action | Expected Result | PASS/FAIL |
|---|---|---|
| 로그아웃 상태에서 `/dashboard`에 접속한다. | 로그인 페이지로 이동한다. |  |
| 로그아웃 상태에서 `/items`에 접속한다. | 로그인 페이지로 이동한다. |  |
| 로그아웃 상태에서 `/admin`에 접속한다. | 접근 불가 메시지 또는 로그인 페이지가 표시된다. |  |

## 3. Signup Flow

| Action | Expected Result | PASS/FAIL |
|---|---|---|
| 회원가입 페이지를 연다. | 이메일과 비밀번호 입력창이 표시된다. |  |
| 올바른 이메일과 비밀번호를 입력한다. | 가입 또는 이메일 확인 안내가 표시된다. |  |
| 잘못된 이메일을 입력한다. | 이해 가능한 오류 메시지가 표시된다. |  |

## 4. Login Flow

| Action | Expected Result | PASS/FAIL |
|---|---|---|
| 로그인 페이지를 연다. | 이메일과 비밀번호 입력창이 표시된다. |  |
| 올바른 계정으로 로그인한다. | dashboard로 이동한다. |  |
| 틀린 비밀번호를 입력한다. | 로그인 실패 메시지가 표시된다. |  |

## 5. Item CRUD Flow

| Action | Expected Result | PASS/FAIL |
|---|---|---|
| 새 item 생성 페이지를 연다. | 입력 form이 표시된다. |  |
| 필수값을 입력하고 저장한다. | item이 생성되고 목록에 표시된다. |  |
| item 상세 페이지를 연다. | item의 상세 정보가 표시된다. |  |
| item을 수정한다. | 수정된 값이 저장된다. |  |
| item을 삭제한다. | 목록에서 해당 item이 사라진다. |  |

## 6. Authorization Flow

| Action | Expected Result | PASS/FAIL |
|---|---|---|
| 일반 사용자로 `/admin`에 접속한다. | 관리자 권한이 없다는 메시지가 표시된다. |  |
| 사용자 A로 item을 만든다. | 사용자 A의 목록에 표시된다. |  |
| 사용자 B로 로그인한다. | 사용자 A의 item이 보이지 않는다. |  |
```

---

# 4. 실습 3 — Playwright E2E 테스트 환경 만들기

## 4.1 Playwright란 무엇인가

Playwright는 브라우저를 자동으로 조작해 사용자의 행동을 테스트하는 도구다. 사람이 브라우저에서 클릭하는 일을 코드로 자동화한다고 이해하면 된다.

예를 들어 다음을 자동으로 확인할 수 있다.

```text
홈 화면이 열리는가?
로그인하지 않은 사용자가 dashboard에 들어가면 login으로 이동하는가?
로그인 후 item을 만들 수 있는가?
관리자 페이지는 일반 사용자에게 막혀 있는가?
```

---

## 4.2 Playwright 설치

터미널에서 다음 명령을 실행한다.

[터미널]

```bash
npm install -D @playwright/test
npx playwright install
```

정상적으로 설치되면 `node_modules` 안에 Playwright 관련 패키지가 설치되고, 테스트용 브라우저가 준비된다.

---

## 4.3 package.json 스크립트 추가

AI 코딩 도구에 요청한다.

[AI 코딩 도구 - English prompt]

```text
Update package.json scripts for testing.

Add these scripts if they do not already exist:

- "test:e2e": "playwright test"
- "test:e2e:ui": "playwright test --ui"
- "test:e2e:headed": "playwright test --headed"
- "test:unit": "vitest run"
- "test": "npm run test:unit && npm run test:e2e"

Do not remove existing scripts.
If a script name already exists, ask before overwriting it.
```

[한국어 번역]

```text
package.json의 테스트 스크립트를 보완해 주세요.

다음 스크립트가 없으면 추가해 주세요.

- "test:e2e": "playwright test"
- "test:e2e:ui": "playwright test --ui"
- "test:e2e:headed": "playwright test --headed"
- "test:unit": "vitest run"
- "test": "npm run test:unit && npm run test:e2e"

기존 스크립트는 삭제하지 마세요.
이미 같은 이름의 스크립트가 있으면 덮어쓰기 전에 질문해 주세요.
```

---

## 4.4 playwright.config.ts 만들기

[AI 코딩 도구 - English prompt]

```text
Create playwright.config.ts for this Next.js web service.

Requirements:

- test directory: tests/e2e
- default baseURL: http://127.0.0.1:3000
- allow overriding baseURL with PLAYWRIGHT_BASE_URL
- start the dev server with npm run dev unless PLAYWRIGHT_SKIP_WEBSERVER is set
- use Chromium as the default project
- collect screenshots only on failure
- collect trace on first retry
- use retries in CI
- keep the configuration beginner-readable
```

[한국어 번역]

```text
이 Next.js 웹서비스를 위한 playwright.config.ts 파일을 만들어 주세요.

요구사항은 다음과 같습니다.

- 테스트 폴더는 tests/e2e
- 기본 baseURL은 http://127.0.0.1:3000
- PLAYWRIGHT_BASE_URL 환경변수로 baseURL을 바꿀 수 있게 하기
- PLAYWRIGHT_SKIP_WEBSERVER가 설정되지 않았으면 npm run dev로 개발 서버 시작
- 기본 프로젝트는 Chromium 사용
- 실패 시에만 screenshot 저장
- 첫 재시도에서 trace 저장
- CI 환경에서는 retry 사용
- 초보자가 읽을 수 있게 구성
```

직접 작성해야 한다면 아래 코드를 사용한다.

[파일 내용: `playwright.config.ts`]

```ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  timeout: 30_000,
  expect: {
    timeout: 5_000,
  },
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  reporter: [['list'], ['html', { outputFolder: 'playwright-report', open: 'never' }]],
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL ?? 'http://127.0.0.1:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  webServer: process.env.PLAYWRIGHT_SKIP_WEBSERVER
    ? undefined
    : {
        command: 'npm run dev',
        url: 'http://127.0.0.1:3000',
        reuseExistingServer: !process.env.CI,
        timeout: 120_000,
      },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});
```

---

# 5. 실습 4 — 첫 번째 E2E 테스트 작성

## 5.1 테스트 폴더 만들기

[터미널]

```bash
mkdir -p tests/e2e
```

Windows PowerShell에서 위 명령이 작동하지 않으면 다음을 사용한다.

[터미널]

```powershell
New-Item -ItemType Directory -Force tests\e2e | Out-Null
```

---

## 5.2 홈 화면 테스트

[AI 코딩 도구 - English prompt]

```text
Create tests/e2e/home.spec.ts.

The test should:

1. open the home page,
2. check that the page renders without an error,
3. check that there is a visible link or button that starts the service,
4. avoid depending on fragile exact styling.

If the current home page does not have stable text or data-testid attributes, suggest minimal accessibility-friendly improvements.
```

[한국어 번역]

```text
tests/e2e/home.spec.ts 파일을 만들어 주세요.

이 테스트는 다음을 확인해야 합니다.

1. 홈 화면을 연다.
2. 페이지가 오류 없이 렌더링되는지 확인한다.
3. 서비스를 시작하는 링크나 버튼이 보이는지 확인한다.
4. 깨지기 쉬운 정확한 스타일 조건에 의존하지 않는다.

현재 홈 화면에 안정적인 텍스트나 data-testid 속성이 없다면, 접근성을 고려한 최소 수정안을 제안해 주세요.
```

직접 작성할 때 사용할 예시는 다음과 같다.

[파일 내용: `tests/e2e/home.spec.ts`]

```ts
import { expect, test } from '@playwright/test';

test('home page renders and has a start action', async ({ page }) => {
  await page.goto('/');

  await expect(page).toHaveTitle(/.+/);

  const startAction = page
    .getByRole('link', { name: /시작|로그인|대시보드|start|login|dashboard/i })
    .or(page.getByRole('button', { name: /시작|로그인|대시보드|start|login|dashboard/i }));

  await expect(startAction.first()).toBeVisible();
});
```

---

## 5.3 보호된 라우트 테스트

보호된 라우트란 로그인하지 않은 사용자가 접근하면 안 되는 페이지다. 예를 들면 다음과 같다.

```text
/dashboard
/items
/admin
```

[파일 내용: `tests/e2e/protected-routes.spec.ts`]

```ts
import { expect, test } from '@playwright/test';

const protectedRoutes = ['/dashboard', '/items'];

for (const route of protectedRoutes) {
  test(`anonymous user is redirected or blocked from ${route}`, async ({ page }) => {
    await page.goto(route);

    await expect(page).toHaveURL(/login|signin|auth|unauthorized/);
  });
}

test('anonymous user cannot access admin page', async ({ page }) => {
  await page.goto('/admin');

  await expect(page).toHaveURL(/login|signin|auth|unauthorized|forbidden/);
});
```

> [!NOTE]
> 프로젝트에서 로그인 페이지 경로가 `/login`이 아니라 `/auth/login`이라면 정규식은 그대로 작동할 가능성이 높다. 그래도 실패하면 본인 프로젝트의 실제 경로에 맞게 수정한다.

---

## 5.4 E2E 테스트 실행

[터미널]

```bash
npm run test:e2e
```

정상이라면 다음과 비슷한 결과가 나온다.

```text
Running 3 tests using 1 worker
  ✓ home page renders and has a start action
  ✓ anonymous user is redirected or blocked from /dashboard
  ✓ anonymous user is redirected or blocked from /items
  ✓ anonymous user cannot access admin page
```

실패하면 다음 명령으로 브라우저가 실제로 어떻게 움직이는지 볼 수 있다.

[터미널]

```bash
npm run test:e2e:headed
```

---

# 6. 실습 5 — 로그인과 item 흐름 E2E 테스트

## 6.1 테스트 계정 준비

로그인 테스트에는 테스트용 계정이 필요하다. 실제 운영 계정을 사용하지 않는다.

`.env.test.local` 파일을 만든다.

### Windows PowerShell

[터미널]

```powershell
notepad .env.test.local
```

### Mac Terminal

[터미널]

```bash
nano .env.test.local
```

아래 형식으로 작성한다.

[파일 내용: `.env.test.local`]

```env
PLAYWRIGHT_TEST_EMAIL=test-user@example.com
PLAYWRIGHT_TEST_PASSWORD=replace-with-test-password
PLAYWRIGHT_ADMIN_EMAIL=admin-user@example.com
PLAYWRIGHT_ADMIN_PASSWORD=replace-with-admin-password
```

> [!IMPORTANT]
> `.env.test.local`은 GitHub에 올리지 않는다. 이 파일에는 테스트 계정 비밀번호가 들어갈 수 있다.

`.gitignore`에 다음이 있는지 확인한다.

[파일 내용: `.gitignore`]

```gitignore
.env*.local
playwright-report/
test-results/
```

---

## 6.2 로그인 테스트 작성 요청

[AI 코딩 도구 - English prompt]

```text
Create tests/e2e/auth.spec.ts.

Requirements:

- Use PLAYWRIGHT_TEST_EMAIL and PLAYWRIGHT_TEST_PASSWORD from environment variables.
- Do not hard-code passwords.
- Test that a user can open the login page.
- Test that invalid credentials show an understandable error message.
- Test that valid credentials can log in and reach dashboard.
- Test that logout returns the user to a public or login state.
- If the project uses different route names, adapt to the existing routes.
```

[한국어 번역]

```text
tests/e2e/auth.spec.ts 파일을 만들어 주세요.

요구사항은 다음과 같습니다.

- PLAYWRIGHT_TEST_EMAIL과 PLAYWRIGHT_TEST_PASSWORD 환경변수를 사용한다.
- 비밀번호를 코드에 직접 쓰지 않는다.
- 사용자가 로그인 페이지를 열 수 있는지 테스트한다.
- 잘못된 로그인 정보에서 이해 가능한 오류 메시지가 나오는지 테스트한다.
- 올바른 로그인 정보로 로그인 후 dashboard에 도달하는지 테스트한다.
- 로그아웃 후 공개 상태 또는 로그인 상태로 돌아가는지 테스트한다.
- 프로젝트의 실제 라우트 이름이 다르면 기존 라우트에 맞게 조정한다.
```

---

## 6.3 item 흐름 테스트 작성 요청

[AI 코딩 도구 - English prompt]

```text
Create tests/e2e/items.spec.ts.

Requirements:

- Log in using test account credentials from environment variables.
- Create a new item with a unique title that includes the current timestamp.
- Verify that the item appears in the item list.
- Open the item detail page.
- Edit the item if the project supports editing.
- Delete the item if the project supports deletion.
- Avoid relying on fragile CSS selectors.
- Prefer accessible roles, labels, and visible text.
- If the current UI lacks stable labels or buttons, suggest minimal improvements.
```

[한국어 번역]

```text
tests/e2e/items.spec.ts 파일을 만들어 주세요.

요구사항은 다음과 같습니다.

- 환경변수의 테스트 계정 정보로 로그인한다.
- 현재 timestamp를 포함한 고유 제목의 item을 생성한다.
- 생성된 item이 목록에 나타나는지 확인한다.
- item 상세 페이지를 연다.
- 프로젝트가 수정 기능을 지원하면 item을 수정한다.
- 프로젝트가 삭제 기능을 지원하면 item을 삭제한다.
- 깨지기 쉬운 CSS 선택자에 의존하지 않는다.
- 접근 가능한 role, label, visible text를 우선 사용한다.
- 현재 UI에 안정적인 label이나 버튼이 부족하면 최소 개선안을 제안한다.
```

---

## 6.4 테스트가 실패할 때 가장 먼저 볼 것

E2E 테스트 실패는 흔하다. 실패했다고 프로젝트가 망가진 것은 아니다. 다음 순서로 확인한다.

```text
1. 개발 서버가 켜져 있는가?
2. 테스트 계정 이메일과 비밀번호가 맞는가?
3. Supabase 이메일 인증 설정 때문에 로그인이 막히는가?
4. 실제 페이지 경로가 테스트 코드와 다른가?
5. 버튼 이름이나 label이 테스트 코드와 다른가?
6. 보호 라우트가 redirect가 아니라 error message 방식인가?
7. RLS 정책 때문에 insert/select가 막히는가?
```

AI 코딩 도구에 다음처럼 요청할 수 있다.

[AI 코딩 도구 - English prompt]

```text
A Playwright test failed.
Analyze the failure output and identify whether the cause is:

1. wrong route,
2. missing accessible label,
3. authentication issue,
4. authorization or RLS issue,
5. timing issue,
6. actual application bug.

Suggest the smallest safe fix.
Do not weaken authentication or authorization to make the test pass.
```

[한국어 번역]

```text
Playwright 테스트가 실패했습니다.
실패 출력 내용을 분석해서 원인이 다음 중 무엇인지 판단해 주세요.

1. 잘못된 라우트
2. 접근 가능한 label 부족
3. 인증 문제
4. 권한 또는 RLS 문제
5. 타이밍 문제
6. 실제 애플리케이션 버그

가장 작고 안전한 수정안을 제안해 주세요.
테스트를 통과시키기 위해 인증이나 권한을 약화시키지 마세요.
```

---

# 7. 실습 6 — 단위 테스트 추가

## 7.1 왜 단위 테스트가 필요한가

E2E 테스트는 사용자의 전체 흐름을 확인하는 데 좋다. 그러나 모든 세부 로직을 E2E로만 테스트하면 느리고 불안정해질 수 있다.

작은 함수는 단위 테스트로 검증하는 것이 좋다. 이번 회차에서는 item 입력값 검증 함수를 만든다.

---

## 7.2 Vitest 설치

[터미널]

```bash
npm install -D vitest
```

---

## 7.3 검증 함수 만들기

[AI 코딩 도구 - English prompt]

```text
Create src/lib/validation/item.ts and tests/unit/item-validation.test.ts.

The validation function should check:

- title is required,
- title must not exceed 100 characters,
- description must not exceed 1000 characters,
- status must be one of allowed values if the project has status values.

The function should return a structured result, not just true or false.
Use Vitest for the unit test.
Keep the implementation small and readable.
```

[한국어 번역]

```text
src/lib/validation/item.ts와 tests/unit/item-validation.test.ts 파일을 만들어 주세요.

검증 함수는 다음을 확인해야 합니다.

- title은 필수값이다.
- title은 100자를 넘지 않아야 한다.
- description은 1000자를 넘지 않아야 한다.
- 프로젝트에 status 값이 있다면 status는 허용된 값 중 하나여야 한다.

함수는 단순히 true/false만 반환하지 말고 구조화된 결과를 반환해야 합니다.
단위 테스트는 Vitest를 사용해 주세요.
구현은 작고 읽기 쉽게 작성해 주세요.
```

직접 작성할 때 사용할 예시는 다음과 같다.

[파일 내용: `src/lib/validation/item.ts`]

```ts
export type ItemInput = {
  title?: string;
  description?: string;
  status?: string;
};

export type ValidationResult = {
  valid: boolean;
  errors: Record<string, string>;
};

const ALLOWED_STATUSES = ['todo', 'in_progress', 'done'];

export function validateItemInput(input: ItemInput): ValidationResult {
  const errors: Record<string, string> = {};

  const title = input.title?.trim() ?? '';
  const description = input.description?.trim() ?? '';

  if (!title) {
    errors.title = 'Title is required.';
  }

  if (title.length > 100) {
    errors.title = 'Title must be 100 characters or fewer.';
  }

  if (description.length > 1000) {
    errors.description = 'Description must be 1000 characters or fewer.';
  }

  if (input.status && !ALLOWED_STATUSES.includes(input.status)) {
    errors.status = 'Status is not allowed.';
  }

  return {
    valid: Object.keys(errors).length === 0,
    errors,
  };
}
```

[파일 내용: `tests/unit/item-validation.test.ts`]

```ts
import { describe, expect, it } from 'vitest';
import { validateItemInput } from '../../src/lib/validation/item';

describe('validateItemInput', () => {
  it('accepts a valid item', () => {
    const result = validateItemInput({
      title: 'Valid title',
      description: 'Short description',
      status: 'todo',
    });

    expect(result.valid).toBe(true);
    expect(result.errors).toEqual({});
  });

  it('requires title', () => {
    const result = validateItemInput({ title: '' });

    expect(result.valid).toBe(false);
    expect(result.errors.title).toBeDefined();
  });

  it('rejects a title longer than 100 characters', () => {
    const result = validateItemInput({ title: 'a'.repeat(101) });

    expect(result.valid).toBe(false);
    expect(result.errors.title).toBeDefined();
  });

  it('rejects an invalid status', () => {
    const result = validateItemInput({ title: 'Task', status: 'unknown' });

    expect(result.valid).toBe(false);
    expect(result.errors.status).toBeDefined();
  });
});
```

---

## 7.4 단위 테스트 실행

[터미널]

```bash
npm run test:unit
```

정상이라면 다음과 비슷한 결과가 나온다.

```text
✓ tests/unit/item-validation.test.ts
```

---

# 8. 실습 7 — 보안 점검 문서 작성

## 8.1 보안 점검의 핵심

이번 수업은 전문 보안 침투 테스트 수업이 아니다. 그러나 기본 보안 원칙은 반드시 지켜야 한다.

오늘 확인할 항목은 다음이다.

```text
1. secret이 GitHub에 올라가지 않는가?
2. service role key가 브라우저 코드에 들어가지 않는가?
3. 일반 사용자가 관리자 페이지에 접근할 수 없는가?
4. 사용자별 데이터 소유권이 유지되는가?
5. RLS 정책이 활성화되어 있는가?
6. 오류 메시지가 민감한 내부 정보를 노출하지 않는가?
7. 입력값 검증이 있는가?
8. 배포 환경변수가 분리되어 있는가?
```

---

## 8.2 security-review.md 생성 요청

[AI 코딩 도구 - English prompt]

```text
Create docs/security-review.md for this web service project.

Use these sections:

1. Authentication Review
2. Authorization Review
3. Row Level Security Review
4. Environment Variable and Secret Review
5. Input Validation Review
6. Error Message Review
7. Admin Access Review
8. Data Privacy Review
9. Dependency Review
10. Release Decision

For each section, include:
- what to check,
- why it matters,
- current status,
- evidence,
- risk level,
- required fix if any.

Keep it understandable for beginners, but use professional security categories.
```

[한국어 번역]

```text
이 웹서비스 프로젝트를 위한 docs/security-review.md 파일을 만들어 주세요.

다음 섹션을 사용해 주세요.

1. 인증 검토
2. 권한 검토
3. Row Level Security 검토
4. 환경변수와 secret 검토
5. 입력값 검증 검토
6. 오류 메시지 검토
7. 관리자 접근 검토
8. 데이터 개인정보 검토
9. 의존성 검토
10. 릴리스 결정

각 섹션에는 다음을 포함해 주세요.
- 무엇을 확인할 것인가
- 왜 중요한가
- 현재 상태
- 근거
- 위험 수준
- 필요한 수정 사항

초보자도 이해할 수 있게 작성하되, 보안 범주는 전문적으로 구성해 주세요.
```

---

## 8.3 직접 작성할 때 사용할 양식

[파일 내용: `docs/security-review.md`]

```md
# Security Review

## 1. Authentication Review

| Item | Status | Evidence | Risk | Required Fix |
|---|---|---|---|---|
| 로그인하지 않은 사용자는 보호된 페이지에 접근할 수 없는가? |  |  |  |  |
| 로그아웃 후 세션이 유지되지 않는가? |  |  |  |  |
| 테스트 계정과 운영 계정이 분리되어 있는가? |  |  |  |  |

## 2. Authorization Review

| Item | Status | Evidence | Risk | Required Fix |
|---|---|---|---|---|
| 일반 사용자는 관리자 페이지에 접근할 수 없는가? |  |  |  |  |
| 사용자 A는 사용자 B의 데이터를 볼 수 없는가? |  |  |  |  |
| 서버 로직에서 사용자 권한을 다시 확인하는가? |  |  |  |  |

## 3. Row Level Security Review

| Item | Status | Evidence | Risk | Required Fix |
|---|---|---|---|---|
| items 테이블에 RLS가 활성화되어 있는가? |  |  |  |  |
| select 정책이 owner_id 또는 user_id를 기준으로 제한되는가? |  |  |  |  |
| insert 정책이 현재 로그인 사용자만 허용하는가? |  |  |  |  |
| update/delete 정책이 소유자만 허용하는가? |  |  |  |  |

## 4. Environment Variable and Secret Review

| Item | Status | Evidence | Risk | Required Fix |
|---|---|---|---|---|
| `.env.local`이 GitHub에 올라가지 않는가? |  |  |  |  |
| service role key를 브라우저 코드에서 사용하지 않는가? |  |  |  |  |
| `.env.local.example`에는 실제 secret이 없는가? |  |  |  |  |
| Vercel 환경변수가 Preview/Production에 맞게 설정되어 있는가? |  |  |  |  |

## 5. Release Decision

- Release decision: PASS / CONCERNS / FAIL
- Blocking issues:
- Non-blocking issues:
- Next actions:
```

---

# 9. 실습 8 — Supabase RLS 정책 확인

## 9.1 RLS 정책 확인 SQL

Supabase SQL Editor에서 다음 SQL을 실행한다.

[Supabase SQL Editor]

```sql
select
  schemaname,
  tablename,
  policyname,
  cmd,
  roles,
  qual,
  with_check
from pg_policies
where schemaname = 'public'
order by tablename, policyname;
```

이 결과를 보고 다음을 확인한다.

```text
[ ] items 테이블에 select 정책이 있다.
[ ] items 테이블에 insert 정책이 있다.
[ ] items 테이블에 update 정책이 있다.
[ ] items 테이블에 delete 정책이 있다.
[ ] 정책 조건에 auth.uid() 또는 사용자 id 조건이 있다.
[ ] 관리자 정책이 있다면 일반 사용자 정책과 분리되어 있다.
```

---

## 9.2 RLS 검토 요청

[AI 코딩 도구 - English prompt]

```text
Review the Supabase RLS policies in supabase/schema.sql.

Check whether:

1. RLS is enabled on user-owned tables,
2. select policies only allow users to read their own records,
3. insert policies bind new records to the authenticated user,
4. update and delete policies only allow the owner or authorized admin,
5. admin policies do not accidentally grant broad public access,
6. service role keys are not used in browser code.

Return PASS, CONCERNS, or FAIL.
For any concern, provide the exact SQL or code area to inspect.
```

[한국어 번역]

```text
supabase/schema.sql에 있는 Supabase RLS 정책을 검토해 주세요.

다음 항목을 확인해 주세요.

1. 사용자 소유 데이터 테이블에 RLS가 활성화되어 있는가
2. select 정책이 사용자가 자신의 record만 읽도록 제한하는가
3. insert 정책이 새 record를 인증된 사용자와 연결하는가
4. update와 delete 정책이 소유자 또는 권한 있는 관리자에게만 허용되는가
5. 관리자 정책이 실수로 public access를 넓게 허용하지 않는가
6. service role key가 브라우저 코드에서 사용되지 않는가

PASS, CONCERNS, FAIL 중 하나로 판정해 주세요.
문제가 있으면 확인해야 할 정확한 SQL 또는 코드 위치를 알려 주세요.
```

---

# 10. 실습 9 — 환경변수와 secret 점검

## 10.1 환경변수 기본 원칙

환경변수는 코드에 직접 쓰면 안 되는 값이다. 예를 들면 다음과 같다.

```text
Supabase URL
Supabase anon key
Supabase service role key
테스트 계정 비밀번호
외부 API key
```

중요한 구분은 다음이다.

| 종류 | 브라우저 노출 가능 여부 | 예시 |
|---|---|---|
| public 환경변수 | 노출될 수 있음 | `NEXT_PUBLIC_SUPABASE_URL` |
| anon key | 제한된 공개 key로 사용할 수 있으나 RLS가 필요 | `NEXT_PUBLIC_SUPABASE_ANON_KEY` |
| service role key | 절대 브라우저 노출 금지 | `SUPABASE_SERVICE_ROLE_KEY` |
| 비밀번호 | 절대 GitHub 커밋 금지 | 테스트 계정 비밀번호 |

> [!WARNING]
> `NEXT_PUBLIC_`으로 시작하는 환경변수는 브라우저 JavaScript에 포함될 수 있다. 따라서 `NEXT_PUBLIC_`에는 브라우저에 노출되어도 되는 값만 넣어야 한다.

---

## 10.2 .env.local.example 점검

`.env.local.example`에는 실제 값이 아니라 예시만 있어야 한다.

[파일 내용: `.env.local.example`]

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

`.env.local`에는 실제 값을 넣지만 GitHub에 올리지 않는다.

[파일 내용: `.gitignore`]

```gitignore
.env
.env.local
.env*.local
```

---

## 10.3 secret 검색 명령

GitHub에 올리기 전에 다음 명령으로 위험한 문자열을 검색한다.

### Windows PowerShell

[터미널]

```powershell
Select-String -Path * -Pattern "SUPABASE_SERVICE_ROLE|service_role|password|secret|api_key" -Recurse
```

### Mac Terminal

[터미널]

```bash
grep -R "SUPABASE_SERVICE_ROLE\|service_role\|password\|secret\|api_key" . --exclude-dir=node_modules --exclude-dir=.next --exclude-dir=.git
```

> [!NOTE]
> 검색 결과가 모두 문제는 아니다. 문서에서 “service role key를 쓰지 말라”고 설명한 문장도 검색될 수 있다. 그러나 실제 key처럼 보이는 값이 코드에 있으면 반드시 제거한다.

---

# 11. 실습 10 — 배포 전 build 검증

## 11.1 build란 무엇인가

개발 중에는 `npm run dev`로 실행한다. 그러나 실제 배포 전에는 프로젝트가 production build로 변환될 수 있는지 확인해야 한다.

[터미널]

```bash
npm run build
```

정상이라면 Next.js가 production build를 만들고, 오류 없이 종료된다.

---

## 11.2 build 실패 시 대응

자주 발생하는 오류는 다음과 같다.

| 오류 유형 | 의미 | 해결 방향 |
|---|---|---|
| TypeScript 오류 | 타입이 맞지 않음 | 해당 파일의 타입 수정 |
| 환경변수 오류 | 필요한 값이 없음 | `.env.local` 확인 |
| import 오류 | 파일 경로가 틀림 | import 경로 수정 |
| server/client 오류 | 서버 컴포넌트와 클라이언트 컴포넌트 경계 문제 | `use client` 위치 확인 |
| Supabase 세션 오류 | SSR client 설정 문제 | server/client Supabase client 분리 확인 |

AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구 - English prompt]

```text
npm run build failed.
Analyze the build error and identify the smallest safe fix.

Rules:
- Do not remove authentication or authorization checks.
- Do not expose secrets to the browser.
- Do not bypass TypeScript by using any unless absolutely necessary.
- Explain the root cause in beginner-friendly Korean.
```

[한국어 번역]

```text
npm run build가 실패했습니다.
build 오류를 분석하고 가장 작고 안전한 수정안을 찾아 주세요.

규칙:
- 인증이나 권한 검사를 제거하지 마세요.
- secret을 브라우저에 노출하지 마세요.
- 꼭 필요하지 않으면 any로 TypeScript를 우회하지 마세요.
- 원인을 초보자도 이해할 수 있는 한국어로 설명해 주세요.
```

---

# 12. 실습 11 — deployment-checklist.md 작성

## 12.1 배포 준비 체크리스트의 목적

배포 준비 체크리스트는 “지금 공개해도 되는가”를 판단하는 문서다.

체크리스트는 감이 아니라 근거로 판단하게 한다.

---

## 12.2 AI에게 배포 체크리스트 생성 요청

[AI 코딩 도구 - English prompt]

```text
Create docs/deployment-checklist.md.

The checklist must include:

1. local development check,
2. build check,
3. test check,
4. environment variable check,
5. Supabase RLS check,
6. authentication and authorization check,
7. Vercel Preview deployment check,
8. post-deployment smoke test,
9. rollback plan,
10. release decision.

For each item, include:
- check item,
- command or evidence,
- expected result,
- PASS/FAIL.
```

[한국어 번역]

```text
docs/deployment-checklist.md 파일을 만들어 주세요.

체크리스트에는 다음 항목을 포함해 주세요.

1. 로컬 개발 환경 확인
2. build 확인
3. 테스트 확인
4. 환경변수 확인
5. Supabase RLS 확인
6. 인증과 권한 확인
7. Vercel Preview 배포 확인
8. 배포 후 smoke test
9. rollback 계획
10. 릴리스 결정

각 항목에는 다음을 포함해 주세요.
- 점검 항목
- 명령 또는 근거
- 기대 결과
- PASS/FAIL
```

---

## 12.3 직접 붙여넣을 양식

[파일 내용: `docs/deployment-checklist.md`]

```md
# Deployment Checklist

## 1. Local Development Check

| Check | Command or Evidence | Expected Result | PASS/FAIL |
|---|---|---|---|
| 개발 서버 실행 | `npm run dev` | 오류 없이 실행 |  |
| 홈 화면 확인 | `http://localhost:3000` | 홈 화면 표시 |  |

## 2. Build Check

| Check | Command or Evidence | Expected Result | PASS/FAIL |
|---|---|---|---|
| Production build | `npm run build` | 오류 없이 성공 |  |

## 3. Test Check

| Check | Command or Evidence | Expected Result | PASS/FAIL |
|---|---|---|---|
| Unit tests | `npm run test:unit` | 모든 테스트 통과 |  |
| E2E tests | `npm run test:e2e` | 핵심 흐름 통과 |  |
| Manual QA | `docs/manual-qa-checklist.md` | 핵심 항목 PASS |  |

## 4. Security and Environment Check

| Check | Command or Evidence | Expected Result | PASS/FAIL |
|---|---|---|---|
| `.env.local` 미커밋 | `git status` | `.env.local`이 tracked file 아님 |  |
| service role key 미노출 | 코드 검색 | 브라우저 코드에 없음 |  |
| RLS 정책 존재 | Supabase SQL Editor | 사용자별 접근 제한 |  |

## 5. Vercel Preview Check

| Check | Command or Evidence | Expected Result | PASS/FAIL |
|---|---|---|---|
| GitHub 연결 | Vercel Dashboard | repository 연결됨 |  |
| Preview build | Vercel Dashboard | build 성공 |  |
| Preview 환경변수 | Vercel Dashboard | 필요한 값 설정됨 |  |
| Preview smoke test | Preview URL | 홈, 로그인, dashboard 확인 |  |

## 6. Rollback Plan

- 이전 안정 배포 버전:
- 문제가 생겼을 때 되돌릴 방법:
- 담당자:
- 알려야 할 사용자 또는 이해관계자:

## 7. Release Decision

- Decision: PASS / CONCERNS / FAIL
- Blocking issues:
- Non-blocking issues:
- Release notes path:
```

---

# 13. 실습 12 — Vercel Preview 배포 준비

## 13.1 Preview 배포란 무엇인가

Preview 배포는 실제 Production 공개 전에 확인하는 임시 배포 환경이다. GitHub repository와 Vercel을 연결하면, 일반적으로 변경사항마다 Preview URL이 생성된다.

초보자에게 중요한 점은 다음이다.

```text
로컬에서 되는 것과 배포 환경에서 되는 것은 다를 수 있다.
배포 환경에는 별도로 환경변수를 넣어야 한다.
Preview에서 먼저 확인하고 Production으로 넘겨야 한다.
```

---

## 13.2 GitHub 상태 확인

[터미널]

```bash
git status
```

아직 Git 저장소가 아니라면 다음을 실행한다.

[터미널]

```bash
git init
git add .
git commit -m "Prepare testing security and deployment readiness"
```

이미 Git 저장소라면 다음처럼 커밋한다.

[터미널]

```bash
git add .
git commit -m "Add tests security review and deployment checklist"
```

---

## 13.3 Vercel Dashboard에서 해야 할 일

[Vercel Dashboard]

```text
1. Vercel에 로그인한다.
2. Add New Project를 선택한다.
3. GitHub repository를 선택한다.
4. Framework Preset이 Next.js인지 확인한다.
5. Environment Variables에 필요한 값을 입력한다.
6. Deploy를 누른다.
7. Preview URL이 생성되면 접속한다.
```

환경변수에는 최소한 다음이 필요하다.

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
```

프로젝트가 서버 전용 secret을 사용한다면 해당 값은 반드시 서버 환경변수로만 관리한다.

> [!WARNING]
> Supabase service role key가 필요한 특별한 서버 작업이 있더라도, 이 값은 클라이언트 코드나 `NEXT_PUBLIC_` 환경변수에 넣으면 안 된다.

---

## 13.4 Preview URL에서 E2E 테스트 실행

Preview URL이 생기면 로컬 개발 서버가 아니라 Preview URL을 대상으로 E2E 테스트를 실행할 수 있다.

Mac/Linux:

[터미널]

```bash
PLAYWRIGHT_BASE_URL="https://your-preview-url.vercel.app" PLAYWRIGHT_SKIP_WEBSERVER=1 npm run test:e2e
```

Windows PowerShell:

[터미널]

```powershell
$env:PLAYWRIGHT_BASE_URL="https://your-preview-url.vercel.app"
$env:PLAYWRIGHT_SKIP_WEBSERVER="1"
npm run test:e2e
```

테스트 후 PowerShell 환경변수를 지우고 싶으면 다음을 실행한다.

[터미널]

```powershell
Remove-Item Env:PLAYWRIGHT_BASE_URL
Remove-Item Env:PLAYWRIGHT_SKIP_WEBSERVER
```

---

# 14. 실습 13 — release-notes.md 작성

## 14.1 릴리스 노트란 무엇인가

릴리스 노트는 이번 버전에서 무엇이 추가되었고, 무엇이 아직 제한적인지 설명하는 문서다.

초보 프로젝트라도 릴리스 노트를 쓰면 전문성이 크게 올라간다.

---

## 14.2 AI에게 릴리스 노트 작성 요청

[AI 코딩 도구 - English prompt]

```text
Create docs/release-notes.md for the current MVP version.

Include:

1. version name,
2. release date,
3. summary,
4. completed features,
5. test evidence,
6. known limitations,
7. security notes,
8. deployment notes,
9. next milestone.

Do not exaggerate the maturity of the service.
Clearly state what is still mock, incomplete, or experimental.
```

[한국어 번역]

```text
현재 MVP 버전을 위한 docs/release-notes.md 파일을 만들어 주세요.

다음 항목을 포함해 주세요.

1. 버전 이름
2. 릴리스 날짜
3. 요약
4. 완료된 기능
5. 테스트 근거
6. 알려진 한계
7. 보안 관련 메모
8. 배포 관련 메모
9. 다음 마일스톤

서비스의 완성도를 과장하지 마세요.
아직 mock이거나 미완성이거나 실험적인 부분은 명확히 적어 주세요.
```

---

## 14.3 릴리스 노트 예시

[파일 내용: `docs/release-notes.md`]

```md
# Release Notes

## Version

MVP Readiness Review v0.1

## Release Date

YYYY-MM-DD

## Summary

이번 버전은 인증, 권한, 사용자별 데이터 저장, 핵심 item 관리 흐름을 갖춘 웹서비스 MVP이다.

## Completed Features

- 회원가입
- 로그인
- 로그아웃
- 보호된 dashboard
- item 생성
- item 목록 조회
- item 상세 조회
- item 수정
- item 삭제
- 사용자별 데이터 소유권
- 관리자 페이지 접근 제한의 기본 구조

## Test Evidence

- Unit test:
- E2E test:
- Manual QA:
- Build check:
- Preview deployment:

## Known Limitations

- 결제 기능은 구현하지 않았다.
- 고급 관리자 통계는 구현하지 않았다.
- 이메일 인증 정책은 Supabase 설정에 따라 달라질 수 있다.
- 대규모 부하 테스트는 수행하지 않았다.

## Security Notes

- `.env.local`은 GitHub에 커밋하지 않는다.
- service role key는 브라우저 코드에서 사용하지 않는다.
- 사용자별 데이터 접근은 RLS 정책을 통해 제한한다.

## Next Milestone

- 사용자 경험 개선
- 관리자 기능 확장
- 오류 로깅과 모니터링 추가
- Production 배포 후 피드백 수집
```

---

# 15. README.md 보완

## 15.1 README에 추가할 섹션

7회차 이후 README에는 다음 섹션이 있어야 한다.

```text
1. How to Run Locally
2. Environment Variables
3. How to Test
4. Deployment
5. Security Notes
6. Known Limitations
```

---

## 15.2 AI에게 README 보완 요청

[AI 코딩 도구 - English prompt]

```text
Update README.md for Session 7.

Add or revise these sections:

1. How to Run Locally,
2. Environment Variables,
3. How to Test,
4. Deployment,
5. Security Notes,
6. Known Limitations.

Rules:
- Do not include real environment variable values.
- Mention that .env.local must not be committed.
- Explain npm run dev, npm run build, npm run test:unit, npm run test:e2e.
- Mention that Preview deployment should be tested before Production.
- Keep it beginner-friendly but professionally structured.
```

[한국어 번역]

```text
7회차 기준으로 README.md를 보완해 주세요.

다음 섹션을 추가하거나 수정해 주세요.

1. 로컬 실행 방법
2. 환경변수
3. 테스트 방법
4. 배포
5. 보안 메모
6. 알려진 한계

규칙:
- 실제 환경변수 값은 포함하지 마세요.
- .env.local은 커밋하면 안 된다고 명시해 주세요.
- npm run dev, npm run build, npm run test:unit, npm run test:e2e를 설명해 주세요.
- Production 배포 전에 Preview 배포에서 테스트해야 한다고 적어 주세요.
- 초보자도 이해할 수 있게 작성하되, 구조는 전문적으로 유지해 주세요.
```

---

# 16. 최종 품질 게이트

7회차가 끝나기 전에 다음을 모두 확인한다.

## 16.1 테스트 게이트

```text
[ ] docs/test-plan.md가 있다.
[ ] docs/manual-qa-checklist.md가 있다.
[ ] playwright.config.ts가 있다.
[ ] tests/e2e/home.spec.ts가 있다.
[ ] tests/e2e/protected-routes.spec.ts가 있다.
[ ] 로그인 또는 인증 관련 E2E 테스트가 있다.
[ ] item 흐름 E2E 테스트가 있다.
[ ] npm run test:e2e가 실행된다.
[ ] 단위 테스트가 최소 1개 있다.
[ ] npm run test:unit이 실행된다.
```

## 16.2 보안 게이트

```text
[ ] docs/security-review.md가 있다.
[ ] `.env.local`이 GitHub에 올라가지 않는다.
[ ] `.env.test.local`이 GitHub에 올라가지 않는다.
[ ] service role key가 브라우저 코드에 없다.
[ ] RLS 정책이 확인되었다.
[ ] 일반 사용자가 관리자 페이지에 접근할 수 없다.
[ ] 사용자 A가 사용자 B의 데이터를 볼 수 없다.
[ ] 오류 메시지가 내부 secret을 노출하지 않는다.
```

## 16.3 배포 게이트

```text
[ ] docs/deployment-checklist.md가 있다.
[ ] npm run build가 성공한다.
[ ] Preview 배포가 가능하다.
[ ] Preview URL에서 smoke test를 수행했다.
[ ] 환경변수가 Vercel에 설정되어 있다.
[ ] release-notes.md가 있다.
[ ] README.md에 테스트와 배포 안내가 있다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구 - English prompt]

```text
Check the current project against the Session 7 quality gates.

Evaluate:

1. test plan,
2. manual QA checklist,
3. Playwright setup,
4. E2E tests,
5. unit tests,
6. security review,
7. RLS review,
8. environment variable safety,
9. build readiness,
10. deployment checklist,
11. release notes,
12. README updates.

Return PASS, CONCERNS, or FAIL.
For every concern, provide the exact fix.
Do not weaken security or authorization to pass the gate.
```

[한국어 번역]

```text
현재 프로젝트를 7회차 품질 게이트 기준으로 점검해 주세요.

다음 항목을 평가해 주세요.

1. 테스트 계획서
2. 수동 QA 체크리스트
3. Playwright 설정
4. E2E 테스트
5. 단위 테스트
6. 보안 검토
7. RLS 검토
8. 환경변수 안전성
9. build 준비도
10. 배포 체크리스트
11. 릴리스 노트
12. README 보완

PASS, CONCERNS, FAIL 중 하나로 판정해 주세요.
문제가 있으면 정확한 수정 방법을 제시해 주세요.
품질 게이트를 통과하기 위해 보안이나 권한을 약화시키지 마세요.
```

---

# 17. GitHub에 커밋하기

## 17.1 변경 사항 확인

[터미널]

```bash
git status
```

`.env.local` 또는 `.env.test.local`이 커밋 대상에 있으면 안 된다.

문제가 없다면 커밋한다.

[터미널]

```bash
git add .
git commit -m "Add testing security review and deployment readiness"
```

> [!IMPORTANT]
> 커밋 전에 반드시 `git status`를 보고 실제 secret 파일이 포함되어 있지 않은지 확인한다.

---

# 18. 과제 안내

## 과제 1. Preview 배포 결과 기록

`docs/deployment-checklist.md`에 Preview 배포 결과를 기록한다.

```text
Preview URL:
Build status:
Environment variables configured:
Smoke test result:
Known issues:
Release decision:
```

---

## 과제 2. 보안 위험 3개 작성

`docs/security-review.md`에 현재 프로젝트에서 가장 중요한 보안 위험 3개를 적는다.

예시:

```text
1. RLS 정책이 잘못 작성되면 다른 사용자의 데이터를 볼 수 있다.
2. service role key가 노출되면 데이터베이스 접근 통제가 무력화될 수 있다.
3. 관리자 페이지 접근 제한이 약하면 일반 사용자가 운영 기능에 접근할 수 있다.
```

각 위험에 대해 다음을 쓴다.

```text
위험 설명:
발생 가능성:
영향:
현재 대응:
추가로 필요한 대응:
```

---

## 과제 3. 테스트 실패 사례 하나 분석

의도적으로 하나의 테스트를 실패시킨 뒤, 왜 실패했는지 기록한다.

```text
실패한 테스트:
실패 메시지:
원인:
수정 방법:
배운 점:
```

---

# 19. 자주 생기는 문제와 해결법

## 19.1 `npx playwright install`이 오래 걸린다

Playwright는 테스트용 브라우저를 설치하므로 시간이 걸릴 수 있다. 설치가 완료될 때까지 기다린다. 네트워크 문제가 있으면 다시 실행한다.

[터미널]

```bash
npx playwright install
```

---

## 19.2 `npm run test:e2e`가 서버 시작에서 멈춘다

가능한 원인:

```text
이미 다른 포트에서 서버가 실행 중이다.
프로젝트가 build 오류를 가지고 있다.
환경변수가 누락되었다.
```

먼저 개발 서버가 직접 실행되는지 확인한다.

[터미널]

```bash
npm run dev
```

---

## 19.3 로그인 테스트가 실패한다

가능한 원인:

```text
테스트 계정이 없다.
비밀번호가 틀렸다.
Supabase 이메일 인증이 필요하다.
로그인 form의 label이 테스트 코드와 다르다.
로그인 후 이동 경로가 다르다.
```

해결:

```text
1. Supabase Authentication에서 테스트 사용자가 있는지 확인한다.
2. .env.test.local의 이메일과 비밀번호를 확인한다.
3. 브라우저에서 직접 로그인해 본다.
4. 테스트 코드를 실제 label과 route에 맞게 수정한다.
```

---

## 19.4 Vercel 배포에서만 실패한다

가능한 원인:

```text
Vercel에 환경변수를 넣지 않았다.
Production과 Preview 환경변수가 다르다.
로컬에는 있는 파일이 GitHub에는 없다.
TypeScript 오류가 로컬에서 무시되었다.
```

확인:

```text
1. Vercel Project Settings → Environment Variables 확인
2. Vercel Build Logs 확인
3. git status로 커밋 누락 확인
4. npm run build를 로컬에서 실행
```

---

## 19.5 secret이 실수로 커밋되었다

즉시 다음을 수행한다.

```text
1. 해당 key를 Supabase 또는 외부 서비스에서 폐기한다.
2. 새 key를 발급한다.
3. Git history에서 제거가 필요한지 판단한다.
4. 팀원 또는 교수자에게 알린다.
```

단순히 파일에서 지우는 것만으로는 이미 커밋된 secret 문제가 해결되지 않을 수 있다.

---

# 20. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> 좋은 웹서비스는 작동하는 화면뿐 아니라, 테스트·보안·배포 기준을 함께 갖춘 서비스이다.

7회차의 흐름은 다음과 같다.

```text
6회차 산출물 확인
→ 테스트 계획서 작성
→ 수동 QA 체크리스트 작성
→ Playwright 설정
→ E2E 테스트 작성
→ 단위 테스트 추가
→ 보안 검토
→ RLS 검토
→ 환경변수 점검
→ build 검증
→ Preview 배포 준비
→ 릴리스 노트 작성
```

---

# 21. 7회차 최종 체크리스트

수업이 끝나기 전에 스스로 확인한다.

```text
[ ] 테스트 계획서의 목적을 설명할 수 있다.
[ ] 수동 QA와 E2E 테스트의 차이를 설명할 수 있다.
[ ] Playwright를 설치했다.
[ ] playwright.config.ts를 만들었다.
[ ] 홈 화면 E2E 테스트를 작성했다.
[ ] 보호된 라우트 E2E 테스트를 작성했다.
[ ] 로그인 또는 item 흐름 테스트를 작성했다.
[ ] 단위 테스트를 최소 1개 작성했다.
[ ] 보안 검토 문서를 작성했다.
[ ] RLS 정책을 확인했다.
[ ] 환경변수와 secret을 점검했다.
[ ] npm run build를 실행했다.
[ ] 배포 체크리스트를 작성했다.
[ ] Preview 배포 준비 방법을 이해했다.
[ ] 릴리스 노트를 작성했다.
```

---

## 부록 A. 오늘 사용하는 핵심 명령 모음

### 터미널 명령

```bash
pwd
npm run dev
npm install -D @playwright/test
npx playwright install
npm install -D vitest
npm run test:unit
npm run test:e2e
npm run test:e2e:headed
npm run build
git status
git add .
git commit -m "Add testing security review and deployment readiness"
```

### Windows PowerShell Preview 테스트 명령

```powershell
$env:PLAYWRIGHT_BASE_URL="https://your-preview-url.vercel.app"
$env:PLAYWRIGHT_SKIP_WEBSERVER="1"
npm run test:e2e
Remove-Item Env:PLAYWRIGHT_BASE_URL
Remove-Item Env:PLAYWRIGHT_SKIP_WEBSERVER
```

### Supabase SQL Editor 명령

```sql
select
  schemaname,
  tablename,
  policyname,
  cmd,
  roles,
  qual,
  with_check
from pg_policies
where schemaname = 'public'
order by tablename, policyname;
```

---

## 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| QA | Quality Assurance. 서비스 품질을 확인하는 절차 |
| Unit Test | 작은 함수나 모듈 하나를 검증하는 테스트 |
| E2E Test | 사용자의 실제 흐름을 브라우저로 자동 실행하는 테스트 |
| Smoke Test | 배포 후 핵심 기능이 최소한 작동하는지 빠르게 확인하는 테스트 |
| RLS | Row Level Security. 행 단위로 데이터 접근을 제한하는 보안 방식 |
| Secret | 외부에 노출되면 안 되는 key, token, password |
| Preview Deployment | Production 공개 전 확인용 임시 배포 |
| Production Deployment | 실제 사용자가 접근하는 운영 배포 |
| Rollback | 문제가 생겼을 때 이전 안정 버전으로 되돌리는 절차 |
| Release Notes | 이번 버전의 변경 사항과 한계를 정리한 문서 |
