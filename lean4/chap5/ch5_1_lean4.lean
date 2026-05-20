/-
  ch5_1_lean4_all_code.lean

  로젠 이산수학 §5.1 (수학적 귀납법) 학생 자료·코드 설명에 등장한
  모든 Lean 4 코드를 한 파일에 모은 것이다.

  본 파일은 다음 14개 정리(theorem)와 부속 example을 포함한다:

    1.  zero_add_nat              -- 0 + n = n
    2.  add_zero_nat              -- n + 0 = n
    3.  sum_odd_eq_sq             -- 처음 n개 홀수의 합 = n²
    4.  two_mul_sum_range         -- 가우스 합 (양변 2배)
    5.  n_lt_two_pow              -- n < 2^n  (n ≥ 1, Nat.le_induction)
    6.  three_dvd_n3_add_2n       -- 3 ∣ (n³ + 2n)  자연수
    7.  seven_dvd_11n_sub_4n      -- 7 ∣ (11^n − 4^n)  정수
    8.  sum_sq                    -- 제곱의 합 (양변 6배)
    9.  sum_cube                  -- 세제곱의 합 (양변 4배)
   10.  geom_sum                  -- 등비급수
   11.  pow_two_lt_fac            -- 2^n < n!  (n ≥ 4)
   12.  bernoulli                 -- 베르누이 부등식
   13.  div3_n3_sub_n_int         -- 3 ∣ (n³ − n)  정수, Int.induction_on
   14.  add_comm_nat              -- revert 기법으로 덧셈 교환 법칙

  부속 example: 멱집합 크기 (Mathlib 직접 인용), 페아노 P3·P4 시연.
-/

import Mathlib

open Finset BigOperators


-- =========================================================
-- 코드 1. zero_add_nat : 0 + n = n
-- =========================================================
theorem zero_add_nat (n : Nat) : 0 + n = n := by
  induction n with
  | zero =>
    rfl
  | succ k ih =>
    rw [Nat.add_succ]
    rw [ih]


-- =========================================================
-- 코드 2. add_zero_nat : n + 0 = n
-- =========================================================
theorem add_zero_nat (n : Nat) : n + 0 = n := by
  induction n with
  | zero =>
    rfl
  | succ k ih =>
    rw [Nat.succ_add]


-- =========================================================
-- 코드 3. sum_odd_eq_sq : 처음 n개 홀수의 합은 n의 제곱
--   (∑ k ∈ range n, (2k+1)) = n²
-- =========================================================
theorem sum_odd_eq_sq (n : Nat) :
    (∑ k ∈ Finset.range n, (2 * k + 1)) = n ^ 2 := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [ih]
    ring


-- =========================================================
-- 코드 4. two_mul_sum_range : 가우스 합 (양변 2배 형태)
--   2 · (∑ k ∈ range (n+1), k) = n(n+1)
-- =========================================================
theorem two_mul_sum_range (n : Nat) :
    2 * (∑ k ∈ Finset.range (n + 1), k) = n * (n + 1) := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [mul_add]
    rw [ih]
    ring

-- 대안 형태 (linarith 버전):
example (n : Nat) :
    2 * (∑ k ∈ Finset.range (n + 1), k) = n * (n + 1) := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    have h := ih
    linarith [h]


-- =========================================================
-- 코드 5. n_lt_two_pow : n ≥ 1 ⇒ n < 2^n
-- =========================================================
theorem n_lt_two_pow (n : Nat) (hn : 1 ≤ n) : n < 2 ^ n := by
  induction n, hn using Nat.le_induction with
  | base =>
    decide
  | succ k hk ih =>
    have h1 : k + 1 ≤ 2 * k := by omega
    have h2 : 2 * k < 2 * 2 ^ k := by
      have := ih
      nlinarith [pow_pos (by norm_num : (0 : Nat) < 2) k]
    calc k + 1
        ≤ 2 * k       := h1
      _ < 2 * 2 ^ k   := h2
      _ = 2 ^ (k + 1) := by rw [pow_succ]; ring


-- =========================================================
-- 코드 6. three_dvd_n3_add_2n : 3 ∣ (n³ + 2n) 자연수
-- =========================================================
theorem three_dvd_n3_add_2n (n : Nat) : 3 ∣ (n ^ 3 + 2 * n) := by
  induction n with
  | zero =>
    decide
  | succ k ih =>
    have key : (k + 1) ^ 3 + 2 * (k + 1)
             = (k ^ 3 + 2 * k) + 3 * (k ^ 2 + k + 1) := by
      ring
    rw [key]
    exact Nat.dvd_add ih (Dvd.intro (k ^ 2 + k + 1) rfl)


-- =========================================================
-- 코드 7. seven_dvd_11n_sub_4n : 7 ∣ (11^n − 4^n) 정수
-- =========================================================
theorem seven_dvd_11n_sub_4n (n : Nat) :
    (7 : Int) ∣ ((11 : Int) ^ n - 4 ^ n) := by
  induction n with
  | zero =>
    decide
  | succ k ih =>
    have key : (11 : Int) ^ (k + 1) - 4 ^ (k + 1)
             = 11 * (11 ^ k - 4 ^ k) + 7 * 4 ^ k := by
      ring
    rw [key]
    exact dvd_add (Dvd.dvd.mul_left ih 11) (Dvd.intro (4 ^ k) rfl)


-- =========================================================
-- 코드 8. sum_sq : 제곱의 합 (양변 6배 형태)
--   6 · (∑ k ∈ range (n+1), k²) = n(n+1)(2n+1)
-- =========================================================
theorem sum_sq (n : Nat) :
    6 * (∑ k ∈ Finset.range (n + 1), k ^ 2) = n * (n + 1) * (2 * n + 1) := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [mul_add]
    rw [ih]
    ring


-- =========================================================
-- 코드 9. sum_cube : 세제곱의 합 (양변 4배 형태)
--   4 · (∑ k ∈ range (n+1), k³) = (n(n+1))²
-- =========================================================
theorem sum_cube (n : Nat) :
    4 * (∑ k ∈ Finset.range (n + 1), k ^ 3) = (n * (n + 1)) ^ 2 := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [mul_add]
    rw [ih]
    ring


-- =========================================================
-- 코드 10. geom_sum : 등비급수
--   r ≠ 1 ⇒ ∑ k ∈ range (n+1), r^k = (r^(n+1) − 1) / (r − 1)
-- =========================================================
theorem geom_sum (r : Real) (hr : r ≠ 1) (n : Nat) :
    (∑ k ∈ Finset.range (n + 1), r ^ k) = (r ^ (n + 1) - 1) / (r - 1) := by
  have hrm1 : r - 1 ≠ 0 := sub_ne_zero.mpr hr
  induction n with
  | zero =>
    simp
    field_simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [ih]
    field_simp
    ring


-- =========================================================
-- 코드 11. pow_two_lt_fac : n ≥ 4 ⇒ 2^n < n!
-- =========================================================
theorem pow_two_lt_fac (n : Nat) (hn : 4 ≤ n) : 2 ^ n < n.factorial := by
  induction n, hn using Nat.le_induction with
  | base =>
    decide
  | succ k hk ih =>
    have h1 : 2 ^ (k + 1) = 2 * 2 ^ k := by
      rw [pow_succ]
      ring
    have h2 : (2 : Nat) * 2 ^ k < 2 * k.factorial := by
      have := ih
      nlinarith
    have h3 : 2 * k.factorial ≤ (k + 1) * k.factorial := by
      have hk1 : 2 ≤ k + 1 := by omega
      exact Nat.mul_le_mul_right _ hk1
    have h4 : (k + 1) * k.factorial = (k + 1).factorial := by
      rw [Nat.factorial_succ]
    omega


-- =========================================================
-- 코드 12. bernoulli : 베르누이 부등식
--   x ≥ −1 ⇒ (1 + x)^n ≥ 1 + n·x  (실수 위에서)
-- =========================================================
theorem bernoulli (x : Real) (hx : -1 ≤ x) (n : Nat) :
    (1 + x) ^ n ≥ 1 + n * x := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    have h1x : 0 ≤ 1 + x := by linarith
    have hkx_sq : 0 ≤ (k : Real) * x ^ 2 := by
      apply mul_nonneg
      · positivity
      · exact sq_nonneg x
    rw [pow_succ]
    push_cast
    calc (1 + x) ^ k * (1 + x)
        _ ≥ (1 + k * x) * (1 + x)       := by gcongr
        _ = 1 + (k + 1) * x + k * x ^ 2 := by ring
        _ ≥ 1 + (k + 1) * x             := by linarith


-- =========================================================
-- 코드 13. div3_n3_sub_n_int : 3 ∣ (n³ − n) 정수 (세 갈래 귀납)
-- =========================================================
theorem div3_n3_sub_n_int (n : Int) : (3 : Int) ∣ (n ^ 3 - n) := by
  induction n using Int.induction_on with
  | zero =>
    decide
  | succ k ih =>
    have key : ((k : Int) + 1) ^ 3 - ((k : Int) + 1)
             = ((k : Int) ^ 3 - (k : Int)) + 3 * ((k : Int) ^ 2 + (k : Int)) := by
      ring
    rw [key]
    exact dvd_add ih (Dvd.intro ((k : Int) ^ 2 + (k : Int)) rfl)
  | pred k ih =>
    have key : (-(k : Int) - 1) ^ 3 - (-(k : Int) - 1)
             = ((-(k : Int)) ^ 3 - (-(k : Int))) - 3 * ((k : Int) ^ 2 + (k : Int)) := by
      ring
    rw [key]
    exact dvd_sub ih (Dvd.intro ((k : Int) ^ 2 + (k : Int)) rfl)


-- =========================================================
-- 코드 14. add_comm_nat : 자연수 덧셈 교환 법칙 (revert 기법)
-- =========================================================
theorem add_comm_nat (n m : Nat) : n + m = m + n := by
  revert m
  induction n with
  | zero =>
    intro m
    simp
  | succ k ih =>
    intro m
    rw [Nat.succ_add]
    rw [ih m]
    rw [Nat.add_succ]


-- =========================================================
-- 부속 example A. 멱집합의 크기 (Mathlib 직접 인용)
-- =========================================================
example (s : Finset Nat) : s.powerset.card = 2 ^ s.card :=
  Finset.card_powerset s


-- =========================================================
-- 부속 example B. 페아노 P3 시연: 0 ≠ succ n
-- =========================================================
example (n : Nat) : 0 ≠ n.succ := by
  exact (Nat.succ_ne_zero n).symm


-- =========================================================
-- 부속 example C. 페아노 P4 시연: succ m = succ n ⇒ m = n
-- =========================================================
example (m n : Nat) (h : m.succ = n.succ) : m = n :=
  Nat.succ.inj h


-- =========================================================
-- 부속 example D. Nat.strong_induction_on 기본 형태 (§5.2 다리)
--   m ≤ m 만 닫는 사소한 예시. 본격적인 사용은 §5.2 자료에서.
-- =========================================================
example (n : Nat) : n ≤ n := by
  induction n using Nat.strong_induction_on with
  | _ m ih =>
    -- ih : ∀ k, k < m → k ≤ k  (현재는 직접 사용하지 않는다)
    exact Nat.le_refl m
