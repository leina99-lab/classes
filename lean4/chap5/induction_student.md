# 수학적 귀납법 (Mathematical Induction)


Rosen 이산수학 8판 §5.1 + Lean 4

> **증명 원칙**: `simp`, `linarith`, `norm_num`을 사용하지 않는다.
> 공리와 보조정리를 `rw`(rewrite)로 직접 호출하여 대수 구조를 한 단계씩 전개한다.

---

## 1. 수학적 귀납법이란

### 직관적 이해 — 도미노

도미노를 일렬로 세워두었다고 생각하자.

```
[1] → [2] → [3] → [4] → [5] → ...
```

두 가지를 확인하면 모든 도미노가 쓰러진다.

- **기저 단계**: 첫 번째 도미노가 쓰러진다.
- **귀납 단계**: k번째가 쓰러지면 (k+1)번째도 쓰러진다.

### 정의

> **수학적 귀납법(Mathematical Induction)**
>
> 명제 P(n)이 모든 양의 정수 n에 대해 성립함을 보이려면:
>
> 1. **기저 단계**(Basis Step): P(1)이 참임을 보인다.
> 2. **귀납 단계**(Inductive Step): P(k)가 참이면 P(k+1)도 참임을 보인다.

귀납 단계에서 "P(k)가 참이다"라는 가정이 **귀납 가설(Induction Hypothesis)**이다.

---

## 2. 수학 증명 예시

### 예시 1. 등차수열의 합

$$1 + 2 + \cdots + n = \frac{n(n+1)}{2}$$

**기저 단계** (n = 1): 좌변 = 1, 우변 = $\dfrac{1 \cdot 2}{2} = 1$ ✓

**귀납 단계**: $1 + 2 + \cdots + k = \dfrac{k(k+1)}{2}$ 가정 하에,

$$1 + 2 + \cdots + k + (k+1) = \frac{k(k+1)}{2} + (k+1) = (k+1)\cdot\frac{k+2}{2} = \frac{(k+1)(k+2)}{2} \checkmark$$

---

### 예시 2. 부등식 — 2ⁿ > n

**기저 단계** (n = 1): $2^1 = 2 > 1$ ✓

**귀납 단계**: $2^k > k$ 가정 하에,

$$2^{k+1} = 2 \cdot 2^k = 2^k + 2^k > k + k \geq k + 1 \checkmark$$

---

### 예시 3. 리스트 삽입 후 길이

**명제**: `(myInsert x l).length = l.length + 1`

**기저 단계** (l = []): `myInsert x [] = [x]`, 길이 = 1 = 0 + 1 ✓

**귀납 단계** (l = h :: t):
- 귀납 가설: `(myInsert x t).length = t.length + 1`
- x ≤ h이면 맨 앞에 삽입 → 길이 = (h::t).length + 1 ✓
- x > h이면 t에 재귀 삽입 → 귀납 가설 적용 ✓

---

## 3. Lean 4 — rw 전술 원칙

`rw [lemma]`는 현재 목표에서 lemma의 좌변을 우변으로 교체한다.

```
rw [A = B]    →  목표에서 A를 B로 교체 (정방향)
rw [← A = B]  →  목표에서 B를 A로 교체 (역방향)
rw [lemma] at h  →  가정 h에서 교체
```

### 자주 쓰는 Nat 공리

| 공리 이름 | 내용 |
|----------|------|
| `Nat.mul_zero` | `n * 0 = 0` |
| `Nat.zero_mul` | `0 * n = 0` |
| `Nat.mul_add`  | `n * (a + b) = n * a + n * b` |
| `Nat.add_mul`  | `(a + b) * n = a * n + b * n` |
| `Nat.mul_comm` | `a * b = b * a` |
| `Nat.add_comm` | `a + b = b + a` |
| `Nat.add_assoc`| `a + (b + c) = (a + b) + c` |
| `Nat.add_zero` | `n + 0 = n` |
| `Nat.zero_add` | `0 + n = n` |
| `Nat.pow_zero` | `a ^ 0 = 1` |
| `Nat.pow_succ` | `a ^ (n+1) = a ^ n * a` |
| `Nat.two_mul`  | `2 * n = n + n` |

### 자주 쓰는 List 공리

| 공리 이름 | 내용 |
|----------|------|
| `List.length_nil`       | `[].length = 0` |
| `List.length_cons`      | `(a :: l).length = l.length + 1` |
| `List.length_singleton` | `[a].length = 1` |
| `if_pos`  | `c → (if c then a else b) = a` |
| `if_neg`  | `¬c → (if c then a else b) = b` |

---

## 4. 예시 1 — Lean 4 rw 증명: 합 공식

```lean4
import Mathlib

def sumTo : Nat → Nat
  | 0     => 0
  | n + 1 => (n + 1) + sumTo n

-- 패턴 매칭 정의로부터 등식 추출 (rfl: 양변이 정의상 같음)
theorem sumTo_zero : sumTo 0 = 0 := rfl
theorem sumTo_succ (n : Nat) : sumTo (n + 1) = (n + 1) + sumTo n := rfl

theorem sumTo_formula (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  induction n with
  | zero =>
    -- 목표: 2 * sumTo 0 = 0 * (0 + 1)
    rw [sumTo_zero]
    -- 목표: 2 * 0 = 0 * (0 + 1)
    rw [Nat.mul_zero]
    -- 목표: 0 = 0 * (0 + 1)
    rw [Nat.zero_mul]
    -- 목표: 0 = 0
  | succ n ih =>
    -- ih  : 2 * sumTo n = n * (n + 1)
    -- 목표: 2 * sumTo (n + 1) = (n + 1) * (n + 1 + 1)
    rw [sumTo_succ]
    -- 목표: 2 * ((n + 1) + sumTo n) = (n + 1) * (n + 2)
    rw [Nat.mul_add]
    -- 목표: 2 * (n + 1) + 2 * sumTo n = (n + 1) * (n + 2)
    rw [ih]
    -- 목표: 2 * (n + 1) + n * (n + 1) = (n + 1) * (n + 2)
    rw [← Nat.add_mul]
    -- 목표: (2 + n) * (n + 1) = (n + 1) * (n + 2)
    rw [Nat.add_comm 2 n]
    -- 목표: (n + 2) * (n + 1) = (n + 1) * (n + 2)
    rw [Nat.mul_comm]
    -- 목표: (n + 1) * (n + 2) = (n + 1) * (n + 2)  →  rfl
```

**InfoView 단계별 추적 (succ 분기):**

| rw 호출 | 사용 공리 | 변환 결과 |
|---------|----------|----------|
| `rw [sumTo_succ]` | 정의 전개 | `2 * ((n+1) + sumTo n) = ...` |
| `rw [Nat.mul_add]` | 분배법칙 | `2*(n+1) + 2*sumTo n = ...` |
| `rw [ih]` | 귀납 가설 대입 | `2*(n+1) + n*(n+1) = ...` |
| `rw [← Nat.add_mul]` | 분배법칙 역방향 | `(2+n)*(n+1) = ...` |
| `rw [Nat.add_comm 2 n]` | 교환법칙 | `(n+2)*(n+1) = ...` |
| `rw [Nat.mul_comm]` | 교환법칙 | 양변 일치 |

---

## 5. 예시 2 — Lean 4 rw 증명: 2ⁿ > n

```lean4
import Mathlib

theorem two_pow_gt (n : Nat) : n < 2 ^ n := by
  induction n with
  | zero =>
    -- 목표: 0 < 2 ^ 0
    rw [Nat.pow_zero]
    -- 목표: 0 < 1
    exact Nat.one_pos
  | succ n ih =>
    -- ih  : n < 2 ^ n
    -- 목표: n + 1 < 2 ^ (n + 1)
    rw [Nat.pow_succ]
    -- 목표: n + 1 < 2 ^ n * 2
    rw [Nat.mul_comm]
    -- 목표: n + 1 < 2 * 2 ^ n
    rw [Nat.two_mul]
    -- 목표: n + 1 < 2 ^ n + 2 ^ n
    apply Nat.lt_of_lt_of_le
    · -- 첫 번째 목표: n + 1 ≤ 2 ^ n
      -- ih : n < 2^n  →  n + 1 ≤ 2^n
      exact Nat.succ_le_of_lt ih
    · -- 두 번째 목표: 2 ^ n ≤ 2 ^ n + 2 ^ n
      rw [← Nat.add_zero (2 ^ n)]
      -- 목표: 2^n + 0 ≤ 2^n + 2^n
      apply Nat.add_le_add_left
      -- 목표: 0 ≤ 2^n
      exact Nat.zero_le _
```

**각 `rw` 단계 설명:**

| rw 호출 | 사용 공리 | 변환 |
|---------|----------|------|
| `rw [Nat.pow_zero]` | `a^0 = 1` | `2^0 → 1` |
| `rw [Nat.pow_succ]` | `a^(n+1) = a^n * a` | `2^(n+1) → 2^n * 2` |
| `rw [Nat.mul_comm]` | `a*b = b*a` | `2^n * 2 → 2 * 2^n` |
| `rw [Nat.two_mul]`  | `2*n = n+n` | `2 * 2^n → 2^n + 2^n` |
| `rw [← Nat.add_zero (2^n)]` | `n+0=n` 역방향 | `2^n → 2^n + 0` |

---

## 6. 예시 3 — Lean 4 rw 증명: insert_length

```lean4
import Mathlib

def myInsert (x : Nat) : List Nat → List Nat
  | []     => [x]
  | h :: t => if x ≤ h then x :: h :: t
              else h :: myInsert x t

-- 패턴 매칭 정의로부터 등식 추출
theorem myInsert_nil (x : Nat) :
    myInsert x [] = [x] := rfl

theorem myInsert_cons_le (x h : Nat) (t : List Nat) (hle : x ≤ h) :
    myInsert x (h :: t) = x :: h :: t := by
  unfold myInsert
  rw [if_pos hle]

theorem myInsert_cons_gt (x h : Nat) (t : List Nat) (hgt : ¬ x ≤ h) :
    myInsert x (h :: t) = h :: myInsert x t := by
  unfold myInsert
  rw [if_neg hgt]

-- 본 정리
theorem insert_length (x : Nat) (l : List Nat)
    : (myInsert x l).length = l.length + 1 := by
  induction l with
  | nil =>
    -- 목표: (myInsert x []).length = [].length + 1
    rw [myInsert_nil]
    -- 목표: [x].length = [].length + 1
    rw [List.length_singleton]
    -- 목표: 1 = [].length + 1
    rw [List.length_nil]
    -- 목표: 1 = 0 + 1
    rw [Nat.zero_add]
    -- 목표: 1 = 1  →  rfl
  | cons h t ih =>
    -- ih  : (myInsert x t).length = t.length + 1
    -- 목표: (myInsert x (h :: t)).length = (h :: t).length + 1
    by_cases hle : x ≤ h
    · -- 경우 1: x ≤ h  →  맨 앞에 삽입
      rw [myInsert_cons_le x h t hle]
      -- 목표: (x :: h :: t).length = (h :: t).length + 1
      rw [List.length_cons]
      -- 목표: (h :: t).length + 1 = (h :: t).length + 1  →  rfl
    · -- 경우 2: x > h  →  t에 재귀 삽입
      rw [myInsert_cons_gt x h t hle]
      -- 목표: (h :: myInsert x t).length = (h :: t).length + 1
      rw [List.length_cons, List.length_cons]
      -- 목표: (myInsert x t).length + 1 = t.length + 1 + 1
      rw [ih]
      -- 목표: t.length + 1 + 1 = t.length + 1 + 1  →  rfl
```

**InfoView 단계별 추적 (cons, x > h 경우):**

| rw 호출 | 사용 공리 | 변환 결과 |
|---------|----------|----------|
| `rw [myInsert_cons_gt]` | 정의 전개 | `(h :: myInsert x t).length = ...` |
| `rw [List.length_cons, List.length_cons]` | 길이 공리 두 번 | `(myInsert x t).length + 1 = t.length + 1 + 1` |
| `rw [ih]` | 귀납 가설 대입 | 양변 일치 |

---

## 7. rw 방향 선택 기준

```lean4
-- 정방향: A → B
rw [Nat.add_mul]    -- (a+b)*c = a*c + b*c  →  좌변에서 우변으로

-- 역방향: B → A  (← 기호)
rw [← Nat.add_mul]  -- a*c + b*c를 발견해서 (a+b)*c로 묶음
```

**규칙**: 목표를 단순하게 만드는 방향을 선택한다. 인수를 묶어야 할 때는 역방향(←)을 쓴다.

---

## 8. 핵심 전술 요약

| 전술 | 역할 |
|------|------|
| `rw [lemma]` | 공리로 목표 한 단계 변환 |
| `rw [← lemma]` | 역방향 변환 (인수 묶기 등) |
| `rw [lemma] at ih` | 귀납 가설 ih를 변환 |
| `induction n with` | 귀납법 시작 |
| `\| zero =>` | 기저 단계 (n = 0) |
| `\| succ n ih =>` | 귀납 단계, ih가 귀납 가설 |
| `by_cases h : P` | 경우 분기 (if문 처리 시) |
| `exact` | 목표와 정확히 일치하는 증명 제시 |
| `apply` | 정리의 결론이 목표와 일치할 때 |
