# sqrt(2) 무리수 증명 — 손 증명에서 Lean 4까지
## 귀류법, 보조정리(lemma), 그리고 Mathlib의 힘

> **대상**: 수학적 증명을 처음 접하는 중학생 ~ 학부생  
> **선수 지식**: Lean 4 기본 문법 (theorem, by, 전술의 개념)  
> **핵심 목표**: 귀류법의 구조를 이해하고, lemma와 theorem의 관계를 체득한다  

---

## 목차

| 절 | 제목 | 핵심 내용 |
|----|------|-----------|
| 0 | 왜 sqrt(2)인가? | 이 증명이 중요한 이유 |
| 1 | 귀류법이란 무엇인가 | 직접 증명 vs 귀류법 |
| 2 | 손 증명 5단계 완전 해부 | 수학적 추론의 흐름 |
| 3 | Lean 4 전술 1:1 대응표 | 손 증명 -> Lean 전술 매칭 |
| 4 | 보조정리(lemma)와 정리(theorem) | 벽돌과 건물의 관계 |
| 5 | if(->)와 if and only if(<->) | 단방향 vs 양방향 |
| 6 | Lean 4 코드: 기초부터 완성까지 | 단계별 코드 작성 |
| 7 | Mathlib 한 줄의 의미 | 라이브러리의 힘 |
| 8 | 연습 문제 (3단계) | 빈칸 -> sorry -> 자유 증명 |

---

# 0. 왜 sqrt(2)인가?

고대 그리스의 피타고라스 학파는 "모든 수는 정수의 비(ratio)로 나타낼 수 있다"고 믿었다. 즉, 모든 수가 **유리수**(rational number)라고 생각한 것이다.

그런데 한 변의 길이가 1인 정사각형의 대각선 길이가 sqrt(2)임을 알게 되었고, 이것이 유리수로 표현될 수 없다는 사실이 발견되었다. 이것은 피타고라스 학파의 근본 신념을 뒤흔든 사건이었다.

이 증명은 다음 세 가지 이유로 형식 증명 입문에 최적이다:

1. **귀류법**(proof by contradiction)의 대표적 사례이다
2. **보조정리**(lemma)를 만들어 재사용하는 구조가 명확하다
3. 손 증명의 매 단계가 Lean 4 전술과 **1:1 대응**한다

---

# 1. 귀류법(Proof by Contradiction)이란 무엇인가?

## 1.1 직접 증명 vs 귀류법

수학에는 두 가지 증명 전략이 있다.

| 전략 | 방법 | 비유 |
|------|------|------|
| **직접 증명** | "P이면 Q이다"를 앞에서부터 따라가며 보인다 | 정문으로 들어간다 |
| **귀류법** | "P가 아니라고 가정하면 모순이 생긴다. 따라서 P이다" | 뒷문이 막혀 있음을 확인한다 |

## 1.2 귀류법의 구조

귀류법은 정확히 세 단계로 이루어진다:

```
1. 증명하려는 것의 반대를 가정한다.    (가정)
2. 논리적으로 추론한다.                (추론)
3. 모순이 발생한다!                    (모순)
→ 따라서 원래 주장이 참이다.           (결론)
```

**일상 비유**: "내일 비가 온다"를 증명하고 싶다면?  
"비가 안 온다고 가정하자. 그러면 습도가 30% 미만이어야 한다. 그런데 현재 습도가 95%이다. **모순**! 따라서 비가 온다."

## 1.3 Lean 4에서 귀류법

Lean 4에서 귀류법을 시작하는 전술은 **`by_contra`** 이다.

```lean
-- by_contra 실행 전 (InfoView)
-- ⊢ P                     ← 목표: P를 증명하라

-- by_contra h 실행 후 (InfoView)
-- h : ¬P                   ← 가설: "P가 아니다"를 가정
-- ⊢ False                  ← 목표: 모순을 찾아라
```

**왜 `by_contra`인가?**  
목표를 `False`로 바꾸고, 원래 명제의 부정(`¬P`)을 가설로 넣어준다. 이제 `False`만 유도하면 증명이 끝난다.

---

# 2. 손 증명 5단계 완전 해부

## 2.0 증명할 명제

> **정리**: sqrt(2)는 무리수이다.  
> (즉, sqrt(2)를 a/b (a, b는 정수, b != 0) 형태로 쓸 수 없다.)

## 2.1 — 1단계: 유리수라고 가정한다

```
sqrt(2)가 유리수라고 가정하자.
그러면 sqrt(2) = a/b 로 쓸 수 있다.
(단, a와 b는 서로소인 자연수, 즉 gcd(a, b) = 1)
```

"서로소"(coprime)란 a와 b의 최대공약수가 1이라는 뜻이다. 모든 분수는 기약분수로 만들 수 있으므로 이 가정에는 문제가 없다.

## 2.2 — 2단계: 양변을 제곱한다

```
sqrt(2) = a/b
양변을 제곱: 2 = a²/b²
양변에 b²를 곱하면: 2b² = a²
```

핵심 등식 **2b² = a²** 를 얻었다.

## 2.3 — 3단계: a²이 짝수이므로 a도 짝수이다

```
2b² = a² 에서 a² = 2 × (b²) 이므로 a²은 2의 배수, 즉 짝수이다.

[핵심 사실] n²이 짝수이면 n도 짝수이다.
  증명: 대우를 보인다. "n이 홀수이면 n²도 홀수이다."
  n = 2k+1 이면 n² = 4k²+4k+1 = 2(2k²+2k)+1 → 홀수. ■
  
따라서 a²이 짝수이면 a도 짝수이다.
```

이 "핵심 사실"이 바로 **보조정리**(lemma)이다. 나중에 한 번 더 사용하게 된다.

## 2.4 — 4단계: b도 짝수이다

```
a가 짝수이므로 a = 2c (어떤 자연수 c에 대해)
2b² = (2c)² = 4c²
양변을 2로 나누면: b² = 2c²

b²이 짝수이므로 (3단계와 같은 논리로) b도 짝수이다.
```

3단계에서 증명한 보조정리를 b에 대해 **재사용**했다.

## 2.5 — 5단계: 모순!

```
a도 짝수, b도 짝수
→ a와 b 모두 2의 배수
→ gcd(a, b) >= 2
→ 서로소(gcd = 1)라는 1단계 가정에 모순!

따라서 처음 가정("sqrt(2)는 유리수이다")이 거짓이다.
결론: sqrt(2)는 무리수이다. ■
```

---

# 3. 손 증명 <-> Lean 4 전술 1:1 대응표

이 증명의 가장 중요한 구조적 통찰이다.

| 단계 | 손 증명에서 하는 일 | Lean 4 전술 | 전술의 역할 |
|------|---------------------|-------------|-------------|
| 1 | "유리수라고 **가정**하자" | `by_contra h` | 목표를 False로 바꾸고, 부정을 가설로 넣는다 |
| 2 | "a, b를 **꺼내자**" | `obtain ⟨a, b, hb, hab⟩ := h` | 존재 가설을 분해하여 구체적 값을 얻는다 |
| 3 | "a² 짝수 → a 짝수" (**성질 사용**) | `even_of_even_sq a ...` | 보조정리(lemma)를 호출한다 |
| 4 | "b에도 **같은 논리**" | `even_of_even_sq b ...` | 동일한 lemma를 재사용한다 |
| 5 | "**모순**이다!" | `absurd h_coprime h_contra` | P와 not P가 공존 → False |

### InfoView로 보는 전체 흐름

```
[시작]
  ⊢ Irrational (Real.sqrt 2)

[by_contra h 후]
  h : ¬ Irrational (Real.sqrt 2)    -- "유리수라고 가정"
  ⊢ False                            -- "모순을 찾아라"

[obtain 후]
  a : ℤ, b : ℤ
  hb : b ≠ 0
  hab : Real.sqrt 2 = ↑a / ↑b
  hcop : Int.gcd a b = 1             -- 서로소
  ⊢ False

[lemma 적용 후]
  ha_even : Even a                    -- a는 짝수
  hb_even : Even b                    -- b는 짝수
  ⊢ False

[absurd 후]
  -- 서로소인데 둘 다 짝수 → 모순!
  -- 증명 완성 ■
```

---

# 4. 보조정리(lemma)와 정리(theorem)

## 4.1 정의

| 용어 | 영문 | 의미 | 비유 |
|------|------|------|------|
| **보조정리** | lemma | 큰 증명을 위해 먼저 증명하는 작은 사실 | 벽돌 |
| **정리** | theorem | 최종적으로 증명하려는 주장 | 건물 |

## 4.2 이 증명에서의 관계

```
[벽돌 1] lemma even_of_even_sq : n² 짝수 → n 짝수
    ↓ (a에 적용)           ↓ (b에 적용)
  a 짝수               b 짝수
    ↘                   ↙
[벽돌 2] lemma not_coprime : 둘 다 짝수 → 서로소 아님
          ↓
        모순!
          ↓
[건물] theorem : sqrt(2)는 무리수이다
```

## 4.3 Lean 4에서 lemma vs theorem

```lean
-- lemma와 theorem은 기능상 완전히 동일하다.
-- 관례적으로만 구별한다:

-- 보조정리: 중간 단계의 작은 사실
lemma even_of_even_sq (n : ℕ) (h : Even (n ^ 2)) : Even n := by
  sorry

-- 정리: 최종 결론
theorem sqrt2_irrational : Irrational (Real.sqrt 2) := by
  sorry
```

**핵심**: Lean 4 컴파일러는 `lemma`와 `theorem`을 완전히 동일하게 취급한다. 차이는 순전히 인간을 위한 것이다. "이것은 중간 부품이다"(lemma) vs "이것이 최종 결론이다"(theorem)라는 의도를 표현할 뿐이다.

## 4.4 lemma 재사용의 위력

한 번 증명한 lemma는 이름만 부르면 어디서든 다시 쓸 수 있다.

```lean
-- 한 번 증명하면:
lemma even_of_even_sq (n : ℕ) (h : Even (n ^ 2)) : Even n := by
  by_contra hodd
  push_neg at hodd
  -- ... (대우 증명)

-- a에 적용:
have ha : Even a := even_of_even_sq a h_a_sq_even

-- b에 적용 (같은 lemma를 한 번 더!):
have hb : Even b := even_of_even_sq b h_b_sq_even
```

손 증명에서 "같은 논리로"라고 한 줄로 넘기는 부분이 Lean에서는 **같은 lemma 이름을 한 번 더 호출하는 것**으로 구현된다. 코드를 복사하는 것이 아니라, 이름을 부르는 것이다.

---

# 5. if(->) 와 if and only if(<->)의 차이

이 증명을 정확히 이해하려면 `→`와 `↔`의 차이를 알아야 한다.

## 5.1 if(->): 한 방향 화살표

"P이면 Q이다" = P → Q

```
예: "비가 오면 땅이 젖는다"   (P → Q)
    비가 온다 → 땅이 젖는다   (참)
    땅이 젖는다 → 비가 온다   (거짓! 물을 뿌렸을 수도 있다)
```

```lean
-- Lean 4에서 →
example : P → Q := by
  intro hp       -- P가 참이라고 가정
  -- 여기서 Q를 증명해야 한다
  sorry
```

### InfoView 변화

```
[intro hp 전]   ⊢ P → Q
[intro hp 후]   hp : P,  ⊢ Q
```

## 5.2 if and only if(<->): 양방향 화살표

"P일 때 그리고 그때에만 Q이다" = P ↔ Q = (P → Q) ∧ (Q → P)

```
예: "n² 짝수 ↔ n 짝수"
    n²이 짝수이면 n이 짝수이다   (→ 방향, 이 증명에서 사용)
    n이 짝수이면 n²이 짝수이다   (← 방향)
    둘 다 참이므로 ↔ 가 성립한다.
```

```lean
-- Lean 4에서 ↔
example : P ↔ Q := by
  constructor          -- 두 방향으로 나눈다
  · intro hp           -- → 방향: P가 참이면 Q를 보여라
    sorry
  · intro hq           -- ← 방향: Q가 참이면 P를 보여라
    sorry
```

### InfoView 변화

```
[constructor 전]   ⊢ P ↔ Q
[constructor 후]   두 개의 목표 생성:
                   목표 1: ⊢ P → Q
                   목표 2: ⊢ Q → P
```

## 5.3 이 증명에서의 역할

```
완전한 사실: "n² 짝수 ↔ n 짝수"     (↔, 양방향)
이 증명에서 쓴 것: "n² 짝수 → n 짝수" (→, 한 방향만)
```

우리는 건물 전체(↔)가 아니라 건물의 한 쪽 벽(→)만 필요했다. `↔`에서 한 방향만 꺼내 쓸 수 있으며, Lean 4에서는 `.mp`(modus ponens, → 방향)와 `.mpr`(반대 방향)으로 꺼낸다.

```lean
-- h : P ↔ Q 에서 한 방향만 꺼내기
-- h.mp  : P → Q   (→ 방향)
-- h.mpr : Q → P   (← 방향)

example (h : P ↔ Q) (hp : P) : Q :=
  h.mp hp    -- ↔ 에서 → 방향을 꺼내서 적용
```

---

# 6. Lean 4 코드: 기초부터 완성까지

## 6.1 준비: 짝수의 정의 확인

```lean
-- Lean 4 / Mathlib에서 짝수(Even)의 정의
-- Even n ↔ ∃ k, n = 2 * k
-- 즉, "n이 짝수이다" = "어떤 k가 존재하여 n = 2k"

#check Even       -- Even : α → Prop
#check @Even.mk   -- 짝수임을 증명하는 생성자
```

## 6.2 보조정리(lemma) 1: n² 짝수이면 n 짝수

이것이 3단계와 4단계에서 사용할 핵심 벽돌이다.

```lean
-- ═══════════════════════════════════════════════════
-- 보조정리: n의 제곱이 짝수이면 n도 짝수이다
-- ═══════════════════════════════════════════════════
lemma even_of_sq_even (n : ℕ) (h : Even (n ^ 2)) : Even n := by
  -- 전략: 대우(contrapositive)를 증명한다.
  -- 대우: "n이 홀수이면 n²도 홀수이다"
  by_contra h_odd
  push_neg at h_odd
  -- h_odd : ¬ Even n  (n이 짝수가 아니다 = n이 홀수이다)
  
  -- n이 홀수이므로 n = 2k + 1 형태
  rw [Nat.even_iff] at h_odd
  -- n % 2 ≠ 0, 즉 n은 홀수
  
  -- n²도 홀수임을 보인다
  have : ¬ Even (n ^ 2) := by
    rw [Nat.even_iff]
    omega
  -- 그런데 h : Even (n²) 이므로 모순!
  contradiction
```

### 손 증명과 코드의 1:1 매칭

| 손 증명 | Lean 4 코드 | 설명 |
|---------|-------------|------|
| "대우를 보인다" | `by_contra h_odd` | 귀류법으로 대우를 증명 |
| "n이 홀수라 하자" | `push_neg at h_odd` | "짝수가 아님" = "홀수" |
| "n = 2k+1이면" | `rw [Nat.even_iff]` | 짝수 정의를 나머지로 변환 |
| "n²은 홀수이다" | `omega` | 산술 자동 증명 |
| "모순!" | `contradiction` | 가설 간 모순 발견 |

## 6.3 본 정리의 스켈레톤(뼈대)

전체 구조를 `sorry`로 채워 먼저 뼈대를 확인한다.

```lean
-- ═══════════════════════════════════════════════════
-- 정리: sqrt(2)는 무리수이다 (스켈레톤)
-- ═══════════════════════════════════════════════════
theorem sqrt2_irrational : Irrational (Real.sqrt 2) := by
  -- 1단계: 유리수라고 가정
  by_contra h
  sorry  -- 2~5단계를 여기에 채울 것
```

## 6.4 각 단계 채우기

```lean
theorem sqrt2_irrational : Irrational (Real.sqrt 2) := by
  -- 1단계: 귀류법 — "유리수라고 가정하자"
  by_contra h
  -- h : ¬ Irrational (Real.sqrt 2)
  -- goal : False
  
  -- 2단계: a/b 형태 분해 — "a, b를 꺼내자"
  -- (Rational 표현에서 분자, 분모, 조건들을 추출)
  obtain ⟨a, b, hb, hab, hcop⟩ := rational_of_not_irrational h
  -- a : ℤ, b : ℤ, hb : b ≠ 0
  -- hab : Real.sqrt 2 = a / b
  -- hcop : Int.gcd a b = 1 (서로소)
  
  -- 핵심 등식: 2 * b² = a²
  have key : 2 * b ^ 2 = a ^ 2 := by
    -- hab로부터 유도
    sorry
  
  -- 3단계: a² 짝수 → a 짝수  (lemma 호출!)
  have ha_sq_even : Even (a ^ 2) := ⟨b ^ 2, by linarith⟩
  have ha_even : Even a := even_of_sq_even a ha_sq_even
  
  -- 4단계: b² 짝수 → b 짝수  (같은 lemma 재사용!)
  obtain ⟨c, hc⟩ := ha_even     -- a = 2c
  have hb_sq_even : Even (b ^ 2) := by
    use c ^ 2
    nlinarith [hc]               -- 2b² = 4c² → b² = 2c²
  have hb_even : Even b := even_of_sq_even b hb_sq_even
  
  -- 5단계: 둘 다 짝수인데 서로소라고 했으므로 모순!
  have : 2 ∣ Int.gcd a b := by
    exact Int.gcd_dvd_of_dvd_both 
      (even_iff_two_dvd.mp ha_even) 
      (even_iff_two_dvd.mp hb_even)
  -- gcd(a,b) = 1 인데 2 | gcd(a,b) → 모순
  omega
```

## 6.5 Mathlib 한 줄 완성

위의 모든 과정을 Mathlib 개발자들이 이미 완성해 두었다.

```lean
-- Mathlib에서 이미 증명된 정리:
#check irrational_sqrt_two
-- irrational_sqrt_two : Irrational (Real.sqrt 2)

-- 사용 방법: 이름을 부르기만 하면 된다
example : Irrational (Real.sqrt 2) := irrational_sqrt_two
```

**Mathlib의 한 줄은 마법이 아니다.** 위의 30줄짜리 증명이 기계적으로 검증된 채로 라이브러리에 저장되어 있는 것이다. 우리가 벽돌을 굽는 법을 배운 다음, 필요할 때 기성품 벽돌을 가져다 쓰는 것과 같다.

---

# 7. 전술 요약표

이 증명에서 사용한 모든 전술을 정리한다.

| 전술 | 언제 사용하는가 | 이 증명에서의 역할 |
|------|-----------------|---------------------|
| `by_contra h` | 직접 증명이 어려울 때, 반대를 가정하고 모순을 찾는다 | 1단계: "유리수라고 가정" |
| `obtain ⟨...⟩ := h` | "존재한다" 형태의 가설을 분해하여 값을 꺼낸다 | 2단계: a, b 추출 |
| `have` | 중간 결과를 선언하고 증명한다 | 3~4단계: 짝수 성질 |
| `linarith` / `nlinarith` | 선형/비선형 산술 부등식을 자동 증명한다 | 등식 변환 |
| `omega` | 자연수/정수 산술을 자동 증명한다 | 최종 모순 |
| `contradiction` | 가설에 P와 not P가 동시에 있으면 False를 닫는다 | lemma 내부 |
| `push_neg` | 부정(not)을 안쪽으로 밀어 넣어 읽기 쉽게 만든다 | "짝수 아님" → "홀수" |

---

# 8. 연습 문제

## 8.1 빈칸 채우기

### 연습 1: 귀류법의 시작

```lean
-- sqrt(2)가 무리수임을 증명하는 첫 단계
theorem sqrt2_step1 : Irrational (Real.sqrt 2) := by
  ________ h     -- "유리수라고 가정하자"
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
theorem sqrt2_step1 : Irrational (Real.sqrt 2) := by
  by_contra h
  sorry
```
**설명**: `by_contra h`는 목표를 `False`로 바꾸고, 원래 명제의 부정을 `h`로 넣는다.

</details>

### 연습 2: 짝수 성질의 사용

```lean
-- n² = 2 * m 이면 n이 짝수임을 보여라
example (n : ℕ) (h : Even (n ^ 2)) : Even n := by
  ________ h_not_even    -- 대우를 보이기 위해 "짝수가 아님"을 가정
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (n : ℕ) (h : Even (n ^ 2)) : Even n := by
  by_contra h_not_even
  sorry
```
**설명**: lemma 내부에서도 귀류법을 사용한다. "짝수가 아님(= 홀수)"을 가정하고 모순을 찾는 것이다.

</details>

### 연습 3: ↔ 에서 → 꺼내기

```lean
-- h : P ↔ Q 와 hp : P 에서 Q를 증명하라
example (h : P ↔ Q) (hp : P) : Q := by
  exact h.________ hp
```

<details>
<summary>정답 보기</summary>

```lean
example (h : P ↔ Q) (hp : P) : Q := by
  exact h.mp hp
```
**설명**: `h.mp`는 `↔`에서 `→` 방향(modus ponens)을 꺼낸다. `h.mpr`은 `←` 방향이다.

</details>

---

## 8.2 sorry 완성

### 연습 4: 모순 찾기

```lean
-- P와 ¬P가 동시에 있으면 False이다
example (hp : P) (hnp : ¬P) : False := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (hp : P) (hnp : ¬P) : False := by
  exact absurd hp hnp
  -- 또는: contradiction
  -- 또는: exact hnp hp
```
**설명**: `absurd`는 증거(hp : P)와 그 부정(hnp : not P)을 받아서 `False`를 만든다. `contradiction`은 가설들을 자동 스캔하여 모순을 찾는다.

</details>

### 연습 5: 보조정리 호출

```lean
-- 아래 lemma가 이미 증명되어 있다고 하자:
-- lemma my_even_lemma (n : ℕ) (h : Even (n ^ 2)) : Even n

-- 이것을 사용하여 a가 짝수임을 보여라
example (a : ℕ) (ha_sq : Even (a ^ 2)) : Even a := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (a : ℕ) (ha_sq : Even (a ^ 2)) : Even a := by
  exact my_even_lemma a ha_sq
```
**설명**: lemma는 이름을 부르고 필요한 인자(a)와 조건(ha_sq)을 넘겨주면 된다. 코드를 다시 쓰는 것이 아니라, 이미 만든 벽돌을 가져다 놓는 것이다.

</details>

### 연습 6: ↔ 증명하기

```lean
-- "n이 짝수 ↔ n+1이 홀수" 의 구조를 완성하라
example (n : ℕ) : Even n ↔ ¬ Even (n + 1) := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example (n : ℕ) : Even n ↔ ¬ Even (n + 1) := by
  constructor
  · intro h           -- → 방향
    intro h_contra    -- n+1이 짝수라고 가정하면...
    omega             -- 모순
  · intro h           -- ← 방향
    by_contra h_odd
    push_neg at h_odd
    omega
```
**설명**: `↔`는 `constructor`로 두 방향을 나눈 뒤, 각각 독립적으로 증명한다.

</details>

---

## 8.3 완전 자유 증명

### 연습 7: sqrt(3)으로 확장

```lean
-- sqrt(3)이 무리수임을 증명하라.
-- 힌트: sqrt(2) 증명과 같은 구조이다.
-- "n² 이 3의 배수이면 n도 3의 배수이다"가 핵심 lemma가 된다.
theorem sqrt3_irrational : Irrational (Real.sqrt 3) := by
  sorry
```

<details>
<summary>힌트 보기</summary>

1. `by_contra h` 로 유리수라고 가정한다.
2. `obtain`으로 a, b를 꺼낸다.
3. 핵심 등식: `3 * b² = a²`를 유도한다.
4. lemma: "a²이 3의 배수이면 a도 3의 배수이다"를 증명 또는 호출한다.
5. a도 b도 3의 배수 → 서로소에 모순.

구조가 sqrt(2) 증명과 **완전히 동일**하다. "2"를 "3"으로 바꾸기만 하면 된다.

</details>

<details>
<summary>정답 보기</summary>

```lean
-- Mathlib에 이미 있다:
#check Nat.Prime.irrational_sqrt
-- 소수 p에 대해 sqrt(p)가 무리수임을 증명하는 일반화된 정리

-- 직접 쓴다면 sqrt(2) 증명에서 2 → 3으로 치환하면 된다.
-- 핵심 lemma를 "n²이 3의 배수 → n이 3의 배수"로 바꾸면
-- 나머지 구조는 동일하다.
```

</details>

---

# 부록: 치환/대입(Substitution) = 슈퍼포지션(Superposition)

이 증명에서 2단계("a = 2c를 대입한다")와 같이 등식을 다른 식에 넣는 것을 **치환**(substitution) 또는 **대입**이라 한다.

Lean 4 / Mathlib의 자동 전술들(예: `simp`, `omega`, `linarith`)은 내부적으로 **슈퍼포지션**(superposition)이라는 추론 규칙을 사용한다. 슈퍼포지션은 "등식을 가지고 있으면, 그 등식의 한쪽을 다른 식에 끼워 넣는다"는 것이다.

```lean
-- 치환의 예
-- h : a = 2 * c    (a는 2c이다)
-- goal : 2 * b^2 = a^2
-- rw [h]           (a를 2*c로 치환한다)
-- goal이 바뀜: 2 * b^2 = (2 * c)^2
```

| 용어 | 의미 | Lean 4 전술 |
|------|------|-------------|
| **치환**(substitution) | 등식의 한쪽을 다른 식에 대입 | `rw [h]`, `subst h` |
| **슈퍼포지션**(superposition) | 치환의 일반화 (자동 추론) | `simp`, `omega`, `linarith` 내부 |

---

> **이 문서의 핵심 메시지**  
> 손 증명의 매 단계는 Lean 4의 전술 하나에 정확히 대응한다.  
> lemma는 벽돌이고, theorem은 건물이다.  
> 형식 증명은 수학적 직관을 대체하는 것이 아니라, 직관을 기계가 검증할 수 있는 형태로 번역하는 것이다.
