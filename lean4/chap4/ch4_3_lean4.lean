/-
  ch4_3_lean4_all_code.lean

  로젠 이산수학 §4.3 (소수와 최대공약수)
  Lean 4 코드 모음

  본 파일은 다음을 다룬다:
    Part A. 합성수의 작은 소인수 정리 (Nat.minFac)
    Part B. 유클리드의 소수 무한성 정리
    Part C. 최대공약수 (Nat.gcd)
    Part D. 최소공배수 (Nat.lcm)
    Part E. gcd · lcm = m · n 의 핵심 등식
-/

import Mathlib
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Common


-- =========================================================
-- Part A. 합성수의 작은 소인수 정리
-- =========================================================

-- §4.3 정리: 1보다 큰 합성수는 √n 이하의 소인수를 갖는다.
-- 즉, 합성수 n에 대해 p * p ≤ n 인 소인수 p가 존재.

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
  -- (3) Nat.minFac_sq_le_self : minFac n ^ 2 ≤ n
  --     pow_two 로 ^2 = * 변환
  have hp_sq : p * p ≤ n := by
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rw [pow_two] at h
    exact h
  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩


-- 같은 정리의 대안 증명 (omega 없이 Nat.zero_lt_of_lt, Nat.ne_of_gt 사용)
theorem composite_has_small_prime_factor1
    (n : Nat) (h_comp : 1 < n ∧ ¬ Nat.Prime n) :
    ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n := by
  obtain ⟨h1, h_not_prime⟩ := h_comp
  have hn_pos : 0 < n := Nat.zero_lt_of_lt h1
  have hn_ne_one : n ≠ 1 := Nat.ne_of_gt h1
  set p := n.minFac with hp_def
  have hp_prime : p.Prime := Nat.minFac_prime hn_ne_one
  have hp_dvd : p ∣ n := n.minFac_dvd
  have hp_sq : p * p ≤ n := by
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rwa [← hp_def, pow_two] at h
  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩


-- =========================================================
-- Part B. 유클리드의 소수 무한성 정리
-- =========================================================

-- §4.3 정리(유클리드): 임의의 자연수 N에 대해, N 이상인 소수 p가 존재한다.
-- 즉, 소수는 무한히 많다.

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

  -- p < N 이 아니라 N ≤ p 임을 증명 (귀류법)
  exact (Nat.lt_of_not_le (fun h : p ≤ N =>
    -- p ≤ N 이면 p는 N!의 약수이다
    have h_p_div_fact : p ∣ Nat.factorial N := Nat.dvd_factorial (Nat.Prime.pos hp_prime) h

    -- p는 Q의 소인수이므로 Q를 나눈다
    have h_p_div_Q : p ∣ Q := by
      rw [hp]
      exact Nat.minFac_dvd Q

    -- p가 N!과 N! + 1을 모두 나누면 1도 나누어야 함 (모순의 핵심)
    have h_p_div_one : p ∣ 1 := by
      rw [hQ] at h_p_div_Q
      exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q

    -- 소수가 1을 나누는 것은 불가능함
    show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
  )).le


-- =========================================================
-- Part C. 최대공약수 (Nat.gcd)
-- =========================================================

-- Mathlib의 정의 (재귀):
--   def Nat.gcd : Nat → Nat → Nat
--     | 0,     y => y
--     | x + 1, y => Nat.gcd (y % (x + 1)) (x + 1)

#eval Nat.gcd 24 36     -- 12
#eval Nat.gcd 120 500   -- 20
#eval Nat.gcd 17 13     -- 1


-- 정리: 두 수 중 적어도 하나가 0이 아니면 gcd는 양수
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  -- gcd가 0보다 클 조건(iff)을 적용.
  -- 0 < gcd a b ↔ 0 < a ∨ 0 < b
  rw [Nat.gcd_pos_iff]
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h


-- 같은 사실의 대안 증명 (have 사용 명시적 형태)
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  rw [Nat.gcd_pos_iff]
  -- h의 타입을 변환하여 목표와 맞춤
  have h_new : 0 < a ∨ 0 < b := by rwa [Nat.pos_iff_ne_zero, Nat.pos_iff_ne_zero]
  exact h_new


-- =========================================================
-- Part D. 최소공배수 (Nat.lcm)
-- =========================================================

-- Mathlib의 정의:
--   def Nat.lcm (m n : Nat) : Nat := m * n / Nat.gcd m n

#eval Nat.lcm 4 6        -- 12
#eval Nat.lcm 120 500    -- 3000


-- =========================================================
-- Part E. 핵심 등식: a · b = gcd(a, b) · lcm(a, b)
-- =========================================================

-- §4.3 정리: 자연수 m, n에 대해
--   gcd(m, n) · lcm(m, n) = m · n

example (m n : Nat) :
    Nat.gcd m n * Nat.lcm m n = m * n :=
  Nat.gcd_mul_lcm m n


-- =========================================================
-- 부록 - 본 자료의 주요 Mathlib API
-- =========================================================

/-
  ▷ 소수와 최소 소인수
    Nat.minFac n               : n의 최소 소인수
    Nat.minFac_prime           : n ≠ 1 → (Nat.minFac n).Prime
    Nat.minFac_dvd n           : Nat.minFac n ∣ n
    Nat.minFac_sq_le_self      : 0 < n → ¬ Nat.Prime n → (Nat.minFac n)^2 ≤ n
    pow_two                    : a^2 = a * a

  ▷ 소수의 기본 성질
    Nat.Prime                  : 소수임의 명제
    Nat.Prime.pos              : p.Prime → 0 < p
    Nat.Prime.not_dvd_one      : p.Prime → ¬ p ∣ 1

  ▷ 계승
    Nat.factorial n            : n!
    Nat.factorial_pos n        : 0 < n!
    Nat.dvd_factorial          : 0 < a → a ≤ n → a ∣ n!

  ▷ 가분성 분리·결합
    Nat.dvd_add_right h        : a ∣ b → (a ∣ b + c ↔ a ∣ c)
    Nat.dvd_factorial

  ▷ GCD와 LCM
    Nat.gcd                    : 최대공약수
    Nat.lcm                    : 최소공배수
    Nat.gcd_pos_iff            : 0 < gcd a b ↔ 0 < a ∨ 0 < b
    Nat.gcd_mul_lcm            : gcd m n * lcm m n = m * n
    Nat.pos_iff_ne_zero        : 0 < n ↔ n ≠ 0

  ▷ 부등식 변환
    Nat.lt_of_not_le           : ¬ (a ≤ b) → b < a
    Nat.zero_lt_of_lt          : a < b → 0 < b
    Nat.ne_of_gt               : a < b → b ≠ a
    .le                        : a < b → a ≤ b (LT.lt.le)
-/
