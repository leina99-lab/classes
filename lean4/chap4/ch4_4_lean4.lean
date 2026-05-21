/-
  ch4_4_lean4_all_code.lean

  로젠 이산수학 §4.4 (합동과 모듈러 산술)
  Lean 4 코드 모음

  본 파일은 다음을 다룬다:
    Part A. 사용자 정의 합동 관계 CongMod
    Part B. 합동과 가분성의 동치
    Part C. 합동의 세 성질 (반사·대칭·추이)
    Part D. 모듈러 역원의 존재와 유일성
    Part E. ZMod 환경에서의 합동 (구체 계산)
    Part F. 중국 잉여 정리 (CRT)
    Part G. 페르마 소정리
-/

import Mathlib
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Int.GCD
import Mathlib.Tactic.LinearCombination
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.SpecificGroups.Cyclic


-- =========================================================
-- Part A. 사용자 정의 합동 관계
-- =========================================================

-- 우리만의 합동 정의 (Mathlib의 Int.ModEq와 같은 모양)
def CongMod (m a b : Int) : Prop := ∃ k : Int, a - b = k * m

-- 표기 (선택사항): a ≡ b [Zm] 같은 합동 기호
notation:50 a " ≡ " b " [Z" m "]" => CongMod m a b


-- =========================================================
-- Part B. 합동과 가분성의 동치
-- =========================================================

-- §4.4 정리: ∃ k, a - b = k * m ↔ m ∣ (a - b)
-- Lean 4의 Dvd 정의는 a ∣ b ↔ ∃ k, b = a * k 이므로,
-- 우리 정의 ∃ k, a - b = k * m과는 곱셈 순서가 다르다.
-- 두 형태가 같은 가분성을 표현함을 두 가지 방식으로 보인다.

-- 방식 1: 직접 가분성 증인을 구성 (mul_comm으로 순서 맞추기)
example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
  obtain ⟨k, hk⟩ := h
  refine ⟨k, ?_⟩
  rw [hk, mul_comm]

-- 방식 2: dvd_iff_exists_eq_mul_left 정리 활용
-- 이 정리: m ∣ b ↔ ∃ k, b = k * m (왼쪽 곱셈 형태)
example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
  obtain ⟨k, hk⟩ := h
  rw [dvd_iff_exists_eq_mul_left]
  exact ⟨k, hk⟩


-- =========================================================
-- Part C. 합동의 세 성질
-- =========================================================

-- §4.4 정리(반사성): 모든 a에 대해 a ≡ a (mod m)
theorem CongMod_refl (m a : Int) :
    CongMod m a a := by
  unfold CongMod
  -- 증인 0을 제시
  use 0
  -- 목표: a - a = 0 * m
  ring


-- §4.4 정리(대칭성): a ≡ b → b ≡ a (mod m)
theorem CongMod_symm (m a b : Int)
    (h : CongMod m a b) :
    CongMod m b a := by
  unfold CongMod at h ⊢
  obtain ⟨k, hk⟩ := h
  -- hk : a - b = k * m
  -- 증인 -k
  use -k
  -- 목표: b - a = -k * m
  rw [neg_mul]
  rw [← hk]
  ring


-- §4.4 정리(추이성): a ≡ b ∧ b ≡ c → a ≡ c (mod m)
theorem CongMod_trans (m a b c : Int)
    (h1 : CongMod m a b)
    (h2 : CongMod m b c) :
    CongMod m a c := by
  unfold CongMod at h1 h2 ⊢
  obtain ⟨k1, hk1⟩ := h1
  obtain ⟨k2, hk2⟩ := h2
  use k1 + k2
  -- 핵심: a - c = (a - b) + (b - c)
  rw [show a - c = (a - b) + (b - c) by ring]
  rw [hk1, hk2]
  ring


-- =========================================================
-- Part D. 모듈러 역원의 존재와 유일성
-- =========================================================

-- §4.4 정리(역원의 존재): gcd(a, m) = 1이면 a의 모듈러 역원이 존재.
-- 즉, 어떤 정수 a_bar가 있어서 a_bar · a ≡ 1 (mod m).

theorem inverse_exists
    (a m : Int) (_hm : 1 < m)
    (h_cop : Int.gcd a m = 1) :
    ∃ ā : Int, CongMod m (ā * a) 1 := by
  -- 베주 계수: Mathlib4에서 함수 Int.gcdA, Int.gcdB로 미리 계산됨
  set s := Int.gcdA a m
  set t := Int.gcdB a m
  -- 베주 항등식: gcd(a,m) = a*s + m*t. h_cop로 좌변이 1.
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


-- §4.4 정리(역원의 유일성): a의 두 역원은 m을 법으로 합동
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


-- =========================================================
-- Part E. ZMod 환경에서의 구체 계산
-- =========================================================

-- §4.4 시연 (1): 모듈러 역원의 명시적 검증.
-- 3 ⁻¹ ≡ 5 (mod 7), 즉 3 * 5 = 15 ≡ 1 (mod 7).
example : (3 : ZMod 7) * 5 = 1 := by decide


-- §4.4 시연 (2): 선형 합동 가해성.
-- ZMod p에서 a ≠ 0 (p 소수)이면 모든 b에 대해 a*x = b의 해가 존재.
example (a b : ZMod 7) (ha : a ≠ 0) :
    ∃ x : ZMod 7, a * x = b := by
  haveI : Fact (Nat.Prime 7) := ⟨by decide⟩
  refine ⟨a⁻¹ * b, ?_⟩
  field_simp


-- =========================================================
-- Part F. 중국 잉여 정리 (CRT)
-- =========================================================

-- §4.4 정리(CRT): m, n이 서로소이면 ZMod(m*n) ≃+* ZMod m × ZMod n.

example (m n : ℕ) (hmn : Nat.Coprime m n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n :=
  ZMod.chineseRemainder hmn


-- §4.4 시연: 손자의 정리 (Sun Tzu's theorem) 사례
-- x ≡ 2 (mod 3), x ≡ 3 (mod 5), x ≡ 2 (mod 7)의 해 중 하나가 23.
-- 105 = 3 * 5 * 7.
example : (23 : ZMod 105).val % 3 = 2 ∧
          (23 : ZMod 105).val % 5 = 3 ∧
          (23 : ZMod 105).val % 7 = 2 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide


-- =========================================================
-- Part G. 페르마 소정리
-- =========================================================

-- §4.4 정리(페르마 소정리): p가 소수이고 a ≠ 0 in ZMod p이면 a^(p-1) = 1.

example (p : ℕ) [Fact p.Prime] (a : ZMod p) (ha : a ≠ 0) :
    a ^ (p - 1) = 1 :=
  ZMod.pow_card_sub_one_eq_one ha


-- §4.4 따름정리: 모든 a ∈ ZMod p에 대해 a^p = a.
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


-- =========================================================
-- 부록 - 본 자료의 주요 Mathlib API
-- =========================================================

/-
  ▷ 합동의 두 정의
    a ∣ b의 표준 정의:        ∃ k, b = a * k  (k가 오른쪽)
    dvd_iff_exists_eq_mul_left: a ∣ b ↔ ∃ k, b = k * a  (k가 왼쪽)

  ▷ 베주 항등식 (확장된 유클리드)
    Int.gcd a m              : 자연수 gcd
    Int.gcdA a m             : a 쪽 베주 계수 (정수)
    Int.gcdB a m             : m 쪽 베주 계수 (정수)
    Int.gcd_eq_gcd_ab        : gcd(a, m) = a * gcdA + m * gcdB (Int로 캐스팅)

  ▷ ZMod 환경
    ZMod n                   : Z/nZ 환
    ZMod.chineseRemainder    : 서로소 m, n에 대해 ZMod(m*n) ≃+* ZMod m × ZMod n
    ZMod.pow_card_sub_one_eq_one : 페르마 소정리

  ▷ Fact과 typeclass
    Fact (Nat.Prime p)       : p가 소수임을 typeclass로 표현 (전역 가정)
    haveI : Fact (...)       : 지역적으로 Fact 인스턴스 주입

  ▷ 다항식 항등식 자동화 도구
    ring                     : 가환환 다항식 항등식
    linear_combination       : 주어진 등식들의 선형 결합으로 목표 닫기
    field_simp               : 분수·역원 자동 처리

  ▷ 캐스팅
    exact_mod_cast           : 자연수↔정수 같은 캐스팅 자동 처리

  ▷ 분기
    by_cases ha : a = 0      : 명제 a = 0과 ¬ (a = 0)로 분기

  ▷ 거듭제곱
    pow_succ a n             : a^(n+1) = a^n * a
    zero_pow                 : n ≠ 0 → (0 : α)^n = 0
    one_mul a                : 1 * a = a
    Nat.sub_add_cancel       : k ≤ n → n - k + k = n

  ▷ unfold
    unfold CongMod at h ⊢    : 정의를 가정과 목표에서 모두 펼침
-/
