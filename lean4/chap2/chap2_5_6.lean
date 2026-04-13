import Mathlib
import Mathlib.Tactic

import Mathlib.Data.Set.Lattice

open Function

-- 1. 전사함수(Surjective) 증명
example : Surjective (fun (n : ℤ) => n + 1) := by
  intro b
  use b - 1
  dsimp
  -- 현재 상태: b - 1 + 1 = b
  rw [Int.sub_eq_add_neg]
  -- 상태: b + -1 + 1 = b (Lean은 이를 (b + -1) + 1 로 인식)
  rw [Int.add_assoc] 
  -- 상태: b + (-1 + 1) = b
  rw [Int.add_left_neg]
  -- 상태: b + 0 = b
  rw [Int.add_zero]

-- 2. 단사함수(Injective) 증명
example : Injective (fun (n : ℤ) => n + 1) := by
  intro a1 a2 h
  dsimp at h
  -- h: a1 + 1 = a2 + 1
  have h_sub : (a1 + 1) - 1 = (a2 + 1) - 1 := by
    rw [h]
  
  -- repeat를 붙여서 좌변과 우변의 패턴을 모두 찾아 소거합니다.
  repeat rw [Int.add_sub_assoc] at h_sub
  repeat rw [Int.sub_self] at h_sub
  repeat rw [Int.add_zero] at h_sub
  
  -- 이제 h_sub는 정확히 a1 = a2 가 됩니다.
  exact h_sub

example : Function.Surjective (fun n : Int => n + 1) := by
  intro b
  use b - 1
  simp 

example : Function.Surjective (fun n : Int => n + 1) := by
  intro b
  use b - 1
  -- (fun n => n + 1) (b - 1)을 계산 가능한 형태로 전개합니다.
  dsimp
  -- 1. 뺄셈을 가법 역원의 덧셈으로 변환합니다.
  rw [Int.sub_eq_add_neg]
  -- 2. 덧셈의 결합법칙을 사용하여 상수항을 묶습니다.
  rw [Int.add_assoc]
  -- 3. 가법 역원의 성질 (-1 + 1 = 0)을 적용합니다.
  rw [Int.add_left_neg]
  -- 4. 가법 항등원의 성질 (b + 0 = b)로 증명을 마칩니다.
  rw [Int.add_zero]

example : Bijective (fun (n : ℤ) => n + 1) := by
  constructor
  · intro a b h; linarith -- 선형 등식 관계를 파악하여 결론 도출
  · intro b; use b - 1; linarith


def fib : Nat → Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => fib (n+1) + fib n




variable {α : Type*}

/-- 칸토어의 대각선 논법: 임의의 집합 α에서 그 멱집합(Set α)으로의 전사 함수는 존재하지 않는다. -/
theorem cantor_diagonal (f : α → Set α) : ¬ Function.Surjective f := by
  -- 1. 전사 함수 hf가 존재한다고 가정 (귀류법)
  intro hf
  
  -- 2. 대각선 집합 S 정의
  let S : Set α := {i | i ∉ f i}
  
  -- 3. 전사성의 정의에 따라 f j = S를 만족하는 j를 추출
  obtain ⟨j, hj⟩ := hf S
  
  -- 4. j ∈ S 여부에 따른 배중률 분기
  by_cases h : j ∈ S
  · -- [Case 1] j ∈ S인 경우
    -- S의 정의에 따라 h는 j ∉ f j와 정의상 동일(defeq)함
    -- hj를 사용하여 f j를 S로 치환: j ∉ f j → j ∉ S
    have h_not_in_S : j ∉ S := by
      rw [← hj]
      exact h
    -- j ∈ S와 j ∉ S의 모순
    exact h_not_in_S h
    
  · -- [Case 2] j ∉ S인 경우
    -- j ∉ S는 ¬(j ∈ S)이며, S의 정의에 의해 ¬(j ∉ f j) 즉, j ∈ f j와 같음
    -- hj를 사용하여 f j를 S로 치환: j ∈ f j → j ∈ S
    have h_in_S : j ∈ S := by
      rw [← hj] at h
      -- h : j ∉ f j 인 상태에서 다시 h를 활용하여 모순 유도 또는 정의 전개
      -- 여기서는 S의 정의 자체를 h에 투영함
      exact h 
    -- j ∉ S와 j ∈ S의 모순
    exact h h_in_S

def A : Matrix (Fin 2) (Fin 2) Int := !![1, 2; 3, 4]
def B : Matrix (Fin 2) (Fin 2) Int := !![5, 6; 7, 8]

example : A * B ≠ B * A := by
  intro h
  have h00 : (A * B) 0 0 = (B * A) 0 0 := by rw [h]
  simp [A, B, Matrix.mul_apply,
        Fin.sum_univ_two] at h00
  -- h00 : 19 = 23,  즉 모순
  -- omega로 닫거나, exact absurd h00 (by decide)도 가능



open Nat

theorem example_injective_fixed : 
  Function.Injective (fun p : ℕ × ℕ => 2 ^ p.1 * 3 ^ p.2) := by
  intro ⟨i₁, j₁⟩ ⟨i₂, j₂⟩ h
  -- [핵심] 람다 함수 표현식을 값으로 전개한다.
  dsimp at h 
  -- 이제 h는 2 ^ i₁ * 3 ^ j₁ = 2 ^ i₂ * 3 ^ j₂ 형태가 됨.

  have h_coprime : ∀ a b : ℕ, Coprime (2 ^ a) (3 ^ b) := by
    intro a b
    apply Coprime.pow
    norm_num

  -- [단계 1] 2^i₁ = 2^i₂ 증명
  have h_pow2_eq : 2 ^ i₁ = 2 ^ i₂ := by
    apply dvd_antisymm
    · -- 2^i₁ ∣ 2^i₂ 증명
      apply (h_coprime i₁ j₂).dvd_of_dvd_mul_right
      rw [← h]
      apply dvd_mul_right
    · -- 2^i₂ ∣ 2^i₁ 증명
      apply (h_coprime i₂ j₁).dvd_of_dvd_mul_right
      rw [h]
      apply dvd_mul_right

  -- [단계 2] i₁ = i₂ 도출
  -- Nat 네임스페이스를 명시하거나 open Nat을 확인한다.
  have hi : i₁ = i₂ := Nat.pow_right_injective (by norm_num) h_pow2_eq

  -- [단계 3] 3^j₁ = 3^j₂ 증명
  have h_pow3_eq : 3 ^ j₁ = 3 ^ j₂ := by
    -- h에서 i₁을 i₂로 치환
    rw [hi] at h
    -- Nat.mul_left_cancel 을 사용하여 2^i₂를 제거
    apply Nat.mul_left_cancel (pow_pos (by norm_num) i₂) h

  -- [단계 4] j₁ = j₂ 도출
  have hj : j₁ = j₂ := Nat.pow_right_injective (by norm_num) h_pow3_eq

  -- 최종 결과 결합
  exact congrArg₂ Prod.mk hi hj
