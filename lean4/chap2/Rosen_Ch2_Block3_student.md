# Rosen Chapter 2 -- 블록 3: 2.5 집합의 크기 + 2.6 행렬 + 종합 정리

> 블록 1~2에서 배운 집합, 함수, 수열을 토대로, 무한집합의 크기 비교와 행렬의 기초를 다룬다.

---

# 2.5 집합의 크기 (Cardinality of Sets)

---

## 정의 1~2: 크기, 같은 크기

### 정의 1: 같은 크기

두 집합 A, B 사이에 **전단사 함수**가 존재하면 A와 B는 같은 크기이다.

> |A| = |B| ⇔ A에서 B로의 전단사가 존재

유한집합에서는 원소 수가 같으면 같은 크기이다. 핵심은 이 정의가 **무한집합에도 적용**된다는 것이다.

### 정의 2: 셀 수 있는 집합(Countable Set)

유한집합이거나, 자연수 N과 같은 크기인 집합을 **셀 수 있다**고 한다.

---

## 예제 1~4: 셀 수 있는 집합들

### 예제 1: 양의 홀수의 집합은 셀 수 있다

f(n) = 2n + 1이 N에서 양의 홀수 집합으로의 전단사이다.

| n | 0 | 1 | 2 | 3 | 4 | ... |
|---|---|---|---|---|---|-----|
| f(n) = 2n+1 | 1 | 3 | 5 | 7 | 9 | ... |

```lean
-- Lean 4: 양의 홀수가 셀 수 있음
-- f(n) = 2n + 1 이 전단사임을 증명
example : Function.Bijective (fun n : Nat => 2 * n + 1) := by
  constructor
  · intro a b h; omega       -- 단사
  · intro b; use (b - 1) / 2  -- 전사 (개념적)
    omega
```

### 예제 2: 정수 Z는 셀 수 있다

N에서 Z로의 전단사를 구성할 수 있다: 0, 1, -1, 2, -2, 3, -3, ...

### 예제 3: 양의 유리수의 집합은 셀 수 있다

대각선 나열법으로 모든 양의 유리수를 나열할 수 있다.

### 힐버트의 그랜드 호텔

무한개의 방이 꽉 찬 호텔에 새 손님이 왔다. 모든 손님을 한 칸씩 옮기면 1호가 비게 된다.
이것이 가능한 이유는 자연수와 "자연수 + 1"이 같은 크기이기 때문이다.

---

## 예제 5: 실수는 셀 수 없다 (칸토르 대각선 논증)

이것은 수학사에서 가장 우아한 증명 중 하나이다.

### 칸토르 대각선 논증 (Cantor's Diagonal Argument)

**주장**: 0과 1 사이의 실수의 집합은 셀 수 없다.

**증명** (귀류법):

1. 셀 수 있다고 가정한다. 즉, 0과 1 사이의 모든 실수를 나열할 수 있다.

| 번호 | 소수 전개 |
|------|----------|
| r_1 | 0.**5** 1 0 1 1 ... |
| r_2 | 0.4 **1** 3 2 0 ... |
| r_3 | 0.8 0 **9** 3 4 ... |
| r_4 | 0.2 3 1 **0** 1 ... |
| r_5 | 0.4 1 0 7 **2** ... |

2. 새 실수 r을 만든다: i번째 자리를 r_i의 i번째 자리와 **다르게** 설정.

   r = 0.6 2 0 1 3 ...  (대각선의 각 숫자와 다른 숫자 선택)

3. r은 **모든 r_i와 다르다**:
   - r != r_1 (첫째 자리가 다름)
   - r != r_2 (둘째 자리가 다름)
   - r != r_i (i번째 자리가 다름)

4. **모순**: r은 0과 1 사이의 실수인데, 나열에 포함되지 않는다.

따라서 0과 1 사이의 실수는 셀 수 없다. **|R| > |N|**.

### 칸토르 정리 (Lean 4)

(참고: 이 증명은 고급 내용이므로 `have`를 예외적으로 사용한다. 학생이 직접 코딩할 필요는 없으며, 핵심 아이디어를 이해하는 것이 목표이다.)

```lean
-- 칸토르 정리: 어떤 집합에서 자신의 멱집합으로의
-- 전사 함수는 존재하지 않는다.
theorem Cantor : ∀ f : α → Set α, ¬Function.Surjective f := by
  intro f surjf
  let S := { i | i ∉ f i }
  rcases surjf S with ⟨j, h⟩
  have h1 : j ∉ f j := by
    intro h'
    have : j ∉ f j := by rwa [h] at h'
    contradiction
  have h2 : j ∈ S := h1
  have h3 : j ∉ S := by rwa [h] at h1
  contradiction
```

핵심: S = {i | i ∉ f(i)}를 구성하고, S의 원상 j에 대해 "j ∈ S이면서 j ∉ S"라는 모순을 유도한다.

---

## 정리 1~2

### 정리 1: 셀 수 있는 집합의 합집합은 셀 수 있다

### 정리 2 (Schroeder-Bernstein)

|A| <= |B| 이고 |B| <= |A| 이면 |A| = |B|.

즉, 양방향 단사 함수가 존재하면 전단사가 존재한다.

---

---

# 2.6 행렬 (Matrices)

---

## 정의 1~5: 행렬, 덧셈, 곱셈, 항등, 거듭제곱

### 정의 1: 행렬(Matrix)

m x n 행렬은 m개의 행과 n개의 열을 가진 수의 직사각 배열이다.

### 정의 2: 행렬의 덧셈

같은 크기의 행렬끼리 대응하는 원소를 더한다.

### 정의 3: 행렬의 곱셈

A가 m x k, B가 k x n이면 AB는 m x n 행렬.

(AB)_{ij} = sum_{t=1}^{k} a_{it} * b_{tj}

**가장 중요한 것: AB != BA**. 행렬 곱셈은 교환법칙이 성립하지 않는다.

### 정의 4: 항등 행렬(Identity Matrix)

I_n: 대각선이 1, 나머지가 0인 n x n 행렬. AI = IA = A.

### 정의 5: 행렬의 거듭제곱

A^0 = I, A^n = A * A^{n-1}

### [Lean 4] 행렬 연산

```lean
open Matrix

-- 벡터 덧셈
#eval ![1, 2] + ![3, 4]  -- ![4, 6]

-- 행렬 덧셈
#eval !![1, 2; 3, 4] + !![3, 4; 5, 6]  -- !![4, 6; 8, 10]

-- 행렬 곱셈
#eval !![1, 2; 3, 4] * !![3, 4; 5, 6]  -- !![13, 16; 29, 36]
```

---

## 정의 6~10: 전치, 대칭, 0-1 행렬, 부울 곱

### 정의 6: 전치 행렬(Transpose)

A^T: 행과 열을 교환. (A^T)_{ij} = A_{ji}

### 정의 7: 대칭 행렬(Symmetric)

A = A^T이면 대칭 행렬.

### 정의 8~10: 0-1 행렬, 부울 곱

원소가 0 또는 1인 행렬. 부울 곱에서는 +를 OR, *를 AND로 대체한다.

```lean
open Matrix

-- 전치
#eval !![1, 2; 3, 4]ᵀ  -- !![1, 3; 2, 4]

-- 행렬-벡터 곱
#eval !![1, 2; 3, 4] *ᵥ ![1, 1]  -- ![3, 7]

-- 행렬식
#eval !![(1 : Int), 2; 3, 4].det  -- -2
```

---

---

# Chapter 2 종합 정리

---

## Lean 4 전술 총정리

| 전술 | 용도 | 대표적 사용 장면 |
|------|------|----------------|
| `intro x` | 변수/가정 도입 | ⊆ 증명, Injective 증명 |
| `exact h` | 정확히 일치하는 증거 | 증명 마무리 |
| `apply h` | 함수 적용 | h : A -> B, 목표 B |
| `omega` | 선형 산술 자동 | 부등식, 등식 |
| `ext x` | 집합 같음 -> 원소별 | A = B 증명 |
| `simp [...]` | 자동 단순화 | 집합 연산, 논리 법칙 |
| `use a` | 존재 증인 제시 | Surjective 증명 |
| `obtain` | 존재 분해 | ∃에서 증인 추출 |
| `constructor` | ∧/↔ 분리 | Bijective = Injective ∧ Surjective |
| `cases h` | 가정 분해 | ∨, ∧ 분해 |
| `ring` | 대수 등식 | 합성 함수 계산 |
| `decide` | 유한 결정 | Finset 검증 |
| `norm_num` | 수치 판정 | 1^2 = (-1)^2 |
| `absurd` | 모순 유도 | ¬Injective 증명 |
| `#eval` | 계산 확인 | 수열, 집합, 행렬 |

---

## 핵심 증명 패턴 정리

### 패턴 1: 부분집합 증명 (A ⊆ B)

```lean
-- 수학: 임의의 x를 잡고, x ∈ A이면 x ∈ B를 보인다.
intro x hx    -- x를 잡고, x ∈ A를 가정
(목표 증명)    -- x ∈ B를 보인다
```

### 패턴 2: 집합 같음 증명 (A = B)

```lean
-- 수학: 원소별로 양쪽 동치를 보인다.
ext x         -- ∀x, x ∈ A ↔ x ∈ B 로 변환
simp [...]    -- 논리 법칙으로 마무리
```

### 패턴 3: 단사 증명 (Injective f)

```lean
-- 수학: f(a) = f(b)를 가정하고 a = b를 보인다.
intro a b h   -- a, b를 잡고, f(a) = f(b)를 가정
omega         -- a = b 유도
```

### 패턴 4: 전사 증명 (Surjective f)

```lean
-- 수학: 임의의 b에 대해 f(a) = b인 a를 제시한다.
intro b       -- 임의의 출력 b
use (증인)     -- 입력 a 제시
omega         -- f(a) = b 확인
```

### 패턴 5: 전단사 증명 (Bijective f)

```lean
-- 수학: 단사와 전사를 각각 보인다.
constructor   -- Injective ∧ Surjective 분리
· (단사 증명)
· (전사 증명)
```

---

## 1장 논리 ↔ 2장 집합 대응 총정리

| 논리 (1장) | 집합 (2장) | Lean 정리 |
|-----------|-----------|-----------|
| p ∨ q | A ∪ B | `or_comm`, `or_assoc` |
| p ∧ q | A ∩ B | `and_comm`, `and_assoc` |
| ¬p | Aᶜ | `Set.mem_compl_iff` |
| p ∧ ¬q | A \\ B | `Set.mem_diff` |
| ¬(p ∧ q) ≡ ¬p ∨ ¬q | (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ | `not_and_or` |
| ¬(p ∨ q) ≡ ¬p ∧ ¬q | (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ | `not_or` |
| p ∧ (q ∨ r) ≡ (p∧q) ∨ (p∧r) | A ∩ (B ∪ C) = (A∩B) ∪ (A∩C) | `and_or_left` |

---

## 종합 연습: sorry 완성

### 문제 1

```lean
-- 합집합의 멱등법칙: A ∪ A = A
example (A : Set Nat) : A ∪ A = A := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (A : Set Nat) : A ∪ A = A := by
  ext x; simp
```

</details>

### 문제 2

```lean
-- 교집합의 멱등법칙: A ∩ A = A
example (A : Set Nat) : A ∩ A = A := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (A : Set Nat) : A ∩ A = A := by
  ext x; simp
```

</details>

### 문제 3

```lean
-- f(x) = 3x - 7 이 Int에서 단사
example : Function.Injective (fun n : Int => 3 * n - 7) := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : Function.Injective (fun n : Int => 3 * n - 7) := by
  intro a b h; omega
```

</details>

### 문제 4

```lean
-- f(x) = x - 3 이 Int에서 전단사
example : Function.Bijective (fun n : Int => n - 3) := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : Function.Bijective (fun n : Int => n - 3) := by
  constructor
  · intro a b h; omega
  · intro b; use b + 3; omega
```

</details>

### 문제 5

```lean
-- 드 모르간 + 분배 조합:
-- (A ∪ B) ∩ C = (A ∩ C) ∪ (B ∩ C)
example (A B C : Set Nat) :
    (A ∪ B) ∩ C = (A ∩ C) ∪ (B ∩ C) := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (A B C : Set Nat) :
    (A ∪ B) ∩ C = (A ∩ C) ∪ (B ∩ C) := by
  ext x
  simp [Set.mem_inter_iff, Set.mem_union, or_and_right]
```

</details>

---

## 완전 자유 증명 도전

### 도전 1: 이중 여집합

```lean
-- (Aᶜ)ᶜ = A
example (A : Set Nat) : Aᶜᶜ = A := by
  -- 여기에 증명을 작성하라
```

<details>
<summary>정답 보기</summary>

```lean
example (A : Set Nat) : Aᶜᶜ = A := by
  ext x; simp
```

</details>

### 도전 2: 차집합과 교집합의 관계

```lean
-- A \ B = A ∩ Bᶜ
example (A B : Set Nat) : A \ B = A ∩ Bᶜ := by
  -- 여기에 증명을 작성하라
```

<details>
<summary>정답 보기</summary>

```lean
example (A B : Set Nat) : A \ B = A ∩ Bᶜ := by
  ext x; simp [Set.mem_diff, Set.mem_inter_iff, Set.mem_compl_iff]
```

</details>

### 도전 3: 합성 함수의 단사성

```lean
-- g o f 가 단사이면 f도 단사이다
example {α β γ : Type} {f : α → β} {g : β → γ}
    (h : Function.Injective (g ∘ f)) :
    Function.Injective f := by
  -- 여기에 증명을 작성하라
```

<details>
<summary>정답 보기</summary>

```lean
example {α β γ : Type} {f : α → β} {g : β → γ}
    (h : Function.Injective (g ∘ f)) :
    Function.Injective f := by
  intro a b hab
  apply h
  -- 목표: g (f a) = g (f b)
  -- hab : f a = f b 이므로 양변에 g를 적용하면 같다
  congr 1
  exact hab
```

</details>

---

## 과제

### 필수 (손으로 풀기)

- 2.1절 연습문제 7, 11, 13, 16 중 **3개**
- 2.2절 연습문제 3, 10, 15, 21 중 **3개**
- 2.3절 연습문제 10, 16, 22, 30 중 **3개**
- 2.4절 연습문제 5, 9, 17, 29 중 **2개**

### 선택 (Lean 4로 확인)

수업 중 [추가 연습]의 `______` 채우기 **5개 이상**

### 권장

2.5절 연습문제 1~2 (유한/셀 수 있는/셀 수 없는 판별)

> **필수 과제는 Lean 없이 손으로 풀어야 한다.**
