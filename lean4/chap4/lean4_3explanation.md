
# Lean 4 4.3


주제는 자연수 소수성, 소인수분해, 소수의 무한성, 최대공약수와 최소공배수, 유클리드 알고리즘, 베주 항등식, 유클리드 보조정리이다.

주의할 점이 있다. 여러 슬라이드에서 다음과 같은 코드는 "Mathlib에 이미 있는 정의 또는 정리의 모양을 설명하기 위한 코드"이다.

```lean
def Nat.gcd ...
def Nat.lcm ...
theorem Nat.gcd_mul_lcm ...
theorem Int.gcd_eq_gcd_ab ...
```

이 이름들은 Mathlib에 이미 존재한다. 실제 Lean 파일에서 같은 이름으로 다시 선언하면 이름 충돌이 난다.실제 사용 예제에서는 `example`을 쓰거나 `my_...` 같은 새 이름을 붙이는 것이 안전하다.

학습용 파일에서는 보통 다음처럼 넓은 import를 쓰면 대부분의 예제가 동작한다.

```lean
import Mathlib
```

더 정교하게 import를 나누려면 `Nat.Prime`, `Nat.Factors`, `Nat.Factorial`, `Nat.GCD`, `Int.GCD`, `Tactic` 관련 모듈을 불러와야 한다. Mathlib 버전에 따라 정확한 모듈 경로가 조금씩 달라질 수 있으므로, 초반 학습에서는 `import Mathlib`이 가장 단순하다.

---

## 0. 공통 Lean 문법과 전술 패턴

이 문서에서 반복해서 등장하는 Lean 패턴은 다음과 같다.

```lean
example : P := by
  ...
```

이름 없는 정리이다. `P`라는 명제를 증명하는 예제이다.

```lean
theorem my_theorem : P := by
  ...
```

이름 있는 정리이다. 나중에 `my_theorem`이라는 이름으로 다시 사용할 수 있다.

```lean
def f : A := ...
```

새로운 함수나 값을 정의한다.

```lean
#eval expression
```

표현식을 계산해서 결과를 출력한다. 증명 명령이 아니라 계산 확인용이다.

주요 전술은 다음과 같다.

| 전술 | 의미 | 자주 쓰는 상황 |
|---|---|---|
| `intro`, `intros` | 가정을 도입한다 | `P → Q`, `∀ x, ...` 증명 |
| `exact h` | 목표와 같은 증거 `h`를 제출한다 | 목표와 가정이 정확히 일치 |
| `rw [h]` | 등식 `h`로 rewrite 한다 | 식 변형 |
| `rw [← h]` | 등식 `h`를 반대 방향으로 rewrite 한다 | 식을 원래 정리의 반대 방향으로 바꿈 |
| `constructor` | `∧`, `↔` 목표를 성분별 목표로 나눈다 | 논리곱, 필요충분조건 |
| `left`, `right` | `P ∨ Q` 목표에서 왼쪽/오른쪽을 선택한다 | 논리합 증명 |
| `obtain ⟨...⟩ := h` | 복합 가정을 분해한다 | `∧`, `∃` 가정 분해 |
| `refine ⟨..., ?_, ...⟩` | 증거 객체를 일부만 채운다 | 존재명제, 구조체 증명 |
| `by_cases h : P` | `P` 참/거짓으로 경우를 나눈다 | 고전 논리, 배중률 활용 |
| `.mp`, `.mpr` | `A ↔ B`의 정방향/역방향을 사용한다 | 동치 정리 사용 |
| `.symm` | 등식의 좌우를 뒤집는다 | `a = b`에서 `b = a` |
| `omega`, `norm_num` | 산술 자동화 | 자연수/정수 계산과 부등식 |

Lean에서 증명은 "목표 명제 타입의 증거 객체를 구성하는 일"이다. 예를 들어 `P ∧ Q`를 증명하려면 `P`의 증거와 `Q`의 증거를 함께 만들어야 하고, `∃ x, P x`를 증명하려면 실제 증인 `x`와 `P x`의 증거를 함께 제시해야 한다.

---

## 1. `Nat.Prime`: 자연수 소수성

### 코드

```lean
-- Mathlib 정의의 개념적 모습
structure Nat.Prime (p : Nat) : Prop where
  two_le      : 2 ≤ p
  not_dvd_lt  : ∀ m, 2 ≤ m → m < p → ¬ m ∣ p

-- 사용 예
example : Nat.Prime 7 := by
  decide
```

### 설명

`Nat.Prime p`는 "자연수 `p`가 소수이다"라는 명제다. 여기서 `: Prop`은 이것이 계산 데이터가 아니라 증명해야 할 명제라는 뜻이다.

위의 `structure`는 실제 Mathlib 정의를 그대로 재정의하라는 뜻이 아니라, 소수성의 개념적 조건을 보여 주는 설명용 코드이다. 실제 Mathlib에서 `Nat.Prime p`는 이미 정의되어 있다.

소수 조건은 다음 두 가지로 이해할 수 있다.

```text
1. 2 ≤ p
2. 2 ≤ m < p 인 자연수 m 중 p를 나누는 m은 없다.
```

즉 `p = 7`이라면 다음을 확인해야 한다.

```text
2 ≤ 7
2 ∤ 7
3 ∤ 7
4 ∤ 7
5 ∤ 7
6 ∤ 7
```

`m ∣ p`는 "`m`이 `p`를 나눈다"는 뜻이고, `¬ m ∣ p`는 "`m`이 `p`를 나누지 못한다"는 뜻이다.

Lean에서 부정은 함수형으로 이해한다.

```lean
¬ P
```

는 내부적으로 다음과 같다.

```lean
P → False
```

따라서 `¬ m ∣ p`는 "`m ∣ p`라고 가정하면 모순이 나온다"는 뜻이다.

`example : Nat.Prime 7 := by decide`는 Lean에게 `7`이 소수라는 명제를 계산적으로 판정해서 증명하게 한다. 작은 자연수의 소수성은 `decide`나 `norm_num`으로 처리할 수 있다.

```lean
example : Nat.Prime 7 := by
  norm_num
```

---

## 2. 합성수는 작은 소인수를 가진다

### 코드

```lean
theorem composite_has_small_prime_factor
    (n : Nat) (h_comp : 1 < n ∧ ¬ Nat.Prime n) :
    ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n := by
  obtain ⟨h1, h_not_prime⟩ := h_comp

  have hn_pos    : 0 < n := by omega
  have hn_ne_one : n ≠ 1 := by omega

  set p := Nat.minFac n with hp_def

  have hp_prime : Nat.Prime p := Nat.minFac_prime hn_ne_one
  have hp_dvd   : p ∣ n        := Nat.minFac_dvd n

  have hp_sq : p * p ≤ n := by
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rw [pow_two] at h
    exact h

  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩
```

### 수학적 의미

이 정리는 다음을 말한다.

```text
n > 1이고 n이 소수가 아니면,
n을 나누는 어떤 소수 p가 존재하고,
p * p ≤ n 이다.
```

즉 합성수는 `√n` 이하의 소인수를 가진다는 고전적 사실이다. Lean에서는 제곱근 대신 다음 부등식을 쓴다.

```lean
p * p ≤ n
```

### 증명 흐름

처음 가정은 다음이다.

```lean
h_comp : 1 < n ∧ ¬ Nat.Prime n
```

이것을 분해한다.

```lean
obtain ⟨h1, h_not_prime⟩ := h_comp
```

이후 문맥에는 다음이 생긴다.

```lean
h1 : 1 < n
h_not_prime : ¬ Nat.Prime n
```

다음 두 보조 사실을 만든다.

```lean
have hn_pos    : 0 < n := by omega
have hn_ne_one : n ≠ 1 := by omega
```

`1 < n`이면 당연히 `0 < n`이고 `n ≠ 1`이다. `omega`가 이 자연수 산술을 자동으로 처리한다.

핵심은 최소 소인수이다.

```lean
set p := Nat.minFac n with hp_def
```

수학적으로는 다음이다.

```text
p := n의 최소 소인수
```

Mathlib는 최소 소인수에 대해 이미 세 가지 중요한 정리를 제공한다.

```lean
Nat.minFac_prime hn_ne_one
```

`n ≠ 1`이면 `Nat.minFac n`은 소수이다.

```lean
Nat.minFac_dvd n
```

`Nat.minFac n`은 `n`을 나눈다.

```lean
Nat.minFac_sq_le_self hn_pos h_not_prime
```

`n > 0`이고 `n`이 소수가 아니면, 최소 소인수의 제곱은 `n` 이하이다.

다만 `Nat.minFac_sq_le_self`가 주는 식은 보통 다음 모양이다.

```lean
p ^ 2 ≤ n
```

목표는 다음 모양이다.

```lean
p * p ≤ n
```

그래서 다음 rewrite를 쓴다.

```lean
rw [pow_two] at h
```

`pow_two`는 `p ^ 2 = p * p`라는 정리이다.

마지막으로 존재명제를 조립한다.

```lean
exact ⟨p, hp_prime, hp_sq, hp_dvd⟩
```

이는 다음을 한 번에 제출한다.

```text
증인: p
증명 1: p는 소수이다.
증명 2: p * p ≤ n 이다.
증명 3: p ∣ n 이다.
```

---

## 3. `Nat.primeFactorsList`: 소인수분해 리스트

### 코드

```lean
#eval Nat.primeFactorsList 100      -- [2, 2, 5, 5]
#eval Nat.primeFactorsList 999      -- [3, 3, 3, 37]
#eval Nat.primeFactorsList 641      -- [641]

-- 존재성: 분해 가능 (n ≠ 0 이면)
example (n : Nat) (h : n ≠ 0) :
    (Nat.primeFactorsList n).prod = n :=
  Nat.prod_primeFactorsList h

-- 모든 인수가 소수임
example (n : Nat) :
    ∀ p ∈ Nat.primeFactorsList n, Nat.Prime p :=
  fun _ hp => Nat.prime_of_mem_primeFactorsList hp
```

### 설명

`Nat.primeFactorsList n`은 자연수 `n`의 소인수분해를 리스트로 반환한다. 중복을 포함한다.

예를 들어:

```text
100 = 2 * 2 * 5 * 5
```

이므로:

```lean
Nat.primeFactorsList 100 = [2, 2, 5, 5]
```

`999`는:

```text
999 = 3 * 3 * 3 * 37
```

이므로:

```lean
Nat.primeFactorsList 999 = [3, 3, 3, 37]
```

`641`은 소수이므로:

```lean
Nat.primeFactorsList 641 = [641]
```

### 리스트의 곱은 원래 수

```lean
example (n : Nat) (h : n ≠ 0) :
    (Nat.primeFactorsList n).prod = n :=
  Nat.prod_primeFactorsList h
```

이 정리는 다음을 말한다.

```text
n ≠ 0이면,
primeFactorsList n의 모든 원소를 곱하면 다시 n이 된다.
```

`n ≠ 0` 조건이 필요한 이유는 `primeFactorsList 0 = []`이고, 빈 리스트의 곱은 `1`이기 때문이다. 따라서 `n = 0`이면:

```text
[].prod = 1 ≠ 0
```

이다.

### 리스트의 모든 원소는 소수

```lean
example (n : Nat) :
    ∀ p ∈ Nat.primeFactorsList n, Nat.Prime p :=
  fun _ hp => Nat.prime_of_mem_primeFactorsList hp
```

Lean의 문법:

```lean
∀ p ∈ Nat.primeFactorsList n, Nat.Prime p
```

는 다음의 축약형이다.

```lean
∀ p, p ∈ Nat.primeFactorsList n → Nat.Prime p
```

즉:

```text
p가 primeFactorsList n 안에 들어 있다면 p는 소수이다.
```

`fun _ hp => ...`에서 `_`는 원소 `p`의 이름을 생략한 것이다. `hp`는 다음 타입의 증거이다.

```lean
hp : p ∈ Nat.primeFactorsList n
```

그러면 Mathlib 정리:

```lean
Nat.prime_of_mem_primeFactorsList hp
```

가 바로 다음을 줍니다.

```lean
Nat.Prime p
```

전술 모드로 쓰면 다음과 같다.

```lean
example (n : Nat) :
    ∀ p ∈ Nat.primeFactorsList n, Nat.Prime p := by
  intro p hp
  exact Nat.prime_of_mem_primeFactorsList hp
```

---

## 4. 유클리드의 소수 무한성 증명

### 코드

```lean
import Mathlib

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

  -- p ≤ N이라고 가정하면 모순. 따라서 N < p, 특히 N ≤ p.
  exact (Nat.lt_of_not_le (fun h : p ≤ N =>
    -- p ≤ N 이면 p는 N!의 약수이다.
    have h_p_div_fact : p ∣ Nat.factorial N :=
      Nat.dvd_factorial (Nat.Prime.pos hp_prime) h

    -- p는 Q의 최소 소인수이므로 Q를 나눈다.
    have h_p_div_Q : p ∣ Q := by
      rw [hp]
      exact Nat.minFac_dvd Q

    -- p가 N!과 N! + 1을 모두 나누면 1도 나눈다.
    have h_p_div_one : p ∣ 1 := by
      rw [hQ] at h_p_div_Q
      exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q

    -- 소수가 1을 나누는 것은 불가능하다.
    show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
  )).le
```

### 정리의 의미

```lean
theorem my_infinite_primes (N : Nat) : ∃ p, N ≤ p ∧ Nat.Prime p
```

뜻은 다음이다.

```text
임의의 자연수 N에 대해,
N 이상인 어떤 소수 p가 존재한다.
```

즉 소수는 무한히 많다는 유클리드 정리의 한 형태이다. 사실 이 증명은 더 강하게 `N < p`를 보이다.

### 수학적 아이디어

```text
Q := N! + 1
p := Q의 최소 소인수
```

그러면 `p`는 소수이고 `p ∣ Q`이다. 만약 `p ≤ N`이라면 `p`는 `N!`을 나눈다. 그런데 동시에 `p ∣ Q = N! + 1`이다. 그러면 `p`는 차이인 `1`도 나눈다. 하지만 소수는 `1`을 나눌 수 없습니다. 모순이다. 따라서 `p ≤ N`은 불가능하고, `N < p`이다.

### 핵심 단계

`Q`를 도입한다.

```lean
set Q := Nat.factorial N + 1 with hQ
```

이후:

```lean
hQ : Q = Nat.factorial N + 1
```

이 생깁니다.

`Q ≥ 2`를 보이다.

```lean
have hQ_ge : 2 ≤ Q := by
  rw [hQ]
  have := Nat.factorial_pos N
  omega
```

`Nat.factorial_pos N`은 `0 < N!`를 줍니다. 따라서 `2 ≤ N! + 1`이다.

최소 소인수를 잡습니다.

```lean
set p := Nat.minFac Q with hp
have hp_prime : Nat.Prime p := Nat.minFac_prime (by omega)
```

`Q ≥ 2`이므로 `Q ≠ 1`이고, `Nat.minFac_prime`으로 `p`가 소수임을 얻습니다.

결론은 존재명제이다.

```lean
refine ⟨p, ?_, hp_prime⟩
```

증인 `p`를 제시하고, `Nat.Prime p`는 `hp_prime`으로 해결한다. 남은 목표는:

```lean
N ≤ p
```

이다.

이를 귀류적으로 보이다. `p ≤ N`이라고 가정하면:

```lean
have h_p_div_fact : p ∣ Nat.factorial N :=
  Nat.dvd_factorial (Nat.Prime.pos hp_prime) h
```

`p`가 양수이고 `p ≤ N`이면 `p ∣ N!`이다.

또한:

```lean
have h_p_div_Q : p ∣ Q := by
  rw [hp]
  exact Nat.minFac_dvd Q
```

`p`는 `Q`의 최소 소인수이므로 `Q`를 나눈다.

`Q = N! + 1`이므로:

```lean
rw [hQ] at h_p_div_Q
```

이후:

```lean
h_p_div_Q : p ∣ Nat.factorial N + 1
```

이다.

이제 `p ∣ N!`이고 `p ∣ N! + 1`이면 `p ∣ 1`이다.

```lean
exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
```

하지만 소수는 `1`을 나눌 수 없습니다.

```lean
Nat.Prime.not_dvd_one hp_prime h_p_div_one : False
```

따라서 `p ≤ N`은 모순이고, `N < p`, 그래서 `N ≤ p`이다.

---

## 5. `Nat.gcd`: 최대공약수

### 코드

```lean
-- Mathlib의 정의를 간소화한 개념적 모습
-- 실제 파일에서 Nat.gcd를 다시 정의하면 안 된다.
def Nat.gcd : Nat → Nat → Nat
  | 0,     y => y
  | x + 1, y => Nat.gcd (y % (x + 1)) (x + 1)

-- 사용
#eval Nat.gcd 24 36     -- 12
#eval Nat.gcd 120 500   -- 20
#eval Nat.gcd 17 13     -- 1

-- 정리: 둘 중 적어도 하나가 0이 아니면 gcd는 양수
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  rw [Nat.gcd_pos_iff]
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h
```

### 정의의 의미

개념적으로 `Nat.gcd`는 유클리드 알고리즘이다.

```text
gcd(0, y) = y
gcd(x + 1, y) = gcd(y % (x + 1), x + 1)
```

예를 들어:

```text
gcd(24, 36)
= gcd(36 % 24, 24)
= gcd(12, 24)
= gcd(24 % 12, 12)
= gcd(0, 12)
= 12
```

### `gcd`가 양수인 조건

정리:

```lean
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  rw [Nat.gcd_pos_iff]
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h
```

주석은 정확히는 다음이어야 한다.

```text
두 수가 동시에 0이 아니면 gcd는 양수이다.
```

즉 `a ≠ 0 ∨ b ≠ 0`이다. "둘 다 0이 아니다"라면 `a ≠ 0 ∧ b ≠ 0`이므로 다릅니다.

`Nat.gcd_pos_iff`는 다음 동치이다.

```lean
0 < Nat.gcd a b ↔ 0 < a ∨ 0 < b
```

따라서 목표:

```lean
0 < Nat.gcd a b
```

는 rewrite 후:

```lean
0 < a ∨ 0 < b
```

가 된다.

우리가 가진 가정은:

```lean
h : a ≠ 0 ∨ b ≠ 0
```

자연수에서는 다음이 성립한다.

```lean
Nat.pos_iff_ne_zero : 0 < n ↔ n ≠ 0
```

그래서 `← Nat.pos_iff_ne_zero`를 사용해 `a ≠ 0`, `b ≠ 0`를 각각 `0 < a`, `0 < b`로 바꾼다.

```lean
rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h
```

`rwa`는 `rw` 후 `exact`까지 하는 전술이다. 즉 가정 `h`를 목표와 같은 모양으로 바꾼 뒤 그대로 사용한다.

---

## 6. `Nat.lcm`: 최소공배수와 `gcd_mul_lcm`

### 코드

```lean
-- Mathlib에서 lcm은 gcd로 정의된다. 설명용 코드.
def Nat.lcm (m n : Nat) : Nat := m * n / Nat.gcd m n

#eval Nat.lcm 4 6        -- 12
#eval Nat.lcm 120 500    -- 3000

-- 핵심 성질: gcd(a,b) · lcm(a,b) = a · b
example (m n : Nat) :
    Nat.gcd m n * Nat.lcm m n = m * n :=
  Nat.gcd_mul_lcm m n
```

### 설명

`Nat.lcm m n`은 `m`과 `n`의 최소공배수이다. 수학적으로 다음 공식이 성립한다.

```text
lcm(m, n) = m * n / gcd(m, n)
```

그리고 핵심 정리는 다음이다.

```lean
Nat.gcd_mul_lcm m n :
    Nat.gcd m n * Nat.lcm m n = m * n
```

즉:

```text
gcd(m,n) × lcm(m,n) = m × n
```

예를 들어:

```text
gcd(120, 500) = 20
lcm(120, 500) = 3000
20 * 3000 = 120 * 500 = 60000
```

---

## 7. `gcd_mul_lcm`에서 `lcm = a*b/gcd` 유도

### 코드

```lean
-- 사용 예: lcm을 gcd로부터 계산
example (a b : Nat) (h : Nat.gcd a b ≠ 0) :
    Nat.lcm a b = a * b / Nat.gcd a b := by
  rw [← Nat.gcd_mul_lcm a b]
  rw [Nat.mul_div_cancel_left _ (Nat.pos_of_ne_zero h)]

-- 검증
example : Nat.gcd 120 500 * Nat.lcm 120 500 = 120 * 500 := by
  rw [Nat.gcd_mul_lcm]
```

### 첫 번째 예제 설명

목표는 다음이다.

```lean
Nat.lcm a b = a * b / Nat.gcd a b
```

즉:

```text
lcm(a,b) = a*b/gcd(a,b)
```

먼저 핵심 정리:

```lean
Nat.gcd_mul_lcm a b :
  Nat.gcd a b * Nat.lcm a b = a * b
```

를 반대 방향으로 rewrite한다.

```lean
rw [← Nat.gcd_mul_lcm a b]
```

그러면 오른쪽의 `a * b`가 다음으로 바뀐다.

```lean
Nat.gcd a b * Nat.lcm a b
```

목표는 다음 꼴이 된다.

```lean
Nat.lcm a b =
  (Nat.gcd a b * Nat.lcm a b) / Nat.gcd a b
```

이제 오른쪽에서 `Nat.gcd a b`를 약분한다.

```lean
rw [Nat.mul_div_cancel_left _ (Nat.pos_of_ne_zero h)]
```

`Nat.mul_div_cancel_left`는 다음 형태이다.

```lean
n * m / n = m
```

단, `0 < n`이 필요하다. 여기서 `n := Nat.gcd a b`이다. 그래서 가정:

```lean
h : Nat.gcd a b ≠ 0
```

를 사용해:

```lean
Nat.pos_of_ne_zero h : 0 < Nat.gcd a b
```

를 만듭니다.

두 번째 `rw` 후 목표는:

```lean
Nat.lcm a b = Nat.lcm a b
```

가 되어 끝난다.

참고로 Mathlib에는 이 공식을 직접 주는 정리도 있다.

```lean
example (a b : Nat) :
    Nat.lcm a b = a * b / Nat.gcd a b :=
  Nat.lcm_eq_mul_div a b
```

위의 증명은 `gcd_mul_lcm`에서 나눗셈 약분으로 직접 공식을 유도하는 연습이다.

---

## 8. `Nat.gcd_rec`: 유클리드 알고리즘 한 단계

### 코드

```lean
-- 설명용. 실제 Mathlib에 이미 있는 정리.
example (a b : Nat) :
    Nat.gcd a b = Nat.gcd (b % a) a :=
  Nat.gcd_rec a b

example (a b : Nat) (h : b ≠ 0) :
    Nat.gcd a b = Nat.gcd b (a % b) := by
  rw [Nat.gcd_comm a b]
  rw [Nat.gcd_rec b a]
  rw [Nat.gcd_comm]

-- 검증
#eval Nat.gcd 414 662           -- 2
#eval Nat.gcd 662 (414 % 662)   -- 2
#eval Nat.gcd 414 (662 % 414)   -- 2
```

### `Nat.gcd_rec`

`Nat.gcd_rec a b`는 다음 정리이다.

```lean
Nat.gcd a b = Nat.gcd (b % a) a
```

수학적으로는:

```text
gcd(a,b) = gcd(b mod a, a)
```

이다.

교과서에서 더 자주 보는 형태는 다음이다.

```text
gcd(a,b) = gcd(b, a mod b)
```

이 형태를 얻기 위해 `Nat.gcd_comm`을 사용한다.

### 두 번째 예제의 증명 흐름

목표:

```lean
Nat.gcd a b = Nat.gcd b (a % b)
```

첫 번째 rewrite:

```lean
rw [Nat.gcd_comm a b]
```

왼쪽을 바꾼다.

```lean
Nat.gcd a b
```

가:

```lean
Nat.gcd b a
```

가 된다.

두 번째 rewrite:

```lean
rw [Nat.gcd_rec b a]
```

`Nat.gcd b a`를 다음으로 바꾼다.

```lean
Nat.gcd (a % b) b
```

세 번째 rewrite:

```lean
rw [Nat.gcd_comm]
```

`Nat.gcd (a % b) b`를 `Nat.gcd b (a % b)`로 바꾼다. 목표는 양변이 같아져 닫힌다.

`h : b ≠ 0`은 수학적 직관상 붙어 있지만, 이 증명에서는 사용되지 않는다. Lean의 자연수 나머지 연산은 `b = 0`일 때도 정의되어 있으므로, 이 예제는 사실 `h` 없이도 성립한다.

---

## 9. 직접 구현한 유클리드 알고리즘 `myGcd`

### 의도 코드

```lean
def myGcd : Nat → Nat → Nat
  | a, 0 => a
  | a, b+1 => myGcd (b+1) (a % (b+1))
```

이 정의는 교과서식 유클리드 알고리즘이다.

```text
myGcd(a, 0) = a
myGcd(a, b+1) = myGcd(b+1, a mod (b+1))
```

두 번째 인수가 매번 다음 값으로 바뀐다.

```lean
a % (b + 1)
```

나머지는 항상 나누는 수보다 작습니다.

```lean
Nat.mod_lt a (Nat.succ_pos b) : a % (b+1) < b+1
```

따라서 재귀가 종료된다.

환경에 따라 Lean이 종료성을 자동으로 못 잡을 수 있으므로, 안전한 정의는 다음처럼 작성할 수 있다.

```lean
def myGcd (a b : Nat) : Nat :=
  match b with
  | 0 => a
  | b' + 1 => myGcd (b' + 1) (a % (b' + 1))
termination_by b
decreasing_by
  exact Nat.mod_lt _ (Nat.succ_pos _)
```

### 정당성 정리

```lean
theorem myGcd_eq (a b : Nat) : myGcd a b = Nat.gcd a b := by
  revert a
  induction b using Nat.strong_induction_on with
  | _ b ih =>
      intro a
      match b with
      | 0 =>
          rw [myGcd, Nat.gcd_zero_right]
      | b + 1 =>
          calc
            myGcd a (b + 1)
                = myGcd (b + 1) (a % (b + 1)) := by
                    rw [myGcd]
            _   = Nat.gcd (b + 1) (a % (b + 1)) :=
                    ih (a % (b + 1)) (Nat.mod_lt a (Nat.succ_pos b)) (b + 1)
            _   = Nat.gcd (a % (b + 1)) (b + 1) :=
                    Nat.gcd_comm (b + 1) (a % (b + 1))
            _   = Nat.gcd (b + 1) a :=
                    (Nat.gcd_rec (b + 1) a).symm
            _   = Nat.gcd a (b + 1) :=
                    Nat.gcd_comm (b + 1) a
```

### 설명

목표는 다음이다.

```lean
myGcd a b = Nat.gcd a b
```

즉 직접 구현한 `myGcd`가 Mathlib의 표준 `Nat.gcd`와 항상 같은 값을 낸다는 것이다.

증명은 두 번째 인수 `b`에 대한 강한 귀납법이다. 강한 귀납법을 쓰는 이유는 재귀 호출의 두 번째 인수가 `b-1`이 아니라 `a % b`처럼 임의의 더 작은 수로 바뀌기 때문이다.

```lean
revert a
```

이 줄은 `a`를 다시 목표 안으로 넣어:

```lean
∀ a, myGcd a b = Nat.gcd a b
```

형태로 만듭니다. 이것이 필요한 이유는 재귀 호출에서 첫 번째 인수가 바뀌기 때문이다.

```lean
myGcd a (b+1)
= myGcd (b+1) (a % (b+1))
```

귀납가정은 작은 두 번째 인수에 대해 모든 첫 번째 인수를 허용해야 한다.

기저 경우 `b = 0`에서는:

```text
myGcd(a, 0) = a
gcd(a, 0) = a
```

이므로 끝납니다.

재귀 경우 `b + 1`에서는:

```text
myGcd(a, b+1)
= myGcd(b+1, a mod (b+1))       -- 정의
= gcd(b+1, a mod (b+1))         -- 귀납가정
= gcd(a mod (b+1), b+1)         -- 교환법칙
= gcd(b+1, a)                   -- gcd_rec의 대칭
= gcd(a, b+1)                   -- 교환법칙
```

따라서 `myGcd`가 실제로 gcd를 반환함이 기계적으로 검증된다.

---

## 10. `Int.gcdA`, `Int.gcdB`: 베주 항등식

### 코드

```lean
-- Mathlib의 Int.gcd_eq_gcd_ab
-- Nat은 음의 계수를 다루기 어려우므로 Int 버전이 표준

example (a b : Int) :
    (Int.gcd a b : Int) = a * Int.gcdA a b + b * Int.gcdB a b :=
  Int.gcd_eq_gcd_ab a b

-- 검증
#eval Int.gcd  252 198      -- 18
#eval Int.gcdA 252 198      -- 4
#eval Int.gcdB 252 198      -- -5
#eval (252 : Int) * 4 + 198 * (-5)   -- 18

example : (252 : Int) * 4 + 198 * (-5) = 18 := by
  norm_num
```

### 중요한 정정

다음 계수는 `18`을 만들지 않는다.

```lean
#eval Int.gcdA 252 198    -- s₀ = -3
#eval Int.gcdB 252 198    -- t₀ = 4
#eval (252 : Int) * (-3) + 198 * 4    -- 18
```

실제로 계산하면:

```text
252 * (-3) + 198 * 4
= -756 + 792
= 36
```

따라서 이 예제는 잘못된 검증이다. `252`, `198`에 대해 Mathlib가 주는 계수가 `4`, `-5`라면:

```text
252 * 4 + 198 * (-5)
= 1008 - 990
= 18
```

이다.

### 베주 항등식

정리:

```lean
(Int.gcd a b : Int) = a * Int.gcdA a b + b * Int.gcdB a b
```

는 베주 항등식이다.

```text
gcd(a,b) = a*s + b*t
```

여기서:

```lean
s = Int.gcdA a b
t = Int.gcdB a b
```

이다.

`Int.gcd a b`는 이름은 `Int.gcd`이지만 값은 자연수이다. 최대공약수는 음수가 아니기 때문이다. 오른쪽은 정수식이므로 왼쪽을 정수로 캐스팅한다.

```lean
(Int.gcd a b : Int)
```

---

## 11. 모듈러 역원 후보

### 코드

```lean
-- 모듈러 역원 후보
noncomputable def modInv (a m : Int) : Int :=
  (Int.gcdA a m) % m
```

### 설명

`a`와 `m`이 서로소이면:

```text
gcd(a,m) = 1
```

베주 항등식에 의해 어떤 정수 `s`, `t`가 존재해서:

```text
1 = a*s + m*t
```

이다.

이를 `mod m`으로 보면:

```text
a*s ≡ 1 (mod m)
```

이다. 따라서 `s`는 `a`의 `mod m` 역원이다. Mathlib에서는 이 `s`를 다음으로 잡는다.

```lean
Int.gcdA a m
```

그래서 역원 후보를:

```lean
(Int.gcdA a m) % m
```

로 정의한다.

단, `a`와 `m`이 서로소일 때만 진짜 역원이다. 예를 들어 `a = 2`, `m = 4`이면 `gcd(2,4)=2`이므로 역원이 없다. 따라서 정확한 명제는 다음 형태이다.

```text
Int.gcd a m = 1 이면,
a * modInv a m ≡ 1 (mod m).
```

Lean에서는 합동을 보통 `Int.ModEq`로 표현한다.

---

## 12. 유클리드 보조정리: 소수가 곱을 나누면 한쪽을 나눈다

### 코드

```lean
-- Mathlib의 Nat.Prime.dvd_mul

theorem euclid_lemma (p a b : Nat) (hp : Nat.Prime p) :
    p ∣ a * b → p ∣ a ∨ p ∣ b :=
  (Nat.Prime.dvd_mul hp).mp
```

### 설명

이 정리는 다음 수학 명제이다.

```text
p가 소수이고 p ∣ a*b 이면,
p ∣ a 또는 p ∣ b 이다.
```

`Nat.Prime.dvd_mul hp`는 다음 동치이다.

```lean
p ∣ a * b ↔ p ∣ a ∨ p ∣ b
```

동치 `A ↔ B`에서:

```lean
.mp  : A → B
.mpr : B → A
```

이다. 따라서:

```lean
(Nat.Prime.dvd_mul hp).mp
```

는 다음 함수이다.

```lean
p ∣ a * b → p ∣ a ∨ p ∣ b
```

정리의 결론과 정확히 일치하므로 한 줄로 증명된다.

전술 모드로 쓰면:

```lean
theorem euclid_lemma' (p a b : Nat) (hp : Nat.Prime p) :
    p ∣ a * b → p ∣ a ∨ p ∣ b := by
  intro h
  exact (Nat.Prime.dvd_mul hp).mp h
```

---

## 13. 유클리드 보조정리의 경우 나누기 증명

### 코드

```lean
example (p a b : Nat) (hp : Nat.Prime p) (h : p ∣ a * b) :
    p ∣ a ∨ p ∣ b := by
  by_cases ha : p ∣ a
  · left
    exact ha
  · right
    -- gcd(p, a) = 1, 즉 서로소
    have hcop : Nat.Coprime p a :=
      (hp.coprime_iff_not_dvd).mpr ha
    -- 서로소 + p ∣ a*b → p ∣ b
    exact (Nat.Coprime.dvd_mul_left hcop).mp h
```

### 설명

증명 전략은 다음이다.

```text
p ∣ a 인지 아닌지로 나눈다.

1. p ∣ a이면 결론 p ∣ a ∨ p ∣ b는 바로 참이다.
2. p ∤ a이면, p가 소수이므로 p와 a는 서로소이다.
   서로소인 p와 a에 대해 p ∣ a*b이면 p ∣ b이다.
```

경우 나누기:

```lean
by_cases ha : p ∣ a
```

첫 번째 경우에는:

```lean
ha : p ∣ a
```

가 있으므로:

```lean
left
exact ha
```

로 끝납니다.

두 번째 경우에는:

```lean
ha : ¬ p ∣ a
```

이다. 목표는:

```lean
p ∣ a ∨ p ∣ b
```

인데, 왼쪽은 거짓인 경우이므로 오른쪽을 선택한다.

```lean
right
```

이후 목표는:

```lean
p ∣ b
```

이다.

소수 `p`가 `a`를 나누지 않으면 `p`와 `a`는 서로소이다.

```lean
have hcop : Nat.Coprime p a :=
  (hp.coprime_iff_not_dvd).mpr ha
```

여기서 `hp.coprime_iff_not_dvd`는 다음 동치이다.

```lean
Nat.Coprime p a ↔ ¬ p ∣ a
```

우리는 오른쪽 `¬ p ∣ a`를 가지고 있으므로 `.mpr`로 왼쪽 `Nat.Coprime p a`를 얻는다.

마지막으로 서로소 약분 정리를 사용한다.

```lean
exact (Nat.Coprime.dvd_mul_left hcop).mp h
```

`Nat.Coprime.dvd_mul_left hcop`는 다음 동치이다.

```lean
p ∣ a * b ↔ p ∣ b
```

그리고 `h : p ∣ a * b`가 있으므로 `.mp h`로 `p ∣ b`를 얻는다.

---

## 14. 전체 주제 연결

지금까지 다룬 내용은 하나의 흐름으로 연결된다.

```text
소수 Nat.Prime
  ↓
소인수 Nat.minFac, primeFactorsList
  ↓
합성수는 작은 소인수를 가짐
  ↓
N! + 1을 이용한 소수 무한성
  ↓
gcd와 lcm
  ↓
유클리드 알고리즘
  ↓
확장 유클리드 알고리즘과 베주 항등식
  ↓
모듈러 역원
  ↓
유클리드 보조정리
```

Mathlib는 많은 정리를 이미 제공한다. Lean 학습의 핵심은 이 정리들을 외워서 쓰는 것이 아니라, 다음을 익히는 것이다.

```text
1. 목표가 어떤 논리 구조인지 본다.
2. 필요한 정리를 찾는다.
3. 목표와 정리의 모양을 rw, simpa, exact, refine 등으로 맞춘다.
4. 존재명제는 증인과 증명을 조립한다.
5. 부정은 X → False로 이해한다.
6. 동치 A ↔ B는 .mp와 .mpr로 방향을 선택한다.
```

---

## 15. 한 파일에 넣을 수 있는 정리된 코드 모음

아래 코드는 위 내용을 실습하기 위한 정리본이다. Mathlib 버전에 따라 일부 정리 이름이나 import가 달라질 수 있으므로, 학습용으로는 `import Mathlib`를 권장한다.

```lean
import Mathlib

/-! ## 1. 소수 예제 -/

example : Nat.Prime 7 := by
  norm_num

/-! ## 2. 합성수는 작은 소인수를 가진다 -/

theorem composite_has_small_prime_factor
    (n : Nat) (h_comp : 1 < n ∧ ¬ Nat.Prime n) :
    ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n := by
  obtain ⟨h1, h_not_prime⟩ := h_comp
  have hn_pos    : 0 < n := by omega
  have hn_ne_one : n ≠ 1 := by omega
  set p := Nat.minFac n with hp_def
  have hp_prime : Nat.Prime p := Nat.minFac_prime hn_ne_one
  have hp_dvd   : p ∣ n        := Nat.minFac_dvd n
  have hp_sq : p * p ≤ n := by
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rw [pow_two] at h
    exact h
  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩

/-! ## 3. 소인수분해 리스트 -/

#eval Nat.primeFactorsList 100
#eval Nat.primeFactorsList 999
#eval Nat.primeFactorsList 641

example (n : Nat) (h : n ≠ 0) :
    (Nat.primeFactorsList n).prod = n :=
  Nat.prod_primeFactorsList h

example (n : Nat) :
    ∀ p ∈ Nat.primeFactorsList n, Nat.Prime p := by
  intro p hp
  exact Nat.prime_of_mem_primeFactorsList hp

/-! ## 4. 소수 무한성 -/

theorem my_infinite_primes (N : Nat) : ∃ p, N ≤ p ∧ Nat.Prime p := by
  set Q := Nat.factorial N + 1 with hQ
  have hQ_ge : 2 ≤ Q := by
    rw [hQ]
    have := Nat.factorial_pos N
    omega
  set p := Nat.minFac Q with hp
  have hp_prime : Nat.Prime p := Nat.minFac_prime (by omega)
  refine ⟨p, ?_, hp_prime⟩
  exact (Nat.lt_of_not_le (fun h : p ≤ N =>
    have h_p_div_fact : p ∣ Nat.factorial N :=
      Nat.dvd_factorial (Nat.Prime.pos hp_prime) h
    have h_p_div_Q : p ∣ Q := by
      rw [hp]
      exact Nat.minFac_dvd Q
    have h_p_div_one : p ∣ 1 := by
      rw [hQ] at h_p_div_Q
      exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
    show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
  )).le

/-! ## 5. gcd 양수성 -/

#eval Nat.gcd 24 36
#eval Nat.gcd 120 500
#eval Nat.gcd 17 13

example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) :
    0 < Nat.gcd a b := by
  rw [Nat.gcd_pos_iff]
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h

/-! ## 6. gcd와 lcm -/

#eval Nat.lcm 4 6
#eval Nat.lcm 120 500

example (m n : Nat) :
    Nat.gcd m n * Nat.lcm m n = m * n :=
  Nat.gcd_mul_lcm m n

example (a b : Nat) (h : Nat.gcd a b ≠ 0) :
    Nat.lcm a b = a * b / Nat.gcd a b := by
  rw [← Nat.gcd_mul_lcm a b]
  rw [Nat.mul_div_cancel_left _ (Nat.pos_of_ne_zero h)]

example : Nat.gcd 120 500 * Nat.lcm 120 500 = 120 * 500 := by
  rw [Nat.gcd_mul_lcm]

/-! ## 7. gcd_rec -/

example (a b : Nat) :
    Nat.gcd a b = Nat.gcd (b % a) a :=
  Nat.gcd_rec a b

example (a b : Nat) :
    Nat.gcd a b = Nat.gcd b (a % b) := by
  rw [Nat.gcd_comm a b]
  rw [Nat.gcd_rec b a]
  rw [Nat.gcd_comm]

#eval Nat.gcd 414 662
#eval Nat.gcd 662 (414 % 662)
#eval Nat.gcd 414 (662 % 414)

/-! ## 8. 직접 구현한 gcd -/

def myGcd (a b : Nat) : Nat :=
  match b with
  | 0 => a
  | b' + 1 => myGcd (b' + 1) (a % (b' + 1))
termination_by b
decreasing_by
  exact Nat.mod_lt _ (Nat.succ_pos _)

theorem myGcd_eq (a b : Nat) : myGcd a b = Nat.gcd a b := by
  revert a
  induction b using Nat.strong_induction_on with
  | _ b ih =>
      intro a
      match b with
      | 0 =>
          rw [myGcd, Nat.gcd_zero_right]
      | b + 1 =>
          calc
            myGcd a (b + 1)
                = myGcd (b + 1) (a % (b + 1)) := by
                    rw [myGcd]
            _   = Nat.gcd (b + 1) (a % (b + 1)) :=
                    ih (a % (b + 1)) (Nat.mod_lt a (Nat.succ_pos b)) (b + 1)
            _   = Nat.gcd (a % (b + 1)) (b + 1) :=
                    Nat.gcd_comm (b + 1) (a % (b + 1))
            _   = Nat.gcd (b + 1) a :=
                    (Nat.gcd_rec (b + 1) a).symm
            _   = Nat.gcd a (b + 1) :=
                    Nat.gcd_comm (b + 1) a

/-! ## 9. Int gcdA/gcdB와 베주 항등식 -/

example (a b : Int) :
    (Int.gcd a b : Int) = a * Int.gcdA a b + b * Int.gcdB a b :=
  Int.gcd_eq_gcd_ab a b

#eval Int.gcd 252 198
#eval Int.gcdA 252 198
#eval Int.gcdB 252 198
#eval (252 : Int) * 4 + 198 * (-5)

example : (252 : Int) * 4 + 198 * (-5) = 18 := by
  norm_num

noncomputable def modInv (a m : Int) : Int :=
  (Int.gcdA a m) % m

/-! ## 10. 유클리드 보조정리 -/

theorem euclid_lemma (p a b : Nat) (hp : Nat.Prime p) :
    p ∣ a * b → p ∣ a ∨ p ∣ b :=
  (Nat.Prime.dvd_mul hp).mp

example (p a b : Nat) (hp : Nat.Prime p) (h : p ∣ a * b) :
    p ∣ a ∨ p ∣ b := by
  by_cases ha : p ∣ a
  · left
    exact ha
  · right
    have hcop : Nat.Coprime p a :=
      (hp.coprime_iff_not_dvd).mpr ha
    exact (Nat.Coprime.dvd_mul_left hcop).mp h
```

---

## 16. 최종 요약

이 전체 코드 묶음은 Lean에서 수론을 다루는 기본 패턴을 보여 준다.

첫째, `Nat.Prime`, `Nat.minFac`, `Nat.primeFactorsList`를 통해 소수와 소인수분해를 다룬다.

둘째, `Nat.factorial N + 1`과 최소 소인수를 이용해 소수가 무한히 많다는 유클리드 증명을 Lean으로 구현한다.

셋째, `Nat.gcd`, `Nat.lcm`, `Nat.gcd_rec`, `Nat.gcd_mul_lcm`을 통해 유클리드 알고리즘과 최대공약수/최소공배수 관계를 형식화한다.

넷째, 직접 구현한 `myGcd`가 Mathlib의 `Nat.gcd`와 같다는 정리를 통해 알고리즘 검증의 기본 형태를 확인한다.

다섯째, `Int.gcdA`, `Int.gcdB`를 통해 확장 유클리드 알고리즘과 베주 항등식을 다룬다.

마지막으로, `Nat.Prime.dvd_mul`과 서로소 약분 정리를 통해 유클리드 보조정리를 증명한다.

핵심은 Lean이 단순히 계산만 하는 것이 아니라, 각 알고리즘과 정리가 실제로 올바르다는 것을 명제와 증명 객체로 엄밀하게 확인한다는 점이다.
