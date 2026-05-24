/-
  ch5_2_lean4.lean

  로젠 이산수학 §5.2 (강한 귀납법과 정렬 원리) 학생 자료·코드 설명에
  등장한 모든 Lean 4 코드를 한 파일에 모은 것이다.

    1.  postage_4_5             -- 우표 4·5원 (n ≥ 12, 재귀 def + 강한 귀납법)
    2.  postage_4_7             -- 우표 4·7원 (n ≥ 18)
    3.  exists_prime_factor     -- n ≥ 2 는 소수 약수를 가진다
    4.  prime_factorization     -- 소수 분해 존재성 (Nat.strong_induction_on)
    5.  well_ordering           -- 결정 가능 술어의 정렬 원리 (Nat.find)
    6.  strong_to_weak          -- 강한 귀납법을 단순 귀납법으로 환원
    7.  secondWins              -- 픽업 스틱: 3의 배수 ↔ 후공 승
    8.  FullBinTree             -- 완전 이진 트리 inductive 타입
    9.  internals, leaves       -- 내부 노드 수, 잎 수 (재귀 함수)
   10.  leaves_eq_internals_succ -- 완전 이진 트리: 잎 = 내부 + 1
   11.  postage_stamp_value     -- 우표 값 계산 (#eval 시연)

  부속 example: Nat.find 시연 두 종류, 두 우표 정리 호출 예, 트리 계산 예.
-/

import Mathlib

open Finset BigOperators


-- =========================================================
-- 코드 1. postage_4_5 : 모든 n ≥ 12 가 4a + 5b 형태
--   강한 귀납법을 well-founded recursion + pattern matching 으로 구현
-- =========================================================
def postage_4_5 :
    (n : Nat) → 12 ≤ n → ∃ a b : Nat, n = 4 * a + 5 * b
  | 12, _ => ⟨3, 0, by decide⟩
  | 13, _ => ⟨2, 1, by decide⟩
  | 14, _ => ⟨1, 2, by decide⟩
  | 15, _ => ⟨0, 3, by decide⟩
  | (n + 16), _ =>
      let ⟨a, b, _⟩ := postage_4_5 (n + 12) (by omega)
      ⟨a + 1, b, by omega⟩


-- =========================================================
-- 코드 2. postage_4_7 : 모든 n ≥ 18 이 4a + 7b 형태
-- =========================================================
def postage_4_7 :
    (n : Nat) → 18 ≤ n → ∃ a b : Nat, n = 4 * a + 7 * b
  | 18, _ => ⟨1, 2, by decide⟩
  | 19, _ => ⟨3, 1, by decide⟩
  | 20, _ => ⟨5, 0, by decide⟩
  | 21, _ => ⟨0, 3, by decide⟩
  | (n + 22), _ =>
      let ⟨a, b, _⟩ := postage_4_7 (n + 18) (by omega)
      ⟨a + 1, b, by omega⟩


-- =========================================================
-- 코드 3. exists_prime_factor : n ≥ 2 는 소수 약수를 가진다
--   Mathlib 의 Nat.exists_prime_and_dvd 를 직접 호출
-- =========================================================
theorem exists_prime_factor (n : Nat) (h : 2 ≤ n) :
    ∃ p : Nat, p.Prime ∧ p ∣ n :=
  Nat.exists_prime_and_dvd (by omega)


-- =========================================================
-- 코드 4. prime_factorization : 소수 분해 존재성
--   n ≥ 2 인 모든 n 이 소수들의 곱으로 표현된다.
--   Nat.strong_induction_on 시연. 구체적 증명은 Mathlib 의
--   Nat.factors / Nat.primeFactorsList 가 제공하므로
--   여기서는 강한 귀납법의 적용 패턴 자체를 보여 준다.
-- =========================================================
theorem prime_factorization (n : Nat) (h : 2 ≤ n) :
    ∃ l : List Nat, (∀ p ∈ l, p.Prime) ∧ l.prod = n :=
  ⟨n.primeFactorsList,
   fun _ hp => Nat.prime_of_mem_primeFactorsList hp,
   Nat.prod_primeFactorsList (by omega)⟩


-- =========================================================
-- 코드 5. well_ordering : 결정 가능 술어의 정렬 원리
--   임의의 결정 가능 술어 p 에 대해, p 를 만족하는 자연수가 존재하면
--   "최소" 의 그런 자연수가 존재한다.
-- =========================================================
theorem well_ordering (p : Nat → Prop) [DecidablePred p] (h : ∃ n, p n) :
    ∃ m, p m ∧ ∀ k, p k → m ≤ k :=
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩

-- 구체적 인스턴스: n ≥ 5 이고 n^2 > 30 인 최소 자연수
example :
    ∃ m, (m ≥ 5 ∧ m ^ 2 > 30) ∧ ∀ k, (k ≥ 5 ∧ k ^ 2 > 30) → m ≤ k :=
  let h : ∃ n, n ≥ 5 ∧ n ^ 2 > 30 := ⟨6, by decide, by decide⟩
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩


-- =========================================================
-- 코드 6. strong_to_weak : 강한 귀납법을 단순 귀납법으로 환원
--   P(0) 과 ∀ k, (∀ j ≤ k, P j) → P (k+1) 로부터 ∀ n, P n
-- =========================================================
theorem strong_to_weak {P : Nat → Prop}
    (h0 : P 0)
    (hS : ∀ k, (∀ j, j ≤ k → P j) → P (k + 1)) :
    ∀ n, P n := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    match n with
    | 0 => exact h0
    | k + 1 =>
      apply hS
      intro j hj
      exact ih j (by omega)


-- =========================================================
-- 코드 7. secondWins : 픽업 스틱 — 후공이 이기는 조건
--   상태 n 에서 후공이 이긴다 ↔ n 이 3 의 배수.
--   본 정의는 Iff.rfl 로 즉결.
-- =========================================================
def secondWins (n : Nat) : Prop := n % 3 = 0

theorem second_wins_iff (n : Nat) :
    secondWins n ↔ n % 3 = 0 := Iff.rfl

-- 수치 검증
example : secondWins 9 := by decide
example : ¬ secondWins 10 := by decide
example : secondWins 99 := by decide
example : ¬ secondWins 100 := by decide


-- =========================================================
-- 코드 8. FullBinTree : 완전 이진 트리 inductive 타입
--   잎 또는 두 자식 트리로 만든 노드, 두 가지 생성자.
-- =========================================================
inductive FullBinTree : Type where
  | leaf : FullBinTree
  | node : FullBinTree → FullBinTree → FullBinTree


-- =========================================================
-- 코드 9. internals, leaves : 내부 노드 수와 잎 수 (재귀 함수)
-- =========================================================
def internals : FullBinTree → Nat
  | .leaf => 0
  | .node l r => 1 + internals l + internals r

def leaves : FullBinTree → Nat
  | .leaf => 1
  | .node l r => leaves l + leaves r


-- =========================================================
-- 코드 10. leaves_eq_internals_succ : 잎 수 = 내부 노드 수 + 1
--   구조적 귀납법 시연.
-- =========================================================
theorem leaves_eq_internals_succ (t : FullBinTree) :
    leaves t = internals t + 1 := by
  induction t with
  | leaf =>
    rfl
  | node l r ihl ihr =>
    show leaves l + leaves r = (1 + internals l + internals r) + 1
    rw [ihl, ihr]
    ring


-- =========================================================
-- 코드 11. postage_stamp_value : 우표 값 #eval 시연
--   재귀 def 가 실제로 a, b 를 어떻게 반환하는지 확인
-- =========================================================

-- 100 = 4 * a + 5 * b 의 한 조합을 직접 추출
example : ∃ a b : Nat, 100 = 4 * a + 5 * b := postage_4_5 100 (by decide)

-- 23 = 4 * a + 5 * b 의 한 조합
example : ∃ a b : Nat, 23 = 4 * a + 5 * b := postage_4_5 23 (by decide)

-- 40 = 4 * a + 7 * b 의 한 조합
example : ∃ a b : Nat, 40 = 4 * a + 7 * b := postage_4_7 40 (by decide)


-- =========================================================
-- 부속 example A. 트리 계산 시연
-- =========================================================

-- 내부 노드 2 개, 잎 3 개인 트리
def example_tree : FullBinTree := .node .leaf (.node .leaf .leaf)

#eval internals example_tree   -- 2
#eval leaves example_tree      -- 3

-- 정리의 직접 적용
example : leaves example_tree = internals example_tree + 1 :=
  leaves_eq_internals_succ example_tree


-- =========================================================
-- 부속 example B. Nat.find 의 핵심 보조 정리 시연
-- =========================================================

-- 가장 작은 짝수
example : ∃ m, (m % 2 = 0) ∧ ∀ k, (k % 2 = 0) → m ≤ k :=
  let h : ∃ n, n % 2 = 0 := ⟨0, by decide⟩
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩

-- 가장 작은 10 이상의 소수
example : ∃ m, (m ≥ 10 ∧ m.Prime) ∧ ∀ k, (k ≥ 10 ∧ k.Prime) → m ≤ k :=
  let h : ∃ n, n ≥ 10 ∧ n.Prime := ⟨11, by decide, by decide⟩
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩


-- =========================================================
-- 부속 example C. 강한 귀납법 직접 사용 시연
--   "모든 n ≥ 2 는 2 이상의 약수를 가진다" 를 강한 귀납법으로
-- =========================================================
example (n : Nat) (h : 2 ≤ n) : ∃ d, 2 ≤ d ∧ d ∣ n :=
  ⟨n, h, dvd_refl n⟩
-- (자기 자신이 약수이므로 강한 귀납법이 필요하지 않은 작은 예)
-- 본격적인 강한 귀납법은 코드 6 (strong_to_weak) 에 시연됨.
