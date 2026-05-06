# 이산수학 4.4절 합동 풀기 ·


## 도입부 — 합동(congruence)이란 무엇이며, 왜 4.4절을 배우는가

### 0.1 합동의 직관

두 정수 **a**(a)와 **b**(b)가 양의 정수 **m**(m)에 대해 **합동**(congruent)**이다**라 함은

$$ a \equiv b \pmod{m} \iff m \mid (a - b) $$

이 성립한다는 뜻이다. 즉, **a − b**가 m의 배수이다.

직관적으로는 '**시계 산술**(clock arithmetic)'이다. 12시간 시계에서 17시는 ____시와 같고, 24시간 시계에서 25시는 ____시와 같다.

<details><summary>정답</summary>

- 12시간 시계: 17 ≡ **5** (mod 12)
- 24시간 시계: 25 ≡ **1** (mod 24)

</details>

### 0.2 합동의 세 가지 기본 성질

세 성질을 빈칸으로 채우라.

1. **반사**(reflexivity) — $a \equiv a \pmod{m}$
2. **대칭**(symmetry) — $a \equiv b \pmod{m} \Rightarrow$ ____
3. **이행**(transitivity) — $a \equiv b \pmod{m} \land b \equiv c \pmod{m} \Rightarrow$ ____

<details><summary>정답</summary>

- 대칭: $b \equiv a \pmod{m}$
- 이행: $a \equiv c \pmod{m}$

</details>

### 0.3 4.4절의 지형도(roadmap)

| 부 | 주제 | 핵심 정리 / 정의 |
| --- | --- | --- |
| 1부 | 선형 합동 $ax \equiv b \pmod{m}$ | **정리 1**(역원의 존재·유일성) |
| 2부 | 연립 합동 (CRT) | **정리 2**(중국인의 나머지 정리) |
| 3부 | 페르마의 작은 정리 | **정리 3** |
| 4부 | 원시근·이산 로그 | **정의 3, 정의 4**, DLP |
| 5부 | RAG / AI 응용 | 위 6개를 ____에 적용 |

<details><summary>정답</summary>

5부: 위 6개를 **RAG, 분산 인덱스, 동형 암호, 영지식 증명, 양자화 LLM** 에 적용

</details>

### 0.4 Lean 4 — `theorem`, `if/iff`, `rw`

Lean 4에서 명제는 ____ 타입에 속한다. '만약-그러면'은 ____ 로, '동치'는 ____ 로 표기한다.

```lean
theorem cong_refl (a m : ℤ) : a ≡ a [ZMOD m] := by
  ____    -- 힌트: rfl 또는 Int.ModEq.refl
```

<details><summary>정답</summary>

- 명제 타입: `Prop`
- 만약-그러면: `→` (또는 `Implies`)
- 동치: `↔` (또는 `Iff`)
- `rfl`

</details>

---

## 1부 — 선형 합동과 모듈러 역원 (정리 1)

### 1.1 정리 1 — 모듈러 역원의 존재·유일성

> **정리 1**. **a, m**(a, m)이 $\gcd(a, m) = 1$ 인 정수라 하자. 그러면 다음을 만족하는 정수 **a⁻¹**(a⁻¹)이 mod m 에 대해 **유일하게 존재한다**.  
> $$ a \cdot a^{-1} \equiv 1 \pmod{m} $$

**증명의 큰 흐름**:
1. **베주 항등식**(Bézout's identity): $\gcd(a, m) = 1 \Rightarrow \exists\,s, t \in \mathbb{Z}$ 에 대해 $sa + tm = 1$.
2. 양변을 mod m 으로 보면 ____.
3. 따라서 ____ 가 a 의 역원이다.
4. 유일성: 두 역원 $a_1^{-1}, a_2^{-1}$이 있다 가정하면 ____.

<details><summary>정답</summary>

2. $sa \equiv 1 \pmod{m}$
3. $a^{-1} = s$
4. $a_1^{-1} \equiv a_1^{-1}(a a_2^{-1}) \equiv (a_1^{-1} a) a_2^{-1} \equiv a_2^{-1} \pmod{m}$

</details>

### 1.2 예제 1 — 3 의 mod 7 역원

확장 유클리드 호제법으로 $\gcd(3, 7) = 1$ 의 베주 계수를 구하라.

```
7 = 2·3 + 1   →   1 = 7 − 2·3
```

따라서 $3^{-1} \equiv$ ____ $\pmod{7}$.

<details><summary>정답</summary>

$3^{-1} \equiv -2 \equiv \mathbf{5} \pmod{7}$ (검산: $3 \cdot 5 = 15 \equiv 1 \pmod{7}$)

</details>

### 1.3 Lean 4 — 선형 합동의 골격

```lean
import Mathlib.Data.ZMod.Basic

example : (3 : ZMod 7) * 5 = 1 := by
  ____    -- 힌트: decide / rfl / native_decide

-- 선형 합동 ax ≡ b (mod m) 의 해는 x ≡ a⁻¹·b
example (a b : ZMod 7) (ha : a ≠ 0) :
    ∃ x : ZMod 7, a * x = b := by
  refine ⟨____ * b, ?_⟩
  ____    -- 힌트: 곱셈 결합 + a · a⁻¹ = 1
```

<details><summary>정답</summary>

```lean
example : (3 : ZMod 7) * 5 = 1 := by
  decide

example (a b : ZMod 7) (ha : a ≠ 0) :
    ∃ x : ZMod 7, a * x = b := by
  refine ⟨a⁻¹ * b, ?_⟩
  rw [← mul_assoc, ZMod.mul_inv_of_unit a (by exact Ne.isUnit ha), one_mul]
```

(2026 Mathlib4 기준. `ZMod p` 가 `p` 가 소수이므로 `a ≠ 0 ↔ IsUnit a`.)

</details>

### 1.4 예제 2 · 3 — 더 큰 모듈러스

(1) $5x \equiv 3 \pmod{11}$ 의 해를 구하라.

확장 유클리드: $11 = 2 \cdot 5 + 1$, 즉 $1 = 11 - 2 \cdot 5$.
따라서 $5^{-1} \equiv$ ____ $\pmod{11}$.
해 $x \equiv 5^{-1} \cdot 3 \equiv$ ____ $\pmod{11}$.

<details><summary>정답</summary>

$5^{-1} \equiv -2 \equiv \mathbf{9} \pmod{11}$.
$x \equiv 9 \cdot 3 = 27 \equiv \mathbf{5} \pmod{11}$.

</details>

(2) $12x \equiv 7 \pmod{15}$ 은 해를 가지는가? 그 이유는?

<details><summary>정답</summary>

$\gcd(12, 15) = 3$ 이므로 $12x \equiv 7 \pmod{15}$ 의 해 존재 ↔ $3 \mid 7$. 그러나 $3 \nmid 7$ 이므로 **해는 존재하지 않는다**.

</details>

### 1.5 자기 점검 (1부)

- 정리 1의 두 가정 중 '$\gcd(a,m)=1$' 을 떨어뜨리면 무엇이 깨지는가?
- 베주 항등식에서 '$s$' 와 '$t$' 중 어느 쪽이 모듈러 역원에 해당하는가?

<details><summary>정답</summary>

- 존재성·유일성 모두 깨진다. 일반적으로 $d = \gcd(a,m)$일 때 $d \mid b$ 이면 해가 $d$개, 아니면 0개.
- $sa + tm = 1$ 에서 'a 와 곱해지는 $s$' 가 a 의 역원이다.

</details>

---

## 2부 — 중국인의 나머지 정리 (CRT, 정리 2)

### 2.1 정리 2 — CRT 진술
  
> **정리 2 (CRT)**. $m_1, m_2, \ldots, m_n$ 이 **쌍쌍 서로소**(pairwise coprime)인 양의 정수라 하자. 임의의 정수 $a_1, \ldots, a_n$ 에 대해 다음 연립 합동  
 $$ x \equiv a_j \pmod{m_j}, \quad j = 1, \ldots, n $$
> 은 $\bmod\,M = m_1 m_2 \cdots m_n$ 에 대해 **유일한 해를 가진다**.

### 2.2 명시적 해 — `M_k` 와 `y_k`

해 $x$ 의 닫힌 형은 다음과 같다. 빈칸을 채우라.

$$ M_k = \frac{M}{m_k}, \quad y_k \equiv M_k^{-1} \pmod{m_k}, \quad x \equiv \sum_{k=1}^{n} a_k\,M_k\,y_k \pmod{M} $$

핵심 — $j \ne k$ 일 때 $M_k \equiv 0 \pmod{m_j}$ 이고, $j = k$ 일 때 $M_k\,y_k \equiv$ ____ $\pmod{m_k}$.

<details><summary>정답</summary>

$M_k\,y_k \equiv \mathbf{1} \pmod{m_k}$ — 따라서 $a_k M_k y_k \equiv a_k \pmod{m_k}$, 다른 모든 항은 $\equiv 0 \pmod{m_k}$.

</details>

### 2.3 손자(孫子) 문제

> 어떤 수가 3으로 나누어 2가 남고, 5로 나누어 3이 남고, 7로 나누어 2가 남는다. 그 수는?

연립합동: $x \equiv 2 \pmod 3, \ x \equiv 3 \pmod 5, \ x \equiv 2 \pmod 7$.

-  $M = 3 \cdot 5 \cdot 7 = $ ____  
-  $M_1 = $ ____ , $M_2 = $ ____ , $M_3 = $ ____  
-  $y_1 \equiv 35^{-1} \pmod 3$ : $35 \equiv 2 \pmod 3$, 그리고 $2 \cdot 2 \equiv 1 \pmod 3$ 이므로 $y_1 = $ ____.  
-  $y_2 \equiv 21^{-1} \pmod 5$ : $21 \equiv 1 \pmod 5$, 그러므로 $y_2 = $ ____.  
-  $y_3 \equiv 15^{-1} \pmod 7$ : $15 \equiv 1 \pmod 7$, 그러므로 $y_3 = $ ____.  
-  $x \equiv 2 \cdot 35 \cdot 2 + 3 \cdot 21 \cdot 1 + 2 \cdot 15 \cdot 1 = $ ____ $\equiv$ ____ $\pmod{105}$.  

<details><summary>정답</summary>

- $M = \mathbf{105}$, $M_1 = \mathbf{35}$, $M_2 = \mathbf{21}$, $M_3 = \mathbf{15}$  
- $y_1 = 2$, $y_2 = 1$, $y_3 = 1$  
- $x \equiv 140 + 63 + 30 = \mathbf{233} \equiv \mathbf{23} \pmod{105}$  

검산: $23 \mod 3 = 2$ ✓, $23 \mod 5 = 3$ ✓, $23 \mod 7 = 2$ ✓.  

</details>

### 2.4 역대입법(back substitution)

CRT의 또 다른 풀이법. 한 합동씩 차례로 '쌓아 올린다'.

문제: $x \equiv 1 \pmod 5, \ x \equiv 2 \pmod 6, \ x \equiv 3 \pmod 7$.

- 1단계: $x = 5t + 1$. 이를 두 번째에 넣으면 ____ ⇒ $t \equiv$ ____ $\pmod 6$ ⇒ $t = 6u + ?$
- 2단계: $x = 30u + ?$. 세 번째에 넣어 $u$ 결정.

<details><summary>정답</summary>

- 1단계: $5t + 1 \equiv 2 \pmod 6 \Rightarrow 5t \equiv 1 \pmod 6 \Rightarrow t \equiv \mathbf{5} \pmod 6$, 즉 $t = 6u + 5$.
- 그러면 $x = 5(6u + 5) + 1 = 30u + 26$.
- 2단계: $30u + 26 \equiv 3 \pmod 7 \Rightarrow 2u + 5 \equiv 3 \pmod 7 \Rightarrow 2u \equiv -2 \pmod 7 \Rightarrow u \equiv -1 \equiv 6 \pmod 7$.
- $x = 30 \cdot 6 + 26 = 206 \pmod{210}$. (확인: $206 \bmod 5 = 1, \bmod 6 = 2, \bmod 7 = 3$ ✓)

</details>

### 2.5 RNS — 큰 정수를 '쪼개어' 다루기

**잉여수 표현**(Residue Number System, RNS) — 큰 정수 $a < M = m_1 m_2 \cdots m_n$ 을 튜플 $(a \bmod m_1, \ldots, a \bmod m_n)$ 으로 저장.

장점: $+, \times$ 가 ____마다 독립적으로 수행되어 SIMD/GPU에 적합.

수학적 정당성: ____ 정리.

<details><summary>정답</summary>

- 장점: **각 좌표** 마다 독립.
- 정당성: **정리 2 (CRT)** — 좌표별 결과가 원래 정수의 결과와 일의적으로 일치한다.

</details>

### 2.6 Lean 4 — CRT 골격

```lean
import Mathlib.Data.ZMod.Basic

-- "ℤ/(m·n) ≃ ℤ/m × ℤ/n  (m, n 서로소일 때)"
example (m n : ℕ) (hmn : Nat.Coprime m n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n := by
  exact ____    -- 힌트: ZMod.chineseRemainder 또는 ZMod.equivProdOfCoprime
```

<details><summary>정답</summary>

```lean
exact ZMod.chineseRemainder hmn
```

</details>

---

## 3부 — 페르마의 작은 정리 (정리 3)

### 3.1 정리 3 — 진술

> **정리 3 (페르마의 작은 정리)**. $p$ 가 소수이고 $\gcd(a, p) = 1$ 이면
> $$ a^{p-1} \equiv 1 \pmod{p} $$

따름정리: 모든 $a \in \mathbb{Z}$ 에 대해 $a^p \equiv a \pmod{p}$.

### 3.2 증명의 큰 그림 (3단계)

1. **잉여 집합 보존**(rearrangement): $\{a, 2a, 3a, \ldots, (p-1)a\} \pmod p$ 은 $\{1, 2, \ldots, p-1\}$ 의 ____이다.
2. **양변의 곱을 비교**: 위 등식의 양변을 모두 곱하면 $a^{p-1} \cdot (p-1)! \equiv (p-1)! \pmod p$.
3. **$(p-1)!$ 를 양변에서 '약분'**: $\gcd((p-1)!, p) = 1$ 이므로 ____ 한다(정리 1 활용).

<details><summary>정답</summary>

1. **순열**(permutation, 재배열).
2. (그대로)
3. $(p-1)!$ 의 mod $p$ 역원을 양변에 곱하면 $a^{p-1} \equiv 1 \pmod p$.

</details>

### 3.3 예제 9 — `3^302 mod 5`

페르마: $3^4 \equiv 1 \pmod 5$. 따라서 $302 = 4 \cdot 75 + 2$, 그러므로 $3^{302} \equiv 3^2 \equiv$ ____ $\pmod 5$.

<details><summary>정답</summary>

$3^{302} \equiv 3^2 = \mathbf{9} \equiv \mathbf{4} \pmod 5$.

</details>

### 3.4 예제 9 확장 — `3^302 mod 385` (페르마 + CRT)

$385 = 5 \cdot 7 \cdot 11$. 각 소수에서 페르마를 쓰고 CRT 로 합성.

- $3^{302} \pmod 5$: $3^4 \equiv 1$, $302 = 4 \cdot 75 + 2$ ⇒ $3^2 \equiv$ ____.
- $3^{302} \pmod 7$: $3^6 \equiv 1$, $302 = 6 \cdot 50 + 2$ ⇒ $3^2 \equiv$ ____.
- $3^{302} \pmod{11}$: $3^{10} \equiv 1$, $302 = 10 \cdot 30 + 2$ ⇒ $3^2 \equiv$ ____.
- CRT로 $x \equiv 4 \pmod 5, x \equiv 2 \pmod 7, x \equiv 9 \pmod{11}$ 을 풀면 $x \equiv$ ____ $\pmod{385}$.

<details><summary>정답</summary>

- $3^2 = 4$, $3^2 = 2$ (mod 7: $9 \equiv 2$), $3^2 = 9$.
- CRT: $M = 385$. $M_1 = 77, M_2 = 55, M_3 = 35$.
  - $77 \bmod 5 = 2$, $2 \cdot 3 \equiv 1 \pmod 5$ → $y_1 = 3$.
  - $55 \bmod 7 = 6 \equiv -1$, $-1 \cdot -1 \equiv 1$ → $y_2 = 6$.
  - $35 \bmod 11 = 2$, $2 \cdot 6 \equiv 1$ → $y_3 = 6$.
  - $x \equiv 4 \cdot 77 \cdot 3 + 2 \cdot 55 \cdot 6 + 9 \cdot 35 \cdot 6 = 924 + 660 + 1890 = 3474$.
  - $3474 \bmod 385 = 3474 - 9 \cdot 385 = 3474 - 3465 = \mathbf{9}$.

</details>

### 3.5 의사소수와 카마이클 수

- **페르마 의사소수**(Fermat pseudoprime) 밑 $b$ — 합성수 $n$ 인데도 $b^{n-1} \equiv 1 \pmod n$ 인 $n$.
- **카마이클 수**(Carmichael number) — $\gcd(b, n) = 1$ 인 모든 $b$ 에 대해 $b^{n-1} \equiv 1 \pmod n$ 인 합성수.

가장 작은 카마이클 수: $n = $ ____ $= $ ____ $\cdot$ ____ $\cdot$ ____.

<details><summary>정답</summary>

$561 = 3 \cdot 11 \cdot 17$.

</details>

### 3.6 Lean 4 — 페르마

```lean
import Mathlib.FieldTheory.Finite.Basic

-- 진술: a ≠ 0 in ZMod p (p prime) → a^(p-1) = 1
example (p : ℕ) [Fact p.Prime] (a : ZMod p) (ha : a ≠ 0) :
    a ^ (p - 1) = 1 := by
  exact ____    -- 힌트: ZMod.pow_card_sub_one_eq_one
```

<details><summary>정답</summary>

```lean
exact ZMod.pow_card_sub_one_eq_one ha
```

</details>

---

## 4부 — 원시근과 이산 로그

### 4.1 정의 3 — 원시근(primitive root)

> $r \in (\mathbb{Z}/p\mathbb{Z})^*$ 이 **원시근**이라 함은
> $$ \{r^1, r^2, \ldots, r^{p-1}\} \equiv \{1, 2, \ldots, p-1\} \pmod{p} $$
> 즉 $r$ 의 거듭제곱이 ____ 잉여류를 '한 번씩' 만든다는 뜻이다.

<details><summary>정답</summary>

영이 아닌 모든 잉여류를.

</details>

### 4.2 예제 12 — `mod 11` 의 원시근

$\mathbb{Z}/11\mathbb{Z}^*$ 에서 $r = 2$ 의 거듭제곱을 계산하라.

| $k$ | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| $2^k \bmod 11$ | 2 | 4 | 8 | __ | __ | __ | __ | __ | __ | __ |

10개 모두 서로 다르면 $2$ 는 mod 11 의 원시근이다.

<details><summary>정답</summary>

| $k$ | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| $2^k \bmod 11$ | 2 | 4 | 8 | **5** | **10** | **9** | **7** | **3** | **6** | **1** |

10개 모두 다르다 ⇒ **2 는 mod 11 의 원시근이다**.

</details>

### 4.3 정의 4 — 이산 로그(discrete logarithm)

> $r$ 이 mod $p$ 의 원시근이고 $a \in (\mathbb{Z}/p\mathbb{Z})^*$ 이면
> $$ \log_r a := \text{유일한 } e \in \{1, \ldots, p-1\}\ \text{인데, 즉}\ r^e \equiv a \pmod p $$

### 4.4 예제 13 — `log_2 3 mod 11`

위 표에서 $2^? \equiv 3 \pmod{11}$. 정답: $\log_2 3 \equiv$ ____ $\pmod{11-1}$.

<details><summary>정답</summary>

표에서 $2^8 \equiv 3$. ⇒ $\log_2 3 \equiv \mathbf{8} \pmod{10}$.

</details>

### 4.5 이산 로그의 곱셈 성질

$\log_r (ab) \equiv \log_r a + \log_r b \pmod{p-1}$.

(실수 로그의 '곱 → 합' 성질의 이산 판본. mod $p-1$인 이유는 $r^{p-1} \equiv 1$ 이기 때문.)

### 4.6 DLP — 이산 로그 문제

> 주어진 $r$, $p$, $a$ 로부터 $\log_r a$ 를 구하는 문제.
> $p$ 가 클 때(예: 2048비트), 가장 빠른 알려진 알고리즘도 ____ 시간이다.

<details><summary>정답</summary>

준지수(sub-exponential) 시간 — 일반 수체 체분해(GNFS)에 가까운 복잡도. 현실적으로 '풀 수 없다'고 간주된다. → **공개키 암호의 안전성 토대**.

</details>

### 4.7 Diffie–Hellman 키 교환

| 공개 정보: 큰 소수 $p$, 원시근 $g$ |
| --- |
| Alice: 비밀 $a$, 공개 $A = g^a \bmod p$ |
| Bob: 비밀 $b$, 공개 $B = g^b \bmod p$ |
| 공통 비밀: Alice 가 $K = B^a \bmod p$, Bob 이 $K = A^b \bmod p$ |

두 사람이 얻는 $K$ 가 같음의 핵심 — $g^{ab} = (g^a)^b = (g^b)^a$.

도청자가 $K$ 를 알려면 $a$ 또는 $b$ 를 알아야 하는데, 이는 ____ 문제이다.

<details><summary>정답</summary>

**DLP**(이산 로그 문제). 도청자는 $A, B, g, p$ 만 알고 있으며 $a = \log_g A$ 를 구해야 한다.

</details>

### 4.8 Lean 4 — 원시근 / DLP 골격

```lean
import Mathlib.NumberTheory.LucasLehmer
import Mathlib.GroupTheory.SpecificGroups.Cyclic

-- 'r 이 mod p 의 원시근' 의 형식 정의
example (p : ℕ) [Fact p.Prime] (r : ZMod p) (hr : r ≠ 0) :
    Prop := ____    -- 힌트: orderOf r = p - 1

-- 이산 로그의 '유일성' (대수적 표현)
example (p : ℕ) [Fact p.Prime] (g : ZMod p)
    (hg : orderOf g = p - 1) (a : ZMod p) (ha : a ≠ 0) :
    ∃! e : Fin (p - 1), g ^ (e : ℕ) = a := by
  ____    -- 힌트: Cyclic group의 generator 성질을 사용한다
```

<details><summary>정답(개요)</summary>

```lean
example (p : ℕ) [Fact p.Prime] (r : ZMod p) (hr : r ≠ 0) :
    Prop := orderOf r = p - 1
```

뒤의 `∃!` 증명은 Mathlib4 의 `IsCyclic` / `orderOf_eq_card` 등으로 채울 수 있다(전체 구성은 워크북 참조).

</details>

---

## 5부 — RAG / AI 응용

### 5.1 RAG 파이프라인 5단계

질의 → ____ → ____ → ____ → 생성.

이 가운데 모듈러 산술이 직접 쓰이는 단계: ____, ____, ____.

<details><summary>정답</summary>

- 단계: 질의(Query) → **임베딩**(Embed) → **검색**(Search) → **검증**(Verify) → 생성(Generate).
- 모듈러 산술 단계: **임베딩**(해싱, 정리 1), **검색**(샤딩, 정리 2 CRT), **검증**(서명·ZK, 정리 3 페르마 + DLP).

</details>

### 5.2 분산 인덱스의 CRT 비유

샤드 $j$ 의 부분 결과 $r_j \in \mathbb{Z}_{m_j}$ 이 있을 때, 전체 인덱스 $R \in \mathbb{Z}_M$ 은 $R \equiv r_j \pmod{m_j}$ 라는 정보로부터 ____ 복원된다.

<details><summary>정답</summary>

**유일하게**(uniquely) 복원된다 — 정리 2(CRT)의 직접 응용.

</details>

### 5.3 동형 암호와 RNS

큰 모듈러스 $q \approx 2^{600}$ 을 ____ 꼴로 쪼개면, 각 좌표를 32~64비트 GPU/CPU 명령으로 처리할 수 있다.

<details><summary>정답</summary>

$q = q_1 q_2 \cdots q_\ell$ (서로소). RNS 표현. 정당성: **CRT**.

</details>

### 5.4 zk-SNARK 의 토대

영지식 증명의 안전성은 ____ 문제의 어려움에 기반한다. 그 어려움이 식 $g^x \equiv a \pmod p$ 에서 ____ 를 구하는 일이다.

<details><summary>정답</summary>

DLP(이산 로그 문제). $x$ 를 구하는 일.

</details>

### 5.5 LLM 양자화의 모듈러

가중치를 8비트 정수로 자른다 = mod ____ 산술. 8비트 정수곱 결과를 다시 8비트로 환원할 때 'scale 인수 + mod 256'은 ____ 정리(나눗셈 보조정리)와 ____ 정리(CRT)가 결합된 구조이다.

<details><summary>정답</summary>

mod **256**. **정리 1** + **정리 2**.

</details>

### 5.6 5부 종합 STUDENT TRY — RAG 샤드 합성

문제 — 모듈러스 $m_1 = 7, m_2 = 11, m_3 = 13$ 의 3 샤드. 부분 점수 $s \equiv 3 \pmod 7,\ 5 \pmod{11},\ 9 \pmod{13}$.

(a) CRT 로 $0 \le s < 1001$ 인 유일 $s$ = ____.

(b) 한 샤드 손실 시 정리 2의 어느 가정이 깨지는가? ____.

(c) Python 한 줄로 (a) 검산: ____.

<details><summary>정답</summary>

(a) **$s = 269$**. 풀이는 슬라이드 175 참조.

(b) **'모든 $m_j$ 에 대한 부분 정보가 주어진다'는 가정**. $m_2$ 손실 시 후보가 $1001/11 = 91$ 개로 분기되어 유일성이 깨진다.

(c) `from sympy.ntheory.modular import crt; crt([7,11,13],[3,5,9])` → `(269, 1001)`.

</details>

---

## 부록 — Mathlib4 (2026) 정리 인덱스

| 수학 개념 | Mathlib4 이름 |
| --- | --- |
| 합동의 정의 | `Int.ModEq`, `Nat.ModEq` |
| 모듈러 역원의 존재(소수) | `ZMod.mul_inv_of_unit` |
| 페르마의 작은 정리 | `ZMod.pow_card_sub_one_eq_one` |
| CRT (두 모듈러스) | `ZMod.chineseRemainder` |
| CRT (일반) | `ZMod.equivProdOfCoprime` (또는 `Nat.chineseRemainder`) |
| 소인수 분해 리스트 | `Nat.primeFactorsList` |
| 소인수 분해의 곱 | `Nat.prod_primeFactorsList` |
| 주기 (orderOf) | `orderOf` |
| 순환군 | `IsCyclic` |
| 베주 항등식 | `Nat.gcd_eq_gcd_ab`, `Int.gcd_eq_gcd_ab` |

---

## 한 페이지 정리 시트

**6개 핵심**

1. 정리 1 — $ax \equiv b \pmod m$, $\gcd(a,m)=1$ ⇒ 유일 해 $x \equiv a^{-1}\,b$.
2. 정리 2 — CRT: 서로소 모듈러스에서 연립합동의 유일 해 $\bmod\,M$.
3. 정리 3 — 페르마: $p$ 소수, $\gcd(a,p)=1$ ⇒ $a^{p-1} \equiv 1$.
4. 정의 3 — 원시근: 거듭제곱이 모든 비영 잉여를 만든다.
5. 정의 4 — 이산 로그: 원시근의 거듭제곱에서의 '지수'.
6. DLP — 이산 로그를 푸는 어려운 문제.

**6개 응용**

1. RSA — 페르마(정리 3).
2. Diffie-Hellman — DLP.
3. RAG 샤딩 — CRT (정리 2).
4. 동형 암호 — RNS = CRT 끝까지.
5. zk-SNARK — 원시근 + DLP.
6. 양자화 LLM — 정리 1 + mod $2^8$.

**한 줄 격언** — 정수론은 AI의 인프라 언어다.
