# Chapter 1. 논리와 증명의 기초 -- Lean 4로 증명하기

> 교재: Rosen, Discrete Mathematics and Its Applications, 8판
> 범위: 1.1 명제 논리 ~ 1.8 증명 방법과 전략

---

# Part 0. Lean 4 최소 도입

## 0.1 Lean 4란?

Lean 4는 수학 증명을 컴퓨터가 검사하는 도구이다. 맞춤법 검사기가 글자를 검사하듯, Lean은 논리를 검사한다. 틀리면 빨간 줄, 맞으면 아무 표시 없음.

## 0.2 화면 구조

```
┌──────────────────────────┬──────────────────────┐
│  코드 입력 (편집 창)     │  Lean InfoView       │
│                          │                      │
│  example : 2 + 2 = 4 :=  │  ⊢ 2 + 2 = 4         │
│    by rfl                │                      │
└──────────────────────────┴──────────────────────┘
```

핵심 기호 ⊢ (턴스타일):
- ⊢ 위에 있는 것 = 재료 (가정)
- ⊢ 아래에 있는 것 = 목표 (증명해야 할 것)
- 커서를 이동하면 목표가 바뀐다

## 0.3 증명의 기본 틀

```lean
import Mathlib.Tactic  -- 파일 맨 위에 반드시 필요!

theorem 이름 : 명제 := by
  전술1
  전술2
```

- `import Mathlib.Tactic`: 이 줄이 파일 맨 위에 있어야 linarith, ring, omega, by_contra, by_cases 등 대부분의 전술을 쓸 수 있다. 없으면 "unknown tactic" 오류가 뜬다.
- `theorem`: 정리를 선언한다
- `:` 뒤: 무엇을 증명할지
- `by`: 전술 모드로 증명 시작
- 전술을 쓸 때마다 InfoView의 목표가 바뀌거나 사라진다. 전부 사라지면 증명 완료.

## 0.4 핵심 전술 요약표

| 전술 | 언제 쓰는가 | 비유 |
|------|-----------|------|
| `intro h` | 목표가 A → B 또는 ∀ x, P x 일 때 | "A라고 가정하자" |
| `exact h` | h가 목표와 정확히 같을 때 | "이것이 답이다" |
| `constructor` | 목표가 A ∧ B 또는 A ↔ B 일 때 | "둘로 쪼갠다" |
| `cases h` | h가 A ∨ B 일 때 | "경우를 나눈다" |
| `left` / `right` | 목표가 A ∨ B 일 때 | "왼쪽/오른쪽을 선택" |
| `use 값` | 목표가 ∃ x, P x 일 때 | "이 값이 증거다" |
| `obtain ⟨a, ha⟩ := h` | 가정 h가 ∃ x, P x 일 때 | "상자를 열어 꺼낸다" |
| `rfl` | 양쪽을 계산하면 같을 때 | "같은 건 같다" |
| `rw [h]` | h : A = B 로 치환할 때 | "A를 B로 바꿔치기" |
| `ring` | 대수 등식일 때 | "계산으로 끝" |
| `decide` | 유한하게 계산 가능할 때 | "직접 계산해봐" |
| `omega` | 정수/자연수 산술일 때 | "정수 계산 자동" |
| `linarith` | 선형 부등식일 때 | "부등식 자동" |
| `by_cases hp : P` | 배중률로 분기할 때 | "P가 참이거나 거짓이거나" |
| `by_contra hnp` | 귀류법을 쓸 때 | "아니라고 가정하면 모순" |

## 0.5 탐문 도구

```lean
#check 2 + 2       -- 타입 확인: 2 + 2 : Nat
#eval 2 + 2        -- 값 계산: 4
```

## 0.6 sorry -- 판단의 보류

```lean
theorem difficult (a b : ℝ) : a^2 + b^2 ≥ 0 := by
  sorry   -- 노란 경고: 'declaration uses sorry'
```

sorry를 쓰면 Lean은 그 부분을 검사하지 않고 넘어간다. 참이라고 판정하는 것도 아니고, 거짓이라고 판정하는 것도 아니다. 판단 자체를 보류한다.

```
sorry 없이 증명 완료 → Lean이 "참이다"라고 판단
증명이 틀림         → Lean이 "틀렸다"라고 판단 (빨간 줄)
sorry 사용          → Lean이 판단하지 않음 (노란 경고)
```

sorry가 없는 증명만이 "Lean이 검증 완료한 증명"이다.

---

# Part 1. 명제 논리 (Rosen 1.1 ~ 1.3)

## 1.1 부정 ¬ (Negation)

¬P = "P가 아니다"

| p | ¬p |
|---|-----|
| T | F |
| F | T |

### Lean에서 ¬P = P → False

이것은 "P가 참이라고 가정하면, False(모순)를 만들어낼 수 있다"는 뜻이다. False는 절대로 참이 될 수 없는 명제이다. False를 만들어냈다는 것은 가정 자체가 잘못되었다는 뜻이다.

단계별로 풀어보면:

1. False는 "절대로 참이 될 수 없는 명제"이다.
2. P → False는 "P가 참이라고 가정하면 False를 만들어낼 수 있다"이다.
3. False를 만들어냈다는 것은 가정(P가 참)이 잘못되었다는 뜻이다.
4. 따라서 P는 거짓이다. 즉 ¬P이다.

이것이 수학에서 귀류법(proof by contradiction)이다. Lean은 귀류법을 ¬의 정의 자체로 채택한 것이다.

```lean
example : ¬ (2 = 3) := by
  intro h          -- h : 2 = 3 이라고 가정
                   -- 목표가 False로 바뀜
  exact absurd h (by decide)
```

InfoView 변화:

```
intro h 전:   ⊢ ¬(2 = 3)
            = ⊢ (2 = 3) → False    ← Lean이 ¬를 풀어서 읽음

intro h 후:   h : 2 = 3             ← "가정했다"
              ⊢ False               ← "이제 모순을 만들어라"
```

### 연습 1-1

```lean
example (P : Prop) (hnp : ¬P) (hp : P) : False := by
  sorry
```

<details>
<summary>힌트</summary>

¬P는 P → False와 같다. hnp에 hp를 적용하면 된다.

</details>

<details>
<summary>정답 보기</summary>

```lean
example (P : Prop) (hnp : ¬P) (hp : P) : False := by
  exact hnp hp
```

hnp : P → False에 hp : P를 넣으면 False가 나온다.

</details>

---

## 1.2 논리곱 ∧ (Conjunction)

P ∧ Q = "P 그리고 Q" (둘 다 참이어야 참)

| p | q | p ∧ q |
|---|---|-------|
| T | T | T |
| T | F | F |
| F | T | F |
| F | F | F |

```lean
-- ∧ 만들기: constructor로 쪼갠 뒤 각각 증명
example (P Q : Prop) (hp : P) (hq : Q) : P ∧ Q := by
  constructor
  · exact hp     -- 첫 번째 목표: P
  · exact hq     -- 두 번째 목표: Q

-- ∧ 꺼내기: h.left (= h.1), h.right (= h.2)
example (P Q : Prop) (h : P ∧ Q) : P := by
  exact h.left
```

### 연습 1-2

```lean
example (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by
  constructor
  · exact h.right
  · exact h.left
```

</details>

---

## 1.3 논리합 ∨ (Disjunction)

P ∨ Q = "P 또는 Q" (하나만 참이어도 참)

| p | q | p ∨ q |
|---|---|-------|
| T | T | T |
| T | F | T |
| F | T | T |
| F | F | F |

```lean
-- ∨ 만들기: left 또는 right로 선택
example (P Q : Prop) (hp : P) : P ∨ Q := by
  left
  exact hp

-- ∨ 사용하기: cases로 경우 나눔
example (P Q R : Prop) (h : P ∨ Q) (hp : P → R) (hq : Q → R) : R := by
  cases h with
  | inl p => exact hp p    -- P인 경우
  | inr q => exact hq q    -- Q인 경우
```

### ∨에서 constructor를 쓰지 않는 이유

∧는 "둘 다 필요하다"이므로 쪼개서 각각 채운다 (constructor). ∨는 "하나만 있으면 된다"이므로 고르는 것이다 (left/right). 쪼개는 것이 아니라 선택하는 것이다.

```
∧ (그리고) = 둘 다 채워야 완성    → constructor로 쪼개서 각각 채운다
∨ (또는)  = 하나만 고르면 됨      → left(왼쪽) 또는 right(오른쪽)로 선택
```

### cases h with 해석

```lean
cases hpq with
| inl hp => exact absurd hp hnp    -- p인 경우
| inr hq => exact hq               -- q인 경우
```

한 줄씩 풀어보면:

- `cases hpq with`: hpq : P ∨ Q를 경우별로 나눈다. 어느 쪽인지 모르니 둘 다 처리한다.
- `| inl hp =>`: inl은 "injection left"(왼쪽). P인 경우를 뜻한다. hp는 그 증거의 이름.
- `| inr hq =>`: inr은 "injection right"(오른쪽). Q인 경우를 뜻한다.

### 연습 1-3

```lean
example (P Q : Prop) (h : P ∨ Q) : Q ∨ P := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (P Q : Prop) (h : P ∨ Q) : Q ∨ P := by
  cases h with
  | inl hp => right; exact hp
  | inr hq => left; exact hq
```

</details>

---

## 1.4 배타적 논리합 ⊕ (Exclusive Or)

P ⊕ Q = "P 또는 Q, 단 둘 다는 아님"

| p | q | p ⊕ q |
|---|---|-------|
| T | T | F |
| T | F | T |
| F | T | T |
| F | F | F |

∨(포괄적)와의 차이: ∨는 둘 다 참이어도 참이지만, ⊕는 둘 다 참이면 거짓이다.

정의: P ⊕ Q = (P ∧ ¬Q) ∨ (¬P ∧ Q)

```lean
#eval xor true true    -- false
#eval xor true false   -- true

-- ⊕이면 ∨도 성립
example (P Q : Prop) (h : Xor' P Q) : P ∨ Q := by
  cases h with
  | inl hpnq => left; exact hpnq.left
  | inr hnpq => right; exact hnpq.right
```

---

## 1.5 조건문 → (Implication)

P → Q = "P이면 Q"

| p | q | p → q |
|---|---|-------|
| T | T | T |
| T | F | F |
| F | T | T |
| F | F | T |

p가 거짓일 때 항상 참인 것을 "공허한 참(vacuous truth)"이라 한다.

```lean
-- → 증명: intro로 가정
-- → 사용: 함수 적용 (긍정 논법, Modus Ponens)
example (P Q : Prop) (h : P → Q) (hp : P) : Q := by
  exact h hp     -- h에 hp를 적용하면 Q가 나온다
```

역, 대우, 이:

```
원래:  P → Q
역:    Q → P
대우:  ¬Q → ¬P   (원래와 논리적 동치!)
이:    ¬P → ¬Q
```

### 연습 1-5

```lean
-- 대우 증명
example (P Q : Prop) (h : P → Q) : ¬Q → ¬P := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (P Q : Prop) (h : P → Q) : ¬Q → ¬P := by
  intro hnq hp
  exact hnq (h hp)
```

intro hnq: ¬Q를 가정. intro hp: P를 가정. h hp: P → Q에 P를 넣어서 Q. hnq (h hp): ¬Q에 Q를 넣어서 False. 모순.

</details>

---

## 1.6 쌍조건문 ↔ (Biconditional)

P ↔ Q = "P이면 Q이고, Q이면 P" (양방향)

| p | q | p ↔ q |
|---|---|-------|
| T | T | T |
| T | F | F |
| F | T | F |
| F | F | T |

```lean
-- ↔ 증명: constructor로 양방향 각각
example (P Q : Prop) (hpq : P → Q) (hqp : Q → P) : P ↔ Q := by
  constructor
  · exact hpq    -- 정방향
  · exact hqp    -- 역방향

-- ↔ 사용: h.mp (정방향 P → Q), h.mpr (역방향 Q → P)
```

---

## 1.7 논리 연산자 우선순위

| 순위 | 연산자 | 이름 |
|------|--------|------|
| 1 (높음) | ¬ | 부정 |
| 2 | ∧ | 논리곱 |
| 3 | ∨ | 논리합 |
| 4 | → | 조건문 |
| 5 (낮음) | ↔ | 쌍조건문 |

예: `¬p ∧ q` = `(¬p) ∧ q` (부정이 먼저)

---

## 1.8 논리 회로

디지털 회로에서 논리 연산자는 물리적 게이트로 구현된다. 스위치가 켜지면 1(T), 꺼지면 0(F)이다.

- Inverter (NOT): 입력 p를 받아서 ¬p를 출력. 1이 들어오면 0, 0이 들어오면 1.
- OR 게이트: 입력 p, q를 받아서 p ∨ q를 출력. 하나라도 1이면 1.
- AND 게이트: 입력 p, q를 받아서 p ∧ q를 출력. 둘 다 1이어야 1.

여러 게이트를 연결하면 복합 명제를 회로로 구현할 수 있다. CPU의 덧셈기, 비교기, 메모리 제어 장치가 전부 이 게이트들의 조합이다.

---

# Part 2. 논리적 동치 (Rosen 1.3)

## 2.1 드모르간 법칙

### 제1법칙: ¬(p ∨ q) ≡ ¬p ∧ ¬q

"또는의 부정" = "둘 다 아니다"

진리표 증명:

```
p | q | p ∨ q | ¬(p ∨ q) | ¬p | ¬q | ¬p ∧ ¬q
T | T |   T   |    F     |  F |  F |    F
T | F |   T   |    F     |  F |  T |    F
F | T |   T   |    F     |  T |  F |    F
F | F |   F   |    T     |  T |  T |    T
```

모든 행에서 ¬(p ∨ q)와 ¬p ∧ ¬q가 같다.

Lean 증명:

```lean
example (P Q : Prop) : ¬(P ∨ Q) ↔ (¬P ∧ ¬Q) := by
  constructor
  · intro h
    constructor
    · intro hp; apply h; left; exact hp
    · intro hq; apply h; right; exact hq
  · intro h hpq
    cases hpq with
    | inl hp => exact h.left hp
    | inr hq => exact h.right hq
```

### 제2법칙: ¬(p ∧ q) ≡ ¬p ∨ ¬q

"그리고의 부정" = "적어도 하나가 아니다"

Lean 증명 (정방향에 by_cases 필요 -- 고전 논리):

```lean
example (P Q : Prop) : ¬(P ∧ Q) ↔ (¬P ∨ ¬Q) := by
  constructor
  · intro h
    by_cases hp : P
    · right; intro hq; apply h; exact ⟨hp, hq⟩
    · left; exact hp
  · intro h hpq
    cases h with
    | inl hnp => exact hnp hpq.left
    | inr hnq => exact hnq hpq.right
```

두 법칙의 차이: 제1법칙은 직관주의 논리로 증명 가능하지만, 제2법칙의 정방향은 배중률(by_cases)이 필요하다.

---

## 2.2 논리적 동치 단계별 증명 예제

### 증명 대상: ¬(p ∨ (¬p ∧ q)) ≡ ¬p ∧ ¬q

```
¬(p ∨ (¬p ∧ q))
≡ ¬p ∧ ¬(¬p ∧ q)           -- 1단계: 드모르간 1
≡ ¬p ∧ [¬(¬p) ∨ ¬q]       -- 2단계: 드모르간 2
≡ ¬p ∧ (p ∨ ¬q)            -- 3단계: 이중 부정
≡ (¬p ∧ p) ∨ (¬p ∧ ¬q)    -- 4단계: 분배 법칙
≡ F ∨ (¬p ∧ ¬q)            -- 5단계: 모순 (¬p ∧ p = F)
≡ (¬p ∧ ¬q) ∨ F            -- 6단계: 교환 법칙
≡ ¬p ∧ ¬q                  -- 7단계: 항등 법칙 (A ∨ F = A)
```

5단계에서 ¬p ∧ p가 F가 되는 이유: "p가 아니면서 동시에 p이다"는 절대로 참이 될 수 없다. Lean에서는 h.left : ¬p와 hp : p가 동시에 있으면, exact h.left hp로 False가 나오고 이 경우는 불가능하므로 자동으로 닫힌다.

---

## 2.3 이중 부정

```lean
example (P : Prop) : ¬¬P ↔ P := by
  constructor
  · intro hnnp
    by_contra hnp
    exact hnnp hnp
  · intro hp
    intro hnp
    exact hnp hp
```

---

# Part 3. 술어 논리 (Rosen 1.4 ~ 1.5)

## 3.1 전칭 한정자 ∀

∀ x, P x = "모든 x에 대해 P(x)가 성립한다"

```lean
example : ∀ n : Nat, n + 0 = n := by
  intro n    -- 임의의 n 하나를 꺼냄
  rfl
```

## 3.2 존재 한정자 ∃

∃ x, P x = "P(x)를 만족하는 x가 적어도 하나 존재한다"

```lean
example : ∃ n : Nat, n > 3 := by
  use 4        -- 4를 증거로 제시
  decide
```

## 3.3 한정기호 부정

| 원래 | 부정 |
|------|------|
| ¬(∀ x, P x) | ∃ x, ¬P x |
| ¬(∃ x, P x) | ∀ x, ¬P x |

Lean에서는 `push_neg`이 이 변환을 자동으로 한다.

---

# Part 4. 추론 규칙 (Rosen 1.6)

## 4.1 긍정 논법 (Modus Ponens)

p, p → q ∴ q -- "p가 참이고, p이면 q이다. 따라서 q이다."

```lean
example (p q : Prop) (hp : p) (hpq : p → q) : q := by
  exact hpq hp
```

```
hpq : p → q    "p를 주면 q를 내놓는 함수"
hp  : p        "p가 참이라는 증거"
hpq hp : q     "함수에 값을 넣으면 q가 나온다"
```

## 4.2 부정 논법 (Modus Tollens)

¬q, p → q ∴ ¬p -- "q가 아니고, p이면 q이다. 따라서 p가 아니다."

```lean
example (p q : Prop) (hnq : ¬q) (hpq : p → q) : ¬p := by
  intro hp
  exact hnq (hpq hp)
```

```
hp          : p          "p가 참이다"
hpq hp      : q          "p → q에 p를 넣으면 q"
hnq (hpq hp): False      "¬q에 q를 넣으면 False"
```

## 4.3 가설적 삼단논법 (Hypothetical Syllogism)

p → q, q → r ∴ p → r -- "p이면 q이고, q이면 r이다. 따라서 p이면 r이다."

```lean
example (p q r : Prop) (hpq : p → q) (hqr : q → r) : p → r := by
  intro hp
  exact hqr (hpq hp)
```

```
p ──→ hpq ──→ q ──→ hqr ──→ r
      (p→q)          (q→r)
```

## 4.4 논리합 삼단논법 (Disjunctive Syllogism)

p ∨ q, ¬p ∴ q -- "p이거나 q이다. 그런데 p가 아니다. 따라서 q이다."

```lean
example (p q : Prop) (hpq : p ∨ q) (hnp : ¬p) : q := by
  cases hpq with
  | inl hp => exact absurd hp hnp
  | inr hq => exact hq
```

p인 경우: ¬p와 p가 동시에 존재 → 모순 → absurd로 처리 (이 경우는 불가능)
q인 경우: q가 바로 있다 → exact hq

### absurd와 폭발 원리

`absurd hp hnp`에서 일어나는 일:

```
hp  : p       "p가 참이다"
hnp : ¬p      "p가 아니다" (= p → False)
hnp hp : False "¬p에 p를 넣으면 False"
absurd hp hnp : q  "False가 나왔으므로 무엇이든 증명 가능"
```

이것을 "폭발 원리(ex falso quodlibet)"라고 한다. 모순이 발생하면 어떤 명제든 증명할 수 있다. 위험하게 들리지만, 실제로는 "이 경우는 애초에 도달할 수 없다"는 것을 확인하는 용도로만 쓰인다.

## 4.5 나머지 추론 규칙

| 가산 논법 | p ∴ p ∨ q | `left; exact hp` |
|----------|-----------|-----------------|
| 단순화 논법 | p ∧ q ∴ p | `exact h.left` |
| 논리곱 논법 | p, q ∴ p ∧ q | `constructor; exact hp; exact hq` |

---

## 4.6 by_cases와 by_contra

```lean
-- by_cases: 배중률. P가 참이거나 거짓이거나.
example (P Q : Prop) (h : P → Q) : ¬P ∨ Q := by
  by_cases hp : P
  · right; exact h hp     -- P가 참인 경우
  · left; exact hp         -- P가 거짓인 경우

-- by_contra: 귀류법. 결론의 부정을 가정하고 모순을 찾는다.
example (P : Prop) (hnnp : ¬¬P) : P := by
  by_contra hnp
  exact hnnp hnp
```

---

# Part 5. 증명 방법 (Rosen 1.7 ~ 1.8)

## 5.1 직접 증명 (Direct Proof)

P → Q를 증명하려면, P를 가정하고 Q를 보인다.

### 예제: "n이 짝수이면, n + 2도 짝수이다"

```lean
example (n : ℤ) (h : ∃ k, n = 2*k) : ∃ m, n+2 = 2*m := by
  obtain ⟨k, hk⟩ := h    -- 상자를 열어 k와 hk를 꺼냄
  use k + 1               -- m = k + 1을 증거로 제시
  rw [hk]                 -- n을 2k로 치환
  ring                    -- 2k + 2 = 2(k + 1) 계산으로 확인
```

단계별 InfoView:

```
by 뒤:       h : ∃ k, n = 2 * k    ⊢ ∃ m, n + 2 = 2 * m
obtain 후:   k : ℤ, hk : n = 2*k   ⊢ ∃ m, n + 2 = 2 * m
use k+1 후:                         ⊢ n + 2 = 2 * (k + 1)
rw [hk] 후:                         ⊢ 2*k + 2 = 2 * (k + 1)
ring 후:     No goals
```

손 증명과의 대응:

```
손 증명                          Lean 증명
n = 2k인 k가 존재한다            obtain ⟨k, hk⟩ := h
m = k + 1로 놓으면               use k + 1
n + 2 = 2k + 2                  rw [hk]
     = 2(k + 1)                 ring
```

## 5.2 대우 증명 (Proof by Contraposition)

P → Q 대신 ¬Q → ¬P를 증명한다.

```lean
example (P Q : Prop) (h : ¬Q → ¬P) : P → Q := by
  intro hp
  by_contra hnq
  exact h hnq hp
```

## 5.3 모순 증명 (Proof by Contradiction)

결론의 부정을 가정하고 모순을 유도한다.

```lean
example (P : Prop) (h : ¬P → False) : P := by
  by_contra hnp
  exact h hnp
```

---

# Part 6. 존재 증명 (Rosen 1.8)

## 6.1 생산적 존재 증명 (Constructive)

"여기 있다. 이것이 증거다." -- 구체적인 값을 직접 보여준다.

```lean
example : ∃ n : Nat, n > 3 := by
  use 4
  decide
```

## 6.2 비생산적 존재 증명 (Nonconstructive)

"있긴 한데, 뭔지는 안 알려준다." -- 없다고 가정하면 모순이 생김을 보여준다.

비유: "이 건물에 화장실이 있다"를 증명할 때, 생산적 증명은 "3층 왼쪽 복도 끝에 있습니다"이고, 비생산적 증명은 "없다고 가정하면 건축법 위반입니다. 모순이니까 있습니다"이다.

## 6.3 obtain: 존재 가정을 풀어 쓰기

```lean
example (n : ℤ) (h : ∃ k, n = 2*k) : ∃ m, n + 2 = 2*m := by
  obtain ⟨k, hk⟩ := h     -- k와 hk : n = 2*k를 꺼냄
  use k + 1
  rw [hk]; ring
```

## 6.4 반례 (Counterexample)

∀ 명제가 거짓임을 보이려면 반례 하나를 찾는다.

```lean
example : ∃ n : Nat, n % 2 ≠ 0 := by
  use 3
  decide
```

### 연습 6-1

```lean
example : ∃ n : Nat, n > 10 ∧ n % 2 = 0 := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : ∃ n : Nat, n > 10 ∧ n % 2 = 0 := by
  use 12
  constructor <;> decide
```

</details>

### 연습 6-2

```lean
example (P Q : Nat → Prop) (h1 : ∀ x, P x → Q x) (h2 : ∃ a, P a) : ∃ b, Q b := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (P Q : Nat → Prop) (h1 : ∀ x, P x → Q x) (h2 : ∃ a, P a) : ∃ b, Q b := by
  obtain ⟨a, ha⟩ := h2
  use a
  exact h1 a ha
```

</details>

### 연습 6-3

```lean
-- 짝수의 합
example (a b : ℤ) (ha : ∃ k, a = 2*k) (hb : ∃ l, b = 2*l)
    : ∃ m, a + b = 2*m := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (a b : ℤ) (ha : ∃ k, a = 2*k) (hb : ∃ l, b = 2*l)
    : ∃ m, a + b = 2*m := by
  obtain ⟨k, hk⟩ := ha
  obtain ⟨l, hl⟩ := hb
  use k + l
  rw [hk, hl]; ring
```

</details>

---

# Part 7. 유일성 증명 (Rosen 1.8)

## 7.1 유일 존재란?

∃! x, P(x) = "P(x)를 만족하는 x가 존재하고, 딱 하나뿐이다."

증명은 항상 2단계이다.

```
(1) 존재: P(a)를 만족하는 a를 찾는다
(2) 유일: P(a)도 만족하고 P(b)도 만족하면, a = b임을 보인다
```

## 7.2 Lean에서 유일성 증명 패턴

이 틀은 변하지 않는다:

```lean
example : ∃! x : Nat, x + 3 = 5 := by
  use 2                     -- (1) 존재: x = 2
  constructor
  · rfl                     -- 2 + 3 = 5 확인
  · intro y hy              -- (2) 유일: y + 3 = 5인 y를 가정
    omega                   -- y = 2 자동 계산
```

InfoView 추적:

```
use 2 후:       ⊢ 2 + 3 = 5 ∧ ∀ y, y + 3 = 5 → y = 2
constructor 후: ⊢ 2 + 3 = 5 (존재)  /  ⊢ ∀ y, y + 3 = 5 → y = 2 (유일)
rfl 후:         첫 번째 끝
intro y hy 후:  y : Nat, hy : y + 3 = 5, ⊢ y = 2
omega 후:       No goals
```

### 연습 7-1

```lean
example : ∃! x : Nat, x + 5 = 8 := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : ∃! x : Nat, x + 5 = 8 := by
  use 3
  constructor
  · rfl
  · intro y hy
    omega
```

</details>

### 연습 7-2

```lean
example : ∃! x : Nat, 3 * x = 15 := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : ∃! x : Nat, 3 * x = 15 := by
  use 5
  constructor
  · rfl
  · intro y hy
    omega
```

</details>

---

# Part 8. 왜 컴퓨터가 수학 증명을 검사해야 하는가

## 8.1 모순이 들어오면 무슨 일이 일어나는가

논리 체계 안에 모순이 하나 들어온다고 하자. P이면서 동시에 P가 아니다.

P가 참이니까 "P 또는 Q"도 참이다. 그런데 P가 아니라고도 했으니까, "P 또는 Q"에서 P는 탈락한다. 남는 것은 Q이다. Q에 아무거나 넣어도 이 추론은 성립한다.

이것이 폭발 원리이다. 모순 하나가 들어오면 아무 명제나 증명 가능해진다.

## 8.2 "모든 것이 참이 된다"는 반쪽짜리 설명이다

모든 명제가 증명 가능해지면, P도 증명되고 ¬P도 증명된다. P가 참이면서 동시에 거짓이다. "참"이라는 말이 의미가 없어진다. 맞는 것과 틀린 것을 가려내는 기능이 사라진다.

## 8.3 그래서 모순은 절대로 들어와서는 안 된다

사람은 실수한다. 모순을 실수로 끼워넣을 수 있고, 끼워넣었는지 모를 수 있다.

Lean 4는 증명의 매 줄을 검사하여 모순이 들어오지 못하게 막는다. sorry는 아직 검사하지 못한 부분을 표시하여 판단을 보류한다. sorry가 없는 증명만이 "모순이 없다"는 보증을 받는다.

폭발 원리는 체계 안에 존재하지만, 모순 자체가 들어올 수 없으므로 발동할 일이 없다.

이것이 Lean 4가 존재하는 이유이다. 맞는 것과 틀린 것의 구분을 지키는 것.

---

# 부록: 전술 총정리표

## 연산자별 Lean 패턴

| 연산자 | 만들기 (증명하기) | 사용하기 (꺼내기) |
|--------|----------------|----------------|
| ¬ | `intro h` + 모순 도출 | `exact hnp hp` |
| ∧ | `constructor` | `h.left`, `h.right` |
| ∨ | `left` / `right` | `cases h with` |
| → | `intro h` | `exact h x` |
| ↔ | `constructor` (양방향) | `h.mp`, `h.mpr` |
| ∀ | `intro x` | `h x` (값 대입) |
| ∃ | `use a` | `obtain ⟨a, ha⟩ := h` |
| ∃! | `use a; constructor` | (존재 + 유일 분해) |

## 증명 방법별 Lean 패턴

| 증명 방법 | Lean 패턴 |
|----------|----------|
| 직접 증명 | `intro → 계산 → exact` |
| 대우 증명 | `by_contra` |
| 모순 증명 | `by_contra → 모순 도출` |
| 경우 분류 | `by_cases hp : P` |
| 존재 증명 | `use 값` |
| 유일성 증명 | `use; constructor; 존재; intro y hy; 유일` |

## 자동 전술

| 전술 | 해결하는 것 |
|------|-----------|
| `rfl` | 양쪽 계산해서 같음 |
| `ring` | 대수 등식 |
| `omega` | 정수/자연수 산술 |
| `decide` | 유한 계산 가능 |
| `linarith` | 선형 부등식 |
| `norm_num` | 수치 계산 |

---

# 과제

## 필수

1. 연습 1~5 중 2개 이상 직접 VS Code에서 풀기
2. 연습 6-1, 6-2 (존재 증명) 풀기
3. 연습 7-1, 7-2 (유일성 증명) 풀기

## 권장

4. 드모르간 법칙 제2법칙 (연습 5) 직접 증명
5. 연습 6-3 짝수의 합 증명
6. lean4_tutorial_part4_1.md 추가 연습 3개

## 참고 자료

- 기호 사전: lean4_tutorial_dict.md
- 전술 상세: lean4_tutorial_part3.md
- 논리적 동치: lean4_tutorial_part4_2.md
- 술어 논리 심화: lean4_tutorial_part4_3.md
- 증명 방법 심화: lean4_tutorial_part4_4.md, lean4_tutorial_part4_5.md
