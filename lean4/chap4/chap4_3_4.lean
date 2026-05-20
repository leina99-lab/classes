import Mathlib
import Mathlib.Data.ZMod.Basic

import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Common

import Mathlib.Data.Int.GCD
import Mathlib.Tactic.LinearCombination
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.SpecificGroups.Cyclic

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
  -- Nat.lt_of_not_le (fun h : p ≤ N => ...) 를 사용하여 p ≤ N 이면 False임을 보임
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



theorem composite_has_small_prime_factor1 (n : Nat) (h_comp : 1 < n ∧ ¬ Nat.Prime n) :
    ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n := by
  obtain ⟨h1, h_not_prime⟩ := h_comp
  
  -- (1) omega 대신 Nat.pos_of_gt 등을 사용
  have hn_pos : 0 < n := Nat.zero_lt_of_lt h1
  have hn_ne_one : n ≠ 1 := Nat.ne_of_gt h1

  -- (2) 최소 소인수 p := Nat.minFac n 도입
  set p := n.minFac with hp_def
  have hp_prime : p.Prime := Nat.minFac_prime hn_ne_one
  have hp_dvd : p ∣ n := n.minFac_dvd

  -- (3) p * p ≤ n 증명
  have hp_sq : p * p ≤ n := by
    -- Nat.minFac_sq_le_self : n이 소수가 아니고 n > 0 이면 (minFac n)^2 ≤ n
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rwa [← hp_def, pow_two] at h

  -- (4) 최종 결과 구성
  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩

-- Mathlib의 정의 (재귀)
/-def Nat.gcd : Nat → Nat → Nat
  | 0,     y => y
  | x + 1, y => Nat.gcd (y % (x + 1)) (x + 1)
-/
-- 사용
#eval Nat.gcd 24 36     -- 12
#eval Nat.gcd 120 500   -- 20
#eval Nat.gcd 17 13     -- 1

-- 정리: 두 수가 모두 0이 아니면 gcd는 양수
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  -- 1. gcd가 0보다 클 조건(iff)을 적용합니다.
  -- 0 < gcd a b ↔ 0 < a ∨ 0 < b
  rw [Nat.gcd_pos_iff]
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h


example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  rw [Nat.gcd_pos_iff]
  -- h의 타입을 변환하여 목표와 맞춤
  have h_new : 0 < a ∨ 0 < b := by rwa [Nat.pos_iff_ne_zero, Nat.pos_iff_ne_zero]
  exact h_new

--def Nat.lcm (m n : Nat) : Nat := m * n / Nat.gcd m n

#eval Nat.lcm 4 6        -- 12
#eval Nat.lcm 120 500    -- 3000

-- 핵심 성질: a · b = gcd(a,b) · lcm(a,b)
example (m n : Nat) :
    Nat.gcd m n * Nat.lcm m n = m * n :=
  Nat.gcd_mul_lcm m n

-- 우리가 쓸 합동 정의 (Mathlib의 Int.ModEq와 같은 모양)
def CongMod (m a b : Int) : Prop := ∃ k : Int, a - b = k * m

-- 표기 (선택사항): a ≡ b [ZMOD m] 같은 합동 기호 마크로 도입
notation:50 a " ≡ " b " [Z" m "]" => CongMod m a b


example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
  obtain ⟨k, hk⟩ := h
  refine ⟨k, ?_⟩
  rw [hk, mul_comm]

example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
  obtain ⟨k, hk⟩ := h
  rw [dvd_iff_exists_eq_mul_left]
  exact ⟨k, hk⟩

theorem CongMod_refl (m a : Int) :
    CongMod m a a := by
  -- 목표: ∃ k : Int, a − a = k * m
  unfold CongMod
  -- 증인 0을 제시
  use 0
  -- 목표: a − a = 0 * m
  -- 양변 모두 0이 되므로 정의상 같다
  ring

theorem CongMod_symm (m a b : Int)
    (h : CongMod m a b) :
    CongMod m b a := by
  unfold CongMod at h ⊢
  -- h : ∃ k, a − b = k * m
  -- ⊢ ∃ k, b − a = k * m
  obtain ⟨k, hk⟩ := h
  -- hk : a − b = k * m
  use -k
  -- ⊢ b − a = -k * m
  rw [neg_mul]
  -- ⊢ b − a = -(k * m)
  rw [← hk]
  ring

theorem CongMod_trans (m a b c : Int)
    (h1 : CongMod m a b)
    (h2 : CongMod m b c) :
    CongMod m a c := by
  unfold CongMod at h1 h2 ⊢
  obtain ⟨k1, hk1⟩ := h1
  obtain ⟨k2, hk2⟩ := h2
  use k1 + k2
  -- ⊢ a − c = (k1 + k2) * m
  -- 핵심: a − c = (a − b) + (b − c)
  rw [show a - c = (a - b) + (b - c) by ring]
  rw [hk1, hk2]
  ring


--def CongMod (m a b : Int) : Prop := ∃ k : Int, a - b = k * m

theorem inverse_exists
    (a m : Int) (_hm : 1 < m)
    (h_cop : Int.gcd a m = 1) :
    ∃ ā : Int, CongMod m (ā * a) 1 := by
  -- 베주 계수 — Mathlib4 에서는 함수 Int.gcdA, Int.gcdB 로 미리 계산됨
  set s := Int.gcdA a m
  set t := Int.gcdB a m
  -- 베주 항등식: gcd(a,m) = a*s + m*t. h_cop 로 좌변이 1 이 된다
  have h_bezout : (1 : Int) = a * s + m * t := by
    have h := Int.gcd_eq_gcd_ab a m
    rw [h_cop] at h
    -- h : ((1 : ℕ) : Int) = a * s + m * t
    exact_mod_cast h
  -- 증인: ā = s
  use s
  -- 목표: CongMod m (s * a) 1 = ∃ k, s * a - 1 = k * m
  unfold CongMod
  -- 증인: k = -t
  use -t
  -- 목표: s * a - 1 = -t * m
  -- 손계산: 1 = a*s + m*t  ⟹  s*a - 1 = -(m*t) = -t*m
  have h1 : s * a - 1 = -(m * t) := by
    rw [h_bezout]
    ring
  rw [h1]
  ring

-- 유일성: ā 와 b̄ 가 모두 a의 역원이면 ā ≡ b̄ (mod m)
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


-- (1) 모듈러 역원의 명시적 검증: 3⁻¹ ≡ 5 (mod 7)
example : (3 : ZMod 7) * 5 = 1 := by decide

-- (2) 선형 합동의 가해성: a ≠ 0 (in ZMod p, p 소수) 이면 모든 b 에 대해 해가 존재
example (a b : ZMod 7) (ha : a ≠ 0) :
    ∃ x : ZMod 7, a * x = b := by
  haveI : Fact (Nat.Prime 7) := ⟨by decide⟩
  refine ⟨a⁻¹ * b, ?_⟩
  field_simp


-- "ℤ/(m·n) ≃ ℤ/m × ℤ/n  (m, n 서로소일 때)" — 환 동형 사상
example (m n : ℕ) (hmn : Nat.Coprime m n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n :=
  ZMod.chineseRemainder hmn

-- 손자 문제의 해: 23 ∈ ZMod 105 가 세 합동을 만족함
example : (23 : ZMod 105).val % 3 = 2 ∧
          (23 : ZMod 105).val % 5 = 3 ∧
          (23 : ZMod 105).val % 7 = 2 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide


-- 진술: a ≠ 0 in ZMod p (p 소수) → a^(p-1) = 1
example (p : ℕ) [Fact p.Prime] (a : ZMod p) (ha : a ≠ 0) :
    a ^ (p - 1) = 1 :=
  ZMod.pow_card_sub_one_eq_one ha

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




