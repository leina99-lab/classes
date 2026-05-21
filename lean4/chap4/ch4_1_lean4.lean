/-
  ch4_1_lean4_all_code.lean

  로젠 이산수학 §4.1 (가분성과 모듈러 산술)
  Lean 4 코드 모음 (교수님 검증 필요 상태)

  본 파일은 다음을 다룬다:
    Part A. 가분성의 정의와 기본 성질
    Part B. 가분성의 결합 성질 (선형 결합, 곱, 추이성)
    Part C. 나눗셈 알고리즘과 div/mod
    Part D. 모듈러 합동의 도입 (§4.4에서 본격 다룸)

  ※ 본 파일의 코드는 컴파일 미검증 상태이다.
     교수님께서 Lean 4로 돌려보시고 오류가 나는 줄을 알려주시면
     사이클로 수정한다.

  ※ 메모리 확정 패턴만 사용하려 노력하였다:
     - 기본 전술: rfl, rw, exact, refine, omega, decide, ring
     - 가분성: Nat.dvd_add, Nat.dvd_sub', dvd_add, dvd_mul_left,
              dvd_mul_right, Dvd.intro, Dvd.dvd.mul_left
     - 나눗셈: Nat.div_add_mod, Nat.mod_lt
-/

import Mathlib
open Nat


-- =========================================================
-- Part A. 가분성의 정의와 기본 성질
-- =========================================================

-- §4.1 정의: a ∣ b ↔ ∃ k, b = a * k
-- Mathlib의 정의를 그대로 시연한다.

example : (3 : Nat) ∣ 12 := by
  -- 증인 k = 4를 제시: 12 = 3 * 4
  exact ⟨4, by decide⟩

example : ¬ ((3 : Nat) ∣ 10) := by
  -- 10은 3으로 나누어떨어지지 않음. 직접 계산으로 즉결.
  decide

-- 자명한 사실 1: 모든 a에 대해 a ∣ 0.
theorem a_dvd_zero (a : Nat) : a ∣ 0 := by
  -- 증인 k = 0을 제시: 0 = a * 0
  exact ⟨0, by ring⟩

-- 자명한 사실 2: 모든 a에 대해 a ∣ a.
theorem a_dvd_self (a : Nat) : a ∣ a := by
  -- 증인 k = 1을 제시: a = a * 1
  exact ⟨1, by ring⟩

-- 자명한 사실 3: 1 ∣ a.
theorem one_dvd_a (a : Nat) : 1 ∣ a := by
  exact ⟨a, by ring⟩


-- =========================================================
-- Part B. 가분성의 결합 성질
-- =========================================================

-- §4.1 정리: a ∣ b ∧ a ∣ c → a ∣ (b + c)
-- Mathlib에 Nat.dvd_add라는 이름으로 존재.
theorem dvd_add_demo (a b c : Nat)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (b + c) :=
  Nat.dvd_add h1 h2

-- §4.1 정리: a ∣ b ∧ a ∣ c → a ∣ (b - c) (b ≥ c일 때)
-- 자연수에서는 뺄셈에 주의해야 하므로 일반적으로 Int로 다룬다.
theorem dvd_sub_int_demo (a b c : Int)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (b - c) :=
  dvd_sub h1 h2

-- §4.1 정리: a ∣ b → a ∣ (b * c)  (곱셈으로 가분성 전파)
theorem dvd_mul_demo (a b c : Nat) (h : a ∣ b) :
    a ∣ (b * c) :=
  Dvd.dvd.mul_right h c

-- §4.1 정리: a ∣ b ∧ b ∣ c → a ∣ c  (추이성)
theorem dvd_trans_demo (a b c : Nat)
    (h1 : a ∣ b) (h2 : b ∣ c) :
    a ∣ c :=
  Dvd.dvd.trans h1 h2

-- §4.1 정리(선형 결합): a ∣ b ∧ a ∣ c → a ∣ (m*b + n*c)
-- 위 dvd_mul과 dvd_add를 결합하여 얻음.
theorem dvd_linear_combination (a b c m n : Nat)
    (h1 : a ∣ b) (h2 : a ∣ c) :
    a ∣ (m * b + n * c) := by
  -- m * b에 a가 나누어짐 (b의 좌측 곱)
  have hb : a ∣ (m * b) := Dvd.dvd.mul_left h1 m
  -- n * c에 a가 나누어짐
  have hc : a ∣ (n * c) := Dvd.dvd.mul_left h2 n
  -- 두 가분성의 합
  exact Nat.dvd_add hb hc


-- =========================================================
-- Part C. 나눗셈 알고리즘과 div/mod
-- =========================================================

-- §4.1 정리(나눗셈 알고리즘):
-- 0 < b이면, a = b * (a / b) + (a % b) 이고 0 ≤ a % b < b.

-- Mathlib에 두 정리가 분리되어 있다.
-- (1) Nat.div_add_mod : ∀ (m k : Nat), k * (m / k) + m % k = m

theorem div_mod_decomposition (a b : Nat) :
    b * (a / b) + a % b = a :=
  Nat.div_add_mod a b

-- (2) Nat.mod_lt : ∀ (x : Nat) {y : Nat}, 0 < y → x % y < y

theorem mod_lt_divisor (a b : Nat) (hb : 0 < b) :
    a % b < b :=
  Nat.mod_lt a hb

-- 시연: 17 = 5 * 3 + 2
example : 17 = 5 * (17 / 5) + 17 % 5 := by
  -- div_add_mod의 좌우를 뒤집으면 정확히 이 형태.
  -- 단, 좌변 자체는 17이라는 상수이므로 직접 계산도 가능하다.
  decide

example : 17 / 5 = 3 := by decide
example : 17 % 5 = 2 := by decide


-- §4.1 정리: a ∣ b ↔ b % a = 0
-- 즉, "나누어떨어진다"는 "나머지가 0이다"와 같다.
--
-- 핵심: Mathlib의 Nat.dvd_iff_mod_eq_zero는 가정 0 < a를 요구하지 않는다.
-- a = 0인 경우에도 잘 정의되어 양방향 동치가 성립한다.
--   Nat.dvd_iff_mod_eq_zero : m ∣ n ↔ n % m = 0
--   Nat.mod_eq_zero_of_dvd  : m ∣ n → n % m = 0
--   Nat.dvd_of_mod_eq_zero  : n % m = 0 → m ∣ n

-- 양방향 동치 (가장 짧은 형태):
theorem dvd_iff_mod_eq_zero (a b : Nat) :
    a ∣ b ↔ b % a = 0 :=
  Nat.dvd_iff_mod_eq_zero

-- 양방향 동치 (constructor로 미시 전개):
example (a b : Nat) : a ∣ b ↔ b % a = 0 := by
  constructor
  · intro h
    exact Nat.mod_eq_zero_of_dvd h
  · intro h
    exact Nat.dvd_of_mod_eq_zero h

-- forward 방향 (가분성 → 나머지 0):
theorem dvd_to_mod_zero (a b : Nat) (h : a ∣ b) :
    b % a = 0 :=
  Nat.mod_eq_zero_of_dvd h

-- backward 방향 (나머지 0 → 가분성):
example (a b : Nat) (h : b % a = 0) : a ∣ b :=
  Nat.dvd_of_mod_eq_zero h

-- rw 중심의 대안 (forward 방향):
example (a b : Nat) (h : a ∣ b) : b % a = 0 := by
  rw [← Nat.dvd_iff_mod_eq_zero]
  exact h


-- =========================================================
-- Part D. 모듈러 합동의 도입 (§4.4에서 본격 다룸)
-- =========================================================

-- 본 절에서는 도입만 한다. 완전한 처리는 §4.4 자료를 본다.

-- 정의: a ≡ b (mod m) ↔ m ∣ (a - b)
-- 자연수에서는 뺄셈이 위험하므로 Int로 작업한다.

-- Mathlib에는 Int.ModEq라는 이름으로 합동 관계가 정의되어 있다.

example : Int.ModEq 5 17 2 := by
  -- 17 ≡ 2 (mod 5). 즉 5 ∣ (17 - 2) = 15.
  decide

example : ¬ Int.ModEq 5 17 3 := by
  decide

-- 합동의 반사성·대칭성·추이성은 Mathlib에 각각 있다:
-- Int.ModEq.refl, Int.ModEq.symm, Int.ModEq.trans

example (m a : Int) : Int.ModEq m a a :=
  Int.ModEq.refl a

example (m a b : Int) (h : Int.ModEq m a b) : Int.ModEq m b a :=
  Int.ModEq.symm h

example (m a b c : Int)
    (h1 : Int.ModEq m a b) (h2 : Int.ModEq m b c) :
    Int.ModEq m a c :=
  Int.ModEq.trans h1 h2


-- =========================================================
-- 마무리 — 본 자료의 주요 보조 정리 목록
-- =========================================================

/-
  본 자료에서 사용한 Mathlib 정리들의 시그니처 정리:

  ▷ 가분성 결합
    Nat.dvd_add : a ∣ b → a ∣ c → a ∣ (b + c)
    dvd_sub     : a ∣ b → a ∣ c → a ∣ (b - c)        (정수 등 환에서)
    Dvd.Dvd.mul_left  : a ∣ b → (c : α) → a ∣ (c * b)
    Dvd.Dvd.mul_right : a ∣ b → (c : α) → a ∣ (b * c)
    Dvd.Dvd.trans     : a ∣ b → b ∣ c → a ∣ c

  ▷ 가분성 생성
    Dvd.intro : (c : α) → b = a * c → a ∣ b
    a ∣ b의 정의: ∃ k, b = a * k  (k가 오른쪽)
    dvd_iff_exists_eq_mul_left : a ∣ b ↔ ∃ k, b = k * a  (k가 왼쪽)

  ▷ 나눗셈
    Nat.div_add_mod : k * (m / k) + m % k = m
    Nat.mod_lt      : 0 < y → x % y < y
    Nat.dvd_of_mod_eq_zero : n % m = 0 → m ∣ n
    Nat.mod_eq_zero_of_dvd : m ∣ n → n % m = 0
    Nat.dvd_iff_mod_eq_zero : m ∣ n ↔ n % m = 0
    (세 정리 모두 m의 양수성을 요구하지 않는다)

  ▷ 합동 (§4.4 본격)
    Int.ModEq m a b := m ∣ (a - b)
    Int.ModEq.refl, Int.ModEq.symm, Int.ModEq.trans

  ▷ Dvd 정의의 두 형태
    a ∣ b의 표준 정의: ∃ k, b = a * k       (k가 오른쪽)
    동등 형태:        ∃ k, b = k * a       (k가 왼쪽, 가환환에서)
    두 형태는 가환환에서 동치이며,
    위 정의를 명시적으로 다루는 보조 정리가
    `dvd_iff_exists_eq_mul_left`이다.
-/
