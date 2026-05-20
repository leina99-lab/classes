/-
  ch4_2_lean4_all_code.lean

  로젠 이산수학 §4.2 (정수의 표현과 알고리즘)
  Lean 4 코드 모음 (교수님 검증 필요 상태)

  본 파일은 다음을 다룬다:
    Part A. 자연수의 b진법 표현 (Nat.digits API)
    Part B. 진법 변환 예제 (10진 → 2진, 16진)
    Part C. 모듈러 멱승 (fast exponentiation, Nat.pow + 합동)

  ※ 본 파일의 코드는 컴파일 미검증 상태이다.
     특히 Nat.digits 관련 정리의 이름은 Mathlib 버전에 따라
     다를 수 있으므로 교수님 환경에서 확인이 필요하다.

  ※ §4.2의 핵심 주제 진법 변환은 Lean 4 Mathlib의 Nat.digits API를
     주로 활용한다. 직접 손증명은 §4.1처럼 풍부하지 않다.
-/

import Mathlib
open Nat


-- =========================================================
-- Part A. 자연수의 b진법 표현 (Nat.digits API)
-- =========================================================

-- §4.2 정의: 자연수 n을 b진법으로 표현하면 자릿수 리스트가 나온다.
-- Mathlib의 Nat.digits b n은 n의 b진법 자릿수를 낮은 자리부터 리스트로 반환.
-- 예: Nat.digits 10 1234 = [4, 3, 2, 1] (낮은 자리부터)
--     Nat.digits 2  13   = [1, 0, 1, 1] (2진법, 13 = 1101₂)

-- 시연 1: 10진법 1234의 자릿수
example : Nat.digits 10 1234 = [4, 3, 2, 1] := by decide

-- 시연 2: 2진법으로 변환 — 13 = 1101₂
example : Nat.digits 2 13 = [1, 0, 1, 1] := by decide

-- 시연 3: 16진법 — 255 = FF₁₆ (15, 15가 두 자리)
example : Nat.digits 16 255 = [15, 15] := by decide

-- 시연 4: 8진법 — 64 = 100₈
example : Nat.digits 8 64 = [0, 0, 1] := by decide


-- §4.2 정리(자릿수 복원): 자릿수로부터 원래 수를 복원할 수 있다.
-- Nat.ofDigits b L = L의 자릿수를 b진법으로 합성한 자연수.
-- Mathlib에 Nat.ofDigits_digits라는 이름으로 다음 정리가 있다:
--   ∀ b n, Nat.ofDigits b (Nat.digits b n) = n

theorem digits_round_trip (n : Nat) :
    Nat.ofDigits 10 (Nat.digits 10 n) = n :=
  Nat.ofDigits_digits 10 n

-- 시연: 1234의 자릿수를 다시 합치면 1234
example : Nat.ofDigits 10 [4, 3, 2, 1] = 1234 := by decide


-- §4.2 정리(자릿수 개수): n이 0이 아니면, 10진법 자릿수의 개수는
-- log_10 n에 + 1 한 만큼이다.
-- Mathlib에 Nat.size_digits 또는 (Nat.digits b n).length 관련 정리가 있다.
-- 본 자료에서는 직접 계산으로 확인.

example : (Nat.digits 10 1234).length = 4 := by decide
example : (Nat.digits 10 9).length    = 1 := by decide
example : (Nat.digits 10 10).length   = 2 := by decide
example : (Nat.digits 10 99).length   = 2 := by decide
example : (Nat.digits 10 100).length  = 3 := by decide


-- =========================================================
-- Part B. 진법 변환 예제
-- =========================================================

-- 진법 변환 1: 10진 → 2진 (학생 자료의 핵심 예제)
example : Nat.digits 2 25 = [1, 0, 0, 1, 1] := by decide
-- 25 = 11001₂ = 16 + 8 + 1

example : Nat.digits 2 100 = [0, 0, 1, 0, 0, 1, 1] := by decide
-- 100 = 1100100₂ = 64 + 32 + 4

-- 진법 변환 2: 10진 → 16진
example : Nat.digits 16 255  = [15, 15] := by decide
example : Nat.digits 16 256  = [0, 0, 1] := by decide
example : Nat.digits 16 4095 = [15, 15, 15] := by decide

-- 진법 변환 3: 2진 → 10진 (자릿수 리스트로부터 합성)
example : Nat.ofDigits 2 [1, 0, 0, 1, 1] = 25 := by decide
example : Nat.ofDigits 2 [1, 1, 1, 1, 1, 1, 1, 1] = 255 := by decide

-- 진법 변환 4: 16진 → 10진
example : Nat.ofDigits 16 [10, 11, 12] = 10 + 11 * 16 + 12 * 256 := by
  -- 좌변 Nat.ofDigits 16 [10, 11, 12] = 10 + (11 + 12 * 16) * 16
  --                                   = 10 + 11 * 16 + 12 * 256
  decide

-- 시연: A2C₁₆ = 2604₁₀
-- 0xA2C = 10 * 16^2 + 2 * 16 + 12 = 2560 + 32 + 12 = 2604
-- (자릿수는 낮은 자리부터: [12, 2, 10])
example : Nat.ofDigits 16 [12, 2, 10] = 2604 := by decide


-- =========================================================
-- Part C. 모듈러 멱승 (fast exponentiation)
-- =========================================================

-- §4.2 알고리즘: a^n mod m을 빠르게 계산하는 방법.
-- 핵심 아이디어: n을 2진법으로 표현하고, 비트별로 곱셈을 누적.
-- 예: a^13 = a^(1101₂) = a^8 · a^4 · a^1

-- Mathlib에서는 Nat.pow와 % 연산을 결합한 모듈러 멱승이 직접 지원된다.

-- 시연 1: 3^13 mod 7 = ?
-- 3^13 = 1594323
-- 1594323 mod 7 = ?
-- Lean이 직접 계산해 줌.
example : 3 ^ 13 % 7 = 3 := by decide

-- 시연 2: 페르마 소정리의 검증 (3은 소수가 아닌 11에 대한 일반화 형태)
-- a^(p-1) ≡ 1 (mod p)  (p 소수, gcd(a, p) = 1)
-- 예: 2^10 mod 11 = 1 (페르마 소정리)
example : 2 ^ 10 % 11 = 1 := by decide

-- 시연 3: 더 큰 수의 모듈러 멱승
-- 7^222 mod 11 = ?
-- 페르마 소정리에 의해 7^10 ≡ 1 (mod 11)이므로
-- 7^222 = 7^(22*10 + 2) = (7^10)^22 * 7^2 ≡ 1^22 * 49 ≡ 49 ≡ 5 (mod 11)
example : 7 ^ 222 % 11 = 5 := by decide

-- 시연 4: 빠른 멱승의 직접 구현 패턴 (재귀 호출)
-- 이는 학생들이 직접 작성해 본 후 Mathlib의 Nat.pow와 비교하도록 한다.
--
-- 주의: if-then-else의 분기 조건에 증거 변수(if h : ...)를 두면
-- decide가 환원에 막히므로, 순수 분기(if ...)로 작성한다.

def fastModPow : Nat → Nat → Nat → Nat
  | _,    0,        _ => 1
  | base, exp + 1,  m =>
      if (exp + 1) % 2 = 0 then
        let half := fastModPow base ((exp + 1) / 2) m
        (half * half) % m
      else
        (base * fastModPow base exp m) % m
termination_by _ exp _ => exp

-- 시연: 위에서 본 결과를 fastModPow로도 확인.
-- decide 대신 native_decide를 사용한다. native_decide는 컴파일된 코드로
-- 평가하므로, 재귀 함수의 환원이 stuck되는 문제를 우회한다.
example : fastModPow 3 13 7 = 3 := by native_decide
example : fastModPow 2 10 11 = 1 := by native_decide
example : fastModPow 7 222 11 = 5 := by native_decide


-- =========================================================
-- 마무리 — 본 자료의 주요 Mathlib API 목록
-- =========================================================

/-
  본 자료에서 사용한 Mathlib 정리/정의들:

  ▷ 진법 표현
    Nat.digits b n   : n을 b진법으로 표현한 자릿수 리스트 (낮은 자리부터)
    Nat.ofDigits b L : 자릿수 리스트 L을 b진법으로 합성한 자연수
    Nat.ofDigits_digits : ofDigits b (digits b n) = n

  ▷ 자릿수 개수
    (Nat.digits b n).length : n의 b진법 자릿수 개수
    Nat.size                : 2진법 자릿수 개수 전용

  ▷ 모듈러 산술
    a ^ n % m  : 모듈러 멱승 (Lean 4 기본 연산자로 직접 표현 가능)
    Nat.pow_mod 등 직접 정리도 있으나 본 자료에서는 % 표기를 사용

  ▷ 정리 핵심 형태
    Nat.digits_add_two_add_one : 자릿수 분해 (≥ 2진법에서)
    Nat.digits_lt : 자릿수의 값은 진법 b보다 작음

  ※ Mathlib 버전(2026 현재)에서 위 이름들이 변경되었을 수 있다.
     컴파일 시 오류가 나면 #check로 정확한 이름을 확인한다.
-/
