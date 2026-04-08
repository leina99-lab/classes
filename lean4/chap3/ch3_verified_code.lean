-- ============================================================
-- Rosen Chapter 3: 전체 Lean 4 코드 검증 파일
-- 이 파일의 모든 코드는 `import Mathlib` 없이
-- 순수 Lean 4로 동작하도록 작성하였다.
-- ============================================================

-- ============================================================
-- 1. 기본 함수 정의
-- ============================================================

-- 두 수를 더하는 함수
def myAdd (a b : Nat) : Nat := a + b
#eval myAdd 3 5  -- 8

-- 짝수 판별
def isEven (n : Nat) : Bool := n % 2 == 0
#eval isEven 4   -- true
#eval isEven 7   -- false

-- 두 배
def double (n : Nat) : Nat := n * 2
#eval double 7   -- 14

-- ============================================================
-- 2. 패턴 매칭
-- ============================================================

def describe (n : Nat) : String :=
  match n with
  | 0 => "영"
  | 1 => "일"
  | _ => "기타"

#eval describe 0   -- "영"
#eval describe 5   -- "기타"

-- 재귀 함수: 팩토리얼
def factorial : Nat → Nat
  | 0     => 1
  | n + 1 => (n + 1) * factorial n

#eval factorial 5   -- 120
#eval factorial 10  -- 3628800

-- ============================================================
-- 3. 자연수 연산
-- ============================================================

def myMul : Nat → Nat → Nat
  | _, 0     => 0
  | n, m + 1 => n + myMul n m

#eval myMul 3 4  -- 12

def myPow : Nat → Nat → Nat
  | _, 0     => 1
  | b, e + 1 => b * myPow b e

#eval myPow 2 10  -- 1024

-- ============================================================
-- 4. 리스트 함수
-- ============================================================

def mySum : List Nat → Nat
  | []      => 0
  | a :: as => a + mySum as

#eval mySum [1, 2, 3, 4, 5]  -- 15

def myLen : List Nat → Nat
  | []      => 0
  | _ :: as => 1 + myLen as

#eval myLen [10, 20, 30]  -- 3

def myMem (x : Nat) : List Nat → Bool
  | []      => false
  | a :: as => if a == x then true else myMem x as

#eval myMem 7 [3, 5, 7, 9]   -- true
#eval myMem 4 [3, 5, 7, 9]   -- false

-- ============================================================
-- 5. 최댓값 찾기 (알고리즘 1)
-- ============================================================

def myMax : List Nat → Nat
  | []      => 0
  | [a]     => a
  | a :: as =>
    let m := myMax as
    if a >= m then a else m

#eval myMax [8, 4, 11, 3, 10]  -- 11
#eval myMax [1]                -- 1
#eval myMax [5, 5, 5]          -- 5
#eval myMax []                 -- 0

-- 비교 횟수를 함께 반환하는 버전
def maxWithCount : List Nat → Nat × Nat
  | []      => (0, 0)
  | [a]     => (a, 0)
  | a :: as =>
    let (m, c) := maxWithCount as
    if a >= m then (a, c + 1) else (m, c + 1)

#eval maxWithCount [8, 4, 11, 3, 10]  -- (11, 4)

-- ============================================================
-- 6. 선형 탐색 (알고리즘 2)
-- ============================================================

def linearSearch (x : Nat) : List Nat → Nat → Nat
  | [], _       => 0
  | a :: as, i  =>
    if a == x then i
    else linearSearch x as (i + 1)

#eval linearSearch 7 [3, 5, 7, 8, 10] 1  -- 3
#eval linearSearch 4 [3, 5, 7, 8, 10] 1  -- 0

-- ============================================================
-- 7. 이진 탐색 (알고리즘 3)
-- 주의: Array 사용, termination_by 필수
-- ============================================================

def binarySearch (x : Nat) (arr : Array Nat)
    (lo hi : Nat) : Nat :=
  if h : lo < hi then
    let mid := (lo + hi) / 2
    if arr[mid]! == x then mid + 1
    else if arr[mid]! < x then
      binarySearch x arr (mid + 1) hi
    else
      binarySearch x arr lo mid
  else 0
termination_by hi - lo

#eval binarySearch 19 #[1,2,3,5,6,7,8,10,12,13,15,16,18,19,20,22] 0 16
-- 14

-- ============================================================
-- 8. 버블 정렬 (알고리즘 4)
-- ============================================================

def bubblePass : List Nat → List Nat
  | []  => []
  | [a] => [a]
  | a :: b :: rest =>
    if a > b then b :: bubblePass (a :: rest)
    else a :: bubblePass (b :: rest)

def bubbleSort : Nat → List Nat → List Nat
  | 0, xs     => xs
  | n + 1, xs => bubbleSort n (bubblePass xs)

#eval bubbleSort 4 [3, 2, 4, 1, 5]  -- [1, 2, 3, 4, 5]
#eval bubbleSort 5 [5, 4, 3, 2, 1]  -- [1, 2, 3, 4, 5]

-- ============================================================
-- 9. 삽입 정렬 (알고리즘 5)
-- ============================================================

def insert (x : Nat) : List Nat → List Nat
  | []      => [x]
  | a :: as =>
    if x ≤ a then x :: a :: as
    else a :: insert x as

def insertionSort : List Nat → List Nat
  | []      => []
  | a :: as => insert a (insertionSort as)

#eval insertionSort [3, 2, 4, 1, 5]  -- [1, 2, 3, 4, 5]
#eval insertionSort [5, 4, 3, 2, 1]  -- [1, 2, 3, 4, 5]

-- ============================================================
-- 10. 거스름돈 (욕심쟁이 알고리즘)
-- ============================================================

def cashier (n : Nat) : List (Nat × Nat) :=
  let q25 := n / 25
  let r25 := n % 25
  let q10 := r25 / 10
  let r10 := r25 % 10
  let q5  := r10 / 5
  let r5  := r10 % 5
  [(25, q25), (10, q10), (5, q5), (1, r5)]

#eval cashier 67  -- [(25, 2), (10, 1), (5, 1), (1, 2)]

-- ============================================================
-- 11. 추가 리스트 함수 (연습문제용)
-- ============================================================

-- 최솟값
def myMin : List Nat → Nat
  | []      => 0
  | [a]     => a
  | a :: as =>
    let m := myMin as
    if a ≤ m then a else m

#eval myMin [8, 4, 11, 3, 10]  -- 3

-- 정렬 확인
def isSorted : List Nat → Bool
  | []  => true
  | [_] => true
  | a :: b :: rest => a ≤ b && isSorted (b :: rest)

#eval isSorted [1, 2, 3, 5]   -- true
#eval isSorted [1, 3, 2, 5]   -- false

-- 뒤집기
def myReverse : List Nat → List Nat
  | []      => []
  | a :: as => myReverse as ++ [a]

#eval myReverse [1, 2, 3]  -- [3, 2, 1]

-- 짝수 개수
def countEven : List Nat → Nat
  | []      => 0
  | a :: as => (if a % 2 == 0 then 1 else 0) + countEven as

#eval countEven [1, 2, 3, 4, 5]  -- 2

-- n보다 큰 원소 필터
def filterGt (n : Nat) : List Nat → List Nat
  | []      => []
  | a :: as =>
    if a > n then a :: filterGt n as
    else filterGt n as

#eval filterGt 3 [1, 2, 3, 4, 5]  -- [4, 5]

-- 병합 (두 정렬된 리스트)
def merge : List Nat → List Nat → List Nat
  | [], ys      => ys
  | xs, []      => xs
  | x :: xs, y :: ys =>
    if x ≤ y then x :: merge xs (y :: ys)
    else y :: merge (x :: xs) ys

#eval merge [1, 3, 5] [2, 4, 6]  -- [1, 2, 3, 4, 5, 6]

-- 리스트의 곱
def product : List Nat → Nat
  | []      => 1
  | a :: as => a * product as

#eval product [1, 2, 3, 4, 5]  -- 120

-- ============================================================
-- 12. 간단한 증명들 (import Mathlib 불필요)
-- ============================================================

-- rfl: 양변이 정의상 같을 때
example : 3 + 4 = 7 := by rfl

-- omega: 선형 산술
example (n : Nat) : n + 0 = n := by omega
example : 5 > 3 := by omega
example (n : Nat) : n + 1 > n := by omega

-- rw: 등식으로 치환
example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]

-- simp: 간단화
example (n : Nat) : 0 + n = n := by simp

-- ↔ 증명: constructor로 양방향
example (n : Nat) : n > 0 ↔ n ≥ 1 := by
  constructor
  · intro h; omega
  · intro h; omega

-- ============================================================
-- 13. Big-O 관련 증명 (nlinarith 사용)
-- 주의: nlinarith는 Mathlib이 필요할 수 있다.
-- 순수 Lean 4에서는 omega로 선형 경우만 처리 가능.
-- Mathlib 사용 시 nlinarith 가능.
-- ============================================================

-- 선형 부등식 (omega로 충분)
example : ∀ n : Nat, n > 7 → 3 * n + 7 ≤ 4 * n := by
  intro n hn; omega

-- 비선형은 Mathlib의 nlinarith가 필요
-- import Mathlib 후:
-- example : ∀ n : Nat, n > 1 →
--   n ^ 2 + 2 * n + 1 ≤ 4 * n ^ 2 := by
--   intro n hn; nlinarith

-- Mathlib 없이 비선형 증명을 하려면 수동으로:
-- (이 부분은 수업에서 Mathlib 사용을 전제로 설명)

-- ============================================================
-- 14. IsBigO 형식적 정의 (Mathlib 필요)
-- ============================================================

-- import Mathlib 후 사용 가능한 정의:
-- def IsBigO (f g : Nat → Nat) : Prop :=
--   ∃ C k : Nat, C > 0 ∧
--     ∀ n : Nat, n > k →
--       f n ≤ C * g n
--
-- example : IsBigO
--   (fun n => n ^ 2 + 2 * n + 1)
--   (fun n => n ^ 2) := by
--   use 4, 1
--   constructor
--   · omega
--   · intro n hn; nlinarith
