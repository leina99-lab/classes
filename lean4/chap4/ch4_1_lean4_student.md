# 4.1 Lean 4 학생 자료 - 가분성과 모듈러 산술

> 본 자료는 §4.1 강의에서 다룬 모든 Lean 4 코드를, **Lean 4**(린 포)를 처음 접하는 학습자가 한 줄씩 따라갈 수 있도록 자세히 풀어 쓴 것이다. 외부 자료를 따로 찾아보지 않아도 본 문서만으로 충분히 이해하고 손으로 따라 칠 수 있게 구성하였다.
>
> 짝꿍 문서로 **`ch4_1_lean4_code_explanation.md`**(코드 설명 자료)가 있다. 본 문서가 "왜 이렇게 쓰는가"를 풀어 준다면, 짝꿍 문서는 "한 줄을 누르면 화면 오른쪽 InfoView에 무엇이 보이는가"를 한 줄씩 기록한 정밀 해설서이다. 두 문서를 나란히 펴 놓고 읽으면 가장 효과적이다.

---

## 1. 들어가며

§4.1 강의에서는 **가분성**(divisibility)이라는 정수론의 가장 기초적인 관계를 배웠다. "a가 b를 나눈다"는 표현은 "b가 a의 배수다", "b는 a로 나누어떨어진다"와 같은 말이다. 이를 기호로 `a ∣ b`로 적는다(특수 기호 ∣, 단순 막대기 `|`가 아님).

본 자료에서 할 일은 이 가분성 관계를 컴퓨터가 한 치의 오차도 없이 검사하는 형태로 옮기는 것이다. 그 도구가 Lean 4이다.

본 자료를 다 따라가고 나면 다음을 할 수 있게 된다.

1. Lean 4에서 가분성 `a ∣ b`가 어떻게 정의되어 있는지 안다.
2. 가분성의 자명한 사실(`a ∣ 0`, `a ∣ a`, `1 ∣ a`)을 직접 증명할 수 있다.
3. 가분성의 결합 성질(합, 차, 곱, 선형 결합, 추이성)을 Mathlib의 보조 정리로 닫을 수 있다.
4. 나눗셈 알고리즘의 두 정리(`Nat.div_add_mod`, `Nat.mod_lt`)를 활용할 수 있다.
5. Mathlib의 `Int.ModEq`로 합동 관계를 다루는 도입을 안다(본격은 §4.4 자료).

---

## 2. 가분성의 정의

§4.1 강의에서 본 정의를 다시 적어 둔다.

**정의** 정수 `a`, `b`에 대해, `b = a * k`인 정수 `k`가 존재하면 "`a`가 `b`를 나눈다"고 하고 `a ∣ b`로 쓴다.

Lean 4에서는 이 정의가 Mathlib에 다음과 같은 형태로 이미 들어 있다.

```
a ∣ b ↔ ∃ k, b = a * k
```

즉 "어떤 `k`가 있어서 `b = a * k`이다"가 `a ∣ b`의 정의 그 자체이다. 본 자료에서 `a ∣ b`를 보일 때, 학습자가 할 일은 **그런 `k`를 직접 제시하는 것**이다. 이를 "**증인**(witness)을 제시한다"라고 한다.

가분성 기호 `∣`는 Lean 4 편집기에서 `\|`(역슬래시 + 막대기) 또는 `\dvd`(엔터)로 입력한다. 단순 막대기 `|`(파이프)와 모양은 비슷하지만 다른 기호이다.

---

## 3. 가장 단순한 시연 - `3 ∣ 12`

가장 단순한 사례로 시작한다.

**주장** `3 ∣ 12`이다.

`12 = 3 * k`인 `k`를 찾으면 된다. 답은 `k = 4`이다. 12 = 3 × 4이므로.

Lean 4 코드로는 다음과 같이 쓴다.

```lean
import Mathlib

example : (3 : Nat) ∣ 12 := by
  -- 증인 k = 4를 제시: 12 = 3 * 4
  exact ⟨4, by decide⟩
```

한 줄씩 풀어 본다.

`example : (3 : Nat) ∣ 12 := by`는 정리의 선언이다. `example`은 이름을 따로 붙이지 않는 정리이다(이름이 필요 없는 시연 정리에 자주 쓴다). `(3 : Nat)`는 "3을 자연수로 해석하라"는 타입 지정이다. 이 한 줄로 식 전체가 자연수 환경에서 작동한다는 것이 확정된다.

`exact ⟨4, by decide⟩`이 본체이다. 두 가지 새 요소이다.

**꺽쇠 묶음 `⟨..., ...⟩`** 이는 "**구조체**(structure)나 **존재**(`∃`) 같은 짝 정보를 한꺼번에 묶어 제공한다"는 기호이다. 가분성 `3 ∣ 12`의 정의가 `∃ k, 12 = 3 * k`이므로, 우리는 두 정보를 함께 제공해야 한다. 첫째, 증인 `k`(여기서는 `4`). 둘째, 그 `k`로 등식이 성립한다는 증명(여기서는 `by decide`). 이 둘을 `⟨4, by decide⟩` 한 묶음으로 전달한다.

**`decide` 전술** 작은 수의 직접 계산으로 참거짓을 판정한다. `12 = 3 * 4`는 단순 계산이므로 `decide`가 즉결한다.

부정 형태도 본다.

```lean
example : ¬ ((3 : Nat) ∣ 10) := by
  -- 10은 3으로 나누어떨어지지 않음. 직접 계산으로 즉결.
  decide
```

`¬`는 부정 기호이다. "`3 ∣ 10`이 거짓이다"는 명제이다. 작은 수의 부정도 `decide`가 직접 계산으로 즉결한다.

---

## 4. 자명한 사실 세 가지

가분성의 가장 기초적인 사실 세 가지이다. 모두 증인 제시 한 줄로 닫힌다.

**자명 사실 1.** 모든 자연수 `a`에 대해 `a ∣ 0`이다.

이유: `0 = a * 0`이므로, 증인 `k = 0`을 제시하면 된다.

```lean
theorem a_dvd_zero (a : Nat) : a ∣ 0 := by
  -- 증인 k = 0을 제시: 0 = a * 0
  exact ⟨0, by ring⟩
```

`by ring`은 다항식 항등식 자동 검증이다. `0 = a * 0`은 곱셈의 영원 성질로부터 즉시 따라오는 항등식이므로 `ring`이 처리한다.

**자명 사실 2.** 모든 자연수 `a`에 대해 `a ∣ a`이다.

이유: `a = a * 1`이므로, 증인 `k = 1`을 제시하면 된다.

```lean
theorem a_dvd_self (a : Nat) : a ∣ a := by
  exact ⟨1, by ring⟩
```

**자명 사실 3.** 모든 자연수 `a`에 대해 `1 ∣ a`이다.

이유: `a = 1 * a`이므로, 증인 `k = a`를 제시하면 된다.

```lean
theorem one_dvd_a (a : Nat) : 1 ∣ a := by
  exact ⟨a, by ring⟩
```

세 정리는 본 자료에서 가장 단순한 가분성 패턴이다. 손에 익을 때까지 따라쳐 본다.

**일반 패턴 정리** 가분성 `a ∣ b`를 직접 보이는 형태:

```lean
example (...) : a ∣ b := by
  exact ⟨<증인 k>, by <등식 검증>⟩
```

`<증인 k>`는 `b = a * k`를 성립시키는 정수이다. `<등식 검증>`은 그 등식의 증명이다. 등식이 다항식 항등식이면 `ring`, 단순 계산이면 `decide` 또는 `rfl`이 사용된다.

---

## 5. 결합 성질 (1) - 합과 차

가분성은 합과 차에 대해 보존된다. 즉 같은 `a`로 나누어떨어지는 두 수의 합·차도 같은 `a`로 나누어떨어진다.

**정리(합)** `a ∣ b`이고 `a ∣ c`이면 `a ∣ (b + c)`이다.

Mathlib에는 이 정리가 `Nat.dvd_add`라는 이름으로 들어 있다. 진술은 다음과 같다.

```
Nat.dvd_add : a ∣ b → a ∣ c → a ∣ (b + c)
```

말로 풀면 "두 개의 가분성 증명을 받아 합의 가분성 증명을 돌려준다". 함수 인수처럼 두 개의 증명을 넘긴다.

```lean
theorem dvd_add_demo (a b c : Nat)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (b + c) :=
  Nat.dvd_add h1 h2
```

증명 본체가 한 줄이다. `Nat.dvd_add h1 h2`. 가정으로 받은 두 가분성 증명 `h1`, `h2`를 그대로 `Nat.dvd_add`에 넘기면, 합의 가분성이 돌아온다.

여기서 한 가지를 짚어 둔다. 이 정리는 `:= by`가 아닌 `:=`만으로 본체가 시작한다. 즉 **전술 모드**(tactic mode, `by` 다음)에 들어가지 않고 **표현 모드**(term mode)에서 바로 답을 적었다. 한 줄짜리 직접 답은 `:= 답`이 더 깔끔하다. 본 자료에서 종종 등장하는 형식이다.

**정리(차)** `a ∣ b`이고 `a ∣ c`이면 `a ∣ (b - c)`이다.

자연수에서는 뺄셈이 위험하다(작은 수에서 큰 수를 빼면 0으로 잘림). 그러므로 차의 가분성은 **정수** `Int`에서 일반적으로 다룬다.

```lean
theorem dvd_sub_int_demo (a b c : Int)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (b - c) :=
  dvd_sub h1 h2
```

정수 환경에서는 `Nat.dvd_add`가 아니라 일반 환에서 작동하는 `dvd_sub`을 쓴다.

종이 증명과 Lean 4 코드의 대응을 정리한다.

| 종이 증명 | Lean 4 한 줄 |
|---|---|
| "b = a·k₁, c = a·k₂이라 하면" | (가정 `h1`, `h2`로 자동 표현됨) |
| "b + c = a·(k₁ + k₂)" | (`Nat.dvd_add`가 내부적으로 처리) |
| "따라서 a ∣ (b + c)" | `Nat.dvd_add h1 h2` |

종이의 세 줄이 코드의 한 줄로 압축된다. 보조 정리에 일을 맡기는 것의 효율이다.

---

## 6. 결합 성질 (2) - 곱과 추이성

**정리(곱)** `a ∣ b`이면 임의의 `c`에 대해 `a ∣ (b * c)`이다.

이유: `b = a * k`이면 `b * c = (a * k) * c = a * (k * c)`이므로 증인 `k * c`로 가분성이 성립한다.

Mathlib에는 `Dvd.dvd.mul_right`라는 이름으로 있다.

```lean
theorem dvd_mul_demo (a b c : Nat) (h : a ∣ b) :
    a ∣ (b * c) :=
  Dvd.dvd.mul_right h c
```

`Dvd.dvd.mul_right h c`의 의미는 "`h`라는 가분성에 우측에서 `c`를 곱한 형태의 가분성을 만든다"이다. 짝꿍 정리 `Dvd.dvd.mul_left`도 있다. 좌측 곱셈에 쓴다.

```
Dvd.dvd.mul_right : a ∣ b → (c : α) → a ∣ (b * c)
Dvd.dvd.mul_left  : a ∣ b → (c : α) → a ∣ (c * b)
```

곱의 어느 쪽에 가분성이 작동하느냐에 따라 둘 중 하나를 선택한다.

**정리(추이성)** `a ∣ b`이고 `b ∣ c`이면 `a ∣ c`이다.

이유: `b = a * k₁`, `c = b * k₂`이면 `c = (a * k₁) * k₂ = a * (k₁ * k₂)`이므로 증인 `k₁ * k₂`로 성립한다.

Mathlib에는 `Dvd.dvd.trans`라는 이름으로 있다.

```lean
theorem dvd_trans_demo (a b c : Nat)
    (h1 : a ∣ b) (h2 : b ∣ c) :
    a ∣ c :=
  Dvd.dvd.trans h1 h2
```

가분성 관계가 **추이적**이라는 사실은 후에 §4.3의 최대공약수 이론에서 핵심 역할을 한다.

---

## 7. 결합 성질 (3) - 선형 결합

§4.1 강의의 가분성 핵심 정리이다. 위에서 본 정리들을 결합해서 만든다.

**정리(선형 결합)** `a ∣ b`이고 `a ∣ c`이면 임의의 `m`, `n`에 대해 `a ∣ (m·b + n·c)`이다.

이유: `a ∣ b`이므로 `a ∣ m·b` (곱). `a ∣ c`이므로 `a ∣ n·c` (곱). 두 가분성의 합으로 `a ∣ (m·b + n·c)` (합).

Mathlib에 직접 단일 정리로 있는지 모르지만, 위 세 가지 정리(`Dvd.dvd.mul_left`, `Nat.dvd_add`)를 차례로 적용하면 충분히 만들 수 있다.

```lean
theorem dvd_linear_combination (a b c m n : Nat)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (m * b + n * c) := by
  -- m * b에 a가 나누어짐 (b의 좌측 곱)
  have hb : a ∣ (m * b) := Dvd.dvd.mul_left h1 m
  -- n * c에 a가 나누어짐
  have hc : a ∣ (n * c) := Dvd.dvd.mul_left h2 n
  -- 두 가분성의 합
  exact Nat.dvd_add hb hc
```

본 정리는 세 줄에 걸친 **연속 적용**이다. `have`로 보조 사실을 두 개 비축하고, `exact`로 결론을 내린다.

`have <이름> : <명제> := <증명>`은 본 자료에서 중요한 구문이다. "이런 명제를 이런 이름으로 손에 쥔다"는 의미이다. 후속 줄에서 그 이름을 호명해 쓴다.

종이 증명과 Lean 4 코드의 대응:

| 종이 | Lean 4 한 줄 |
|---|---|
| "a ∣ b이므로 a ∣ m·b" | `have hb : a ∣ (m * b) := Dvd.dvd.mul_left h1 m` |
| "a ∣ c이므로 a ∣ n·c" | `have hc : a ∣ (n * c) := Dvd.dvd.mul_left h2 n` |
| "두 가분성의 합" | `exact Nat.dvd_add hb hc` |

종이의 세 줄이 코드의 세 줄과 한 줄씩 짝을 이룬다.

---

## 8. 나눗셈 알고리즘

§4.1 강의의 또 하나의 기둥 정리이다.

**정리(나눗셈 알고리즘)** 양의 정수 `b > 0`과 임의의 자연수 `a`에 대해, 유일한 `q`(몫)와 `r`(나머지)이 존재해서

```
a = b · q + r,   0 ≤ r < b.
```

Lean 4와 Mathlib에서는 이 정리가 **두 개의 분리된 정리**로 들어 있다.

**정리 1.** `Nat.div_add_mod`. 진술:

```
Nat.div_add_mod : ∀ (m k : Nat), k * (m / k) + m % k = m
```

말로 풀면 "어떤 자연수 `m`을 `k`로 나누면, `k * (몫) + (나머지) = m`이 성립한다". 종이의 `a = b · q + r`을 옮긴 것이다.

```lean
theorem div_mod_decomposition (a b : Nat) :
    b * (a / b) + a % b = a :=
  Nat.div_add_mod a b
```

본 정리는 인수만 넘기면 끝이다.

**정리 2.** `Nat.mod_lt`. 진술:

```
Nat.mod_lt : ∀ (x : Nat) {y : Nat}, 0 < y → x % y < y
```

말로 풀면 "나누는 수 `y`가 양수이면, 나머지 `x % y`는 `y`보다 작다". 종이의 `r < b`를 옮긴 것이다.

```lean
theorem mod_lt_divisor (a b : Nat) (hb : 0 < b) :
    a % b < b :=
  Nat.mod_lt a hb
```

`hb : 0 < b`라는 가정이 핵심이다. `b = 0`이면 정리가 성립하지 않는다(0으로 나눌 수 없음).

**시연** 17을 5로 나누는 경우. 몫 3, 나머지 2.

```lean
example : 17 = 5 * (17 / 5) + 17 % 5 := by
  decide

example : 17 / 5 = 3 := by decide
example : 17 % 5 = 2 := by decide
```

세 정리 모두 `decide`로 즉결한다. 작은 수이므로 직접 계산이 가장 단순하다.

---

## 9. 가분성과 나머지

가분성과 나머지의 관계를 짚는다.

**핵심 정리** 자연수 `a`, `b`에 대해 다음 세 가지가 Mathlib에 들어 있다.

```
Nat.mod_eq_zero_of_dvd  : m ∣ n → n % m = 0
Nat.dvd_of_mod_eq_zero  : n % m = 0 → m ∣ n
Nat.dvd_iff_mod_eq_zero : m ∣ n ↔ n % m = 0
```

세 정리 모두 **`m`의 양수성을 요구하지 않는다**. 즉 `m = 0`일 때조차 잘 정의되어 양방향 동치가 성립한다. 그 이유는 Lean 4의 자연수 나머지 정의에서 `n % 0 = n`이고, `0 ∣ n`은 `n = 0`과 동치이므로 두 사실이 자연스럽게 맞물리기 때문이다.

**양방향 동치 (가장 짧은 형태)**

```lean
theorem dvd_iff_mod_eq_zero (a b : Nat) :
    a ∣ b ↔ b % a = 0 :=
  Nat.dvd_iff_mod_eq_zero
```

본 자료에서 가장 짧은 정리. Mathlib에 정확히 같은 진술이 있으므로 호명만 한다. 표현 모드(`:=`)에 단순 인용 한 줄로 닫힘.

**양방향 동치 (constructor로 미시 전개)**

```lean
example (a b : Nat) : a ∣ b ↔ b % a = 0 := by
  constructor
  · intro h
    exact Nat.mod_eq_zero_of_dvd h
  · intro h
    exact Nat.dvd_of_mod_eq_zero h
```

같은 정리를 두 단방향으로 분해해 보인 형태. 새 요소가 둘.

**`constructor`** `↔`(쌍방향 함의)나 `∧`(합접) 같은 두 성분 명제를 두 부목표로 분해. 본 코드에서는 `↔`를 `→`(정방향)와 `←`(역방향) 두 함의로 분해.

**`intro h`** 함의 `P → Q`의 가정 `P`를 잡아 새 가정 `h`로 만들고, 목표를 `Q`로 좁힌다.

각 갈래에서 Mathlib 정리 하나씩을 인용해 닫는다.

**단방향 (가분성 → 나머지 0)**

```lean
theorem dvd_to_mod_zero (a b : Nat) (h : a ∣ b) :
    b % a = 0 :=
  Nat.mod_eq_zero_of_dvd h
```

**단방향 (나머지 0 → 가분성)**

```lean
example (a b : Nat) (h : b % a = 0) : a ∣ b :=
  Nat.dvd_of_mod_eq_zero h
```

**rw 중심 대안 (forward 방향)**

```lean
example (a b : Nat) (h : a ∣ b) : b % a = 0 := by
  rw [← Nat.dvd_iff_mod_eq_zero]
  exact h
```

`Nat.dvd_iff_mod_eq_zero`를 **역방향**(`←`)으로 적용해 목표 `b % a = 0`을 `a ∣ b`로 다시 쓴 다음, 가정 `h`로 닫음.

종이 증명의 "`a ∣ b ↔ a로 나눈 나머지가 0`"이라는 직관이, Lean 4에서는 정확히 `Nat.dvd_iff_mod_eq_zero`라는 한 정리로 표현된다.

---

## 10. 모듈러 합동의 도입

§4.4 강의에서 본격적으로 다룰 **합동** 관계를, §4.1에서는 도입만 한다.

**정의** 정수 `a`, `b`, `m`(`m > 0`)에 대해 `m ∣ (a - b)`이면 "`a`와 `b`는 `m`을 법으로 합동"이라 하고 `a ≡ b (mod m)`으로 쓴다.

Lean 4와 Mathlib에서는 이 정의가 `Int.ModEq m a b`라는 형태로 들어 있다.

```lean
example : Int.ModEq 5 17 2 := by
  -- 17 ≡ 2 (mod 5). 즉 5 ∣ (17 - 2) = 15.
  decide

example : ¬ Int.ModEq 5 17 3 := by
  decide
```

작은 수의 합동 여부는 `decide`가 직접 계산으로 판정한다.

**합동의 세 성질** 본 자료에서는 진술만 본다. 본격적인 증명은 §4.4 자료에서 본다.

```lean
-- 반사성
example (m a : Int) : Int.ModEq m a a :=
  Int.ModEq.refl a

-- 대칭성
example (m a b : Int) (h : Int.ModEq m a b) : Int.ModEq m b a :=
  Int.ModEq.symm h

-- 추이성
example (m a b c : Int)
    (h1 : Int.ModEq m a b) (h2 : Int.ModEq m b c) :
    Int.ModEq m a c :=
  Int.ModEq.trans h1 h2
```

세 정리 모두 Mathlib에 직접 들어 있어 이름을 호명만 하면 된다.

§4.4 자료에서는 본 자료의 `Int.ModEq` 대신 우리만의 정의 `CongMod`을 직접 만들고, 위 세 성질을 직접 증명한다. 그 시점에 본 자료의 도입이 다리가 된다.

---

## 11. 마무리 - 본 자료의 패턴 정리

본 자료에서 익힌 핵심 패턴 다섯 가지를 정리한다.

**패턴 1. 가분성 직접 증명 (증인 제시)**

```lean
example : a ∣ b := by
  exact ⟨<증인 k>, by <등식 검증>⟩
```

`<등식 검증>`은 `b = a * k`의 증명이다. 다항식 항등식이면 `ring`, 단순 계산이면 `decide` 또는 `rfl`.

**패턴 2. 결합 정리 직접 호출**

```lean
-- 합
Nat.dvd_add h1 h2

-- 차 (정수 환경)
dvd_sub h1 h2

-- 곱
Dvd.dvd.mul_left  h c  -- a ∣ b → a ∣ (c * b)
Dvd.dvd.mul_right h c  -- a ∣ b → a ∣ (b * c)

-- 추이성
Dvd.dvd.trans h1 h2
```

**패턴 3. 연속 적용 (have로 비축)**

```lean
example ... : a ∣ ... := by
  have h_step1 : ... := <첫 호출>
  have h_step2 : ... := <둘째 호출>
  exact <마지막 결합>
```

**패턴 4. 나눗셈 알고리즘 활용**

```lean
-- a = b·q + r의 표현
Nat.div_add_mod a b   -- 자동으로 b * (a / b) + a % b = a

-- r < b의 표현 (b > 0 가정)
Nat.mod_lt a hb       -- hb : 0 < b
```

**패턴 5. 작은 수의 직접 판정**

```lean
example : <작은 수의 가분성·합동·등식> := by decide
```

이 다섯 패턴이 본 자료가 다룬 §4.1의 모든 정리를 덮는다. 각 패턴은 "수학적 사실 한 단계가 코드의 한 줄에 대응"하도록 설계되었다.

본 자료를 처음부터 끝까지 손으로 한 번 따라쳐 보면, Lean 4의 기초 문법, 가분성 정의, Mathlib의 주요 가분성 정리들(`Nat.dvd_add`, `dvd_sub`, `Dvd.dvd.mul_left`, `Dvd.dvd.mul_right`, `Dvd.dvd.trans`, `Nat.div_add_mod`, `Nat.mod_lt`, `Nat.dvd_of_mod_eq_zero`, `Int.ModEq.refl`/`symm`/`trans`)에 자연스럽게 익숙해질 것이다.

다음 단계는 §4.2의 **정수의 표현**이다. 이번에는 가분성보다는 자릿수와 진법 변환을 다룬다. §4.2 짝꿍 자료에서 만난다.

---

**부록. 짝꿍 문서 안내**

본 문서의 각 코드 블록에 대해 한 줄씩 정밀하게 InfoView 상태 변화를 기록한 짝꿍 문서가 **`ch4_1_lean4_code_explanation.md`**(코드 설명 자료)이다. 본 문서에서 큰 그림을 잡은 뒤 짝꿍 문서에서 한 줄씩의 변화를 확인하는 흐름을 권한다.
