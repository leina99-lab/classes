# Rosen Chapter 2 -- 기본구조: 집합, 함수, 수열의 합, 행렬

## 블록 1: 2.1 집합 + 2.2 집합의 연산

> 수학적 개념을 먼저 이해하고, Lean 4로 그것을 정확히 구현하는 흐름으로 구성되었다.

---

# 2.1 집합 (Sets)

---

## 2.1.1 집합의 정의

### 정의 1: 집합(Set)

집합이란 **순서를 고려하지 않은, 서로 다른 개체들의 모임**이다.

두 가지 핵심 성질:

- **순서 없음**: {1, 2, 3}과 {3, 1, 2}는 같은 집합이다.
- **중복 없음**: {1, 1, 3, 5}와 {1, 3, 5}는 같은 집합이다.

### 집합 서술 방법

| 방법 | 설명 | 예시 |
|------|------|------|
| **원소나열법**(Roster) | 원소를 직접 나열 | {a, e, i, o, u} |
| **조건제시법**(Set-builder) | 조건을 서술 | {x \| x는 양의 홀수, x < 10} |

### 예제 1~4

- **예제 1**: 영어 모음의 집합 V = {a, e, i, o, u}
- **예제 2**: 10 미만 양의 홀수 = {1, 3, 5, 7, 9}
- **예제 3**: 서로 다른 종류의 원소도 가능: {1, red, True}
- **예제 4**: 조건제시법 -- {x | x는 양의 정수, x < 100}

---

## 주요 수 집합 + 예제 5~6

| 기호 | 이름 | 원소 |
|------|------|------|
| **N** | 자연수(Natural) | {0, 1, 2, 3, ...} (이 교재에서 0 포함) |
| **Z** | 정수(Integer) | {..., -2, -1, 0, 1, 2, ...} |
| **Q** | 유리수(Rational) | p/q (p, q는 정수, q != 0) |
| **R** | 실수(Real) | 수직선 위의 모든 수 |

**예제 5**: {N, Z, Q, R}은 원소가 4개인 집합이다. 집합 자체가 원소가 될 수 있다.

**예제 6 (집합의 같음)**: {1, 3, 5} = {3, 5, 1} = {1, 1, 3, 3, 5, 5, 5}

### 정의 2: 집합의 상등(Equality)

두 집합 A, B가 같다(A = B) ⇔ 모든 원소가 동일하다.

> 수식으로: A = B ⇔ (∀x)(x ∈ A ↔ x ∈ B)

---

## [Lean 4] 집합 기초

Lean 4에서 **집합은 술어**(predicate)이다. `Set Nat`은 `Nat → Prop`과 같다. 즉, "자연수 하나를 받아서 참/거짓을 반환하는 함수"가 곧 집합이다.

유한 집합은 `Finset`으로 다루며, `decide`가 같음을 자동 확인한다.

```lean
-- Lean 4에서 Set = 술어(predicate)
-- Set Nat = Nat -> Prop

-- 예제 1: 원소 나열 (Finset 사용)
#eval ({1, 3, 5, 7, 9} : Finset Nat)  -- {1, 3, 5, 7, 9}

-- 예제 6: 집합의 같음 (순서/중복 무관)
example : ({1, 3, 5} : Finset Nat) = {3, 5, 1} := by decide
example : ({1, 1, 3, 5} : Finset Nat) = {1, 3, 5} := by decide

-- 조건제시법 (Set 사용)
def Odd_lt10 : Set Nat := {x | x % 2 = 1 ∧ x < 10}
```

### 수학 ↔ Lean 대응표

| 수학 개념 | Lean 4 표현 | 설명 |
|-----------|-------------|------|
| {1, 3, 5} | `({1, 3, 5} : Finset Nat)` | 유한 집합은 `Finset` |
| {x \| P(x)} | `{x : Nat \| P x}` | 조건제시법은 `Set` |
| a ∈ A | `a ∈ A` | 원소 판정 |
| A = B (유한) | `by decide` | 자동 결정 |

### 빈칸 채우기

```lean
-- 짝수 집합을 정의하고, 4가 원소인지 확인하라.
def MyEven : Set Nat := {x | x % 2 = 0}
example : 4 ∈ MyEven := by
  ______
```

<details>
<summary>정답 보기</summary>

```lean
example : 4 ∈ MyEven := by
  simp [MyEven]
```

`simp [MyEven]`은 `MyEven`의 정의를 펼친 뒤 `4 % 2 = 0`을 자동으로 확인한다.

</details>

---

## 2.1.2~3 벤 다이어그램, 부분집합

### 정의 3: 부분집합(Subset)

A의 **모든 원소**가 B에도 있으면, A는 B의 부분집합이다.

> A ⊆ B ⇔ (∀x)(x ∈ A → x ∈ B)

**증명 패턴**: "임의의 x를 잡고, x ∈ A이면 x ∈ B임을 보인다." 이 패턴은 이산수학 전체에서 반복된다.

### 예제 7: 벤 다이어그램

전체집합 U를 사각형, 집합 V를 원으로 표시. 원 안에 a, e, i, o, u 점 표시.

### 예제 8~9

- **예제 8**: 양의 홀수 ⊆ 양의 정수 ⊆ 정수 ⊆ 유리수 ⊆ 실수
- **예제 9**: 반례를 이용한 부분집합 부정

---

## 정리 1: 공집합과 자기 자신

**(i)** 공집합은 모든 집합의 부분집합이다: ∅ ⊆ S

> 증명: 공집합에 원소가 없으므로, "x ∈ ∅ → x ∈ S"는 항상 참이다. 이를 **공허한 참**(vacuous truth)이라 한다.

**(ii)** 모든 집합은 자기 자신의 부분집합이다: S ⊆ S

### 진부분집합(Proper Subset)

A ⊂ B ⇔ A ⊆ B 이고 A ≠ B

### 두 집합이 같음을 보이는 표준 방법

> A = B ⇔ (A ⊆ B) ∧ (B ⊆ A)

양방향 부분집합을 각각 보이면 된다.

---

## [Lean 4] 부분집합 증명

부분집합 증명의 Lean 4 패턴:

```
1. intro x hx    -- "임의의 x를 잡고, x ∈ A라 가정"
2. (목표 증명)    -- "x ∈ B임을 보인다"
```

### 수학 ↔ Lean 대응표

| 수학 단계 | Lean 전술 | InfoView 변화 |
|-----------|-----------|--------------|
| "임의의 x를 잡자" | `intro x hx` | 가설에 `x : Nat`, `hx : x ∈ A` 추가 |
| "x ∈ B임을 보인다" | `omega` 또는 다른 전술 | 목표 해결 |

### 예제: 정리 1(i) -- 공집합은 모든 집합의 부분집합

```lean
-- 정리 1(i): 공집합은 모든 집합의 부분집합
example (A : Set Nat) : (∅ : Set Nat) ⊆ A := by
  intro x hx
  -- hx : x ∈ ∅   (공집합에 원소가 있다는 가정)
  contradiction
```

**왜 `absurd`인가?** `hx`는 "x가 공집합의 원소이다"라는 거짓 가정이다. `Set.not_mem_empty x`는 "x는 공집합의 원소가 아니다"라는 정리이다. 둘을 합치면 모순이 되어 무엇이든 증명할 수 있다.

### 예제: {n | n > 5} ⊆ {n | n > 3}

```lean
example : {n : Nat | n > 5} ⊆ {n : Nat | n > 3} := by
  intro x hx
  simp only [Set.mem_setOf_eq] at *    -- hx와 목표 모두 펼침
  omega         -- 5 < x 이면 당연히 3 < x
```

**왜 `omega`인가?** `omega`는 자연수/정수의 선형 부등식을 자동으로 처리한다. `x > 5`이면 `x > 3`임이 자명하다.

### 빈칸 채우기

```lean
-- {n | n > 10} ⊆ {n | n > 5} 를 증명하라.
example : {n : Nat | n > 10} ⊆ {n : Nat | n > 5} := by
  intro x hx
  ______
```

<details>
<summary>정답 보기</summary>

```lean
example : {n : Nat | n > 10} ⊆ {n : Nat | n > 5} := by
  intro x hx
  simp only [Set.mem_setOf_eq] at *    -- hx와 목표 모두 펼침
  omega
```

`hx : x > 10`이 가설에 있고, 목표가 `x > 5`이므로 `omega`가 자동으로 해결한다.

</details>

---

## 2.1.4 집합의 크기 + 예제 10~13

### 정의 4: 유한 집합(Finite Set)

원소가 유한개인 집합.

### 정의 5: 집합의 크기(Cardinality)

유한 집합 S의 원소의 수를 |S|로 표기한다.

- |{1, 3, 5, 7, 9}| = 5
- |∅| = 0

```lean
-- Lean 4: 크기 확인
#eval ({1, 3, 5, 7, 9} : Finset Nat).card   -- 5
#eval (Finset.range 26).card                  -- 26
#eval (∅ : Finset Nat).card                   -- 0
```

---

## 2.1.5 멱집합 (Power Set)

### 정의 6: 멱집합

집합 S의 멱집합 P(S)는 S의 **모든 부분집합**을 원소로 갖는 집합이다.

> 원소 n개 → 멱집합의 크기 = 2^n

### 예제 14~15

- P({0, 1, 2}) = {∅, {0}, {1}, {2}, {0,1}, {0,2}, {1,2}, {0,1,2}}
- |P({0, 1, 2})| = 2^3 = 8

**주의**: P(∅) = {∅}, P({∅}) = {∅, {∅}}

```lean
-- Lean 4: 멱집합
#eval Finset.powerset ({0, 1, 2} : Finset Nat)
-- {{}, {0}, {1}, {2}, {0,1}, {0,2}, {1,2}, {0,1,2}}
#eval (Finset.powerset ({0, 1, 2} : Finset Nat)).card  -- 8
```

### 빈칸 채우기

```lean
-- |P({a, b, c})| = ?
#eval (Finset.powerset ({1, 2, 3} : Finset Nat)).card
-- 기대: ______
```

<details>
<summary>정답 보기</summary>

답: **8** (= 2^3)

</details>

---

## 2.1.6 데카르트 곱 (Cartesian Product)

### 정의 7: 순서쌍(Ordered Pair)

(a, b)에서 **순서가 있다**. (1, 2) ≠ (2, 1).

집합에서는 순서가 없었지만, 순서쌍에서는 순서가 있다.

### 정의 8: 데카르트 곱

A × B = {(a, b) | a ∈ A ∧ b ∈ B}

### 예제 16~20

- {1, 2} × {3, 4, 5} = {(1,3), (1,4), (1,5), (2,3), (2,4), (2,5)}
- |A × B| = |A| × |B|

```lean
-- Lean 4: 데카르트 곱
#eval ({1, 2} : Finset Nat) ×ˢ ({3, 4, 5} : Finset Nat)
-- {(1,3),(1,4),(1,5),(2,3),(2,4),(2,5)}
```

### 빈칸 채우기

```lean
-- {0,1} × {0,1} 의 원소 수는?
#eval (({0,1} : Finset Nat) ×ˢ ({0,1} : Finset Nat)).card
-- 기대: ______
```

<details>
<summary>정답 보기</summary>

답: **4** (= 2 × 2)

</details>

---

## 예제 21~23: 관계, 한정기호, 진리 집합

### 예제 21: 관계(Relation)

A × B의 부분집합을 A에서 B로의 관계라 한다.

### 예제 22: 한정기호와 집합

∀x ∈ R (x² ≥ 0)은 참이다. 모든 실수의 제곱은 0 이상이다.

### 예제 23: 진리 집합(Truth Set)

| 술어 P(x) | 전체집합 | 진리 집합 |
|-----------|---------|-----------|
| \|x\| = 1 | Z | {1, -1} |
| x² = 2 | Z | ∅ (정수 중 x²=2인 것 없음) |

---

## [학생 활동] 2.1 종합 연습 (5분)

**1.** 참/거짓을 판정하라:

| | 명제 | 참/거짓 |
|---|------|---------|
| (a) | 0 ∈ ∅ | ______ |
| (b) | ∅ ∈ {0} | ______ |
| (c) | {0} ⊆ {0} | ______ |
| (d) | ∅ ⊆ {∅} | ______ |
| (e) | {0} ∈ {{0}, {0,1}} | ______ |
| (f) | \|P({a,b})\| = ? | ______ |

**2.** A = {1,2}, B = {a,b,c}일 때 |A × B| = ______

**3.** [Lean 4] 공집합이 모든 집합의 부분집합임을 증명하라:

```lean
example (A : Set Nat) : (∅ : Set Nat) ⊆ A := by
  intro x hx
  ______
```

<details>
<summary>전체 정답 보기</summary>

**1.**
(a) X -- 공집합에 원소 없음
(b) X -- {0}의 원소는 0뿐. ∅ ≠ 0
(c) O -- 자기 자신의 부분집합
(d) O -- 공집합은 모든 집합의 부분집합
(e) O -- {0}은 {{0},{0,1}}의 원소
(f) |P({a,b})| = 2² = **4**

**2.** |A × B| = 2 × 3 = **6**

**3.**
```lean
example (A : Set Nat) : (∅ : Set Nat) ⊆ A := by
  intro x hx
  contradiction
```

</details>

---

---

# 2.2 집합의 연산 (Set Operations)

---

## 정의 1~3: 합집합, 교집합, 서로소

### 정의 1: 합집합(Union)

A ∪ B = {x | x ∈ A ∨ x ∈ B}

> "A에 있거나 B에 있거나 (또는 둘 다)" -- **OR**에 해당

### 정의 2: 교집합(Intersection)

A ∩ B = {x | x ∈ A ∧ x ∈ B}

> "A에도 있고 B에도 있는 것" -- **AND**에 해당

### 정의 3: 서로소(Disjoint)

A ∩ B = ∅이면 A와 B는 서로소이다.

### 포함-배제 원리

> |A ∪ B| = |A| + |B| - |A ∩ B|

### 논리 연산과의 대응

| 집합 연산 | 논리 연산 | 기호 |
|-----------|-----------|------|
| 합집합 A ∪ B | 논리합 p ∨ q | OR |
| 교집합 A ∩ B | 논리곱 p ∧ q | AND |
| 여집합 Aᶜ | 부정 ¬p | NOT |
| 차집합 A \ B | p ∧ ¬q | AND NOT |

이 대응은 1장의 논리적 동치를 집합 버전으로 변환할 때 핵심이 된다.

---

## 예제 1~5

- A = {1,3,5}, B = {1,2,3} → A ∪ B = {1,2,3,5}, A ∩ B = {1,3}
- |A ∪ B| = 3 + 3 - 2 = 4

---

## 정의 4-5: 차집합, 여집합 + 예제 6-9

### 정의 4: 차집합(Difference)

A \ B = {x | x ∈ A ∧ x ∉ B}

> "A에는 있지만 B에는 없는 것"

### 정의 5: 여집합(Complement)

Aᶜ = U \ A = {x ∈ U | x ∉ A}

> 전체집합 U에서 A를 뺀 것

**핵심 관계**: A \ B = A ∩ Bᶜ

---

## [Lean 4] 집합 연산

```lean
-- 합집합
example : ({1,3,5} : Finset Nat) ∪ {1,2,3} = {1,2,3,5} := by decide

-- 교집합
example : ({1,3,5} : Finset Nat) ∩ {1,2,3} = {1,3} := by decide

-- 차집합
example : ({1,3,5} : Finset Nat) \ {1,2,3} = {5} := by decide
```

유한 집합(`Finset`)의 연산은 `decide`로 자동 확인할 수 있다.

### 일반 집합(Set)의 교환법칙 증명

```lean
-- 합집합의 교환법칙
example (A B : Set Nat) : A ∪ B = B ∪ A := by
  ext x              -- "임의의 x에 대해 양쪽 동치 증명"
  simp [Set.mem_union, or_comm]
  -- ext가 집합 같음을 "∀x, x ∈ LHS ↔ x ∈ RHS"로 변환
  -- simp가 or_comm (p ∨ q ↔ q ∨ p)으로 마무리
```

### 수학 ↔ Lean 대응표

| 수학 단계 | Lean 전술 | 설명 |
|-----------|-----------|------|
| A = B를 보이려면 | `ext x` | 원소별 동치 증명으로 변환 |
| 집합 정의 펼치기 | `simp [...]` | mem_union, mem_inter 등 사용 |
| 논리 법칙 적용 | `or_comm`, `and_comm` 등 | 1장의 논리 동치를 그대로 사용 |

### 빈칸 채우기

```lean
-- 교집합의 교환법칙을 증명하라.
example (A B : Set Nat) : A ∩ B = B ∩ A := by
  ext x
  ______
```

<details>
<summary>정답 보기</summary>

```lean
example (A B : Set Nat) : A ∩ B = B ∩ A := by
  ext x
  simp [Set.mem_inter_iff, and_comm]
```

`ext x`로 원소별 증명을 시작하고, `Set.mem_inter_iff`로 교집합 정의를 펼친 뒤, `and_comm`(p ∧ q ↔ q ∧ p)으로 마무리한다.  
**핵심: 집합 → 논리 번역표**   
|simp 힌트 | 집합 언어 | 논리 언어읽는 법|  
|------|-----------|-----------|
|Set.mem_compl_iff |  x ∈ Aᶜ¬(x ∈ A)   |    "x가 A의 여집합에 속한다 = x가 A에 속하지 않는다."  |
|Set.mem_inter_iff |  x ∈ A ∩ Bx ∈ A ∧ x ∈ B |   "x가 교집합에 속한다 = A에도 속하고 B에도 속한다."  |  
|Set.mem_union     |  x ∈ A ∪ Bx ∈ A ∨ x ∈ B |    "x가 합집합에 속한다 = A에 속하거나 B에 속한다"   |

**왜 필요한가** 

Lean에서 x ∈ Aᶜ은 내부적으로 x ∈ Aᶜ 그대로 저장되어 있다. tauto나 omega는 이것이 논리적으로 ¬(x ∈ A)라는 것을 모른다. 그래서 simp에 "이 사전을 써라"라고 알려줘야 한다.  
lean-- simp 전  
x ∈ (A ∪ B)ᶜ ↔ x ∈ Aᶜ ∩ Bᶜ  
-- 집합 기호 투성이. tauto가 읽을 수 없다.  

-- simp [세 힌트] 후  
¬(x ∈ A ∨ x ∈ B) ↔ ¬(x ∈ A) ∧ ¬(x ∈ B)  
-- 순수 논리. tauto가 바로 해결한다.  
```
  
## 하나씩 실제로 보기  
  
### 1. `Set.mem_compl_iff` -- 여집합  
```
정리: x ∈ Aᶜ ↔ x ∉ A  

적용 전:  x ∈ Aᶜ          (집합 표현)  
적용 후:  ¬(x ∈ A)        (논리 표현)  
```
 
ᶜ(complement)를 ¬(not)으로 바꾼다.  

### 2. `Set.mem_inter_iff` -- 교집합  
```
정리: x ∈ A ∩ B ↔ x ∈ A ∧ x ∈ B  

적용 전:  x ∈ A ∩ B       (집합 표현) 
적용 후:  x ∈ A ∧ x ∈ B   (논리 표현)  
```
 
∩(intersection)을 ∧(and)로 바꾼다. 

### 3. `Set.mem_union` -- 합집합  
```
정리: x ∈ A ∪ B ↔ x ∈ A ∨ x ∈ B  

적용 전:  x ∈ A ∪ B       (집합 표현)  
적용 후:  x ∈ A ∨ x ∈ B   (논리 표현)  
```
 
∪(union)을 ∨(or)로 바꾼다.  

## 대응 패턴 요약  
```
집합 세계          논리 세계  
─────────        ─────────  
  ᶜ  (여집합)   →    ¬  (부정)  
  ∩  (교집합)   →    ∧  (그리고)  
  ∪  (합집합)   →    ∨  (또는)  
  ⊆  (부분집합) →    →  (이면)  
simp 힌트 세 개는 위 표의 처음 세 줄을 Lean에게 알려주는 것이다. 이 번역이 끝나면 집합 문제가 논리 문제로 바뀌고, tauto가 자동으로 해결한다.  

</details>  

---  

## 2.2.2 집합의 항등 관계 (표 1)

1장에서 배운 **논리적 동치의 집합 버전**이다. AND를 ∩, OR를 ∪, NOT을 ᶜ로 바꾸면 된다.

| 이름 | 항등 관계 |
|------|-----------|
| **항등법칙**(Identity) | A ∪ ∅ = A, A ∩ U = A |
| **지배법칙**(Domination) | A ∪ U = U, A ∩ ∅ = ∅ |
| **멱등법칙**(Idempotent) | A ∪ A = A, A ∩ A = A |
| **이중보법칙**(Double complement) | (Aᶜ)ᶜ = A |
| **교환법칙**(Commutative) | A ∪ B = B ∪ A, A ∩ B = B ∩ A |
| **결합법칙**(Associative) | A ∪ (B ∪ C) = (A ∪ B) ∪ C |
| **분배법칙**(Distributive) | A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C) |
| **드 모르간**(De Morgan) | (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ, (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ |
| **흡수법칙**(Absorption) | A ∪ (A ∩ B) = A, A ∩ (A ∪ B) = A |
| **보원법칙**(Complement) | A ∪ Aᶜ = U, A ∩ Aᶜ = ∅ |

---

## 예제 10~11: 드 모르간 법칙 증명

### 방법 1: 부분집합 증명 (예제 10)

양방향 부분집합을 각각 보인다.

(⊆ 방향) x ∈ (A ∩ B)ᶜ라 가정.
→ x ∉ A ∩ B
→ ¬(x ∈ A ∧ x ∈ B)
→ x ∉ A ∨ x ∉ B (드 모르간 논리법칙)
→ x ∈ Aᶜ ∨ x ∈ Bᶜ
→ x ∈ Aᶜ ∪ Bᶜ

(⊇ 방향) 역순으로 진행.

### 방법 2: 조건제시법 + 논리 동치 (예제 11)

(A ∩ B)ᶜ = {x | ¬(x ∈ A ∧ x ∈ B)}
         = {x | x ∉ A ∨ x ∉ B}     (드 모르간 논리법칙)
         = {x | x ∈ Aᶜ ∨ x ∈ Bᶜ}
         = Aᶜ ∪ Bᶜ

---

## [Lean 4] 드 모르간 법칙

### 드 모르간 제1법칙: (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ

```lean
example (A B : Set Nat) :
    (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ := by
  ext x
  simp [Set.mem_compl_iff, Set.mem_union,
        Set.mem_inter_iff]
  tauto
```

### 수학 ↔ Lean 1:1 매칭

| 수학 단계 | Lean 단계 |
|-----------|-----------|
| "원소별로 보자" | `ext x` |
| x ∈ (A ∩ B)ᶜ 풀기 | `Set.mem_compl_iff` |
| ¬(P ∧ Q) = ¬P ∨ ¬Q | `not_and_or` (논리 드 모르간) |
| x ∈ Aᶜ ∪ Bᶜ 합치기 | `Set.mem_union` |

핵심: 집합의 드 모르간은 **논리의 드 모르간**(`not_and_or`)을 그대로 사용한다!

### 드 모르간 제2법칙: (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ

```lean
example (A B : Set Nat) :
    (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ := by
  ext x
  simp [Set.mem_compl_iff, Set.mem_inter_iff]

```
 ¬(P ∨ Q) = ¬P ∧ ¬Q 사용

### 빈칸 채우기

```lean
-- 분배 법칙: A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)
example (A B C_ : Set Nat) :
    A ∩ (B ∪ C_) = (A ∩ B) ∪ (A ∩ C_) := by
  ext x
  ______
```

<details>
<summary>정답 보기</summary>

```lean
example (A B C_ : Set Nat) :
    A ∩ (B ∪ C_) = (A ∩ B) ∪ (A ∩ C_) := by
  ext x
  simp [Set.mem_inter_iff, Set.mem_union, and_or_left]
```

`and_or_left`는 P ∧ (Q ∨ R) ↔ (P ∧ Q) ∨ (P ∧ R)에 해당하며, 이것이 바로 분배법칙의 논리 버전이다.

</details>

---

## 예제 12~14: 분배 법칙과 구성원 표

### 예제 13: 구성원 표(Membership Table)

진리표와 같은 원리이다. 각 원소가 집합에 속하면 1, 안 속하면 0으로 표시한다.

| x ∈ A | x ∈ B | x ∈ A ∩ B | x ∈ A ∪ B | x ∈ A \ B |
|-------|-------|-----------|-----------|-----------|
| 1 | 1 | 1 | 1 | 0 |
| 1 | 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 0 | 0 | 0 | 0 |

**양변이 같은 패턴인지 확인하면 항등 관계가 성립함을 알 수 있다.**

### 예제 14: 기존 항등을 이용한 증명

표 1의 항등을 조합하여 새로운 항등을 유도한다.

---

## 2.2.3 일반화된 합/교집합 + 예제 15~17

n개 집합의 합집합과 교집합:

$$\bigcup_{i=1}^{n} A_i = A_1 \cup A_2 \cup \cdots \cup A_n$$

$$\bigcap_{i=1}^{n} A_i = A_1 \cap A_2 \cap \cdots \cap A_n$$

---

## 2.2.4~5 비트열 표현 + 중복 집합

### 비트열 표현

전체집합 U = {1, 2, ..., 10}일 때 각 원소의 존재 여부를 비트로 표현한다.

- 홀수 집합 = 10 1010 1010
- 여집합 = 비트 반전 = 01 0101 0101
- 합집합 = 비트 OR, 교집합 = 비트 AND

```lean
-- Lean 4: 비트 연산
#eval (0b1010101010 : Nat) ||| (0b1111000000 : Nat)
-- 비트 OR: 합집합에 대응
```

### 빈칸 채우기

```lean
-- 0b1100 AND 0b1010 = ?
#eval (0b1100 : Nat) &&& (0b1010 : Nat)
-- 기대: ______
```

<details>
<summary>정답 보기</summary>

답: **8** (= 0b1000)

1100 AND 1010 = 1000 (둘 다 1인 자리만 1)

</details>

### 중복 집합(Multiset) -- 예제 21

P = {4 * a, 1 * b, 3 * c}, Q = {3 * a, 4 * b, 2 * d}

- P ∪ Q = {4 * a, 4 * b, 3 * c, 2 * d} (각 원소의 **최대** 중복도)
- P ∩ Q = {3 * a, 1 * b} (각 원소의 **최소** 중복도)

---

## [학생 활동] 2.2 집합 연산 종합 (5분)

A = {1, 2, 3, 4, 5}, B = {3, 4, 5, 6, 7}, U = {1, 2, ..., 10}

| 문제 | 답 |
|------|-----|
| 1. A ∪ B = ? | ______ |
| 2. A ∩ B = ? | ______ |
| 3. A \ B = ? | ______ |
| 4. Aᶜ = ? | ______ |
| 5. \|A ∪ B\| (포함-배제) | ______ |

**6.** [Lean 4] 드 모르간 제2법칙 빈칸 채우기:

```lean
example (A B : Set Nat) :
    (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ := by
  ext x
  ______
```

<details>
<summary>전체 정답 보기</summary>

1. A ∪ B = {1, 2, 3, 4, 5, 6, 7}
2. A ∩ B = {3, 4, 5}
3. A \ B = {1, 2}
4. Aᶜ = {6, 7, 8, 9, 10}
5. |A ∪ B| = 5 + 5 - 3 = **7**

6. Lean 4:
```lean
example (A B : Set Nat) :
    (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ := by
  ext x
  simp [Set.mem_compl_iff, Set.mem_inter_iff,
        Set.mem_union, not_or]
```

</details>

---

## 블록 1 Lean 4 전술 요약

| 전술 | 용도 | 사용 장면 |
|------|------|-----------|
| `intro x hx` | 가정/변수 도입 | 부분집합 증명의 첫 단계 |
| `exact` | 정확히 일치하는 증거 제시 | 증명 마무리 |
| `omega` | 선형 산술 자동 판정 | 부등식, 등식 자동 해결 |
| `ext x` | 집합의 같음을 원소별로 | A = B 증명의 첫 단계 |
| `simp [...]` | 자동 단순화 | 집합 연산 정리들 적용 |
| `decide` | 유한 결정 가능 문제 | Finset의 같음 확인 |
| `absurd` | 모순 유도 | 공집합 부분집합 증명 |
| `#eval` | 계산 확인 | 집합 크기, 멱집합 등 |

---

## sorry 완성 연습

아래 증명에서 `sorry`를 올바른 전술로 교체하라.

### 문제 1: 부분집합

```lean
example : {n : Nat | n > 20} ⊆ {n : Nat | n > 10} := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : {n : Nat | n > 20} ⊆ {n : Nat | n > 10} := by
  intro x hx
  omega
```

</details>

### 문제 2: 합집합의 결합법칙

```lean
example (A B C : Set Nat) :
    A ∪ (B ∪ C) = (A ∪ B) ∪ C := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (A B C : Set Nat) :
    A ∪ (B ∪ C) = (A ∪ B) ∪ C := by
  ext x
  simp [Set.mem_union, or_assoc]
```

</details>

### 문제 3: 흡수법칙

```lean
example (A B : Set Nat) :
    A ∪ (A ∩ B) = A := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (A B : Set Nat) :
    A ∪ (A ∩ B) = A := by
  ext x; simp [Set.mem_union, Set.mem_inter_iff]
  tauto
```

`simp`가 집합 정의를 논리식으로 펼친 뒤, `tauto`가 `x ∈ A ∨ x ∈ A ∧ x ∈ B ↔ x ∈ A`를 자동으로 닫는다.

</details>

---

## 완전 자유 증명 연습

다음을 처음부터 끝까지 스스로 증명하라.

### 도전 1

```lean
-- A ∩ (A ∪ B) = A
example (A B : Set Nat) :
    A ∩ (A ∪ B) = A := by
  -- 여기에 증명을 작성하라
```

<details>
<summary>정답 보기</summary>

```lean
example (A B : Set Nat) :
    A ∩ (A ∪ B) = A := by
  ext x; simp [Set.mem_inter_iff, Set.mem_union]
  tauto
```

`simp`가 정의를 펼치고, `tauto`가 `x ∈ A ∧ (x ∈ A ∨ x ∈ B) ↔ x ∈ A`(흡수법칙)를 자동으로 처리한다.

</details>

### 도전 2

```lean
-- (A \ B) ∪ (A ∩ B) = A
example (A B : Set Nat) :
    (A \ B) ∪ (A ∩ B) = A := by
  -- 여기에 증명을 작성하라
```

<details>
<summary>정답 보기</summary>

```lean
example (A B : Set Nat) :
    (A \ B) ∪ (A ∩ B) = A := by
  ext x
  simp [Set.mem_union, Set.mem_diff, Set.mem_inter_iff]
  tauto
```

</details>

---

```
-- Lean 4에서 Set = 술어(predicate)
-- Set Nat = Nat -> Prop
import Mathlib
import Mathlib.Data.Set.Basic
-- 예제 1: 원소 나열 (Finset 사용)
#eval ({1, 3, 5, 7, 9} : Finset Nat)  -- {1, 3, 5, 7, 9}

-- 예제 6: 집합의 같음 (순서/중복 무관)
example : ({1, 3, 5} : Finset Nat) = {3, 5, 1} := by decide
example : ({1, 1, 3, 5} : Finset Nat) = {1, 3, 5} := by decide

-- 조건제시법 (Set 사용)
def Odd_lt10 : Set Nat := {x | x % 2 = 1 ∧ x < 10}

-- 짝수 집합을 정의하고, 4가 원소인지 확인하라.
def MyEven : Set Nat := {x | x % 2 = 0}
example : 4 ∈ MyEven := by
  simp [MyEven]

-- 정리 1(i): 공집합은 모든 집합의 부분집합
example (A : Set Nat) : (∅ : Set Nat) ⊆ A := by
  intro x hx
  -- hx : x ∈ ∅   (공집합에 원소가 있다는 가정)
  contradiction

example : {n : Nat | n > 5} ⊆ {n : Nat | n > 3} := by
  intro x hx
  simp only [Set.mem_setOf_eq] at *    -- hx와 목표 모두 펼침
  omega         -- 5 < x 이면 당연히 3 < x

example : {n : Nat | n > 10} ⊆ {n : Nat | n > 5} := by
  intro x hx
  simp only [Set.mem_setOf_eq] at *    -- hx와 목표 모두 펼침
  omega 

-- Lean 4: 크기 확인
#eval ({1, 3, 5, 7, 9} : Finset Nat).card   -- 5
#eval (Finset.range 26).card                  -- 26
#eval (∅ : Finset Nat).card      

#eval Finset.powerset ({0, 1, 2} : Finset Nat)
-- {{}, {0}, {1}, {2}, {0,1}, {0,2}, {1,2}, {0,1,2}}
#eval (Finset.powerset ({0, 1, 2} : Finset Nat)).card  -- 8             -- 0
#eval (Finset.powerset ({1, 2, 3} : Finset Nat)).card


-- Lean 4: 데카르트 곱
#eval ({1, 2} : Finset Nat) ×ˢ ({3, 4, 5} : Finset Nat)
-- {(1,3),(1,4),(1,5),(2,3),(2,4),(2,5)}

-- {0,1} × {0,1} 의 원소 수는?
#eval (({0,1} : Finset Nat) ×ˢ ({0,1} : Finset Nat)).card

example (A : Set Nat) : (∅ : Set Nat) ⊆ A := by
  intro x hx
  contradiction

-- 합집합
example : ({1,3,5} : Finset Nat) ∪ {1,2,3} = {1,2,3,5} := by decide
-- 교집합
example : ({1,3,5} : Finset Nat) ∩ {1,2,3} = {1,3} := by decide

-- 차집합
example : ({1,3,5} : Finset Nat) \ {1,2,3} = {5} := by decide

-- 합집합의 교환법칙
example (A B : Set Nat) : A ∪ B = B ∪ A := by
  ext x              -- "임의의 x에 대해 양쪽 동치 증명"
  simp [Set.mem_union, or_comm]
  -- ext가 집합 같음을 "∀x, x ∈ LHS ↔ x ∈ RHS"로 변환
  -- simp가 or_comm (p ∨ q ↔ q ∨ p)으로 마무리

example (A B : Set Nat) : A ∩ B = B ∩ A := by
  ext x
  simp [Set.mem_inter_iff, and_comm]

example (A B : Set Nat) : (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ := by
  ext x
  simp [Set.mem_compl_iff, Set.mem_union,
        Set.mem_inter_iff]
  tauto

example (A B : Set Nat) :
    (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ := by
  ext x
  simp [Set.mem_compl_iff, Set.mem_inter_iff]
  
example (A B C_ : Set Nat) :
    A ∩ (B ∪ C_) = (A ∩ B) ∪ (A ∩ C_) := by
  ext x
  simp [Set.mem_inter_iff, Set.mem_union, and_or_left]

#eval (0b1010101010 : Nat) ||| (0b1111000000 : Nat)

-- 0b1100 AND 0b1010 = ?
#eval (0b1100 : Nat) &&& (0b1010 : Nat)

example (A B : Set Nat) :
    (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ := by
  ext x
  simp [Set.mem_compl_iff, Set.mem_inter_iff]

example : {n : Nat | n > 20} ⊆ {n : Nat | n > 10} := by
  intro x hx
  simp only [Set.mem_setOf_eq] at *    -- hx와 목표 모두 펼침
  omega

example (A B C : Set Nat) :
    A ∪ (B ∪ C) = (A ∪ B) ∪ C := by
  ext x
  simp [Set.mem_union, or_assoc]

example (A B : Set Nat) :
    A ∪ (A ∩ B) = A := by
  ext x 
  simp [Set.mem_union, Set.mem_inter_iff]
  tauto

example (A B : Set Nat) :
    A ∩ (A ∪ B) = A := by
  ext x; simp [Set.mem_inter_iff, Set.mem_union]
  tauto

example (A B : Set Nat) :
    (A \ B) ∪ (A ∩ B) = A := by
  ext x
  simp [Set.mem_union, Set.mem_diff, Set.mem_inter_iff]
  tauto
```
