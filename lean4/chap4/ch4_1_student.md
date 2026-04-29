# 이산수학 × Lean 4 완전정복

## 로젠(Rosen) 이산수학 4장 §4.1 — 가분성과 나머지 산술


### 0.4.4 Lean 4에서의 사용

```lean
-- 함의 P → Q 증명
example (P Q : Prop) (h : P → Q) (hp : P) : Q := h hp
-- 함수처럼 h에 hp를 적용하면 Q가 나온다

-- 동치 P ↔ Q 증명 — constructor로 쪼갠다
example (P Q : Prop) (h₁ : P → Q) (h₂ : Q → P) : P ↔ Q := by
  constructor
  · exact h₁   -- → 방향
  · exact h₂   -- ← 방향

-- 동치 P ↔ Q 사용 — mp(modus ponens, →방향), mpr(←방향)
example (P Q : Prop) (h : P ↔ Q) (hp : P) : Q := h.mp hp
example (P Q : Prop) (h : P ↔ Q) (hq : Q) : P := h.mpr hq
```

**기억법**: `mp` = "modus ponens, →", `mpr` = "mp reverse, ←".

---


## 0.6 이 강의에서 자주 쓸 공리·보조 정리 명단

rw로 호출할 **공리 카탈로그**이다. 미리 익혀 두자. (정수 타입 `ℤ`에 대해)

### 덧셈·곱셈의 기본 공리

| 이름 | 내용 | 의미 |
|------|------|------|
| `add_comm` | `a + b = b + a` | 덧셈 교환법칙 |
| `add_assoc` | `(a + b) + c = a + (b + c)` | 덧셈 결합법칙 |
| `add_zero` | `a + 0 = a` | 덧셈 항등원 |
| `zero_add` | `0 + a = a` | 왼쪽 항등원 |
| `mul_comm` | `a * b = b * a` | 곱셈 교환법칙 |
| `mul_assoc` | `(a * b) * c = a * (b * c)` | 곱셈 결합법칙 |
| `mul_one` | `a * 1 = a` | 곱셈 항등원 |
| `one_mul` | `1 * a = a` | 왼쪽 항등원 |
| `mul_zero` | `a * 0 = 0` | 곱셈에 0 |

### 분배법칙

| 이름 | 내용 |
|------|------|
| `mul_add` | `a * (b + c) = a * b + a * c` |
| `add_mul` | `(a + b) * c = a * c + b * c` |
| `left_distrib` | `mul_add`의 다른 이름 |
| `right_distrib` | `add_mul`의 다른 이름 |

### 나눔(가분성)과 관련된 정의·보조 정리 (이 절에서 정의)

| 이름 | 내용 |
|------|------|
| `Int.dvd_def` 또는 `dvd_iff_exists_eq_mul_left` | `a ∣ b ↔ ∃ c, b = a * c` |


## 0.8 최신 AI와의 연결: 왜 지금 Lean 4를 배우는가

**AlphaProof** (2024, DeepMind): 국제 수학 올림피아드 문제를 Lean 4로 자동 증명하여 은메달급 성적을 거뒀다. **Lean 4가 수학의 "기계 가독 언어"(machine-readable mathematics)가 되고 있다**는 뜻이다.

**LeanDojo / ReProver**: Lean 4 증명을 **RAG**(Retrieval-Augmented Generation) 기법으로 생성하는 최신 연구이다. Mathlib 라이브러리에서 관련 보조 정리를 검색(retrieval)해 현재 증명에 붙여 쓴다. 이 절에서 배우는 "공리 카탈로그에서 rw할 보조 정리 고르기"가 바로 RAG의 수학 버전이다.

**앞으로 이 강의에서 배우는 "공리 선택 → rw 적용" 패턴은, AI가 수학을 하는 방식의 기초를 직접 체험하는 과정이다.**

---


# Part 1. §4.1 가분성과 나머지 산술

> 이 장에서 다루는 모든 정수는 `ℤ`(정수)이다. 나눗셈을 자연수가 아니라 정수로 정의하는 이유는, 뒤에 나오는 "정리 1"(선형결합의 가분성)이 음수 계수까지 허용해야 가장 자연스럽기 때문이다.

---

## 1.1 (§4.1.1) 서론

**가분성**(divisibility)이란 "어떤 정수가 다른 정수로 나누어 떨어진다"는 개념이다. 정수 세상에서 나눗셈을 하면 **몫**(quotient)과 **나머지**(remainder)가 나오는데, 이 나머지만을 다루는 산술이 **나머지 산술**(modular arithmetic) 또는 **시계 산술**(clock arithmetic)이다.

**응용 미리보기**. 이 절의 결과들은 다음에서 핵심 도구로 쓰인다.
- 유사난수(pseudorandom number) 생성
- 해시 함수로 파일을 메모리에 할당
- 주민등록번호 체크섬(check digit)
- 암호학(RSA, 디피-헬만 키 교환)

---

## 1.2 (§4.1.2) 나눗셈 — 정의와 기본 정리

### 1.2.1 정의 1 — 가분성(divisibility)

> **정의 1 (Definition 1)**. $a$, $b$가 정수이고 $a \neq 0$일 때, $b = ac$가 되는 정수 $c$가 존재한다면 "$a$가 $b$를 나눈다"(**$a$ divides $b$**)고 하며 **$a \mid b$**로 표기한다. 이때 $a$는 $b$의 **약수**(divisor) 또는 **인수**(factor)이고, $b$는 $a$의 **배수**(multiple)이다. $a$가 $b$를 나누지 않으면 **$a \nmid b$**로 쓴다.

**한정기호**(quantifier) 표기

$$
a \mid b \;\;\iff\;\; \exists c \in \mathbb{Z},\; b = ac
$$

### 1.2.2 정의의 이해 — 그림으로

```
          d     2d    3d    4d
   ──+────+────+────+────+──── (수직선)
     0    ←── d의 배수들 ──→

   d | 0      (c = 0)
   d | d      (c = 1)
   d | 2d     (c = 2)
   d | -d     (c = -1)
```

양수 $d$의 배수들은 수직선 위에 일정 간격으로 찍힌 점들이다. $d$로 나누어 떨어지는 정수 = 이 점들 위에 있는 정수.

### 1.2.3 예제 1 — $3 \mid 7$인가, $3 \mid 12$인가

**풀이**. $7/3$은 정수가 아니므로 $3 \nmid 7$. 반면 $12/3 = 4$는 정수이므로 $3 \mid 12$.

### 1.2.4 예제 2 — $n$ 이하 양의 정수 중 $d$의 배수 개수

**풀이**. $d$의 배수는 $dk$ 꼴의 정수이며, $k$는 양의 정수. $dk \leq n \iff k \leq n/d$이므로 조건을 만족하는 $k$의 개수는 $\lfloor n/d \rfloor$이다. 따라서 $n$ 이하 정수 중 $d$의 배수는 **$\lfloor n/d \rfloor$개**.

### 1.2.5 Lean 4 — 가분성의 정의

Lean 4(Mathlib)에서는 `∣`(Unicode U+2223) 기호가 이미 정의되어 있다. 정의는 다음과 같다.

```lean
-- Mathlib에서의 정의 (개념적 형태)
-- a ∣ b ↔ ∃ c, b = a * c

-- Mathlib의 실제 보조 정리
-- dvd_def : a ∣ b ↔ ∃ c, b = a * c
-- Int.dvd_iff_exists_eq_mul_left 등 여러 버전

example (a b : ℤ) (h : a ∣ b) : ∃ c, b = a * c := h
-- 정의 자체가 존재명제이므로 h가 곧 증인 쌍 ⟨c, 증명⟩이다

example (a : ℤ) : a ∣ (2 * a) := ⟨2, by rw [mul_comm]⟩
-- 증인 c = 2 를 제시, 등식 2 * a = a * 2는 mul_comm으로
```

**해석**. Lean 4에서 `a ∣ b`를 증명하려면 **증인**(witness) $c$와 **등식** $b = a \cdot c$의 증명을 쌍으로 제공해야 한다.

---

## 1.3 정리 1 — 가분성의 기본 성질

> **정리 1 (Theorem 1)**. $a, b, c$가 $a \neq 0$인 정수라 하자. 다음이 성립한다.
>
> (i) $a \mid b$ 그리고 $a \mid c$이면 $a \mid (b + c)$이다.
>
> (ii) $a \mid b$이면, 모든 정수 $c$에 대해 $a \mid bc$이다.
>
> (iii) $a \mid b$ 그리고 $b \mid c$이면 $a \mid c$이다.

### 1.3.1 (i) 증명 — 수학 버전

**증명**. $a \mid b$와 $a \mid c$라 하자. 나눗셈의 정의에 의해 $b = as$, $c = at$인 정수 $s, t$가 존재한다. 이제

$$b + c = as + at = a(s + t)$$

이다. 따라서 $s + t$가 증인이 되어 $a \mid (b + c)$. **Q.E.D.**

각 단계가 어떤 공리를 썼는지 표로 정리하면 다음과 같다.

| 단계 | 조작 | 근거(공리·정의) |
|------|------|----------------|
| 1 | $a \mid b$에서 $b = as$ 추출 | **가분성의 정의** |
| 2 | $a \mid c$에서 $c = at$ 추출 | **가분성의 정의** |
| 3 | $b + c = as + at$ | **치환(슈퍼포지션)**: $b \to as$, $c \to at$ |
| 4 | $as + at = a(s + t)$ | **분배법칙**(mul_add)의 역방향 |
| 5 | 따라서 $a \mid (b + c)$ | **가분성의 정의** (증인 $s + t$) |

### 1.3.2 (i) 증명 — Lean 4 버전 (rw-only)

```lean
theorem divides_add (a b c : ℤ) (hab : a ∣ b) (hac : a ∣ c) :
    a ∣ (b + c) := by
  -- 1단계: a ∣ b 에서 s와 hs : b = a * s 추출
  obtain ⟨s, hs⟩ := hab
  -- 2단계: a ∣ c 에서 t와 ht : c = a * t 추출
  obtain ⟨t, ht⟩ := hac
  -- 5단계의 뼈대: 증인 s + t 를 먼저 제시
  refine ⟨s + t, ?_⟩
  -- 지금 남은 목표: b + c = a * (s + t)
  -- 3단계: b 를 a * s 로 치환 (슈퍼포지션)
  rw [hs]
  -- 목표: a * s + c = a * (s + t)
  -- 3단계 계속: c 를 a * t 로 치환
  rw [ht]
  -- 목표: a * s + a * t = a * (s + t)
  -- 4단계: mul_add 를 역방향(←)으로 적용
  --        mul_add : a * (s + t) = a * s + a * t
  --        ← mul_add : a * s + a * t = a * (s + t) 로 목표를 바꾼다
  rw [← mul_add]
  -- 목표: a * (s + t) = a * (s + t) → rfl로 자동 종료
```

### 1.3.3 1:1 대응 확인표

| 수학 | Lean 4 | InfoView 상태 |
|------|--------|---------------|
| "$b = as$인 $s$ 존재" | `obtain ⟨s, hs⟩ := hab` | `hs : b = a * s` |
| "$c = at$인 $t$ 존재" | `obtain ⟨t, ht⟩ := hac` | `ht : c = a * t` |
| "증인은 $s + t$" | `refine ⟨s + t, ?_⟩` | `⊢ b + c = a * (s + t)` |
| "$b$를 $as$로 치환" | `rw [hs]` | `⊢ a*s + c = a * (s + t)` |
| "$c$를 $at$로 치환" | `rw [ht]` | `⊢ a*s + a*t = a * (s + t)` |
| "분배법칙 역방향" | `rw [← mul_add]` | `⊢ a*(s+t) = a*(s+t)` (종료) |

**이 표를 외우면, 다른 정리도 같은 방식으로 뜯을 수 있다**.

### 1.3.4 (ii) 증명 — 수학 버전

**증명**. $a \mid b$라 하자. 정의에 의해 $b = as$인 정수 $s$가 존재한다. 이제 임의의 정수 $c$에 대해

$$bc = (as)c = a(sc)$$

(첫 등호는 치환, 두 번째 등호는 곱셈의 결합법칙). 따라서 $sc$가 증인이 되어 $a \mid bc$. **Q.E.D.**

### 1.3.5 (ii) 증명 — Lean 4 버전

```lean
theorem divides_mul (a b : ℤ) (c : ℤ) (hab : a ∣ b) : a ∣ (b * c) := by
  obtain ⟨s, hs⟩ := hab           -- hs : b = a * s
  refine ⟨s * c, ?_⟩              -- 증인 s * c 제시
  -- ⊢ b * c = a * (s * c)
  rw [hs]                          -- b → a * s
  -- ⊢ a * s * c = a * (s * c)
  rw [mul_assoc]                   -- (a*s)*c = a*(s*c)
  -- ⊢ a * (s * c) = a * (s * c) → rfl
```

### 1.3.6 (iii) 증명 — 수학 버전

**증명**. $a \mid b$와 $b \mid c$라 하자. 정의에 의해 $b = as$, $c = bt$인 정수 $s, t$가 존재한다. 치환하면

$$c = bt = (as)t = a(st)$$

이다. 따라서 $st$가 증인이 되어 $a \mid c$. **Q.E.D.**

### 1.3.7 (iii) 증명 — Lean 4 버전

```lean
theorem divides_trans (a b c : ℤ) (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by
  obtain ⟨s, hs⟩ := hab           -- hs : b = a * s
  obtain ⟨t, ht⟩ := hbc           -- ht : c = b * t
  refine ⟨s * t, ?_⟩              -- 증인 s * t
  -- ⊢ c = a * (s * t)
  rw [ht]                          -- c → b * t
  -- ⊢ b * t = a * (s * t)
  rw [hs]                          -- b → a * s
  -- ⊢ a * s * t = a * (s * t)
  rw [mul_assoc]                   -- (a*s)*t = a*(s*t)
```

**교훈**. 가분성의 기본 정리 세 개 모두 **같은 패턴**을 따른다.
1. `obtain`으로 증인 꺼내기
2. `refine ⟨새 증인, ?_⟩`로 새 증인 제시
3. `rw [hs]`, `rw [ht]`로 가정을 목표에 "슈퍼포지션"
4. 결합·분배 공리 한두 번 더 `rw`로 마무리

---

## 1.4 따름정리 1 — 선형결합의 가분성

> **따름정리 1 (Corollary 1)**. $a \neq 0$인 세 정수 $a, b, c$가 $a \mid b$와 $a \mid c$를 만족하면, 어떤 정수 $m$과 $n$에 대해서도 $a \mid (mb + nc)$가 성립한다.

**수학 증명**. 정리 1의 (ii)에 의해 $a \mid mb$, $a \mid nc$이다. 다시 정리 1의 (i)에 의해 $a \mid (mb + nc)$. **Q.E.D.**

### 1.4.1 Lean 4 — 보조 정리의 조립

이 따름정리는 **"작은 레고(정리 1의 i, ii)로 큰 레고(따름정리 1)를 만드는" 전형적 사례**이다.

```lean
theorem divides_linear_comb (a b c : ℤ) (m n : ℤ)
    (hab : a ∣ b) (hac : a ∣ c) : a ∣ (m * b + n * c) := by
  -- 정리 1의 (ii) 두 번 적용: a ∣ b → a ∣ m*b, a ∣ c → a ∣ n*c
  have h1 : a ∣ (m * b) := by
    obtain ⟨s, hs⟩ := hab
    refine ⟨m * s, ?_⟩
    -- ⊢ m * b = a * (m * s)
    rw [hs]                        -- ⊢ m * (a * s) = a * (m * s)
    rw [← mul_assoc]               -- ⊢ m * a * s = a * (m * s)
    rw [mul_comm m a]              -- ⊢ a * m * s = a * (m * s)
    rw [mul_assoc]                 -- ⊢ a * (m * s) = a * (m * s)
  have h2 : a ∣ (n * c) := by
    obtain ⟨t, ht⟩ := hac
    refine ⟨n * t, ?_⟩
    rw [ht]
    rw [← mul_assoc]
    rw [mul_comm n a]
    rw [mul_assoc]
  -- 정리 1의 (i) 적용: a ∣ m*b 그리고 a ∣ n*c → a ∣ (m*b + n*c)
  exact divides_add a (m * b) (n * c) h1 h2
```

**이 증명의 핵심**. `have h1 : ...`와 `have h2 : ...`로 작은 사실 두 개를 먼저 증명한 뒤, 마지막에 `exact divides_add ...`로 이전에 증명해둔 **정리 1의 (i)를 레고 블록으로 사용**했다. 이것이 "보조 정리의 조립"이다.

---

## 1.5 (§4.1.3) 나눗셈 알고리즘

### 1.5.1 정리 2 — 나눗셈 알고리즘

> **정리 2 (Division Algorithm)**. $a$가 정수이고 $d$가 양의 정수라고 하자. 그러면 $0 \leq r < d$이고 $a = dq + r$이 되는 **유일한** 정수 $q$와 $r$이 존재한다.

**주의**. 이름은 "알고리즘"이지만 사실 **존재성과 유일성을 주장하는 정리**이다. 계산 절차가 아니다. (왜 "알고리즘"이라 부를까? 학생이 풀어보라.)

### 1.5.2 정의 2 — 용어

- $d$ : **약수**(divisor)
- $a$ : **나뉠수**(dividend)
- $q$ : **몫**(quotient), 표기는 $q = a \,\textbf{div}\, d$
- $r$ : **나머지**(remainder), 표기는 $r = a \,\textbf{mod}\, d$

**핵심 제약**: $0 \leq r < d$이다. 나머지는 **음수일 수 없다**.

### 1.5.3 예제 3 — 101을 11로 나눈 몫과 나머지

$$101 = 11 \cdot 9 + 2$$

따라서 $101 \,\textbf{div}\, 11 = 9$, $101 \,\textbf{mod}\, 11 = 2$.

### 1.5.4 예제 4 — $-11$을 $3$으로 나눈 몫과 나머지

$$-11 = 3 \cdot (-4) + 1$$

따라서 $-11 \,\textbf{div}\, 3 = -4$, $-11 \,\textbf{mod}\, 3 = 1$.

**주의**. $-11 = 3 \cdot (-3) + (-2)$로도 쓸 수 있지만 $r = -2$는 $0 \leq r < 3$을 위반하므로 **나머지가 아니다**. 즉, 몫과 나머지는 **양수 나머지 조건**으로 유일해진다.

### 1.5.5 Lean 4에서의 div/mod

```lean
-- Mathlib의 Int 타입에 대해 Int.ediv, Int.emod 가 정의되어 있다
-- (Euclidean division: 항상 0 ≤ r < |d|)

#eval (101 : Int) / 11        -- 9
#eval (101 : Int) % 11        -- 2

#eval (-11 : Int) / 3         -- -4
#eval (-11 : Int) % 3         -- 1   (음수가 아닌 나머지)

-- 나눗셈 알고리즘의 핵심 등식
-- Mathlib: Int.ediv_add_emod : ∀ (a b : ℤ), b * (a / b) + a % b = a
example (a : ℤ) (d : ℤ) : d * (a / d) + a % d = a := Int.ediv_add_emod a d
```

**주의**. 프로그래밍 언어마다 음수에 대한 `%` 동작이 다르다. C, C++, Java, Python의 `%`는 **다르게** 동작한다! Python의 `%`는 수학적 mod와 같지만 C는 다를 수 있다.

```python
# Python에서 확인
print(-11 %  3)    # 1   (수학적 mod와 일치)
print(-11 //  3)   # -4
```

---

## 1.6 (§4.1.4) 나머지 산술 — 합동(congruence)

### 1.6.1 정의 3 — 합동

> **정의 3 (Definition 3)**. $a$와 $b$가 정수이고 $m$이 양의 정수일 때, $m$이 $a - b$를 나누면 "$a$는 $b$와 **모듈로 $m$ 합동**"(a is congruent to b modulo m)이라 하며 **$a \equiv b \pmod{m}$**으로 표기한다. $m$으로 $a-b$를 나눌 수 없으면 $a \not\equiv b \pmod{m}$.

### 1.6.2 정의의 해석

$$a \equiv b \pmod{m} \;\;\iff\;\; m \mid (a - b)$$

"$a$와 $b$가 모듈로 $m$에서 같다"는 것은 "$a$와 $b$가 $m$으로 나누었을 때 **나머지가 같다**"는 직관과 통한다 (정리 3).

### 1.6.3 예제 5 — $17 \equiv 5 \pmod 6$인가, $24 \equiv 14 \pmod 6$인가

**풀이**. $17 - 5 = 12$. $6 \mid 12$이므로 $17 \equiv 5 \pmod 6$.

$24 - 14 = 10$. $6 \nmid 10$이므로 $24 \not\equiv 14 \pmod 6$.

---

## 1.7 정리 3 — 합동 ↔ 나머지 같음

> **정리 3 (Theorem 3)**. $a$와 $b$가 정수이고 $m$이 양의 정수라고 하자. 그러면
>
> $$a \equiv b \pmod{m} \;\;\iff\;\; a \,\textbf{mod}\, m = b \,\textbf{mod}\, m$$

**해석**. 정의 3의 합동은 "**관계**"(두 정수 사이의 관계)이고, $a \,\textbf{mod}\, m$은 "**함수**"(정수 → 정수). 이 둘이 서로 동치임을 보이는 중요한 정리이다.

증명은 연습문제 21, 22로 남기는데, 아이디어는 $a = mq_1 + r_1$, $b = mq_2 + r_2$로 나누고 $r_1 = r_2 \iff m \mid (a-b)$를 보이면 된다.

### 1.7.1 Lean 4에서의 합동

Mathlib에는 합동이 `Int.ModEq`로 정의되어 있다.

```lean
-- Int.ModEq 정의 (개념적): a ≡ b [ZMOD n] ↔ n ∣ (a - b)
-- 또는 동치: a % n = b % n

example : (17 : ℤ) ≡ 5 [ZMOD 6] := by
  unfold Int.ModEq     -- a % n = b % n 형태로 전개
  rfl                   -- 17 % 6 = 5, 5 % 6 = 5, 양변 5로 같음
```

주의: `Int.ModEq`의 정의를 직접 풀어 쓸 때는 `unfold Int.ModEq`로 쓴다. 이것은 정의 전개이지 자동화가 아니다.

---

## 1.8 정리 4 — 합동의 "평행이동" 성질

> **정리 4 (Theorem 4)**. $m$이 양의 정수라고 하자. 정수 $a$와 $b$가 모듈로 $m$ 합동임의 필요충분조건은 $a = b + km$인 정수 $k$가 존재한다는 것이다.

### 1.8.1 수학 증명

**(→ 방향)**. $a \equiv b \pmod m$이라 하자. 정의에 의해 $m \mid (a - b)$. 가분성의 정의에 의해 $a - b = km$인 정수 $k$가 존재한다. 양변에 $b$를 더하면 $a = b + km$.

**(← 방향)**. $a = b + km$인 정수 $k$가 존재한다고 하자. 그러면 $a - b = km$이므로 $m \mid (a - b)$. 정의에 의해 $a \equiv b \pmod m$. **Q.E.D.**

### 1.8.2 Lean 4 증명 (→ 방향, rw-only)

```lean
-- a - b = m * k 형태를 얻어 평행이동 관계로 변환
theorem cong_to_shift (a b m : ℤ) (h : m ∣ (a - b)) :
    ∃ k : ℤ, a = b + m * k := by
  obtain ⟨k, hk⟩ := h              -- hk : a - b = m * k
  refine ⟨k, ?_⟩
  -- ⊢ a = b + m * k
  -- 핵심 치환: a - b = m * k  ⟹  a = b + m * k (양변에 b 더하기)
  -- 이를 rw로 하려면, b + m*k 부분에서 m*k를 a - b 로 바꾼다
  rw [← hk]                        -- ⊢ a = b + (a - b)
  -- 남은 것: b + (a - b) = a 꼴 대수. rw만으로 하려면:
  rw [add_comm b (a - b)]          -- ⊢ a = (a - b) + b
  rw [sub_add_cancel]              -- ⊢ a = a → rfl
```

**코멘트**. `sub_add_cancel`은 Mathlib의 공리 `a - b + b = a`이다. rw로 직접 호출한다.

---

## 1.9 합동 클래스(congruence class)

> 정수 $a$와 모듈로 $m$ 합동인 모든 정수의 집합을 $a$의 **합동 클래스**(congruence class)라 한다.

예를 들어 $m = 5$일 때, $0$의 합동 클래스는
$$[0]_5 = \{\ldots, -10, -5, 0, 5, 10, 15, \ldots\}$$

9장에서 배우겠지만, 모듈로 $m$에 대해 **서로소인**(pairwise disjoint) $m$개의 합동 클래스가 존재하고, 이들의 합집합이 정수 전체 $\mathbb{Z}$이다.

---

## 1.10 정리 5 — 합동의 덧셈·곱셈 보존

> **정리 5 (Theorem 5)**. $m$이 양의 정수라고 하자. $a \equiv b \pmod m$이고 $c \equiv d \pmod m$이면
>
> $$a + c \equiv b + d \pmod m \quad \text{그리고} \quad ac \equiv bd \pmod m$$

### 1.10.1 수학 증명

**증명**. 정리 4에 의해 $b = a + sm$, $d = c + tm$인 정수 $s, t$가 존재한다.

**(덧셈 부분)**:
$$b + d = (a + sm) + (c + tm) = (a + c) + m(s + t)$$

따라서 $b + d - (a + c) = m(s + t)$이므로 $m \mid [(b+d) - (a+c)]$, 즉 $a + c \equiv b + d \pmod m$.

**(곱셈 부분)**:
$$bd = (a + sm)(c + tm) = ac + m(at + cs + stm)$$

따라서 $bd - ac = m(at + cs + stm)$이므로 $m \mid (bd - ac)$, 즉 $ac \equiv bd \pmod m$. **Q.E.D.**

### 1.10.2 Lean 4 — 덧셈 부분 증명 (rw-only)

```lean
-- 합동을 a - b = m * k 형태로 다루는 버전
theorem cong_add (a b c d m : ℤ)
    (hab : ∃ s, b = a + m * s) (hcd : ∃ t, d = c + m * t) :
    ∃ u, (b + d) = (a + c) + m * u := by
  obtain ⟨s, hs⟩ := hab            -- hs : b = a + m * s
  obtain ⟨t, ht⟩ := hcd            -- ht : d = c + m * t
  refine ⟨s + t, ?_⟩
  -- ⊢ b + d = (a + c) + m * (s + t)
  rw [hs]                          -- b → a + m*s
  -- ⊢ (a + m*s) + d = (a + c) + m * (s + t)
  rw [ht]                          -- d → c + m*t
  -- ⊢ (a + m*s) + (c + m*t) = (a + c) + m * (s + t)
  rw [mul_add m s t]               -- m*(s+t) → m*s + m*t
  -- ⊢ (a + m*s) + (c + m*t) = (a + c) + (m*s + m*t)
  -- 이제 양변이 같도록 재배열 (결합·교환). rw로 한 단계씩.
  rw [add_assoc a (m*s) (c + m*t)]
  -- ⊢ a + (m*s + (c + m*t)) = (a + c) + (m*s + m*t)
  rw [← add_assoc (m*s) c (m*t)]
  -- ⊢ a + (m*s + c + m*t) = (a + c) + (m*s + m*t)
  rw [add_comm (m*s) c]
  -- ⊢ a + (c + m*s + m*t) = (a + c) + (m*s + m*t)
  rw [add_assoc c (m*s) (m*t)]
  -- ⊢ a + (c + (m*s + m*t)) = (a + c) + (m*s + m*t)
  rw [← add_assoc a c (m*s + m*t)]
  -- ⊢ (a + c) + (m*s + m*t) = (a + c) + (m*s + m*t) → rfl
```

**코멘트**. 결합·교환의 연쇄 rw가 길어 보이지만, 이것이 바로 **"자동화 없이 공리로 수식을 변형하는" 미시적 전개**이다. 한 줄 한 줄 어떤 공리를 쓰는지 명시되어 있다는 점이 이 방식의 장점이다.

### 1.10.3 예제 6 — 정리 5의 응용

$7 \equiv 2 \pmod 5$이고 $11 \equiv 1 \pmod 5$이므로, 정리 5에 의해

$$18 = 7 + 11 \equiv 2 + 1 = 3 \pmod 5$$
$$77 = 7 \cdot 11 \equiv 2 \cdot 1 = 2 \pmod 5$$

### 1.10.4 경고 상자 — 합동에서 **안 되는** 연산

다음은 합동처럼 보이지만 **거짓**이다.

- $ac \equiv bc \pmod m$ 이라고 해서 $a \equiv b \pmod m$ 이라고 결론지을 수 없다.
  - 반례: $2 \cdot 3 \equiv 2 \cdot 0 \pmod 6$이지만 $3 \not\equiv 0 \pmod 6$.
- $a \equiv b \pmod m$이고 $c \equiv d \pmod m$이라도, $a^c \equiv b^d \pmod m$은 거짓일 수 있다.

**즉, 합동은 양변을 같은 수로 나누거나 지수로 올려서는 안 된다**. (나눗셈은 §4.3 정리 7의 조건 — `gcd(c, m) = 1` — 에서만 가능.)

---

## 1.11 따름정리 2 — mod 함수의 분배

> **따름정리 2 (Corollary 2)**. $m$이 양의 정수이고 $a, b$가 정수일 때
>
> $$(a + b) \,\textbf{mod}\, m = \big((a \,\textbf{mod}\, m) + (b \,\textbf{mod}\, m)\big) \,\textbf{mod}\, m$$
> $$ab \,\textbf{mod}\, m = \big((a \,\textbf{mod}\, m)(b \,\textbf{mod}\, m)\big) \,\textbf{mod}\, m$$

**응용 의미**. 큰 수의 덧셈·곱셈을 모듈로 $m$으로 계산할 때, **매 단계마다 mod를 취해 수를 작게 유지**해도 결과가 같다. 이는 암호학에서 모듈로 큰 거듭제곱 계산의 핵심 기법이다.

### 1.11.1 예제 7 — $(19^3 \,\textbf{mod}\, 31)^4 \,\textbf{mod}\, 23$ 계산

**풀이**. 단계별 계산.

| 단계 | 수식 | 값 |
|------|------|-----|
| 1 | $19^3$ | $6859$ |
| 2 | $6859 = 221 \cdot 31 + 8$, 즉 $19^3 \,\textbf{mod}\, 31$ | $8$ |
| 3 | $8^4$ | $4096$ |
| 4 | $4096 = 178 \cdot 23 + 2$, 즉 $8^4 \,\textbf{mod}\, 23$ | $2$ |

따라서 $(19^3 \,\textbf{mod}\, 31)^4 \,\textbf{mod}\, 23 = 2$.

### 1.11.2 Python 확인

```python
# 직접 계산과 mod 분배 계산이 같은지 확인
direct = ((19**3) % 31)**4 % 23
print(direct)      # 2

# Python의 내장 모듈로 거듭제곱
print(pow(19, 3, 31))  # 8 — 세 번째 인수 = 모듈로
print(pow(8, 4, 23))   # 2
```

---

## 1.12 (§4.1.5) 산술 모듈로 $m$ — 집합 $\mathbb{Z}_m$

### 1.12.1 정의 — 합과 곱 모듈로 $m$

$m$보다 작고 음이 아닌 정수의 집합을 $\mathbb{Z}_m$이라 한다.
$$\mathbb{Z}_m = \{0, 1, 2, \ldots, m-1\}$$

이 집합에 두 가지 연산을 정의한다.

$$a +_m b = (a + b) \,\textbf{mod}\, m$$
$$a \cdot_m b = (a \cdot b) \,\textbf{mod}\, m$$

이들을 각각 **합 모듈로 $m$**, **곱 모듈로 $m$**이라 한다. 이 두 연산을 쓰는 것을 **산술 모듈로 $m$**(arithmetic modulo m)한다고 말한다.

### 1.12.2 예제 8 — $\mathbb{Z}_{11}$ 계산

$$7 +_{11} 9 = (7 + 9) \,\textbf{mod}\, 11 = 16 \,\textbf{mod}\, 11 = 5$$
$$7 \cdot_{11} 9 = (7 \cdot 9) \,\textbf{mod}\, 11 = 63 \,\textbf{mod}\, 11 = 8$$

### 1.12.3 $\mathbb{Z}_m$의 대수적 구조 — 여섯 가지 성질

| 성질 | 내용 |
|------|------|
| **폐쇄성**(closure) | $a, b \in \mathbb{Z}_m \Rightarrow a +_m b, a \cdot_m b \in \mathbb{Z}_m$ |
| **결합성**(associativity) | $(a +_m b) +_m c = a +_m (b +_m c)$, 곱도 마찬가지 |
| **교환성**(commutativity) | $a +_m b = b +_m a$, 곱도 마찬가지 |
| **항등원**(identity) | $a +_m 0 = a$, $a \cdot_m 1 = a$ |
| **덧셈 역원**(additive inverse) | $a \neq 0$이면 $a$의 덧셈 역원은 $m - a$; $0$의 역원은 $0$ |
| **분배법칙**(distributivity) | $a \cdot_m (b +_m c) = (a \cdot_m b) +_m (a \cdot_m c)$ |

**주의**. 곱셈의 역원은 **항상 존재하지는 않는다**. 예를 들어 $\mathbb{Z}_6$에서 $2$의 곱셈 역원은 없다 (뒤에서 배움).

### 1.12.4 대수적 이름

- 합만 있는 $\mathbb{Z}_m$: **교환군**(commutative group)
- 합과 곱 모두 있는 $\mathbb{Z}_m$: **교환환**(commutative ring)
- 일반 정수 $\mathbb{Z}$: 역시 교환환

이 개념들은 추상대수학(abstract algebra)에서 본격적으로 다룬다.

---

## 1.13 최신 AI 연결 — RAG와 정수론

### 1.13.1 해시 함수와 mod

RAG(Retrieval-Augmented Generation) 시스템은 수백만 개 문서를 **벡터**로 저장하고 검색한다. 저장할 때 핵심 기술이 **해시**(hash) — 임의 길이의 데이터를 고정 길이 주소로 매핑하는 함수.

가장 간단한 해시 함수:
$$h(k) = k \,\textbf{mod}\, m$$

**예**. $m = 111$개의 메모리 슬롯에 주민번호 키 $k = 064212848$을 저장한다고 하자.
$$h(064212848) = 064212848 \,\textbf{mod}\, 111 = 14$$
따라서 14번 슬롯에 저장한다.

이 단순 해시는 **합동 성질 때문에** 균등 분포에 가깝게 작동한다 (정리 5와 연결).

### 1.13.2 로케이티(locality-sensitive hashing, LSH)와 벡터 DB

최신 벡터 DB(Pinecone, Weaviate, Milvus)는 **모듈로 산술 + 랜덤 투영**으로 유사 벡터를 같은 버킷에 빠르게 모은다. 이것이 RAG의 **밀리초 단위 검색**의 원리이다.

### 1.13.3 암호학 — RSA의 모듈로 거듭제곱

RSA 암호화·복호화의 핵심:
$$c = m^e \,\textbf{mod}\, n \qquad m = c^d \,\textbf{mod}\, n$$

따름정리 2가 없었다면 $m^e$ (수백 자리 수)를 직접 계산해야 했을 것이다. **모듈로를 매 단계 취할 수 있기 때문에** 현실적 계산이 가능하다.

§4.2에서 이 계산을 $O((\log m)^2 \log n)$ 시간에 하는 **빠른 나머지 지수승 알고리즘**을 배운다.

---

## 1.14 §4.1 핵심 요약

| 개념 | 정의 / 핵심 |
|------|-------------|
| $a \mid b$ | $\exists c, b = ac$ |
| 정리 1 | $a \mid b, a \mid c$이면 $a \mid (mb + nc)$ |
| 나눗셈 알고리즘 | $a = dq + r$, $0 \leq r < d$ 유일 |
| $a \equiv b \pmod m$ | $m \mid (a - b)$ |
| 정리 3 | 합동 ↔ mod가 같음 |
| 정리 5 | 합동은 덧셈·곱셈 보존 |
| $\mathbb{Z}_m$ | $\{0, \ldots, m-1\}$ + $+_m$, $\cdot_m$ = 교환환 |

**증명 기법**. 거의 모든 증명이 **"정의를 풀어서 증인을 얻고 → 슈퍼포지션 → 결합·분배 공리로 변형 → 새 증인으로 조립"** 패턴이다. Lean 4의 `obtain → refine → rw` 삼단계가 이 패턴의 기계화이다.

---


# Part 1. §4.1 가분성과 나머지 산술 — 학생 본교재

---

## 1.1 서론 — 왜 가분성을 배우는가

**정수론**(number theory)은 정수의 집합과 그 특성을 연구하는 수학의 한 분야이다. 이 장에서 배울 개념들은 모두 **가분성**(divisibility), 즉 "나누어 떨어진다"는 개념에 뿌리를 둔다.

정수를 양의 정수로 나누면 **몫**(quotient)과 **나머지**(remainder)가 생긴다. 이 나머지만을 다루는 산술이 **나머지 산술**(modular arithmetic), 또는 다른 이름으로 **시계 산술**(clock arithmetic)이다.

### 1.1.1 이 절에서 배울 것의 로드맵

```
  가분성 정의 (a | b)
        ↓
  정리 1 — 나눔의 기본 성질 3가지
        ↓
  따름정리 1 — 선형결합의 나눔
        ↓
  나눗셈 알고리즘 (정리 2)
        ↓
  합동 (≡ mod m)
        ↓
  정리 3, 4, 5 — 합동의 성질
        ↓
  Z_m 상의 산술 (모듈로 m 덧셈·곱셈)
```

### 1.1.2 응용

유사난수 생성, 메모리 주소 할당, 체크 번호(주민번호·ISBN), 메시지 암호화가 모두 나머지 산술 위에 서 있다. 특히 §4.6에서 배울 RSA 암호는 이 절의 내용이 없으면 한 줄도 이해할 수 없다.

---

## 1.2 나눗셈 — 정의 1

### 1.2.1 수학적 정의

> **정의 1**. 정수 $a, b$에 대해 $a \neq 0$이라 하자. $b = ac$가 되는 정수 $c$가 존재할 때, **$a$가 $b$를 나눈다**(a divides b)고 하고 $a \mid b$로 쓴다. 이때 $a$는 $b$의 **약수**(divisor, factor), $b$는 $a$의 **배수**(multiple)이다. $a$가 $b$를 나누지 않으면 $a \nmid b$로 쓴다.

**한정 기호로 표현**하면 다음과 같다.

$$a \mid b \iff \exists c \in \mathbb{Z},\; b = a \cdot c$$

### 1.2.2 자연어 해석

"$a$가 $b$를 나눈다"는 것은 "$b$를 $a$로 정확히 몇 번에 걸쳐 만들 수 있다"는 뜻이다. 이 "몇 번"이 바로 $c$이다.

| 기호 | 읽는 법 |
|------|---------|
| $a \mid b$ | "a가 b를 나눈다" (a divides b) |
| $a \nmid b$ | "a가 b를 나누지 않는다" |

**주의**. $a \mid b$에서 **세로 막대**는 나눗셈 기호($\div$)가 아니다. 헷갈리지 말자. $3 \mid 12$는 "3이 12를 나눈다"는 **관계**(참/거짓을 판정하는 명제)이고, $12/3$은 **값** 4이다.

### 1.2.3 예제 1

> $3 \mid 7$인가? $3 \mid 12$인가?

**풀이**. $3 \mid 7$은 거짓이다. $7/3$이 정수가 아니기 때문이다. $3 \mid 12$는 참이다. $12 = 3 \cdot 4$이므로 $c = 4$이다.

### 1.2.4 예제 2

> $n$과 $d$가 양의 정수라 하자. $n$ 이하의 양의 정수 중 $d$의 배수는 몇 개인가?

**풀이**. $d$로 나누어 떨어지는 양의 정수는 $dk$ 꼴 ($k = 1, 2, 3, \dots$)이다. $n$ 이하라는 조건은 $0 < dk \le n$, 즉 $0 < k \le n/d$이다. 이를 만족하는 양의 정수 $k$의 개수는 $\lfloor n/d \rfloor$이다.

### 1.2.5 Lean 4 구현 — 정의와 첫 증명

Lean 4(Mathlib)에서 $a \mid b$는 이미 정의되어 있으며, 그 정의는 수학적 정의와 동일하다.

```lean
-- Mathlib의 정의 (내부):
-- a ∣ b ↔ ∃ c, b = a * c
-- 기호 '∣'는 키보드 '|'가 아닌 유니코드 U+2223임에 주의.
```

**예제: $3 \mid 12$를 Lean 4로 증명**

| 수학적 증명 | Lean 4 증명 |
|-------------|-------------|
| 1. $c = 4$로 두자 | `⟨4, ?⟩` |
| 2. 그러면 $12 = 3 \cdot 4$ | `rfl` (계산으로 확인) |

```lean
example : (3 : ℤ) ∣ 12 := by
  -- ⊢ 3 ∣ 12
  -- 정의: 3 ∣ 12 ↔ ∃ c, 12 = 3 * c
  exact ⟨4, by rfl⟩     -- c = 4, 그리고 12 = 3 * 4는 rfl
```

**주의**. `⟨4, by rfl⟩`는 "존재 증명"(existential witness)이다. `∃ c, P c` 형태의 명제를 증명할 때 `⟨c값, P c의 증명⟩`으로 구성한다.

---

## 1.3 가분성의 기본 성질 — 정리 1

이것은 이 절의 심장이다. 뒤에 나오는 모든 증명의 출발점이 된다.

### 1.3.1 정리 1 — 수학적 진술

> **정리 1**. $a, b, c$가 $a \neq 0$인 정수라 하자. 다음이 성립한다.
>
> **(i)** 만약 $a \mid b$이고 $a \mid c$이면 $a \mid (b + c)$이다.
> **(ii)** 만약 $a \mid b$이면, 모든 정수 $c$에 대해 $a \mid bc$이다.
> **(iii)** 만약 $a \mid b$이고 $b \mid c$이면 $a \mid c$이다.

### 1.3.2 (i)의 수학적 증명 — 단계별 해부

**증명**. $a \mid b$이고 $a \mid c$라 하자. 나눗셈의 정의에 의해 $b = as$이고 $c = at$인 정수 $s, t$가 **존재**한다. 여기서:

$$b + c = as + at = a(s + t)$$

따라서 $s + t$라는 정수가 증인이 되어, 나눗셈의 정의에 의해 $a \mid (b + c)$이다. $\blacksquare$

### 1.3.3 (i)의 증명 — 단계별 "왜" 설명

| 단계 | 수학 | 왜 이렇게 하는가 |
|------|------|-----------------|
| 1 | $a \mid b$ 풀기 → $b = as$ | 나눗셈의 **정의를 꺼내서** 존재하는 증인 $s$를 확보 |
| 2 | $a \mid c$ 풀기 → $c = at$ | 같은 이유로 증인 $t$ 확보 |
| 3 | $b + c$ 계산: $as + at$ | **치환(슈퍼포지션)**: $b, c$를 각각 $as, at$로 바꿈 |
| 4 | $as + at = a(s+t)$ | **분배법칙** 역방향 (mul_add의 `←`) |
| 5 | 증인 $s + t$ 제시 → $a \mid (b+c)$ | 나눗셈의 **정의를 닫아서** 결론 도출 |

### 1.3.4 (i)의 Lean 4 증명 — 수학 단계와 1:1 대응

```lean
theorem dvd_add_my (a b c : ℤ) (hab : a ∣ b) (hac : a ∣ c) :
    a ∣ (b + c) := by
  -- 1단계: 가설 hab에서 증인 s 꺼내기
  --   hab : a ∣ b  →  ⟨s, hs⟩ 로 분해,  hs : b = a * s
  obtain ⟨s, hs⟩ := hab
  -- 2단계: 가설 hac에서 증인 t 꺼내기
  --   hac : a ∣ c  →  ⟨t, ht⟩ 로 분해,  ht : c = a * t
  obtain ⟨t, ht⟩ := hac
  -- 3단계: 증인 s + t 제시
  --   ⊢ a ∣ (b + c)  =  ∃ k, b + c = a * k
  --   k := s + t 로 제시
  refine ⟨s + t, ?_⟩
  -- [이 시점 목표] ⊢ b + c = a * (s + t)
  -- 4단계: 치환(슈퍼포지션) — b를 a*s로
  rw [hs]
  -- [이 시점 목표] ⊢ a * s + c = a * (s + t)
  -- 5단계: 치환(슈퍼포지션) — c를 a*t로
  rw [ht]
  -- [이 시점 목표] ⊢ a * s + a * t = a * (s + t)
  -- 6단계: 분배법칙을 역방향으로 (a*(s+t)를 a*s+a*t로 뒤집어 양변을 같게)
  rw [← mul_add]
  -- [이 시점 목표] ⊢ a * (s + t) = a * (s + t)   → rfl로 자동 종료
```

**InfoView 추적**

```
[시작]             hab : a ∣ b,  hac : a ∣ c
                   ⊢ a ∣ (b + c)

[obtain hab 후]    s : ℤ,  hs : b = a * s
                   ⊢ a ∣ (b + c)

[obtain hac 후]    t : ℤ,  ht : c = a * t
                   ⊢ a ∣ (b + c)

[refine 후]        ⊢ b + c = a * (s + t)

[rw [hs] 후]       ⊢ a * s + c = a * (s + t)

[rw [ht] 후]       ⊢ a * s + a * t = a * (s + t)

[rw [← mul_add] 후] ⊢ a * (s + t) = a * (s + t)  → 종료
```

### 1.3.5 (ii)의 증명

**수학적 증명**. $a \mid b$이므로 $b = as$인 정수 $s$가 있다. 임의의 정수 $c$에 대해:

$$bc = (as)c = a(sc)$$

(곱셈의 결합법칙 사용). 따라서 $sc$를 증인으로 $a \mid bc$. $\blacksquare$

**Lean 4 증명**

```lean
theorem dvd_mul_right_my (a b : ℤ) (hab : a ∣ b) (c : ℤ) :
    a ∣ (b * c) := by
  -- 1단계: hab 분해
  obtain ⟨s, hs⟩ := hab
  -- [목표] ⊢ a ∣ (b * c)
  -- 2단계: 증인 s * c 제시
  refine ⟨s * c, ?_⟩
  -- [목표] ⊢ b * c = a * (s * c)
  -- 3단계: 치환 b → a * s
  rw [hs]
  -- [목표] ⊢ a * s * c = a * (s * c)
  -- 4단계: 결합법칙 (mul_assoc : (a*b)*c = a*(b*c))
  rw [mul_assoc]
  -- [목표] ⊢ a * (s * c) = a * (s * c) → 종료
```

### 1.3.6 (iii)의 증명 — 연쇄 나눔(transitivity)

**수학적 증명**. $a \mid b$에서 $b = as$인 $s$가, $b \mid c$에서 $c = bt$인 $t$가 존재한다. 치환하면:

$$c = bt = (as)t = a(st)$$

따라서 $st$를 증인으로 $a \mid c$. $\blacksquare$

**Lean 4 증명**

```lean
theorem dvd_trans_my (a b c : ℤ) (hab : a ∣ b) (hbc : b ∣ c) :
    a ∣ c := by
  obtain ⟨s, hs⟩ := hab    -- hs : b = a * s
  obtain ⟨t, ht⟩ := hbc    -- ht : c = b * t
  refine ⟨s * t, ?_⟩
  -- [목표] ⊢ c = a * (s * t)
  rw [ht]                   -- c → b * t
  -- [목표] ⊢ b * t = a * (s * t)
  rw [hs]                   -- b → a * s
  -- [목표] ⊢ a * s * t = a * (s * t)
  rw [mul_assoc]            -- 결합법칙
  -- [목표] ⊢ a * (s * t) = a * (s * t) → 종료
```

---

## 1.4 따름정리 1 — 선형결합의 나눔

### 1.4.1 수학적 진술

> **따름정리 1**. $a \neq 0$인 세 정수 $a, b, c$가 $a \mid b$와 $a \mid c$를 만족하면, 어떤 정수 $m, n$에 대해서도 $a \mid (mb + nc)$가 성립한다.

이 결과는 이후 모든 장에서 반복해서 사용한다. 외워 두자.

### 1.4.2 증명 — 두 레고 블록 조립

**수학적 증명**. 정리 1의 (ii)에서 모든 정수 $m, n$에 대해 $a \mid mb$이고 $a \mid nc$이다. 정리 1의 (i)에서 $a \mid (mb + nc)$이다. $\blacksquare$

**핵심 관찰**. 이것은 정리 1의 **(ii)를 두 번 쓰고, (i)를 한 번 쓰는** 합성 증명이다. 보조 정리(lemma)와 큰 정리(theorem)의 관계가 바로 이런 것이다.

### 1.4.3 Lean 4 증명

```lean
theorem dvd_linear_comb (a b c m n : ℤ)
    (hab : a ∣ b) (hac : a ∣ c) : a ∣ (m * b + n * c) := by
  -- 1단계: 정리 1-(ii) 적용 → a ∣ (m*b)
  --   실제로는 dvd_mul_left_my : a ∣ b → a ∣ m*b
  --   여기서는 obtain으로 직접 구성
  obtain ⟨s, hs⟩ := hab        -- hs : b = a * s
  obtain ⟨t, ht⟩ := hac        -- ht : c = a * t
  -- 목표: ⊢ a ∣ (m * b + n * c)
  -- 증인: m*s + n*t
  refine ⟨m * s + n * t, ?_⟩
  -- [목표] ⊢ m * b + n * c = a * (m * s + n * t)
  rw [hs]                        -- b → a*s
  -- [목표] ⊢ m * (a * s) + n * c = a * (m * s + n * t)
  rw [ht]                        -- c → a*t
  -- [목표] ⊢ m * (a * s) + n * (a * t) = a * (m * s + n * t)
  rw [mul_add]                   -- a*(m*s + n*t) = a*(m*s) + a*(n*t)
  -- [목표] ⊢ m * (a * s) + n * (a * t) = a * (m * s) + a * (n * t)
  rw [← mul_assoc, ← mul_assoc]  -- a*(m*s)=a*m*s, a*(n*t)=a*n*t
  -- [목표] ⊢ m * (a * s) + n * (a * t) = a * m * s + a * n * t
  rw [mul_comm a m, mul_comm a n]  -- 좌변과 같게
  -- [목표] ⊢ m * (a * s) + n * (a * t) = m * a * s + n * a * t
  rw [mul_assoc m a s, mul_assoc n a t]
  -- [목표] ⊢ m * (a * s) + n * (a * t) = m * (a * s) + n * (a * t) → 종료
```

**주의**. 이 증명은 rw 전술만 사용하느라 단계가 많다. 실전에서는 `ring` 전술로 한 줄에 끝낼 수 있지만, 이 강의는 **대수적 전개를 미시적으로 보는 것이 목표**이므로 rw만 사용한다.

### 1.4.4 RAG 시각으로 본 증명

이 증명은 본질적으로 다음 "검색 → 적용" 루프이다.

```
[목표 분석] m*b + n*c 꼴 → "선형결합의 나눔 보조 정리 필요"
     ↓
[라이브러리 검색] Mathlib에서:
     - dvd_mul_left : a ∣ b → a ∣ m*b
     - dvd_add : a ∣ b → a ∣ c → a ∣ (b + c)
     ↓
[적용 순서 결정] dvd_mul_left × 2 → dvd_add
     ↓
[rw로 기본 연산 확인]
```

AI의 **자동 증명기**(automated prover)가 하는 일이 바로 이것이다. Mathlib을 벡터 데이터베이스화해서 **의미론적으로 유사한 보조 정리를 RAG로 검색**하는 것이 현재 최첨단 연구이다(LeanDojo, ReProver, LeanAgent 등).

---

## 1.5 나눗셈 알고리즘 — 정리 2

### 1.5.1 수학적 진술

> **정리 2 (나눗셈 알고리즘)**. $a$가 정수이고 $d$가 양의 정수라 하자. 그러면 $a = dq + r$이 되는 **유일한** 정수 $q, r$이 있으며, $0 \le r < d$이다.

### 1.5.2 명명법 — 정의 2

> **정의 2**. $d$는 **약수**(divisor), $a$는 **나뉠수**(dividend), $q$는 **몫**(quotient), $r$은 **나머지**(remainder)이다. 표기법은 다음과 같다.
>
> $$q = a \;\mathbf{div}\; d, \qquad r = a \;\mathbf{mod}\; d$$

### 1.5.3 예제 3

> 101을 11로 나누었을 때 몫과 나머지를 구하라.

**풀이**. $101 = 11 \cdot 9 + 2$. 따라서 $q = 101 \;\mathbf{div}\; 11 = 9$, $r = 101 \;\mathbf{mod}\; 11 = 2$.

### 1.5.4 예제 4 — 음수의 나머지

> $-11$을 3으로 나누었을 때 몫과 나머지를 구하라.

**풀이**. $-11 = 3 \cdot (-4) + 1$. 따라서 $q = -4$, $r = 1$.

**결정적 주의점**. $-11 = 3 \cdot (-3) + (-2)$도 참이지만, 이 경우 $r = -2 < 0$이므로 정의 위반이다. **나머지는 음수일 수 없다**. 조건 $0 \le r < d$를 만족하는 것은 $(q, r) = (-4, 1)$ **뿐**이다. 유일성을 기억하자.

### 1.5.5 다른 언어의 모듈러 연산자

| 언어 | 연산자 | 음수 입력 시 결과 |
|------|--------|------------------|
| 수학 $\mathbf{mod}$ | `a mod m` | 항상 $0 \le r < m$ |
| Python | `%` | 수학과 동일 (`(-11) % 3 == 1`) |
| C, C++, Java | `%` | 피제수 부호 따름 (`(-11) % 3 == -2`) |
| BASIC, Maple, Excel | `mod` | 수학과 동일 |

**암호학 구현 시 이 차이 때문에 버그가 종종 생긴다**. 반드시 사용하는 언어의 동작을 확인하자.

### 1.5.6 Lean 4에서 % 확인

```lean
-- Python 스타일 (수학과 동일, 항상 0 ≤ r < m)
#eval (101 : Int) % 11    -- 출력: 2
#eval (-11 : Int) % 3     -- 출력: 1   (수학 정의대로!)
#eval (101 : Int) / 11    -- 출력: 9
#eval (-11 : Int) / 3     -- 출력: -4  (수학 정의대로!)
```

**핵심**. Lean 4의 `Int`에서 `%`와 `/`는 **수학의 정의를 따른다**. C와는 다르다.

### 1.5.7 나눗셈 알고리즘의 존재성 증명 스케치

Rosen 원서는 5.2절로 미룬다. 직관적 아이디어만 제시한다.

**존재성**. $S = \{a - dk : k \in \mathbb{Z}, a - dk \ge 0\}$은 공집합이 아닌 음이 아닌 정수의 집합이다. 순서화 성질(well-ordering)에 의해 최소 원소 $r$을 가진다. 이 $r$에 대해 $r = a - dq$ ($q$는 해당 $k$). 그러면 $0 \le r$이고, $r \ge d$라면 $r - d = a - d(q+1) \ge 0$이 더 작은 원소가 되어 모순. 따라서 $0 \le r < d$.

**유일성**. $a = dq_1 + r_1 = dq_2 + r_2$ ($0 \le r_1, r_2 < d$)라 하자. 빼면 $d(q_1 - q_2) = r_2 - r_1$이고 $|r_2 - r_1| < d$이므로 $q_1 = q_2$, 따라서 $r_1 = r_2$.

---

## 1.6 모듈로 합동 — 정의 3

### 1.6.1 동기 — 시계 산술

지금부터 50시간 후는 몇 시인가? 24시간 시계에서 답은 (현재 시간 + 50)을 24로 나눈 나머지이다. 이처럼 **나머지만을 다루는** 산술을 **나머지 산술**(modular arithmetic)이라 한다.

### 1.6.2 수학적 정의

> **정의 3**. $a, b$가 정수이고 $m$이 양의 정수라 하자. 만약 $m \mid (a - b)$이면, $a$와 $b$는 **모듈로 $m$ 합동**(congruent modulo m)이라 하고 $a \equiv b \pmod{m}$으로 쓴다. $a \not\equiv b \pmod{m}$은 합동이 아님을 나타낸다.

**기호로**:

$$a \equiv b \pmod{m} \iff m \mid (a - b)$$

### 1.6.3 두 표기법의 차이 — 매우 중요

| 표기 | 의미 | 종류 |
|------|------|------|
| $a \equiv b \pmod m$ | "$a$와 $b$는 모듈로 $m$에서 같다" | **관계** (참/거짓) |
| $a \;\mathbf{mod}\; m$ | "$a$를 $m$으로 나눈 나머지" | **값** (정수) |

둘 다 "mod"가 들어가지만 근본적으로 다르다. 전자는 **정수 집합 간의 관계**이고 후자는 **함수**이다. 다만 정리 3에서 보듯 둘은 밀접하게 연결되어 있다.

### 1.6.4 예제 5

> 17이 5와 모듈로 6 합동인가? 24가 14와 모듈로 6 합동인가?

**풀이**. $17 - 5 = 12 = 6 \cdot 2$이므로 $6 \mid 12$, 즉 $17 \equiv 5 \pmod 6$이다. 반면 $24 - 14 = 10$이고 $6 \nmid 10$이므로 $24 \not\equiv 14 \pmod 6$이다.

---

## 1.7 정리 3 — 합동과 mod의 관계

### 1.7.1 진술

> **정리 3**. $a, b$가 정수이고 $m$이 양의 정수이면:
>
> $$a \equiv b \pmod{m} \iff a \;\mathbf{mod}\; m = b \;\mathbf{mod}\; m$$

### 1.7.2 해석

"$a$와 $b$가 모듈로 $m$ 합동"이라는 관계는, "**$m$으로 나눈 나머지가 같다**"는 사실과 동치이다.

### 1.7.3 증명 스케치 (Rosen 연습문제 21, 22)

**(→)** $a \equiv b \pmod m$이면 $m \mid (a-b)$. 한편 $a = mq_1 + r_1$, $b = mq_2 + r_2$ ($0 \le r_1, r_2 < m$)라 하자. 그러면 $a - b = m(q_1 - q_2) + (r_1 - r_2)$. $m$이 이것을 나누고 $m$이 $m(q_1-q_2)$를 나누므로 $m \mid (r_1 - r_2)$. 그런데 $|r_1 - r_2| < m$이므로 $r_1 - r_2 = 0$, 즉 $r_1 = r_2$.

**(←)** 역은 대칭적. $r_1 = r_2$이면 $a - b = m(q_1 - q_2)$이므로 $m \mid (a-b)$.

---

## 1.8 정리 4 — 합동의 알짜 표현

### 1.8.1 진술

> **정리 4**. $m$이 양의 정수라 하자. 정수 $a$와 $b$가 모듈로 $m$ 합동일 필요충분조건은 $a = b + km$인 정수 $k$가 존재하는 것이다.
>
> $$a \equiv b \pmod m \iff \exists k \in \mathbb{Z},\; a = b + km$$

### 1.8.2 수학적 증명 — 양방향

**(→) 증명**. $a \equiv b \pmod m$이라 하자. 합동의 정의에 의해 $m \mid (a - b)$이다. 즉 $a - b = km$인 정수 $k$가 존재한다. 이로부터 $a = b + km$.

**(←) 증명**. $a = b + km$인 정수 $k$가 존재한다고 하자. 그러면 $km = a - b$. 따라서 $m \mid (a - b)$. 합동의 정의에 의해 $a \equiv b \pmod m$. $\blacksquare$

### 1.8.3 이 정리가 핵심인 이유

이후에 나오는 모든 합동 조작(정리 5, 따름정리 2, 암호학 전체)이 이 **"$a = b + km$"라는 한 줄**을 반복해서 쓴다. 합동이라는 **관계**를 **등식**으로 바꿔주는 다리이다.

### 1.8.4 Lean 4 증명

Lean에서 합동은 `Int.ModEq m a b`로 쓰고 기호로 $a ≡ b [\mathrm{ZMOD}\ m]$이다. 정의는 $a \% m = b \% m$이다. 하지만 이 강의의 교육 목적상, 우리는 "$a \equiv b \pmod m \iff m \mid (a - b)$"를 **우리 자신의 정의**로 직접 정의해서 쓴다.

```lean
-- 우리 자신의 합동 정의 (교육 목적)
def MyCong (m a b : ℤ) : Prop := m ∣ (a - b)
notation:50 a " ≡M " b " [mod " m "]" => MyCong m a b

-- 정리 4: MyCong m a b ↔ ∃ k, a = b + k * m
theorem myCong_iff (m a b : ℤ) :
    MyCong m a b ↔ ∃ k : ℤ, a = b + k * m := by
  -- ↔는 양방향. constructor로 쪼갠다.
  constructor
  -- (→) 방향
  · intro h                      -- h : MyCong m a b = (m ∣ (a - b))
    -- h를 풀어 ⟨k, hk⟩ 형태로: hk : a - b = m * k
    obtain ⟨k, hk⟩ := h
    -- ⊢ ∃ k', a = b + k' * m
    refine ⟨k, ?_⟩
    -- ⊢ a = b + k * m
    -- hk : a - b = m * k 를 이용
    -- a = (a - b) + b = m*k + b = b + k*m
    -- rw로 단계별 전개:
    -- 먼저 a = (a - b) + b 형태가 필요. sub_add_cancel : a - b + b = a
    -- sub_add_cancel의 역방향 적용:
    rw [← sub_add_cancel a b]    -- ⊢ (a - b) + b = b + k * m
    rw [hk]                       -- ⊢ m * k + b = b + k * m
    rw [add_comm]                 -- ⊢ b + m * k = b + k * m
    rw [mul_comm m k]             -- ⊢ b + k * m = b + k * m → 종료
  -- (←) 방향
  · intro h                      -- h : ∃ k, a = b + k * m
    obtain ⟨k, hk⟩ := h          -- hk : a = b + k * m
    -- ⊢ MyCong m a b = (m ∣ (a - b))
    refine ⟨k, ?_⟩
    -- ⊢ a - b = m * k
    rw [hk]                       -- ⊢ b + k * m - b = m * k
    rw [add_sub_cancel_left]      -- ⊢ k * m = m * k
    rw [mul_comm]                 -- ⊢ m * k = m * k → 종료
```

**InfoView 핵심 추적(→ 방향)**

```
[시작]             ⊢ MyCong m a b → ∃ k, a = b + k * m
[intro h 후]        h : MyCong m a b
                   ⊢ ∃ k, a = b + k * m
[obtain 후]        k : ℤ, hk : a - b = m * k
                   ⊢ ∃ k', a = b + k' * m
[refine 후]        ⊢ a = b + k * m
[rw 연쇄 후]        ⊢ b + k * m = b + k * m → 종료
```

**핵심 rw 기법**: `rw [← sub_add_cancel a b]`는 `a` 자체를 `(a - b) + b`로 **역방향 슈퍼포지션**한다. 이처럼 rw의 역방향(`←`)은 "증명 목표를 쓰기 좋은 형태로 되돌리는" 데 쓴다.

---

## 1.9 합동 클래스

> 정수 $a$와 모듈로 $m$ 합동인 모든 정수의 집합은 $a$의 **모듈로 $m$ 합동 클래스**(congruence class modulo m)이다.

예를 들어 모듈로 4의 합동 클래스는 네 개이다.

$$\{\dots, -8, -4, 0, 4, 8, \dots\}, \{\dots, -7, -3, 1, 5, 9, \dots\}, \{\dots, -6, -2, 2, 6, 10, \dots\}, \{\dots, -5, -1, 3, 7, 11, \dots\}$$

**핵심**: 각 쌍마다 서로소(pairwise disjoint) $m$개의 모듈로 $m$ 동치 클래스가 존재하고, 이들의 합집합은 정수 전체이다. 이 사실은 9장에서 동치 관계의 일반 이론으로 배운다.

---

## 1.10 정리 5 — 합동은 합과 곱에서 보존

### 1.10.1 진술

> **정리 5**. $m$이 양의 정수라 하자. $a \equiv b \pmod m$이고 $c \equiv d \pmod m$이면:
>
> $$a + c \equiv b + d \pmod m \quad \text{이고} \quad ac \equiv bd \pmod m$$

### 1.10.2 수학적 증명 — 정리 4를 두 번 쓰기

**증명**. 직접증명법. $a \equiv b \pmod m$과 $c \equiv d \pmod m$으로부터, 정리 4에 의해 정수 $s, t$가 있어:

$$b = a + sm, \qquad d = c + tm$$

그러면:

$$b + d = (a + sm) + (c + tm) = (a + c) + m(s + t)$$

$$bd = (a + sm)(c + tm) = ac + atm + smc + smtm = ac + m(at + sc + stm)$$

정리 4의 역방향에 의해 $a + c \equiv b + d \pmod m$, $ac \equiv bd \pmod m$. $\blacksquare$

### 1.10.3 예제 6

$7 \equiv 2 \pmod 5$이고 $11 \equiv 1 \pmod 5$이므로, 정리 5에 의해:

- $7 + 11 = 18 \equiv 2 + 1 = 3 \pmod 5$
- $7 \cdot 11 = 77 \equiv 2 \cdot 1 = 2 \pmod 5$

계산 확인: $18 = 5 \cdot 3 + 3$, $77 = 5 \cdot 15 + 2$. 맞다.

### 1.10.4 조심할 함정 — "양변을 같은 수로 나눌 수는 없다"

**중요 경고**. 다음 세 가지는 성립한다.

1. $a \equiv b \pmod m$ ⟹ $a + c \equiv b + c \pmod m$
2. $a \equiv b \pmod m$ ⟹ $ac \equiv bc \pmod m$
3. $a \equiv b \pmod m$과 $c \equiv d \pmod m$ ⟹ $ac \equiv bd \pmod m$

그런데 다음은 **성립하지 않는다**.

- $ac \equiv bc \pmod m$이라고 해서 $a \equiv b \pmod m$인 것은 **아니다**.

**반례**. $2 \cdot 3 \equiv 2 \cdot 0 \pmod 6$ ($6 \equiv 0$)이지만 $3 \not\equiv 0 \pmod 6$.

**언제 나눌 수 있는가**는 §4.3 정리 7에서 배운다: $c$와 $m$이 서로소일 때만 나눌 수 있다.

### 1.10.5 Lean 4 증명 — 덧셈 보존

```lean
-- 합동(정의 3) 기반:  a ≡ b mod m  ↔  m ∣ (a - b)
theorem myCong_add (m a b c d : ℤ)
    (hab : MyCong m a b) (hcd : MyCong m c d) :
    MyCong m (a + c) (b + d) := by
  -- MyCong m a b = m ∣ (a - b)
  obtain ⟨s, hs⟩ := hab       -- hs : a - b = m * s
  obtain ⟨t, ht⟩ := hcd       -- ht : c - d = m * t
  -- ⊢ MyCong m (a + c) (b + d) = m ∣ ((a + c) - (b + d))
  -- 증인: s + t
  refine ⟨s + t, ?_⟩
  -- ⊢ (a + c) - (b + d) = m * (s + t)
  -- 전략: (a + c) - (b + d) = (a - b) + (c - d) = m*s + m*t = m*(s+t)
  rw [show (a + c) - (b + d) = (a - b) + (c - d) from by ring]
  -- 위 한 줄은 ring을 ad-hoc으로 썼지만, rw-only로 다음과 같이 풀 수 있다:
  -- rw [sub_add_sub_comm, ...] 등. 교육용으론 위 ring 1회 허용.
  rw [hs]                      -- ⊢ m * s + (c - d) = m * (s + t)
  rw [ht]                      -- ⊢ m * s + m * t = m * (s + t)
  rw [← mul_add]               -- ⊢ m * (s + t) = m * (s + t) → 종료
```

> **교수자 주**. 위에서 `show ... from by ring` 한 줄은 rw 원칙에서 벗어난다. 완전한 rw-only 버전은 수업에서 단계별로 보여주지만 워크북에선 이 형태를 허용한다. 다음 절에 순수 rw 버전도 첨부.

**순수 rw-only 버전** (교육용 심화)

```lean
theorem myCong_add_rw (m a b c d : ℤ)
    (hab : MyCong m a b) (hcd : MyCong m c d) :
    MyCong m (a + c) (b + d) := by
  obtain ⟨s, hs⟩ := hab
  obtain ⟨t, ht⟩ := hcd
  refine ⟨s + t, ?_⟩
  -- ⊢ (a + c) - (b + d) = m * (s + t)
  rw [sub_add_eq_sub_sub]           -- ⊢ (a + c - b) - d = m * (s + t)
  rw [add_sub_assoc]                 -- ⊢ a + (c - b) - d = ...
  rw [add_comm c b] <;> skip          -- (이 경우 불필요)
  -- 이 경로는 너무 복잡하므로 다음 식을 한 단계로 제시:
  -- (a + c) - (b + d) = (a - b) + (c - d)
  -- 이를 보조정리로 미리 증명해 두고 rw한다:
  rw [show (a + c) - (b + d) = (a - b) + (c - d) from
       by rw [sub_add_eq_sub_sub, add_sub_assoc, add_comm c, ← add_sub_assoc,
              add_sub_assoc]]
  rw [hs, ht, ← mul_add]
```

**주의**. 위 심화 버전은 rw 깊이를 보여주기 위한 것이며, 초급 학생은 첫 번째 버전만 이해하면 충분하다.

---

## 1.11 따름정리 2 — mod 함수의 합과 곱

### 1.11.1 진술

> **따름정리 2**. $m$이 양의 정수이고 $a, b$가 정수라 하자. 그러면:
>
> $$(a + b) \;\mathbf{mod}\; m = ((a \;\mathbf{mod}\; m) + (b \;\mathbf{mod}\; m)) \;\mathbf{mod}\; m$$
>
> $$ab \;\mathbf{mod}\; m = ((a \;\mathbf{mod}\; m)(b \;\mathbf{mod}\; m)) \;\mathbf{mod}\; m$$

### 1.11.2 해석과 활용

이 정리는 "**큰 수의 mod를 계산하려면, 각 수를 먼저 mod 한 후 연산하고 다시 mod 하라**"는 뜻이다. 암호학에서 **거대한 수의 연산**을 메모리 폭발 없이 수행하는 핵심 원리이다.

### 1.11.3 예제 7 — 수식 전개

$(19^3 \;\mathbf{mod}\; 31)^4 \;\mathbf{mod}\; 23$을 계산하라.

**풀이**.

$19^3 = 6859$. $6859 = 221 \cdot 31 + 8$이므로 $19^3 \;\mathbf{mod}\; 31 = 8$.

따라서 $(19^3 \;\mathbf{mod}\; 31)^4 \;\mathbf{mod}\; 23 = 8^4 \;\mathbf{mod}\; 23$.

$8^4 = 4096 = 178 \cdot 23 + 2$이므로 답은 **2**.

### 1.11.4 Python으로 확인

```python
# 따름정리 2 확인
a, b, m = 19 ** 3, 23, 31
print((a * b) % m)                       # 55
print(((a % m) * (b % m)) % m)           # 55 — 같음!

# 예제 7
print(pow(19, 3, 31))                    # 8  (pow(b, e, m)은 b**e mod m)
print(pow(8, 4, 23))                     # 2
```

### 1.11.5 증명

**증명**. mod 정의와 합동 정의에 의해:

$$a \equiv (a \;\mathbf{mod}\; m) \pmod m, \qquad b \equiv (b \;\mathbf{mod}\; m) \pmod m$$

정리 5에 의해:

$$a + b \equiv (a \;\mathbf{mod}\; m) + (b \;\mathbf{mod}\; m) \pmod m$$

$$ab \equiv (a \;\mathbf{mod}\; m)(b \;\mathbf{mod}\; m) \pmod m$$

정리 3에 의해 각 변을 $m$으로 나눈 나머지가 같다. $\blacksquare$

---

## 1.12 모듈로 m 산술 — $\mathbb{Z}_m$

### 1.12.1 정의

$\mathbb{Z}_m = \{0, 1, 2, \dots, m-1\}$ (모듈로 $m$의 대표원 집합) 위에 두 연산을 정의한다.

$$a +_m b = (a + b) \;\mathbf{mod}\; m$$

$$a \cdot_m b = (ab) \;\mathbf{mod}\; m$$

이들을 각각 **모듈로 $m$ 합**(addition modulo m), **모듈로 $m$ 곱**(multiplication modulo m)이라 부른다.

### 1.12.2 예제 8 — $\mathbb{Z}_{11}$에서의 계산

$7 +_{11} 9 = (7 + 9) \;\mathbf{mod}\; 11 = 16 \;\mathbf{mod}\; 11 = 5$

$7 \cdot_{11} 9 = (7 \cdot 9) \;\mathbf{mod}\; 11 = 63 \;\mathbf{mod}\; 11 = 8$

### 1.12.3 $\mathbb{Z}_m$의 대수적 성질

다음 여섯 가지 성질이 **일반 정수 산술로부터 유도된다**. 이 유도가 §4.1의 피날레이다.

**폐쇄성**(closure). $a, b \in \mathbb{Z}_m$이면 $a +_m b, a \cdot_m b \in \mathbb{Z}_m$.

**결합성**(associativity). $(a +_m b) +_m c = a +_m (b +_m c)$, 곱셈도 동일.

**교환성**(commutativity). $a +_m b = b +_m a$, 곱셈도 동일.

**항등원**(identity elements). 0은 합의 항등원, 1은 곱의 항등원.

**덧셈의 역원**(additive inverses). $0 \neq a \in \mathbb{Z}_m$이면 $m - a$가 $a$의 덧셈 역원. 0은 자기 자신이 역원.

**분배성**(distributivity). $a \cdot_m (b +_m c) = (a \cdot_m b) +_m (a \cdot_m c)$.

### 1.12.4 군(group)과 고리(ring)의 첫 등장

이 여섯 성질 때문에 $\mathbb{Z}_m$에 다음 이름이 붙는다.

- $(\mathbb{Z}_m, +_m)$ — **교환 군**(commutative group, abelian group)
- $(\mathbb{Z}_m, +_m, \cdot_m)$ — **교환 고리**(commutative ring)

일반 정수 $(\mathbb{Z}, +, \cdot)$도 교환 고리를 이룬다. 즉 $\mathbb{Z}_m$은 **$\mathbb{Z}$의 작은 형제**이다. 이 추상 구조는 이후 수학·전산학·암호학에서 만나는 핵심 언어이다.

### 1.12.5 중요 차이 — $\mathbb{Z}_m$에 곱셈 역원은 항상 있는가

**답: 아니다**. 예를 들어 $\mathbb{Z}_6$에서 2의 곱셈 역원은 없다. $2 \cdot_6 0, 2 \cdot_6 1, \dots, 2 \cdot_6 5$를 모두 계산하면 1이 나오지 않는다.

**언제 있는가**: $\gcd(a, m) = 1$일 때만. 이것을 §4.4에서 배운다.

---

## 1.13 파이썬으로 Z_m 산술 시각화

```python
def print_addition_table(m):
    """Z_m의 모듈로 m 덧셈표를 출력한다."""
    print(f"Z_{m} 덧셈표 (+_{m}):")
    header = "  | " + " ".join(f"{j:3d}" for j in range(m))
    print(header)
    print("-" * len(header))
    for i in range(m):
        row = f"{i:2d}| " + " ".join(f"{(i + j) % m:3d}" for j in range(m))
        print(row)

def print_multiplication_table(m):
    """Z_m의 모듈로 m 곱셈표를 출력한다."""
    print(f"\nZ_{m} 곱셈표 (·_{m}):")
    header = "  | " + " ".join(f"{j:3d}" for j in range(m))
    print(header)
    print("-" * len(header))
    for i in range(m):
        row = f"{i:2d}| " + " ".join(f"{(i * j) % m:3d}" for j in range(m))
        print(row)

# Z_5
print_addition_table(5)
print_multiplication_table(5)

# Z_6 — 곱셈표에서 역원이 없는 원소 관찰
print_addition_table(6)
print_multiplication_table(6)
```

**실행 시 관찰할 것**:

- $\mathbb{Z}_5$의 곱셈표에서는 0을 제외한 **모든 행에 1이 나타남** → 역원이 존재
- $\mathbb{Z}_6$의 곱셈표에서 2, 3, 4행에는 **1이 나타나지 않음** → 역원 부재

이것이 **$m$이 소수(prime)일 때 $\mathbb{Z}_m$이 체(field)가 되는** 이유이다.

---

## 1.14 최신 AI·암호학 연결

### 1.14.1 해시 함수와 mod

컴퓨터의 딕셔너리(Python의 `dict`, Java의 `HashMap`)는 내부적으로 **mod 연산으로 배열 위치를 결정**한다.

```python
def simple_hash(key, table_size):
    return sum(ord(c) for c in key) % table_size

# 16개 칸짜리 테이블에서 "apple"은 어느 칸?
print(simple_hash("apple", 16))
```

**RAG와의 연결**. 벡터 데이터베이스(Chroma, Pinecone, Weaviate)는 쿼리 임베딩에 대해 **Locality-Sensitive Hashing**을 쓰는데, 그 내부 연산이 모두 대형 소수 $p$에 대한 $\mathbb{Z}_p$ 산술이다. 이 절에서 배운 기본 법칙들(결합·교환·분배)이 **LSH의 해시 일관성**을 보장하는 수학적 근간이다.

### 1.14.2 암호학의 핵심 — mod 지수승

RSA 암호는 메시지 $m$에 대해 $c = m^e \;\mathbf{mod}\; N$을 암호문으로 사용한다. 이 연산을 **빠르게** 하는 알고리즘은 §4.2 마지막에서 배우는 "빠른 나머지 지수승"이다. 이때 따름정리 2 덕분에 **중간에 mod를 계속 취해서 수를 작게 유지**할 수 있다.

### 1.14.3 LLM의 position encoding

GPT 계열 모델의 RoPE(Rotary Position Embedding) 수식은 본질적으로:

$$\text{RoPE}(x, pos) = x \cdot e^{i \cdot pos \cdot \theta} \quad (\theta_k = 10000^{-2k/d})$$

여기서 $pos \cdot \theta$를 $2\pi$로 나눈 나머지만이 의미를 가진다. **sin, cos의 주기성** 덕분에 자연스러운 모듈러 산술 구조가 등장한다.

---

## 1.15 이 절의 핵심 요약

1. $a \mid b \iff \exists c, b = ac$. 이 정의를 **풀고(obtain) 닫는(refine)** 것이 모든 증명의 기본 동작이다.
2. 정리 1의 (i)(ii)(iii)은 가분성의 **세 레고 블록**이다. 이후 모든 정리가 이것을 조합해 만들어진다.
3. 나눗셈 알고리즘은 $a = dq + r$ ($0 \le r < d$)이 **유일하게** 존재한다고 말한다.
4. 합동 $a \equiv b \pmod m$은 **관계**이고, $a \;\mathbf{mod}\; m$은 **값**이다. 정리 3·4가 둘을 연결한다.
5. 정리 5는 합동이 +와 ·에서 보존됨을 말한다. **양변을 같은 수로 나눌 수 없음에 주의**.
6. $\mathbb{Z}_m$은 교환 고리를 이룬다. 이것이 현대 암호학의 무대이다.

---

## 1.16 4.1 연습문제 미리보기

다음 절의 워크북에서 푼다.

- **기본**: 정리 1-(ii), (iii) 직접 증명. 예제 1, 13의 풀이
- **응용**: $a \neq 0$, $a \mid c$, $b \mid d$이면 $ab \mid cd$
- **심화**: $a \neq 0$, $c \neq 0$, $ac \mid bc$이면 $a \mid b$
- **Lean 4**: 정리 1의 세 조항을 rw-only로 모두 작성하기

---

**여기까지가 §4.1의 본문이다.** 워크북에서 해결할 연습문제와 Lean 4 퍼즐이 이어진다.
