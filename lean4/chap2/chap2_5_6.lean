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
