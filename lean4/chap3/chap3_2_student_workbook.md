# Chapter 3.2: 함수의 증가 (The Growth of Functions)
## 학생 워크북 (안내 노트)

Rosen 이산수학 8판 §3.2 + Lean 4

> **증명 원칙**: `simp`, `linarith`, `norm_num`을 사용하지 않는다.
> 공리를 `rw`로 직접 호출하여 한 단계씩 전개한다.
> 각 `____` 한 칸 = 전술 또는 값 한 줄.

---

# I — 왜 함수의 증가를 배우는가?

## 핵심 통찰

같은 알고리즘을 비교할 때 앞에 붙은 **\_\_\_\_**는 n이 커지면 중요하지 않게 된다.
중요한 것은 n이 커질수록 함수가 **\_\_\_\_**하는 속도이다.

### Q1. 다음 표를 완성하라 (n = 1,000,000일 때 대략적인 값)

| 함수 | n = 1,000,000일 때 |
|------|-------------------|
| log n | **\_\_\_\_** |
| n | **\_\_\_\_** |
| n log n | **\_\_\_\_** |
| n² | **\_\_\_\_** |
| 2ⁿ | **\_\_\_\_** (폭발적) |

### Q2. 알고리즘 A (1000n 단계)와 알고리즘 B (n² 단계)

| n | A = 1000n | B = n² | 더 빠른 것 |
|---|-----------|--------|-----------|
| 100 | **\_\_\_\_** | **\_\_\_\_** | **\_\_\_\_** |
| 10,000 | **\_\_\_\_** | **\_\_\_\_** | **\_\_\_\_** |

→ n이 **\_\_\_\_** 보다 크면 A가 더 빠르다.

---

# II — Big-O 표기법: 상한 (Upper Bound)

## 정의

> f(n)이 **O(g(n))** 이라 함은, 양의 상수 C와 k가 존재하여
> 모든 n > k에 대해 **|f(n)| ≤ C|g(n)|** 이 성립하는 것이다.

### Q3. 정의의 세 요소를 빈칸으로 채워라

- "양의 상수 C와 k가 존재하여" → 구체적인 **\_\_\_\_**와 **\_\_\_\_**를 찾을 수 있다
- "모든 n > k에 대해" → n이 **\_\_\_\_**할 때
- "|f(n)| ≤ C|g(n)|" → f(n)은 C × g(n)보다 **\_\_\_\_**하다

직관: f(n)은 g(n)보다 **\_\_\_\_** 증가하지 않는다. g(n)이 f(n)의 "**\_\_\_\_**"이다.

## Lean 4 정의

```lean4
import Mathlib

def BigO (f g : Nat → Nat) : Prop :=
  ∃ C : Nat, ∃ k : Nat, C > 0 ∧
    ∀ n : Nat, n > k → f n ≤ C * g n
```

### Q4. Lean 4 정의의 각 줄과 수학 표기를 연결하라

| Lean 4 | 수학 의미 |
|--------|----------|
| `∃ C : Nat, ∃ k : Nat` | **\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_** |
| `C > 0` | **\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_** |
| `∀ n : Nat, n > k →` | **\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_** |
| `f n ≤ C * g n` | **\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_** |

---

# III — Big-O 증명: 3n + 5 는 O(n)

## 수학 증명

**목표**: 3n + 5 = O(n), 즉 적당한 C, k를 찾는다.

C = **\_\_\_\_**, k = **\_\_\_\_** 으로 놓자.

n > **\_\_\_\_** 일 때:

> 3n + 5 ≤ 3n + n = **\_\_\_\_**n    (왜냐하면 n > **\_\_\_\_** 이므로 5 < n)
>
> 따라서 3n + 5 ≤ **\_\_\_\_** × n = C × n ✓

### Q5. Lean 4 rw 증명 — 빈칸을 채워라

```lean4
def BigO (f g : Nat → Nat) : Prop :=
  ∃ C : Nat, ∃ k : Nat, C > 0 ∧
    ∀ n : Nat, n > k → f n ≤ C * g n

theorem linear_bigO :
    BigO (fun n => 3 * n + 5) (fun n => n) := by
  use ____, ____          -- (1) C와 k의 값
  constructor
  · exact ____            -- (2) C > 0 증명 (Nat.succ_pos 또는 rfl)
  · intro n hn
    -- hn : n > k
    -- 목표: 3 * n + 5 ≤ C * n
    rw [____]             -- (3) C * n 전개: 4 * n = n + n + n + n
    -- 목표: 3 * n + 5 ≤ n + n + n + n
    rw [← ____]           -- (4) hn으로부터 5 ≤ n 을 목표에 반영
    ____                  -- (5) Nat.add_le_add 계열로 마무리
```

### Q6. 각 빈칸의 공리 이름과 이유를 적어라

| 위치 | 값 또는 공리 | 이유 |
|------|------------|------|
| (1) C | **\_\_\_\_** | 3n + 5 ≤ C×n 을 만족하는 가장 작은 정수 |
| (1) k | **\_\_\_\_** | 5 < n 이 성립하려면 n > **\_\_\_\_** |
| (2) | **\_\_\_\_** | C > 0 임을 보임 |
| (3) | **\_\_\_\_** | 곱셈을 덧셈으로 전개 |

---

# IV — Big-O 증명: 5n² + 3n + 7 은 O(n²)

## 수학 증명

C = **\_\_\_\_**, k = **\_\_\_\_** 으로 놓자.

n > **\_\_\_\_** 일 때:

> 3n ≤ **\_\_\_\_** (왜냐하면 n ≥ 1이면 3n ≤ 3n²)
>
> 7 ≤ **\_\_\_\_** (왜냐하면 n > 7이면 7 < n ≤ n²)
>
> 따라서 5n² + 3n + 7 ≤ 5n² + n² = **\_\_\_\_**n² ✓

### Q7. Big-O 증명의 일반 전략을 채워라

1. f(n)의 각 항을 **\_\_\_\_**의 배수로 바운드한다.
2. C를 모든 **\_\_\_\_**의 합보다 크게 잡는다.
3. k를 모든 **\_\_\_\_**가 성립할 만큼 크게 잡는다.

---

# V — Big-Omega: 하한 (Lower Bound)

## 정의

> f(n)이 **Ω(g(n))** 이라 함은, 양의 상수 C와 k가 존재하여
> 모든 n > k에 대해 **|f(n)| ≥ C|g(n)|** 이 성립하는 것이다.

Big-O가 "**\_\_\_\_**"이라면, Big-Omega는 "**\_\_\_\_**"이다.

### Q8. Lean 4 정의 — 빈칸을 채워라

```lean4
def BigOmega (f g : Nat → Nat) : Prop :=
  ∃ C : Nat, ∃ k : Nat, C > 0 ∧
    ∀ n : Nat, n > k → f n ____ C * g n    -- (1) 부등호 방향?
```

## 예제: 3n + 5 는 Ω(n)인가?

C = **\_\_\_\_**, k = **\_\_\_\_** 으로 놓으면:

> 3n + 5 ≥ **\_\_\_\_** × n    (모든 n ≥ 0에서 성립) ✓

---

# VI — Big-Theta: 동일한 차수

## 정의

> f(n)이 **Θ(g(n))** 이라 함은, f(n)이 **O(g(n))이면서 동시에 Ω(g(n))**인 것이다.

### Q9. Lean 4 정의 — 빈칸을 채워라

```lean4
def BigTheta (f g : Nat → Nat) : Prop :=
  ____ f g ∧ ____ f g              -- (1) 두 정의를 연결
```

### Q10. 세 표기법 비교표 — 빈칸을 채워라

| 표기법 | 의미 | 비유 | 부등호 |
|--------|------|------|--------|
| O(g(n)) | f는 g보다 느리거나 같다 | **\_\_\_\_** (상한) | ≤ |
| Ω(g(n)) | f는 g보다 빠르거나 같다 | **\_\_\_\_** (하한) | ≥ |
| Θ(g(n)) | f와 g는 같은 속도 | **\_\_\_\_** (양쪽) | = |

---

# VII — 증가 속도 계층

## Q11. 느린 것부터 빠른 순서로 빈칸을 채워라

$$1 \lt \text{\_\_\_\_} \lt \text{\_\_\_\_} \lt \text{\_\_\_\_} \lt \text{\_\_\_\_} \lt \text{\_\_\_\_} \lt 2^n \lt n!$$

| 이름 | 함수 | 대표 알고리즘 |
|------|------|-------------|
| 상수 | O(1) | 배열 인덱스 접근 |
| 로그 | **\_\_\_\_** | 이진 탐색 |
| 선형 | **\_\_\_\_** | 선형 탐색 |
| 선형로그 | **\_\_\_\_** | 병합 정렬 |
| 이차 | **\_\_\_\_** | 버블 정렬 |
| 지수 | **\_\_\_\_** | 부분집합 열거 |

---

# VIII — 계산 규칙

## 합 규칙 (Sum Rule)

> f₁이 O(g₁)이고 f₂가 O(g₂)이면, f₁ + f₂는 O(**\_\_\_\_**)이다.

직관: 두 작업을 순서대로 수행하면, 전체 시간은 더 **\_\_\_\_**쪽이 지배한다.

예: O(n) + O(n²) = **\_\_\_\_**

## 곱 규칙 (Product Rule)

> f₁이 O(g₁)이고 f₂가 O(g₂)이면, f₁ × f₂는 O(**\_\_\_\_**)이다.

예: O(n) × O(n) = **\_\_\_\_** (이중 반복문)

### Q12. 합 규칙 rw 증명 — 빈칸을 채워라 (각 빈칸 = 전술 1줄)

```lean4
theorem sum_rule
    (hf : BigO f1 g) (hg : BigO f2 g) :
    BigO (fun n => f1 n + f2 n) g := by
  obtain ⟨C1, k1, hC1, h1⟩ := hf
  obtain ⟨C2, k2, hC2, h2⟩ := hg
  -- C1, k1 : f1 n ≤ C1 * g n  (n > k1)
  -- C2, k2 : f2 n ≤ C2 * g n  (n > k2)
  use ____, ____              -- (1) 새 C = C1 + C2, 새 k = max k1 k2
  constructor
  · rw [____]                 -- (2) C1 + C2 > 0 을 Nat.add_pos_left로
    exact hC1
  · intro n hn
    -- hn : n > max k1 k2
    have hk1 : n > k1 := ____  -- (3) Nat.lt_of_lt_of_le 계열
    have hk2 : n > k2 := ____  -- (4) 위와 동일
    have ha := h1 n hk1         -- ha : f1 n ≤ C1 * g n
    have hb := h2 n hk2         -- hb : f2 n ≤ C2 * g n
    rw [____]                   -- (5) (C1+C2)*g n = C1*g n + C2*g n
    exact Nat.add_le_add ha hb  -- f1+f2 ≤ C1*g + C2*g
```

---

# 부록 1: 빈칸 정답

## Q1 정답 (n = 1,000,000)

| 함수 | 값 |
|------|----|
| log n | 약 20 |
| n | 1,000,000 |
| n log n | 약 20,000,000 |
| n² | 10¹² |
| 2ⁿ | 폭발적 (사실상 계산 불가) |

## Q2 정답

| n | A = 1000n | B = n² | 더 빠른 것 |
|---|-----------|--------|-----------|
| 100 | 100,000 | 10,000 | B |
| 10,000 | 10,000,000 | 100,000,000 | A |

→ n이 **1,000** 보다 크면 A가 더 빠르다.

## Q3 정답

- 구체적인 **C**와 **k**를 찾을 수 있다
- n이 **충분히 클** 때
- f(n)은 C × g(n)보다 **작거나 같**다
- f(n)은 g(n)보다 **빠르게** 증가하지 않는다. g(n)이 f(n)의 "**천장**"이다.

## Q4 정답

| Lean 4 | 수학 의미 |
|--------|----------|
| `∃ C : Nat, ∃ k : Nat` | 양의 상수 C와 k가 존재하여 |
| `C > 0` | C는 양수 |
| `∀ n : Nat, n > k →` | 모든 n > k에 대해 |
| `f n ≤ C * g n` | f(n) ≤ C × g(n) |

## Q5 정답

```lean4
theorem linear_bigO :
    BigO (fun n => 3 * n + 5) (fun n => n) := by
  use 4, 5
  constructor
  · exact Nat.succ_pos 3        -- 4 = Nat.succ 3, Nat.succ_pos : 0 < n+1
  · intro n hn
    -- hn : n > 5, 목표: 3 * n + 5 ≤ 4 * n
    rw [Nat.mul_comm 4 n]       -- 4 * n → n * 4
    rw [show n * 4 = n + n + n + n from by rw [Nat.mul_succ, Nat.mul_succ, Nat.mul_succ, Nat.mul_one]]
    -- 또는 더 간결하게:
    -- Nat.add_le_add 계열 + hn으로 5 ≤ n
    exact Nat.add_le_add
      (Nat.add_le_add (Nat.le_refl _) (Nat.le_refl _))
      (Nat.le_of_lt hn)
```

실용적인 완전 증명:

```lean4
theorem linear_bigO :
    BigO (fun n => 3 * n + 5) (fun n => n) := by
  use 4, 5
  refine ⟨Nat.succ_pos 3, fun n hn => ?_⟩
  -- hn : 5 < n, 목표: 3 * n + 5 ≤ 4 * n
  have h5n : 5 ≤ n := hn
  calc 3 * n + 5
      ≤ 3 * n + n := Nat.add_le_add_left h5n (3 * n)
    _ = 4 * n     := by rw [← Nat.add_mul]
```

## Q6 정답

| 위치 | 값 또는 공리 | 이유 |
|------|------------|------|
| (1) C | **4** | 3n + 5 ≤ 4n (n > 5) |
| (1) k | **5** | 5 < n이 성립하려면 n > 5 |
| (2) | `Nat.succ_pos 3` | 4 = 3 + 1 > 0 |
| (3) | `← Nat.add_mul` | a*n + b*n = (a+b)*n 역방향 |

## Q7 정답

1. f(n)의 각 항을 **g(n) = nᵐ**의 배수로 바운드한다.
2. C를 모든 **계수**의 합보다 크게 잡는다.
3. k를 모든 **부등식**이 성립할 만큼 크게 잡는다.

## Q8 정답

```lean4
    ∀ n : Nat, n > k → f n ≥ C * g n    -- (1) ≥
```

예: C = **3**, k = **0** 으로 놓으면 3n + 5 ≥ **3** × n ✓

## Q9 정답

```lean4
def BigTheta (f g : Nat → Nat) : Prop :=
  BigO f g ∧ BigOmega f g
```

## Q10 정답

| 표기법 | 비유 |
|--------|------|
| O(g(n)) | **천장** |
| Ω(g(n)) | **바닥** |
| Θ(g(n)) | **구간** |

## Q11 정답

$$1 \lt \log n \lt n \lt n\log n \lt n^2 \lt n^3 \lt 2^n \lt n!$$

| 이름 | 함수 |
|------|------|
| 로그 | O(log n) |
| 선형 | O(n) |
| 선형로그 | O(n log n) |
| 이차 | O(n²) |
| 지수 | O(2ⁿ) |

## Q12 정답

```lean4
  use C1 + C2, max k1 k2
  constructor
  · rw [Nat.add_comm]             -- C1 + C2 = C2 + C1, 양수 + 양수
    exact Nat.add_pos_left hC2 C1
  · intro n hn
    have hk1 : n > k1 := Nat.lt_of_lt_of_le (Nat.lt_max_left k1 k2) hn
    have hk2 : n > k2 := Nat.lt_of_lt_of_le (Nat.lt_max_right k1 k2) hn
    have ha := h1 n hk1
    have hb := h2 n hk2
    rw [← Nat.add_mul]
    exact Nat.add_le_add ha hb
```

---

# 부록 2: 연습 문제

**문제 1.** f(n) = 2n + 1이 O(n)임을 수학적으로 증명하라. C와 k 값을 제시한다.

<details>
<summary>정답 보기</summary>

C = 3, k = 1로 놓자. n > 1일 때: 2n + 1 ≤ 2n + n = 3n. ✓

</details>

---

**문제 2.** 다음 각 명제의 참·거짓을 판별하라.

| 명제 | 참/거짓 |
|------|--------|
| n² + n은 O(n²) | **\_\_\_\_** |
| n³은 O(n²) | **\_\_\_\_** |
| 2ⁿ은 O(n¹⁰⁰) | **\_\_\_\_** |
| log n은 O(n) | **\_\_\_\_** |
| n은 O(n log n) | **\_\_\_\_** |

<details>
<summary>정답 보기</summary>

| 명제 | 참/거짓 | 이유 |
|------|--------|------|
| n² + n은 O(n²) | 참 | n ≤ n²이므로 n² + n ≤ 2n² |
| n³은 O(n²) | **거짓** | n³/n² = n → 무한히 커짐 |
| 2ⁿ은 O(n¹⁰⁰) | **거짓** | 지수는 어떤 다항식보다 빠름 |
| log n은 O(n) | 참 | 로그는 선형보다 느림 |
| n은 O(n log n) | 참 | n ≤ n log n (n ≥ 2) |

</details>

---

**문제 3.** Lean 4 코드의 빈칸을 채워 2n + 1이 O(n)임을 증명하라.

```lean4
theorem exercise_bigO :
    BigO (fun n => 2 * n + 1) (fun n => n) := by
  use ____, ____
  refine ⟨____, fun n hn => ?_⟩
  have h1n : 1 ≤ n := ____
  calc 2 * n + 1
      ≤ 2 * n + n := ____
    _ = ____ * n  := by rw [← Nat.add_mul]
```

<details>
<summary>정답 보기</summary>

```lean4
theorem exercise_bigO :
    BigO (fun n => 2 * n + 1) (fun n => n) := by
  use 3, 1
  refine ⟨Nat.succ_pos 2, fun n hn => ?_⟩
  have h1n : 1 ≤ n := hn
  calc 2 * n + 1
      ≤ 2 * n + n := Nat.add_le_add_left h1n (2 * n)
    _ = 3 * n     := by rw [← Nat.add_mul]
```

- `use 3, 1`: C = 3, k = 1
- `Nat.succ_pos 2`: 3 = 2 + 1 > 0
- `hn : n > 1` → `1 ≤ n`
- `← Nat.add_mul`: `2*n + 1*n = (2+1)*n = 3*n`

</details>

---

**문제 4.** O, Ω, Θ 중 어느 것이 가장 강한(정보가 많은) 표기법인지 설명하라.

<details>
<summary>정답 보기</summary>

Θ가 가장 강하다. Θ(g)는 O(g)와 Ω(g)를 **동시에** 만족하므로 f와 g가 정확히 같은 차수임을 알 수 있다. O(g)만으로는 f가 g보다 훨씬 느릴 수도 있어 정보가 부족하다.

</details>
