# 최댓값구하기 정확성 lean4 증명코드이해하기
`myMax_is_ge` 증명 해설

> **정리**: 리스트 L의 어떤 원소 x에 대해서도 `myMax L ≥ x`이다.
> **증명 방법**: 리스트 L에 대한 구조적 귀납법

---

## 전체 코드

```lean4
theorem myMax_is_ge (L : List Nat) (x : Nat) (h : x ∈ L) : myMax L ≥ x := by
  induction L with
  | nil =>
    simp at h
  | cons a rest ih =>
    cases rest with
    | nil =>
      show a ≥ x
      rw [List.mem_singleton] at h
      exact le_of_eq h
    | cons b bs =>
      simp only [myMax]
      split
      · rename_i hge
        rw [List.mem_cons] at h
        cases h with
        | inl h_eq =>
          rw [h_eq]
        | inr h_in =>
          exact Nat.le_trans (ih h_in) hge
      · rename_i hlt
        rw [List.mem_cons] at h
        cases h with
        | inl h_eq =>
          rw [h_eq]
          exact Nat.le_of_lt (Nat.lt_of_not_le hlt)
        | inr h_in =>
          exact ih h_in
```

---

## 줄별 해설

---

### 서명(Signature)

```lean4
theorem myMax_is_ge (L : List Nat) (x : Nat) (h : x ∈ L) : myMax L ≥ x := by
```

| 항목 | 의미 |
|------|------|
| `(L : List Nat)` | 자연수 리스트 L을 인자로 받는다 |
| `(x : Nat)` | 찾을 원소 x를 인자로 받는다 |
| `(h : x ∈ L)` | "x가 L에 속한다"는 사실을 가정으로 받는다 |
| `: myMax L ≥ x` | 증명할 목표: myMax L은 x보다 크거나 같다 |
| `:= by` | 전술(tactic) 모드로 증명을 시작한다 |

**InfoView (시작)**
```
L : List Nat
x : Nat
h : x ∈ L
⊢ myMax L ≥ x
```

---

### 귀납법 시작

```lean4
  induction L with
```

> L의 구조에 대한 귀납법을 시작한다.
> List Nat은 두 가지 경우만 존재한다: 빈 리스트 `[]`와 원소가 하나 이상인 리스트 `a :: rest`.
> 이 명령 하나로 목표가 두 개의 분기로 나뉜다.

---

## 분기 1: `| nil =>`

```lean4
  | nil =>
```

> L = `[]` (빈 리스트)인 경우.

**InfoView**
```
x : Nat
h : x ∈ []
⊢ myMax [] ≥ x
```

---

```lean4
    simp at h
```

> **왜 이 전술인가?**
> 가정 `h : x ∈ []`는 거짓이다. 빈 리스트에는 어떤 원소도 속하지 않기 때문이다.
> `simp`는 `List.mem_nil_iff`를 알고 있어서 `x ∈ [] ↔ False`를 자동으로 적용한다.
> 가정이 `False`가 되는 순간, 모순에서 어떤 것이든 증명할 수 있으므로 목표가 자동으로 닫힌다.

**InfoView (simp at h 후)**
```
No goals  ← 목표가 사라짐 (모순으로 닫힘)
```

---

## 분기 2: `| cons a rest ih =>`

```lean4
  | cons a rest ih =>
```

> L = `a :: rest` (원소가 하나 이상)인 경우.
> - `a` : 리스트의 첫 번째 원소
> - `rest` : 나머지 리스트
> - `ih` : 귀납 가설 (ih : x ∈ rest → myMax rest ≥ x)

**InfoView**
```
a : Nat
rest : List Nat
ih : x ∈ rest → myMax rest ≥ x
h : x ∈ a :: rest
⊢ myMax (a :: rest) ≥ x
```

---

```lean4
    cases rest with
```

> `rest`의 구조를 다시 두 경우로 나눈다.
> - `rest = []` 이면 L = `[a]` (원소 하나짜리 리스트)
> - `rest = b :: bs` 이면 L = `a :: b :: bs` (원소 두 개 이상)
>
> **왜 한 번 더 나누는가?**
> `myMax`의 정의가 세 패턴으로 나뉘기 때문이다.
> `[]`, `[a]`, `a :: rest` — 이 세 경우에 맞추어야 한다.

---

### 분기 2-1: `| nil =>`

```lean4
    | nil =>
```

> rest = `[]` 이므로 L = `[a]` (원소 하나).

**InfoView**
```
a : Nat
ih : x ∈ [] → myMax [] ≥ x
h : x ∈ [a]
⊢ myMax [a] ≥ x
```

---

```lean4
      show a ≥ x
```

> `myMax [a] = a`는 정의에 의해 자명하다.
> `show`는 목표를 동치인 다른 형태로 바꾼다.
> `myMax [a] ≥ x`를 명시적으로 `a ≥ x`로 전개한다.

**InfoView (show 후)**
```
h : x ∈ [a]
⊢ a ≥ x
```

---

```lean4
      rw [List.mem_singleton] at h
```

> **`List.mem_singleton`**: `x ∈ [a] ↔ x = a`
> 즉 "x가 [a]에 속한다"는 것은 "x = a"와 동치이다.
> `rw [...] at h`는 가정 h를 변환한다.
> h가 `x ∈ [a]`에서 `x = a`로 바뀐다.

**InfoView (rw 후)**
```
a : Nat
h : x = a
⊢ a ≥ x
```

---

```lean4
      exact le_of_eq h
```

> **`le_of_eq`**: `a = b → a ≤ b`
> `h : x = a` 이므로 `le_of_eq h : x ≤ a`, 즉 `a ≥ x`이다.
> 이것이 목표와 정확히 일치하므로 `exact`로 닫는다.

**InfoView (exact 후)**
```
No goals  ← 닫힘
```

---

### 분기 2-2: `| cons b bs =>`

```lean4
    | cons b bs =>
```

> rest = `b :: bs` 이므로 L = `a :: b :: bs` (원소 두 개 이상).

**InfoView**
```
a b : Nat
bs : List Nat
ih : x ∈ b :: bs → myMax (b :: bs) ≥ x
h : x ∈ a :: b :: bs
⊢ myMax (a :: b :: bs) ≥ x
```

---

```lean4
      simp only [myMax]
```

> `myMax`의 정의를 전개한다.
> `myMax (a :: b :: bs)`는 정의에 의해
> `if a ≥ myMax (b :: bs) then a else myMax (b :: bs)`로 펼쳐진다.

**InfoView (simp only [myMax] 후)**
```
⊢ (if a ≥ myMax (b :: bs) then a else myMax (b :: bs)) ≥ x
```

---

```lean4
      split
```

> `if-then-else` 목표를 두 분기로 나눈다.
> - 분기 `·` : 조건이 참인 경우 (`a ≥ myMax (b :: bs)`)
> - 분기 `·` : 조건이 거짓인 경우 (`¬ a ≥ myMax (b :: bs)`)

---

#### if 분기 1: 조건이 참 (`a ≥ myMax (b :: bs)`)

```lean4
      · rename_i hge
```

> `split` 이후 조건이 자동으로 이름 없이 도입된다.
> `rename_i hge`로 그 조건에 `hge`라는 이름을 붙인다.
> `hge : a ≥ myMax (b :: bs)`

**InfoView**
```
hge : a ≥ myMax (b :: bs)
h : x ∈ a :: b :: bs
⊢ a ≥ x
```

---

```lean4
        rw [List.mem_cons] at h
```

> **`List.mem_cons`**: `x ∈ a :: rest ↔ x = a ∨ x ∈ rest`
> h를 두 가능성으로 분해한다.

**InfoView (rw 후)**
```
h : x = a ∨ x ∈ b :: bs
⊢ a ≥ x
```

---

```lean4
        cases h with
        | inl h_eq =>
```

> `h`가 `x = a ∨ x ∈ b :: bs`이므로 두 경우로 나눈다.
> `inl`: 왼쪽이 참인 경우, 즉 `h_eq : x = a`

**InfoView (inl 분기)**
```
h_eq : x = a
⊢ a ≥ x
```

---

```lean4
          rw [h_eq]
```

> `h_eq : x = a`를 목표에 대입한다.
> 목표가 `a ≥ x`에서 `a ≥ a`로 바뀐다.
> `a ≥ a`는 `le_refl`에 의해 성립하므로 Lean이 자동으로 닫는다.

**InfoView (rw 후)**
```
No goals  ← a ≥ a는 자동 닫힘
```

---

```lean4
        | inr h_in =>
          exact Nat.le_trans (ih h_in) hge
```

> `inr`: 오른쪽이 참인 경우, 즉 `h_in : x ∈ b :: bs`

**InfoView (inr 분기)**
```
h_in : x ∈ b :: bs
hge  : a ≥ myMax (b :: bs)
⊢ a ≥ x
```

> - `ih h_in : myMax (b :: bs) ≥ x`  ← 귀납 가설 적용
> - `hge     : a ≥ myMax (b :: bs)`
> - `Nat.le_trans` : `x ≤ y → y ≤ z → x ≤ z` (추이성)
> - 따라서 `Nat.le_trans (ih h_in) hge : a ≥ x`

```
x ≤ myMax (b::bs) ≤ a
      ↑ ih h_in        ↑ hge
→ x ≤ a  (le_trans)
```

---

#### if 분기 2: 조건이 거짓 (`¬ a ≥ myMax (b :: bs)`)

```lean4
      · rename_i hlt
```

> 조건이 거짓인 분기. `hlt : ¬ a ≥ myMax (b :: bs)`

**InfoView**
```
hlt : ¬ a ≥ myMax (b :: bs)
h   : x ∈ a :: b :: bs
⊢ myMax (b :: bs) ≥ x
```

> 이 분기에서 `if-then-else`의 결과는 `myMax (b :: bs)`이다.
> 따라서 목표가 `myMax (b :: bs) ≥ x`로 바뀐다.

---

```lean4
        rw [List.mem_cons] at h
        cases h with
        | inl h_eq =>
          rw [h_eq]
          exact Nat.le_of_lt (Nat.lt_of_not_le hlt)
```

> `inl` 분기: `h_eq : x = a`
> 목표는 `myMax (b :: bs) ≥ a`

> - `hlt : ¬ a ≥ myMax (b :: bs)`, 즉 `myMax (b :: bs) > a`
> - `Nat.lt_of_not_le hlt : a < myMax (b :: bs)`
> - `Nat.le_of_lt : a < b → a ≤ b`
> - 따라서 `Nat.le_of_lt (Nat.lt_of_not_le hlt) : a ≤ myMax (b :: bs)`
>   즉 `myMax (b :: bs) ≥ a`

---

```lean4
        | inr h_in =>
          exact ih h_in
```

> `inr` 분기: `h_in : x ∈ b :: bs`
> 귀납 가설 `ih h_in : myMax (b :: bs) ≥ x`를 그대로 사용한다.

**InfoView (exact 후)**
```
No goals  ← 닫힘
```

---

## 증명 구조 요약

```
myMax_is_ge
│
├── nil          → 모순 (x ∈ [] 는 False)
│
└── cons a rest
    │
    ├── rest = nil       → [a] 경우
    │   x ∈ [a] → x = a → a ≥ a ✓
    │
    └── rest = b :: bs   → a :: b :: bs 경우
        │
        ├── if True  (a ≥ myMax rest)
        │   ├── x = a  → a ≥ a ✓
        │   └── x ∈ rest → le_trans (ih) (hge) ✓
        │
        └── if False (a < myMax rest)
            ├── x = a  → le_of_lt (lt_of_not_le) ✓
            └── x ∈ rest → ih h_in ✓
```

---

## 핵심 전술 정리

| 전술 | 역할 |
|------|------|
| `induction L with` | 리스트 구조 귀납법 시작 |
| `cases rest with` | 나머지 리스트를 재분기 |
| `simp at h` | 거짓인 가정을 자동으로 닫음 |
| `show a ≥ x` | 목표를 동치 형태로 명시 |
| `rw [List.mem_singleton] at h` | `x ∈ [a]`를 `x = a`로 변환 |
| `rw [List.mem_cons] at h` | `x ∈ a::rest`를 `x=a ∨ x∈rest`로 변환 |
| `simp only [myMax]` | myMax 정의 전개 |
| `split` | if-then-else 목표를 두 분기로 분리 |
| `rename_i hge` | 자동 도입된 가정에 이름 부여 |
| `exact Nat.le_trans` | 추이성으로 부등식 연결 |
| `Nat.lt_of_not_le` | ¬ a ≥ b를 a < b로 변환 |
| `Nat.le_of_lt` | a < b를 a ≤ b로 변환 |
