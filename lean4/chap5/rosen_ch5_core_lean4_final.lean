import Mathlib.Tactic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Factorization.Basic


set_option autoImplicit false
set_option linter.unusedVariables false

namespace RosenCh5

/-============================================================================
  Part 1. 자연수 타입 N 과 덧셈의 대수
  (슬라이드 133-136)
============================================================================-/

inductive N where
  | z : N
  | s : N -> N
  deriving Repr, DecidableEq

namespace N

/-- 덧셈의 재귀 정의. 첫 인자에 대한 패턴 매칭이다.
    자동으로 `add.eq_1 : add z b = b`, `add.eq_2 : add (s a) b = s (add a b)` 가 생성된다. -/
def add : N -> N -> N
  | z, b => b
  | s a, b => s (add a b)

/-- 정의 등식의 별칭. 슬라이드의 표기와 일치시킨다. -/
theorem z_add (b : N) : add z b = b := by
  rw [add]

theorem s_add (a b : N) : add (s a) b = s (add a b) := by
  rw [add]

/-- 오른쪽 항등원: add n z = n. n 에 대한 귀납법. (슬라이드 134) -/
theorem add_z (n : N) : add n z = n := by
  induction n with
  | z =>
      -- 목표: add z z = z
      rw [z_add]
  | s k ih =>
      -- 목표: add (s k) z = s k
      rw [s_add]
      -- 목표: s (add k z) = s k
      rw [ih]

/-- s 와 덧셈의 가환: add a (s b) = s (add a b). a 에 대한 귀납법. (슬라이드 135) -/
theorem add_s (a b : N) : add a (s b) = s (add a b) := by
  induction a with
  | z =>
      -- 목표: add z (s b) = s (add z b)
      rw [z_add, z_add]
  | s k ih =>
      -- 목표: add (s k) (s b) = s (add (s k) b)
      rw [s_add]
      -- 목표: s (add k (s b)) = s (add (s k) b)
      rw [ih]
      -- 목표: s (s (add k b)) = s (add (s k) b)
      rw [s_add]

/-- 덧셈의 교환법칙. a 에 대한 귀납법. (슬라이드 136) -/
theorem add_comm (a b : N) : add a b = add b a := by
  induction a with
  | z =>
      -- 목표: add z b = add b z
      rw [z_add, add_z]
  | s k ih =>
      -- 목표: add (s k) b = add b (s k)
      rw [s_add]
      -- 목표: s (add k b) = add b (s k)
      rw [add_s]
      -- 목표: s (add k b) = s (add b k)
      rw [ih]

/-- 덧셈의 결합법칙. a 에 대한 귀납법. -/
theorem add_assoc (a b c : N) : add (add a b) c = add a (add b c) := by
  induction a with
  | z =>
      -- 목표: add (add z b) c = add z (add b c)
      rw [z_add, z_add]
  | s k ih =>
      -- 목표: add (add (s k) b) c = add (s k) (add b c)
      rw [s_add]
      -- 목표: add (s (add k b)) c = add (s k) (add b c)
      rw [s_add]
      -- 목표: s (add (add k b) c) = add (s k) (add b c)
      rw [s_add]
      -- 목표: s (add (add k b) c) = s (add k (add b c))
      rw [ih]

/-- 좌측 교환. add_assoc 와 add_comm 의 결합으로 얻는다.
    이후 곱셈의 우분배, twice_add 증명에서 사용한다. -/
theorem add_left_comm (a b c : N) : add a (add b c) = add b (add a c) := by
  -- 목표: add a (add b c) = add b (add a c)
  rw [← add_assoc]
  -- 목표: add (add a b) c = add b (add a c)
  rw [add_comm a b]
  -- 목표: add (add b a) c = add b (add a c)
  rw [add_assoc]

end N

/-============================================================================
  Part 2. 곱셈의 대수, mul_s 보조정리
============================================================================-/

namespace N

/-- 곱셈의 재귀 정의. 첫 인자에 대한 패턴 매칭이다.
    `mul.eq_1 : mul z b = z`, `mul.eq_2 : mul (s a) b = add (mul a b) b`. -/
def mul : N -> N -> N
  | z, _ => z
  | s a, b => add (mul a b) b

/-- 정의 등식의 별칭. -/
theorem z_mul (b : N) : mul z b = z := by
  rw [mul]

theorem s_mul (a b : N) : mul (s a) b = add (mul a b) b := by
  rw [mul]

/-- 오른쪽이 z 이면 곱은 z. n 에 대한 귀납법. -/
theorem mul_z (n : N) : mul n z = z := by
  induction n with
  | z =>
      -- 목표: mul z z = z
      rw [z_mul]
  | s k ih =>
      -- 목표: mul (s k) z = z
      rw [s_mul]
      -- 목표: add (mul k z) z = z
      rw [ih]
      -- 목표: add z z = z
      rw [z_add]

/-- 우 분배: mul a (s b) = add (mul a b) a. a 에 대한 귀납법.
    `tri_step`, `square_step` 의 핵심 보조정리이다.

    귀납 단계의 핵심은 마지막 다섯 줄의 재배열에 있다:
      add (add (mul k b) k) (s b) = add (add (mul k b) b) (s k)
    양변의 s 를 빼내고 (add_s 두 번), 안쪽에서 k 와 b 를 교환하면 양변이 일치한다. -/
theorem mul_s (a b : N) : mul a (s b) = add (mul a b) a := by
  induction a with
  | z =>
      -- 목표: mul z (s b) = add (mul z b) z
      rw [z_mul]
      -- 목표: z = add (mul z b) z
      rw [z_mul]
      -- 목표: z = add z z
      rw [z_add]
  | s k ih =>
      -- 목표: mul (s k) (s b) = add (mul (s k) b) (s k)
      rw [s_mul]
      -- 목표: add (mul k (s b)) (s b) = add (mul (s k) b) (s k)
      rw [ih]
      -- 목표: add (add (mul k b) k) (s b) = add (mul (s k) b) (s k)
      rw [s_mul]
      -- 목표: add (add (mul k b) k) (s b) = add (add (mul k b) b) (s k)
      rw [add_s]
      -- 목표: s (add (add (mul k b) k) b) = add (add (mul k b) b) (s k)
      rw [add_s]
      -- 목표: s (add (add (mul k b) k) b) = s (add (add (mul k b) b) k)
      rw [add_assoc]
      -- 목표: s (add (mul k b) (add k b)) = s (add (add (mul k b) b) k)
      rw [add_comm k b]
      -- 목표: s (add (mul k b) (add b k)) = s (add (add (mul k b) b) k)
      rw [← add_assoc]

/-- 곱셈의 좌 분배: mul (add a b) c = add (mul a c) (mul b c). a 에 대한 귀납법.
    슬라이드 본문에는 없으나 mul_comm 의 우 측면 증명을 깔끔히 해 주므로 둔다. -/
theorem add_mul (a b c : N) : mul (add a b) c = add (mul a c) (mul b c) := by
  induction a with
  | z =>
      -- 목표: mul (add z b) c = add (mul z c) (mul b c)
      rw [z_add]
      -- 목표: mul b c = add (mul z c) (mul b c)
      rw [z_mul]
      -- 목표: mul b c = add z (mul b c)
      rw [z_add]
  | s k ih =>
      -- 목표: mul (add (s k) b) c = add (mul (s k) c) (mul b c)
      rw [s_add]
      -- 목표: mul (s (add k b)) c = add (mul (s k) c) (mul b c)
      rw [s_mul]
      -- 목표: add (mul (add k b) c) c = add (mul (s k) c) (mul b c)
      rw [ih]
      -- 목표: add (add (mul k c) (mul b c)) c = add (mul (s k) c) (mul b c)
      rw [s_mul]
      -- 목표: add (add (mul k c) (mul b c)) c = add (add (mul k c) c) (mul b c)
      rw [add_assoc]
      -- 목표: add (mul k c) (add (mul b c) c) = add (add (mul k c) c) (mul b c)
      rw [add_assoc]
      -- 목표: add (mul k c) (add (mul b c) c) = add (mul k c) (add c (mul b c))
      rw [add_comm (mul b c) c]

end N

/-============================================================================
  Part 3. twice 함수와 twice_add
============================================================================-/

namespace N

/-- 두배 함수: twice n = n + n. 정의로부터 곧바로 등식 `twice n = add n n` 이 따라온다. -/
def twice (n : N) : N := add n n

/-- twice 가 덧셈 위에서 분배된다: twice (a + b) = twice a + twice b.
    rw 사슬 8단계로 양변을 일치시킨다.

    핵심 아이디어: (a + b) + (a + b) 의 두 번째 b 를 첫 번째 a 와 자리 바꿈하면
    (a + a) + (b + b) 가 된다. 결합법칙과 교환법칙을 정확히 한 번씩만 호출한다. -/
theorem twice_add (a b : N) : twice (add a b) = add (twice a) (twice b) := by
  -- 목표: twice (add a b) = add (twice a) (twice b)
  rw [twice]
  -- 목표: add (add a b) (add a b) = add (twice a) (twice b)
  rw [twice]
  -- 목표: add (add a b) (add a b) = add (add a a) (twice b)
  rw [twice]
  -- 목표: add (add a b) (add a b) = add (add a a) (add b b)
  rw [add_assoc]
  -- 목표: add a (add b (add a b)) = add (add a a) (add b b)
  rw [← add_assoc b a b]
  -- 목표: add a (add (add b a) b) = add (add a a) (add b b)
  rw [add_comm b a]
  -- 목표: add a (add (add a b) b) = add (add a a) (add b b)
  rw [add_assoc]
  -- 목표: add a (add a (add b b)) = add (add a a) (add b b)
  rw [← add_assoc]

end N

/-============================================================================
  Part 4. sumTo, tri_step, sum_formula_twice
  (슬라이드 30, 33)

  명제: 2 * (1 + 2 + ... + n) = n * (n + 1)
  N 위에서 twice 형태로 진술하여 ℕ 의 뺄셈 / 분수를 피한다.
============================================================================-/

namespace N

/-- sumTo n = 0 + 1 + ... + n. n 에 대한 재귀. (슬라이드 30) -/
def sumTo : N -> N
  | z => z
  | s n => add (sumTo n) (s n)

/-- 핵심 보조정리: 손증명의 통분-인수분해 한 줄과 정확히 대응한다.
    k * (k + 1) + 2 * (k + 1) = (k + 1) * (k + 2).

    rw 6단계로 양변을 동일 표준형 `((mul k k + k) + (s k)) + (s k)` 로 맞춘다. -/
theorem tri_step (k : N) :
    add (mul k (s k)) (twice (s k)) = mul (s k) (s (s k)) := by
  -- 목표: add (mul k (s k)) (twice (s k)) = mul (s k) (s (s k))
  rw [mul_s]
  -- 목표: add (add (mul k k) k) (twice (s k)) = mul (s k) (s (s k))
  rw [twice]
  -- 목표: add (add (mul k k) k) (add (s k) (s k)) = mul (s k) (s (s k))
  rw [mul_s]
  -- 목표: add (add (mul k k) k) (add (s k) (s k)) = add (mul (s k) (s k)) (s k)
  rw [mul_s]
  -- 목표: add (add (mul k k) k) (add (s k) (s k)) = add (add (mul (s k) k) (s k)) (s k)
  rw [s_mul]
  -- 목표: add (add (mul k k) k) (add (s k) (s k)) = add (add (add (mul k k) k) (s k)) (s k)
  rw [← add_assoc]

/-- 합 공식 (twice 형). 슬라이드 33 의 자연어 증명과 1대1 대응한다.
    구조적 귀납법 + tri_step + twice_add 만으로 닫힌다. -/
theorem sum_formula_twice (n : N) : twice (sumTo n) = mul n (s n) := by
  induction n with
  | z =>
      -- 목표: twice (sumTo z) = mul z (s z)
      rw [sumTo]
      -- 목표: twice z = mul z (s z)
      rw [twice]
      -- 목표: add z z = mul z (s z)
      rw [z_add]
      -- 목표: z = mul z (s z)
      rw [z_mul]
  | s k ih =>
      -- 목표: twice (sumTo (s k)) = mul (s k) (s (s k))
      rw [sumTo]
      -- 목표: twice (add (sumTo k) (s k)) = mul (s k) (s (s k))
      rw [twice_add]
      -- 목표: add (twice (sumTo k)) (twice (s k)) = mul (s k) (s (s k))
      rw [ih]
      -- 목표: add (mul k (s k)) (twice (s k)) = mul (s k) (s (s k))
      rw [tri_step]

end N

/-============================================================================
  Part 5. odd, oddSum, square_step, odd_sum_eq_sq
  (슬라이드 48-49)

  명제: 1 + 3 + 5 + ... + (2n - 1) = n^2
  N 위에서 진술한다.
============================================================================-/

namespace N

/-- odd n = 2n + 1. 작은 값을 확인하면 odd 0 = 1, odd 1 = 3, odd 2 = 5. -/
def odd : N -> N
  | z => s z
  | s n => s (s (odd n))

/-- 핵심 보조정리: odd k = k + (k + 1). k 에 대한 귀납법.
    이 식은 odd 의 닫힌 표현이며 square_step 의 출발점이 된다. -/
theorem odd_eq (k : N) : odd k = add k (s k) := by
  induction k with
  | z =>
      -- 목표: odd z = add z (s z)
      rw [odd]
      -- 목표: s z = add z (s z)
      rw [z_add]
  | s n ih =>
      -- 목표: odd (s n) = add (s n) (s (s n))
      rw [odd]
      -- 목표: s (s (odd n)) = add (s n) (s (s n))
      rw [ih]
      -- 목표: s (s (add n (s n))) = add (s n) (s (s n))
      rw [s_add]
      -- 목표: s (s (add n (s n))) = s (add n (s (s n)))
      -- RHS 안쪽의 add n (s (s n)) 만 매치되도록 인스턴스를 명시한다.
      rw [add_s n (s n)]
      -- 목표: s (s (add n (s n))) = s (s (add n (s n)))

/-- oddSum n = odd 0 + odd 1 + ... + odd (n-1). (슬라이드 48) -/
def oddSum : N -> N
  | z => z
  | s n => add (oddSum n) (odd n)

/-- 핵심 보조정리: k^2 + (2k + 1) = (k + 1)^2 에 대응한다.
    rw 4단계로 양변을 동일 표준형 `(mul k k + k) + (s k)` 로 맞춘다. -/
theorem square_step (k : N) :
    add (mul k k) (odd k) = mul (s k) (s k) := by
  -- 목표: add (mul k k) (odd k) = mul (s k) (s k)
  rw [odd_eq]
  -- 목표: add (mul k k) (add k (s k)) = mul (s k) (s k)
  rw [s_mul]
  -- 목표: add (mul k k) (add k (s k)) = add (mul k (s k)) (s k)
  rw [mul_s]
  -- 목표: add (mul k k) (add k (s k)) = add (add (mul k k) k) (s k)
  rw [← add_assoc]

/-- 홀수 합 공식. 슬라이드 49 의 자연어 증명에 1대1 대응한다.
    n 에 대한 구조적 귀납법으로 닫는다. -/
theorem odd_sum_eq_sq (n : N) : oddSum n = mul n n := by
  induction n with
  | z =>
      -- 목표: oddSum z = mul z z
      rw [oddSum]
      -- 목표: z = mul z z
      rw [z_mul]
  | s k ih =>
      -- 목표: oddSum (s k) = mul (s k) (s k)
      rw [oddSum]
      -- 목표: add (oddSum k) (odd k) = mul (s k) (s k)
      rw [ih]
      -- 목표: add (mul k k) (odd k) = mul (s k) (s k)
      rw [square_step]

end N

/-============================================================================
  Part 6. 표준 ℕ 에서의 합, 홀수 합, 등비 합
  (슬라이드 21-58)

  같은 결과를 Mathlib 의 표준 자연수 위에서 다시 증명한다.
  ring 과 linear_combination 은 본격적 자동화가 아니라 다항 항등식의 폐쇄에 한정한다.
  각 정리는 `have` 절로 핵심 변형을 명시한다.
============================================================================-/

/-- 1 + 2 + ... + n 의 재귀 정의. -/
def sumNat : ℕ -> ℕ
  | 0 => 0
  | n + 1 => sumNat n + (n + 1)

/-- 합 공식의 분수 회피형: 2 * (1+2+...+n) = n * (n+1). -/
theorem two_mul_sumNat (n : ℕ) : 2 * sumNat n = n * (n + 1) := by
  induction n with
  | zero =>
      -- 목표: 2 * sumNat 0 = 0 * (0 + 1)
      rw [sumNat]
      -- 목표: 2 * 0 = 0 * (0 + 1)
      -- 양변 모두 0 이므로 정의적으로 일치
  | succ k ih =>
      -- 목표: 2 * sumNat (k + 1) = (k + 1) * ((k + 1) + 1)
      rw [sumNat]
      -- 목표: 2 * (sumNat k + (k + 1)) = (k + 1) * (k + 1 + 1)
      -- 좌변 분배
      have distrib : 2 * (sumNat k + (k + 1)) = 2 * sumNat k + 2 * (k + 1) := by ring
      rw [distrib]
      -- 목표: 2 * sumNat k + 2 * (k + 1) = (k + 1) * (k + 1 + 1)
      -- 귀납가정 대입
      rw [ih]
      -- 목표: k * (k + 1) + 2 * (k + 1) = (k + 1) * (k + 1 + 1)
      -- (k + 2) * (k + 1) = k * (k + 1) + 2 * (k + 1) 로 인수분해
      ring

/-- 1 + 3 + ... + (2n - 1) 의 재귀 정의. -/
def oddSumNat : ℕ -> ℕ
  | 0 => 0
  | n + 1 => oddSumNat n + (2 * n + 1)

/-- 홀수 합 공식: oddSumNat n = n^2. -/
theorem oddSumNat_eq_sq (n : ℕ) : oddSumNat n = n ^ 2 := by
  induction n with
  | zero =>
      -- 목표: oddSumNat 0 = 0 ^ 2, 즉 0 = 0
      decide
  | succ k ih =>
      -- 목표: oddSumNat (k + 1) = (k + 1) ^ 2
      rw [oddSumNat]
      -- 목표: oddSumNat k + (2 * k + 1) = (k + 1) ^ 2
      rw [ih]
      -- 목표: k ^ 2 + (2 * k + 1) = (k + 1) ^ 2
      -- 항등식: (k + 1)^2 = k^2 + 2k + 1
      ring

/-- 1 + 2 + 4 + ... + 2^n 의 재귀 정의. -/
def geomSum : ℕ -> ℕ
  | 0 => 1
  | n + 1 => geomSum n + 2 ^ (n + 1)

/-- 등비 합 공식의 음수 회피형: geomSum n + 1 = 2^(n+1).
    원형은 1 + 2 + ... + 2^n = 2^(n+1) - 1 이지만 ℕ 의 뺄셈 정의 문제를 피한다. -/
theorem geomSum_succ (n : ℕ) : geomSum n + 1 = 2 ^ (n + 1) := by
  induction n with
  | zero =>
      -- 목표: geomSum 0 + 1 = 2 ^ (0 + 1), 즉 1 + 1 = 2
      decide
  | succ k ih =>
      -- 목표: geomSum (k + 1) + 1 = 2 ^ (k + 1 + 1)
      rw [geomSum]
      -- 목표: geomSum k + 2 ^ (k + 1) + 1 = 2 ^ (k + 1 + 1)
      -- 결합법칙으로 (geomSum k + 1) 를 묶는다.
      have rearrange :
          geomSum k + 2 ^ (k + 1) + 1 = (geomSum k + 1) + 2 ^ (k + 1) := by ring
      rw [rearrange]
      -- 목표: (geomSum k + 1) + 2 ^ (k + 1) = 2 ^ (k + 1 + 1)
      rw [ih]
      -- 목표: 2 ^ (k + 1) + 2 ^ (k + 1) = 2 ^ (k + 1 + 1)
      -- 2 * 2^(k+1) = 2^(k+2)
      ring

/-============================================================================
  Part 7. 배수성 정리 3 | n^3 - n
  (슬라이드 59-63)

  ℕ 의 뺄셈 정의 문제를 피하기 위해 ℤ 로 들어 올려 진술한다.
  귀납 단계의 핵심 식별식은
    (k+1)^3 - (k+1) = (k^3 - k) + 3 * (k^2 + k)
  이며 ring 으로 마무리한다.
============================================================================-/

/-- 모든 자연수 n 에 대해 3 은 n^3 - n 을 나눈다. -/
theorem three_dvd_cube_sub_self (n : ℕ) :
    (3 : ℤ) ∣ ((n : ℤ) ^ 3 - (n : ℤ)) := by
  induction n with
  | zero =>
      -- 목표: 3 ∣ (0:ℤ)^3 - 0
      refine ⟨0, ?_⟩
      -- 목표: ((0:ℕ):ℤ)^3 - ((0:ℕ):ℤ) = 3 * 0, 양변 모두 0 이다.
      norm_num
  | succ k ih =>
      -- 목표: 3 ∣ ((k+1):ℤ)^3 - (k+1)
      -- 귀납가정에서 m 을 끄집어낸다.
      obtain ⟨m, hm⟩ := ih
      -- hm : (k:ℤ)^3 - (k:ℤ) = 3 * m
      -- 새 증인은 m + k^2 + k
      refine ⟨m + (k : ℤ) ^ 2 + (k : ℤ), ?_⟩
      -- 목표: ((k+1):ℤ)^3 - (k+1) = 3 * (m + k^2 + k)
      push_cast
      -- 목표: ((k:ℤ)+1)^3 - ((k:ℤ)+1) = 3 * (m + (k:ℤ)^2 + (k:ℤ))
      -- 좌변을 (k^3 - k) + 3 * (k^2 + k) 로 분해
      have expand :
          ((k : ℤ) + 1) ^ 3 - ((k : ℤ) + 1)
            = ((k : ℤ) ^ 3 - (k : ℤ)) + 3 * ((k : ℤ) ^ 2 + (k : ℤ)) := by
        ring
      rw [expand]
      -- 목표: ((k:ℤ)^3 - k) + 3 * (k^2 + k) = 3 * (m + k^2 + k)
      -- 귀납가정 대입
      rw [hm]
      -- 목표: 3 * m + 3 * (k^2 + k) = 3 * (m + k^2 + k)
      ring

/-============================================================================
  Part 8. 부등식 n + 1 ≤ 2^n
  (슬라이드 70-72)
============================================================================-/

/-- 모든 자연수 n 에 대해 n + 1 ≤ 2^n.
    귀납 단계에서 2^(k+1) = 2^k + 2^k 라는 분해와
    ih : k + 1 ≤ 2^k, 그리고 1 ≤ 2^k 만으로 결론을 얻는다. -/
theorem succ_le_pow_two (n : ℕ) : n + 1 ≤ 2 ^ n := by
  induction n with
  | zero =>
      -- 목표: 0 + 1 ≤ 2 ^ 0, 즉 1 ≤ 1
      decide
  | succ k ih =>
      -- 목표: (k + 1) + 1 ≤ 2 ^ (k + 1)
      -- 분해: 2^(k+1) = 2^k + 2^k
      have expand : (2 : ℕ) ^ (k + 1) = 2 ^ k + 2 ^ k := by ring
      -- 양의 사실: 1 ≤ 2^k
      have pow_pos : (1 : ℕ) ≤ 2 ^ k := by
        have h : 0 < (2 : ℕ) ^ k := by positivity
        omega
      -- 계산 사슬
      calc (k + 1) + 1
          ≤ 2 ^ k + 1       := by omega
        _ ≤ 2 ^ k + 2 ^ k   := by omega
        _ = 2 ^ (k + 1)     := expand.symm

/-============================================================================
  Part 9. 강귀납 보조 원리 strongInd
  (슬라이드 90-110, 113-120 의 공용 도구)

  Mathlib 이름에 의존하지 않도록 직접 구현한다.
============================================================================-/

/-- 강귀납 원리: 모든 자연수 n 에 대해 P n 이 성립함을 보이려면,
    각 n 에 대해 ∀ m < n, P m 으로부터 P n 을 보이면 충분하다. -/
private theorem strongInd {P : ℕ -> Prop}
    (H : ∀ n, (∀ m, m < n -> P m) -> P n) : ∀ n, P n := by
  -- 보조 사실: ∀ n m, m < n -> P m. n 에 대한 일반 귀납법.
  have aux : ∀ n m, m < n -> P m := by
    intro n
    induction n with
    | zero =>
        -- m < 0 은 ℕ 에서 불가능 (모순으로부터 임의의 명제 도출)
        intro m hm
        omega
    | succ k ih =>
        intro m hm
        -- hm : m < k + 1
        -- m < k 인 경우와 m = k 인 경우로 나눈다.
        by_cases hmk : m < k
        · -- m < k 이면 ih 가 곧바로 적용된다.
          exact ih m hmk
        · -- 그 외에는 m = k 이며, H k 와 ih 로 P k 를 얻는다.
          have hmek : m = k := by omega
          rw [hmek]
          exact H k ih
  -- 본 정리는 aux 의 직접 적용
  intro n
  exact H n (aux n)

/-============================================================================
  Part 10. 우표 문제 (강귀납법)
  (슬라이드 113-120)

  주장: 12 센트 이상의 모든 우편 요금은 4 센트 우표와 5 센트 우표만으로 지불 가능하다.
  즉 n ≥ 12 이면 자연수 a, b 가 존재하여 n = 4a + 5b.
============================================================================-/

/-- 우표 문제. -/
theorem postage (n : ℕ) (h : 12 ≤ n) :
    ∃ a b : ℕ, n = 4 * a + 5 * b := by
  -- 강귀납으로 강화한 진술을 먼저 증명한다.
  have key : ∀ n, 12 ≤ n -> ∃ a b : ℕ, n = 4 * a + 5 * b := by
    apply strongInd (P := fun n => 12 ≤ n -> ∃ a b : ℕ, n = 4 * a + 5 * b)
    intro n ih h12
    by_cases h16 : 16 ≤ n
    · -- 귀납 단계: n ≥ 16 이면 n - 4 ≥ 12 이고 n - 4 < n.
      have h4 : 12 ≤ n - 4 := by omega
      have hlt : n - 4 < n := by omega
      -- ih 적용
      obtain ⟨a, b, hab⟩ := ih (n - 4) hlt h4
      -- hab : n - 4 = 4 * a + 5 * b
      -- 새 증인 (a + 1, b)
      refine ⟨a + 1, b, ?_⟩
      -- 목표: n = 4 * (a + 1) + 5 * b. n = (n - 4) + 4 와 hab 로 omega 가 마무리.
      omega
    · -- 기저 구간: n ∈ {12, 13, 14, 15}.
      interval_cases n
      · exact ⟨3, 0, by norm_num⟩   -- 12 = 4*3
      · exact ⟨2, 1, by norm_num⟩   -- 13 = 4*2 + 5
      · exact ⟨1, 2, by norm_num⟩   -- 14 = 4 + 5*2
      · exact ⟨0, 3, by norm_num⟩   -- 15 = 5*3
  exact key n h

/-============================================================================
  Part 11. 소인수분해 존재
  (슬라이드 99-110)

  Mathlib 의 Nat.primeFactorsList 가 정확히 우리가 원하는 구성 자체이다.
  존재성의 본문은 두 조건의 검증으로 환원된다.
============================================================================-/

/-- 모든 n ≥ 2 는 소수들의 곱으로 표현된다. -/
theorem prime_factorization_exists (n : ℕ) (h : 2 ≤ n) :
    ∃ l : List ℕ, (∀ p ∈ l, Nat.Prime p) ∧ l.prod = n := by
  -- 증인은 Mathlib 이 이미 제공하는 소인수 리스트
  refine ⟨n.primeFactorsList, ?_, ?_⟩
  · -- 모든 원소가 소수임
    intro p hp
    exact Nat.prime_of_mem_primeFactorsList hp
  · -- 곱이 n 임 (n ≠ 0 임을 omega 로 확인)
    exact Nat.prod_primeFactorsList (by omega : n ≠ 0)

/-============================================================================
  Part 12. 팩토리얼과 피보나치
  (슬라이드 127-128)
============================================================================-/

/-- 팩토리얼: 0! = 1, (n+1)! = (n+1) * n!. -/
def fact : ℕ -> ℕ
  | 0 => 1
  | n + 1 => (n + 1) * fact n

-- 작은 값 검증
example : fact 0 = 1 := rfl
example : fact 1 = 1 := rfl
example : fact 3 = 6 := rfl
example : fact 5 = 120 := rfl

/-- 피보나치: F_0 = 0, F_1 = 1, F_{n+2} = F_n + F_{n+1}. -/
def fib : ℕ -> ℕ
  | 0 => 0
  | 1 => 1
  | n + 2 => fib n + fib (n + 1)

example : fib 0 = 0 := rfl
example : fib 1 = 1 := rfl
example : fib 6 = 8 := rfl
example : fib 10 = 55 := rfl

/-- 피보나치 재귀 관계가 정의 그대로 성립한다. -/
theorem fib_succ_succ (n : ℕ) : fib (n + 2) = fib n + fib (n + 1) := by
  rw [fib]

/-============================================================================
  Part 13. MyList 와 구조적 귀납법
  (슬라이드 142-147)

  명제: length (xs ++ ys) = length xs + length ys
        length (reverse xs) = length xs
============================================================================-/

inductive MyList (alpha : Type) where
  | nil : MyList alpha
  | cons : alpha -> MyList alpha -> MyList alpha
  deriving Repr

namespace MyList

variable {alpha : Type}

/-- 리스트 이어붙이기. -/
def append : MyList alpha -> MyList alpha -> MyList alpha
  | nil, ys => ys
  | cons x xs, ys => cons x (append xs ys)

/-- 리스트 길이. 측정값은 N 타입으로 받아 사용자 정의 자연수와 연결한다. -/
def length : MyList alpha -> N
  | nil => N.z
  | cons _ xs => N.s (length xs)

/-- 뒤에 원소 하나 붙이기. -/
def snoc : MyList alpha -> alpha -> MyList alpha
  | nil, x => cons x nil
  | cons y ys, x => cons y (snoc ys x)

/-- 역순 함수. -/
def reverse : MyList alpha -> MyList alpha
  | nil => nil
  | cons x xs => snoc (reverse xs) x

/-- 핵심 정리: 이어붙인 리스트의 길이는 각각의 길이의 합이다. (슬라이드 145)
    xs 에 대한 구조적 귀납법. -/
theorem length_append (xs ys : MyList alpha) :
    length (append xs ys) = N.add (length xs) (length ys) := by
  induction xs with
  | nil =>
      -- 목표: length (append nil ys) = N.add (length nil) (length ys)
      rw [append]
      -- 목표: length ys = N.add (length nil) (length ys)
      rw [length]
      -- 목표: length ys = N.add N.z (length ys)
      rw [N.z_add]
  | cons x tail ih =>
      -- 목표: length (append (cons x tail) ys)
      --        = N.add (length (cons x tail)) (length ys)
      rw [append]
      -- 목표: length (cons x (append tail ys))
      --        = N.add (length (cons x tail)) (length ys)
      rw [length]
      -- 목표: N.s (length (append tail ys))
      --        = N.add (length (cons x tail)) (length ys)
      rw [length]
      -- 목표: N.s (length (append tail ys)) = N.add (N.s (length tail)) (length ys)
      rw [ih]
      -- 목표: N.s (N.add (length tail) (length ys)) = N.add (N.s (length tail)) (length ys)
      rw [N.s_add]

/-- 뒤에 원소 하나 붙이면 길이가 하나 늘어난다. xs 에 대한 구조적 귀납법. -/
theorem length_snoc (xs : MyList alpha) (x : alpha) :
    length (snoc xs x) = N.s (length xs) := by
  induction xs with
  | nil =>
      -- 목표: length (snoc nil x) = N.s (length nil)
      -- snoc nil x = cons x nil 와 length 의 정의로부터 양변이 정의적으로 일치한다.
      rfl
  | cons y ys ih =>
      -- 목표: length (snoc (cons y ys) x) = N.s (length (cons y ys))
      rw [snoc]
      -- 목표: length (cons y (snoc ys x)) = N.s (length (cons y ys))
      rw [length]
      -- 목표: N.s (length (snoc ys x)) = N.s (length (cons y ys))
      rw [length]
      -- 목표: N.s (length (snoc ys x)) = N.s (N.s (length ys))
      rw [ih]

/-- 역순으로 바꿔도 길이는 같다. (슬라이드 147)
    xs 에 대한 구조적 귀납법. -/
theorem length_reverse (xs : MyList alpha) :
    length (reverse xs) = length xs := by
  induction xs with
  | nil =>
      -- 목표: length (reverse nil) = length nil
      rw [reverse]
  | cons x ys ih =>
      -- 목표: length (reverse (cons x ys)) = length (cons x ys)
      rw [reverse]
      -- 목표: length (snoc (reverse ys) x) = length (cons x ys)
      rw [length_snoc]
      -- 목표: N.s (length (reverse ys)) = length (cons x ys)
      rw [ih]
      -- 목표: N.s (length ys) = length (cons x ys)
      rw [length]

end MyList

/-============================================================================
  Part 14. BTree 와 구조적 귀납법
  (슬라이드 148-154)

  명제: 거울변환을 두 번 적용하면 원래대로 돌아온다.
        완전이진트리의 잎의 개수는 내부노드 개수보다 하나 많다.
============================================================================-/

inductive BTree where
  | leaf : BTree
  | node : BTree -> BTree -> BTree
  deriving Repr

namespace BTree

/-- 좌우를 뒤집는 거울 변환. -/
def mirror : BTree -> BTree
  | leaf => leaf
  | node l r => node (mirror r) (mirror l)

/-- 잎의 개수. -/
def leaves : BTree -> N
  | leaf => N.s N.z
  | node l r => N.add (leaves l) (leaves r)

/-- 내부 노드의 개수. -/
def internal : BTree -> N
  | leaf => N.z
  | node l r => N.s (N.add (internal l) (internal r))

/-- mirror 를 두 번 적용하면 원래 트리. (슬라이드 150)
    t 에 대한 구조적 귀납법. -/
theorem mirror_involutive (t : BTree) : mirror (mirror t) = t := by
  induction t with
  | leaf =>
      -- 목표: mirror (mirror leaf) = leaf
      -- mirror leaf = leaf 의 정의로부터 양변이 정의적으로 일치한다.
      rfl
  | node l r ihl ihr =>
      -- 목표: mirror (mirror (node l r)) = node l r
      rw [mirror]
      -- 목표: mirror (node (mirror r) (mirror l)) = node l r
      rw [mirror]
      -- 목표: node (mirror (mirror l)) (mirror (mirror r)) = node l r
      rw [ihl]
      -- 목표: node l (mirror (mirror r)) = node l r
      rw [ihr]

/-- 완전이진트리에서 leaves = internal + 1. (슬라이드 154)
    t 에 대한 구조적 귀납법. -/
theorem leaves_eq_internal_s (t : BTree) :
    leaves t = N.s (internal t) := by
  induction t with
  | leaf =>
      -- 목표: leaves leaf = N.s (internal leaf)
      -- leaves leaf = N.s N.z 와 internal leaf = N.z 로부터 양변이 정의적으로 일치한다.
      rfl
  | node l r ihl ihr =>
      -- 목표: leaves (node l r) = N.s (internal (node l r))
      rw [leaves]
      -- 목표: N.add (leaves l) (leaves r) = N.s (internal (node l r))
      rw [internal]
      -- 목표: N.add (leaves l) (leaves r) = N.s (N.s (N.add (internal l) (internal r)))
      rw [ihl]
      -- 목표: N.add (N.s (internal l)) (leaves r) = N.s (N.s (N.add (internal l) (internal r)))
      rw [ihr]
      -- 목표: N.add (N.s (internal l)) (N.s (internal r))
      --        = N.s (N.s (N.add (internal l) (internal r)))
      rw [N.s_add]
      -- 목표: N.s (N.add (internal l) (N.s (internal r)))
      --        = N.s (N.s (N.add (internal l) (internal r)))
      rw [N.add_s]

end BTree

/-============================================================================
  Part 15. 재귀 알고리즘
  (슬라이드 160-165)

  팩토리얼은 Part 12 에서 다루었다. 여기서는 유클리드 알고리즘과 이진 탐색.
============================================================================-/

/-- 유클리드 알고리즘은 Lean 코어의 Nat.gcd 와 일치한다. -/
example : Nat.gcd 30 18 = 6 := by decide
example : Nat.gcd 100 75 = 25 := by decide
example : Nat.gcd 12 8 = 4 := by decide
example : Nat.gcd 17 5 = 1 := by decide

/-- 정렬된 리스트에서 이진 탐색.
    종료성을 보장하기 위해 명시적인 fuel 인자를 도입한다.
    fuel 에 대한 자연 재귀이므로 Lean 의 자동 종료 판정이 통과한다. -/
def binSearchAux (xs : List ℕ) (target : ℕ) : ℕ -> ℕ -> ℕ -> Option ℕ
  | _, _, 0 => none
  | lo, hi, fuel + 1 =>
    if lo ≥ hi then none
    else
      let mid := (lo + hi) / 2
      match xs[mid]? with
      | none => none
      | some v =>
          if v = target then some mid
          else if target < v then binSearchAux xs target lo mid fuel
          else binSearchAux xs target (mid + 1) hi fuel

/-- 사용자 친화 인터페이스. -/
def binarySearch (xs : List ℕ) (target : ℕ) : Option ℕ :=
  binSearchAux xs target 0 xs.length (xs.length + 1)

example : binarySearch [1, 3, 5, 7, 9, 11] 7 = some 3 := by decide
example : binarySearch [1, 3, 5, 7, 9, 11] 4 = none := by decide
example : binarySearch [2, 4, 6, 8, 10] 10 = some 4 := by decide

end RosenCh5
