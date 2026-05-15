# 4회차 학습자 실습 매뉴얼: 웹서비스 트랙

# 웹서비스 MVP 골격 구현
## 실행 환경 확인 → Next.js 골격 생성 → 화면 라우팅 → mock data → form validation → API mock → 품질 게이트

---

## 이 자료의 목적

4회차의 목표는 완성된 서비스를 만드는 것이 아니다. 4회차의 목표는 3회차에서 만든 웹서비스 설계 문서를 바탕으로 **브라우저에서 실제로 열리는 MVP 골격**을 만드는 것이다.

3회차에서는 다음 산출물을 만들었다.

```text
_bmad-output/architecture.md
_bmad-output/epics-and-stories.md
docs/user-flow.md
docs/screen-map.md
docs/route-map.md
docs/data-model-draft.md
docs/api-contract-draft.md
docs/auth-and-security.md
docs/test-plan.md
```

4회차에서는 이 문서들을 바탕으로 다음 산출물을 만든다.

```text
1. 실행 가능한 Next.js 프로젝트 골격
2. 공통 레이아웃과 상단 내비게이션
3. 핵심 페이지 6개 이상
4. mock data 기반 목록·상세 화면
5. 기본 입력 form과 validation
6. mock API route
7. README 실행 방법 보완
8. 4회차 품질 게이트 결과
```

오늘의 핵심 문장은 다음이다.

> 웹서비스 MVP의 첫 단계는 모든 기능을 완성하는 것이 아니라, 사용자가 이동할 수 있는 화면 구조를 먼저 고정하는 것이다.

4회차가 끝나면 학습자는 다음을 할 수 있어야 한다.

```text
브라우저에서 웹서비스를 실행한다.
홈 화면에서 핵심 화면으로 이동한다.
목록 화면에서 상세 화면으로 이동한다.
mock data를 화면에 표시한다.
입력 form에서 빈 값 오류를 확인한다.
API endpoint가 JSON을 반환하는지 확인한다.
```

---

## 오늘 끝나면 있어야 하는 것

4회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
my-web-service/
├── _bmad-output/
│   ├── project-context.md
│   ├── product-brief.md
│   ├── PRD.md
│   ├── architecture.md
│   └── epics-and-stories.md
├── docs/
│   ├── user-flow.md
│   ├── screen-map.md
│   ├── route-map.md
│   ├── data-model-draft.md
│   ├── api-contract-draft.md
│   ├── auth-and-security.md
│   ├── test-plan.md
│   └── implementation-notes.md
├── src/
│   ├── app/
│   │   ├── api/
│   │   │   └── items/
│   │   │       └── route.ts
│   │   ├── admin/
│   │   │   └── page.tsx
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── items/
│   │   │   ├── [id]/
│   │   │   │   └── page.tsx
│   │   │   ├── new/
│   │   │   │   └── page.tsx
│   │   │   └── page.tsx
│   │   ├── login/
│   │   │   └── page.tsx
│   │   ├── signup/
│   │   │   └── page.tsx
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── components/
│   │   ├── AppHeader.tsx
│   │   ├── ItemCard.tsx
│   │   ├── ItemForm.tsx
│   │   ├── PageShell.tsx
│   │   └── StatusBadge.tsx
│   ├── lib/
│   │   ├── mock-data.ts
│   │   └── validation.ts
│   └── types/
│       └── index.ts
├── public/
├── README.md
├── package.json
├── next.config.ts
└── tsconfig.json
```

> [!NOTE]
> 이 자료는 수업 표준 스택으로 `Next.js + React + TypeScript`를 사용한다. 2회차 또는 3회차에서 다른 기술 스택을 명시적으로 선택했다면, 원칙은 동일하게 유지하되 명령과 파일명은 해당 스택에 맞게 조정한다. 초보자는 우선 이 교안의 표준 스택을 그대로 따라가는 것이 안전하다.

---

## 오늘 사용할 입력 위치를 구분하자

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `npm run dev` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `Create the MVP skeleton` |
| `[파일 내용]` | TypeScript, CSS, Markdown 파일 안에 들어갈 내용 | `export default function Page()` |

아래 명령은 터미널에 입력한다.

```bash
npm run dev
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create src/app/page.tsx
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

정상이라면 대략 다음과 비슷하게 나온다.

```text
C:\Users\내이름\my-web-service
```

또는:

```text
/Users/내이름/my-web-service
```

> [!IMPORTANT]
> 오늘 모든 명령은 프로젝트 폴더 안에서 실행한다. `pwd` 결과가 프로젝트 폴더가 아니면 먼저 프로젝트 폴더로 이동한다.

---

## 0.3 3회차 산출물이 있는지 확인한다

4회차는 3회차 산출물이 있어야 안정적으로 진행할 수 있다.

### Windows PowerShell

[터미널]

```powershell
dir docs
dir _bmad-output
```

### Mac Terminal

[터미널]

```bash
ls docs
ls _bmad-output
```

다음 파일이 있어야 한다.

```text
docs/user-flow.md
docs/screen-map.md
docs/route-map.md
docs/data-model-draft.md
docs/api-contract-draft.md
docs/auth-and-security.md
docs/test-plan.md
_bmad-output/architecture.md
```

파일이 일부 없다면 AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구]

```text
Check whether the Session 3 web service outputs exist:

- _bmad-output/architecture.md
- docs/user-flow.md
- docs/screen-map.md
- docs/route-map.md
- docs/data-model-draft.md
- docs/api-contract-draft.md
- docs/auth-and-security.md
- docs/test-plan.md

If any file is missing, tell me the exact file to recreate and the shortest safe prompt to recreate it.
Do not start implementation until the missing design document is identified.
```

---

## 0.4 Node.js와 npm이 설치되어 있는지 확인한다

웹서비스 프로젝트는 Python이 아니라 JavaScript/TypeScript 실행 환경을 사용한다. 여기서 `Node.js`는 JavaScript를 컴퓨터에서 실행하게 해 주는 프로그램이고, `npm`은 필요한 패키지를 설치하는 도구이다.

[터미널]

```bash
node --version
npm --version
```

정상이라면 다음과 비슷하게 버전이 나온다.

```text
v20.11.1
10.2.4
```

오류가 나오면 Node.js가 설치되지 않은 것이다. 이 경우 Node.js LTS 버전을 설치한 뒤 터미널을 새로 열고 다시 확인한다.

> [!NOTE]
> Next.js 최신 버전은 Node.js 20.9 이상을 요구한다. 버전이 너무 낮으면 `npm run dev` 단계에서 오류가 날 수 있다.

---

# 1. 오늘 구현 범위 이해하기

## 1.1 오늘 하지 않는 것

4회차에서는 다음을 하지 않는다.

```text
실제 회원가입 데이터 저장
실제 로그인 인증
실제 데이터베이스 연결
실제 결제 기능
실제 배포
복잡한 관리자 권한 시스템
외부 API 연동
```

이것들은 중요하지만, 초보자가 처음 웹서비스를 만들 때 한 번에 모두 넣으면 구조가 무너진다.

오늘은 다음을 먼저 만든다.

```text
화면 구조
이동 경로
mock data
입력값 검증
mock API
실행 가능한 프로젝트 골격
```

---

## 1.2 mock data란 무엇인가

`mock data`는 실제 데이터베이스에서 가져온 데이터가 아니라, 화면을 만들기 위해 임시로 만든 가짜 데이터이다.

예를 들어 아직 데이터베이스가 없어도 다음과 같은 데이터를 만들어 화면에 표시할 수 있다.

```text
제목: 연구실 예약 요청
상태: active
작성자: 김연구
등록일: 2026-05-15
```

mock data를 쓰는 이유는 다음과 같다.

```text
데이터베이스 없이도 화면을 먼저 만들 수 있다.
사용자 흐름을 빠르게 검증할 수 있다.
디자이너와 기획자가 화면을 먼저 확인할 수 있다.
API와 DB는 나중에 교체할 수 있다.
```

---

## 1.3 오늘의 표준 사용자 흐름

3회차에서 만든 `docs/user-flow.md`가 source of truth이다. 다만 수업에서는 다음 기본 흐름을 사용한다.

```text
Home
→ Signup 또는 Login
→ Dashboard
→ Items 목록
→ Item 상세
→ Item 생성 form
→ Admin 화면
```

여기서 `Item`은 실제 서비스의 핵심 데이터 단위이다. 예를 들어 서비스 종류에 따라 다음처럼 바꿔 이해하면 된다.

| 서비스 유형 | Item의 의미 |
|---|---|
| 예약 시스템 | 예약 요청 |
| 교육 플랫폼 | 강의 또는 과제 |
| 동아리 프로젝트 | 행사 또는 신청서 |
| 관리자 웹앱 | 관리 대상 항목 |
| SaaS MVP | 사용자가 생성하는 업무 객체 |

---

# 2. 실습 1 — AI에게 구현 계획을 먼저 확인시키기

## 2.1 AI 코딩 도구를 실행한다

Gemini CLI를 사용하는 경우:

[터미널]

```bash
gemini
```

Claude Code를 사용하는 경우:

[터미널]

```bash
claude
```

AI 코딩 도구가 열리면 다음을 입력한다.

[AI 코딩 도구]

```text
bmad-help
```

---

## 2.2 오늘 구현 범위를 AI에게 고정한다

[AI 코딩 도구]

```text
We are starting Session 4 of the web service track.

Goal:
Build a beginner-friendly MVP skeleton, not a complete production service.

Use the Session 3 documents as the source of truth:
- _bmad-output/architecture.md
- docs/user-flow.md
- docs/screen-map.md
- docs/route-map.md
- docs/data-model-draft.md
- docs/api-contract-draft.md
- docs/auth-and-security.md
- docs/test-plan.md

Implementation scope for today:
- Use Next.js, React, and TypeScript.
- Create a working app structure under src/app/.
- Create common layout and navigation.
- Create Home, Login, Signup, Dashboard, Items, Item Detail, New Item, and Admin pages.
- Use mock data only.
- Add basic form validation.
- Add a mock API route that returns JSON.
- Do not connect a real database.
- Do not implement real authentication.
- Do not add payment, deployment, or external API integration.
- Do not hard-code API keys or secrets.

Before editing files, summarize the implementation plan and list the files you will create or modify.
```

AI가 계획을 제시하면 다음 기준으로 확인한다.

```text
[ ] 실제 DB 연결을 하겠다고 하지 않는가?
[ ] 실제 인증 구현을 하겠다고 하지 않는가?
[ ] mock data를 사용한다고 되어 있는가?
[ ] 페이지 목록이 route-map 또는 screen-map과 충돌하지 않는가?
[ ] 오늘 만들 파일 목록이 명확한가?
```

계획이 맞으면 다음을 입력한다.

[AI 코딩 도구]

```text
Proceed with the Session 4 MVP skeleton implementation.
Keep the code beginner-readable.
After creating files, tell me the exact command to run the app.
```

AI가 파일을 잘 만들면 7장으로 이동한다. AI가 파일을 만들지 못하거나, 학습자가 직접 작성해야 한다면 3장부터 그대로 따라간다.

---

# 3. 실습 2 — Next.js 기본 설정 만들기

## 3.1 package.json 작성

`package.json`은 이 웹서비스가 어떤 패키지를 사용하고, 어떤 명령으로 실행되는지 기록하는 파일이다.

### Windows PowerShell

[터미널]

```powershell
@'
{
  "name": "my-web-service",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "latest",
    "react": "latest",
    "react-dom": "latest"
  },
  "devDependencies": {
    "@types/node": "latest",
    "@types/react": "latest",
    "@types/react-dom": "latest",
    "eslint": "latest",
    "eslint-config-next": "latest",
    "typescript": "latest"
  }
}
'@ | Set-Content package.json -Encoding UTF8
```

### Mac Terminal

[터미널]

```bash
cat > package.json <<'EOF'
{
  "name": "my-web-service",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "latest",
    "react": "latest",
    "react-dom": "latest"
  },
  "devDependencies": {
    "@types/node": "latest",
    "@types/react": "latest",
    "@types/react-dom": "latest",
    "eslint": "latest",
    "eslint-config-next": "latest",
    "typescript": "latest"
  }
}
EOF
```

---

## 3.2 패키지 설치

[터미널]

```bash
npm install
```

정상이라면 `node_modules/` 폴더와 `package-lock.json` 파일이 만들어진다.

> [!IMPORTANT]
> `node_modules/`는 매우 큰 폴더이다. GitHub에 올리지 않는다. `.gitignore`에 반드시 포함한다.

---

## 3.3 TypeScript 설정 파일 작성

### Windows PowerShell

[터미널]

```powershell
@'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
'@ | Set-Content tsconfig.json -Encoding UTF8

@'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {};

export default nextConfig;
'@ | Set-Content next.config.ts -Encoding UTF8

@'
/// <reference types="next" />
/// <reference types="next/image-types/global" />

// This file is generated for Next.js TypeScript support.
'@ | Set-Content next-env.d.ts -Encoding UTF8
```

### Mac Terminal

[터미널]

```bash
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

cat > next.config.ts <<'EOF'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {};

export default nextConfig;
EOF

cat > next-env.d.ts <<'EOF'
/// <reference types="next" />
/// <reference types="next/image-types/global" />

// This file is generated for Next.js TypeScript support.
EOF
```

---

## 3.4 폴더 만들기

### Windows PowerShell

[터미널]

```powershell
$dirs = @(
  "src/app/api/items",
  "src/app/admin",
  "src/app/dashboard",
  "src/app/items/[id]",
  "src/app/items/new",
  "src/app/login",
  "src/app/signup",
  "src/components",
  "src/lib",
  "src/types",
  "public",
  "docs"
)

foreach ($d in $dirs) {
  New-Item -ItemType Directory -Force $d | Out-Null
}
```

### Mac Terminal

[터미널]

```bash
mkdir -p src/app/api/items src/app/admin src/app/dashboard
mkdir -p 'src/app/items/[id]' src/app/items/new src/app/login src/app/signup
mkdir -p src/components src/lib src/types public docs
```

---

# 4. 실습 3 — 공통 타입과 mock data 만들기

## 4.1 src/types/index.ts

[파일 내용: `src/types/index.ts`]

```ts
export type UserRole = "guest" | "user" | "admin";
export type ItemStatus = "draft" | "active" | "archived";

export interface UserProfile {
  id: string;
  name: string;
  email: string;
  role: UserRole;
}

export interface ServiceItem {
  id: string;
  title: string;
  description: string;
  status: ItemStatus;
  ownerName: string;
  createdAt: string;
  updatedAt: string;
}
```

---

## 4.2 src/lib/mock-data.ts

[파일 내용: `src/lib/mock-data.ts`]

```ts
import type { ServiceItem, UserProfile } from "@/types";

export const currentUser: UserProfile = {
  id: "user-001",
  name: "김연구",
  email: "researcher@example.com",
  role: "user",
};

export const adminUser: UserProfile = {
  id: "admin-001",
  name: "관리자",
  email: "admin@example.com",
  role: "admin",
};

export const mockItems: ServiceItem[] = [
  {
    id: "item-001",
    title: "연구실 장비 예약 요청",
    description: "공동 연구실의 분석 장비 사용 시간을 예약하기 위한 요청이다.",
    status: "active",
    ownerName: "김연구",
    createdAt: "2026-05-01",
    updatedAt: "2026-05-02",
  },
  {
    id: "item-002",
    title: "세미나 참석 신청",
    description: "대학원 세미나 참석자를 모집하고 신청 상태를 관리한다.",
    status: "draft",
    ownerName: "이분석",
    createdAt: "2026-05-03",
    updatedAt: "2026-05-04",
  },
  {
    id: "item-003",
    title: "자료 검토 요청",
    description: "외부 프로젝트 제안서에 포함될 자료의 검토 상태를 추적한다.",
    status: "archived",
    ownerName: "박기획",
    createdAt: "2026-04-20",
    updatedAt: "2026-04-28",
  },
];

export function getItemById(id: string): ServiceItem | undefined {
  return mockItems.find((item) => item.id === id);
}
```

---

## 4.3 src/lib/validation.ts

[파일 내용: `src/lib/validation.ts`]

```ts
export interface ItemFormValues {
  title: string;
  description: string;
}

export interface ValidationResult {
  isValid: boolean;
  errors: Partial<Record<keyof ItemFormValues, string>>;
}

export function validateItemForm(values: ItemFormValues): ValidationResult {
  const errors: ValidationResult["errors"] = {};

  if (!values.title.trim()) {
    errors.title = "제목은 반드시 입력해야 한다.";
  }

  if (values.title.trim().length > 80) {
    errors.title = "제목은 80자 이하로 입력해야 한다.";
  }

  if (!values.description.trim()) {
    errors.description = "설명은 반드시 입력해야 한다.";
  }

  if (values.description.trim().length < 10) {
    errors.description = "설명은 최소 10자 이상 입력해야 한다.";
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors,
  };
}
```

---

# 5. 실습 4 — 공통 컴포넌트 만들기

## 5.1 src/components/StatusBadge.tsx

[파일 내용: `src/components/StatusBadge.tsx`]

```tsx
import type { ItemStatus } from "@/types";

const STATUS_LABEL: Record<ItemStatus, string> = {
  draft: "작성 중",
  active: "진행 중",
  archived: "보관됨",
};

export function StatusBadge({ status }: { status: ItemStatus }) {
  return <span className={`status-badge status-${status}`}>{STATUS_LABEL[status]}</span>;
}
```

---

## 5.2 src/components/AppHeader.tsx

[파일 내용: `src/components/AppHeader.tsx`]

```tsx
import Link from "next/link";

export function AppHeader() {
  return (
    <header className="app-header">
      <Link className="brand" href="/">
        Web Service Lab
      </Link>
      <nav className="nav-links" aria-label="주요 화면">
        <Link href="/dashboard">Dashboard</Link>
        <Link href="/items">Items</Link>
        <Link href="/items/new">New Item</Link>
        <Link href="/admin">Admin</Link>
        <Link href="/login">Login</Link>
      </nav>
    </header>
  );
}
```

---

## 5.3 src/components/PageShell.tsx

[파일 내용: `src/components/PageShell.tsx`]

```tsx
import type { ReactNode } from "react";

interface PageShellProps {
  title: string;
  description: string;
  children: ReactNode;
}

export function PageShell({ title, description, children }: PageShellProps) {
  return (
    <section className="page-shell">
      <div className="page-heading">
        <h1>{title}</h1>
        <p>{description}</p>
      </div>
      {children}
    </section>
  );
}
```

---

## 5.4 src/components/ItemCard.tsx

[파일 내용: `src/components/ItemCard.tsx`]

```tsx
import Link from "next/link";
import type { ServiceItem } from "@/types";
import { StatusBadge } from "@/components/StatusBadge";

export function ItemCard({ item }: { item: ServiceItem }) {
  return (
    <article className="card">
      <div className="card-header">
        <h2>{item.title}</h2>
        <StatusBadge status={item.status} />
      </div>
      <p>{item.description}</p>
      <dl className="meta-grid">
        <div>
          <dt>작성자</dt>
          <dd>{item.ownerName}</dd>
        </div>
        <div>
          <dt>수정일</dt>
          <dd>{item.updatedAt}</dd>
        </div>
      </dl>
      <Link className="text-link" href={`/items/${item.id}`}>
        상세 보기
      </Link>
    </article>
  );
}
```

---

## 5.5 src/components/ItemForm.tsx

[파일 내용: `src/components/ItemForm.tsx`]

```tsx
"use client";

import { useState } from "react";
import { validateItemForm, type ItemFormValues } from "@/lib/validation";

const INITIAL_VALUES: ItemFormValues = {
  title: "",
  description: "",
};

export function ItemForm() {
  const [values, setValues] = useState<ItemFormValues>(INITIAL_VALUES);
  const [errors, setErrors] = useState<Partial<Record<keyof ItemFormValues, string>>>({});
  const [submitted, setSubmitted] = useState(false);

  function updateField(field: keyof ItemFormValues, value: string) {
    setValues((current) => ({ ...current, [field]: value }));
    setSubmitted(false);
  }

  function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const result = validateItemForm(values);
    setErrors(result.errors);
    setSubmitted(result.isValid);
  }

  return (
    <form className="form-card" onSubmit={handleSubmit} noValidate>
      <label htmlFor="title">제목</label>
      <input
        id="title"
        name="title"
        value={values.title}
        onChange={(event) => updateField("title", event.target.value)}
        placeholder="예: 연구실 장비 예약 요청"
      />
      {errors.title ? <p className="error-message">{errors.title}</p> : null}

      <label htmlFor="description">설명</label>
      <textarea
        id="description"
        name="description"
        value={values.description}
        onChange={(event) => updateField("description", event.target.value)}
        placeholder="요청의 목적과 필요한 정보를 입력한다."
        rows={5}
      />
      {errors.description ? <p className="error-message">{errors.description}</p> : null}

      <button className="primary-button" type="submit">
        mock item 생성하기
      </button>

      {submitted ? (
        <p className="success-message">
          입력값 검증을 통과했다. 오늘은 실제 DB 저장 대신 화면 검증까지만 수행한다.
        </p>
      ) : null}
    </form>
  );
}
```

---

# 6. 실습 5 — App Router 페이지 만들기

## 6.1 src/app/layout.tsx

[파일 내용: `src/app/layout.tsx`]

```tsx
import type { Metadata } from "next";
import { AppHeader } from "@/components/AppHeader";
import "./globals.css";

export const metadata: Metadata = {
  title: "Web Service Lab",
  description: "Beginner-friendly MVP skeleton for a web service project",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="ko">
      <body>
        <AppHeader />
        <main className="app-main">{children}</main>
      </body>
    </html>
  );
}
```

---

## 6.2 src/app/page.tsx

[파일 내용: `src/app/page.tsx`]

```tsx
import Link from "next/link";
import { mockItems } from "@/lib/mock-data";

export default function HomePage() {
  return (
    <section className="hero">
      <p className="eyebrow">Session 4 MVP Skeleton</p>
      <h1>사용자 흐름을 브라우저에서 확인하는 첫 번째 웹서비스 골격</h1>
      <p>
        이 화면은 완성된 서비스가 아니라, 3회차에서 설계한 화면과 경로가 실제로 연결되는지
        검증하기 위한 MVP 골격이다.
      </p>
      <div className="button-row">
        <Link className="primary-button" href="/dashboard">
          Dashboard로 이동
        </Link>
        <Link className="secondary-button" href="/items">
          Items 보기
        </Link>
      </div>
      <div className="summary-grid">
        <div className="summary-box">
          <strong>{mockItems.length}</strong>
          <span>mock items</span>
        </div>
        <div className="summary-box">
          <strong>6+</strong>
          <span>core pages</span>
        </div>
        <div className="summary-box">
          <strong>0</strong>
          <span>real secrets</span>
        </div>
      </div>
    </section>
  );
}
```

---

## 6.3 src/app/dashboard/page.tsx

[파일 내용: `src/app/dashboard/page.tsx`]

```tsx
import Link from "next/link";
import { PageShell } from "@/components/PageShell";
import { currentUser, mockItems } from "@/lib/mock-data";

export default function DashboardPage() {
  const activeCount = mockItems.filter((item) => item.status === "active").length;
  const draftCount = mockItems.filter((item) => item.status === "draft").length;

  return (
    <PageShell
      title="Dashboard"
      description="사용자가 로그인 후 가장 먼저 확인하는 요약 화면이다. 현재는 mock data를 사용한다."
    >
      <div className="card-grid">
        <article className="card">
          <h2>현재 사용자</h2>
          <p>{currentUser.name}</p>
          <p className="muted">{currentUser.email}</p>
        </article>
        <article className="card">
          <h2>진행 중 항목</h2>
          <p className="large-number">{activeCount}</p>
        </article>
        <article className="card">
          <h2>작성 중 항목</h2>
          <p className="large-number">{draftCount}</p>
        </article>
      </div>
      <div className="button-row">
        <Link className="primary-button" href="/items">
          목록 확인하기
        </Link>
        <Link className="secondary-button" href="/items/new">
          새 항목 만들기
        </Link>
      </div>
    </PageShell>
  );
}
```

---

## 6.4 src/app/items/page.tsx

[파일 내용: `src/app/items/page.tsx`]

```tsx
import Link from "next/link";
import { ItemCard } from "@/components/ItemCard";
import { PageShell } from "@/components/PageShell";
import { mockItems } from "@/lib/mock-data";

export default function ItemsPage() {
  return (
    <PageShell
      title="Items"
      description="서비스의 핵심 데이터 목록 화면이다. 실제 DB 연결 전까지는 mock data로 화면 구조를 검증한다."
    >
      <div className="button-row">
        <Link className="primary-button" href="/items/new">
          새 item 만들기
        </Link>
      </div>
      <div className="card-grid">
        {mockItems.map((item) => (
          <ItemCard key={item.id} item={item} />
        ))}
      </div>
    </PageShell>
  );
}
```

---

## 6.5 src/app/items/[id]/page.tsx

[파일 내용: `src/app/items/[id]/page.tsx`]

```tsx
import Link from "next/link";
import { notFound } from "next/navigation";
import { PageShell } from "@/components/PageShell";
import { StatusBadge } from "@/components/StatusBadge";
import { getItemById } from "@/lib/mock-data";

export default async function ItemDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const item = getItemById(id);

  if (!item) {
    notFound();
  }

  return (
    <PageShell
      title={item.title}
      description="목록에서 선택한 개별 item의 상세 화면이다."
    >
      <article className="card detail-card">
        <div className="card-header">
          <h2>상세 정보</h2>
          <StatusBadge status={item.status} />
        </div>
        <p>{item.description}</p>
        <dl className="meta-grid">
          <div>
            <dt>ID</dt>
            <dd>{item.id}</dd>
          </div>
          <div>
            <dt>작성자</dt>
            <dd>{item.ownerName}</dd>
          </div>
          <div>
            <dt>생성일</dt>
            <dd>{item.createdAt}</dd>
          </div>
          <div>
            <dt>수정일</dt>
            <dd>{item.updatedAt}</dd>
          </div>
        </dl>
      </article>
      <Link className="secondary-button" href="/items">
        목록으로 돌아가기
      </Link>
    </PageShell>
  );
}
```

---

## 6.6 src/app/items/new/page.tsx

[파일 내용: `src/app/items/new/page.tsx`]

```tsx
import { ItemForm } from "@/components/ItemForm";
import { PageShell } from "@/components/PageShell";

export default function NewItemPage() {
  return (
    <PageShell
      title="New Item"
      description="사용자가 새 항목을 입력하는 form 화면이다. 오늘은 실제 저장 없이 validation만 확인한다."
    >
      <ItemForm />
    </PageShell>
  );
}
```

---

## 6.7 src/app/login/page.tsx

[파일 내용: `src/app/login/page.tsx`]

```tsx
import Link from "next/link";
import { PageShell } from "@/components/PageShell";

export default function LoginPage() {
  return (
    <PageShell
      title="Login"
      description="인증 흐름을 배치하기 위한 화면이다. 4회차에서는 실제 로그인 처리를 구현하지 않는다."
    >
      <form className="form-card">
        <label htmlFor="email">이메일</label>
        <input id="email" name="email" type="email" placeholder="user@example.com" />

        <label htmlFor="password">비밀번호</label>
        <input id="password" name="password" type="password" placeholder="비밀번호" />

        <button className="primary-button" type="button">
          mock login
        </button>
        <p className="muted">실제 인증은 후속 차시에서 별도 구현한다.</p>
      </form>
      <p>
        계정이 없다면 <Link className="text-link" href="/signup">회원가입 화면</Link>으로 이동한다.
      </p>
    </PageShell>
  );
}
```

---

## 6.8 src/app/signup/page.tsx

[파일 내용: `src/app/signup/page.tsx`]

```tsx
import { PageShell } from "@/components/PageShell";

export default function SignupPage() {
  return (
    <PageShell
      title="Signup"
      description="회원가입 화면의 기본 구조이다. 4회차에서는 실제 계정 저장을 하지 않는다."
    >
      <form className="form-card">
        <label htmlFor="name">이름</label>
        <input id="name" name="name" placeholder="홍길동" />

        <label htmlFor="email">이메일</label>
        <input id="email" name="email" type="email" placeholder="user@example.com" />

        <label htmlFor="password">비밀번호</label>
        <input id="password" name="password" type="password" placeholder="비밀번호" />

        <button className="primary-button" type="button">
          mock signup
        </button>
        <p className="muted">실제 회원가입과 비밀번호 저장은 후속 차시에서 안전하게 구현한다.</p>
      </form>
    </PageShell>
  );
}
```

---

## 6.9 src/app/admin/page.tsx

[파일 내용: `src/app/admin/page.tsx`]

```tsx
import { PageShell } from "@/components/PageShell";
import { adminUser, mockItems } from "@/lib/mock-data";

export default function AdminPage() {
  return (
    <PageShell
      title="Admin"
      description="관리자 화면의 기본 골격이다. 4회차에서는 실제 권한 검사를 구현하지 않는다."
    >
      <article className="card">
        <h2>관리자 정보</h2>
        <p>{adminUser.name}</p>
        <p className="muted">{adminUser.email}</p>
      </article>
      <article className="card">
        <h2>관리 대상 item</h2>
        <table>
          <thead>
            <tr>
              <th>제목</th>
              <th>상태</th>
              <th>작성자</th>
            </tr>
          </thead>
          <tbody>
            {mockItems.map((item) => (
              <tr key={item.id}>
                <td>{item.title}</td>
                <td>{item.status}</td>
                <td>{item.ownerName}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </article>
    </PageShell>
  );
}
```

---

# 7. 실습 6 — mock API route 만들기

## 7.1 src/app/api/items/route.ts

[파일 내용: `src/app/api/items/route.ts`]

```ts
import { NextResponse } from "next/server";
import { mockItems } from "@/lib/mock-data";

export async function GET() {
  return NextResponse.json({
    items: mockItems,
    count: mockItems.length,
    source: "mock-data",
  });
}

export async function POST(request: Request) {
  const body = await request.json().catch(() => null);

  if (!body || typeof body.title !== "string" || typeof body.description !== "string") {
    return NextResponse.json(
      { message: "title과 description이 필요하다." },
      { status: 400 },
    );
  }

  return NextResponse.json(
    {
      message: "mock item이 생성된 것처럼 응답한다. 실제 DB 저장은 아직 하지 않는다.",
      item: {
        id: "mock-created-item",
        title: body.title,
        description: body.description,
        status: "draft",
      },
    },
    { status: 201 },
  );
}
```

---

# 8. 실습 7 — CSS 작성

## 8.1 src/app/globals.css

[파일 내용: `src/app/globals.css`]

```css
:root {
  color-scheme: light;
  font-family: Arial, Helvetica, sans-serif;
  background: #f6f7fb;
  color: #1f2937;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  background: #f6f7fb;
}

a {
  color: inherit;
  text-decoration: none;
}

.app-header {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 16px 32px;
  background: white;
  border-bottom: 1px solid #e5e7eb;
}

.brand {
  font-weight: 800;
  letter-spacing: -0.02em;
}

.nav-links {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  color: #4b5563;
  font-size: 14px;
}

.nav-links a:hover,
.text-link:hover {
  color: #111827;
  text-decoration: underline;
}

.app-main {
  width: min(1080px, calc(100% - 32px));
  margin: 0 auto;
  padding: 40px 0 80px;
}

.hero,
.page-shell {
  display: grid;
  gap: 24px;
}

.hero {
  padding: 48px;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 24px;
}

.hero h1,
.page-heading h1 {
  margin: 0;
  font-size: clamp(32px, 5vw, 56px);
  line-height: 1.05;
  letter-spacing: -0.05em;
}

.hero p,
.page-heading p {
  max-width: 760px;
  color: #4b5563;
  line-height: 1.7;
}

.eyebrow {
  margin: 0;
  color: #2563eb;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.button-row {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
}

.primary-button,
.secondary-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 42px;
  padding: 0 18px;
  border-radius: 999px;
  font-weight: 700;
  border: 1px solid transparent;
  cursor: pointer;
}

.primary-button {
  background: #111827;
  color: white;
}

.secondary-button {
  background: white;
  color: #111827;
  border-color: #d1d5db;
}

.summary-grid,
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
}

.summary-box,
.card,
.form-card {
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 18px;
  padding: 22px;
}

.summary-box strong,
.large-number {
  display: block;
  margin: 0;
  font-size: 36px;
  font-weight: 800;
}

.summary-box span,
.muted {
  color: #6b7280;
}

.card-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
}

.card h2 {
  margin: 0 0 12px;
}

.card p {
  color: #4b5563;
  line-height: 1.6;
}

.detail-card {
  max-width: 760px;
}

.status-badge {
  display: inline-flex;
  border-radius: 999px;
  padding: 4px 10px;
  font-size: 12px;
  font-weight: 700;
  border: 1px solid #d1d5db;
}

.status-draft {
  background: #fff7ed;
}

.status-active {
  background: #ecfdf5;
}

.status-archived {
  background: #f3f4f6;
}

.meta-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;
  margin: 16px 0;
}

.meta-grid dt {
  color: #6b7280;
  font-size: 12px;
}

.meta-grid dd {
  margin: 4px 0 0;
  font-weight: 700;
}

.form-card {
  display: grid;
  gap: 10px;
  max-width: 640px;
}

label {
  font-weight: 700;
}

input,
textarea {
  width: 100%;
  border: 1px solid #d1d5db;
  border-radius: 12px;
  padding: 12px 14px;
  font: inherit;
  background: white;
}

.error-message {
  margin: 0 0 8px;
  color: #b91c1c;
  font-weight: 700;
}

.success-message {
  margin: 0;
  color: #047857;
  font-weight: 700;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  padding: 12px;
  border-bottom: 1px solid #e5e7eb;
  text-align: left;
}

@media (max-width: 720px) {
  .app-header {
    align-items: flex-start;
    flex-direction: column;
  }

  .hero {
    padding: 28px;
  }
}
```

---

# 9. 실습 8 — 실행하기

## 9.1 개발 서버 실행

[터미널]

```bash
npm run dev
```

정상이라면 다음과 비슷한 메시지가 나온다.

```text
Local:        http://localhost:3000
```

웹브라우저를 열고 다음 주소로 이동한다.

```text
http://localhost:3000
```

화면이 보이면 1차 성공이다.

---

## 9.2 화면 이동 확인

브라우저에서 다음 주소를 하나씩 확인한다.

```text
http://localhost:3000/
http://localhost:3000/login
http://localhost:3000/signup
http://localhost:3000/dashboard
http://localhost:3000/items
http://localhost:3000/items/item-001
http://localhost:3000/items/new
http://localhost:3000/admin
http://localhost:3000/api/items
```

정상이라면 다음을 확인할 수 있다.

```text
[ ] Home 화면이 열린다.
[ ] Login 화면이 열린다.
[ ] Signup 화면이 열린다.
[ ] Dashboard 화면이 열린다.
[ ] Items 목록이 열린다.
[ ] Item 상세 화면이 열린다.
[ ] New Item form이 열린다.
[ ] Admin 화면이 열린다.
[ ] /api/items가 JSON을 반환한다.
```

---

## 9.3 form validation 확인

`http://localhost:3000/items/new`로 이동한다.

다음 순서로 확인한다.

```text
1. 제목과 설명을 비워 둔다.
2. mock item 생성하기 버튼을 누른다.
3. 오류 메시지가 표시되는지 확인한다.
4. 제목을 입력한다.
5. 설명을 10자 미만으로 입력한다.
6. 다시 버튼을 누른다.
7. 설명 길이 오류가 표시되는지 확인한다.
8. 제목과 설명을 충분히 입력한다.
9. 성공 메시지가 표시되는지 확인한다.
```

이 단계가 성공하면, 최소한의 사용자 입력 검증이 작동하는 것이다.

---

# 10. 실습 9 — 구현 기록 문서 작성

## 10.1 docs/implementation-notes.md 만들기

[파일 내용: `docs/implementation-notes.md`]

```md
# Session 4 Implementation Notes

## 1. 오늘 구현한 범위

- Next.js + React + TypeScript 기반 웹서비스 골격을 생성하였다.
- 공통 레이아웃과 상단 내비게이션을 생성하였다.
- Home, Login, Signup, Dashboard, Items, Item Detail, New Item, Admin 화면을 생성하였다.
- mock data를 사용하여 목록과 상세 화면을 렌더링하였다.
- New Item 화면에 기본 form validation을 추가하였다.
- `/api/items` mock API route를 생성하였다.

## 2. 오늘 구현하지 않은 범위

- 실제 회원가입
- 실제 로그인
- 실제 데이터베이스 저장
- 실제 관리자 권한 검사
- 실제 배포
- 결제 기능
- 외부 API 연동

## 3. 남아 있는 의사결정

- 실제 데이터베이스 선택
- 실제 인증 방식 선택
- 사용자 역할과 권한 정책 확정
- 배포 플랫폼 확정
- 운영 환경의 보안 정책 확정

## 4. 다음 차시 후보 작업

- 상태 관리와 사용자 입력 흐름 개선
- 실제 API contract에 맞는 요청·응답 구조 정리
- 데이터베이스 또는 local persistence 연결
- 인증·권한 설계 세분화
- 핵심 사용자 흐름 테스트 작성
```

AI 코딩 도구에 요청하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Create docs/implementation-notes.md for Session 4.
Summarize what was implemented, what was intentionally not implemented, remaining decisions, and next-session candidate tasks.
Do not claim that real authentication or a real database has been implemented.
```

---

# 11. README.md 보완

## 11.1 README.md에 실행 방법 추가

AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구]

```text
Update README.md for the current web service MVP skeleton.

Add or revise these sections:
- Purpose
- Current MVP Scope
- Tech Stack
- Pages
- How to Run
- What is Mocked
- What is Not Implemented Yet
- Safety Rules

Make clear that:
- npm install installs dependencies.
- npm run dev starts the local development server.
- mock data is used instead of a real database.
- real authentication is not implemented yet.
- API keys and secrets must not be committed.
```

직접 작성하려면 다음 내용을 추가한다.

[파일 내용: `README.md`에 추가]

````md
## Current MVP Scope

This project currently contains a beginner-friendly web service MVP skeleton.
It includes pages, navigation, mock data, basic form validation, and a mock API route.
It does not yet include real authentication, a real database, payment, deployment, or external API integration.

## How to Run

```bash
npm install
npm run dev
```

Open the browser at:

```text
http://localhost:3000
```

## Pages

- `/`: Home
- `/login`: Login mock screen
- `/signup`: Signup mock screen
- `/dashboard`: User dashboard
- `/items`: Item list
- `/items/[id]`: Item detail
- `/items/new`: New item form
- `/admin`: Admin mock screen
- `/api/items`: Mock JSON API

## Safety Rules

- Do not commit API keys or secrets.
- Do not implement real password storage without a secure authentication strategy.
- Do not connect real user data until privacy requirements are reviewed.
- Use mock data until the data model and API contract are confirmed.
````

---

# 12. GitHub에 올리기 전 .gitignore 확인

## 12.1 .gitignore 만들기

[파일 내용: `.gitignore`]

```gitignore
# dependencies
node_modules/

# next.js
.next/
out/

# production
build/

# env files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# os files
.DS_Store
Thumbs.db
```

AI 코딩 도구에 요청하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Create or update .gitignore for this Next.js web service project.
It must ignore node_modules, .next, build outputs, logs, and all .env files.
Do not ignore source files, docs, README.md, or BMAD output documents.
```

---

# 13. 오늘의 품질 게이트

## 13.1 실행 게이트

```text
[ ] npm install이 완료된다.
[ ] npm run dev가 실행된다.
[ ] http://localhost:3000이 열린다.
[ ] 터미널에 치명적 오류가 없다.
```

## 13.2 화면 게이트

```text
[ ] Home 화면이 있다.
[ ] Login 화면이 있다.
[ ] Signup 화면이 있다.
[ ] Dashboard 화면이 있다.
[ ] Items 목록 화면이 있다.
[ ] Item 상세 화면이 있다.
[ ] New Item form 화면이 있다.
[ ] Admin 화면이 있다.
```

## 13.3 데이터와 API 게이트

```text
[ ] src/lib/mock-data.ts가 있다.
[ ] 목록 화면이 mockItems를 표시한다.
[ ] 상세 화면이 item id를 기준으로 데이터를 표시한다.
[ ] /api/items가 JSON을 반환한다.
[ ] 실제 DB 연결을 했다고 잘못 기록하지 않았다.
```

## 13.4 form validation 게이트

```text
[ ] 빈 제목을 제출하면 오류 메시지가 나온다.
[ ] 빈 설명을 제출하면 오류 메시지가 나온다.
[ ] 너무 짧은 설명을 제출하면 오류 메시지가 나온다.
[ ] 올바른 값을 입력하면 성공 메시지가 나온다.
```

## 13.5 보안 게이트

```text
[ ] .env 파일을 GitHub에 올리지 않도록 .gitignore가 있다.
[ ] API key를 코드에 직접 쓰지 않았다.
[ ] 실제 비밀번호 저장을 구현하지 않았다.
[ ] 실제 개인정보 데이터를 mock data에 넣지 않았다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Check the current project against the Session 4 web service quality gates:

1. package.json exists and has dev/build/start scripts.
2. src/app/layout.tsx and src/app/page.tsx exist.
3. Home, Login, Signup, Dashboard, Items, Item Detail, New Item, and Admin pages exist.
4. src/lib/mock-data.ts exists and is used by pages.
5. src/lib/validation.ts exists and validates the New Item form.
6. /api/items route exists and returns mock JSON.
7. README.md explains how to run the app.
8. .gitignore ignores node_modules, .next, and .env files.
9. No real authentication or real database is falsely claimed as implemented.

Return PASS, CONCERNS, or FAIL.
For every concern, provide the exact file and exact fix.
```

---

# 14. GitHub에 커밋하기

## 14.1 현재 변경 사항 확인

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

## 14.2 파일 추가와 커밋

[터미널]

```bash
git add .
git commit -m "Add session 4 web service MVP skeleton"
```

커밋이 성공하면 4회차 작업이 저장된 것이다.

---

# 15. 과제 안내

## 과제 1. screen-map과 실제 페이지 대조하기

`docs/screen-map.md`를 열고, 오늘 만든 실제 페이지와 비교한다.

[파일 내용: `docs/screen-implementation-check.md`]

```md
# Screen Implementation Check

| Screen in screen-map.md | Implemented route | Implemented? | Notes |
|---|---|---|---|
| Home | `/` | Yes |  |
| Login | `/login` | Yes | mock only |
| Signup | `/signup` | Yes | mock only |
| Dashboard | `/dashboard` | Yes | mock data |
| Items | `/items` | Yes | mock data |
| Item Detail | `/items/[id]` | Yes | mock data |
| New Item | `/items/new` | Yes | validation only |
| Admin | `/admin` | Yes | mock only |
```

---

## 과제 2. 사용자 테스트 질문 5개 작성

`docs/user-test-questions.md` 파일을 만들고 다음 양식을 채운다.

```md
# User Test Questions

## 1. 첫 화면 이해

사용자는 Home 화면을 보고 이 서비스가 무엇을 하는지 설명할 수 있는가?

## 2. 이동 가능성

사용자는 Dashboard, Items, New Item 화면으로 이동할 수 있는가?

## 3. 목록 이해

사용자는 Items 목록에서 각 항목의 상태와 작성자를 이해할 수 있는가?

## 4. 상세 화면 이해

사용자는 Item Detail 화면에서 필요한 정보를 찾을 수 있는가?

## 5. 입력 오류 이해

사용자는 New Item form에서 오류 메시지를 보고 무엇을 고쳐야 하는지 이해할 수 있는가?
```

---

## 과제 3. 다음 차시 Story 후보 3개 작성

`docs/next-stories.md` 파일을 만든다.

```md
# Next Story Candidates

## Story 1

목표:

필요 파일:

수용 기준:

위험:

## Story 2

목표:

필요 파일:

수용 기준:

위험:

## Story 3

목표:

필요 파일:

수용 기준:

위험:
```

Story 후보 예시는 다음과 같다.

```text
1. Item 생성 form의 입력값을 mock API에 전송한다.
2. Items 목록에 상태 필터를 추가한다.
3. 로그인 사용자의 role에 따라 Admin 링크 노출을 제어한다.
```

---

# 16. 자주 생기는 문제와 해결법

## 16.1 `npm` 명령이 안 된다

가능한 원인:

```text
Node.js가 설치되지 않았다.
Node.js 설치 후 터미널을 새로 열지 않았다.
```

해결:

```bash
node --version
npm --version
```

두 명령이 모두 버전을 출력해야 한다. 그렇지 않으면 Node.js LTS를 설치하고 터미널을 새로 연다.

---

## 16.2 `npm run dev`가 실패한다

먼저 패키지를 설치했는지 확인한다.

[터미널]

```bash
npm install
```

그다음 다시 실행한다.

[터미널]

```bash
npm run dev
```

---

## 16.3 `Module not found: Can't resolve '@/...'` 오류가 난다

가능한 원인:

```text
tsconfig.json의 paths 설정이 없다.
파일 경로가 잘못되었다.
폴더 이름의 대소문자가 다르다.
```

확인할 것:

```text
tsconfig.json에 "@/*": ["./src/*"]가 있는가?
src/components/PageShell.tsx가 실제로 있는가?
import 경로의 대소문자가 파일명과 같은가?
```

---

## 16.4 `/items/item-001`에서 404가 나온다

확인할 것:

```text
src/app/items/[id]/page.tsx가 있는가?
src/lib/mock-data.ts에 id가 item-001인 데이터가 있는가?
브라우저 주소가 /items/item-001인가?
```

---

## 16.5 3000번 포트가 이미 사용 중이라고 나온다

Next.js가 자동으로 다른 포트를 제안할 수 있다. 예를 들어 다음처럼 나온다.

```text
Port 3000 is in use, trying 3001 instead.
```

이 경우 브라우저에서 다음 주소를 연다.

```text
http://localhost:3001
```

---

## 16.6 AI가 실제 인증 또는 DB를 구현하려고 한다

즉시 멈추고 다음을 입력한다.

[AI 코딩 도구]

```text
Stop. Session 4 scope is MVP skeleton only.
Do not implement real authentication or a real database today.
Use mock data and mock API routes only.
Revise the implementation plan to match Session 4 scope.
```

---

# 17. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> 웹서비스 구현은 데이터베이스와 인증부터 시작하는 것이 아니라, 사용자가 이동할 수 있는 화면 구조와 핵심 흐름을 먼저 검증하는 것에서 시작한다.

4회차의 흐름은 다음과 같다.

```text
3회차 설계 문서 확인
→ Next.js 기본 설정
→ 공통 레이아웃 생성
→ 핵심 페이지 생성
→ mock data 연결
→ form validation 확인
→ mock API 확인
→ README와 구현 기록 정리
```

---

# 18. 4회차 최종 체크리스트

수업이 끝나기 전에 스스로 확인한다.

```text
[ ] Node.js와 npm 버전을 확인했다.
[ ] package.json을 만들었다.
[ ] npm install을 실행했다.
[ ] src/app/layout.tsx를 만들었다.
[ ] Home 화면을 만들었다.
[ ] Login 화면을 만들었다.
[ ] Signup 화면을 만들었다.
[ ] Dashboard 화면을 만들었다.
[ ] Items 목록 화면을 만들었다.
[ ] Item 상세 화면을 만들었다.
[ ] New Item form 화면을 만들었다.
[ ] Admin 화면을 만들었다.
[ ] mock data를 만들었다.
[ ] form validation을 확인했다.
[ ] /api/items JSON 응답을 확인했다.
[ ] README.md에 실행 방법을 추가했다.
[ ] .gitignore가 node_modules, .next, .env를 제외한다.
[ ] git commit을 완료했다.
```

---

## 부록 A. 오늘 사용하는 핵심 명령 모음

### 터미널 명령

```bash
pwd
node --version
npm --version
npm install
npm run dev
git status
git add .
git commit -m "Add session 4 web service MVP skeleton"
```

### AI 코딩 도구 명령

```text
bmad-help

Check the current project against the Session 4 web service quality gates.
Return PASS, CONCERNS, or FAIL.
```

---

## 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| MVP | Minimum Viable Product. 가장 작은 단위로 작동하는 초기 제품 |
| route | 사용자가 접속하는 주소 경로 |
| page | 특정 route에서 보이는 화면 |
| component | 여러 화면에서 재사용할 수 있는 UI 조각 |
| mock data | 실제 DB가 아니라 화면 검증을 위해 만든 임시 데이터 |
| validation | 사용자가 입력한 값이 규칙에 맞는지 확인하는 절차 |
| API route | 브라우저나 프론트엔드가 JSON 데이터를 요청할 수 있는 서버 경로 |
| TypeScript | JavaScript에 타입 검사를 추가한 언어 |
| source of truth | 여러 문서가 충돌할 때 기준이 되는 문서 |
