import Mathlib

/-
myMax [8, 4, 11, 3, 10];
= let m := myMax [4, 11, 3, 10] in if 8 ≥ m then 8 else m
  = let m := myMax [11, 3, 10] in if 4 ≥ m then 4 else m
    = let m := myMax [3, 10] in if 11 ≥ m then 11 else m
      = let m := myMax [10] in if 3 ≥ m then 3 else m
        = 10  (기저 경우: 원소 하나)
      = if 3 ≥ 10 then 3 else 10 = 10
    = if 11 ≥ 10 then 11 else 10 = 11
  = if 4 ≥ 11 then 4 else 11 = 11
= if 8 ≥ 11 then 8 else 11 = 11
-/

import Mathlib

-- ══════════════════════════════════════
-- 1. myMax 정의  ← 반드시 theorem 위에
-- ══════════════════════════════════════
def myMax : List Nat → Nat
  | []        => 0
  | [a]       => a
  | a :: rest =>
    let m := myMax rest
    if a ≥ m then a else m

#eval myMax [8, 4, 11, 3, 10]  -- 11

-- ══════════════════════════════════════
-- 2. myMax 정확성 증명
-- ══════════════════════════════════════
theorem myMax_is_ge (L : List Nat) (x : Nat) (h : x ∈ L) : myMax L ≥ x := by
  induction L with
  | nil =>
    -- h : x ∈ []  →  모순.  simp 가 자동으로 닫는다
    simp at h
  | cons a rest ih =>
    cases rest with
    | nil =>
      -- L = [a] 인 경우
      -- 목표: myMax [a] ≥ x  =  a ≥ x
      show a ≥ x
      -- h : x ∈ [a]  →  x = a
      rw [List.mem_singleton] at h
      -- h : x = a  →  x ≤ a  (le_of_eq 사용)
      exact le_of_eq h
    | cons b bs =>
      -- L = a :: b :: bs 인 경우
      simp only [myMax]
      split
      · -- 분기: a ≥ myMax (b :: bs) 가 참
        rename_i hge
        rw [List.mem_cons] at h
        cases h with
        | inl h_eq =>
          -- x = a
          rw [h_eq]   -- 목표 a ≥ a, rw 후 자동 닫힘
        | inr h_in =>
          -- x ∈ b :: bs
          exact Nat.le_trans (ih h_in) hge
      · -- 분기: a ≥ myMax (b :: bs) 가 거짓
        rename_i hlt
        rw [List.mem_cons] at h
        cases h with
        | inl h_eq =>
          rw [h_eq]
          exact Nat.le_of_lt (Nat.lt_of_not_le hlt)
        | inr h_in =>
          exact ih h_in


def linearSearch [BEq a] (x : a)
    : List a → Option Nat
  | []      => none
  | a :: as =>
    if a == x then some 0
    else match linearSearch x as with
      | none   => none
      | some i => some (i + 1)

#eval linearSearch 7 [3,5,7,8,10]
-- some 2  (0-indexed)


def binarySearch (arr : Array Nat) (x : Nat) : Option Nat :=
  go (arr.size + 1) 0 (arr.size - 1)
where
  go (fuel lo hi : Nat) : Option Nat :=
    match fuel with
    | 0     => none           -- 연료 소진: 이 경우는 실제로 발생하지 않음
    | n + 1 =>
      if lo > hi then none
      else
        let mid := (lo + hi) / 2
        let v   := arr[mid]!
        if v == x      then some mid
        else if v < x  then go n (mid + 1) hi
        else if mid == 0 then none
        else               go n lo (mid - 1)


-- ══════════════════════════════════════
-- BUBBLE SORT
-- ══════════════════════════════════════
-- ══════════════════════════════════════
-- 배열 두 원소 교환: swap! 대신 set! 두 번
-- ══════════════════════════════════════
private def arraySwap (a : Array Nat) (i j : Nat) : Array Nat :=
  let vi := a[i]!
  let vj := a[j]!
  a.set! i vj |>.set! j vi

-- ══════════════════════════════════════
-- bubblePass: 한 패스, 가장 큰 원소를 뒤로
-- ══════════════════════════════════════
private def bubblePass (a : Array Nat) (n : Nat) : Array Nat :=
  go a 0
where
  go (curr : Array Nat) (i : Nat) : Array Nat :=
    if i + 1 < n then
      let curr' := if curr[i]! > curr[i+1]!
                   then arraySwap curr i (i+1)  -- swap! → arraySwap
                   else curr
      go curr' (i + 1)
    else curr
  termination_by n - i
  decreasing_by omega

-- ══════════════════════════════════════
-- bubbleSort: 패스를 반복
-- ══════════════════════════════════════
def bubbleSort (arr : Array Nat) : Array Nat :=
  go arr arr.size
where
  go (a : Array Nat) : Nat → Array Nat
    | 0     => a
    | n + 1 => go (bubblePass a (n + 1)) n

#eval bubbleSort #[5, 3, 8, 1, 9, 2]
-- 기댓값: #[1, 2, 3, 5, 8, 9]

#eval bubbleSort #[1]
-- 기댓값: #[1]

#eval bubbleSort #[]
-- 기댓값: #[]

#eval bubbleSort #[3, 3, 3]
-- 기댓값: #[3, 3, 3]

-- ══════════════════════════════════════
-- InsertSort: 
-- ══════════════════════════════════════

def myInsert (x : Nat) : List Nat → List Nat
  | []      => [x]
  | a :: as =>
    if x ≤ a then x :: a :: as
    else a :: myInsert x as

def insertionSort : List Nat → List Nat
  | []      => []
  | a :: as => myInsert a (insertionSort as)

#eval insertionSort [3, 2, 4, 1, 5]   -- [1, 2, 3, 4, 5]
#eval insertionSort [5, 4, 3, 2, 1]   -- [1, 2, 3, 4, 5]

-- ══════════════════════════════════════
-- 욕심쟁이 알고리즘
-- ══════════════════════════════════════
def greedyChange (coins : List Nat) (amount : Nat)
    : List (Nat × Nat) :=
  go coins amount []
where
  go : List Nat → Nat → List (Nat × Nat)
      → List (Nat × Nat)
  | [], _, acc => acc
  | _, 0, acc => acc
  | c :: cs, rem, acc =>
    let count := rem / c
    go cs (rem % c) (acc ++ [(c, count)])

-- ══════════════════════════════════════
-- 3. Big-O 정의 + 증명
-- ══════════════════════════════════════
def BigO (f g : Nat → Nat) : Prop :=
  ∃ C : Nat, ∃ k : Nat, C > 0 ∧
    ∀ n : Nat, n > k → f n ≤ C * g n

theorem linear_bigO :
    BigO (fun n => 3 * n + 5) (fun n => n) := by
  use 4, 5
  constructor
  · -- 목표: 4 > 0
    exact Nat.succ_pos 3
  · -- 목표: ∀ n, n > 5 → 3 * n + 5 ≤ 4 * n
    intro n hn
    -- 람다를 명시적으로 전개
    show 3 * n + 5 ≤ 4 * n
    -- hn : n > 5  →  5 ≤ n
    have h5n : 5 ≤ n := Nat.le_of_lt hn
    -- calc 로 단계별 전개
    calc 3 * n + 5
        ≤ 3 * n + n := Nat.add_le_add_left h5n (3 * n)
      _ = 4 * n     := (Nat.succ_mul 3 n).symm

theorem quad_bigO :
    BigO (fun n => 5*n^2 + 3*n + 7) (fun n => n^2) := by
  use 6, 7
  constructor
  · exact Nat.succ_pos 5     -- 6 > 0  
  · intro n hn
    show 5 * n^2 + 3 * n + 7 ≤ 6 * n^2
    nlinarith [sq_nonneg n, Nat.mul_le_mul_right n hn]


def BigOmega (f g : Nat → Nat) : Prop :=
  ∃ C : Nat, ∃ k : Nat, C > 0 ∧
    ∀ n : Nat, n > k → f n ≥ C * g n

def BigTheta (f g : Nat → Nat) : Prop :=
  BigO f g ∧ BigOmega f g

theorem linear_theta :
    BigTheta (fun n => 3*n+5) (fun n => n) := by
  constructor
  -- O(n) 방향
  · use 4, 5; constructor; · nlinarith
    · intro n hn; nlinarith
  -- Omega(n) 방향
  · use 3, 0; constructor; · nlinarith
    · intro n hn; nlinarith


theorem sum_rule (h1 : BigO f1 g) (h2 : BigO f2 g) :
    BigO (fun n => f1 n + f2 n) g := by
  obtain ⟨C1, k1, hC1, h1⟩ := h1; obtain ⟨C2, k2, hC2, h2⟩ := h2
  use C1 + C2, max k1 k2; constructor; · omega
  · intro n hn; have := h1 n (by omega); have := h2 n (by omega); nlinarith



