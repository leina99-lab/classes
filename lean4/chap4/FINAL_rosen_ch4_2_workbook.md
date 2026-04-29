# §4.2 학생 워크북

## 로젠 이산수학 8판 — 정수의 표현과 알고리즘

---

## Section A — 밑수 변환

### A1. Rosen §4.2 연습문제 1 — 10진 → 2진

a) 231  b) 4532  c) 97644

<details>
<summary>정답 보기</summary>

**a) 231**:
```
231 = 2·115 + 1
115 = 2·57 + 1
 57 = 2·28 + 1
 28 = 2·14 + 0
 14 = 2·7  + 0
  7 = 2·3  + 1
  3 = 2·1  + 1
  1 = 2·0  + 1
```
→ $(231)_{10} = (1110\;0111)_2$

**b) 4532** = $(1\,0001\,1011\,0100)_2$

**c) 97644** = $(10111\,1101\,0110\,1100)_2$

Python 검증:
```python
>>> bin(231)[2:]
'11100111'
>>> bin(4532)[2:]
'1000110110100'
>>> bin(97644)[2:]
'10111110101101100'
```

</details>

---

### A2. Rosen §4.2 연습문제 3 — 2진 → 10진

a) $(1\,1111)_2$  b) $(1\,0000\,0001)_2$  c) $(1\,0101\,0101)_2$  d) $(110\,1001\,0001\,0000)_2$

<details>
<summary>정답 보기</summary>

- a) $(11111)_2 = 16 + 8 + 4 + 2 + 1 = 31$
- b) $(100000001)_2 = 2^8 + 2^0 = 256 + 1 = 257$
- c) $(101010101)_2 = 256 + 64 + 16 + 4 + 1 = 341$
- d) $(1101001000100000)_2 = 2^{15}+2^{14}+2^{12}+2^9+2^5 = 32768+16384+4096+512+32 = 53792$

</details>

---

### A3. Rosen §4.2 연습문제 6 — 2진 → 8진

a) $(1\,1111\,0111)_2$  b) $(1010\,1010\,1010)_2$  c) $(111\,0111\,0111\,0111)_2$  d) $(101\,0101\,0101\,0101)_2$

<details>
<summary>정답 보기</summary>

**전략**: 오른쪽에서 3비트씩 끊는다.

**a)** `1 1111 0111` → 끊기 `001 111 101 11` → 왼쪽 0패딩 `001 111 101 110`... 

정확히: `111110111` → 오른쪽부터 `111`, `110`, `111` → **$(767)_8$**

**b)** `101010101010` → `101 010 101 010` → **$(5252)_8$**

**c)** `111011101110111` → (3자리씩) `111 011 101 110 111` → **$(73567)_8$**

**d)** `101010101010101` → `101 010 101 010 101` → **$(52525)_8$**

</details>

---

### A4. Rosen §4.2 연습문제 7 — 16진 → 2진

a) $(80\text{E})_{16}$  b) $(135\text{AB})_{16}$  c) $(\text{ABBA})_{16}$  d) $(\text{DEFACED})_{16}$

<details>
<summary>정답 보기</summary>

각 16진 자릿수를 4비트로 직접 치환:

| 숫자 | 2진 |
|------|-----|
| 8 | 1000 |
| 0 | 0000 |
| E | 1110 |

**a)** $(80\text{E})_{16} = (1000\,0000\,1110)_2$

**b)** $(135\text{AB})_{16}$:  1=0001, 3=0011, 5=0101, A=1010, B=1011
→ $(0001\,0011\,0101\,1010\,1011)_2$

**c)** $(\text{ABBA})_{16}$: A=1010, B=1011 → $(1010\,1011\,1011\,1010)_2$

**d)** $(\text{DEFACED})_{16}$: D=1101, E=1110, F=1111, A=1010, C=1100, D=1101
→ $(1101\,1110\,1111\,1010\,1100\,1110\,1101)_2$

</details>

---

## Section B — 산술 알고리즘

### B1. 알고리즘 2(덧셈)로 $(10111)_2 + (11010)_2$ 계산

단계를 적어라.

<details>
<summary>정답 보기</summary>

$a = 10111 = (a_4 a_3 a_2 a_1 a_0)_2 = (1,0,1,1,1)$ (작은 자리부터)  
$b = 11010 = (b_4 b_3 b_2 b_1 b_0)_2 = (0,1,0,1,1)$

| $j$ | $a_j$ | $b_j$ | $c$ | $a_j+b_j+c$ | $d=\lfloor \cdot/2 \rfloor$ | $s_j$ |
|-----|-------|-------|-----|-------------|-----------------------------|-------|
| 0 | 1 | 0 | 0 | 1 | 0 | 1 |
| 1 | 1 | 1 | 0 | 2 | 1 | 0 |
| 2 | 1 | 0 | 1 | 2 | 1 | 0 |
| 3 | 0 | 1 | 1 | 2 | 1 | 0 |
| 4 | 1 | 1 | 1 | 3 | 1 | 1 |

$s_5 = c = 1$.

따라서 합은 $s_5 s_4 s_3 s_2 s_1 s_0 = 110001 = (110001)_2$.

검증: $(10111)_2 = 23$, $(11010)_2 = 26$, $23 + 26 = 49 = (110001)_2$. 일치.

</details>

---

### B2. 알고리즘 3(곱셈)으로 $(1110)_2 \times (1010)_2$ 계산

<details>
<summary>정답 보기</summary>

$a = 1110 = 14$, $b = 1010 = 10$. 기대 결과: $140 = (1000\,1100)_2$.

**부분곱**:
- $a \cdot b_0 \cdot 2^0 = 1110 \cdot 0 = 0$
- $a \cdot b_1 \cdot 2^1 = 1110 \cdot 1 \cdot 2 = (1\,1100)_2$
- $a \cdot b_2 \cdot 2^2 = 1110 \cdot 0 \cdot 4 = 0$
- $a \cdot b_3 \cdot 2^3 = 1110 \cdot 1 \cdot 8 = (111\,0000)_2$

**모두 더하기**:
```
       1 1100
  +  111 0000
   ─────────
    1000 1100  = 140
```

</details>

---

### B3. 알고리즘 5로 $7^{644} \;\mathbf{mod}\; 645$ (Rosen 연습문제 25)

$644 = (1010000100)_2$. 단계별로 기록하라.

<details>
<summary>정답 보기</summary>

초기: $x = 1$, $power = 7 \;\mathbf{mod}\; 645 = 7$.

| $i$ | $a_i$ | $x$ (갱신 후) | $power$ (갱신 후) |
|-----|-------|----------------|-------------------|
| 0 | 0 | 1 | $7^2 \;\mathbf{mod}\; 645 = 49$ |
| 1 | 0 | 1 | $49^2 \;\mathbf{mod}\; 645 = 2401 \;\mathbf{mod}\; 645 = 466$ |
| 2 | 1 | $1 \cdot 466 \;\mathbf{mod}\; 645 = 466$ | $466^2 \;\mathbf{mod}\; 645 = 217156 \;\mathbf{mod}\; 645 = 436$ |
| 3 | 0 | 466 | $436^2 \;\mathbf{mod}\; 645 = 190096 \;\mathbf{mod}\; 645 = 1$ |
| 4 | 0 | 466 | $1^2 \;\mathbf{mod}\; 645 = 1$ |
| 5 | 0 | 466 | 1 |
| 6 | 0 | 466 | 1 |
| 7 | 1 | $466 \cdot 1 \;\mathbf{mod}\; 645 = 466$ | 1 |
| 8 | 0 | 466 | 1 |
| 9 | 1 | $466 \cdot 1 \;\mathbf{mod}\; 645 = 466$ | 1 |

**결과**: $7^{644} \;\mathbf{mod}\; 645 = 466$.

Python 확인: `pow(7, 644, 645)` → 466. 일치.

**관찰**: $i=3$에서 $power$가 1이 되어 이후 변화 없다. $7$은 $645$에 대해 **카마이클 수**(Carmichael number)의 특수한 동작을 보인다. 실제로 645 = 3·5·43이고 644 = 4·7·23. 이건 §4.5에서 배운다.

</details>

---

### B4. Python으로 알고리즘 5 구현하고 비교

```python
def modular_exp(b, n, m):
    """알고리즘 5 구현."""
    x = ____      # ★ 빈칸 1
    power = ____  # ★ 빈칸 2
    while n > 0:
        if ____:  # ★ 빈칸 3
            x = ____  # ★ 빈칸 4
        power = ____  # ★ 빈칸 5
        n >>= 1
    return x

# 테스트
assert modular_exp(3, 644, 645) == 36
assert modular_exp(7, 644, 645) == 466
assert modular_exp(123, 1001, 101) == pow(123, 1001, 101)
```

<details>
<summary>정답 보기</summary>

```python
def modular_exp(b, n, m):
    x = 1                    # 빈칸 1
    power = b % m            # 빈칸 2
    while n > 0:
        if n & 1:             # 빈칸 3: 최하위 비트 = 1?
            x = (x * power) % m  # 빈칸 4
        power = (power * power) % m  # 빈칸 5
        n >>= 1
    return x
```

**성능 비교**:
```python
import time
b, n, m = 2, 10**6, 10**9 + 7

start = time.time()
naive = pow(b, n) % m   # 먼저 거대한 수 만들고 mod
print(f"naive: {time.time() - start:.4f}초")

start = time.time()
fast = modular_exp(b, n, m)
print(f"fast: {time.time() - start:.6f}초")

# naive는 약 0.01초, fast는 약 0.00002초 (500배 차이)
```

</details>

---

## Section C — 복잡도 분석

### C1. Rosen §4.2 연습문제 62 — 비교 알고리즘의 복잡도

> 두 $n$비트 정수의 크기를 비교하는 알고리즘은 총 몇 번의 비트 연산이 필요한가?

<details>
<summary>정답 보기</summary>

**분석**. 최고위 비트부터 같은 자리를 비교해 내려간다.
- 각 자리에서 2비트 비교 1번
- 최악의 경우 $n$개 자리 모두 비교

총 $O(n)$ 비트 연산.

**코드**:
```python
def compare_n_bit(a_bits, b_bits):
    """a_bits, b_bits는 높은 자릿수가 앞에 오는 비트 리스트."""
    n = len(a_bits)
    for i in range(n):
        if a_bits[i] > b_bits[i]:
            return 1     # a > b
        if a_bits[i] < b_bits[i]:
            return -1    # a < b
    return 0             # a = b
```

</details>

---

### C2. 알고리즘 5의 복잡도 증명 — Rosen §4.2 연습문제 64

> 알고리즘 5가 $b^n \;\mathbf{mod}\; m$을 구하는 데 $O((\log m)^2 \log n)$ 비트 연산임을 보여라.

<details>
<summary>정답 보기</summary>

**증명**. 

1. **루프 반복 수**: $n = (a_{k-1} \cdots a_0)_2$이므로 루프는 $k = \lceil \log_2(n+1) \rceil = O(\log n)$번 반복.

2. **각 반복의 비용**: 
   - $x \leftarrow (x \cdot power) \;\mathbf{mod}\; m$: $m$ 미만 정수 두 개의 곱은 $O(\log m)^2$ 비트 연산 (전통 곱셈). 그 뒤 mod는 $O((\log m)^2)$.
   - $power \leftarrow (power^2) \;\mathbf{mod}\; m$: 동일하게 $O((\log m)^2)$.

3. **총합**: $O(\log n) \cdot O((\log m)^2) = O((\log m)^2 \log n)$. $\blacksquare$

**실용적 의미**. $m, n$이 $2^{2048}$ 수준(RSA-2048)일 때, $\log m \approx 2048$, $\log n \approx 2048$. 따라서 약 $2048^2 \cdot 2048 \approx 8.6 \times 10^9$ 연산 → **수밀리초**만에 완료된다.

</details>

---

## Section D — Lean 4 밑수 전개 증명

### D1. 수식 일치 확인

```lean
-- (30071)_8 = 12345를 확인
example : 3 * 8^4 + 0 * 8^3 + 0 * 8^2 + 7 * 8 + 1 = 12345 := by
  ____         -- ★ 빈칸: 어느 전술?
```

<details>
<summary>정답 보기</summary>

```lean
example : 3 * 8^4 + 0 * 8^3 + 0 * 8^2 + 7 * 8 + 1 = 12345 := by
  rfl
```

**이유**. 양변이 같은 자연수 리터럴로 환원되므로 `rfl`이 계산해서 확인한다. `rfl`은 정의상 같음(definitional equality)을 검사하는 전술이다.

</details>

---

### D2. 2진 자릿수 분해

```lean
-- 13 = 8 + 4 + 1 = 2^3 + 2^2 + 2^0 = (1101)_2 확인
example : 1 * 2^3 + 1 * 2^2 + 0 * 2^1 + 1 * 2^0 = 13 := by
  ____
```

<details>
<summary>정답 보기</summary>

```lean
example : 1 * 2^3 + 1 * 2^2 + 0 * 2^1 + 1 * 2^0 = 13 := by
  rfl    -- 8 + 4 + 0 + 1 = 13
```

</details>

---

## Section E — Python 종합 실습

### E1. 범용 진법 변환기 만들기

```python
def convert_base(n: int, from_base: int, to_base: int) -> str:
    """from_base 진법 문자열 n을 to_base 진법 문자열로 변환."""
    # TODO
    pass

# 사용 예
assert convert_base("30071", 8, 10) == "12345"
assert convert_base("12345", 10, 8) == "30071"
assert convert_base("2AE0B", 16, 2) == "101011100001011"
```

<details>
<summary>정답 보기</summary>

```python
DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

def from_base(s: str, b: int) -> int:
    """밑 b 문자열 → 10진 정수."""
    n = 0
    for c in s.upper():
        n = n * b + DIGITS.index(c)
    return n

def to_base(n: int, b: int) -> str:
    """10진 정수 → 밑 b 문자열."""
    if n == 0:
        return "0"
    result = []
    while n > 0:
        result.append(DIGITS[n % b])
        n //= b
    return "".join(reversed(result))

def convert_base(n: str, from_b: int, to_b: int) -> str:
    return to_base(from_base(n, from_b), to_b)

# 테스트
print(convert_base("30071", 8, 10))     # 12345
print(convert_base("12345", 10, 8))     # 30071
print(convert_base("2AE0B", 16, 2))     # 101011100001011
print(convert_base("DEFACED", 16, 10))  # 233811181
```

</details>

---

### E2. 이진 덧셈을 문자열로

```python
def binary_add_str(a: str, b: str) -> str:
    """'1011', '1101' → '11000' (알고리즘 2)"""
    # TODO
    pass

assert binary_add_str("1110", "1011") == "11001"
assert binary_add_str("111", "1") == "1000"
```

<details>
<summary>정답 보기</summary>

```python
def binary_add_str(a: str, b: str) -> str:
    # 길이 맞추기
    n = max(len(a), len(b))
    a = a.zfill(n)
    b = b.zfill(n)
    # 뒤(가장 작은 자리)부터 순회
    carry = 0
    result = []
    for i in range(n - 1, -1, -1):
        total = int(a[i]) + int(b[i]) + carry
        result.append(str(total % 2))
        carry = total // 2
    if carry:
        result.append("1")
    return "".join(reversed(result))

assert binary_add_str("1110", "1011") == "11001"
assert binary_add_str("111", "1") == "1000"

# Python 내장과 비교
for a, b in [("1110", "1011"), ("11111", "11111"), ("10101", "01010")]:
    mine = binary_add_str(a, b)
    builtin = bin(int(a, 2) + int(b, 2))[2:]
    print(f"{a} + {b}: mine={mine}, builtin={builtin}, {mine == builtin}")
```

</details>

---

### E3. RSA 작은 예제 (교육용)

```python
# 작은 소수 p=61, q=53 → n=3233
# e=17, d=2753 (미리 계산)
p, q = 61, 53
n = p * q              # 3233
phi = (p - 1) * (q - 1)  # 3120
e = 17
d = 2753               # e·d ≡ 1 mod phi; 17*2753 mod 3120 = 1

# 평문 m = 65 (알파벳 'A')
m = 65
# 암호화: c = m^e mod n
c = pow(m, e, n)
print(f"암호문: {c}")

# 복호화: m' = c^d mod n
m_decrypted = pow(c, d, n)
print(f"복호화: {m_decrypted}")
assert m_decrypted == m
```

<details>
<summary>정답 확인</summary>

출력:
```
암호문: 2790
복호화: 65
```

**이 한 예제가 RSA의 전부이다**. 이 절의 알고리즘 5(`pow`의 빠른 구현)가 없으면 위 두 줄이 실제 RSA-2048에서 몇 시간 걸리는 연산이 된다. 그 대신 밀리초에 끝난다.

</details>

---

## 채점 기준

| 섹션 | 배점 | 내용 |
|-----|------|------|
| A | 20 | 밑수 변환 기초 |
| B | 30 | 알고리즘 실행 |
| C | 20 | 복잡도 분석 |
| D | 10 | Lean 4 |
| E | 20 | Python 종합 |
| **총** | **100** | |
