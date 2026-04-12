```lean 
import Mathlib
import Mathlib.Tactic
-- 단사: f(a) = f(b) -> a = b
-- 단사: f(a) = f(b) -> a = b
example : Function.Injective (fun n : Nat => n + 1) := by
  intro a b h     -- h : (fun n => n + 1) a = (fun n => n + 1) b
  simp at h       -- h : a = b  (베타 환원 + 1 소거까지 simp이 해준다)
  exact h

example : Function.Surjective (fun n : Int => n + 1) := by
  intro b          -- b : Int
  use b - 1        -- 증인(witness)
  simp             -- 목표: (fun n => n + 1) (b - 1) = b  →  simp이 닫는다

example : Function.Bijective (fun n : Int => n + 1) := by
  constructor
  · intro a b h    -- 단사
    simp at h
    exact h
  · intro b        -- 전사
    use b - 1
    simp
-- constructor가 Bijective = Injective ∧ Surjective를
-- 두 개의 하위 목표로 분리한다.
pen Function

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


def fib : Nat -> Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => fib (n + 1) + fib n

#eval (List.range 10).map fib
-- [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
-- 예제 5: a_0 = 2, a_n = a_{n-1} + 3

def seq5 : Nat -> Nat
  | 0 => 2
  | n + 1 => seq5 n + 3

#eval (List.range 6).map seq5
-- [2, 5, 8, 11, 14, 17]


-- 시나리오 1
example : Function.Injective (fun n : Nat => n + 1) := by
  intro a b h
  simp at h
  exact h

-- 시나리오 3
example : Function.Injective (fun n : Nat => 2 * n) := by
  intro a b h
  simp at h
  exact h


-- Mathlib 에는 이미 ℚ 가 가산이라는 사실이 들어 있다.
example : Countable ℚ := inferInstance

-- 그 뿌리는 다음 두 사실이다.
example : Countable (ℕ × ℕ) := inferInstance
example : Countable ℤ := inferInstance



example : Function.Injective (fun p : Nat × Nat => 2 ^ p.1 * 3 ^ p.2) := by
  rintro ⟨i₁, j₁⟩ ⟨i₂, j₂⟩ h
  simp only at h

  have h2prime : Nat.Prime 2 := Nat.prime_two
  have h3prime : Nat.Prime 3 := Nat.prime_three
  have h2pow_ne : ∀ k : ℕ, (2 : ℕ) ^ k ≠ 0 := fun k =>
    pow_ne_zero k (by norm_num)
  have h3pow_ne : ∀ k : ℕ, (3 : ℕ) ^ k ≠ 0 := fun k =>
    pow_ne_zero k (by norm_num)

  -- 경고 제거: Finsupp.single_apply 빼기
  have fact_at_2 : ∀ i j : ℕ,
      (2 ^ i * 3 ^ j : ℕ).factorization 2 = i := by
    intro i j
    rw [Nat.factorization_mul (h2pow_ne i) (h3pow_ne j)]
    rw [Nat.factorization_pow, Nat.factorization_pow]
    rw [h2prime.factorization, h3prime.factorization]
    simp

  have fact_at_3 : ∀ i j : ℕ,
      (2 ^ i * 3 ^ j : ℕ).factorization 3 = j := by
    intro i j
    rw [Nat.factorization_mul (h2pow_ne i) (h3pow_ne j)]
    rw [Nat.factorization_pow, Nat.factorization_pow]
    rw [h2prime.factorization, h3prime.factorization]
    simp

  -- 핵심 수정: congr_arg 뒤에 simp only []로 베타 환원을 강제
  have hi : i₁ = i₂ := by
    have this := congr_arg (fun n : ℕ => n.factorization 2) h
    simp only [] at this   -- 베타 환원: (fun n => ...) x  →  x.factorization 2
    rw [fact_at_2, fact_at_2] at this
    exact this

  have hj : j₁ = j₂ := by
    have this := congr_arg (fun n : ℕ => n.factorization 3) h
    simp only [] at this
    rw [fact_at_3, fact_at_3] at this
    exact this

  rw [hi, hj]


example {A B : Set ℕ} (hA : A.Countable) (hB : B.Countable) :
    (A ∪ B).Countable := hA.union hB

-- 가산 합집합 따름정리.
example {ι : Type*} [Countable ι] {A : ι → Set ℕ}
    (hA : ∀ i, (A i).Countable) : (⋃ i, A i).Countable :=
  Set.countable_iUnion hA


example : A * B ≠ B * A := by
  intro h
  have := congr_fun (congr_fun h 0) 0
  simp [A, B, Matrix.mul_apply, Fin.sum_univ_two] at this
```
