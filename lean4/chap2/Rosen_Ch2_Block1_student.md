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
# 부록 2: 추가 도전 문제 — 단원별 10선

Rosen 8판 §2.3 함수 + §2.4 수열과 합

다음 문제들은 시간이 남거나 더 익히고 싶은 사람을 위한 것이다. Lean 4 코드의 빈칸(`____`)은 직접 채워서 오류 없이 컴파일되는지 확인한다. 정답은 반드시 손으로 먼저 풀어본 뒤 열어 본다.

---

# 제1막 — 함수의 정의와 세 종류

**도전 1.** f: ℤ → ℤ, f(n) = 4n − 3이 단사임을 손으로 증명하라. 워크북 Q1의 네 단계 호흡을 그대로 따른다.

> 힌트. f(a) = f(b)에서 출발한다. 4a − 3 = 4b − 3을 쓰고, 양변에서 −3을 빼고, 4로 나눈다.

<details>
<summary>정답 보기</summary>

f(a) = f(b)라 하자. 정의에 의해 4a − 3 = 4b − 3이다. 양변에 3을 더하면 4a = 4b이다. 양변을 4로 나누면 a = b이다. 따라서 f는 단사이다.

</details>

---

**도전 2.** Lean 4로 f(n) = n + 1이 ℤ → ℤ에서 단사임을 증명하라. 빈칸을 채워라.

```lean4
example : Function.Injective (fun n : Int => n + 1) := by
  intro ____ ____ ____
  ____
```

> 힌트. `intro`로 임의의 a, b와 가정 h를 도입하고, `omega`로 닫는다.

<details>
<summary>정답 보기</summary>

```lean4
example : Function.Injective (fun n : Int => n + 1) := by
  intro a b h
  omega
```

`intro a b h` 이후 InfoView: `a b : Int`, `h : a + 1 = b + 1`, 목표: `a = b`. `omega`가 1차 산술로 자동 처리한다.

</details>

---

**도전 3.** Lean 4로 f(n) = n + 1이 ℤ → ℤ에서 전사임을 증명하라. 빈칸을 채워라.

```lean4
example : Function.Surjective (fun n : Int => n + 1) := by
  intro ____
  use ____
  ____
```

> 힌트. 임의의 출력 b에 대해 증인은 b − 1이다.

<details>
<summary>정답 보기</summary>

```lean4
example : Function.Surjective (fun n : Int => n + 1) := by
  intro b
  use b - 1
  omega
```

`use b - 1` 이후 목표: `b - 1 + 1 = b`. `omega`가 닫는다. `simp`로도 가능하다.

</details>

---

**도전 4.** Lean 4로 f(n) = n + 1이 ℤ → ℤ에서 전단사임을 증명하라. 빈칸을 채워라.

```lean4
example : Function.Bijective (fun n : Int => n + 1) := by
  ____
  · intro ____ ____ ____; ____
  · intro ____; use ____; ____
```

> 힌트. `constructor`가 `Bijective f = Injective f ∧ Surjective f`의 ∧를 두 목표로 분리한다.

<details>
<summary>정답 보기</summary>

```lean4
example : Function.Bijective (fun n : Int => n + 1) := by
  constructor
  · intro a b h; omega
  · intro b; use b - 1; omega
```

`constructor` 이후 첫 번째 목표는 단사, 두 번째 목표는 전사이다. 점(·)으로 각 목표를 구분한다.

</details>

---

**도전 5.** 다음 세 함수 각각에 대해 단사인지, 전사인지, 전단사인지 판별하고 이유를 한 줄씩 쓰라. (정의역과 공역은 모두 ℤ)

- (가) f(n) = n − 7
- (나) f(n) = 3n
- (다) f(n) = n² + 1

> 힌트. (나)는 홀수 1이 출력될 수 있는지 확인한다. (다)는 f(1)과 f(−1)을 각각 계산해 본다.

<details>
<summary>정답 보기</summary>

**(가) f(n) = n − 7:** 단사이다. f(a) = f(b) → a − 7 = b − 7 → a = b. 전사이다. 임의의 b에 대해 a = b + 7이면 f(a) = b. 따라서 **전단사**이다.

**(나) f(n) = 3n:** 단사이다. f(a) = f(b) → 3a = 3b → a = b. 전사가 아니다. 1 = 3a를 만족하는 정수 a가 없다. 따라서 **단사이지만 전사가 아니다**.

**(다) f(n) = n² + 1:** 단사가 아니다. f(1) = 2이고 f(−1) = 2인데 1 ≠ −1이다. 전사도 아니다. 0 = n² + 1을 만족하는 정수 n이 없다. 따라서 **단사도 전사도 아니다**.

</details>

---

**도전 6.** f: ℤ → ℤ, f(n) = 5n + 2가 전단사임을 손으로 증명하라. 단사 증명과 전사 증명을 각각 적는다.

> 힌트. 전사에서 증인을 구하려면 b = 5a + 2를 a에 대해 푼다.

<details>
<summary>정답 보기</summary>

**단사:** f(a) = f(b)라 하면 5a + 2 = 5b + 2이다. 양변에서 2를 빼면 5a = 5b이고, 5로 나누면 a = b이다.

**전사:** 임의의 b ∈ ℤ에 대해 a = (b − 2)/5로 두면 f(a) = 5 · (b−2)/5 + 2 = b이다.

두 조건이 모두 성립하므로 f는 전단사이다.

</details>

---

**도전 7.** Lean 4로 f(n) = 2n + 5가 ℤ → ℤ에서 단사임을 증명하라. 빈칸을 채워라.

```lean4
example : Function.Injective (fun n : Int => 2 * n + 5) := by
  ____
  ____
```

> 힌트. `intro`와 `omega` 두 줄이면 충분하다.

<details>
<summary>정답 보기</summary>

```lean4
example : Function.Injective (fun n : Int => 2 * n + 5) := by
  intro a b h
  omega
```

`h : 2 * a + 5 = 2 * b + 5`에서 `omega`가 `a = b`를 자동으로 유도한다. 손으로는 양변에서 5를 빼고 2로 나누는 두 단계가 필요하지만, `omega`는 이를 한 번에 처리한다.

</details>

---

**도전 8.** 다음 주장이 참인지 거짓인지 판별하고, 거짓이면 반례를 제시하라.

> "f: A → B가 단사이고 g: B → C가 단사이면, g ∘ f: A → C도 단사이다."

> 힌트. (g ∘ f)(a) = (g ∘ f)(b)를 가정하면 g(f(a)) = g(f(b))이다. g가 단사이므로 f(a) = f(b), f가 단사이므로 a = b가 따라온다.

<details>
<summary>정답 보기</summary>

**참이다.**

(g ∘ f)(a) = (g ∘ f)(b)라 하자. 정의에 의해 g(f(a)) = g(f(b))이다. g가 단사이므로 f(a) = f(b)이다. f가 단사이므로 a = b이다. 따라서 g ∘ f는 단사이다.

</details>

---

**도전 9.** Lean 4에서 다음 코드가 오류를 내는 이유를 설명하고, 올바른 서술로 고쳐라.

```lean4
example : Function.Injective (fun n : Int => n ^ 2) := by
  intro a b h
  omega
```

> 힌트. `omega`는 1차(선형) 산술만 처리한다. 그리고 f(n) = n²은 사실 단사가 아니다.

<details>
<summary>정답 보기</summary>

두 가지 문제가 있다.

첫째, `n²`은 2차(비선형) 항이므로 `omega`가 처리하지 못한다.

둘째, f(n) = n²은 단사가 아니다. f(1) = f(−1) = 1이므로 서로 다른 입력이 같은 출력을 낸다. 따라서 이 `example` 자체가 거짓 명제이고, 어떤 전술로도 증명할 수 없다.

올바른 서술:

```lean4
example : ¬ Function.Injective (fun n : Int => n ^ 2) := by
  intro h
  have : (1 : Int) = -1 := h (by norm_num)
  norm_num at this
```

`h`에 `1² = (−1)²`라는 사실을 적용하면 `1 = −1`이 나오고, `norm_num`이 이 모순을 닫는다.

</details>

---

**도전 10.** 집합 A = {1, 2, 3, 4}, B = {a, b, c, d}에서 단사 함수의 개수와 전단사 함수의 개수를 각각 구하고, 두 값이 같은 이유를 설명하라.

> 힌트. |A| = |B| = 4일 때 단사이면 반드시 전사이기도 하다.

<details>
<summary>정답 보기</summary>

|A| = |B| = 4이므로 단사 함수는 자동으로 전사이기도 하다. 따라서 단사 함수의 수 = 전단사 함수의 수 = 4! = **24**이다.

첫 번째 원소에 4가지, 두 번째에 3가지, 세 번째에 2가지, 네 번째에 1가지이므로 4 × 3 × 2 × 1 = 24이다.

</details>

---

# 제2막 — 함수의 식구들

**도전 1.** f(x) = 2x + 3, g(x) = x − 1일 때, (f ∘ g)(4)와 (g ∘ f)(4)를 각각 계산하라.

> 힌트. (f ∘ g)(4) = f(g(4))이다. g(4)를 먼저 계산하고, 그 결과에 f를 적용한다.

<details>
<summary>정답 보기</summary>

(f ∘ g)(4) = f(g(4)) = f(3) = 2 · 3 + 3 = **9**

(g ∘ f)(4) = g(f(4)) = g(11) = 11 − 1 = **10**

두 값이 다르다. 합성은 순서가 중요하다.

</details>

---

**도전 2.** 워크북 Q2의 두 함수 f(x) = x² + 1, g(x) = 2x − 3에 대해 (f ∘ g)(x)와 (g ∘ f)(x)를 x에 대한 식으로 표현하라.

> 힌트. (f ∘ g)(x) = f(2x − 3) = (2x − 3)² + 1이다. 전개하여 정리한다.

<details>
<summary>정답 보기</summary>

(f ∘ g)(x) = (2x − 3)² + 1 = **4x² − 12x + 10**

(g ∘ f)(x) = 2(x² + 1) − 3 = **2x² − 1**

두 식이 다르다.

</details>

---

**도전 3.** f(x) = 7x − 4의 역함수 f⁻¹(y)를 구하고, f⁻¹(f(x)) = x임을 검산하라.

> 힌트. y = 7x − 4를 x에 대해 풀면 x = (y + 4)/7이다.

<details>
<summary>정답 보기</summary>

f⁻¹(y) = **(y + 4)/7**

검산: f⁻¹(f(x)) = ((7x − 4) + 4)/7 = 7x/7 = **x**. 확인됨.

</details>

---

**도전 4.** 다음 값을 계산하라.

- (가) ⌊8.9⌋,  (나) ⌈8.9⌉,  (다) ⌊−5.3⌋,  (라) ⌈−5.3⌉,  (마) ⌈4.0⌉

> 힌트. 음수에서 바닥 함수는 "수직선 왼쪽"이다. ⌊−5.3⌋은 −5가 아니라 −6이다.

<details>
<summary>정답 보기</summary>

(가) **8**,  (나) **9**,  (다) **−6**,  (라) **−5**,  (마) **4**

(다): −5.3 이하의 가장 큰 정수는 −6이다. (라): −5.3 이상의 가장 작은 정수는 −5이다. (마): 이미 정수이면 바닥 = 천정 = 자신이다.

</details>

---

**도전 5.** 워크북 Q3의 공식 ⌈n/8⌉을 응용하여 다음 각 경우에 필요한 바이트 수를 구하라.

- (가) 160비트,  (나) 17비트,  (다) 256비트

> 힌트. 8의 배수인 경우와 그렇지 않은 경우를 구분한다.

<details>
<summary>정답 보기</summary>

(가) ⌈160/8⌉ = ⌈20⌉ = **20바이트**

(나) ⌈17/8⌉ = ⌈2.125⌉ = **3바이트**

(다) ⌈256/8⌉ = ⌈32⌉ = **32바이트**

</details>

---

**도전 6.** 다음 계승 값을 계산하고, 각각 앞 항의 몇 배인지 말하라.

- (가) 6!,  (나) 7!,  (다) 8! / 6!

> 힌트. 5! = 120임을 이용한다. n! = n × (n−1)! 관계를 쓴다.

<details>
<summary>정답 보기</summary>

(가) 6! = 6 × 120 = **720** (5!의 6배)

(나) 7! = 7 × 720 = **5040** (6!의 7배)

(다) 8! / 6! = 8 × 7 = **56**

</details>

---

**도전 7.** f(x) = x + 2, g(x) = x − 2에 대해 (f ∘ g)(x)와 (g ∘ f)(x)를 구하고, g가 f의 역함수인지 판별하라.

> 힌트. (f ∘ g)(x)의 결과가 x이면 g = f⁻¹이다.

<details>
<summary>정답 보기</summary>

(f ∘ g)(x) = f(x − 2) = (x − 2) + 2 = **x**

(g ∘ f)(x) = g(x + 2) = (x + 2) − 2 = **x**

두 합성이 모두 x이므로 **g는 f의 역함수이다.**

</details>

---

**도전 8.** 합성 함수의 비가환성 예시를 워크북 본문의 "양말과 신발" 이외에 두 가지 더 찾아 설명하라.

> 힌트. 순서가 바뀌면 결과가 달라지는 두 행위의 조합을 생각한다.

<details>
<summary>정답 보기</summary>

**예시 1.** 문을 열고 방에 들어가는 것과, 방에 들어가고 문을 여는 것은 결과가 다르다. 문을 먼저 열어야 방에 들어갈 수 있다.

**예시 2.** 물을 끓이고 컵라면에 붓는 것과, 컵라면에 붓고 물을 끓이는 것은 결과가 완전히 다르다. 끓인 물을 부어야 조리가 된다.

</details>

---

**도전 9.** 워크북 기존 도전 6의 공식 ⌈x⌉ = −⌊−x⌋를 다음 세 값에 대해 검증하라.

- x = 2.5,  x = −3.0,  x = −0.1

> 힌트. 각 x에 대해 좌변 ⌈x⌉와 우변 −⌊−x⌋를 따로 계산한다.

<details>
<summary>정답 보기</summary>

**x = 2.5:** ⌈2.5⌉ = 3. −⌊−2.5⌋ = −(−3) = 3. **일치**.

**x = −3.0:** ⌈−3.0⌉ = −3. −⌊3.0⌋ = −3. **일치**.

**x = −0.1:** ⌈−0.1⌉ = 0. −⌊0.1⌋ = −0 = 0. **일치**.

</details>

---

**도전 10.** 함수 f(n) = 3n − 7이 ℤ → ℤ에서 전단사임을 보이고, Lean 4 코드의 빈칸을 채워라.

```lean4
example : Function.Bijective (fun n : Int => 3 * n - 7) := by
  ____
  · ____
  · intro b; use ____; ____
```

> 힌트. 전사의 증인을 구하려면 b = 3a − 7을 a에 대해 푼다.

<details>
<summary>정답 보기</summary>

**손 증명:** 단사: 3a − 7 = 3b − 7 → a = b. 전사: a = (b + 7)/3이면 f(a) = b.

```lean4
example : Function.Bijective (fun n : Int => 3 * n - 7) := by
  constructor
  · intro a b h; omega
  · intro b; use (b + 7) / 3; omega
```

</details>

---

# 제3막 — 수열과 합

**도전 1.** 다음 수열이 함수임을 확인하고, 일반항 a: ℕ → ℕ를 n의 식으로 표현하라.

- (가) 3, 6, 9, 12, 15, ...
- (나) 1, 4, 9, 16, 25, ...
- (다) 2, 4, 8, 16, 32, ...

> 힌트. 수열은 "양의 정수에 원소를 짝짓는 함수"이다.

<details>
<summary>정답 보기</summary>

(가) a(n) = **3n** (등차수열, 선형 함수)

(나) a(n) = **n²** (제곱수 수열, 이차 함수)

(다) a(n) = **2ⁿ** (등비수열, 지수 함수)

</details>

---

**도전 2.** 초항 a = 5, 공차 d = 4인 등차수열의 10번째 항과 처음 10항의 합을 구하라.

> 힌트. a(n) = a + (n−1)·d, 합 = n(2a + (n−1)d)/2를 이용한다.

<details>
<summary>정답 보기</summary>

10번째 항: 5 + 9 × 4 = **41**

처음 10항의 합: 10 × (10 + 36)/2 = **230**

</details>

---

**도전 3.** 가우스 합 공식을 이용하여 계산하라.

- (가) 1 + 2 + ⋯ + 50
- (나) 51 + 52 + ⋯ + 100

> 힌트. (나)는 (1 + ⋯ + 100) − (1 + ⋯ + 50)으로 분리한다.

<details>
<summary>정답 보기</summary>

(가) 50 × 51/2 = **1275**

(나) 5050 − 1275 = **3775**

</details>

---

**도전 4.** 피보나치 수열의 정의를 점화 관계로 쓰고 f₈을 직접 계산하라.

> 힌트. f₀ = 0, f₁ = 1, fₙ = fₙ₋₁ + fₙ₋₂ (n ≥ 2).

<details>
<summary>정답 보기</summary>

f₂ = 1, f₃ = 2, f₄ = 3, f₅ = 5, f₆ = 8, f₇ = 13, f₈ = **21**

</details>

---

**도전 5.** 다음 Lean 4 코드의 빈칸을 채워 등차수열 1, 3, 5, 7, ...을 점화 관계로 정의하라.

```lean4
def oddSeq : Nat → Nat
  | 0     => ____
  | n + 1 => ____
```

> 힌트. 매 항마다 2씩 증가한다. 기저 사례가 하나이다.

<details>
<summary>정답 보기</summary>

```lean4
def oddSeq : Nat → Nat
  | 0     => 1
  | n + 1 => oddSeq n + 2
```

oddSeq 0 = 1, oddSeq 1 = 3, oddSeq 2 = 5, oddSeq 3 = 7. 확인됨.

피보나치는 이전 두 항을 참조하므로 기저 사례가 두 개 필요하지만, 이 수열은 이전 한 항만 참조하므로 하나면 충분하다.

</details>

---

**도전 6.** 워크북 Q5의 빈칸을 채워 등비수열 1, 2, 4, 8, 16, ...을 Lean 4로 정의하라.

```lean4
def geom : Nat → Nat
  | 0     => ____
  | n + 1 => ____
```

> 힌트. 초항은 1이고, 각 항은 이전 항의 2배이다.

<details>
<summary>정답 보기</summary>

```lean4
def geom : Nat → Nat
  | 0     => 1
  | n + 1 => 2 * geom n
```

geom 0 = 1, geom 1 = 2, geom 2 = 4, geom 3 = 8, geom 4 = 16.

</details>

---

**도전 7.** 다음 표에서 피보나치 정의의 각 줄과 수학 표기를 1대1로 연결하라.

```lean4
def fib : Nat → Nat
  | 0     => 0
  | 1     => 1
  | n + 2 => fib (n+1) + fib n
```

| 수학 표기 | Lean 4 코드 |
|-----------|-------------|
| f₀ = 0 | ____ |
| f₁ = 1 | ____ |
| fₙ = fₙ₋₁ + fₙ₋₂ (n ≥ 2) | ____ |

> 힌트. `n + 2` 패턴이 "2 이상의 자연수"를 표현하는 Lean 4 방식이다.

<details>
<summary>정답 보기</summary>

| 수학 표기 | Lean 4 코드 |
|-----------|-------------|
| f₀ = 0 | `\| 0 => 0` |
| f₁ = 1 | `\| 1 => 1` |
| fₙ = fₙ₋₁ + fₙ₋₂ (n ≥ 2) | `\| n + 2 => fib (n+1) + fib n` |

`n + 2`에서 n은 0, 1, 2, ...이므로 `n + 2`는 2, 3, 4, ...이다. 이것이 "n ≥ 2인 경우"를 표현하는 Lean 4의 방식이다.

</details>

---

**도전 8.** 무한 등비수열의 합 공식 a/(1−r) (|r| < 1)을 이용하여 계산하라.

- (가) 1 + 1/2 + 1/4 + 1/8 + ⋯
- (나) 3 + 1 + 1/3 + 1/9 + ⋯

> 힌트. (가)는 a = 1, r = 1/2이다. (나)의 a와 r을 먼저 확인한다.

<details>
<summary>정답 보기</summary>

(가) a = 1, r = 1/2. 합 = 1/(1 − 1/2) = **2**

(나) a = 3, r = 1/3. 합 = 3/(1 − 1/3) = **9/2**

</details>

---

**도전 9.** 수열 a₁ = 2, aₙ₊₁ = 3aₙ으로 정의될 때 a₅를 구하고 일반항을 Lean 4 점화 관계로 정의하라.

> 힌트. 등비수열이다. 공비 r = 3, 초항 a₁ = 2이므로 aₙ = 2 · 3^(n−1)이다.

<details>
<summary>정답 보기</summary>

a₁ = 2, a₂ = 6, a₃ = 18, a₄ = 54, a₅ = **162**

일반항: aₙ = 2 · 3^(n−1)

```lean4
def mySeq : Nat → Nat
  | 0     => 2
  | n + 1 => 3 * mySeq n
```

</details>

---

**도전 10.** 워크북 기존 도전 5의 합 1 + 1/3 + 1/9 + 1/27 + ⋯ = 3/2를 두 방법으로 각각 구하라.

- (가) 공식 a/(1−r) 직접 적용
- (나) S = 1 + 1/3 + ⋯로 두고, S − S/3 = 1을 이용

> 힌트. (나)는 양변에 공비를 곱한 수열을 원래 수열에서 빼는 방법이다. 공식 자체를 유도하는 방식이다.

<details>
<summary>정답 보기</summary>

**(가)** a = 1, r = 1/3. 합 = 1/(1 − 1/3) = 1/(2/3) = **3/2**.

**(나)** S = 1 + 1/3 + 1/9 + ⋯, S/3 = 1/3 + 1/9 + ⋯

S − S/3 = 1이므로 S × 2/3 = 1, S = **3/2**.

두 방법이 같은 답을 준다.

</details>
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
