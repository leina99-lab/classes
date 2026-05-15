# 5회차 학습자 실습 매뉴얼: 웹서비스 트랙

# 핵심 기능 구현과 상태 관리
## mock 화면 → 상호작용 가능한 MVP → 상태 관리 → 생성·조회·수정·삭제 → 검색·필터 → 수동 테스트

---

## 이 자료의 목적

5회차의 목표는 새로운 기술을 많이 배우는 것이 아니다. 5회차의 목표는 4회차에서 만든 **브라우저에서 열리는 웹서비스 골격**을, 사용자가 실제로 조작할 수 있는 **상호작용 가능한 MVP**로 확장하는 것이다.

4회차에서는 다음 산출물을 만들었다.

```text
1. 실행 가능한 Next.js 프로젝트 골격
2. 공통 레이아웃과 상단 내비게이션
3. 핵심 페이지 6개 이상
4. mock data 기반 목록·상세 화면
5. 기본 입력 form과 validation
6. mock API route
7. README 실행 방법
```

5회차에서는 이 골격을 바탕으로 다음을 만든다.

```text
1. 핵심 데이터 타입 보완
2. form validation 보완
3. localStorage 기반 임시 저장소
4. useItems 상태 관리 hook
5. Item 생성 기능
6. Item 수정 기능
7. Item 삭제 기능
8. 검색과 상태 필터
9. 빈 상태, 오류 상태, 저장 성공 상태 메시지
10. 수동 테스트 체크리스트
11. README 기능 설명 보완
```

오늘의 핵심 문장은 다음이다.

> 웹서비스의 핵심 기능은 “화면이 있는가”가 아니라 “사용자가 입력하고, 저장하고, 다시 확인할 수 있는가”로 판단한다.

5회차가 끝나면 학습자는 다음을 할 수 있어야 한다.

```text
Items 목록에서 데이터를 확인한다.
새 Item을 생성한다.
상세 화면에서 Item을 확인한다.
기존 Item을 수정한다.
Item을 삭제한다.
제목과 설명으로 검색한다.
상태별로 필터링한다.
새로고침 후에도 localStorage에 저장된 Item을 확인한다.
```

> [!IMPORTANT]
> 5회차에서는 실제 데이터베이스, 실제 로그인, 실제 권한 관리를 구현하지 않는다. 이 기능은 다음 차시에서 다룬다. 오늘은 `localStorage`를 사용하여 “브라우저 안에서 임시로 저장되는 MVP”를 만든다.

---

## 오늘 끝나면 있어야 하는 것

5회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
my-web-service/
├── docs/
│   ├── state-management-notes.md
│   └── manual-test-checklist.md
├── src/
│   ├── app/
│   │   ├── items/
│   │   │   ├── [id]/
│   │   │   │   ├── edit/
│   │   │   │   │   └── page.tsx
│   │   │   │   └── page.tsx
│   │   │   ├── new/
│   │   │   │   └── page.tsx
│   │   │   └── page.tsx
│   │   └── globals.css
│   ├── components/
│   │   ├── EmptyState.tsx
│   │   ├── ErrorMessage.tsx
│   │   ├── ItemCard.tsx
│   │   ├── ItemDetailClient.tsx
│   │   ├── ItemForm.tsx
│   │   ├── ItemsClient.tsx
│   │   ├── NewItemClient.tsx
│   │   ├── EditItemClient.tsx
│   │   └── SearchFilterBar.tsx
│   ├── hooks/
│   │   └── useItems.ts
│   ├── lib/
│   │   ├── item-repository.ts
│   │   ├── local-storage.ts
│   │   ├── mock-data.ts
│   │   └── validation.ts
│   └── types/
│       └── index.ts
├── README.md
└── package.json
```

> [!NOTE]
> 4회차에서 일부 파일이 이미 존재한다. 5회차에서는 기존 파일을 삭제하지 않고, 필요한 파일만 보완하거나 교체한다.

---

## 오늘 사용할 입력 위치를 구분하자

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `npm run dev` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `Create src/hooks/useItems.ts` |
| `[파일 내용]` | TypeScript, CSS, Markdown 파일 안에 들어갈 내용 | `export function useItems()` |

아래 명령은 터미널에 입력한다.

```bash
npm run dev
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create src/lib/item-repository.ts
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

PowerShell이 열리면 보통 다음과 비슷하다.

```powershell
PS C:\Users\내이름>
```

Mac에서는 Terminal을 연다.

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

Mac 터미널은 보통 다음과 비슷하다.

```bash
내이름@MacBook ~ %
```

앞으로 “터미널”이라고 하면 Windows에서는 PowerShell, Mac에서는 Terminal을 의미한다.

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

## 0.3 4회차 산출물이 있는지 확인한다

4회차에서 만든 웹서비스 골격이 있어야 5회차를 진행할 수 있다.

### Windows PowerShell

[터미널]

```powershell
dir src\app
dir src\components
dir src\lib
```

### Mac Terminal

[터미널]

```bash
ls src/app
ls src/components
ls src/lib
```

다음 파일 또는 폴더가 보이면 정상이다.

```text
src/app/page.tsx
src/app/items/page.tsx
src/app/items/new/page.tsx
src/app/items/[id]/page.tsx
src/components/ItemForm.tsx
src/lib/mock-data.ts
src/lib/validation.ts
src/types/index.ts
```

만약 없다면 4회차 웹서비스 트랙 매뉴얼을 먼저 완료한다.

---

## 0.4 개발 서버가 실행되는지 확인한다

[터미널]

```bash
npm run dev
```

정상이라면 다음과 비슷한 문구가 나온다.

```text
Local: http://localhost:3000
```

브라우저에서 다음 주소를 연다.

```text
http://localhost:3000
```

홈 화면이 열리면 정상이다.

개발 서버를 멈추려면 터미널에서 다음을 누른다.

```text
Ctrl + C
```

---

# 1. 오늘 구현할 기능 범위 이해

## 1.1 오늘 하는 것

5회차에서는 다음 기능을 구현한다.

```text
Item 목록 보기
Item 생성
Item 상세 보기
Item 수정
Item 삭제
검색
상태 필터
localStorage 저장
빈 상태와 오류 상태 처리
```

즉, 사용자가 서비스를 실제로 만져볼 수 있는 최소 기능을 만든다.

---

## 1.2 오늘 하지 않는 것

5회차에서는 다음을 하지 않는다.

```text
실제 회원가입
실제 로그인
실제 권한 관리
실제 데이터베이스 연결
실제 서버 인증
결제 기능
배포
```

이것을 하지 않는 이유는 간단하다. 초보 학습자가 한 번에 인증, DB, 배포까지 구현하면 프로젝트 구조를 이해하기 어렵다. 먼저 “상태가 어떻게 바뀌고 화면에 어떻게 반영되는가”를 이해해야 한다.

---

## 1.3 핵심 용어

| 용어 | 뜻 |
|---|---|
| state | 화면이 기억하고 있는 현재 값 |
| 상태 관리 | state를 만들고, 바꾸고, 화면에 반영하는 과정 |
| localStorage | 브라우저 안에 간단한 데이터를 저장하는 공간 |
| CRUD | Create, Read, Update, Delete. 생성, 조회, 수정, 삭제 |
| validation | 입력값이 올바른지 확인하는 과정 |
| empty state | 보여줄 데이터가 없을 때의 화면 상태 |
| error state | 오류가 발생했을 때의 화면 상태 |
| source of truth | 여러 값이 충돌할 때 기준이 되는 데이터 |

오늘 프로젝트에서 `localStorage`는 임시 저장소 역할을 한다. 실제 서비스에서는 나중에 데이터베이스가 이 역할을 맡는다.

---

# 2. 실습 1 — 5회차 작업 폴더와 문서 만들기

## 2.1 필요한 폴더를 만든다

### Windows PowerShell

[터미널]

```powershell
$dirs = @(
  "src/hooks",
  "src/components",
  "src/lib",
  "src/types",
  "src/app/items/[id]/edit",
  "docs"
)

foreach ($d in $dirs) {
  New-Item -ItemType Directory -Force $d | Out-Null
}
```

### Mac Terminal

[터미널]

```bash
mkdir -p src/hooks src/components src/lib src/types
mkdir -p 'src/app/items/[id]/edit'
mkdir -p docs
```

---

## 2.2 AI 코딩 도구에게 전체 방향을 알려준다

Claude Code 또는 Gemini CLI를 실행한다.

[터미널]

```bash
claude
```

또는:

[터미널]

```bash
gemini
```

AI 코딩 도구 안에서 다음을 입력한다.

[AI 코딩 도구]

```text
/clear
```

그다음 다음 지시를 입력한다.

[AI 코딩 도구]

```text
We are working on Session 5 of the web service track.

Goal:
Turn the static MVP skeleton from Session 4 into an interactive MVP.

Rules:
- Use Next.js, React, TypeScript.
- Do not add a real database yet.
- Do not implement real authentication yet.
- Use localStorage as a temporary client-side store.
- Implement create, read, update, delete, search, and status filter for ServiceItem.
- Keep the code beginner-friendly.
- Do not change the stack without asking.
- Report generated and modified files clearly.
```

이 지시는 AI가 데이터베이스나 인증을 갑자기 추가하지 못하게 하는 안전장치다.

---

# 3. 실습 2 — 타입과 validation 보완

## 3.1 src/types/index.ts 보완

4회차에서 만든 타입을 조금 더 명확하게 보완한다.

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

export interface ItemFormValues {
  title: string;
  description: string;
  status: ItemStatus;
  ownerName: string;
}
```

직접 파일을 열려면 다음 명령을 사용한다.

### Windows PowerShell

[터미널]

```powershell
notepad src\types\index.ts
```

### Mac Terminal

[터미널]

```bash
nano src/types/index.ts
```

---

## 3.2 src/lib/validation.ts 교체

5회차에서는 제목과 설명뿐 아니라 상태와 작성자도 검증한다.

[파일 내용: `src/lib/validation.ts`]

```ts
import type { ItemFormValues, ItemStatus } from "@/types";

export interface ValidationResult {
  isValid: boolean;
  errors: Partial<Record<keyof ItemFormValues, string>>;
}

const VALID_STATUSES: ItemStatus[] = ["draft", "active", "archived"];

export function validateItemForm(values: ItemFormValues): ValidationResult {
  const errors: ValidationResult["errors"] = {};
  const title = values.title.trim();
  const description = values.description.trim();
  const ownerName = values.ownerName.trim();

  if (!title) {
    errors.title = "제목은 반드시 입력해야 한다.";
  } else if (title.length > 80) {
    errors.title = "제목은 80자 이하로 입력해야 한다.";
  }

  if (!description) {
    errors.description = "설명은 반드시 입력해야 한다.";
  } else if (description.length < 10) {
    errors.description = "설명은 최소 10자 이상 입력해야 한다.";
  }

  if (!ownerName) {
    errors.ownerName = "작성자 이름은 반드시 입력해야 한다.";
  } else if (ownerName.length > 30) {
    errors.ownerName = "작성자 이름은 30자 이하로 입력해야 한다.";
  }

  if (!VALID_STATUSES.includes(values.status)) {
    errors.status = "상태값이 올바르지 않다.";
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors,
  };
}

export function createEmptyItemFormValues(): ItemFormValues {
  return {
    title: "",
    description: "",
    status: "draft",
    ownerName: "",
  };
}
```

---

# 4. 실습 3 — localStorage 저장소 만들기

## 4.1 localStorage란 무엇인가

`localStorage`는 브라우저가 제공하는 작은 저장 공간이다. 서버나 데이터베이스가 없어도 브라우저 안에 문자열 데이터를 저장할 수 있다.

오늘은 `ServiceItem` 목록을 localStorage에 저장한다.

```text
처음 실행할 때: mockItems를 localStorage에 복사한다.
새 Item 생성: localStorage에 추가한다.
수정: localStorage 안의 값을 바꾼다.
삭제: localStorage에서 제거한다.
새로고침: localStorage에서 다시 읽는다.
```

> [!WARNING]
> localStorage는 실제 서비스의 안전한 저장소가 아니다. 민감정보, 비밀번호, 개인정보를 저장하면 안 된다. 오늘은 학습용 임시 저장소로만 사용한다.

---

## 4.2 src/lib/local-storage.ts 만들기

[파일 내용: `src/lib/local-storage.ts`]

```ts
export function readJsonFromLocalStorage<T>(key: string, fallbackValue: T): T {
  if (typeof window === "undefined") {
    return fallbackValue;
  }

  const rawValue = window.localStorage.getItem(key);

  if (!rawValue) {
    return fallbackValue;
  }

  try {
    return JSON.parse(rawValue) as T;
  } catch {
    window.localStorage.removeItem(key);
    return fallbackValue;
  }
}

export function writeJsonToLocalStorage<T>(key: string, value: T): void {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(key, JSON.stringify(value));
}

export function removeLocalStorageItem(key: string): void {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.removeItem(key);
}
```

---

## 4.3 src/lib/item-repository.ts 만들기

`item-repository.ts`는 Item 데이터를 읽고 쓰는 파일이다. 오늘은 localStorage를 사용하지만, 다음 차시에 데이터베이스로 바꿀 때도 이 파일이 중요한 기준점이 된다.

[파일 내용: `src/lib/item-repository.ts`]

```ts
import { mockItems } from "@/lib/mock-data";
import {
  readJsonFromLocalStorage,
  removeLocalStorageItem,
  writeJsonToLocalStorage,
} from "@/lib/local-storage";
import type { ItemFormValues, ServiceItem } from "@/types";

const STORAGE_KEY = "session-5-service-items";

function todayText(): string {
  return new Date().toISOString().slice(0, 10);
}

function createId(): string {
  return `item-${Date.now()}`;
}

export function listItems(): ServiceItem[] {
  return readJsonFromLocalStorage<ServiceItem[]>(STORAGE_KEY, mockItems);
}

export function saveItems(items: ServiceItem[]): void {
  writeJsonToLocalStorage(STORAGE_KEY, items);
}

export function getItemById(id: string): ServiceItem | undefined {
  return listItems().find((item) => item.id === id);
}

export function createItem(values: ItemFormValues): ServiceItem {
  const items = listItems();
  const now = todayText();

  const newItem: ServiceItem = {
    id: createId(),
    title: values.title.trim(),
    description: values.description.trim(),
    status: values.status,
    ownerName: values.ownerName.trim(),
    createdAt: now,
    updatedAt: now,
  };

  saveItems([newItem, ...items]);
  return newItem;
}

export function updateItem(id: string, values: ItemFormValues): ServiceItem | undefined {
  const items = listItems();
  let updatedItem: ServiceItem | undefined;

  const updatedItems = items.map((item) => {
    if (item.id !== id) {
      return item;
    }

    updatedItem = {
      ...item,
      title: values.title.trim(),
      description: values.description.trim(),
      status: values.status,
      ownerName: values.ownerName.trim(),
      updatedAt: todayText(),
    };

    return updatedItem;
  });

  saveItems(updatedItems);
  return updatedItem;
}

export function deleteItem(id: string): void {
  const items = listItems();
  saveItems(items.filter((item) => item.id !== id));
}

export function resetItems(): void {
  removeLocalStorageItem(STORAGE_KEY);
}
```

---

# 5. 실습 4 — useItems 상태 관리 hook 만들기

## 5.1 hook이란 무엇인가

React에서 hook은 화면이 사용할 수 있는 기능 묶음이다. 오늘 만들 `useItems`는 다음 일을 한다.

```text
Item 목록을 state로 보관한다.
localStorage에서 데이터를 읽는다.
새 Item을 추가한다.
기존 Item을 수정한다.
Item을 삭제한다.
검색어와 필터를 적용한다.
```

---

## 5.2 src/hooks/useItems.ts 만들기

[파일 내용: `src/hooks/useItems.ts`]

```ts
"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import {
  createItem,
  deleteItem,
  getItemById,
  listItems,
  resetItems,
  updateItem,
} from "@/lib/item-repository";
import type { ItemFormValues, ItemStatus, ServiceItem } from "@/types";

export type StatusFilter = "all" | ItemStatus;

export function useItems() {
  const [items, setItems] = useState<ServiceItem[]>([]);
  const [isReady, setIsReady] = useState(false);
  const [query, setQuery] = useState("");
  const [statusFilter, setStatusFilter] = useState<StatusFilter>("all");

  useEffect(() => {
    setItems(listItems());
    setIsReady(true);
  }, []);

  const refresh = useCallback(() => {
    setItems(listItems());
  }, []);

  const addItem = useCallback((values: ItemFormValues) => {
    const created = createItem(values);
    refresh();
    return created;
  }, [refresh]);

  const editItem = useCallback((id: string, values: ItemFormValues) => {
    const updated = updateItem(id, values);
    refresh();
    return updated;
  }, [refresh]);

  const removeItem = useCallback((id: string) => {
    deleteItem(id);
    refresh();
  }, [refresh]);

  const getItem = useCallback((id: string) => {
    return getItemById(id);
  }, []);

  const resetToMockData = useCallback(() => {
    resetItems();
    refresh();
  }, [refresh]);

  const filteredItems = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase();

    return items.filter((item) => {
      const matchesQuery =
        !normalizedQuery ||
        item.title.toLowerCase().includes(normalizedQuery) ||
        item.description.toLowerCase().includes(normalizedQuery) ||
        item.ownerName.toLowerCase().includes(normalizedQuery);

      const matchesStatus = statusFilter === "all" || item.status === statusFilter;

      return matchesQuery && matchesStatus;
    });
  }, [items, query, statusFilter]);

  return {
    items,
    filteredItems,
    isReady,
    query,
    setQuery,
    statusFilter,
    setStatusFilter,
    addItem,
    editItem,
    removeItem,
    getItem,
    resetToMockData,
  };
}
```

---

# 6. 실습 5 — 공통 컴포넌트 보완

## 6.1 EmptyState 컴포넌트

데이터가 없을 때 빈 화면만 보이면 사용자가 오류라고 생각할 수 있다. 그래서 빈 상태를 설명하는 컴포넌트를 만든다.

[파일 내용: `src/components/EmptyState.tsx`]

```tsx
import Link from "next/link";

interface EmptyStateProps {
  title: string;
  description: string;
  actionHref?: string;
  actionLabel?: string;
}

export function EmptyState({
  title,
  description,
  actionHref,
  actionLabel,
}: EmptyStateProps) {
  return (
    <section className="state-card">
      <h2>{title}</h2>
      <p>{description}</p>
      {actionHref && actionLabel ? (
        <Link className="primary-button" href={actionHref}>
          {actionLabel}
        </Link>
      ) : null}
    </section>
  );
}
```

---

## 6.2 ErrorMessage 컴포넌트

[파일 내용: `src/components/ErrorMessage.tsx`]

```tsx
interface ErrorMessageProps {
  message: string;
}

export function ErrorMessage({ message }: ErrorMessageProps) {
  return <p className="error-message">{message}</p>;
}
```

---

## 6.3 SearchFilterBar 컴포넌트

[파일 내용: `src/components/SearchFilterBar.tsx`]

```tsx
"use client";

import type { StatusFilter } from "@/hooks/useItems";

interface SearchFilterBarProps {
  query: string;
  statusFilter: StatusFilter;
  onQueryChange: (value: string) => void;
  onStatusFilterChange: (value: StatusFilter) => void;
  onReset: () => void;
}

export function SearchFilterBar({
  query,
  statusFilter,
  onQueryChange,
  onStatusFilterChange,
  onReset,
}: SearchFilterBarProps) {
  return (
    <section className="toolbar" aria-label="검색과 필터">
      <label htmlFor="item-search">검색어</label>
      <input
        id="item-search"
        value={query}
        onChange={(event) => onQueryChange(event.target.value)}
        placeholder="제목, 설명, 작성자 검색"
      />

      <label htmlFor="status-filter">상태</label>
      <select
        id="status-filter"
        value={statusFilter}
        onChange={(event) => onStatusFilterChange(event.target.value as StatusFilter)}
      >
        <option value="all">전체</option>
        <option value="draft">Draft</option>
        <option value="active">Active</option>
        <option value="archived">Archived</option>
      </select>

      <button type="button" className="secondary-button" onClick={onReset}>
        초기 mock data로 되돌리기
      </button>
    </section>
  );
}
```

---

## 6.4 ItemForm 컴포넌트 교체

5회차의 form은 생성과 수정 화면에서 모두 사용한다.

[파일 내용: `src/components/ItemForm.tsx`]

```tsx
"use client";

import { useState } from "react";
import { createEmptyItemFormValues, validateItemForm } from "@/lib/validation";
import type { ItemFormValues } from "@/types";

interface ItemFormProps {
  initialValues?: ItemFormValues;
  submitLabel: string;
  onSubmit: (values: ItemFormValues) => void;
}

export function ItemForm({
  initialValues = createEmptyItemFormValues(),
  submitLabel,
  onSubmit,
}: ItemFormProps) {
  const [values, setValues] = useState<ItemFormValues>(initialValues);
  const [errors, setErrors] = useState<Partial<Record<keyof ItemFormValues, string>>>({});
  const [successMessage, setSuccessMessage] = useState("");

  function updateField(field: keyof ItemFormValues, value: string) {
    setValues((current) => ({ ...current, [field]: value }));
    setErrors((current) => ({ ...current, [field]: undefined }));
    setSuccessMessage("");
  }

  function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();

    const result = validateItemForm(values);
    setErrors(result.errors);

    if (!result.isValid) {
      setSuccessMessage("");
      return;
    }

    onSubmit(values);
    setSuccessMessage("저장되었다.");
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

      <label htmlFor="ownerName">작성자</label>
      <input
        id="ownerName"
        name="ownerName"
        value={values.ownerName}
        onChange={(event) => updateField("ownerName", event.target.value)}
        placeholder="예: 김연구"
      />
      {errors.ownerName ? <p className="error-message">{errors.ownerName}</p> : null}

      <label htmlFor="status">상태</label>
      <select
        id="status"
        name="status"
        value={values.status}
        onChange={(event) => updateField("status", event.target.value)}
      >
        <option value="draft">Draft</option>
        <option value="active">Active</option>
        <option value="archived">Archived</option>
      </select>
      {errors.status ? <p className="error-message">{errors.status}</p> : null}

      <button className="primary-button" type="submit">
        {submitLabel}
      </button>

      {successMessage ? <p className="success-message">{successMessage}</p> : null}
    </form>
  );
}
```

---

## 6.5 ItemCard 컴포넌트 교체

[파일 내용: `src/components/ItemCard.tsx`]

```tsx
import Link from "next/link";
import { StatusBadge } from "@/components/StatusBadge";
import type { ServiceItem } from "@/types";

export function ItemCard({ item }: { item: ServiceItem }) {
  return (
    <article className="card">
      <div className="card-header-row">
        <h2>{item.title}</h2>
        <StatusBadge status={item.status} />
      </div>
      <p>{item.description}</p>
      <dl className="meta-list">
        <div>
          <dt>작성자</dt>
          <dd>{item.ownerName}</dd>
        </div>
        <div>
          <dt>수정일</dt>
          <dd>{item.updatedAt}</dd>
        </div>
      </dl>
      <div className="button-row">
        <Link className="secondary-button" href={`/items/${item.id}`}>
          상세 보기
        </Link>
        <Link className="secondary-button" href={`/items/${item.id}/edit`}>
          수정
        </Link>
      </div>
    </article>
  );
}
```

---

# 7. 실습 6 — Items 목록 화면에 상태 관리 연결

## 7.1 ItemsClient 컴포넌트 만들기

Next.js의 페이지 파일은 서버 컴포넌트일 수 있다. 따라서 상태 관리는 별도의 client component로 분리한다.

[파일 내용: `src/components/ItemsClient.tsx`]

```tsx
"use client";

import Link from "next/link";
import { EmptyState } from "@/components/EmptyState";
import { ItemCard } from "@/components/ItemCard";
import { SearchFilterBar } from "@/components/SearchFilterBar";
import { useItems } from "@/hooks/useItems";

export function ItemsClient() {
  const {
    filteredItems,
    isReady,
    query,
    setQuery,
    statusFilter,
    setStatusFilter,
    resetToMockData,
  } = useItems();

  if (!isReady) {
    return <p>데이터를 불러오는 중이다.</p>;
  }

  return (
    <div className="content-stack">
      <div className="button-row">
        <Link className="primary-button" href="/items/new">
          새 item 만들기
        </Link>
      </div>

      <SearchFilterBar
        query={query}
        statusFilter={statusFilter}
        onQueryChange={setQuery}
        onStatusFilterChange={setStatusFilter}
        onReset={resetToMockData}
      />

      {filteredItems.length === 0 ? (
        <EmptyState
          title="표시할 item이 없다"
          description="검색어 또는 필터 조건을 바꾸거나 새 item을 생성한다."
          actionHref="/items/new"
          actionLabel="새 item 만들기"
        />
      ) : (
        <div className="card-grid">
          {filteredItems.map((item) => (
            <ItemCard key={item.id} item={item} />
          ))}
        </div>
      )}
    </div>
  );
}
```

---

## 7.2 src/app/items/page.tsx 교체

[파일 내용: `src/app/items/page.tsx`]

```tsx
import { ItemsClient } from "@/components/ItemsClient";
import { PageShell } from "@/components/PageShell";

export default function ItemsPage() {
  return (
    <PageShell
      title="Items"
      description="localStorage에 저장된 핵심 데이터를 조회하고 검색·필터링하는 화면이다."
    >
      <ItemsClient />
    </PageShell>
  );
}
```

---

# 8. 실습 7 — 생성, 상세, 수정, 삭제 화면 연결

## 8.1 NewItemClient 만들기

[파일 내용: `src/components/NewItemClient.tsx`]

```tsx
"use client";

import { useRouter } from "next/navigation";
import { ItemForm } from "@/components/ItemForm";
import { useItems } from "@/hooks/useItems";
import type { ItemFormValues } from "@/types";

export function NewItemClient() {
  const router = useRouter();
  const { addItem } = useItems();

  function handleSubmit(values: ItemFormValues) {
    const created = addItem(values);
    router.push(`/items/${created.id}`);
  }

  return <ItemForm submitLabel="Item 생성" onSubmit={handleSubmit} />;
}
```

---

## 8.2 src/app/items/new/page.tsx 교체

[파일 내용: `src/app/items/new/page.tsx`]

```tsx
import { NewItemClient } from "@/components/NewItemClient";
import { PageShell } from "@/components/PageShell";

export default function NewItemPage() {
  return (
    <PageShell
      title="New Item"
      description="사용자가 새로운 핵심 데이터를 입력하고 localStorage에 저장하는 화면이다."
    >
      <NewItemClient />
    </PageShell>
  );
}
```

---

## 8.3 ItemDetailClient 만들기

[파일 내용: `src/components/ItemDetailClient.tsx`]

```tsx
"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { EmptyState } from "@/components/EmptyState";
import { StatusBadge } from "@/components/StatusBadge";
import { useItems } from "@/hooks/useItems";

export function ItemDetailClient({ id }: { id: string }) {
  const router = useRouter();
  const { getItem, isReady, removeItem } = useItems();

  if (!isReady) {
    return <p>데이터를 불러오는 중이다.</p>;
  }

  const item = getItem(id);

  if (!item) {
    return (
      <EmptyState
        title="item을 찾을 수 없다"
        description="삭제되었거나 존재하지 않는 item이다."
        actionHref="/items"
        actionLabel="목록으로 돌아가기"
      />
    );
  }

  function handleDelete() {
    const confirmed = window.confirm("정말 이 item을 삭제할 것인가?");

    if (!confirmed) {
      return;
    }

    removeItem(id);
    router.push("/items");
  }

  return (
    <article className="card detail-card">
      <div className="card-header-row">
        <h2>{item.title}</h2>
        <StatusBadge status={item.status} />
      </div>
      <p>{item.description}</p>

      <dl className="meta-list">
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

      <div className="button-row">
        <Link className="secondary-button" href="/items">
          목록으로
        </Link>
        <Link className="primary-button" href={`/items/${item.id}/edit`}>
          수정하기
        </Link>
        <button className="danger-button" type="button" onClick={handleDelete}>
          삭제하기
        </button>
      </div>
    </article>
  );
}
```

---

## 8.4 src/app/items/[id]/page.tsx 교체

[파일 내용: `src/app/items/[id]/page.tsx`]

```tsx
import { ItemDetailClient } from "@/components/ItemDetailClient";
import { PageShell } from "@/components/PageShell";

export default async function ItemDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  return (
    <PageShell
      title="Item Detail"
      description="선택한 item의 상세 정보를 확인하고 수정 또는 삭제할 수 있는 화면이다."
    >
      <ItemDetailClient id={id} />
    </PageShell>
  );
}
```

> [!NOTE]
> 사용 중인 Next.js 버전에 따라 `params` 타입이 다를 수 있다. 오류가 발생하면 아래 대안 코드를 사용한다.

[대안 코드]

```tsx
import { ItemDetailClient } from "@/components/ItemDetailClient";
import { PageShell } from "@/components/PageShell";

export default function ItemDetailPage({ params }: { params: { id: string } }) {
  return (
    <PageShell
      title="Item Detail"
      description="선택한 item의 상세 정보를 확인하고 수정 또는 삭제할 수 있는 화면이다."
    >
      <ItemDetailClient id={params.id} />
    </PageShell>
  );
}
```

---

## 8.5 EditItemClient 만들기

[파일 내용: `src/components/EditItemClient.tsx`]

```tsx
"use client";

import { useRouter } from "next/navigation";
import { EmptyState } from "@/components/EmptyState";
import { ItemForm } from "@/components/ItemForm";
import { useItems } from "@/hooks/useItems";
import type { ItemFormValues } from "@/types";

export function EditItemClient({ id }: { id: string }) {
  const router = useRouter();
  const { editItem, getItem, isReady } = useItems();

  if (!isReady) {
    return <p>데이터를 불러오는 중이다.</p>;
  }

  const item = getItem(id);

  if (!item) {
    return (
      <EmptyState
        title="수정할 item을 찾을 수 없다"
        description="삭제되었거나 존재하지 않는 item이다."
        actionHref="/items"
        actionLabel="목록으로 돌아가기"
      />
    );
  }

  const initialValues: ItemFormValues = {
    title: item.title,
    description: item.description,
    status: item.status,
    ownerName: item.ownerName,
  };

  function handleSubmit(values: ItemFormValues) {
    const updated = editItem(id, values);

    if (updated) {
      router.push(`/items/${updated.id}`);
    }
  }

  return <ItemForm initialValues={initialValues} submitLabel="수정 내용 저장" onSubmit={handleSubmit} />;
}
```

---

## 8.6 src/app/items/[id]/edit/page.tsx 만들기

[파일 내용: `src/app/items/[id]/edit/page.tsx`]

```tsx
import { EditItemClient } from "@/components/EditItemClient";
import { PageShell } from "@/components/PageShell";

export default async function EditItemPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  return (
    <PageShell
      title="Edit Item"
      description="기존 item의 제목, 설명, 작성자, 상태를 수정하는 화면이다."
    >
      <EditItemClient id={id} />
    </PageShell>
  );
}
```

Next.js 버전 문제로 오류가 나면 아래 대안 코드를 사용한다.

[대안 코드]

```tsx
import { EditItemClient } from "@/components/EditItemClient";
import { PageShell } from "@/components/PageShell";

export default function EditItemPage({ params }: { params: { id: string } }) {
  return (
    <PageShell
      title="Edit Item"
      description="기존 item의 제목, 설명, 작성자, 상태를 수정하는 화면이다."
    >
      <EditItemClient id={params.id} />
    </PageShell>
  );
}
```

---

# 9. 실습 8 — CSS 보완

기존 `globals.css`에 아래 내용을 추가한다. 이미 비슷한 클래스가 있다면 중복으로 넣지 않고 필요한 부분만 추가한다.

### Windows PowerShell

[터미널]

```powershell
notepad src\app\globals.css
```

### Mac Terminal

[터미널]

```bash
nano src/app/globals.css
```

[파일 내용: `src/app/globals.css`에 추가]

```css
.content-stack {
  display: grid;
  gap: 1.25rem;
}

.toolbar {
  display: grid;
  gap: 0.75rem;
  padding: 1rem;
  border: 1px solid #dddddd;
  border-radius: 12px;
  background: #ffffff;
}

.toolbar input,
.toolbar select,
.form-card input,
.form-card textarea,
.form-card select {
  width: 100%;
  padding: 0.7rem;
  border: 1px solid #cccccc;
  border-radius: 8px;
  font: inherit;
}

.card-header-row,
.button-row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  align-items: center;
  justify-content: space-between;
}

.meta-list {
  display: grid;
  gap: 0.5rem;
  margin: 1rem 0;
}

.meta-list div {
  display: flex;
  gap: 0.5rem;
}

.meta-list dt {
  font-weight: 700;
}

.state-card {
  padding: 1.5rem;
  border: 1px dashed #aaaaaa;
  border-radius: 12px;
  background: #fafafa;
}

.success-message {
  color: #166534;
  font-weight: 700;
}

.danger-button {
  border: 1px solid #b91c1c;
  border-radius: 8px;
  background: #ffffff;
  color: #b91c1c;
  padding: 0.7rem 1rem;
  cursor: pointer;
}

.danger-button:hover {
  background: #fee2e2;
}
```

---

# 10. 실습 9 — 실행과 기능 확인

## 10.1 개발 서버 실행

[터미널]

```bash
npm run dev
```

브라우저에서 다음 주소를 연다.

```text
http://localhost:3000/items
```

---

## 10.2 목록 화면 확인

다음을 확인한다.

```text
[ ] Items 목록이 열린다.
[ ] mockItems가 카드 형태로 표시된다.
[ ] 검색창이 보인다.
[ ] 상태 필터가 보인다.
[ ] 새 item 만들기 버튼이 보인다.
[ ] 각 카드에 상세 보기와 수정 버튼이 보인다.
```

---

## 10.3 생성 기능 확인

브라우저에서 다음 주소를 연다.

```text
http://localhost:3000/items/new
```

다음을 수행한다.

```text
1. 제목을 비워 두고 저장한다.
2. 오류 메시지가 나오는지 확인한다.
3. 설명을 10자 미만으로 입력한다.
4. 오류 메시지가 나오는지 확인한다.
5. 올바른 제목, 설명, 작성자, 상태를 입력한다.
6. 저장 후 상세 화면으로 이동하는지 확인한다.
```

---

## 10.4 수정 기능 확인

다음을 수행한다.

```text
1. Items 목록에서 수정 버튼을 클릭한다.
2. 제목이나 상태를 변경한다.
3. 저장한다.
4. 상세 화면에서 수정 내용이 반영되었는지 확인한다.
5. 목록으로 돌아가 카드에도 수정 내용이 반영되었는지 확인한다.
```

---

## 10.5 삭제 기능 확인

다음을 수행한다.

```text
1. Item 상세 화면으로 이동한다.
2. 삭제하기 버튼을 클릭한다.
3. 확인 창에서 확인을 누른다.
4. 목록 화면으로 돌아가는지 확인한다.
5. 삭제한 item이 목록에 없는지 확인한다.
```

---

## 10.6 검색과 필터 확인

다음을 수행한다.

```text
1. 검색창에 작성자 이름 일부를 입력한다.
2. 해당 작성자의 item만 보이는지 확인한다.
3. 상태 필터를 draft로 바꾼다.
4. draft 상태의 item만 보이는지 확인한다.
5. 검색어와 필터를 모두 적용했을 때 결과가 올바른지 확인한다.
```

---

## 10.7 새로고침 후 저장 확인

localStorage가 작동하면 새로고침해도 데이터가 유지된다.

```text
1. 새 item을 만든다.
2. 브라우저 새로고침을 한다.
3. 만든 item이 여전히 목록에 있는지 확인한다.
```

---

# 11. 실습 10 — 타입 검사와 빌드 확인

## 11.1 TypeScript 검사

[터미널]

```bash
npx tsc --noEmit
```

오류가 없으면 정상이다.

자주 나오는 오류는 다음과 같다.

| 오류 유형 | 의미 | 해결 |
|---|---|---|
| Cannot find module `@/types` | 경로 alias 문제 | `tsconfig.json`의 paths 확인 |
| Type is not assignable | 타입이 맞지 않음 | `ItemFormValues`, `ServiceItem` 구조 확인 |
| window is not defined | 서버에서 window 사용 | localStorage 코드는 client component나 안전 함수 안에서 사용 |

---

## 11.2 production build 확인

[터미널]

```bash
npm run build
```

정상이라면 build가 완료된다.

> [!NOTE]
> build는 개발 서버보다 엄격하다. 개발 서버에서는 보이지 않던 타입 또는 라우팅 오류가 build에서 발견될 수 있다.

---

# 12. 실습 11 — 상태 관리 메모 작성

5회차에서 구현한 구조를 문서화한다.

[파일 내용: `docs/state-management-notes.md`]

```md
# State Management Notes

## 1. 오늘 구현한 상태

- items: ServiceItem 목록
- query: 검색어
- statusFilter: 상태 필터
- isReady: localStorage 로딩 완료 여부

## 2. 현재 source of truth

현재 source of truth는 브라우저의 localStorage이다.

## 3. localStorage를 사용하는 이유

- 실제 DB를 연결하기 전에도 사용자 흐름을 검증할 수 있다.
- 생성, 조회, 수정, 삭제의 화면 흐름을 먼저 확인할 수 있다.
- 다음 차시에서 DB로 이전할 기준 구조를 만들 수 있다.

## 4. localStorage의 한계

- 브라우저별로 데이터가 다르다.
- 서버에 저장되지 않는다.
- 민감정보 저장에 적합하지 않다.
- 여러 사용자가 함께 쓰는 실제 서비스에는 적합하지 않다.

## 5. 다음 차시에 바꿀 수 있는 부분

- item-repository.ts의 저장소를 localStorage에서 DB 또는 API 호출로 변경한다.
- 로그인 사용자 정보와 item owner를 실제 인증 정보와 연결한다.
- 관리자 권한을 실제 authorization 로직과 연결한다.
```

---

# 13. 실습 12 — 수동 테스트 체크리스트 작성

[파일 내용: `docs/manual-test-checklist.md`]

```md
# Manual Test Checklist

## 1. 기본 실행

- [ ] `npm run dev`가 실행된다.
- [ ] Home 화면이 열린다.
- [ ] Header navigation이 작동한다.

## 2. Items 목록

- [ ] `/items` 화면이 열린다.
- [ ] item 카드가 표시된다.
- [ ] 상세 보기 링크가 작동한다.
- [ ] 수정 링크가 작동한다.

## 3. Item 생성

- [ ] `/items/new` 화면이 열린다.
- [ ] 빈 제목에 대해 오류 메시지가 표시된다.
- [ ] 짧은 설명에 대해 오류 메시지가 표시된다.
- [ ] 올바른 입력값으로 item이 생성된다.
- [ ] 생성 후 상세 화면으로 이동한다.

## 4. Item 수정

- [ ] 수정 화면이 열린다.
- [ ] 기존 값이 form에 채워져 있다.
- [ ] 수정 후 상세 화면으로 이동한다.
- [ ] 수정된 값이 목록에도 반영된다.

## 5. Item 삭제

- [ ] 상세 화면에서 삭제 버튼이 보인다.
- [ ] 삭제 전 확인 창이 뜬다.
- [ ] 삭제 후 목록으로 이동한다.
- [ ] 삭제한 item이 목록에서 사라진다.

## 6. 검색과 필터

- [ ] 검색어 입력 시 목록이 줄어든다.
- [ ] 상태 필터가 작동한다.
- [ ] 검색어와 상태 필터가 동시에 적용된다.
- [ ] 결과가 없을 때 empty state가 표시된다.

## 7. localStorage

- [ ] 새로 만든 item이 새로고침 후에도 남아 있다.
- [ ] 초기 mock data로 되돌리기 버튼이 작동한다.
```

---

# 14. README.md 보완

AI 코딩 도구에 다음을 요청한다.

[AI 코딩 도구]

```text
Update README.md for Session 5.

Add a section titled "Session 5: Interactive MVP".
Include:
- implemented features: create, read, update, delete, search, status filter
- temporary storage: localStorage
- what is not implemented yet: real authentication, database, authorization, deployment
- how to run: npm run dev
- how to check: open /items and use the manual test checklist
```

직접 추가하려면 README.md에 아래 내용을 넣는다.

[파일 내용: `README.md`에 추가]

```md
## Session 5: Interactive MVP

This session turns the static MVP skeleton into an interactive MVP.

Implemented features:

- Item list
- Item detail
- Item creation
- Item editing
- Item deletion
- Search
- Status filter
- Empty state and validation messages

Temporary storage:

- The current version uses browser localStorage.
- This is for learning and MVP flow validation only.
- Real database storage will be handled in a later session.

Not implemented yet:

- Real authentication
- Real authorization
- Real database
- Payment
- Production deployment

How to run:

```bash
npm run dev
```

Manual check:

```text
Open http://localhost:3000/items and follow docs/manual-test-checklist.md.
```
```

---

# 15. 오늘의 품질 게이트

5회차가 끝나기 전에 다음을 확인한다.

## 15.1 기능 게이트

```text
[ ] Items 목록이 localStorage 데이터를 표시한다.
[ ] 새 item을 생성할 수 있다.
[ ] 생성 후 상세 화면으로 이동한다.
[ ] 기존 item을 수정할 수 있다.
[ ] item을 삭제할 수 있다.
[ ] 검색 기능이 작동한다.
[ ] 상태 필터가 작동한다.
[ ] 새로고침 후에도 데이터가 유지된다.
[ ] 초기 mock data로 되돌릴 수 있다.
```

## 15.2 코드 구조 게이트

```text
[ ] src/lib/local-storage.ts가 있다.
[ ] src/lib/item-repository.ts가 있다.
[ ] src/hooks/useItems.ts가 있다.
[ ] src/components/ItemsClient.tsx가 있다.
[ ] src/components/NewItemClient.tsx가 있다.
[ ] src/components/ItemDetailClient.tsx가 있다.
[ ] src/components/EditItemClient.tsx가 있다.
[ ] src/app/items/[id]/edit/page.tsx가 있다.
```

## 15.3 안전 게이트

```text
[ ] 실제 비밀번호를 localStorage에 저장하지 않는다.
[ ] 실제 개인정보를 localStorage에 저장하지 않는다.
[ ] 실제 인증이 구현된 것처럼 설명하지 않는다.
[ ] README에 localStorage의 임시성을 명시했다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Check the current project against the Session 5 web service quality gates:

1. localStorage-based item repository exists.
2. useItems hook exists.
3. Items list supports search and status filter.
4. Item create, detail, edit, and delete flows work.
5. Empty state and validation messages are present.
6. No real authentication or real database is introduced.
7. README documents localStorage as temporary storage.

Return PASS, CONCERNS, or FAIL.
For any concern, give the exact file and fix.
```

---

# 16. GitHub에 커밋하기

## 16.1 현재 변경 사항 확인

[터미널]

```bash
git status
```

아직 Git 저장소가 아니라면 다음을 실행한다.

[터미널]

```bash
git init
```

---

## 16.2 파일 추가와 커밋

[터미널]

```bash
git add .
git commit -m "Add session 5 interactive MVP features"
```

커밋이 성공하면 5회차 작업이 저장된 것이다.

---

# 17. 과제 안내

## 과제 1. 사용자 흐름 메모 작성

`docs/user-flow-session-5.md` 파일을 만들고 아래 양식을 채운다.

[파일 내용: `docs/user-flow-session-5.md`]

```md
# User Flow Review: Session 5

## 1. 가장 중요한 사용자 흐름

예: 사용자가 새 item을 생성하고, 목록에서 확인하고, 상세 화면에서 수정한다.

## 2. 흐름 단계

1.
2.
3.
4.
5.

## 3. 사용자가 헷갈릴 수 있는 부분

- 
- 
- 

## 4. 다음 차시에서 개선하고 싶은 부분

- 
- 
- 
```

---

## 과제 2. 오류 메시지 5개 개선

현재 form 또는 화면에서 사용한 오류 메시지 중 5개를 고르고, 더 친절한 문장으로 바꾼다.

예시:

```text
나쁜 문장:
Invalid input.

좋은 문장:
제목은 반드시 입력해야 한다. 예: 연구실 장비 예약 요청
```

---

## 과제 3. 다음 차시 질문 3개 작성

6회차에서는 실제 인증, 권한, 데이터 저장을 다룬다. 수업 전 다음 질문에 답한다.

```text
1. 이 서비스에서 로그인이 꼭 필요한가?
2. 일반 사용자와 관리자는 어떤 권한이 달라야 하는가?
3. 데이터베이스에 반드시 저장해야 할 정보는 무엇인가?
```

---

# 18. 자주 생기는 문제와 해결법

## 18.1 `window is not defined` 오류

원인:

```text
localStorage는 브라우저에서만 사용할 수 있다.
서버 컴포넌트에서 직접 window.localStorage를 사용하면 오류가 난다.
```

해결:

```text
1. localStorage 코드는 src/lib/local-storage.ts의 안전 함수 안에서 사용한다.
2. 상태를 사용하는 컴포넌트 맨 위에 "use client"를 쓴다.
3. page.tsx에서는 client component를 불러와 사용한다.
```

---

## 18.2 생성한 item이 새로고침하면 사라진다

가능한 원인:

```text
createItem 함수에서 saveItems를 호출하지 않았다.
useItems에서 refresh를 호출하지 않았다.
localStorage key가 파일마다 다르다.
```

해결:

```text
src/lib/item-repository.ts에서 STORAGE_KEY가 하나로 고정되어 있는지 확인한다.
createItem, updateItem, deleteItem이 모두 saveItems를 호출하는지 확인한다.
```

---

## 18.3 수정 화면에서 기존 값이 보이지 않는다

가능한 원인:

```text
EditItemClient에서 getItem(id)를 호출하지 않았다.
useItems의 isReady가 false일 때 item을 바로 찾으려고 했다.
URL의 id와 저장된 item.id가 다르다.
```

해결:

```text
1. isReady가 true가 된 뒤 item을 찾는다.
2. 목록 화면에서 수정 링크가 /items/{item.id}/edit 형식인지 확인한다.
3. localStorage 초기화 후 다시 확인한다.
```

---

## 18.4 검색이 작동하지 않는다

가능한 원인:

```text
SearchFilterBar에서 onQueryChange를 호출하지 않았다.
useItems의 filteredItems가 query를 사용하지 않는다.
ItemsClient가 items가 아니라 filteredItems를 렌더링하지 않았다.
```

해결:

```text
ItemsClient에서 filteredItems.map(...)을 사용하고 있는지 확인한다.
```

---

## 18.5 Next.js params 타입 오류

오류 예시:

```text
Type '{ id: string; }' is missing the following properties from type 'Promise<...>'
```

또는 반대 유형의 오류가 발생할 수 있다.

해결:

```text
사용 중인 Next.js 버전에 따라 params 타입이 다를 수 있다.
이 매뉴얼의 page.tsx 대안 코드 중 하나를 사용한다.
```

---

# 19. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> 상태 관리는 사용자의 입력, 저장, 수정, 삭제가 화면과 데이터에 일관되게 반영되도록 만드는 웹서비스의 핵심 구조이다.

5회차의 흐름은 다음과 같다.

```text
4회차 MVP 골격 확인
→ 타입과 validation 보완
→ localStorage 저장소 생성
→ useItems 상태 관리 hook 생성
→ 생성·조회·수정·삭제 구현
→ 검색과 필터 구현
→ 수동 테스트
→ README와 문서 보완
```

6회차에서는 오늘 만든 `item-repository.ts` 구조를 기준으로, 실제 인증·권한·데이터 저장의 기초를 다룬다.

---

# 부록 A. 오늘 사용하는 핵심 명령 모음

## 터미널 명령

```bash
pwd
npm run dev
npx tsc --noEmit
npm run build
git status
git add .
git commit -m "Add session 5 interactive MVP features"
```

## AI 코딩 도구 명령

```text
/clear
Check the current project against the Session 5 web service quality gates.
```

---

# 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| state | 화면이 기억하고 있는 현재 값 |
| 상태 관리 | state를 만들고 변경하고 화면에 반영하는 과정 |
| localStorage | 브라우저 안에 임시 데이터를 저장하는 기능 |
| CRUD | 생성, 조회, 수정, 삭제 |
| validation | 입력값이 올바른지 확인하는 절차 |
| hook | React에서 상태와 기능을 묶어 재사용하는 함수 |
| empty state | 표시할 데이터가 없을 때의 화면 상태 |
| source of truth | 여러 값이 충돌할 때 기준이 되는 데이터 |
| manual test | 사람이 직접 화면을 조작하며 기능을 확인하는 테스트 |
