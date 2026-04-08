# Rosen Chapter 2 -- 블록 2: 2.3 함수 + 2.4 수열과 합

> 수학적 개념을 먼저 이해하고, Lean 4로 정확히 구현하는 흐름으로 구성되었다.

---

# 2.3 함수 (Functions)

---

## 정의 1-2: 함수, 정의역, 공역, 치역

### 정의 1: 함수(Function)

함수 f: A -> B란, A의 원소 각각에 B의 원소를 **단 하나만** 대응시킨 것이다.

| 용어 | 영문 | 설명 |
|------|------|------|
| **정의역**(Domain) | Domain | 입력 집합 A |
| **공역**(Codomain) | Codomain | 출력 가능한 전체 집합 B |
| **치역**(Range/Image) | Range | 실제 출력값의 집합. 치역 ⊆ 공역 |

### 정의 2: 함수의 같음

f = g ⇔ 모든 a에 대해 f(a) = g(a)

### 예제 1-5

- f: Z -> Z, f(x) = x^2. 정의역 Z, 공역 Z, 치역 = {0, 1, 4, 9, ...}
- 치역은 공역의 **부분집합**이다. 치역 = 공역인 경우는 전사 함수이다.

---

## 정의 3-4: 함수 연산 + 예제 6-7

### 함수의 합, 곱

(f + g)(x) = f(x) + g(x)
(fg)(x) = f(x) * g(x)

### 부분집합의 상(Image)

f(S) = {f(s) | s ∈ S}

---

## 2.3.2 단사, 전사, 전단사 함수

이 세 개념은 함수의 가장 중요한 분류이다.

### 정의 5: 단사 함수(Injection, One-to-one)

**서로 다른 입력은 반드시 서로 다른 출력**을 낸다. 충돌이 없다.

> f(a) = f(b) → a = b

### 예제 8-12

| 함수 | 단사? | 이유 |
|------|-------|------|
| f(x) = x + 1 (Z -> Z) | O | x+1 = y+1이면 x = y |
| f(x) = x^2 (Z -> Z) | X | f(1) = f(-1) = 1 (충돌!) |

### 정의 6: 증가/감소 함수

순증가 함수는 항상 단사이다. (x < y이면 f(x) < f(y)이므로 충돌 불가)

---

## 정의 7-8: 전사, 전단사 + 예제 13-18

### 정의 7: 전사 함수(Surjection, Onto)

공역의 **모든 원소**가 누군가의 출력이다.

> 모든 b ∈ B에 대해, 어떤 a ∈ A가 존재하여 f(a) = b

### 정의 8: 전단사 함수(Bijection)

**단사이면서 전사**. 역함수가 존재한다.

### 세 가지 비교

| 성질 | 의미 | 증명 방법 |
|------|------|-----------|
| **단사**(Injection) | 충돌 없음 | f(a)=f(b) 가정 → a=b 유도 |
| **전사**(Surjection) | 빠짐없이 도달 | 임의의 b에 대해 a 제시 |
| **전단사**(Bijection) | 단사 + 전사 | 둘 다 증명 |

### 예제 13-18

| 함수 | 단사 | 전사 | 전단사 |
|------|------|------|--------|
| f(x) = 2x (Z -> Z) | O | X (홀수 없음) | X |
| f(x) = x + 1 (Z -> Z) | O | O | O |
| f(x) = x^2 (Z -> Z) | X | X | X |

---

## [Lean 4] 단사/전사/전단사

### 수학 ↔ Lean 대응표

| 수학 개념 | Lean 4 표현 | 증명 전략 |
|-----------|-------------|-----------|
| 단사: f(a)=f(b) → a=b | `Function.Injective f` | `intro a b h; omega` |
| 전사: ∀b, ∃a, f(a)=b | `Function.Surjective f` | `intro b; use 증인; omega` |
| 전단사: 단사 ∧ 전사 | `Function.Bijective f` | `constructor` 후 각각 증명 |

### 단사 증명: f(n) = n + 1

```lean
-- 단사: f(a) = f(b) → a = b
example : Function.Injective (fun n : Nat => n + 1) := by
  intro a b h     -- h : a + 1 = b + 1
  simp at h
  omega   
```

**정리: simp at 누구?**

|  대상  |  문법  |  언제  | 
|------|----------|----------|
|목표 |simp (그냥)|목표에 람다가 있을 때|
|가설 |hsimp at h|가설에 람다가 있을 때|
|둘 다|simp at h ⊢|양쪽 다 있을 때|
|변수|b불가|b는 값이지 명제가 아니다|


**왜 `intro a b h`인가?** `Function.Injective f`의 정의는 `∀ a b, f a = f b → a = b`이다. 따라서 a, b, h를 도입한다.  

### InfoView 상태 변화

| 단계 | InfoView |
|------|----------|
| 시작 | 목표: `Function.Injective (fun n => n + 1)` |
| `intro a b h` 후 | 가설: `a b : Nat`, `h : a + 1 = b + 1` / 목표: `a = b` |
| `omega` 후 | 증명 완료 |

### 전사 증명: f(n) = n + 1 (Int -> Int)

```lean
-- 전사: ∀ b, ∃ a, f(a) = b
example : Function.Surjective (fun n : Int => n + 1) := by
  intro b          -- b : Int  (임의의 출력값)
  use b - 1        -- 증인: b - 1  (이것이 입력값)
  simp             -- (b-1) + 1 = b  자동!
```

**왜 `use b - 1`인가?** 전사를 보이려면 "이 출력 b를 만드는 입력이 존재한다"를 보여야 한다. `use`로 증인(witness)을 제시한다.

### InfoView 상태 변화

| 단계 | InfoView |
|------|----------|
| 시작 | 목표: `Function.Surjective (fun n => n + 1)` |
| `intro b` 후 | 가설: `b : Int` / 목표: `∃ a, a + 1 = b` |
| `use b - 1` 후 | 목표: `b - 1 + 1 = b` |
| `omega` 후 | 증명 완료 |

### 전단사 증명: f(n) = n + 1 (Int -> Int)

```lean
-- 전단사 = 단사 + 전사
example : Function.Bijective (fun n : Int => n + 1) := by
  constructor
  · intro a b h
    simp at h
    exact h
  · intro b
    use b - 1
    simp
```

**왜 `constructor`인가?** `Bijective f`는 `Injective f ∧ Surjective f`로 정의된다. `constructor`가 ∧를 두 목표로 분리한다.

### 빈칸 채우기

```lean
-- f(x) = 2x 가 Nat -> Nat에서 단사임을 증명하라.
example : Function.Injective (fun n : Nat => 2 * n) := by
  intro a b h
  ______
```

<details>
<summary>정답 보기</summary>

```lean
example : Function.Injective (fun n : Nat => 2 * n) := by
  intro a b h
  simp at h
  omega
```

`h : 2 * a = 2 * b`에서 `omega`가 자동으로 `a = b`를 유도한다.

</details>

---

## 정의 9-10: 역함수, 합성 + 예제 19-25

### 정의 9: 역함수(Inverse)

f: A -> B가 **전단사**일 때, f의 역함수 f^(-1): B -> A가 존재한다.

f^(-1)(b) = a ⇔ f(a) = b

### 정의 10: 합성 함수(Composition)

(f o g)(x) = f(g(x))

> **순서 주의**: "먼저 g, 그 다음 f". f o g != g o f 일반적으로 성립하지 않는다.

### 예제 19-25

f(x) = 2x + 3, g(x) = 3x + 2일 때:

| 합성 | 계산 | 결과 |
|------|------|------|
| f(g(1)) | f(3x1+2) = f(5) = 2x5+3 | **13** |
| g(f(1)) | g(2x1+3) = g(5) = 3x5+2 | **17** |

f(g(1)) != g(f(1)) -- 합성 순서가 중요하다!

```lean
-- Lean 4: 합성
def ff (x : Int) := 2 * x + 3
def gg (x : Int) := 3 * x + 2
#eval ff (gg 1)   -- f(g(1)) = f(5) = 13
#eval gg (ff 1)   -- g(f(1)) = g(5) = 17  (같지 않다!)
```

---

## 정의 12: 바닥/천정 함수 + 예제 28-32

### 바닥 함수(Floor)

floor(x) = x 이하의 가장 큰 정수

### 천정 함수(Ceiling)

ceil(x) = x 이상의 가장 작은 정수

| x | floor(x) | ceil(x) |
|---|----------|---------|
| 3.7 | 3 | 4 |
| -3.7 | -4 | -3 |
| 7.0 | 7 | 7 |

### 핵심 성질

floor(x) <= x < floor(x) + 1
ceil(x) - 1 < x <= ceil(x)

**응용**: 100비트 데이터를 8비트 바이트로 나누면 ceil(100/8) = 13바이트.

---

## 예제 33-34: 계승 함수, 부분 함수

### 계승(Factorial)

n! = n * (n-1) * ... * 2 * 1, 0! = 1

```lean
-- Lean 4: 계승
#eval Nat.factorial 6     -- 720
#eval Nat.factorial 20    -- 2432902008176640000
```

### 빈칸 채우기

```lean
-- 10! = ?
#eval Nat.factorial 10
-- 기대: ______
```

<details>
<summary>정답 보기</summary>

답: **3628800**

</details>

### 정의 13: 부분 함수(Partial Function)

정의역의 **부분집합**에서만 정의된 함수. 예: sqrt(n)은 음이 아닌 정수에서만 정의.

---

## [학생 활동] 2.3 함수 종합 연습 (5분)

**1.** f: Z -> Z에서 다음 함수의 단사/전사/전단사를 판별하라:

| 함수 | 단사 | 전사 | 전단사 |
|------|------|------|--------|
| (a) f(x) = 2x | ______ | ______ | ______ |
| (b) f(x) = x^3 | ______ | ______ | ______ |
| (c) f(x) = x^2 | ______ | ______ | ______ |

**2.** f(x) = 2x+3, g(x) = 3x+2일 때

(f o g)(1) = ______,  (g o f)(1) = ______

**3.** floor(3.7) + ceil(-3.7) = ______

**4.** [Lean 4] f(x) = x^2이 Int -> Int에서 단사가 아님을 증명하라:

```lean
example : ¬ Function.Injective (fun n : Int => n^2) := by
  intro h
  ______
```

<details>
<summary>전체 정답 보기</summary>

**1.**
(a) 단사 O, 전사 X (홀수 없음), 전단사 X
(b) R->R이면 단사 O, 전사 O, 전단사 O. Z->Z이면 단사 O, 전사 X
(c) 단사 X (f(1)=f(-1)), 전사 X (음수 없음)

**2.** f(g(1)) = f(5) = 13, g(f(1)) = g(5) = 17

**3.** 3 + (-3) = **0**

**4.**
```lean
example : ¬ Function.Injective (fun n : Int => n^2) := by
  intro h
  exact absurd (h (by norm_num : (1:Int)^2 = (-1:Int)^2)) (by norm_num)
```

`h`는 "f가 단사이다"라는 가정이다. `(1)^2 = (-1)^2`을 `h`에 적용하면 `1 = -1`이라는 결론이 나오고, 이는 `norm_num`으로 모순임을 보인다.

</details>

---
## norm_num -- 구체적 수치 계산기

`norm_num`은 **구체적인 숫자가 포함된 식**을 계산하여 참/거짓을 판정하는 전술이다.

### 한 마디로

```
사람이 계산기를 두드리면 바로 알 수 있는 것 → norm_num
```

---

### 할 수 있는 것

```lean
-- 등식
example : 2 + 3 = 5 := by norm_num
example : 2^10 = 1024 := by norm_num

-- 부등식
example : 3 < 7 := by norm_num
example : 100 ≥ 99 := by norm_num

-- 부정
example : 2 + 2 ≠ 5 := by norm_num
example : ¬(3 = 7) := by norm_num

-- 나눗셈, 나머지
example : 10 % 3 = 1 := by norm_num
example : 10 / 3 = 3 := by norm_num

-- 소수 판정
example : Nat.Prime 7 := by norm_num
example : ¬ Nat.Prime 4 := by norm_num
```

### 할 수 없는 것

```lean
-- 변수가 포함된 식 → omega 또는 ring
example (n : Nat) : n + 0 = n := by norm_num      -- 실패!
example (a b : Int) : a + b = b + a := by norm_num -- 실패!
```

변수가 들어가면 "계산기로 두드릴 수 없다". 그때는 다른 전술이 필요하다.

---

### omega, ring, simp와 비교

| 전술 | 영역 | 예시 |
|------|------|------|
| `norm_num` | 구체적 숫자 계산 | `2^10 = 1024`, `Nat.Prime 7` |
| `omega` | 변수 포함 선형 산술 | `n + 1 > n`, `a + 1 = b + 1 → a = b` |
| `ring` | 대수 등식(다항식) | `(a+b)^2 = a^2 + 2*a*b + b^2` |
| `simp` | 식 단순화 + 정의 펼치기 | 람다 축약, 집합 멤버십 |

---

### 실전에서 자주 쓰는 패턴

```lean
-- 1. 반례 제시할 때 (단사가 아님 증명)
example : ¬ Function.Injective (fun n : Int => n^2) := by
  intro h
  have := h (show (1:Int)^2 = (-1:Int)^2 by norm_num)
  norm_num at this

-- 2. simp와 조합
example : (3 : Nat) ∈ {n : Nat | n > 2} := by
  simp        -- 목표: 3 > 2
  norm_num    -- 계산으로 확인

-- 3. omega가 안 되는 거듭제곱
example : 2^8 = 256 := by norm_num    -- omega는 거듭제곱 못 함
```

---

### 판단 기준

```
목표에 변수가 없고 숫자만 있는가?
    ├── 예 → norm_num
    └── 아니오
         ├── 선형 산술(+, -, <, =) → omega
         ├── 다항식 등식 → ring
         └── 정의 펼치기 필요 → simp
```
---
요약하면, `norm_num`은 "계산기"이다. 숫자만 있으면 두드려서 답을 내고, 변수가 있으면 손을 놓는다.  


# 2.4 수열과 수열의 합 (Sequences and Sums)

---

## 정의 1-3: 수열, 등비, 등차 + 예제 1-4

### 정의 1: 수열(Sequence)

수열이란 정수 집합의 부분집합에서 정의된 **함수**이다.

a_n은 함수값 a(n)의 다른 표기법이다.

### 정의 2: 등비수열(Geometric Progression)

a, ar, ar^2, ar^3, ...

초항 a, 공비 r

### 정의 3: 등차수열(Arithmetic Progression)

a, a+d, a+2d, a+3d, ...

초항 a, 공차 d

### 예제 1-4

| 수열 | 종류 | 초항 | 공비/공차 |
|------|------|------|----------|
| {1, 2, 4, 8, 16, ...} | 등비 | 1 | r = 2 |
| {-1, 3, 7, 11, 15, ...} | 등차 | -1 | d = 4 |

```lean
-- Lean 4: 등차수열
def arith (n : Nat) : Int := -1 + 4 * n
#eval (List.range 6).map arith  -- [-1, 3, 7, 11, 15, 19]
```

---

## 정의 4-5: 점화 관계 + 피보나치 + 예제 5-9

### 정의 4: 점화 관계(Recurrence Relation)

a_n을 이전 항들로 정의하는 관계.

### 피보나치 수열

f_0 = 0, f_1 = 1, f_n = f_{n-1} + f_{n-2}

> 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...

### 예제 5

a_0 = 2, a_n = a_{n-1} + 3

> 2, 5, 8, 11, 14, 17, ... (초항 2, 공차 3인 등차수열)

---

## [Lean 4] 수열과 점화 관계

Lean 4에서 수열은 **패턴 매칭**으로 자연스럽게 정의한다.

### 피보나치 수열

```lean
-- 피보나치 (패턴 매칭)
def fib : Nat -> Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => fib (n + 1) + fib n

#eval (List.range 10).map fib
-- [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

### 수학 ↔ Lean 대응표

| 수학 정의 | Lean 4 정의 | 설명 |
|-----------|-------------|------|
| f_0 = 0 | `\| 0 => 0` | 기저 사례(base case) |
| f_1 = 1 | `\| 1 => 1` | 기저 사례 |
| f_n = f_{n-1} + f_{n-2} | `\| n+2 => fib (n+1) + fib n` | 재귀 사례 |

**핵심**: Lean의 패턴 매칭은 수학의 점화 관계와 1:1로 대응한다!

### 예제 5: a_0 = 2, a_n = a_{n-1} + 3

```lean
def seq5 : Nat -> Nat
  | 0 => 2
  | n + 1 => seq5 n + 3

#eval (List.range 6).map seq5  -- [2, 5, 8, 11, 14, 17]
```

### 빈칸 채우기

```lean
-- 등비수열: a_0 = 1, a_n = 2 * a_{n-1}
def geomSeq : Nat -> Nat
  | 0 => ______
  | n + 1 => ______

#eval (List.range 8).map geomSeq
-- 기대: [1, 2, 4, 8, 16, 32, 64, 128]
```

<details>
<summary>정답 보기</summary>

```lean
def geomSeq : Nat -> Nat
  | 0 => 1
  | n + 1 => 2 * geomSeq n
```

기저 사례: 초항 1. 재귀 사례: 이전 항의 2배.

</details>

---

## 예제 10-11: 반복법(Iteration)과 복리

### 반복법

점화 관계를 반복 대입하여 **닫힌 공식**(closed formula)을 유도한다.

- 등차수열: a_n = a_0 + nd = 2 + 3n
- 등비수열: a_n = a_0 * r^n

### 복리 계산

연 11%로 10,000달러를 30년 투자:

P_n = 10000 * (1.11)^30

```lean
#eval (1.11 ^ 30 : Float) * 10000  -- 약 228,923
```

---

## 예제 12-16: 특수 정수수열의 일반항 찾기

패턴을 파악하여 일반항 a_n을 찾는 연습이다.

| 수열 | 일반항 |
|------|--------|
| 1, 1/2, 1/3, 1/4, ... | a_n = 1/n |
| 1, 4, 9, 16, ... | a_n = n^2 |
| 1, -1, 1, -1, ... | a_n = (-1)^n |

---

## 2.4.5 수열의 합 (Summation) + 공식표

### 합의 표기법

$$\sum_{i=1}^{n} a_i = a_1 + a_2 + \cdots + a_n$$

### 핵심 공식

| 공식 | 이름 |
|------|------|
| 1 + 2 + ... + n = n(n+1)/2 | 가우스 공식 |
| 1^2 + 2^2 + ... + n^2 = n(n+1)(2n+1)/6 | 제곱의 합 |
| 1^3 + 2^3 + ... + n^3 = [n(n+1)/2]^2 | 세제곱의 합 |
| a + ar + ... + ar^(n-1) = a(r^n - 1)/(r - 1) | 등비급수 |

```lean
-- Lean 4: 합 계산
#eval (List.range 100).map (· + 1) |>.foldl (· + ·) 0
-- 5050 = 100*101/2  (가우스 공식!)
```

---

## 예제 17-23: 합 계산

### 빈칸 채우기

```lean
-- 1^2 + 2^2 + ... + 10^2 = ?
#eval (List.range 10).map (fun k => (k+1)^2) |>.foldl (· + ·) 0
-- 기대: ______  (= 10*11*21/6)
```

<details>
<summary>정답 보기</summary>

답: **385** (= 10 * 11 * 21 / 6)

</details>

---
## Lean 4 코드 해부: 1부터 100까지의 합

```lean
#eval (List.range 100).map (· + 1) |>.foldl (· + ·) 0
-- 5050
```

1부터 100까지의 합을 구하는 코드이다. 하나씩 뜯어 보겠다.

### 전체 흐름

```
List.range 100  →  .map (· + 1)  →  foldl (· + ·) 0
    [0~99]           [1~100]          전부 더함 = 5050
```

---

### 1단계: `List.range 100`

```lean
#eval List.range 100
-- [0, 1, 2, 3, ..., 99]
```

0부터 99까지 100개의 자연수 리스트를 만든다.

---

### 2단계: `.map (· + 1)`

```lean
#eval (List.range 100).map (· + 1)
-- [1, 2, 3, 4, ..., 100]
```

`map`은 리스트의 **각 원소에 함수를 적용**한다. `(· + 1)`은 `(fun n => n + 1)`의 축약 표기이다. 모든 원소에 1을 더하므로 [0~99]가 [1~100]이 된다.

---

### 3단계: `|>.foldl (· + ·) 0`

```lean
#eval [1, 2, 3, 4, ..., 100].foldl (· + ·) 0
-- 0 + 1 + 2 + 3 + ... + 100 = 5050
```

`foldl`은 리스트를 **왼쪽부터 접어서** 하나의 값으로 만든다.

```
foldl (· + ·) 0 [1, 2, 3, ...]

  초기값: 0
  0 + 1 = 1
  1 + 2 = 3
  3 + 3 = 6
  6 + 4 = 10
  ...
  4950 + 100 = 5050
```

`(· + ·)`는 `(fun a b => a + b)`의 축약이다. 두 인자를 더하는 함수이다.

---

### `|>` 파이프 연산자

```lean
-- 이 둘은 같다:
(List.range 100).map (· + 1) |>.foldl (· + ·) 0
((List.range 100).map (· + 1)).foldl (· + ·) 0
```

`|>`는 "왼쪽 결과를 오른쪽에 넘긴다"는 파이프이다. 괄호 중첩을 피하고 왼쪽에서 오른쪽으로 읽히게 해 준다.

---

### `·` 표기 정리

| 축약 | 원래 형태 | 의미 |
|------|----------|------|
| `(· + 1)` | `fun n => n + 1` | 인자에 1 더하기 |
| `(· + ·)` | `fun a b => a + b` | 두 인자 더하기 |

`·`은 "여기에 인자가 들어간다"는 자리표시자이다.

---

### 결과

```lean
#eval (List.range 100).map (· + 1) |>.foldl (· + ·) 0
-- 5050
```

가우스 공식 `100 * 101 / 2 = 5050`과 일치한다.

---
## 예제 24-25: 무한급수

### 무한 등비급수

|r| < 1일 때: a + ar + ar^2 + ... = a / (1 - r)

예: 1 + 1/2 + 1/4 + 1/8 + ... = 1 / (1 - 1/2) = 2

---

## [학생 활동] 2.4 수열과 합 종합 연습

**1.** 다음 수열의 처음 5항을 구하라:

| 수열 | a_0 | a_1 | a_2 | a_3 | a_4 |
|------|-----|-----|-----|-----|-----|
| a_0=3, a_n=2*a_{n-1}+1 | 3 | ______ | ______ | ______ | ______ |

**2.** 1 + 2 + 3 + ... + 50 = ______

**3.** 등비급수: 2 + 2*(1/3) + 2*(1/3)^2 + ... = ______

**4.** [Lean 4] 다음 수열을 정의하고 처음 6항을 출력하라:

a_0 = 5, a_n = a_{n-1} - 2

```lean
def mySeq : Nat -> Int
  | 0 => ______
  | n + 1 => ______

#eval (List.range 6).map mySeq
-- 기대: [5, 3, 1, -1, -3, -5]
```

<details>
<summary>전체 정답 보기</summary>

**1.** a_0=3, a_1=7, a_2=15, a_3=31, a_4=63

**2.** 50*51/2 = **1275**

**3.** 2 / (1 - 1/3) = 2 / (2/3) = **3**

**4.**
```lean
def mySeq : Nat -> Int
  | 0 => 5
  | n + 1 => mySeq n - 2
```

</details>

---

## 블록 2 Lean 4 전술 요약

| 전술 | 용도 | 사용 장면 |
|------|------|-----------|
| `intro a b h` | 변수/가정 도입 | 단사 증명의 첫 단계 |
| `omega` | 선형 산술 | f(a)=f(b) -> a=b |
| `use 증인` | 존재 증인 제시 | 전사 증명: ∃a, f(a)=b |
| `constructor` | ∧ 분리 | 전단사 = 단사 + 전사 |
| `norm_num` | 수치 계산 | 1^2 = (-1)^2 등 |
| `absurd` | 모순 유도 | 단사가 아님 증명 |
| `ring` | 대수 등식 | 합성 함수 계산 |
| `#eval` | 계산 확인 | 수열, 합, 계승 |

---

## sorry 완성 연습

### 문제 1: 단사 (3배 함수)

```lean
example : Function.Injective (fun n : Int => 3 * n) := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : Function.Injective (fun n : Int => 3 * n) := by
  intro a b h
  omega
```

</details>

### 문제 2: 전사

```lean
example : Function.Surjective (fun n : Int => n - 5) := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : Function.Surjective (fun n : Int => n - 5) := by
  intro b
  use b + 5
  omega
```

</details>

### 문제 3: 전단사

```lean
example : Function.Bijective (fun n : Int => n - 5) := by
  sorry
```

<details>
<summary>정답 보기</summary>

```lean
example : Function.Bijective (fun n : Int => n - 5) := by
  constructor
  · intro a b h
    simp at h
    exact h
  · intro b
    use b + 5
    simp
```

</details>

---

## 완전 자유 증명 연습

### 도전 1

```lean
-- f(x) = 2x + 1 이 Int -> Int에서 단사임을 증명하라.
example : Function.Injective (fun n : Int => 2 * n + 1) := by
  -- 여기에 증명을 작성하라
```

<details>
<summary>정답 보기</summary>

```lean
example : Function.Injective (fun n : Int => 2 * n + 1) := by
  intro a b h
  simp at h
  omega
```

</details>

### 도전 2

```lean
-- f(x) = x + 7 이 Int -> Int에서 전단사임을 증명하라.
example : Function.Bijective (fun n : Int => n + 7) := by
  -- 여기에 증명을 작성하라
```

<details>
<summary>정답 보기</summary>

```lean
example : Function.Bijective (fun n : Int => n + 7) := by
  constructor
  · intro a b h
    simp at h
    exact h
  · intro b
    use b -7
    simp

```

</details>

---
```lean
import Mathlib
import Mathlib.Data.Set.Basic
example : Function.Injective (fun n : Nat => n + 1) := by
  intro a b h     -- h : a + 1 = b + 1
  simp at h
  omega            -- a = b 자동!

-- 전사: ∀ b, ∃ a, f(a) = b
example : Function.Surjective (fun n : Int => n + 1) := by
  intro b          -- b : Int  (임의의 출력값)
  use b - 1        -- 증인: b - 1  (이것이 입력값)
  simp 


example : Function.Bijective (fun n : Int => n + 1) := by
  constructor
  · intro a b h
    simp at h
    exact h
  · intro b
    use b - 1
    simp

example : Function.Injective (fun n : Nat => 2 * n) := by
  intro a b h
  simp at h
  omega

-- Lean 4: 합성
def ff (x : Int) := 2 * x + 3
def gg (x : Int) := 3 * x + 2
#eval ff (gg 1)   -- f(g(1)) = f(5) = 13
#eval gg (ff 1)   -- g(f(1)) = g(5) = 17  (같지 않다!)

-- Lean 4: 계승
#eval Nat.factorial 6     -- 720
#eval Nat.factorial 20    -- 2432902008176640000

-- 10! = ?
#eval Nat.factorial 10

example : ¬ Function.Injective (fun n : Int => n^2) := by
  intro h
  exact absurd (h (by norm_num : (1:Int)^2 = (-1:Int)^2)) (by norm_num)

def arith (n : Nat) : Int := -1 + 4 * n
#eval (List.range 6).map arith  -- [-1, 3, 7, 11, 15, 19]
-- 피보나치 (패턴 매칭)
def fib : Nat -> Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => fib (n + 1) + fib n

#eval (List.range 10).map fib
-- [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

def seq5 : Nat -> Nat
  | 0 => 2
  | n + 1 => seq5 n + 3

#eval (List.range 6).map seq5

def geomSeq : Nat -> Nat
  | 0 => 1
  | n + 1 => 2 * geomSeq n

#eval (1.11 ^ 30 : Float) * 10000
#eval (List.range 100).map (· + 1) |>.foldl (· + ·) 0
#eval (List.range 10).map (fun k => (k+1)^2) |>.foldl (· + ·) 0
def mySeq : Nat -> Int
  | 0 => 5
  | n + 1 => mySeq n - 2

example : Function.Injective (fun n : Int => 3 * n) := by
  intro a b h
  simp at h 
  omega

example : Function.Surjective (fun n : Int => n - 5) := by
  intro b
  use b + 5
  simp

example : Function.Bijective (fun n : Int => n - 5) := by
  constructor
  · intro a b h
    simp at h
    exact h
  · intro b
    use b + 5
    simp

example : Function.Injective (fun n : Int => 2 * n + 1) := by
  intro a b h
  simp at h
  omega

example : Function.Bijective (fun n : Int => n + 7) := by
  constructor
  · intro a b h
    simp at h
    exact h
  · intro b
    use b -7
    simp

---
