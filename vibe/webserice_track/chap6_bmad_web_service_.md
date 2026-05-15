# 6회차 학습자 실습 매뉴얼: 웹서비스 트랙

# 인증·권한·데이터 저장
## localStorage MVP → Supabase Auth → Row Level Security → 실제 데이터베이스 저장 → 권한 검증

---

## 이 자료의 목적

6회차의 목표는 단순히 로그인 화면을 만드는 것이 아니다. 6회차의 목표는 5회차에서 만든 상호작용형 MVP를 **실제 사용자 계정과 실제 데이터베이스를 사용하는 웹서비스**로 확장하는 것이다.

5회차에서는 다음 산출물을 만들었다.

```text
1. localStorage 기반 임시 저장소
2. useItems 상태 관리 hook
3. Item 생성·조회·수정·삭제 기능
4. 검색과 상태 필터
5. 빈 상태, 오류 상태, 저장 성공 상태 메시지
6. 수동 테스트 체크리스트
```

6회차에서는 이 구조를 바탕으로 다음을 만든다.

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
13. README 보완
```

오늘의 핵심 문장은 다음이다.

> 인증은 “누구인가”를 확인하는 절차이고, 권한은 “무엇을 할 수 있는가”를 제한하는 규칙이다.

6회차가 끝나면 학습자는 다음을 수행할 수 있어야 한다.

```text
회원가입을 한다.
로그인을 한다.
로그인한 사용자만 dashboard와 items에 접근한다.
사용자 A가 만든 item은 사용자 A에게만 보인다.
사용자 B는 사용자 A의 item을 볼 수 없다.
관리자 역할의 기본 구조를 이해한다.
민감정보와 API key를 GitHub에 올리지 않는다.
```

> [!IMPORTANT]
> 6회차는 초보 학습자가 따라 할 수 있도록 단계별로 작성되어 있지만, 내부 구조는 실제 웹서비스 개발에서 중요한 원칙을 따른다. 즉, 단순한 화면 연결이 아니라 **인증 Authentication, 인가 Authorization, 데이터 소유권 Data Ownership, RLS Row Level Security, 서버/클라이언트 경계**를 구분한다.

---

## 오늘 끝나면 있어야 하는 것

6회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
my-web-service/
├── .env.local                         # 실제 환경변수. GitHub에 올리지 않음
├── .env.local.example                 # 예시 환경변수. GitHub에 올릴 수 있음
├── docs/
│   ├── auth-and-data-storage-notes.md
│   ├── rls-policy-checklist.md
│   └── auth-manual-test-checklist.md
├── supabase/
│   └── schema.sql
├── src/
│   ├── app/
│   │   ├── login/
│   │   │   └── page.tsx
│   │   ├── signup/
│   │   │   └── page.tsx
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── items/
│   │   │   ├── actions.ts
│   │   │   ├── new/
│   │   │   │   └── page.tsx
│   │   │   ├── [id]/
│   │   │   │   ├── edit/
│   │   │   │   │   └── page.tsx
│   │   │   │   └── page.tsx
│   │   │   └── page.tsx
│   │   └── auth/
│   │       └── actions.ts
│   ├── components/
│   │   ├── LoginForm.tsx
│   │   ├── SignupForm.tsx
│   │   ├── LogoutButton.tsx
│   │   └── ItemForm.tsx
│   ├── lib/
│   │   ├── auth/
│   │   │   ├── require-user.ts
│   │   │   └── require-admin.ts
│   │   ├── items-repository.ts
│   │   └── supabase/
│   │       ├── client.ts
│   │       └── server.ts
│   └── types/
│       └── database.ts
├── README.md
└── package.json
```

> [!NOTE]
> `middleware.ts` 또는 `proxy.ts` 파일은 Next.js와 Supabase 설정 방식에 따라 추가될 수 있다. 최신 Next.js 프로젝트에서는 명칭과 권장 방식이 바뀔 수 있으므로, 이 자료에서는 AI 코딩 도구에게 “현재 프로젝트의 Next.js 버전에 맞는 세션 갱신 파일을 만들라”고 지시한다.

---

## 오늘 사용할 입력 위치를 구분하자

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `npm install @supabase/supabase-js @supabase/ssr` |
| `[Supabase SQL Editor]` | Supabase 웹사이트의 SQL Editor | `create table public.items ...` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `Create Supabase auth files` |
| `[파일 내용]` | TypeScript, SQL, Markdown 파일 안에 들어갈 내용 | `NEXT_PUBLIC_SUPABASE_URL=...` |

아래 명령은 터미널에 입력한다.

```bash
npm run dev
```

아래 SQL은 Supabase SQL Editor에 입력한다.

```sql
select * from auth.users;
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create Supabase authentication files for this Next.js App Router project.
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

정상이라면 대략 다음과 비슷한 결과가 나온다.

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

## 0.3 5회차 산출물을 확인한다

다음 파일 또는 폴더가 있는지 확인한다.

[터미널]

```bash
npm run dev
```

브라우저에서 다음 주소를 연다.

```text
http://localhost:3000
```

다음 기능이 작동하면 6회차를 진행할 준비가 된 것이다.

```text
[ ] 홈 화면이 열린다.
[ ] items 목록 화면이 열린다.
[ ] 새 item 생성 화면이 열린다.
[ ] localStorage 기반으로 item을 생성할 수 있다.
[ ] item 상세 화면을 볼 수 있다.
[ ] item 수정과 삭제가 가능하다.
```

만약 5회차 기능이 전혀 작동하지 않는다면, 6회차로 바로 넘어가지 말고 5회차의 `npm run dev`와 기본 화면부터 복구한다.

---

## 0.4 오늘 배우는 핵심 용어

| 용어 | 뜻 |
|---|---|
| 인증 Authentication | 사용자가 누구인지 확인하는 절차. 예: 로그인 |
| 인가 Authorization | 인증된 사용자가 무엇을 할 수 있는지 제한하는 규칙 |
| 세션 Session | 사용자가 로그인 상태임을 나타내는 정보 |
| 환경변수 Environment Variable | API key처럼 코드에 직접 쓰면 안 되는 설정값 |
| Supabase | PostgreSQL, 인증, 스토리지 등을 제공하는 백엔드 서비스 |
| RLS Row Level Security | 데이터베이스 행 단위 접근 제어 정책 |
| owner_id | 특정 데이터가 어떤 사용자에게 속하는지 나타내는 사용자 id |
| service role key | 서버 관리자 권한 key. 절대 브라우저와 GitHub에 노출하면 안 됨 |

---

# 1. Supabase 프로젝트 만들기

## 1.1 Supabase란 무엇인가

Supabase는 웹서비스에서 자주 필요한 백엔드 기능을 제공한다.

```text
사용자 회원가입
로그인
데이터베이스
권한 정책
파일 저장소
API
```

이번 차시에서는 Supabase의 모든 기능을 배우지 않는다. 오늘 필요한 기능은 세 가지다.

```text
1. Auth: 회원가입과 로그인
2. PostgreSQL Database: item 저장
3. Row Level Security: 사용자별 데이터 접근 제한
```

---

## 1.2 Supabase 프로젝트를 생성한다

브라우저에서 Supabase에 접속한 뒤 새 프로젝트를 만든다.

```text
1. Supabase에 로그인한다.
2. New Project를 클릭한다.
3. Project name을 입력한다. 예: my-web-service
4. Database password를 안전하게 저장한다.
5. Region은 가까운 지역을 선택한다.
6. Create new project를 클릭한다.
```

> [!IMPORTANT]
> Database password는 다시 보기 어려울 수 있다. 수업 중에는 개인 메모장에 임시로 적어 두되, GitHub나 공개 문서에는 절대 쓰지 않는다.

---

## 1.3 Supabase URL과 anon key를 찾는다

Supabase 프로젝트가 만들어지면 다음 위치에서 값을 확인한다.

```text
Project Settings
→ API
→ Project URL
→ anon public key
```

오늘 필요한 값은 두 개다.

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
```

`anon key`는 이름에 `public`이 들어가지만, 이것만으로 모든 데이터에 접근할 수 있는 것은 아니다. 실제 데이터 보호는 RLS 정책으로 수행한다. 반대로 `service_role key`는 관리자 권한이므로 절대 브라우저 코드에 넣지 않는다.

---

# 2. 환경변수 파일 만들기

## 2.1 .env.local 파일을 만든다

프로젝트 루트에 `.env.local` 파일을 만든다.

### Windows PowerShell

[터미널]

```powershell
notepad .env.local
```

### Mac Terminal

[터미널]

```bash
nano .env.local
```

아래 형식으로 입력한다.

[파일 내용: `.env.local`]

```text
NEXT_PUBLIC_SUPABASE_URL=여기에_Project_URL_붙여넣기
NEXT_PUBLIC_SUPABASE_ANON_KEY=여기에_anon_public_key_붙여넣기
```

Mac에서 `nano`를 사용했다면 저장은 다음 순서로 한다.

```text
Ctrl + O
Enter
Ctrl + X
```

---

## 2.2 .env.local.example 파일을 만든다

`.env.local`은 실제 key가 들어 있으므로 GitHub에 올리면 안 된다. 대신 예시 파일을 만든다.

[터미널]

```bash
code .env.local.example
```

`code` 명령이 안 되면 Windows에서는 `notepad`, Mac에서는 `nano`를 사용한다.

[파일 내용: `.env.local.example`]

```text
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
```

---

## 2.3 .gitignore를 확인한다

`.env.local`이 GitHub에 올라가지 않도록 `.gitignore`에 다음이 있는지 확인한다.

[파일 내용: `.gitignore`]

```gitignore
# environment variables
.env
.env.local
.env.*.local
```

AI 코딩 도구에 요청하려면 다음 프롬프트를 사용한다.

[AI 코딩 도구 - English prompt]

```text
Update .gitignore for this Next.js project.
Ensure that .env, .env.local, and .env.*.local are ignored.
Do not ignore .env.local.example.
Do not expose Supabase service role keys.
```

[한국어 번역]

```text
이 Next.js 프로젝트의 .gitignore를 업데이트해 주세요.
.env, .env.local, .env.*.local이 Git에서 제외되도록 해 주세요.
.env.local.example은 제외하지 마세요.
Supabase service role key가 노출되지 않도록 해 주세요.
```

---

# 3. Supabase 패키지 설치

## 3.1 필요한 패키지를 설치한다

Supabase를 Next.js App Router와 함께 사용하기 위해 다음 패키지를 설치한다.

[터미널]

```bash
npm install @supabase/supabase-js @supabase/ssr
```

설치 후 `package.json`을 확인한다.

[터미널]

```bash
npm ls @supabase/supabase-js @supabase/ssr
```

오류 없이 버전이 보이면 정상이다.

---

## 3.2 개발 서버를 다시 시작한다

환경변수와 새 패키지를 반영하려면 개발 서버를 껐다가 다시 실행한다.

[터미널]

```bash
npm run dev
```

브라우저에서 다음 주소를 연다.

```text
http://localhost:3000
```

---

# 4. 데이터베이스 스키마와 RLS 정책 만들기

## 4.1 왜 데이터베이스 정책이 중요한가

웹서비스에서 데이터 저장은 단순히 테이블을 만드는 일이 아니다. 더 중요한 질문은 다음이다.

```text
누가 이 데이터를 만들 수 있는가?
누가 이 데이터를 볼 수 있는가?
누가 이 데이터를 수정할 수 있는가?
누가 이 데이터를 삭제할 수 있는가?
```

오늘의 원칙은 다음이다.

```text
1. 사용자는 자기 item만 볼 수 있다.
2. 사용자는 자기 item만 수정할 수 있다.
3. 사용자는 자기 item만 삭제할 수 있다.
4. 관리자는 별도 역할로 구분한다.
5. role 변경은 일반 사용자가 할 수 없다.
```

---

## 4.2 Supabase SQL Editor를 연다

Supabase 프로젝트 화면에서 다음으로 이동한다.

```text
SQL Editor
→ New query
```

아래 SQL을 붙여넣고 실행한다.

> [!IMPORTANT]
> SQL을 실행하기 전에 전체를 한 번 읽는다. 특히 `profiles`, `items`, `policy`, `trigger`가 어떤 역할인지 확인한다.

[Supabase SQL Editor]

```sql
-- =========================================================
-- Session 6 schema for the web service track
-- Purpose:
-- 1. Create profiles for authenticated users.
-- 2. Create items owned by users.
-- 3. Enable Row Level Security.
-- 4. Restrict item access by owner_id.
-- =========================================================

create extension if not exists pgcrypto;

-- 1. User profile table.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  display_name text,
  role text not null default 'user' check (role in ('user', 'admin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Users can read only their own profile.
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

-- Admins can read all profiles.
drop policy if exists "profiles_admin_select_all" on public.profiles;
create policy "profiles_admin_select_all"
on public.profiles
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
);

-- 2. Automatically create a profile when a new auth user is created.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'display_name', '')
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- 3. Items table.
create table if not exists public.items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 120),
  description text,
  status text not null default 'todo' check (status in ('todo', 'in_progress', 'done')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists items_owner_id_idx on public.items(owner_id);
create index if not exists items_status_idx on public.items(status);
create index if not exists items_created_at_idx on public.items(created_at desc);

alter table public.items enable row level security;

-- Users can read their own items.
drop policy if exists "items_select_own" on public.items;
create policy "items_select_own"
on public.items
for select
to authenticated
using (auth.uid() = owner_id);

-- Users can insert only their own items.
drop policy if exists "items_insert_own" on public.items;
create policy "items_insert_own"
on public.items
for insert
to authenticated
with check (auth.uid() = owner_id);

-- Users can update only their own items.
drop policy if exists "items_update_own" on public.items;
create policy "items_update_own"
on public.items
for update
to authenticated
using (auth.uid() = owner_id)
with check (auth.uid() = owner_id);

-- Users can delete only their own items.
drop policy if exists "items_delete_own" on public.items;
create policy "items_delete_own"
on public.items
for delete
to authenticated
using (auth.uid() = owner_id);

-- Admins can read all items.
drop policy if exists "items_admin_select_all" on public.items;
create policy "items_admin_select_all"
on public.items
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  )
);

-- 4. updated_at helper.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_items_updated_at on public.items;
create trigger set_items_updated_at
before update on public.items
for each row execute function public.set_updated_at();

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();
```

---

## 4.3 SQL 파일로도 저장한다

Supabase에서 실행한 SQL은 프로젝트 안에도 저장한다. 그래야 나중에 어떤 데이터베이스 구조를 만들었는지 추적할 수 있다.

[터미널]

```bash
mkdir -p supabase
```

Windows PowerShell에서 `mkdir -p`가 안 되면 다음을 사용한다.

[터미널]

```powershell
New-Item -ItemType Directory -Force supabase
```

`supabase/schema.sql` 파일을 만들고, 방금 실행한 SQL을 그대로 붙여넣는다.

### Windows PowerShell

[터미널]

```powershell
notepad supabase\schema.sql
```

### Mac Terminal

[터미널]

```bash
nano supabase/schema.sql
```

---

## 4.4 테이블이 만들어졌는지 확인한다

Supabase SQL Editor에서 다음을 실행한다.

[Supabase SQL Editor]

```sql
select table_name
from information_schema.tables
where table_schema = 'public'
  and table_name in ('profiles', 'items');
```

정상이라면 다음과 비슷한 결과가 나온다.

```text
profiles
items
```

RLS가 켜져 있는지도 확인한다.

[Supabase SQL Editor]

```sql
select relname, relrowsecurity
from pg_class
where relname in ('profiles', 'items');
```

`relrowsecurity` 값이 `true`이면 정상이다.

---

# 5. Supabase client 파일 만들기

## 5.1 브라우저 client와 서버 client를 구분하는 이유

Next.js App Router에서는 코드가 실행되는 위치가 중요하다.

```text
브라우저에서 실행되는 코드: 사용자의 클릭, 입력, 화면 상호작용 처리
서버에서 실행되는 코드: 로그인 세션 확인, 데이터베이스 조회, 보안이 필요한 작업 처리
```

Supabase client도 두 종류로 나누어 관리한다.

```text
src/lib/supabase/client.ts  → Client Component에서 사용
src/lib/supabase/server.ts  → Server Component와 Server Action에서 사용
```

---

## 5.2 AI 코딩 도구에 요청한다

[AI 코딩 도구 - English prompt]

```text
Create Supabase client files for this Next.js App Router project.

Requirements:
- Use @supabase/supabase-js and @supabase/ssr.
- Create src/lib/supabase/client.ts for browser-side usage.
- Create src/lib/supabase/server.ts for Server Components and Server Actions.
- Read NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY from environment variables.
- Do not use or expose any service role key.
- Use the correct cookie handling convention for the current Next.js version in this project.
- If a middleware.ts or proxy.ts session refresh file is needed, create the correct file and explain why.
```

[한국어 번역]

```text
이 Next.js App Router 프로젝트를 위한 Supabase client 파일을 만들어 주세요.

요구사항:
- @supabase/supabase-js와 @supabase/ssr을 사용합니다.
- 브라우저 측 사용을 위해 src/lib/supabase/client.ts를 만듭니다.
- Server Component와 Server Action 사용을 위해 src/lib/supabase/server.ts를 만듭니다.
- NEXT_PUBLIC_SUPABASE_URL과 NEXT_PUBLIC_SUPABASE_ANON_KEY를 환경변수에서 읽습니다.
- service role key를 사용하거나 노출하지 않습니다.
- 현재 프로젝트의 Next.js 버전에 맞는 cookie 처리 방식을 사용합니다.
- 세션 갱신을 위해 middleware.ts 또는 proxy.ts가 필요하다면 올바른 파일을 만들고 그 이유를 설명합니다.
```

---

## 5.3 직접 작성할 때 사용할 기본 코드

AI가 파일을 만들지 못하면 아래 코드를 사용한다.

[파일 내용: `src/lib/supabase/client.ts`]

```ts
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Missing Supabase environment variables')
  }

  return createBrowserClient(supabaseUrl, supabaseAnonKey)
}
```

[파일 내용: `src/lib/supabase/server.ts`]

```ts
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export async function createClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Missing Supabase environment variables')
  }

  const cookieStore = await cookies()

  return createServerClient(supabaseUrl, supabaseAnonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll()
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) => {
            cookieStore.set(name, value, options)
          })
        } catch {
          // This can be called from a Server Component.
          // In that case, cookie writing may be handled by middleware/proxy.
        }
      },
    },
  })
}
```

---

# 6. 로그인·회원가입·로그아웃 구현

## 6.1 인증 기능의 최소 요구사항

오늘 만들 인증 기능은 다음과 같다.

```text
1. 사용자는 이메일과 비밀번호로 회원가입할 수 있다.
2. 사용자는 이메일과 비밀번호로 로그인할 수 있다.
3. 사용자는 로그아웃할 수 있다.
4. 로그인하지 않은 사용자는 dashboard와 items에 접근할 수 없다.
5. 로그인한 사용자는 자신의 profile과 items를 사용할 수 있다.
```

---

## 6.2 인증 액션 파일을 만든다

[AI 코딩 도구 - English prompt]

```text
Create authentication actions for this Next.js App Router project.

Create src/app/auth/actions.ts.

Requirements:
- Use Server Actions.
- Use the Supabase server client from src/lib/supabase/server.ts.
- Implement signup, login, and logout.
- Use email and password authentication.
- For signup, also accept display_name and pass it as user metadata.
- Redirect to /dashboard after successful login or signup.
- Redirect to /login after logout.
- Do not expose detailed security-sensitive errors to the user.
- Return or redirect with beginner-friendly error messages.
```

[한국어 번역]

```text
이 Next.js App Router 프로젝트를 위한 인증 액션을 만들어 주세요.

src/app/auth/actions.ts 파일을 만듭니다.

요구사항:
- Server Actions를 사용합니다.
- src/lib/supabase/server.ts의 Supabase server client를 사용합니다.
- signup, login, logout을 구현합니다.
- 이메일과 비밀번호 인증을 사용합니다.
- signup에서는 display_name도 받아 user metadata로 전달합니다.
- 로그인 또는 회원가입 성공 후 /dashboard로 이동합니다.
- 로그아웃 후 /login으로 이동합니다.
- 보안상 민감한 오류를 사용자에게 자세히 노출하지 않습니다.
- 초보자가 이해할 수 있는 오류 메시지를 반환하거나 redirect로 전달합니다.
```

직접 작성할 때는 아래 코드를 사용할 수 있다.

[파일 내용: `src/app/auth/actions.ts`]

```ts
'use server'

import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

function encodeMessage(message: string) {
  return encodeURIComponent(message)
}

export async function signup(formData: FormData) {
  const supabase = await createClient()

  const email = String(formData.get('email') ?? '').trim()
  const password = String(formData.get('password') ?? '')
  const displayName = String(formData.get('display_name') ?? '').trim()

  if (!email || !password) {
    redirect(`/signup?error=${encodeMessage('이메일과 비밀번호를 입력해 주세요.')}`)
  }

  if (password.length < 6) {
    redirect(`/signup?error=${encodeMessage('비밀번호는 최소 6자 이상이어야 합니다.')}`)
  }

  const { error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        display_name: displayName,
      },
    },
  })

  if (error) {
    redirect(`/signup?error=${encodeMessage('회원가입에 실패했습니다. 입력값을 확인해 주세요.')}`)
  }

  redirect('/dashboard')
}

export async function login(formData: FormData) {
  const supabase = await createClient()

  const email = String(formData.get('email') ?? '').trim()
  const password = String(formData.get('password') ?? '')

  if (!email || !password) {
    redirect(`/login?error=${encodeMessage('이메일과 비밀번호를 입력해 주세요.')}`)
  }

  const { error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error) {
    redirect(`/login?error=${encodeMessage('로그인에 실패했습니다. 이메일과 비밀번호를 확인해 주세요.')}`)
  }

  redirect('/dashboard')
}

export async function logout() {
  const supabase = await createClient()
  await supabase.auth.signOut()
  redirect('/login')
}
```

---

## 6.3 로그인과 회원가입 화면을 만든다

[AI 코딩 도구 - English prompt]

```text
Create login and signup pages for this project.

Files:
- src/app/login/page.tsx
- src/app/signup/page.tsx
- src/components/LoginForm.tsx
- src/components/SignupForm.tsx
- src/components/LogoutButton.tsx

Requirements:
- Use the Server Actions from src/app/auth/actions.ts.
- Login form fields: email, password.
- Signup form fields: display_name, email, password.
- Show error messages from the searchParams error value.
- Keep the UI simple and beginner-friendly.
- Do not implement social login yet.
- Do not store passwords manually.
```

[한국어 번역]

```text
이 프로젝트의 로그인과 회원가입 화면을 만들어 주세요.

파일:
- src/app/login/page.tsx
- src/app/signup/page.tsx
- src/components/LoginForm.tsx
- src/components/SignupForm.tsx
- src/components/LogoutButton.tsx

요구사항:
- src/app/auth/actions.ts의 Server Actions를 사용합니다.
- 로그인 form 필드: email, password.
- 회원가입 form 필드: display_name, email, password.
- searchParams의 error 값을 화면에 표시합니다.
- UI는 단순하고 초보자가 이해하기 쉽게 유지합니다.
- 아직 social login은 구현하지 않습니다.
- 비밀번호를 직접 저장하지 않습니다.
```

---

## 6.4 인증이 필요한 사용자 확인 함수 만들기

로그인하지 않은 사용자가 보호된 페이지에 접근하면 `/login`으로 보내야 한다.

[파일 내용: `src/lib/auth/require-user.ts`]

```ts
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export async function requireUser() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  return user
}
```

관리자 권한을 확인하는 함수도 만든다.

[파일 내용: `src/lib/auth/require-admin.ts`]

```ts
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { requireUser } from './require-user'

export async function requireAdmin() {
  const user = await requireUser()
  const supabase = await createClient()

  const { data: profile, error } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  if (error || profile?.role !== 'admin') {
    redirect('/dashboard')
  }

  return user
}
```

---

# 7. localStorage 저장소를 Supabase 저장소로 전환하기

## 7.1 왜 전환이 필요한가

5회차의 `localStorage`는 브라우저 안에만 저장된다. 따라서 다음 문제가 있다.

```text
다른 브라우저에서 볼 수 없다.
다른 기기에서 볼 수 없다.
로그인 사용자별로 구분되지 않는다.
운영자가 데이터를 관리하기 어렵다.
데이터베이스 권한 정책을 적용할 수 없다.
```

6회차부터는 item을 Supabase의 `items` 테이블에 저장한다.

---

## 7.2 item 저장소 파일을 만든다

[AI 코딩 도구 - English prompt]

```text
Replace the localStorage item repository with a Supabase-backed repository.

Create src/lib/items-repository.ts.

Requirements:
- Use the Supabase server client.
- Use requireUser() to ensure the user is authenticated.
- Implement:
  - listItems()
  - getItemById(id)
  - createItem(input)
  - updateItem(id, input)
  - deleteItem(id)
- Always set owner_id to the authenticated user's id when creating an item.
- Do not allow the client to provide owner_id.
- Return only the authenticated user's accessible rows.
- Rely on RLS as the final data protection layer.
```

[한국어 번역]

```text
localStorage 기반 item repository를 Supabase 기반 repository로 교체해 주세요.

src/lib/items-repository.ts 파일을 만듭니다.

요구사항:
- Supabase server client를 사용합니다.
- requireUser()를 사용하여 사용자가 로그인했는지 확인합니다.
- 다음 함수를 구현합니다.
  - listItems()
  - getItemById(id)
  - createItem(input)
  - updateItem(id, input)
  - deleteItem(id)
- item을 만들 때 owner_id는 항상 인증된 사용자의 id로 설정합니다.
- 클라이언트가 owner_id를 직접 전달하게 하지 않습니다.
- 인증된 사용자가 접근 가능한 row만 반환합니다.
- 최종 데이터 보호 계층은 RLS에 의존합니다.
```

직접 작성할 때는 아래 코드를 사용할 수 있다.

[파일 내용: `src/lib/items-repository.ts`]

```ts
import { createClient } from '@/lib/supabase/server'
import { requireUser } from '@/lib/auth/require-user'

export type ItemStatus = 'todo' | 'in_progress' | 'done'

export type ItemInput = {
  title: string
  description?: string
  status: ItemStatus
}

function normalizeInput(input: ItemInput) {
  const title = input.title.trim()
  const description = input.description?.trim() ?? ''
  const status = input.status

  if (!title) {
    throw new Error('제목은 필수입니다.')
  }

  if (!['todo', 'in_progress', 'done'].includes(status)) {
    throw new Error('허용되지 않는 상태값입니다.')
  }

  return { title, description, status }
}

export async function listItems() {
  await requireUser()
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('items')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) {
    throw new Error('item 목록을 불러오지 못했습니다.')
  }

  return data ?? []
}

export async function getItemById(id: string) {
  await requireUser()
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('items')
    .select('*')
    .eq('id', id)
    .single()

  if (error) {
    throw new Error('item을 찾을 수 없습니다.')
  }

  return data
}

export async function createItem(input: ItemInput) {
  const user = await requireUser()
  const supabase = await createClient()
  const normalized = normalizeInput(input)

  const { data, error } = await supabase
    .from('items')
    .insert({
      owner_id: user.id,
      title: normalized.title,
      description: normalized.description,
      status: normalized.status,
    })
    .select('*')
    .single()

  if (error) {
    throw new Error('item을 생성하지 못했습니다.')
  }

  return data
}

export async function updateItem(id: string, input: ItemInput) {
  await requireUser()
  const supabase = await createClient()
  const normalized = normalizeInput(input)

  const { data, error } = await supabase
    .from('items')
    .update({
      title: normalized.title,
      description: normalized.description,
      status: normalized.status,
    })
    .eq('id', id)
    .select('*')
    .single()

  if (error) {
    throw new Error('item을 수정하지 못했습니다.')
  }

  return data
}

export async function deleteItem(id: string) {
  await requireUser()
  const supabase = await createClient()

  const { error } = await supabase.from('items').delete().eq('id', id)

  if (error) {
    throw new Error('item을 삭제하지 못했습니다.')
  }
}
```

---

## 7.3 item Server Actions 만들기

[파일 내용: `src/app/items/actions.ts`]

```ts
'use server'

import { redirect } from 'next/navigation'
import { revalidatePath } from 'next/cache'
import { createItem, deleteItem, updateItem } from '@/lib/items-repository'
import type { ItemStatus } from '@/lib/items-repository'

function readItemForm(formData: FormData) {
  return {
    title: String(formData.get('title') ?? ''),
    description: String(formData.get('description') ?? ''),
    status: String(formData.get('status') ?? 'todo') as ItemStatus,
  }
}

export async function createItemAction(formData: FormData) {
  await createItem(readItemForm(formData))
  revalidatePath('/items')
  redirect('/items')
}

export async function updateItemAction(id: string, formData: FormData) {
  await updateItem(id, readItemForm(formData))
  revalidatePath('/items')
  revalidatePath(`/items/${id}`)
  redirect(`/items/${id}`)
}

export async function deleteItemAction(id: string) {
  await deleteItem(id)
  revalidatePath('/items')
  redirect('/items')
}
```

---

## 7.4 items 화면을 Supabase 데이터로 바꾼다

[AI 코딩 도구 - English prompt]

```text
Update the items pages to use Supabase data instead of localStorage.

Files to update:
- src/app/items/page.tsx
- src/app/items/new/page.tsx
- src/app/items/[id]/page.tsx
- src/app/items/[id]/edit/page.tsx
- src/components/ItemForm.tsx if needed

Requirements:
- Use listItems() in the items list page.
- Use getItemById(id) in the detail and edit pages.
- Use createItemAction, updateItemAction, and deleteItemAction.
- Pages under /items must require login.
- Do not pass owner_id from the client.
- Keep search and status filter if possible, but apply them to the fetched data.
- Remove or archive localStorage usage for production paths.
```

[한국어 번역]

```text
items 페이지가 localStorage가 아니라 Supabase 데이터를 사용하도록 업데이트해 주세요.

수정할 파일:
- src/app/items/page.tsx
- src/app/items/new/page.tsx
- src/app/items/[id]/page.tsx
- src/app/items/[id]/edit/page.tsx
- 필요하면 src/components/ItemForm.tsx

요구사항:
- items 목록 페이지에서는 listItems()를 사용합니다.
- 상세와 수정 페이지에서는 getItemById(id)를 사용합니다.
- createItemAction, updateItemAction, deleteItemAction을 사용합니다.
- /items 아래 페이지는 로그인 상태를 요구합니다.
- 클라이언트에서 owner_id를 전달하지 않습니다.
- 가능하면 검색과 상태 필터를 유지하되, 불러온 데이터에 적용합니다.
- 실제 운영 경로에서는 localStorage 사용을 제거하거나 보관용으로 분리합니다.
```

---

# 8. dashboard 보호하기

## 8.1 dashboard는 로그인 사용자만 접근할 수 있어야 한다

`dashboard` 화면은 로그인하지 않은 사용자가 볼 수 없어야 한다.

[AI 코딩 도구 - English prompt]

```text
Update src/app/dashboard/page.tsx so that it is a protected page.

Requirements:
- Use requireUser().
- Show the user's email.
- Show links to /items and /items/new.
- Include a logout button.
- Do not expose secret environment variables.
```

[한국어 번역]

```text
src/app/dashboard/page.tsx가 보호된 페이지가 되도록 업데이트해 주세요.

요구사항:
- requireUser()를 사용합니다.
- 사용자의 이메일을 표시합니다.
- /items와 /items/new로 이동하는 링크를 표시합니다.
- 로그아웃 버튼을 포함합니다.
- 비밀 환경변수를 노출하지 않습니다.
```

---

# 9. 관리자 권한 구조 만들기

## 9.1 관리자 권한은 왜 별도인가

관리자는 일반 사용자보다 더 넓은 권한을 가진다. 따라서 다음 원칙을 지켜야 한다.

```text
1. 모든 사용자를 관리자로 만들면 안 된다.
2. 일반 사용자가 자기 role을 admin으로 바꿀 수 없어야 한다.
3. 관리자 페이지는 requireAdmin()을 통과한 사용자만 볼 수 있어야 한다.
4. 관리자 권한은 UI가 아니라 서버와 데이터베이스 정책에서 검증되어야 한다.
```

---

## 9.2 관리자 지정하기

수업에서는 Supabase SQL Editor에서 특정 사용자를 관리자로 지정한다.

먼저 회원가입을 한 뒤, 해당 이메일을 사용하여 다음 SQL을 실행한다.

[Supabase SQL Editor]

```sql
update public.profiles
set role = 'admin'
where email = '관리자로_지정할_이메일@example.com';
```

확인한다.

[Supabase SQL Editor]

```sql
select id, email, role
from public.profiles
order by created_at desc;
```

> [!IMPORTANT]
> 일반 사용자가 자기 `role`을 직접 수정할 수 있게 만들면 보안 취약점이 된다. 수업에서는 profile update 기능을 만들지 않는다. 운영 서비스에서는 관리자 role 변경을 별도 서버 로직 또는 관리자 전용 백오피스에서 엄격히 처리해야 한다.

---

## 9.3 관리자 페이지를 보호한다

[AI 코딩 도구 - English prompt]

```text
Update or create the admin page so that it requires admin permission.

File:
- src/app/admin/page.tsx

Requirements:
- Use requireAdmin().
- Show a simple admin-only message.
- If possible, show the total number of items.
- Do not allow role changes from this page yet.
- Keep the implementation minimal but secure.
```

[한국어 번역]

```text
관리자 권한이 필요한 admin page를 업데이트하거나 새로 만들어 주세요.

파일:
- src/app/admin/page.tsx

요구사항:
- requireAdmin()을 사용합니다.
- 관리자 전용 메시지를 표시합니다.
- 가능하면 전체 item 수를 표시합니다.
- 아직 이 페이지에서 role 변경은 허용하지 않습니다.
- 구현은 최소화하되 보안적으로 안전하게 유지합니다.
```

---

# 10. 수동 테스트

## 10.1 인증 테스트

브라우저에서 다음을 순서대로 실행한다.

```text
[ ] /signup으로 이동한다.
[ ] display_name, email, password를 입력한다.
[ ] 회원가입 후 /dashboard로 이동한다.
[ ] 로그아웃한다.
[ ] /login으로 이동한다.
[ ] 이메일과 비밀번호로 로그인한다.
[ ] 로그인 후 /dashboard로 이동한다.
[ ] 로그아웃 후 /dashboard에 접근하면 /login으로 이동한다.
```

---

## 10.2 데이터 저장 테스트

```text
[ ] 사용자 A로 로그인한다.
[ ] /items/new에서 item을 생성한다.
[ ] /items 목록에서 생성한 item이 보인다.
[ ] 상세 화면에서 item이 보인다.
[ ] item을 수정한다.
[ ] item을 삭제한다.
[ ] Supabase Table Editor에서 items 테이블에 데이터가 저장되었는지 확인한다.
```

---

## 10.3 RLS 테스트

RLS 테스트는 오늘 가장 중요한 테스트다.

```text
1. 사용자 A로 회원가입한다.
2. 사용자 A로 item을 1개 만든다.
3. 로그아웃한다.
4. 사용자 B로 회원가입한다.
5. 사용자 B로 /items에 접속한다.
6. 사용자 A가 만든 item이 보이지 않아야 한다.
7. 사용자 B가 item을 1개 만든다.
8. 사용자 A로 다시 로그인한다.
9. 사용자 B가 만든 item이 보이지 않아야 한다.
```

정상 결과는 다음이다.

```text
사용자 A는 사용자 A의 item만 본다.
사용자 B는 사용자 B의 item만 본다.
관리자는 관리자 정책이 있는 범위에서 더 넓게 볼 수 있다.
```

---

# 11. 문서 작성

## 11.1 auth-and-data-storage-notes.md 작성

[파일 내용: `docs/auth-and-data-storage-notes.md`]

```md
# Auth and Data Storage Notes

## 1. 오늘 구현한 것

- Supabase Auth 기반 회원가입
- Supabase Auth 기반 로그인
- 로그아웃
- 로그인 사용자 보호 페이지
- Supabase items 테이블 저장
- 사용자별 item 접근 제한
- 관리자 role 기본 구조

## 2. 인증과 권한의 구분

- 인증 Authentication: 사용자가 누구인지 확인한다.
- 권한 Authorization: 사용자가 어떤 작업을 할 수 있는지 제한한다.

## 3. 데이터 소유권

- items.owner_id는 auth.users.id를 참조한다.
- item 생성 시 owner_id는 서버에서 현재 로그인 사용자 id로 설정한다.
- 클라이언트가 owner_id를 직접 보내지 않는다.

## 4. 보안 원칙

- .env.local은 GitHub에 올리지 않는다.
- service role key는 브라우저 코드에서 사용하지 않는다.
- RLS는 반드시 켜 둔다.
- 관리자 role 변경은 일반 사용자에게 허용하지 않는다.

## 5. 아직 하지 않은 것

- 소셜 로그인
- 비밀번호 재설정
- 이메일 인증 고도화
- 관리자 role 변경 UI
- 배포 환경의 인증 callback 설정
```

---

## 11.2 rls-policy-checklist.md 작성

[파일 내용: `docs/rls-policy-checklist.md`]

```md
# RLS Policy Checklist

## profiles

- [ ] RLS가 enable 되어 있다.
- [ ] 사용자는 자기 profile만 조회할 수 있다.
- [ ] 관리자는 모든 profile을 조회할 수 있다.
- [ ] 일반 사용자가 자기 role을 admin으로 바꿀 수 없다.

## items

- [ ] RLS가 enable 되어 있다.
- [ ] 사용자는 자기 item만 조회할 수 있다.
- [ ] 사용자는 자기 item만 생성할 수 있다.
- [ ] 사용자는 자기 item만 수정할 수 있다.
- [ ] 사용자는 자기 item만 삭제할 수 있다.
- [ ] 관리자는 필요한 범위에서 item을 조회할 수 있다.

## 보안 검토

- [ ] service role key가 코드에 없다.
- [ ] service role key가 .env.local에도 없다.
- [ ] .env.local이 .gitignore에 포함되어 있다.
- [ ] owner_id는 서버에서 설정한다.
- [ ] 사용자 A와 사용자 B의 데이터가 분리되어 있다.
```

---

## 11.3 README.md 보완

AI 코딩 도구에 요청한다.

[AI 코딩 도구 - English prompt]

```text
Update README.md for Session 6.

Add sections:
- Authentication
- Authorization
- Data Storage
- Environment Variables
- Security Rules
- How to Test Auth and RLS

Mention:
- Supabase Auth is used for signup and login.
- Supabase PostgreSQL stores items.
- Row Level Security restricts users to their own items.
- .env.local must not be committed.
- service role keys must not be exposed.
```

[한국어 번역]

```text
6회차 내용을 반영하여 README.md를 업데이트해 주세요.

추가할 섹션:
- Authentication
- Authorization
- Data Storage
- Environment Variables
- Security Rules
- How to Test Auth and RLS

포함할 내용:
- 회원가입과 로그인에는 Supabase Auth를 사용합니다.
- item 저장에는 Supabase PostgreSQL을 사용합니다.
- Row Level Security는 사용자가 자기 item만 접근하도록 제한합니다.
- .env.local은 커밋하면 안 됩니다.
- service role key는 노출하면 안 됩니다.
```

---

# 12. 품질 게이트

6회차가 끝나기 전에 다음을 확인한다.

## 12.1 인증 게이트

```text
[ ] 회원가입이 된다.
[ ] 로그인이 된다.
[ ] 로그아웃이 된다.
[ ] 로그인하지 않고 /dashboard에 접근하면 /login으로 이동한다.
[ ] 로그인하지 않고 /items에 접근하면 /login으로 이동한다.
```

## 12.2 데이터 저장 게이트

```text
[ ] item 생성 시 Supabase items 테이블에 row가 생긴다.
[ ] item의 owner_id가 현재 로그인 사용자 id와 일치한다.
[ ] item 수정이 된다.
[ ] item 삭제가 된다.
[ ] 새로고침 후에도 item이 유지된다.
```

## 12.3 RLS 게이트

```text
[ ] 사용자 A는 사용자 A의 item만 볼 수 있다.
[ ] 사용자 B는 사용자 B의 item만 볼 수 있다.
[ ] 사용자 B는 사용자 A의 item을 볼 수 없다.
[ ] RLS가 profiles와 items에 켜져 있다.
[ ] 일반 사용자는 자기 role을 admin으로 변경할 수 없다.
```

## 12.4 보안 게이트

```text
[ ] .env.local이 .gitignore에 포함되어 있다.
[ ] .env.local.example만 GitHub에 올린다.
[ ] service role key를 사용하지 않는다.
[ ] owner_id를 클라이언트에서 입력받지 않는다.
[ ] 에러 메시지가 비밀번호, 토큰, key를 노출하지 않는다.
```

AI 코딩 도구에 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구 - English prompt]

```text
Review this project against the Session 6 quality gates.

Check:
1. signup works,
2. login works,
3. logout works,
4. protected pages require authentication,
5. items are stored in Supabase,
6. owner_id is set server-side,
7. users can only access their own items,
8. RLS is enabled for profiles and items,
9. .env.local is ignored by Git,
10. no service role key is exposed.

Return PASS, CONCERNS, or FAIL.
For each concern, provide the exact fix.
```

[한국어 번역]

```text
이 프로젝트를 6회차 품질 게이트 기준으로 검토해 주세요.

확인 항목:
1. 회원가입이 작동하는가,
2. 로그인이 작동하는가,
3. 로그아웃이 작동하는가,
4. 보호된 페이지가 인증을 요구하는가,
5. item이 Supabase에 저장되는가,
6. owner_id가 서버에서 설정되는가,
7. 사용자가 자기 item만 접근할 수 있는가,
8. profiles와 items에 RLS가 켜져 있는가,
9. .env.local이 Git에서 제외되는가,
10. service role key가 노출되지 않는가.

PASS, CONCERNS, FAIL 중 하나로 판정해 주세요.
각 우려 사항에 대해 정확한 수정 방법을 제시해 주세요.
```

---

# 13. GitHub에 커밋하기 전 확인

## 13.1 git status 확인

[터미널]

```bash
git status
```

`.env.local`이 보이면 안 된다. 만약 `.env.local`이 `Changes to be committed` 또는 `Untracked files`에 보이면 즉시 멈춘다.

`.env.local`이 Git 추적 대상에 들어갔다면 다음을 실행한다.

[터미널]

```bash
git rm --cached .env.local
```

그 다음 `.gitignore`를 다시 확인한다.

---

## 13.2 커밋한다

[터미널]

```bash
git add .
git commit -m "Add authentication authorization and Supabase data storage"
```

---

# 14. 과제 안내

## 과제 1. RLS 테스트 기록 작성

`docs/auth-manual-test-checklist.md`를 만들고 다음 양식을 채운다.

[파일 내용: `docs/auth-manual-test-checklist.md`]

```md
# Auth Manual Test Checklist

## 1. 테스트 계정

- 사용자 A 이메일:
- 사용자 B 이메일:
- 관리자 이메일:

## 2. 회원가입 테스트

- [ ] 사용자 A 회원가입 성공
- [ ] 사용자 B 회원가입 성공

## 3. 로그인 테스트

- [ ] 사용자 A 로그인 성공
- [ ] 사용자 B 로그인 성공
- [ ] 잘못된 비밀번호 입력 시 오류 메시지 표시

## 4. 데이터 소유권 테스트

- [ ] 사용자 A가 item 생성
- [ ] 사용자 A가 자기 item 조회
- [ ] 사용자 B는 사용자 A의 item을 볼 수 없음
- [ ] 사용자 B가 자기 item 생성
- [ ] 사용자 A는 사용자 B의 item을 볼 수 없음

## 5. 관리자 권한 테스트

- [ ] 관리자 role 지정
- [ ] 관리자 페이지 접근 가능
- [ ] 일반 사용자는 관리자 페이지 접근 불가

## 6. 발견한 문제

- 문제 1:
- 문제 2:
- 수정 필요 사항:
```

---

## 과제 2. 보안 리스크 5개 작성

`docs/security-risk-notes.md`를 만들고 다음 질문에 답한다.

```text
1. .env.local을 GitHub에 올리면 어떤 문제가 생기는가?
2. service role key를 브라우저 코드에 넣으면 어떤 문제가 생기는가?
3. RLS를 끄면 어떤 문제가 생기는가?
4. owner_id를 클라이언트가 직접 입력하게 하면 어떤 문제가 생기는가?
5. 관리자 role 변경을 일반 사용자에게 허용하면 어떤 문제가 생기는가?
```

---

# 15. 자주 생기는 문제와 해결법

## 15.1 환경변수 오류가 난다

오류 예시:

```text
Missing Supabase environment variables
```

해결:

```text
1. .env.local 파일이 프로젝트 루트에 있는지 확인한다.
2. 변수 이름이 정확한지 확인한다.
3. NEXT_PUBLIC_SUPABASE_URL 오타를 확인한다.
4. NEXT_PUBLIC_SUPABASE_ANON_KEY 오타를 확인한다.
5. npm run dev를 껐다가 다시 실행한다.
```

---

## 15.2 회원가입 후 profiles row가 생기지 않는다

가능한 원인:

```text
handle_new_user trigger가 생성되지 않았다.
SQL 실행 중 일부가 실패했다.
이메일 인증 설정 때문에 세션 생성 흐름이 달라졌다.
```

확인 SQL:

[Supabase SQL Editor]

```sql
select * from public.profiles order by created_at desc;
```

trigger 확인 SQL:

[Supabase SQL Editor]

```sql
select trigger_name
from information_schema.triggers
where trigger_name = 'on_auth_user_created';
```

---

## 15.3 item 생성이 실패한다

가능한 원인:

```text
로그인 상태가 아니다.
owner_id가 누락되었다.
RLS insert policy가 없다.
status 값이 todo, in_progress, done 중 하나가 아니다.
```

확인할 부분:

```text
createItem()에서 owner_id: user.id를 넣고 있는가?
items_insert_own policy가 있는가?
로그인 후 item을 생성하고 있는가?
```

---

## 15.4 사용자 B가 사용자 A의 item을 볼 수 있다

이는 심각한 문제다. 즉시 다음을 확인한다.

[Supabase SQL Editor]

```sql
select relname, relrowsecurity
from pg_class
where relname = 'items';
```

`relrowsecurity`가 `false`이면 RLS가 꺼져 있는 것이다. 다시 켠다.

[Supabase SQL Editor]

```sql
alter table public.items enable row level security;
```

그 다음 policy를 다시 확인한다.

[Supabase SQL Editor]

```sql
select policyname, cmd, qual, with_check
from pg_policies
where tablename = 'items';
```

---

## 15.5 .env.local이 git status에 보인다

`.env.local`은 Git에 올라가면 안 된다.

해결:

[터미널]

```bash
git rm --cached .env.local
```

`.gitignore`에 다음을 추가한다.

```gitignore
.env.local
.env.*.local
```

다시 확인한다.

[터미널]

```bash
git status
```

---

# 16. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> 웹서비스의 데이터 보안은 화면에서만 처리하는 것이 아니라, 서버 로직과 데이터베이스 RLS 정책에서 함께 보장해야 한다.

6회차의 흐름은 다음과 같다.

```text
Supabase 프로젝트 생성
→ 환경변수 설정
→ 패키지 설치
→ profiles/items 테이블 생성
→ RLS 정책 설정
→ Supabase client 생성
→ 회원가입/로그인/로그아웃 구현
→ localStorage를 Supabase 저장소로 전환
→ 보호 페이지와 관리자 구조 구현
→ RLS 수동 테스트
```

다음 차시에서는 다음으로 나아간다.

```text
7회차 웹서비스 트랙:
테스트·보안·배포 준비
```

---

# 부록 A. 오늘 사용하는 핵심 명령 모음

## 터미널 명령

```bash
pwd
npm install @supabase/supabase-js @supabase/ssr
npm run dev
npm ls @supabase/supabase-js @supabase/ssr
git status
git add .
git commit -m "Add authentication authorization and Supabase data storage"
```

## Supabase SQL 확인 명령

```sql
select * from auth.users;
select * from public.profiles;
select * from public.items;

select relname, relrowsecurity
from pg_class
where relname in ('profiles', 'items');

select policyname, cmd, qual, with_check
from pg_policies
where tablename in ('profiles', 'items');
```

## AI 코딩 도구 핵심 프롬프트

```text
Create Supabase authentication and data storage for this Next.js App Router project.
Use Supabase Auth, Supabase SSR, profiles table, items table, and Row Level Security.
Do not expose service role keys.
Make protected pages require login.
Ensure users can access only their own items.
```

[한국어 번역]

```text
이 Next.js App Router 프로젝트에 Supabase 기반 인증과 데이터 저장 기능을 만들어 주세요.
Supabase Auth, Supabase SSR, profiles 테이블, items 테이블, Row Level Security를 사용합니다.
service role key를 노출하지 마세요.
보호된 페이지는 로그인을 요구하게 하세요.
사용자가 자기 item만 접근할 수 있도록 보장하세요.
```

---

# 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| Authentication | 사용자가 누구인지 확인하는 절차 |
| Authorization | 사용자가 무엇을 할 수 있는지 제한하는 규칙 |
| Session | 로그인 상태를 유지하기 위한 정보 |
| RLS | 데이터베이스 행 단위 접근 제어 정책 |
| owner_id | 데이터 소유자를 나타내는 사용자 id |
| Server Action | 서버에서 실행되는 Next.js 함수 |
| Server Component | 서버에서 렌더링되는 React component |
| Client Component | 브라우저에서 상호작용을 처리하는 React component |
| anon key | Supabase 클라이언트 접근에 사용하는 공개 key |
| service role key | 관리자 권한 key. 브라우저와 GitHub에 노출 금지 |

