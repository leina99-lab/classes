# 4.3 Lean 4 학생 자료 - 소수와 최대공약수

> 본 자료는 §4.3 강의에서 다룬 모든 Lean 4 코드를, **Lean 4**(린 포)를 처음 접하는 학습자가 한 줄씩 따라갈 수 있도록 풀어 쓴 것이다.
>
> 짝꿍 문서로 **`ch4_3_lean4_code_explanation.md`**(코드 설명 자료)가 있다.

---

## 1. 들어가며

§4.3 강의에서는 **소수**(prime numbers)와 **최대공약수**(greatest common divisor, GCD), 그리고 **최소공배수**(least common multiple, LCM)를 배웠다. 정수론의 가장 고전적이고도 가장 강력한 주제들이다.

본 자료는 다음 다섯 주제를 다룬다.

1. 합성수에는 √n 이하의 소인수가 존재한다는 정리(`composite_has_small_prime_factor`)
2. 유클리드의 소수 무한성 정리(`my_infinite_primes`)
3. 최대공약수 `Nat.gcd`의 사용법과 양수성 정리
4. 최소공배수 `Nat.lcm`의 사용법
5. 핵심 등식 `gcd(m, n) · lcm(m, n) = m · n`

§4.1·§4.2에서 다룬 가분성과 진법이 본 절의 도구로 활용된다. 특히 가분성의 결합 정리들(`Nat.dvd_add`, `Nat.dvd_factorial` 등)이 본 절의 두 핵심 정리에서 결정적인 역할을 한다.

---

## 2. 최소 소인수 `Nat.minFac`

§4.3의 첫 핵심 도구는 **최소 소인수**이다.

**정의** 1보다 큰 자연수 `n`에 대해, `n`을 나누는 가장 작은 소수를 `n`의 **최소 소인수**라 하고 `Nat.minFac n`으로 표시한다.

Mathlib에는 이 함수가 직접 정의되어 있다. 그리고 그에 관한 세 가지 핵심 성질이 보조 정리로 제공된다.

| 정리 이름 | 진술 |
|---|---|
| `Nat.minFac_prime` | `n ≠ 1 → (Nat.minFac n).Prime` |
| `Nat.minFac_dvd` | `Nat.minFac n ∣ n` |
| `Nat.minFac_sq_le_self` | `0 < n → ¬ Nat.Prime n → (Nat.minFac n)^2 ≤ n` |

세 정리를 말로 풀면 다음과 같다.

- 첫째: `n`이 1이 아니면, `minFac n`은 소수이다.
- 둘째: `minFac n`은 `n`의 약수이다(즉 `n`을 나눈다).
- 셋째: `n`이 양수이고 합성수이면, `minFac n`의 제곱이 `n` 이하이다.

세 번째 정리가 §4.3 강의의 핵심 부등식이다. 종이로 풀어 쓰면 "최소 소인수의 제곱은 원래 수보다 크지 않다"이다. 이는 곧 합성수에 대해 "√n 이하의 소인수가 존재한다"는 강력한 사실로 이어진다.

---

## 3. 합성수의 작은 소인수 정리

**정리** `n`이 1보다 크고 소수가 아니면(즉 합성수이면), `p * p ≤ n`이고 `p ∣ n`인 소수 `p`가 존재한다.

이는 종이의 "√n 이하의 소인수"를 정확히 옮긴 진술이다. `p ≤ √n`은 `p² ≤ n`과 같고, 자연수 환경에서는 후자가 다루기 쉬우므로 그쪽을 쓴다.

```lean
import Mathlib
import Mathlib.Data.Nat.Prime.Basic

theorem composite_has_small_prime_factor
    (n : Nat) (h_comp : 1 < n ∧ ¬ Nat.Prime n) :
    ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n := by
  obtain ⟨h1, h_not_prime⟩ := h_comp
  -- (1) 0 < n 과 n ≠ 1 을 도출
  have hn_pos    : 0 < n := by omega
  have hn_ne_one : n ≠ 1 := by omega
  -- (2) 최소 소인수 p := Nat.minFac n 도입
  set p := Nat.minFac n with hp_def
  have hp_prime : Nat.Prime p := Nat.minFac_prime hn_ne_one
  have hp_dvd   : p ∣ n        := Nat.minFac_dvd n
  -- (3) Nat.minFac_sq_le_self : (minFac n)^2 ≤ n
  --     pow_two 로 ^2 = * 변환
  have hp_sq : p * p ≤ n := by
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rw [pow_two] at h
    exact h
  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩
```

여섯 가지 새 요소이다. 차근차근 풀어 본다.

**`obtain ⟨h1, h_not_prime⟩ := h_comp`** 가정 `h_comp : 1 < n ∧ ¬ Nat.Prime n`은 두 사실의 **합접**(conjunction, AND)이다. 합접을 두 개의 따로따로의 가정으로 분해하는 것이 `obtain`이다. 분해 결과 `h1 : 1 < n`과 `h_not_prime : ¬ Nat.Prime n`이 새 이름으로 가정에 들어간다.

`⟨h1, h_not_prime⟩`이라는 꺽쇠 패턴이 "두 성분을 이렇게 받아내겠다"는 의미이다. §4.1에서 본 가분성의 꺽쇠와 같은 기호이지만 여기서는 합접의 분해이다.

**`have hn_pos : 0 < n := by omega`** `h1 : 1 < n`에서 `0 < n`을 도출. `omega`가 선형 산술로 자동 처리.

**`set p := Nat.minFac n with hp_def`** 새 정의 `p`를 도입한다. `set`은 `let`과 비슷하지만 더 강하다. `Nat.minFac n`이라는 표현을 `p`라는 새 이름으로 묶고, 동시에 그 정의 등식을 `hp_def : p = Nat.minFac n`이라는 가정으로 함께 넣어 준다. 본문에서 `p`를 마치 보통의 변수처럼 쓸 수 있게 된다.

**Mathlib 정리 직접 호출** `Nat.minFac_prime hn_ne_one`은 "n ≠ 1이라는 가정에서 minFac n이 소수임"을 즉시 도출. `Nat.minFac_dvd n`은 인수 한 개만 받아 가분성을 돌려준다.

**`Nat.minFac_sq_le_self`의 등장** 이 정리는 `(minFac n)^2 ≤ n`을 돌려준다. 그러나 우리는 `p * p ≤ n` 형태를 원한다. 둘은 같은 사실이지만 표현이 다르다. `pow_two`라는 보조 정리가 다리를 놓는다.

```
pow_two : a^2 = a * a
```

`rw [pow_two] at h`는 가정 `h` 안의 `^2`를 `* a`로 다시 쓴다. 결과: `h : p * p ≤ n`.

**`exact ⟨p, hp_prime, hp_sq, hp_dvd⟩`** 마지막 줄. 결론이 `∃ p, P1 ∧ P2 ∧ P3`라는 존재 명제 + 합접의 결합이므로, 네 정보를 꺽쇠로 묶어 한꺼번에 제공한다. 첫째는 증인 `p`, 나머지는 세 명제의 증명. Lean 4가 합접의 결합 구조를 자동으로 해석한다.

**전체 흐름 정리**

| 종이 | Lean 4 |
|---|---|
| "n이 1보다 큰 합성수라 하자" | `obtain ⟨h1, h_not_prime⟩ := h_comp` |
| "최소 소인수 p = minFac n을 잡자" | `set p := Nat.minFac n with hp_def` |
| "p는 소수이다" | `have hp_prime := Nat.minFac_prime hn_ne_one` |
| "p ∣ n" | `have hp_dvd := Nat.minFac_dvd n` |
| "p² ≤ n" | `have hp_sq : p * p ≤ n := by ...` |
| "따라서 그런 p가 존재" | `exact ⟨p, hp_prime, hp_sq, hp_dvd⟩` |

종이의 다섯 단계가 코드의 다섯 줄과 정확히 한 줄씩 짝을 이룬다.

---

## 4. 유클리드의 소수 무한성

§4.3 강의의 가장 유명한 정리이다.

**정리(유클리드)** 임의의 자연수 `N`에 대해, `N` 이상의 소수가 존재한다.

종이의 고전적 증명:
1. `Q = N! + 1`을 잡는다.
2. `Q ≥ 2`이므로 `Q`의 최소 소인수 `p`가 존재.
3. 만약 `p ≤ N`이면 `p ∣ N!`이고 동시에 `p ∣ Q = N! + 1`이므로 `p ∣ 1`. 이는 `p`가 소수임에 모순.
4. 따라서 `p > N`, 즉 `N < p`. 그리고 `p`는 소수.

이를 Lean 4로 옮기면 다음과 같다.

```lean
theorem my_infinite_primes (N : Nat) : ∃ p, N ≤ p ∧ Nat.Prime p := by
  -- 1) Q := N! + 1
  set Q := Nat.factorial N + 1 with hQ
  
  -- 2) Q ≥ 2
  have hQ_ge : 2 ≤ Q := by
    rw [hQ]
    have := Nat.factorial_pos N
    omega

  -- 3) Q의 최소 소인수 p
  set p := Nat.minFac Q with hp
  have hp_prime : Nat.Prime p := Nat.minFac_prime (by omega)
  
  -- 4) 결론 도출
  refine ⟨p, ?_, hp_prime⟩
  
  -- N ≤ p 임을 증명 (귀류법)
  exact (Nat.lt_of_not_le (fun h : p ≤ N => 
    -- p ≤ N 이면 p는 N!의 약수
    have h_p_div_fact : p ∣ Nat.factorial N := 
      Nat.dvd_factorial (Nat.Prime.pos hp_prime) h
    -- p는 Q의 소인수이므로 Q를 나눈다
    have h_p_div_Q : p ∣ Q := by
      rw [hp]
      exact Nat.minFac_dvd Q
    -- p가 N!과 N!+1을 모두 나누면 1도 나누어야 함
    have h_p_div_one : p ∣ 1 := by
      rw [hQ] at h_p_div_Q
      exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
    -- 소수가 1을 나누는 것은 불가능
    show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
  )).le
```

본 자료에서 가장 큰 정리이다. 여섯 가지 핵심 부분을 차례로 풀어 본다.

**`set Q := Nat.factorial N + 1 with hQ`** 종이의 `Q = N! + 1` 정의를 옮긴 줄.

**`Nat.factorial_pos N`과 `omega`의 결합** `N!`이 양수임을 받아 `2 ≤ Q = N! + 1`을 자동으로 도출. `Nat.factorial_pos`의 진술은 `0 < n!`이다.

**`refine ⟨p, ?_, hp_prime⟩`** 결론 `∃ p, N ≤ p ∧ Nat.Prime p`를 부분적으로 채운다. `refine`은 `exact`와 비슷하지만 "아직 못 채운 부분을 `?_`로 남겨 둔다"는 차이가 있다. 이 줄로 우리는 증인 `p`와 소수성 `hp_prime`은 제공하지만, `N ≤ p`는 아직 못 보였다고 표시한다. `?_` 자리가 다음 줄들의 목표가 된다.

**`Nat.lt_of_not_le`과 람다 표현** 가장 까다로운 부분이다.

`Nat.lt_of_not_le`의 진술: `¬ (a ≤ b) → b < a`. 우리는 `N < p`를 보이고 싶다. `lt_of_not_le`을 쓰려면 `¬ (p ≤ N)`을 제공해야 한다.

`(fun h : p ≤ N => ...)`라는 표현은 "만약 `p ≤ N`이라는 가정 `h`를 받았다고 치자. 그러면 모순(False)이 따라온다"는 의미의 람다 함수이다. 이것이 정확히 귀류법의 형태이다. "p ≤ N을 가정하면 False"라는 함수는 곧 `¬ (p ≤ N)`의 증명이다.

람다의 본문은 세 단계의 `have`로 모순을 끌어낸다. 마지막의 `Nat.Prime.not_dvd_one`이 결정적 한 방. "소수는 1을 나눌 수 없다"는 사실.

마지막의 `.le`은 LT.lt의 `.le` 메서드로, `N < p`에서 `N ≤ p`로 약화시킨다. 종이의 "`N < p`이므로 당연히 `N ≤ p`"를 옮긴 것이다.

**`Nat.dvd_factorial`의 사용** 진술: `0 < a → a ≤ n → a ∣ n!`. 즉 "양수이고 `n` 이하인 수는 `n!`을 나눈다". 우리는 `p`가 양수(소수이므로)이고 `p ≤ N`(가정 `h`)이므로 `p ∣ N!`을 즉시 얻는다.

**`Nat.dvd_add_right`의 사용** 진술: `a ∣ b → (a ∣ (b + c) ↔ a ∣ c)`. "이미 `b`의 가분성이 있을 때, `b + c`의 가분성과 `c`의 가분성이 동치"라는 정리이다. 우리는 `p ∣ N!`이 있고 `p ∣ N! + 1`이 있으므로, 이 동치의 `.mp`(좌→우) 방향을 적용해 `p ∣ 1`을 얻는다.

**`show False from ...`** 람다의 마지막 줄. "지금 우리가 보이려는 것은 False이다. 그 증명은 다음과 같다"고 명시. 형식은 `show <명제> from <증명>`.

종이 증명과의 대응:

| 종이 | Lean 4 |
|---|---|
| "Q = N! + 1을 정의" | `set Q := Nat.factorial N + 1 with hQ` |
| "Q ≥ 2" | `have hQ_ge : 2 ≤ Q := ...` |
| "Q의 최소 소인수 p" | `set p := Nat.minFac Q with hp` |
| "p는 소수" | `have hp_prime := ...` |
| "p > N (귀류법)" | `Nat.lt_of_not_le (fun h => ...)` |
| 귀류법 안: "p ≤ N → p ∣ N!" | `Nat.dvd_factorial` |
| "p ∣ Q = N!+1" | `Nat.minFac_dvd Q` |
| "p ∣ N!과 p ∣ N!+1로 p ∣ 1" | `Nat.dvd_add_right` |
| "소수는 1을 못 나눔, 모순" | `Nat.Prime.not_dvd_one` |

종이의 9단계가 코드의 9개 의미 단위와 정확히 짝을 이룬다.

---

## 5. 최대공약수 `Nat.gcd`

§4.3의 또 다른 기둥은 최대공약수이다.

**정의** Mathlib의 `Nat.gcd`는 유클리드 호제법으로 정의되어 있다.

```
Nat.gcd 0     y = y
Nat.gcd (x+1) y = Nat.gcd (y % (x+1)) (x+1)
```

말로 풀면 "큰 수를 작은 수로 나누고, 나머지로 다시 시작"이라는 유클리드 알고리즘 그 자체이다.

**시연**

```lean
#eval Nat.gcd 24 36     -- 12
#eval Nat.gcd 120 500   -- 20
#eval Nat.gcd 17 13     -- 1
```

`#eval`은 "이 표현의 값을 계산해 보여 달라"는 명령이다. Lean 4가 직접 계산해서 출력해 준다. 17과 13은 서로소이므로 gcd가 1이다.

---

## 6. gcd의 양수성

**정리** 두 자연수 `a`, `b` 중 적어도 하나가 0이 아니면, `gcd(a, b) > 0`이다.

```lean
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  -- 1. gcd가 0보다 클 조건(iff)을 적용.
  -- 0 < gcd a b ↔ 0 < a ∨ 0 < b
  rw [Nat.gcd_pos_iff]
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h
```

세 가지 새 요소이다.

**`Nat.gcd_pos_iff`** Mathlib의 정리. 진술:

```
Nat.gcd_pos_iff : 0 < Nat.gcd a b ↔ 0 < a ∨ 0 < b
```

이 동치를 적용하면 목표 `0 < Nat.gcd a b`가 `0 < a ∨ 0 < b`로 바뀐다.

**`Nat.pos_iff_ne_zero`** 또 다른 동치. 진술:

```
Nat.pos_iff_ne_zero : 0 < n ↔ n ≠ 0
```

자연수 환경에서 "양수다"와 "0이 아니다"는 같은 사실이다.

**`rwa`와 `←` 화살표** `rwa`는 `rw` + `assumption`의 결합이다. 즉 다시 쓰기 후 가정 목록에서 일치하는 것을 찾아 즉결.

`←`는 등식·동치를 **역방향**으로 적용한다는 표시. 우리는 가정 `h : a ≠ 0 ∨ b ≠ 0`을 `0 < a ∨ 0 < b`로 바꿔야 하므로, `Nat.pos_iff_ne_zero`의 `0 < n ↔ n ≠ 0`을 역방향(`n ≠ 0 → 0 < n`)으로 적용한다. 그래서 `← Nat.pos_iff_ne_zero`이다. 두 번 적용(양변 각각)하므로 `← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero`로 두 번 쓴다.

**대안 형태** 위 코드가 다소 압축되어 있다. 더 명시적인 형태도 가능하다.

```lean
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  rw [Nat.gcd_pos_iff]
  have h_new : 0 < a ∨ 0 < b := by
    rwa [Nat.pos_iff_ne_zero, Nat.pos_iff_ne_zero]
  exact h_new
```

`have h_new`로 중간 사실을 명시적으로 손에 쥐고, `exact`로 마무리한다. 두 형태는 같은 일을 한다. 학습자의 취향에 따라 선택.

---

## 7. 최소공배수 `Nat.lcm`

**정의** Mathlib의 `Nat.lcm`은 다음과 같이 정의된다.

```
Nat.lcm m n := m * n / Nat.gcd m n
```

즉 "두 수의 곱을 그 gcd로 나눈 것"이다. 종이에서 자주 외우는 공식 `lcm(m, n) = m·n / gcd(m, n)`을 정의 자체로 채택한 것이다.

**시연**

```lean
#eval Nat.lcm 4 6        -- 12
#eval Nat.lcm 120 500    -- 3000
```

4와 6의 lcm은 12. 검산: gcd(4, 6) = 2, 4·6/2 = 12. (일치함)

---

## 8. 핵심 등식 - `gcd · lcm = m · n`

§4.3의 클라이맥스 정리이다.

**정리** 자연수 `m`, `n`에 대해 `gcd(m, n) · lcm(m, n) = m · n`이다.

```lean
example (m n : Nat) :
    Nat.gcd m n * Nat.lcm m n = m * n :=
  Nat.gcd_mul_lcm m n
```

Mathlib에 `Nat.gcd_mul_lcm`이라는 정확한 형태로 정리가 들어 있어 인수 두 개만 넘기면 끝.

**의미** 이 정리는 lcm의 정의 `Nat.lcm m n := m * n / Nat.gcd m n`을 양변에 gcd를 곱해 정리한 것이다. 정의에서 정수 나눗셈을 자유롭게 다루려면 gcd가 0이 아니어야 하는데, Mathlib의 진술은 그 까다로움까지 자동 처리해 일반적으로 성립함을 보장한다.

---

## 9. 마무리

본 자료에서 익힌 핵심 패턴 다섯 가지.

**패턴 1. 합접의 분해 (`obtain`)**

```lean
obtain ⟨h1, h2⟩ := h_conj
-- h_conj : P ∧ Q를 분해하여 h1 : P, h2 : Q를 얻음
```

**패턴 2. 정의 이름 짓기 (`set`)**

```lean
set p := <긴 표현> with hp_def
-- p가 새 이름이 되고, hp_def : p = <긴 표현>가 가정에 추가됨
```

**패턴 3. 존재+합접 결론 (`exact ⟨..., ..., ...⟩`)**

```lean
example : ∃ p, P1 ∧ P2 ∧ P3 := ⟨<증인>, <증명1>, <증명2>, <증명3>⟩
```

**패턴 4. 부분 채움 (`refine`)**

```lean
refine ⟨<채울 것>, ?_, <채울 것>⟩
-- ?_ 자리가 다음 줄들의 목표가 됨
```

**패턴 5. 람다 귀류법**

```lean
exact (Nat.lt_of_not_le (fun h : <가정> => <False 유도>))
```

본 자료를 따라치면, `Nat.minFac`, `Nat.factorial`, `Nat.gcd`, `Nat.lcm`, `Nat.dvd_factorial`, `Nat.dvd_add_right`, `Nat.gcd_pos_iff`, `Nat.gcd_mul_lcm` 등 §4.3의 핵심 Mathlib API에 자연스럽게 익숙해진다.

다음 단계는 §4.4의 **합동**(congruence)이다. 합동은 가분성의 일반화이고, §4.1·§4.3의 모든 도구가 활용된다.

---

**부록. 짝꿍 문서 안내**

본 문서의 각 코드 블록에 대해 한 줄씩 정밀하게 InfoView 상태 변화를 기록한 짝꿍 문서가 **`ch4_3_lean4_code_explanation.md`**(코드 설명 자료)이다.
