# 4.4 Lean 4 학생 자료 - 합동과 모듈러 산술

> 본 자료는 §4.4 강의에서 다룬 모든 Lean 4 코드를, **Lean 4**(린 포)를 처음 접하는 학습자가 한 줄씩 따라갈 수 있도록 풀어 쓴 것이다.
>
> 짝꿍 문서로 **`ch4_4_lean4_code_explanation.md`**(코드 설명 자료)가 있다. 두 문서를 나란히 펴 놓고 읽으면 가장 효과적이다.

---

## 1. 들어가며

§4.4 강의에서는 **합동**(congruence)이라는 정수론의 핵심 관계를 본격적으로 다루었다. 두 정수가 어떤 법(modulus)을 두고 "사실상 같은 수"로 취급되는 관계이다. 이 관계가 잘 정의되어 있다는 것, 즉 동치 관계(반사·대칭·추이)임을 보이고, 그 위에 모듈러 역원, 중국 잉여 정리, 페르마 소정리 같은 클래식 결과들을 쌓아 올린다.

본 자료는 다음 일곱 주제를 다룬다.

1. 사용자 정의 합동 관계 `CongMod` (정의)
2. 합동과 가분성의 동치 (두 형태 비교)
3. 합동의 세 성질 (반사·대칭·추이)
4. 모듈러 역원의 존재와 유일성 (베주 항등식)
5. ZMod 환경에서의 구체 계산
6. 중국 잉여 정리 (CRT)
7. 페르마 소정리

§4.1·§4.3에서 다룬 모든 도구가 본 절에서 활용된다.

---

## 2. 합동의 사용자 정의

§4.4 강의에서 본 합동의 정의를 다시 적는다.

**정의** 정수 `a`, `b`, `m`에 대해, `a - b`가 `m`의 정수배이면 "`a`와 `b`는 `m`을 법으로 합동"이라 하고 다음과 같이 쓴다.

```
a ≡ b (mod m)  ⟺  ∃ k : Int, a - b = k * m
```

Lean 4에서는 Mathlib에 이미 `Int.ModEq`라는 정의가 있지만, **본 자료에서는 우리만의 정의 `CongMod`을 직접 만들어 본다**. 정의의 내부 동작과 세 성질의 직접 증명을 통해 합동 관계가 어떻게 작동하는지 깊이 이해하기 위함이다.

```lean
import Mathlib

def CongMod (m a b : Int) : Prop := ∃ k : Int, a - b = k * m

notation:50 a " ≡ " b " [Z" m "]" => CongMod m a b
```

두 가지 새 요소.

**`def`로 명제 정의** `def CongMod ... : Prop := ...`는 새 **명제**(`Prop`)를 정의한다. 사실 `CongMod`는 함수처럼 보이지만, 결과가 `Prop`(명제)이므로 "명제를 만드는 함수"이다. 인수를 받아 명제를 돌려주는 형태이다.

**`notation` 선언** 새 표기법을 도입한다. `a " ≡ " b " [Z" m "]"`라는 패턴을 `CongMod m a b`로 해석. 즉 `5 ≡ 12 [Z 7]`이라고 쓰면 Lean 4가 자동으로 `CongMod 7 5 12`로 받아들인다. 종이의 `5 ≡ 12 (mod 7)`을 가능한 한 가깝게 옮긴 표기.

`:50`은 연산자의 우선순위. 다른 연산자(예: `+`, `*`)와 섞일 때 결합 순서가 어떻게 되는지를 정한다. 본 자료의 학습 단계에서는 자세히 알 필요 없다.

---

## 3. 합동과 가분성의 동치

본 자료의 `CongMod`은 `∃ k, a - b = k * m` 형태이다. 그런데 Lean 4의 가분성 `m ∣ (a - b)`는 정의가 `∃ k, (a - b) = m * k`이다. **곱셈의 순서가 다르다**.

| 표현 | 정의 |
|---|---|
| `m ∣ (a - b)` | `∃ k, (a - b) = m * k` (k가 오른쪽) |
| `CongMod m a b` | `∃ k, a - b = k * m` (k가 왼쪽) |

정수환은 가환환(commutative ring)이므로 `m * k = k * m`이지만, 형식 증명에서는 두 형태가 그대로 같지 않다. 명시적인 변환이 필요하다.

본 자료에서는 두 방식으로 이 변환을 보인다.

**방식 1.** 가분성의 증인을 직접 구성하고 `mul_comm`으로 순서를 맞춘다.

```lean
example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
  obtain ⟨k, hk⟩ := h
  refine ⟨k, ?_⟩
  rw [hk, mul_comm]
```

다섯 줄을 풀어 본다.

- `obtain ⟨k, hk⟩ := h`: 존재 가정 `h`를 분해해서 증인 `k`와 등식 `hk : a - b = k * m`을 손에 쥔다.
- `refine ⟨k, ?_⟩`: 결론 `m ∣ (a - b)`의 정의 `∃ k', (a - b) = m * k'`에 같은 `k`를 증인으로 제시. `?_`는 "등식은 아직 못 보였음"의 자리표시.
- `rw [hk, mul_comm]`: `?_` 자리의 목표 `a - b = m * k`를 닫기 위해, 먼저 `hk`로 좌변을 `k * m`으로 치환하고, `mul_comm`으로 곱셈 순서를 뒤집어 `m * k`로.

**방식 2.** Mathlib의 `dvd_iff_exists_eq_mul_left` 정리를 활용.

```lean
example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
  obtain ⟨k, hk⟩ := h
  rw [dvd_iff_exists_eq_mul_left]
  exact ⟨k, hk⟩
```

`dvd_iff_exists_eq_mul_left`의 진술:

```
dvd_iff_exists_eq_mul_left : a ∣ b ↔ ∃ k, b = k * a
```

즉 가분성을 **왼쪽 곱셈 형태**로 다시 적은 정리이다. 우리의 `CongMod` 정의와 같은 형태이므로, 이를 적용하면 변환이 자동 처리된다.

**중요한 학습 포인트**

본 자료에서 가장 자주 헷갈리는 부분 중 하나가 가분성 정의의 두 형태이다. 강의 자료에서 다시 한 번 강조한다.

> Lean 4의 표준 가분성 `a ∣ b`의 정의는 **k가 오른쪽**: `∃ k, b = a * k`.
> 같은 사실의 왼쪽 형태는 `dvd_iff_exists_eq_mul_left`: `∃ k, b = k * a`.
> 두 형태는 가환환(예: 정수)에서 동치이지만, 정확히 같은 표현은 아니다.

---

## 4. 합동의 세 성질 (1) - 반사성

`CongMod` 관계가 동치 관계임을 보이려면 세 성질을 증명해야 한다. 반사성, 대칭성, 추이성이다. 하나씩 직접 증명한다.

**정리(반사성)** 모든 정수 `a`, `m`에 대해 `a ≡ a (mod m)`이다.

종이 증명: `a - a = 0 = 0 * m`이므로 증인 `k = 0`으로 성립.

```lean
theorem CongMod_refl (m a : Int) :
    CongMod m a a := by
  unfold CongMod
  -- 목표: ∃ k : Int, a - a = k * m
  use 0
  -- 목표: a - a = 0 * m
  ring
```

세 가지 새 요소.

**`unfold CongMod`** 정의 `CongMod`을 펼친다. 목표가 `CongMod m a a`에서 `∃ k : Int, a - a = k * m`으로 바뀐다. 정의를 펼치는 것은 Lean 4가 정의의 약속을 따라 식을 변환하는 작업이다.

**`use 0`** 존재 명제 `∃ k, ...`에서 증인 `k = 0`을 제시. 목표가 `a - a = 0 * m`으로 바뀐다.

**`ring`** 다항식 항등식 자동 검증. `a - a`는 `0`이고 `0 * m`도 `0`이므로 등식 성립. `ring`이 즉결.

종이의 한 줄짜리 증명("a - a = 0 = 0 * m이므로")이 코드의 세 줄과 일대일 대응한다.

---

## 5. 합동의 세 성질 (2) - 대칭성

**정리(대칭성)** `a ≡ b (mod m)`이면 `b ≡ a (mod m)`이다.

종이 증명: `a - b = k * m`이면 `b - a = -(a - b) = -(k * m) = (-k) * m`이므로 증인 `-k`로 성립.

```lean
theorem CongMod_symm (m a b : Int)
    (h : CongMod m a b) :
    CongMod m b a := by
  unfold CongMod at h ⊢
  obtain ⟨k, hk⟩ := h
  -- 증인 -k
  use -k
  -- 목표: b - a = -k * m
  rw [neg_mul]
  -- 목표: b - a = -(k * m)
  rw [← hk]
  ring
```

새 요소.

**`unfold CongMod at h ⊢`** 정의를 가정 `h`와 목표(`⊢`) **양쪽**에서 펼친다. `at h`만 적으면 `h`에서만, `at ⊢`만 적으면 목표에서만 펼친다. 둘 다 하려면 `at h ⊢`처럼 함께 적는다.

펼친 후:
- `h : ∃ k, a - b = k * m`
- 목표: `∃ k, b - a = k * m`

**`obtain ⟨k, hk⟩ := h`** §4.3에서 본 패턴. 존재 가정을 분해.

**`use -k`** 새 증인으로 `-k`를 제시.

**`rw [neg_mul]`** `neg_mul`의 진술: `(-a) * b = -(a * b)`. 목표 안의 `-k * m`을 `-(k * m)`으로 변환.

**`rw [← hk]`** `hk`를 역방향으로 적용. `hk`의 진술이 `a - b = k * m`이므로, `←` 방향은 `k * m → a - b`. 목표 안의 `k * m`이 `a - b`로 바뀐다.

이제 목표는 `b - a = -(a - b)`. 이는 자명한 산술 항등식. `ring`이 닫음.

---

## 6. 합동의 세 성질 (3) - 추이성

**정리(추이성)** `a ≡ b (mod m)`이고 `b ≡ c (mod m)`이면 `a ≡ c (mod m)`이다.

종이 증명: `a - b = k₁ * m`, `b - c = k₂ * m`이면 `a - c = (a - b) + (b - c) = (k₁ + k₂) * m`. 증인 `k₁ + k₂`.

```lean
theorem CongMod_trans (m a b c : Int)
    (h1 : CongMod m a b)
    (h2 : CongMod m b c) :
    CongMod m a c := by
  unfold CongMod at h1 h2 ⊢
  obtain ⟨k1, hk1⟩ := h1
  obtain ⟨k2, hk2⟩ := h2
  use k1 + k2
  -- 목표: a - c = (k1 + k2) * m
  rw [show a - c = (a - b) + (b - c) by ring]
  rw [hk1, hk2]
  ring
```

새 요소.

**`rw [show a - c = (a - b) + (b - c) by ring]`** 특이한 형태이다. 인라인으로 보조 등식 `a - c = (a - b) + (b - c)`을 즉석에서 증명하고(`by ring`), 그것을 `rw`로 적용한다. `show ... by ...`는 "이 명제를, 이 증명으로"라는 표현이다.

핵심: 우리 목표가 `a - c = ...` 형태이므로, 우선 `a - c`를 두 차의 합 `(a - b) + (b - c)`로 다시 쓴다. 그러면 양변에 `a - b`와 `b - c`가 노출되어 가설 `hk1`과 `hk2`를 적용할 수 있다.

**`rw [hk1, hk2]`** 두 가설을 차례로 적용. 첫 번째: `a - b → k1 * m`. 두 번째: `b - c → k2 * m`. 결과: `(k1 * m) + (k2 * m) = (k1 + k2) * m`.

**`ring`** 마지막 다항식 항등식 검증.

종이의 두 줄("두 등식을 더하면 (k₁ + k₂) * m")이 코드의 세 줄과 짝을 이룬다.

---

## 7. 모듈러 역원의 존재 (베주 항등식 활용)

§4.4 강의의 강력한 정리이다. **확장된 유클리드 알고리즘**(extended Euclidean algorithm)의 직접 응용이다.

**정리(모듈러 역원의 존재)** `gcd(a, m) = 1`이면, `a_bar · a ≡ 1 (mod m)`인 정수 `a_bar`가 존재한다.

종이 증명의 핵심:
- 베주 항등식: `gcd(a, m) = a · s + m · t`인 정수 `s`, `t`가 존재.
- 조건 `gcd(a, m) = 1`이면 `1 = a · s + m · t`.
- 양변에서 `m · t`를 빼면 `s · a - 1 = -(m · t) = (-t) · m`.
- 즉 증인 `s` (역원 후보)와 `-t` (`CongMod`의 증인)로 정확히 합동 관계 성립.

```lean
theorem inverse_exists
    (a m : Int) (_hm : 1 < m)
    (h_cop : Int.gcd a m = 1) :
    ∃ ā : Int, CongMod m (ā * a) 1 := by
  -- 베주 계수: Mathlib4에서 함수 Int.gcdA, Int.gcdB로 제공.
  set s := Int.gcdA a m
  set t := Int.gcdB a m
  -- 베주 항등식.
  have h_bezout : (1 : Int) = a * s + m * t := by
    have h := Int.gcd_eq_gcd_ab a m
    rw [h_cop] at h
    exact_mod_cast h
  -- 증인 ā = s
  use s
  unfold CongMod
  -- 증인 k = -t
  use -t
  -- 목표: s * a - 1 = -t * m
  have h1 : s * a - 1 = -(m * t) := by
    rw [h_bezout]
    ring
  rw [h1]
  ring
```

본 자료에서 가장 흥미로운 코드. 여러 새 요소가 등장한다.

**`set s := Int.gcdA a m`과 `set t := Int.gcdB a m`** 베주 계수에 이름을 짓는다. Mathlib4에서는 `gcd(a, m) = a * s + m * t`를 만드는 두 계수 `s`, `t`가 미리 계산된 함수 `Int.gcdA`, `Int.gcdB`로 제공된다. 매우 편리하다.

**`Int.gcd_eq_gcd_ab a m`** Mathlib의 베주 항등식 정리. 진술:

```
Int.gcd_eq_gcd_ab : ∀ (a b : ℤ), ↑(Int.gcd a b) = a * Int.gcdA a b + b * Int.gcdB a b
```

말로 풀면 "gcd(a, b)는 a와 b의 정수 결합으로 표현 가능". 양변의 `gcd`는 자연수이지만 우변이 정수이므로 정수로 캐스팅된 형태로 진술된다.

**`rw [h_cop] at h`** 가설 `h_cop : Int.gcd a m = 1`을 `h` 안에 적용. 결과: `h : (1 : ℕ) = a * s + m * t` (좌변이 1로 단순화).

**`exact_mod_cast h`** 캐스팅 처리. 좌변이 `(1 : ℕ)`로 자연수인데 우리는 `(1 : Int)`를 원한다. `exact_mod_cast`가 자연수↔정수 캐스팅을 자동으로 맞춰 준다.

**중첩된 `use`** 두 번 `use`가 등장한다. 외부 결론은 `∃ ā, CongMod m (ā * a) 1`이고, `CongMod`의 정의도 `∃ k, ...`이므로 결국 두 개의 존재 명제가 중첩되어 있다. 그래서 두 번 증인 제시.

**`have h1 : s * a - 1 = -(m * t) := by rw [h_bezout]; ring`** 우변 정리. `h_bezout : 1 = a * s + m * t`를 `rw`로 좌변에 적용하면, `s * a - 1`에서 `1`이 `a * s + m * t`로 풀어지고 정리하면 `-(m * t)`가 된다. `ring`이 자동 처리.

**`rw [h1]`** 만들어 둔 `h1`을 적용. 목표가 `-(m * t) = -t * m`이 된다.

마지막 `ring`이 양변의 곱셈 순서·부호를 정리해 닫음.

---

## 8. 모듈러 역원의 유일성

**정리(유일성)** `a`의 두 모듈러 역원은 `m`을 법으로 합동이다. 즉 `a_1 * a ≡ 1`이고 `b_1 * a ≡ 1`이면 `a_1 ≡ b_1 (mod m)`.

종이 증명: `a_1 * a - 1 = k_1 * m`, `b_1 * a - 1 = k_2 * m`. 두 등식을 적절히 결합하면 `a_1 - b_1`이 `m`의 정수배가 됨. 구체적으로 `b_1 * (a_1 * a - 1) - a_1 * (b_1 * a - 1) = b_1 * k_1 * m - a_1 * k_2 * m`. 좌변 정리하면 `a_1 - b_1`. 따라서 증인 `b_1 * k_1 - a_1 * k_2`.

```lean
theorem inverse_unique
    (a m a1 b1 : Int) (_hm : 1 < m)
    (_h_cop : Int.gcd a m = 1)
    (h1 : CongMod m (a1 * a) 1)
    (h2 : CongMod m (b1 * a) 1) :
    CongMod m a1 b1 := by
  obtain ⟨k1, hk1⟩ := h1
  obtain ⟨k2, hk2⟩ := h2
  refine ⟨b1 * k1 - a1 * k2, ?_⟩
  linear_combination b1 * hk1 - a1 * hk2
```

새 요소.

**`linear_combination`** 강력한 전술. 인수로 받은 표현(여기서는 `b1 * hk1 - a1 * hk2`)이 **주어진 등식들의 선형 결합**으로 목표를 닫음을 검증한다.

직관적으로: 가설 `hk1`이 등식 `A1 = B1`이고 `hk2`가 `A2 = B2`이면, `b1 * hk1 - a1 * hk2`는 "`b1 * A1 - a1 * A2 = b1 * B1 - a1 * B2`"라는 새 등식을 만든다. 만약 그 새 등식이 우리 목표와 (대수적으로) 같다면 `linear_combination`이 즉결.

본 정리에서:
- `hk1 : a1 * a - 1 = k1 * m`
- `hk2 : b1 * a - 1 = k2 * m`
- `b1 * hk1 - a1 * hk2` →  `b1 * (a1 * a - 1) - a1 * (b1 * a - 1) = b1 * k1 * m - a1 * k2 * m`
- 좌변 정리: `b1 * a1 * a - b1 - a1 * b1 * a + a1 = a1 - b1`.
- 우변 정리: `(b1 * k1 - a1 * k2) * m`.
- 결과: `a1 - b1 = (b1 * k1 - a1 * k2) * m`. 이것이 우리 목표.

`linear_combination`은 이 모든 대수 결합을 자동 검증한다. **본 자료에서 가장 강력한 자동화 전술 중 하나**이다.

---

(이어서 §9. ZMod 환경, §10. CRT, §11. 페르마 소정리, §12. 마무리)
## 9. ZMod 환경에서의 구체 계산

지금까지의 `CongMod` 정의와 `Int.ModEq`는 정수 위에서의 합동 관계를 다루었다. 그러나 Lean 4에는 더 강력한 도구가 있다. 바로 **`ZMod n`**이다.

**`ZMod n`이란 무엇인가** `ZMod n`은 "정수를 `n`으로 나눈 나머지의 집합", 즉 `{0, 1, 2, ..., n-1}`을 환(ring)으로 만든 구조이다. 종이에서 `Z/nZ`로 쓰는 그 환과 같다. `ZMod n`의 원소는 모듈러 산술의 자연스러운 표현이다.

`ZMod n`을 쓰면 좋은 점은, **합동 관계가 자동으로 등식이 된다**는 것이다. 예를 들어 `3 ≡ 10 (mod 7)`은 정수 위에서는 두 다른 정수의 합동 관계이지만, `ZMod 7`에서는 `(3 : ZMod 7) = (10 : ZMod 7)`이라는 그냥 등식이다. `3 = 3`인 셈이다.

**시연 1: 모듈러 역원의 명시적 검증**

종이에서 자주 푸는 문제: "3의 mod 7 역원은 무엇인가?" 답은 5. 검산: `3 * 5 = 15 = 14 + 1 ≡ 1 (mod 7)`.

```lean
example : (3 : ZMod 7) * 5 = 1 := by decide
```

본 한 줄이 위 사실의 형식 증명이다. `ZMod 7` 환에서 `3 * 5`을 계산하면 `15 mod 7 = 1`이고, 우변도 `1`이므로 등식 성립. `decide`가 직접 계산으로 즉결.

**시연 2: 선형 합동의 가해성**

§4.4 강의의 중심 정리 중 하나. "`p`가 소수이고 `a`가 `ZMod p`에서 0이 아니면, 임의의 `b`에 대해 `a * x = b`의 해 `x`가 존재한다."

이는 곧 "`ZMod p`(p 소수)는 **체**(field)"라는 사실의 다른 표현이다. 0이 아닌 모든 원소가 역원을 가진다.

```lean
example (a b : ZMod 7) (ha : a ≠ 0) :
    ∃ x : ZMod 7, a * x = b := by
  haveI : Fact (Nat.Prime 7) := ⟨by decide⟩
  refine ⟨a⁻¹ * b, ?_⟩
  field_simp
```

네 가지 새 요소이다.

**`haveI : Fact (Nat.Prime 7) := ⟨by decide⟩`** `Fact`라는 typeclass에 인스턴스를 주입한다. Mathlib의 많은 정리(특히 `ZMod p`가 체임을 활용하는 정리들)는 `[Fact (Nat.Prime p)]`라는 전역 가정을 요구한다. `Fact (Nat.Prime 7)`은 "7이 소수임을 typeclass 시스템이 알 수 있는 형태로 표현"한 것이고, `haveI`로 지역적으로 그 인스턴스를 만들어 준다. 안쪽은 `⟨by decide⟩`로 "7이 소수임"의 증명을 즉석에서 제공.

**`refine ⟨a⁻¹ * b, ?_⟩`** 증인을 제시. 종이 증명의 "해는 `x = a⁻¹ * b`이다" 그 자체. `?_`는 등식 `a * (a⁻¹ * b) = b`의 자리표시.

**`a⁻¹` 표기** `ZMod p`(p 소수)가 체이므로 0이 아닌 원소의 역원이 존재한다. `a⁻¹`은 `a`의 역원(즉 `a * a⁻¹ = 1`인 원소).

**`field_simp`** 분수·역원이 들어간 식을 자동으로 정리하는 전술. 우리 목표 `a * (a⁻¹ * b) = b`에서 `a * a⁻¹ = 1`이 적용되어 좌변이 `1 * b = b`로 정리되고, 우변과 일치한다.

---

## 10. 중국 잉여 정리 (CRT)

§4.4 강의의 또 다른 빛나는 정리이다. 종이에서 본 정리의 모양:

**정리(중국 잉여 정리)** 자연수 `m`, `n`이 서로소이면, 임의의 `a`, `b`에 대해 다음 두 합동을 동시에 만족하는 `x`가 (mod `mn`에서) 유일하게 존재한다.

```
x ≡ a (mod m),   x ≡ b (mod n).
```

Mathlib에서는 이 정리를 더 일반적이고 우아한 형태로 진술한다. **환 동형 사상**(ring isomorphism)으로 옮긴 것이다.

**정리(CRT, 환 동형 형태)** `m`, `n`이 서로소이면, `ZMod (m * n) ≃+* ZMod m × ZMod n`.

말로 풀면 "mn을 법으로 한 환은 m을 법으로 한 환과 n을 법으로 한 환의 직접곱(direct product)과 동형이다". 동형 사상은 어떤 원소 `x ∈ ZMod (m*n)`을 `(x mod m, x mod n) ∈ ZMod m × ZMod n`으로 보내는 자연스러운 사상.

```lean
example (m n : ℕ) (hmn : Nat.Coprime m n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n :=
  ZMod.chineseRemainder hmn
```

Mathlib의 `ZMod.chineseRemainder`가 정확히 이 정리이다. 인수로 서로소성 가정만 넘기면 환 동형이 돌아온다.

**기호 설명**
- `≃+*`: 환 동형 사상의 기호. 환의 덧셈·곱셈 구조를 모두 보존하는 양방향 일대일 대응.
- `Nat.Coprime m n`: `m`과 `n`이 서로소임의 명제. 정의는 `Nat.gcd m n = 1`.

**시연: 손자의 정리 사례**

종이의 고전 문제. 다음 세 합동을 동시에 만족하는 자연수가 있는가?

```
x ≡ 2 (mod 3),   x ≡ 3 (mod 5),   x ≡ 2 (mod 7).
```

종이로 풀면 `x = 23`이 가장 작은 양의 정수 해이다(105를 법으로 한 유일한 해이기도 함). 검산: 23 = 7·3 + 2, 23 = 4·5 + 3, 23 = 3·7 + 2. 모두 성립.

```lean
example : (23 : ZMod 105).val % 3 = 2 ∧
          (23 : ZMod 105).val % 5 = 3 ∧
          (23 : ZMod 105).val % 7 = 2 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide
```

새 요소.

**`.val`** `ZMod n`의 원소를 자연수로 변환하는 메서드. `(23 : ZMod 105).val`은 `ZMod 105` 안의 `23`을 다시 자연수 `23`으로 보낸 값. 그 위에서 `% 3`, `% 5`, `% 7`을 적용해 각 모듈러를 본다.

**`refine ⟨?_, ?_, ?_⟩ <;> decide`** 세 합접의 결론을 세 자리표시로 분해하고, **모든 자리표시에 동시에** `decide`를 적용. `<;>` 연산자는 "앞 전술의 모든 결과 부목표에 뒤의 전술을 적용"이라는 의미이다. 본 자료에서 새로 등장한 결합 표현이다. 세 개의 단순 계산을 한 줄에 묶어 처리한다.

---

## 11. 페르마 소정리

§4.4의 클라이맥스이다.

**정리(페르마 소정리)** `p`가 소수이고 `a`가 `ZMod p`에서 0이 아니면, `a^(p-1) = 1` (in `ZMod p`).

```lean
example (p : ℕ) [Fact p.Prime] (a : ZMod p) (ha : a ≠ 0) :
    a ^ (p - 1) = 1 :=
  ZMod.pow_card_sub_one_eq_one ha
```

본 정리는 Mathlib의 `ZMod.pow_card_sub_one_eq_one`로 한 줄. 호출만 한다.

`[Fact p.Prime]`은 **typeclass 인수**이다. 정리 선언의 대괄호 `[]` 안에 두면, Lean 4가 자동으로 적절한 인스턴스를 찾아 채워 준다. 우리는 `p`가 소수라는 사실을 정리의 전제로 두지만, 직접 인수로 받지는 않는다(인스턴스로 처리).

**따름정리** 모든 `a ∈ ZMod p`에 대해 `a^p = a`.

종이 증명: `a = 0`이면 `0^p = 0`. `a ≠ 0`이면 페르마 소정리로 `a^(p-1) = 1`이고, 양변에 `a`를 곱하면 `a^p = a`.

```lean
example (p : ℕ) [Fact p.Prime] (a : ZMod p) : a ^ p = a := by
  have hpPrime : Nat.Prime p := Fact.out
  by_cases ha : a = 0
  · rw [ha, zero_pow hpPrime.pos.ne']
  · have h : a ^ (p - 1) = 1 := ZMod.pow_card_sub_one_eq_one ha
    have hp : p = (p - 1) + 1 := (Nat.sub_add_cancel hpPrime.pos).symm
    calc
      a ^ p
          = a ^ ((p - 1) + 1) := by rw [← hp]
        _ = a ^ (p - 1) * a   := pow_succ a (p - 1)
        _ = 1 * a             := by rw [h]
        _ = a                 := one_mul a
```

본 자료에서 가장 큰 정리. 여러 새 요소를 풀어 본다.

**`Fact.out`** `[Fact p.Prime]` 인스턴스에서 내용물(`p.Prime`)을 꺼내는 메서드. 인스턴스로 받은 사실을 명시적인 가정 이름(`hpPrime`)으로 손에 쥔다.

**`by_cases ha : a = 0`** 명제 `a = 0`과 그 부정 `¬ (a = 0)`으로 분기한다. 두 경우를 각각 `·`(점)으로 시작하는 줄에서 처리.

**경우 1: `a = 0`** `rw [ha, zero_pow hpPrime.pos.ne']`. 두 다시쓰기:
- `rw [ha]`: 목표 안의 `a`를 `0`으로 치환. 목표는 `0 ^ p = 0`이 됨.
- `rw [zero_pow hpPrime.pos.ne']`: `zero_pow`의 진술은 `n ≠ 0 → (0 : α)^n = 0`. `hpPrime.pos.ne'`은 "`p`가 양수이므로 `p ≠ 0`"의 도출. `.pos`로 양수성을, `.ne'`으로 0과 같지 않음을 얻는다.

**경우 2: `a ≠ 0`** 페르마 소정리를 활용한 사슬.
- `have h := ZMod.pow_card_sub_one_eq_one ha`: 페르마 소정리로 `a^(p-1) = 1`.
- `have hp : p = (p - 1) + 1`: `p`를 `(p-1) + 1`로 다시 적은 등식. `Nat.sub_add_cancel`의 진술은 `k ≤ n → n - k + k = n`. `.symm`으로 좌우를 뒤집어 `p = (p-1) + 1`.
- `calc` 블록으로 네 단계 사슬:
  1. `a^p = a^((p-1) + 1)` (rewrite `hp` 역방향).
  2. `= a^(p-1) * a` (`pow_succ`).
  3. `= 1 * a` (rewrite `h`).
  4. `= a` (`one_mul`).

**전체 흐름 정리**

| 종이 | Lean 4 |
|---|---|
| "case 1: a = 0" | `by_cases` 첫 가지 |
| "0^p = 0" | `zero_pow hpPrime.pos.ne'` |
| "case 2: a ≠ 0" | `by_cases` 둘째 가지 |
| "페르마 소정리 적용" | `have h := ZMod.pow_card_sub_one_eq_one ha` |
| "p = (p-1) + 1" | `have hp` |
| "a^p = a^((p-1)+1) = a^(p-1) · a = 1 · a = a" | `calc` 4단계 |

---

## 12. 마무리

본 자료에서 익힌 핵심 패턴 일곱 가지.

**패턴 1. 사용자 정의 명제 (`def ... : Prop`)**

```lean
def MyRelation (...) : Prop := <명제 본체>
```

**패턴 2. 정의 펼치기와 존재 증인 제시**

```lean
unfold MyRelation at h ⊢
obtain ⟨k, hk⟩ := h
use <증인>
```

**패턴 3. 합동의 세 성질 손증명**

```lean
-- 반사: ring으로 등식 0 = 0*m 즉결
-- 대칭: -k 증인 + neg_mul + ← hk + ring
-- 추이: k1 + k2 증인 + show ... by ring으로 차의 합 변환 + ring
```

**패턴 4. 베주 항등식 호출**

```lean
set s := Int.gcdA a m
set t := Int.gcdB a m
have h_bezout : (1 : Int) = a * s + m * t := by
  have h := Int.gcd_eq_gcd_ab a m
  rw [h_cop] at h
  exact_mod_cast h
```

**패턴 5. `linear_combination`으로 등식의 선형 결합**

```lean
linear_combination <계수1> * <등식1> + <계수2> * <등식2> + ...
```

**패턴 6. `ZMod n` 환에서의 직접 계산**

```lean
example : (a : ZMod n) * b = c := by decide
```

**패턴 7. 페르마 소정리·CRT 활용**

```lean
-- 페르마: ZMod.pow_card_sub_one_eq_one
-- CRT: ZMod.chineseRemainder
```

본 자료를 따라치면, `CongMod` 사용자 정의, 합동의 세 성질 직접 증명, `Int.gcdA`/`gcdB`로 베주 항등식 활용, `ZMod n` 환의 직접 계산, `Fact` typeclass 주입, `linear_combination` 전술, CRT와 페르마 소정리 직접 호출 — 이 모든 클래식한 정수론 도구가 손에 익는다.

§4.4까지가 4장의 핵심이다. §4.5는 합동의 응용, §4.6은 암호학으로 이어진다. 후속 자료에서 만난다.

---

**부록. 짝꿍 문서 안내**

본 문서의 각 코드 블록에 대해 한 줄씩 정밀하게 InfoView 상태 변화를 기록한 짝꿍 문서가 **`ch4_4_lean4_code_explanation.md`**(코드 설명 자료)이다. 본 문서에서 큰 그림을 잡은 뒤 짝꿍 문서에서 한 줄씩의 변화를 확인하는 흐름을 권한다.
