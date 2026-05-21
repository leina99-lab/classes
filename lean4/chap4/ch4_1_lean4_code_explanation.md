# 4.1 Lean 4 코드 설명 자료

> 본 자료는 짝꿍 문서 **`ch4_1_lean4_student.md`**(학생 자료)에서 등장한 모든 Lean 4 코드를, 한 줄씩 누를 때마다 화면 오른쪽 **InfoView**(인포뷰)가 어떻게 변하는지 정밀하게 기록한 해설서이다. 학생 자료가 "큰 그림"을 잡아 준다면, 본 문서는 "한 줄을 누르면 무엇이 변하는가"를 현미경처럼 관찰한다.

---

## 표기 약속

- `⊢` 기호는 **목표**(goal)를 표시.
- `-- BEFORE:` 그 줄 실행 직전의 InfoView 상태.
- `-- AFTER:` 그 줄 실행 직후의 InfoView 상태.
- `-- WHY:` 그 줄에서 그 전술을 고른 이유.
- `-- USES:` 사용한 보조 정리의 이름과 진술.

---

## 코드 1. `(3 : Nat) ∣ 12` - 직접 증인 제시

**완성 코드 전체**

```lean
example : (3 : Nat) ∣ 12 := by
  exact ⟨4, by decide⟩
```

**한 줄씩 분석**

```lean
example : (3 : Nat) ∣ 12 := by
```

```
-- AFTER `:= by`:
--   ⊢ (3 : Nat) ∣ 12
```

목표 안에 자유 변수가 없다. `(3 : Nat) ∣ 12`는 닫힌 명제이다.

---

```lean
  exact ⟨4, by decide⟩
```

- WHY: `a ∣ b`의 정의는 `∃ k, b = a * k`이다. 따라서 증인 `k = 4`와 등식 `12 = 3 * 4`의 증명을 한 묶음으로 제공한다.
- USES: `decide`(작은 수의 직접 계산).

`⟨4, by decide⟩`의 두 성분:
- 첫 성분 `4`: 증인 `k`.
- 둘째 성분 `by decide`: 등식 `12 = 3 * 4`의 증명. `12 = 12`로 환원되어 `decide`가 즉결.

```
-- AFTER `exact ⟨4, by decide⟩`:
--   (No goals)
```

---

## 코드 2. `¬ ((3 : Nat) ∣ 10)` - 부정의 직접 판정

**완성 코드 전체**

```lean
example : ¬ ((3 : Nat) ∣ 10) := by
  decide
```

```
-- AFTER `:= by`:
--   ⊢ ¬ ((3 : Nat) ∣ 10)
```

- WHY: 작은 수 10이 3으로 나누어지지 않음은 직접 계산으로 판정 가능하다.
- USES: `decide`. 가분성 명제와 그 부정은 작은 자연수에서 결정 가능(decidable)하므로 `decide`가 작동한다.

```
-- AFTER `decide`:
--   (No goals)
```

---

## 코드 3. `a_dvd_zero` - 모든 자연수 `a`에 대해 `a ∣ 0`

**완성 코드 전체**

```lean
theorem a_dvd_zero (a : Nat) : a ∣ 0 := by
  exact ⟨0, by ring⟩
```

**한 줄씩 분석**

```lean
theorem a_dvd_zero (a : Nat) : a ∣ 0 := by
```

```
-- AFTER `:= by`:
--   a : Nat
--   ⊢ a ∣ 0
```

자유 변수 `a`가 가정에 들어와 있다. 목표는 그 임의의 `a`에 대한 가분성.

---

```lean
  exact ⟨0, by ring⟩
```

- WHY: `0 = a * k`인 `k`를 찾는다. `k = 0`이면 `0 = a * 0`이 성립.
- USES: `ring`. 다항식 항등식 `0 = a * 0`은 곱의 영원성으로 자명.

```
-- AFTER `exact ⟨0, by ring⟩`:
--   (No goals)
```

---

## 코드 4. `a_dvd_self` - `a ∣ a`

```lean
theorem a_dvd_self (a : Nat) : a ∣ a := by
  exact ⟨1, by ring⟩
```

- 증인 `k = 1`. `a = a * 1`은 곱의 단위 성질.
- `ring`이 처리.

---

## 코드 5. `one_dvd_a` - `1 ∣ a`

```lean
theorem one_dvd_a (a : Nat) : 1 ∣ a := by
  exact ⟨a, by ring⟩
```

- 증인 `k = a`. `a = 1 * a`. 단위 성질.
- 증인이 명제의 다른 부분(`a`)과 같은 이름을 가져도 무방하다. Lean 4가 자동으로 구분한다.

---

## 코드 6. `dvd_add_demo` - 합의 가분성

**완성 코드 전체**

```lean
theorem dvd_add_demo (a b c : Nat)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (b + c) :=
  Nat.dvd_add h1 h2
```

**한 줄씩 분석**

```lean
theorem dvd_add_demo (a b c : Nat)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (b + c) :=
```

```
-- BEFORE the proof body:
--   a b c : Nat
--   h1 : a ∣ b
--   h2 : a ∣ c
--   ⊢ a ∣ (b + c)
```

가정 두 개(`h1`, `h2`)가 손에 들어와 있다.

---

```lean
  Nat.dvd_add h1 h2
```

- WHY: Mathlib에 직접 정리가 있으므로 호출만 한다.
- USES: `Nat.dvd_add : a ∣ b → a ∣ c → a ∣ (b + c)`.

`:=` 다음에 바로 표현을 적었다(전술 모드 `by`를 거치지 않음). 한 줄 표현이면 더 깔끔하다.

```
-- AFTER `Nat.dvd_add h1 h2`:
--   (No goals)
```

---

## 코드 7. `dvd_sub_int_demo` - 차의 가분성 (정수)

**완성 코드 전체**

```lean
theorem dvd_sub_int_demo (a b c : Int)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (b - c) :=
  dvd_sub h1 h2
```

**핵심 차이점** 인수 타입이 `Nat`가 아닌 `Int`이다.

```
-- BEFORE the proof body:
--   a b c : Int
--   h1 : a ∣ b
--   h2 : a ∣ c
--   ⊢ a ∣ (b - c)
```

`Nat.dvd_add`가 아닌 일반 환에서 작동하는 `dvd_sub`을 쓴다. `dvd_sub`의 진술:

```
dvd_sub : ∀ {α : Type*} [inst : Ring α] {a b c : α},
          a ∣ b → a ∣ c → a ∣ (b - c)
```

`[inst : Ring α]`는 "α가 환이라는 인스턴스가 있어야 한다"는 요구. `Int`는 환이므로 만족.

자연수 `Nat`은 일반 환이 아니다(뺄셈이 잘림). 그래서 `dvd_sub`을 `Nat`에 적용하면 문제가 생기거나 보장이 약해진다. 차의 가분성을 다루려면 정수 환경이 안전하다.

---

## 코드 8. `dvd_mul_demo` - 곱의 가분성

**완성 코드 전체**

```lean
theorem dvd_mul_demo (a b c : Nat) (h : a ∣ b) :
    a ∣ (b * c) :=
  Dvd.dvd.mul_right h c
```

**`Dvd.dvd.mul_right`의 진술**

```
Dvd.dvd.mul_right : ∀ {α : Type*} [inst : Mul α] [inst_1 : Semigroup α]
                    {a b : α}, a ∣ b → ∀ (c : α), a ∣ (b * c)
```

`h c`로 두 인수를 넘긴다. `h`는 `a ∣ b`라는 가분성 증명, `c`는 곱해질 수.

**짝꿍** `Dvd.dvd.mul_left h c : a ∣ (c * b)`. 좌측 곱셈.

```
-- AFTER:
--   (No goals)
```

---

## 코드 9. `dvd_trans_demo` - 추이성

**완성 코드 전체**

```lean
theorem dvd_trans_demo (a b c : Nat)
    (h1 : a ∣ b) (h2 : b ∣ c) :
    a ∣ c :=
  Dvd.dvd.trans h1 h2
```

**`Dvd.dvd.trans`의 진술**

```
Dvd.dvd.trans : a ∣ b → b ∣ c → a ∣ c
```

가분성 관계의 **추이성**이다. 가분성 관계 `∣`가 자연수 위에서 **부분 순서 관계**(reflexive + transitive + antisymmetric)를 이루는 핵심 사실 중 하나이다.

---

## 코드 10. `dvd_linear_combination` - 선형 결합

**완성 코드 전체**

```lean
theorem dvd_linear_combination (a b c m n : Nat)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (m * b + n * c) := by
  have hb : a ∣ (m * b) := Dvd.dvd.mul_left h1 m
  have hc : a ∣ (n * c) := Dvd.dvd.mul_left h2 n
  exact Nat.dvd_add hb hc
```

**한 줄씩 분석**

```lean
theorem dvd_linear_combination (a b c m n : Nat)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (m * b + n * c) := by
```

```
-- AFTER `:= by`:
--   a b c m n : Nat
--   h1 : a ∣ b
--   h2 : a ∣ c
--   ⊢ a ∣ (m * b + n * c)
```

---

```lean
  have hb : a ∣ (m * b) := Dvd.dvd.mul_left h1 m
```

- WHY: `h1 : a ∣ b`의 좌측에 `m`을 곱한 형태의 가분성을 새로운 이름 `hb`로 손에 쥔다.
- USES: `Dvd.dvd.mul_left h1 m`. `h1`이라는 가분성에 좌측에서 `m`을 곱하기.

```
-- AFTER `have hb ...`:
--   a b c m n : Nat
--   h1 : a ∣ b
--   h2 : a ∣ c
--   hb : a ∣ m * b
--   ⊢ a ∣ (m * b + n * c)
```

가정에 `hb`가 추가되었다.

---

```lean
  have hc : a ∣ (n * c) := Dvd.dvd.mul_left h2 n
```

같은 방식으로 `hc`를 비축.

```
-- AFTER `have hc ...`:
--   ...
--   hb : a ∣ m * b
--   hc : a ∣ n * c
--   ⊢ a ∣ (m * b + n * c)
```

---

```lean
  exact Nat.dvd_add hb hc
```

- WHY: 두 가분성 `hb`, `hc`의 합으로 결론.
- USES: `Nat.dvd_add`.

```
-- AFTER `exact ...`:
--   (No goals)
```

**전체 흐름**

| 줄 | 종이 | Lean 4 |
|---|---|---|
| 1 | "a ∣ b이므로 a ∣ m·b" | `have hb : a ∣ (m * b) := Dvd.dvd.mul_left h1 m` |
| 2 | "a ∣ c이므로 a ∣ n·c" | `have hc : a ∣ (n * c) := Dvd.dvd.mul_left h2 n` |
| 3 | "두 가분성의 합" | `exact Nat.dvd_add hb hc` |

---

## 코드 11. `div_mod_decomposition` - 나눗셈 알고리즘 (분해)

**완성 코드 전체**

```lean
theorem div_mod_decomposition (a b : Nat) :
    b * (a / b) + a % b = a :=
  Nat.div_add_mod a b
```

**`Nat.div_add_mod`의 진술**

```
Nat.div_add_mod : ∀ (m k : Nat), k * (m / k) + m % k = m
```

좌변이 `k * (m / k) + m % k`, 우변이 `m`. 본 정리는 인수 두 개(`a`, `b`)만 넘기면 자동으로 결론이 따라온다.

```
-- AFTER:
--   (No goals)
```

본 정리에는 가정이 없다. `b = 0`일 때조차 정리가 성립한다(`b = 0`이면 `m / k`와 `m % k`의 Lean 4 정의가 잘 짜여 있어 합이 `m`이 되도록 처리됨).

---

## 코드 12. `mod_lt_divisor` - 나머지 < 제수

**완성 코드 전체**

```lean
theorem mod_lt_divisor (a b : Nat) (hb : 0 < b) :
    a % b < b :=
  Nat.mod_lt a hb
```

`hb : 0 < b`가 핵심 가정이다. 이 가정이 있어야 `Nat.mod_lt`를 호출할 수 있다.

`Nat.mod_lt`의 진술:

```
Nat.mod_lt : ∀ (x : Nat) {y : Nat}, 0 < y → x % y < y
```

`{y : Nat}`은 **암묵 인수**(implicit argument). 호출 시 명시적으로 넘기지 않고 Lean 4가 문맥에서 추론한다. 그래서 `Nat.mod_lt a hb`로 `a`(피제수)와 `hb`(양수성 가정)만 넘기면 된다.

---

## 코드 13. 가분성 ↔ 나머지 0의 동치

**가분성과 나머지의 동치 관계** Mathlib에 세 정리가 있다:

```
Nat.mod_eq_zero_of_dvd  : m ∣ n → n % m = 0
Nat.dvd_of_mod_eq_zero  : n % m = 0 → m ∣ n
Nat.dvd_iff_mod_eq_zero : m ∣ n ↔ n % m = 0
```

세 정리 모두 `m`의 양수성을 요구하지 않는다.

### 코드 13a. 양방향 동치 (가장 짧은 형태)

**완성 코드**

```lean
theorem dvd_iff_mod_eq_zero (a b : Nat) :
    a ∣ b ↔ b % a = 0 :=
  Nat.dvd_iff_mod_eq_zero
```

- WHY: Mathlib에 정확한 형태의 정리가 있으므로 호명만.
- USES: `Nat.dvd_iff_mod_eq_zero`.

```
-- AFTER:
--   (No goals)
```

### 코드 13b. constructor로 미시 전개

**완성 코드**

```lean
example (a b : Nat) : a ∣ b ↔ b % a = 0 := by
  constructor
  · intro h
    exact Nat.mod_eq_zero_of_dvd h
  · intro h
    exact Nat.dvd_of_mod_eq_zero h
```

**한 줄씩**

```lean
  constructor
```

- WHY: `↔`를 두 함의 `→`로 분해.
- USES: `constructor`.

```
-- AFTER:
--   2 goals
--   goal 1: ⊢ a ∣ b → b % a = 0      (정방향)
--   goal 2: ⊢ b % a = 0 → a ∣ b      (역방향)
```

---

```lean
  · intro h
    exact Nat.mod_eq_zero_of_dvd h
```

첫 갈래(정방향). `intro h`로 가정 `h : a ∣ b`를 잡고, 정리 `Nat.mod_eq_zero_of_dvd`로 직접 닫음.

```
-- AFTER `intro h`:
--   h : a ∣ b
--   ⊢ b % a = 0
-- AFTER `exact Nat.mod_eq_zero_of_dvd h`:
--   (1번째 goal 닫힘)
```

---

```lean
  · intro h
    exact Nat.dvd_of_mod_eq_zero h
```

둘째 갈래(역방향). 같은 패턴.

### 코드 13c. forward 단방향 (`rw` 중심 대안)

**완성 코드**

```lean
example (a b : Nat) (h : a ∣ b) : b % a = 0 := by
  rw [← Nat.dvd_iff_mod_eq_zero]
  exact h
```

```
-- AFTER `:= by`:
--   a b : Nat, h : a ∣ b
--   ⊢ b % a = 0
```

---

```lean
  rw [← Nat.dvd_iff_mod_eq_zero]
```

- WHY: 양방향 정리를 **역방향**(`←`)으로 적용해 목표 `b % a = 0`을 `a ∣ b`로 다시 쓴다.
- USES: `Nat.dvd_iff_mod_eq_zero : m ∣ n ↔ n % m = 0`. `←` 방향은 `n % m = 0 → m ∣ n`을 사용해 다시 쓰는 효과.

```
-- AFTER:
--   ⊢ a ∣ b
```

---

```lean
  exact h
```

가정 `h`가 정확히 목표.

```
-- AFTER:
--   (No goals)
```

---

## 코드 14. `Int.ModEq` 도입 예제

**합동 명제의 판정**

```lean
example : Int.ModEq 5 17 2 := by
  decide

example : ¬ Int.ModEq 5 17 3 := by
  decide
```

`Int.ModEq m a b`는 정의에 따라 `m ∣ (a - b)`로 환원된다. 작은 수의 경우 `decide`가 직접 계산으로 판정.

`Int.ModEq 5 17 2`는 `5 ∣ (17 - 2) = 15`. 참.
`Int.ModEq 5 17 3`은 `5 ∣ (17 - 3) = 14`. 거짓.

**합동의 세 성질**

```lean
example (m a : Int) : Int.ModEq m a a :=
  Int.ModEq.refl a

example (m a b : Int) (h : Int.ModEq m a b) : Int.ModEq m b a :=
  Int.ModEq.symm h

example (m a b c : Int)
    (h1 : Int.ModEq m a b) (h2 : Int.ModEq m b c) :
    Int.ModEq m a c :=
  Int.ModEq.trans h1 h2
```

세 정리 모두 Mathlib에 직접 들어 있어 이름만 호명. **§4.4 자료에서는 우리만의 정의 `CongMod`을 만들어 위 세 성질을 직접 증명**한다.

---

## 마무리

본 코드 설명 자료에서 다룬 14개 코드를 직접 자기 편집기에 입력해서 InfoView가 본 문서의 기록과 한 줄씩 같게 변하는지 확인한다. 차이가 있다면 그 자리에서 멈추고 원인을 추적한다.

§4.2의 정수 표현 자료에서 다시 만난다.
