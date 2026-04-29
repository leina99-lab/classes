# §4.1 학생 워크북

## 로젠 이산수학 8판 — 가분성과 나머지 산술


---

## Section A — 정의 이해

### A1. 가분성 판정

다음 나눔 관계의 참/거짓을 판정하라. 참이면 증인 $c$(즉 $b = ac$의 $c$)를 제시하라.

| 문제 | 답 | 증인 $c$ |
|------|----|---------| 
| $3 \mid 18$ | ? | ? |
| $5 \mid 23$ | ? | ? |
| $-4 \mid 28$ | ? | ? |
| $17 \mid 0$ | ? | ? |
| $0 \mid 5$ | ? | ? |

<details>
<summary>정답 보기</summary>

| 문제 | 답 | 증인 $c$ |
|------|----|---------|
| $3 \mid 18$ | 참 | $c = 6$ ($18 = 3 \cdot 6$) |
| $5 \mid 23$ | 거짓 | $23 = 5c$인 정수 $c$ 없음 |
| $-4 \mid 28$ | 참 | $c = -7$ ($28 = -4 \cdot -7$) |
| $17 \mid 0$ | 참 | $c = 0$ ($0 = 17 \cdot 0$). 0은 모든 0 아닌 정수의 배수 |
| $0 \mid 5$ | **정의되지 않음** | 정의 1에서 $a \neq 0$ 필요 |

</details>

---

### A2. Rosen §4.1 연습문제 1 — $17 \mid ?$

다음의 수들은 17로 나누어 떨어지는가?

a) 68  b) 84  c) 357  d) 1001

<details>
<summary>정답 보기</summary>

- a) $68 = 17 \cdot 4$ → **참**
- b) $84 = 17 \cdot 4 + 16$ → **거짓**
- c) $357 = 17 \cdot 21$ → **참**
- d) $1001 = 17 \cdot 58 + 15$ → **거짓**

</details>

---

## Section B — 정리 1의 세 성질 증명

### B1. Rosen §4.1 연습문제 3 — 정리 1의 (ii) 증명

> $a \neq 0$, $a \mid b$이면 모든 정수 $c$에 대해 $a \mid bc$이다.

**수학 증명을 직접 완성하라**.

$a \mid b$이므로, 나눗셈 정의에 의해 $b = a \cdot \underline{\hspace{2em}}$인 정수 $\underline{\hspace{2em}}$가 존재한다.

그러면 $bc = (\underline{\hspace{2em}}) c = a \cdot (\underline{\hspace{2em}})$이다.

따라서 증인 $\underline{\hspace{2em}}$에 의해 $a \mid bc$. $\blacksquare$

<details>
<summary>정답 보기</summary>

$a \mid b$이므로, 나눗셈 정의에 의해 $b = a \cdot \mathbf{s}$인 정수 $\mathbf{s}$가 존재한다.

그러면 $bc = (\mathbf{as}) c = a \cdot (\mathbf{sc})$이다. (결합법칙)

따라서 증인 $\mathbf{sc}$에 의해 $a \mid bc$. $\blacksquare$

</details>

---

### B2. Lean 4로 정리 1-(ii) 완성하기

```lean
theorem dvd_mul_right_exercise (a b : ℤ) (hab : a ∣ b) (c : ℤ) :
    a ∣ (b * c) := by
  obtain ⟨s, hs⟩ := hab     -- hs : b = a * s
  refine ⟨____, ?_⟩          -- ★ 빈칸 1: 증인 제시
  -- ⊢ b * c = a * (____)
  rw [____]                   -- ★ 빈칸 2: 치환
  -- ⊢ a * s * c = a * (s * c)
  rw [____]                   -- ★ 빈칸 3: 결합법칙
  -- ⊢ a * (s * c) = a * (s * c) → 종료
```

<details>
<summary>정답 보기</summary>

```lean
theorem dvd_mul_right_exercise (a b : ℤ) (hab : a ∣ b) (c : ℤ) :
    a ∣ (b * c) := by
  obtain ⟨s, hs⟩ := hab
  refine ⟨s * c, ?_⟩          -- 빈칸 1: s * c
  rw [hs]                      -- 빈칸 2: hs
  rw [mul_assoc]               -- 빈칸 3: mul_assoc
```

**InfoView 추적**:
```
[시작]            ⊢ a ∣ (b * c)
[obtain 후]        s : ℤ,  hs : b = a * s
                   ⊢ a ∣ (b * c)
[refine 후]        ⊢ b * c = a * (s * c)
[rw [hs] 후]       ⊢ a * s * c = a * (s * c)
[rw [mul_assoc] 후] ⊢ a * (s * c) = a * (s * c) → 종료
```

</details>

---

### B3. Rosen §4.1 연습문제 4 — 정리 1의 (iii) 증명 (연쇄 나눔)

> $a \neq 0$, $a \mid b$이고 $b \mid c$이면 $a \mid c$이다.

**수학 증명**.

$a \mid b$에서 $b = a \cdot \underline{\hspace{2em}}$인 정수 $\underline{\hspace{2em}}$이 존재한다.

$b \mid c$에서 $c = b \cdot \underline{\hspace{2em}}$인 정수 $\underline{\hspace{2em}}$가 존재한다.

따라서 $c = b \cdot t = (\underline{\hspace{2em}}) \cdot t = a \cdot (\underline{\hspace{2em}})$.

증인 $\underline{\hspace{2em}}$에 의해 $a \mid c$. $\blacksquare$

<details>
<summary>정답 보기</summary>

$a \mid b$에서 $b = a \cdot \mathbf{s}$인 정수 $\mathbf{s}$가 존재한다.

$b \mid c$에서 $c = b \cdot \mathbf{t}$인 정수 $\mathbf{t}$가 존재한다.

따라서 $c = b \cdot t = (\mathbf{as}) \cdot t = a \cdot (\mathbf{st})$. (결합법칙)

증인 $\mathbf{st}$에 의해 $a \mid c$. $\blacksquare$

</details>

---

### B4. Lean 4로 정리 1-(iii) 완성하기

```lean
theorem dvd_trans_exercise (a b c : ℤ) (hab : a ∣ b) (hbc : b ∣ c) :
    a ∣ c := by
  obtain ⟨s, hs⟩ := hab       -- hs : b = a * s
  obtain ⟨t, ht⟩ := hbc       -- ht : c = b * t
  refine ⟨____, ?_⟩            -- ★ 빈칸 1: 증인
  -- ⊢ c = a * (____)
  rw [____]                     -- ★ 빈칸 2: c를 b*t로
  -- ⊢ b * t = a * (s * t)
  rw [____]                     -- ★ 빈칸 3: b를 a*s로
  -- ⊢ a * s * t = a * (s * t)
  rw [____]                     -- ★ 빈칸 4: 결합법칙
```

<details>
<summary>정답 보기</summary>

```lean
theorem dvd_trans_exercise (a b c : ℤ) (hab : a ∣ b) (hbc : b ∣ c) :
    a ∣ c := by
  obtain ⟨s, hs⟩ := hab
  obtain ⟨t, ht⟩ := hbc
  refine ⟨s * t, ?_⟩            -- 빈칸 1: s * t
  rw [ht]                       -- 빈칸 2: ht
  rw [hs]                       -- 빈칸 3: hs
  rw [mul_assoc]                -- 빈칸 4: mul_assoc
```

</details>

---

## Section C — 따름정리 1 응용

### C1. Rosen §4.1 연습문제 5 — 서로 나누면 같음(부호 차이)

> $a$와 $b$가 정수일 때 $a \mid b$이고 $b \mid a$이면, $a = b$ 또는 $a = -b$임을 증명하라.

**수학 증명을 완성하라**.

**전제 정리 확인**. $a \mid b$이면 $|a| \le |b|$ (단 $b \neq 0$). [이 사실은 별도 보조 정리로 필요]

$a \mid b$ 그리고 $b \mid a$라 하자.

- 만약 $a = 0$이면 $a \mid b$에서 $b = 0 \cdot c = 0$. 따라서 $a = b = 0$.
- $a \neq 0$일 때: $a \mid b$에서 $b = a \cdot s$, $b \mid a$에서 $a = b \cdot t$. 치환하면 $a = (as)t = a(st)$. $a \neq 0$이므로 $st = \underline{\hspace{2em}}$. 정수 $s, t$가 곱이 1이려면 $(s, t) = (\underline{\hspace{2em}}, \underline{\hspace{2em}})$ 또는 $(\underline{\hspace{2em}}, \underline{\hspace{2em}})$. 따라서 $b = \underline{\hspace{2em}}$ 또는 $b = \underline{\hspace{2em}}$.

<details>
<summary>정답 보기</summary>

$a \neq 0$일 때: $a = a(st)$, $a \neq 0$이므로 $\mathbf{st = 1}$.

정수에서 $st = 1$이려면 $(s, t) = (\mathbf{1, 1})$ 또는 $(\mathbf{-1, -1})$.

- $(s, t) = (1, 1)$이면 $b = a \cdot 1 = a$.
- $(s, t) = (-1, -1)$이면 $b = a \cdot (-1) = -a$, 즉 $a = -b$.

$\blacksquare$

</details>

---

### C2. Rosen §4.1 연습문제 11 — 3 연속수와 3의 배수

> $a$가 3으로 나누어 떨어지지 않는 정수라면, $(a+1)(a+2)$가 3의 배수임을 증명하라.

**힌트**. 나눗셈 알고리즘으로 $a = 3q + r$ ($r \in \{0, 1, 2\}$). $r = 0$은 가정 위반.

<details>
<summary>정답 보기</summary>

**증명**. 나눗셈 알고리즘에 의해 $a = 3q + r$, $r \in \{0, 1, 2\}$. 가정 $3 \nmid a$에서 $r \neq 0$. 

**경우 1**. $r = 1$. 그러면 $a + 2 = 3q + 3 = 3(q+1)$이므로 $3 \mid (a+2)$. 정리 1-(ii)에 의해 $3 \mid (a+1)(a+2)$.

**경우 2**. $r = 2$. 그러면 $a + 1 = 3q + 3 = 3(q+1)$이므로 $3 \mid (a+1)$. 정리 1-(ii)에 의해 $3 \mid (a+1)(a+2)$.

어느 경우든 $3 \mid (a+1)(a+2)$. $\blacksquare$

</details>

---

## Section D — 나눗셈 알고리즘

### D1. Rosen §4.1 연습문제 13 — 몫과 나머지

다음 연산의 몫과 나머지를 구하라 ($q = a \;\mathbf{div}\; d$, $r = a \;\mathbf{mod}\; d$).

| $a$ | $d$ | $q$ | $r$ |
|-----|-----|-----|-----|
| 19 | 7 | ? | ? |
| $-111$ | 11 | ? | ? |
| 789 | 23 | ? | ? |
| 1001 | 13 | ? | ? |
| $-1$ | 3 | ? | ? |

<details>
<summary>정답 보기</summary>

| $a$ | $d$ | $q$ | $r$ | 계산 |
|-----|-----|-----|-----|------|
| 19 | 7 | 2 | 5 | $19 = 7 \cdot 2 + 5$ |
| $-111$ | 11 | $-11$ | 10 | $-111 = 11 \cdot (-11) + 10$ |
| 789 | 23 | 34 | 7 | $789 = 23 \cdot 34 + 7$ |
| 1001 | 13 | 77 | 0 | $1001 = 13 \cdot 77$ |
| $-1$ | 3 | $-1$ | 2 | $-1 = 3 \cdot (-1) + 2$ |

**음수의 함정**: $-111 = 11 \cdot (-10) - 1$은 $r = -1 < 0$이라 위반. $-111 = 11 \cdot (-11) + 10$이 정답.

</details>

---

### D2. Rosen §4.1 연습문제 15 — 12시간 시계

12시간 시계를 사용하면 다음 시간은 몇 시가 되는가?

a) 11시부터 80시간 후  
b) 12시로부터 40시간 후  
c) 6시로부터 100시간 후

<details>
<summary>정답 보기</summary>

12시간 시계이므로 mod 12 연산.

a) $(11 + 80) \;\mathbf{mod}\; 12 = 91 \;\mathbf{mod}\; 12 = 7$ → **7시**

b) $(12 + 40) \;\mathbf{mod}\; 12 = 52 \;\mathbf{mod}\; 12 = 4$ → **4시**

c) $(6 + 100) \;\mathbf{mod}\; 12 = 106 \;\mathbf{mod}\; 12 = 10$ → **10시**

</details>

---

## Section E — 합동

### E1. Rosen §4.1 연습문제 34 — 모듈로 7 합동 판정

다음 정수가 3 modulo 7과 합동인지 판정하라.

a) 37  b) 66  c) $-17$  d) $-67$

<details>
<summary>정답 보기</summary>

합동 조건: $7 \mid (x - 3)$, 또는 $x \;\mathbf{mod}\; 7 = 3$.

a) $37 \;\mathbf{mod}\; 7 = 2$ → **아니다**.
b) $66 \;\mathbf{mod}\; 7 = 3$ ($66 = 7 \cdot 9 + 3$) → **맞다**.
c) $-17 \;\mathbf{mod}\; 7 = 4$ ($-17 = 7 \cdot (-3) + 4$) → **아니다**.
d) $-67 \;\mathbf{mod}\; 7 = 3$ ($-67 = 7 \cdot (-10) + 3$) → **맞다**.

</details>

---

### E2. Rosen §4.1 연습문제 36 — mod 연산

계산하라.

a) $(177 \;\mathbf{mod}\; 31 + 270 \;\mathbf{mod}\; 31) \;\mathbf{mod}\; 31$  
b) $(177 \;\mathbf{mod}\; 31 \cdot 270 \;\mathbf{mod}\; 31) \;\mathbf{mod}\; 31$

<details>
<summary>정답 보기</summary>

먼저 $177 \;\mathbf{mod}\; 31$: $177 = 31 \cdot 5 + 22$ → 22.
$270 \;\mathbf{mod}\; 31$: $270 = 31 \cdot 8 + 22$ → 22.

a) $(22 + 22) \;\mathbf{mod}\; 31 = 44 \;\mathbf{mod}\; 31 = 13$.

b) $(22 \cdot 22) \;\mathbf{mod}\; 31 = 484 \;\mathbf{mod}\; 31$. $484 = 31 \cdot 15 + 19$. → **19**.

**검증 (따름정리 2)**: $(177 + 270) \;\mathbf{mod}\; 31 = 447 \;\mathbf{mod}\; 31 = 447 - 14 \cdot 31 = 447 - 434 = 13$. 일치!

</details>

---

### E3. Lean 4 연습 — 합동 정리 4의 역방향 (←)

다음을 완성하라. 우리의 합동 정의는 `MyCong m a b := m ∣ (a - b)`.

```lean
-- (←) 방향: ∃ k, a = b + k * m → MyCong m a b
theorem myCong_of_exists (m a b : ℤ) (h : ∃ k, a = b + k * m) :
    MyCong m a b := by
  obtain ⟨k, hk⟩ := h           -- hk : a = b + k * m
  refine ⟨____, ?_⟩              -- ★ 빈칸 1: 증인
  -- ⊢ a - b = m * k
  rw [____]                       -- ★ 빈칸 2: a를 b + k*m로
  -- ⊢ b + k * m - b = m * k
  rw [____]                       -- ★ 빈칸 3: (b + x) - b = x
  -- ⊢ k * m = m * k
  rw [____]                       -- ★ 빈칸 4: 교환법칙
```

<details>
<summary>정답 보기</summary>

```lean
theorem myCong_of_exists (m a b : ℤ) (h : ∃ k, a = b + k * m) :
    MyCong m a b := by
  obtain ⟨k, hk⟩ := h
  refine ⟨k, ?_⟩                  -- 빈칸 1: k
  rw [hk]                          -- 빈칸 2: hk
  rw [add_sub_cancel_left]         -- 빈칸 3: add_sub_cancel_left
  rw [mul_comm]                    -- 빈칸 4: mul_comm
```

</details>

---

## Section F — 정리 5 응용

### F1. 모듈로 7 산술표 채우기

$7 \equiv 0 \pmod 7$, $8 \equiv 1 \pmod 7$, …

| $a$ | $a \;\mathbf{mod}\; 7$ | $a^2 \;\mathbf{mod}\; 7$ | $a^3 \;\mathbf{mod}\; 7$ |
|-----|------------------------|--------------------------|--------------------------|
| 0 | ? | ? | ? |
| 1 | ? | ? | ? |
| 2 | ? | ? | ? |
| 3 | ? | ? | ? |
| 4 | ? | ? | ? |
| 5 | ? | ? | ? |
| 6 | ? | ? | ? |

<details>
<summary>정답 보기</summary>

| $a$ | $a \;\mathbf{mod}\; 7$ | $a^2 \;\mathbf{mod}\; 7$ | $a^3 \;\mathbf{mod}\; 7$ |
|-----|--|--|--|
| 0 | 0 | 0 | 0 |
| 1 | 1 | 1 | 1 |
| 2 | 2 | 4 | 1 |
| 3 | 3 | 2 | 6 |
| 4 | 4 | 2 | 1 |
| 5 | 5 | 4 | 6 |
| 6 | 6 | 1 | 6 |

**관찰**: $a^3 \in \{0, 1, 6\}$만 나타난다. 이것이 §4.4 페르마의 작은 정리의 전조이다!

</details>

---

### F2. Rosen §4.1 연습문제 44 — $n^2 \;\mathbf{mod}\; 4$

> $n$이 정수이면 $n^2 \equiv 0$ 또는 $n^2 \equiv 1 \pmod 4$임을 증명하라.

<details>
<summary>정답 보기</summary>

**증명**. 경우 분류.

**경우 1**. $n$이 짝수. $n = 2k$인 정수 $k$ 존재. 그러면 $n^2 = 4k^2$, 즉 $4 \mid n^2$, 즉 $n^2 \equiv 0 \pmod 4$.

**경우 2**. $n$이 홀수. $n = 2k + 1$인 정수 $k$ 존재. 그러면
$$n^2 = (2k+1)^2 = 4k^2 + 4k + 1 = 4(k^2 + k) + 1$$
따라서 $n^2 \equiv 1 \pmod 4$.

어느 경우든 $n^2 \equiv 0$ 또는 $1 \pmod 4$. $\blacksquare$

**응용**: 이 결과는 §4.1 연습문제 45에서 "$4k+3$ 꼴 소수는 두 정수 제곱의 합이 아님"을 증명하는 데 쓰인다.

</details>

---

## Section G — 자유 증명 (Lean 4 완전 자유)

### G1. 정리 1의 (i) 자유 증명

가정 `hab : a ∣ b`, `hac : a ∣ c`로부터 `a ∣ (b + c)`를 **rw만 써서** 증명하라. 빈칸 없음, 전체를 당신이 작성.

<details>
<summary>정답 보기</summary>

```lean
theorem dvd_add_free (a b c : ℤ) (hab : a ∣ b) (hac : a ∣ c) :
    a ∣ (b + c) := by
  obtain ⟨s, hs⟩ := hab
  obtain ⟨t, ht⟩ := hac
  refine ⟨s + t, ?_⟩
  rw [hs]
  rw [ht]
  rw [← mul_add]
```

</details>

---

### G2. 3 연속수의 곱은 6의 배수

> 임의의 정수 $n$에 대해, $n(n+1)(n+2)$는 6의 배수임을 증명하라.

(수학 증명만; Lean 증명은 복잡함)

<details>
<summary>정답 보기</summary>

**증명**. $6 = 2 \cdot 3$이고 $\gcd(2, 3) = 1$이므로, $2 \mid n(n+1)(n+2)$와 $3 \mid n(n+1)(n+2)$를 각각 보이면 충분하다.

**2로 나누어 떨어짐**. $n, n+1$ 중 하나는 짝수이다(나눗셈 알고리즘). 따라서 $2 \mid n(n+1)$, 정리 1-(ii)에 의해 $2 \mid n(n+1)(n+2)$.

**3으로 나누어 떨어짐**. 나눗셈 알고리즘: $n = 3q + r$, $r \in \{0, 1, 2\}$.
- $r = 0$: $3 \mid n$, 따라서 $3 \mid n(n+1)(n+2)$.
- $r = 1$: $n + 2 = 3q + 3 = 3(q+1)$, 따라서 $3 \mid (n+2)$, 따라서 $3 \mid n(n+1)(n+2)$.
- $r = 2$: $n + 1 = 3q + 3 = 3(q+1)$, 따라서 $3 \mid (n+1)$, 따라서 $3 \mid n(n+1)(n+2)$.

어느 경우든 $3 \mid n(n+1)(n+2)$. 2와 3이 모두 나누므로 $6 \mid n(n+1)(n+2)$. $\blacksquare$

</details>

---

## Section H — Python 실습

### H1. 모듈로 m 덧셈표 구현

다음 함수를 완성하라.

```python
def make_addition_table(m):
    """mod m 덧셈표를 2차원 리스트로 반환."""
    # TODO
    pass

# 예: make_addition_table(4) ==
# [[0, 1, 2, 3],
#  [1, 2, 3, 0],
#  [2, 3, 0, 1],
#  [3, 0, 1, 2]]
```

<details>
<summary>정답 보기</summary>

```python
def make_addition_table(m):
    return [[(i + j) % m for j in range(m)] for i in range(m)]

# 검증
for row in make_addition_table(4):
    print(row)
# 출력:
# [0, 1, 2, 3]
# [1, 2, 3, 0]
# [2, 3, 0, 1]
# [3, 0, 1, 2]
```

</details>

---

### H2. 역원 탐색

$\mathbb{Z}_{11}$에서 $a \cdot b \equiv 1 \pmod{11}$인 $b$를 모든 $a \in \{1, \dots, 10\}$에 대해 찾아라.

<details>
<summary>정답 보기</summary>

```python
m = 11
for a in range(1, m):
    for b in range(1, m):
        if (a * b) % m == 1:
            print(f"{a}^{-1} ≡ {b} (mod {m})")
            break

# 출력:
# 1^-1 ≡ 1 (mod 11)
# 2^-1 ≡ 6 (mod 11)   (2·6 = 12 = 11 + 1)
# 3^-1 ≡ 4 (mod 11)   (3·4 = 12)
# 4^-1 ≡ 3 (mod 11)
# 5^-1 ≡ 9 (mod 11)   (5·9 = 45 = 44 + 1)
# 6^-1 ≡ 2 (mod 11)
# 7^-1 ≡ 8 (mod 11)   (7·8 = 56 = 55 + 1)
# 8^-1 ≡ 7 (mod 11)
# 9^-1 ≡ 5 (mod 11)
# 10^-1 ≡ 10 (mod 11) (10·10 = 100 = 99 + 1)
```

**관찰**: $\mathbb{Z}_{11}$의 0이 아닌 모든 원소에 곱셈 역원이 존재한다. 이것은 11이 소수이기 때문이다 (§4.3).

</details>

---

## 채점 기준

- **Section A, D**: 각 문제 2점, 총 14점
- **Section B, C**: 각 증명 5점, 총 20점
- **Section E**: 각 문제 3점, 총 15점
- **Section F**: 각 문제 5점, 총 10점
- **Section G**: 각 자유 증명 10점, 총 20점
- **Section H**: 각 실습 10점, 총 20점

**총 100점**. 90점 이상 우수, 70점 이상 이해 양호, 50점 이상 보완 필요.
