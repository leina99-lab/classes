# 이산수학 4.4절 합동 풀기 · 학생 워크북



---

## 1부 — 선형 합동 (정리 1)

### 문제 1-1 (유형 1) — 정리 1 진술 빈칸

> **정리 1**. \(a, m\) 이 정수이고 \(\gcd(a, m) =\) ____ 이라 하자. 그러면 \(ax \equiv b \pmod m\) 의 해는 ____ 에 대해 ____ 한다.

<details><summary>정답</summary>

\(\gcd(a,m) = \mathbf{1}\). **\(\bmod m\)** 에 대해 **유일하게 존재**한다.

</details>

### 문제 1-2 (유형 1) — 베주 항등식 빈칸

> \(\gcd(a, m) = 1\) 이면 정수 \(s, t\) 가 있어 \(sa + tm =\) ____ 이다. 그러면 mod \(m\) 에서 \(sa \equiv\) ____ 이고, 따라서 \(a^{-1} \equiv\) ____ \(\pmod m\).

<details><summary>정답</summary>

\(sa + tm = \mathbf{1}\). \(sa \equiv \mathbf{1} \pmod m\). \(a^{-1} \equiv \mathbf{s} \pmod m\).

</details>

### 문제 1-3 (유형 2) — gcd 가 1 이 아닐 때

> \(\gcd(a, m) = d > 1\) 일 때 \(ax \equiv b \pmod m\) 의 해의 개수에 대한 결론을 한 문장으로 서술하라.

<details><summary>모범 답</summary>

\(d \mid b\) 이면 mod \(m\) 에서 정확히 **\(d\) 개**의 해가 있고, \(d \nmid b\) 이면 **해가 없다**.

</details>

### 문제 1-4 (유형 2) — 핵심 단계 서술

> 문제 1-2 의 ‘\(a^{-1} \equiv s \pmod m\)' 가 왜 ‘유일하게' 결정되는가? 한 문장으로 서술하라(유일성의 ‘결정적 단계').

<details><summary>모범 답</summary>

두 역원 \(s_1, s_2\) 가 있다고 하면 \(s_1 \equiv s_1 (a s_2) \equiv (s_1 a) s_2 \equiv s_2 \pmod m\) — 곱셈의 결합과 ‘\(s_i a \equiv 1\)'을 결합하면 \(s_1 \equiv s_2\) 가 강제되기 때문이다.

</details>

### 문제 1-5 (유형 3) — `5x ≡ 4 (mod 13)` 풀이

확장 유클리드부터 답까지 모든 단계를 적으라.

<details><summary>풀이</summary>

1. \(\gcd(5, 13)\) — \(13 = 2 \cdot 5 + 3,\ 5 = 1 \cdot 3 + 2,\ 3 = 1 \cdot 2 + 1\). \(\gcd = 1\).
2. 역추적: \(1 = 3 - 1 \cdot 2 = 3 - (5 - 3) = 2 \cdot 3 - 5 = 2(13 - 2 \cdot 5) - 5 = 2 \cdot 13 - 5 \cdot 5\).
   따라서 \(5 \cdot (-5) \equiv 1 \pmod{13}\), 즉 \(5^{-1} \equiv -5 \equiv 8 \pmod{13}\).
3. \(x \equiv 8 \cdot 4 = 32 \equiv \mathbf{6} \pmod{13}\).

검산 — \(5 \cdot 6 = 30 \equiv 4 \pmod{13}\). 확인

</details>

### 문제 1-6 (유형 3) — 해의 개수가 3 인 경우

> \(6x \equiv 9 \pmod{15}\) 의 모든 해를 구하라.

<details><summary>풀이</summary>

\(\gcd(6, 15) = 3\), \(3 \mid 9\) 이므로 mod 15 에서 정확히 3 개의 해가 있다.

식을 3 으로 나누면 \(2x \equiv 3 \pmod 5\). \(2^{-1} \equiv 3 \pmod 5\) 이므로 \(x \equiv 9 \equiv \mathbf{4} \pmod 5\).

\(\bmod 15\) 에서의 해는 \(x \equiv 4, 9, 14 \pmod{15}\). (각각 mod 5 로는 모두 4.)

</details>

### 문제 1-7 (유형 4-①) — Lean 4 빈칸 채우기

```lean
import Mathlib.Data.ZMod.Basic

example : (5 : ZMod 13) * 8 = 1 := by
  ____  -- 1단계: 한 줄 결정 전술

example (a b : ZMod 13) (ha : a ≠ 0) :
    ∃ x : ZMod 13, a * x = b := by
  refine ⟨____ * b, ?_⟩
  rw [← mul_assoc, ____, one_mul]
```

<details><summary>정답</summary>

```lean
example : (5 : ZMod 13) * 8 = 1 := by decide

example (a b : ZMod 13) (ha : a ≠ 0) :
    ∃ x : ZMod 13, a * x = b := by
  refine ⟨a⁻¹ * b, ?_⟩
  rw [← mul_assoc, ZMod.mul_inv_of_unit a (Ne.isUnit ha), one_mul]
```

</details>

### 문제 1-8 (유형 4-③) — 자유 증명

`ZMod 11` 에서 \(x \mapsto 7 \cdot x\) 가 bijection 임을 증명하라(`Equiv` 사용 가능).

<details><summary>해설(개요)</summary>

`ZMod 11` 이 field 이므로 0 이 아닌 원소의 곱은 자기 자신의 역원을 가진다. `Equiv.mulLeft₀ (7 : ZMod 11) (by decide : (7 : ZMod 11) ≠ 0)` 가 그 bijection 의 정의이다. 이를 자기 자신의 손으로 작성:

```lean
def mul7 : ZMod 11 ≃ ZMod 11 :=
  Equiv.mulLeft₀ 7 (by decide)
```

</details>

---

## 2부 — 중국인의 나머지 정리 (CRT, 정리 2)

### 문제 2-1 (유형 1) — 정리 2 진술 빈칸

> \(m_1, \ldots, m_n\) 이 ____ 서로소인 양의 정수라 하자. 임의의 \(a_1, \ldots, a_n\) 에 대해 \(x \equiv a_j \pmod{m_j}\) 의 해는 \(\bmod\,M =\) ____ 에 대해 ____ 한다.

<details><summary>정답</summary>

**쌍쌍**(pairwise) 서로소. \(M = m_1 m_2 \cdots m_n\). **유일하게 존재**한다.

</details>

### 문제 2-2 (유형 1) — `M_k`, `y_k` 빈칸

\(M_k =\) ____ 이고, \(y_k\) 는 \(M_k\) 의 ____ (\(\bmod\ m_k\) 에서의)이다. 그러면 \(x \equiv \sum_k\) ____ \(\pmod M\).

<details><summary>정답</summary>

\(M_k = M / m_k\). \(y_k = M_k^{-1} \pmod{m_k}\). \(x \equiv \sum_k a_k M_k y_k\).

</details>

### 문제 2-3 (유형 2) — 결정적 단계 서술

> CRT 증명에서 ‘\(\sum_k a_k M_k y_k \equiv a_j \pmod{m_j}\)' 가 성립하는 핵심 이유를 한 문장으로 서술하라.

<details><summary>모범 답</summary>

\(j \neq k\) 일 때 \(M_k\) 에는 \(m_j\) 가 인수로 포함되어 \(M_k \equiv 0 \pmod{m_j}\) 이고, \(j = k\) 일 때만 \(M_k y_k \equiv 1 \pmod{m_j}\) 이므로, 합 안에서 \(j\) 번 항만 살아남기 때문이다.

</details>

### 문제 2-4 (유형 2) — 가정 위반 시

> \(m_1 = 4, m_2 = 6\) (서로소가 아님). 연립합동 \(x \equiv 1 \pmod 4, x \equiv 2 \pmod 6\) 가 해를 가지지 않는 이유를 설명하라.

<details><summary>모범 답</summary>

두 합동이 동시에 성립하려면 두 나머지가 공약수 \(\gcd(4,6)=2\) 에 대해 서로 같아야 한다. 그런데 \(1 \not\equiv 2 \pmod 2\) 이다. 따라서 \(x \equiv 1 \pmod 4\) 인 수는 항상 홀수이고, \(x \equiv 2 \pmod 6\) 인 수는 항상 짝수이므로 두 조건을 동시에 만족하는 정수 \(x\) 는 존재하지 않는다. 일반적으로 서로소가 아닌 경우의 해 존재 필요충분조건은 모든 \(i \neq j\) 에 대해 \(a_i \equiv a_j \pmod{\gcd(m_i, m_j)}\) 이다.

</details>

### 문제 2-5 (유형 3) — 손자 변형

> \(x \equiv 4 \pmod 5,\ x \equiv 5 \pmod 7,\ x \equiv 6 \pmod{11}\) 의 가장 작은 양의 해를 구하라.

<details><summary>풀이</summary>

\(M = 385,\ M_1 = 77,\ M_2 = 55,\ M_3 = 35\).

- \(77 \bmod 5 = 2\). \(2 \cdot 3 \equiv 1 \pmod 5\) → \(y_1 = 3\).
- \(55 \bmod 7 = 6 \equiv -1\). \(-1 \cdot -1 \equiv 1\) → \(y_2 = 6\).
- \(35 \bmod 11 = 2\). \(2 \cdot 6 \equiv 1\) → \(y_3 = 6\).

\(x \equiv 4 \cdot 77 \cdot 3 + 5 \cdot 55 \cdot 6 + 6 \cdot 35 \cdot 6 = 924 + 1650 + 1260 = 3834 \equiv 3834 - 9 \cdot 385 = 3834 - 3465 = \mathbf{369} \pmod{385}\).

검산 — \(369 \bmod 5 = 4\) 확인, \(369 \bmod 7 = 369 - 52 \cdot 7 = 369 - 364 = 5\) 확인, \(369 \bmod 11 = 369 - 33 \cdot 11 = 369 - 363 = 6\) 확인.

</details>

### 문제 2-6 (유형 3) — 역대입 풀이

> 문제 2-5 를 역대입법으로 다시 풀라.

<details><summary>풀이</summary>

1. \(x = 5t + 4\). → \(5t + 4 \equiv 5 \pmod 7 \Rightarrow 5t \equiv 1 \pmod 7\). \(5^{-1} \equiv 3 \pmod 7\) → \(t \equiv 3 \pmod 7\). \(t = 7u + 3\).
2. \(x = 5(7u + 3) + 4 = 35u + 19\).
3. \(35u + 19 \equiv 6 \pmod{11}\). \(35 \equiv 2 \pmod{11}\), \(19 \equiv 8\). → \(2u + 8 \equiv 6 \pmod{11} \Rightarrow 2u \equiv -2 \equiv 9 \pmod{11}\). \(2^{-1} \equiv 6 \pmod{11}\) → \(u \equiv 6 \cdot 9 = 54 \equiv 10 \pmod{11}\). \(u = 11v + 10\).
4. \(x = 35(11v + 10) + 19 = 385v + 369\).

\(\boxed{x \equiv 369 \pmod{385}}\) — 문제 2-5 와 일치.

</details>

### 문제 2-7 (유형 4-①) — Lean 4 빈칸

```lean
-- 두 개의 모듈러스에 대한 CRT 동형
example (m n : ℕ) (h : Nat.Coprime m n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n :=
  ____  -- Mathlib4 2026
```

<details><summary>정답</summary>

```lean
ZMod.chineseRemainder h
```

</details>

### 문제 2-8 (유형 4-②) — 부분 완성

```lean
-- 손자 문제의 답 23 ∈ ZMod 105 가 세 합동을 만족함
example : (23 : ZMod 105).val % 3 = 2 ∧
          (23 : ZMod 105).val % 5 = 3 ∧
          (23 : ZMod 105).val % 7 = 2 := by
  refine ⟨?_, ?_, ?_⟩
  · ____
  · ____
  · ____
```

<details><summary>정답</summary>

```lean
example : (23 : ZMod 105).val % 3 = 2 ∧
          (23 : ZMod 105).val % 5 = 3 ∧
          (23 : ZMod 105).val % 7 = 2 := by
  refine ⟨?_, ?_, ?_⟩
  · decide
  · decide
  · decide
```

(또는 `native_decide`).

</details>

---

## 3부 — 페르마의 작은 정리

### 문제 3-1 (유형 1) — 정리 3 빈칸

> \(p\) 가 ____ 이고 \(\gcd(a, p) =\) ____ 이면 \(a^{\boxed{?}} \equiv 1 \pmod p\).

<details><summary>정답</summary>

\(p\) 소수, \(\gcd(a,p) = 1\), 지수는 \(p - 1\).

</details>

### 문제 3-2 (유형 2) — 페르마 증명의 핵심

> 페르마의 작은 정리 증명에서 ‘\(\{a, 2a, \ldots, (p-1)a\} \bmod p\) 가 \(\{1, 2, \ldots, p-1\}\) 의 순열이다'가 왜 성립하는가? 한 문장으로 서술하라.

<details><summary>모범 답</summary>

만약 두 항 \(i a, j a\) (\(1 \le i < j \le p-1\)) 가 mod \(p\) 에서 같다면 \((j - i) a \equiv 0 \pmod p\) 이고 \(\gcd(a, p) = 1\) 이므로 \(p \mid (j - i)\) — 그러나 \(0 < j - i < p\) 이므로 모순. 따라서 모두 서로 다르며, \(p-1\) 개의 영이 아닌 잉여류에 일대일 대응하므로 정확히 순열.

</details>

### 문제 3-3 (유형 3) — 페르마 적용

> \(7^{222} \bmod 11\) 을 구하라.

<details><summary>풀이</summary>

\(\gcd(7, 11) = 1\) 이고 \(7^{10} \equiv 1 \pmod{11}\). \(222 = 10 \cdot 22 + 2\). 따라서 \(7^{222} \equiv 7^2 = 49 \equiv \mathbf{5} \pmod{11}\).

</details>

### 문제 3-4 (유형 3) — 페르마 + CRT 통합

> \(5^{1000} \bmod 77\) 을 구하라. (\(77 = 7 \cdot 11\).)

<details><summary>풀이</summary>

- mod 7: \(5^6 \equiv 1\). \(1000 = 6 \cdot 166 + 4\). \(5^4 = 625 \equiv 625 - 89 \cdot 7 = 625 - 623 = 2 \pmod 7\).
- mod 11: \(5^{10} \equiv 1\). \(1000 = 10 \cdot 100\). \(5^{1000} \equiv 1 \pmod{11}\).
- CRT: \(x \equiv 2 \pmod 7,\ x \equiv 1 \pmod{11}\). \(M = 77, M_1 = 11, M_2 = 7\). \(11 \equiv 4 \pmod 7\), \(4^{-1} \equiv 2 \pmod 7\) → \(y_1 = 2\). \(7 \equiv 7 \pmod{11}\), \(7^{-1} \equiv 8 \pmod{11}\) → \(y_2 = 8\).
- \(x \equiv 2 \cdot 11 \cdot 2 + 1 \cdot 7 \cdot 8 = 44 + 56 = 100 \equiv \mathbf{23} \pmod{77}\).

검산 — \(23 \bmod 7 = 2\) 확인, \(23 \bmod 11 = 1\) 확인.

</details>

### 문제 3-5 (유형 2) — 의사소수의 예

> \(341 = 11 \cdot 31\) 이 페르마 의사소수(밑 2)임을 보이려면 무엇을 확인해야 하는가? 한 문장으로 서술하라.

<details><summary>모범 답</summary>

\(2^{340} \equiv 1 \pmod{341}\) 임을 확인하면 된다. 페르마의 ‘역'이 거짓임을 보여주는 가장 작은 반례 중 하나.

</details>

### 문제 3-6 (유형 3) — 카마이클 561 검증

> 561 = 3 · 11 · 17 이 카마이클 수인지 ‘한 줄 조건'(연습문제 48)으로 검증하라.

<details><summary>풀이</summary>

‘한 줄 조건' — \(n\) 이 서로 다른 소수의 곱이고 모든 소인수 \(p_j\) 에 대해 \((p_j - 1) \mid (n - 1)\) 이면 \(n\) 은 카마이클 수.

\(n - 1 = 560\). 검증:
- \(3 - 1 = 2\), \(560 = 2 \cdot 280\) 확인
- \(11 - 1 = 10\), \(560 = 10 \cdot 56\) 확인
- \(17 - 1 = 16\), \(560 = 16 \cdot 35\) 확인

세 조건 모두 만족 ⇒ **561 은 카마이클 수**.

</details>

### 문제 3-7 (유형 4-①) — Lean 4 페르마

```lean
import Mathlib.FieldTheory.Finite.Basic

example (a : ZMod 7) (ha : a ≠ 0) : a ^ 6 = 1 := by
  ____
```

<details><summary>정답</summary>

```lean
exact ZMod.pow_card_sub_one_eq_one ha
```

(`ZMod 7` 의 `Fact (Nat.Prime 7)` 인스턴스가 자동 합성된다.)

</details>

### 문제 3-8 (유형 4-③) — 자유 증명

> \(a^p \equiv a \pmod p\) (\(p\) 소수, 모든 \(a\)) 의 따름정리를 Lean 4 로 작성하라.

<details><summary>해설(개요)</summary>

```lean
example (p : ℕ) [Fact p.Prime] (a : ZMod p) : a ^ p = a := by
  by_cases ha : a = 0
  · subst ha; simp [zero_pow_ne_zero (Nat.Prime.ne_zero (Fact.out))]
  · have h := ZMod.pow_card_sub_one_eq_one ha
    have : a ^ p = a * a ^ (p - 1) := by
      rw [← pow_succ', Nat.succ_pred_eq_of_pos (Nat.Prime.pos (Fact.out))]
    rw [this, h, mul_one]
```

(2026 Mathlib4 기준. `ZMod.pow_card` 한 줄로 더 짧게도 가능.)

</details>

---

## 4부 — 원시근과 이산 로그

### 문제 4-1 (유형 1) — 정의 3 빈칸

> \(r \in \mathbb{Z}/p\mathbb{Z}^*\) 이 mod \(p\) 의 ____ 라 함은 \(\{r^1, r^2, \ldots, r^{\boxed{?}}\}\) 가 ____ 와 같다는 뜻이다.

<details><summary>정답</summary>

‘**원시근**', \(r^{p-1}\), \(\{1, 2, \ldots, p-1\}\).

</details>

### 문제 4-2 (유형 3) — `mod 13` 의 원시근

> \(\mathbb{Z}/13\mathbb{Z}^*\) 의 원시근을 ‘작은 것부터' 모두 찾으라(2, 3, …, 12 중에서).

<details><summary>풀이</summary>

원시근의 개수 — \(\varphi(\varphi(13)) = \varphi(12) = 4\) 개.

각 후보의 차수 계산. mod 13 에서:
- \(2^k\) — 2, 4, 8, 3, 6, 12, 11, 9, 5, 10, 7, 1 (12 항, 1은 12 번째). 차수 12 → 원시근.
- \(3^k\) — 3, 9, 1 (1은 3 번째). 차수 3 → 원시근 아님.
- \(4^k\) — 4, 3, 12, 9, 10, 1 (1은 6 번째). 차수 6 → 원시근 아님.
- \(5^k\) — 5, 12, 8, 1 (1은 4 번째). 차수 4 → 원시근 아님.
- \(6^k\) — 6, 10, 8, 9, 2, 12, 7, 3, 5, 4, 11, 1 (12 항). 차수 12 → **원시근**.
- \(7^k\) — 7, 10, 5, 9, 11, 12, 6, 3, 8, 4, 2, 1. 차수 12 → **원시근**.
- \(8^k\) — 8, 12, 5, 1 (1은 4 번째). 차수 4 → 아님.
- \(9^k\) — 9, 3, 1. 차수 3 → 아님.
- \(10^k\) — 10, 9, 12, 3, 4, 1 (1은 6 번째). 차수 6 → 아님.
- \(11^k\) — 11, 4, 5, 3, 7, 12, 2, 9, 8, 10, 6, 1. 차수 12 → **원시근**.
- \(12^k\) — 12, 1. 차수 2 → 아님.

답: **2, 6, 7, 11** (정확히 4 개). 확인

</details>

### 문제 4-3 (유형 1) — 정의 4 빈칸

> \(\log_r a\) 는 \(r^e \equiv a \pmod p\) 를 만족하는 ____ 정수 \(e\) 이며, 가능한 범위는 \(e \in \{1, \ldots, p-1\}\) 이다.

<details><summary>정답</summary>

**유일한** \(e\), 범위는 \(e \in \{1, \ldots, p-1\}\).

</details>

### 문제 4-4 (유형 2) — 곱셈 성질의 이유

> \(\log_r (ab) \equiv \log_r a + \log_r b \pmod{p-1}\) 이 성립하는 이유를 한 문장으로 서술하라.

<details><summary>모범 답</summary>

\(r^{\log_r a + \log_r b} = r^{\log_r a} \cdot r^{\log_r b} = ab\) 이고, \(r\) 의 차수가 \(p-1\) 이므로 지수는 mod \(p-1\) 에서 일의적이기 때문이다.

</details>

### 문제 4-5 (유형 3) — Diffie–Hellman 시연

> \(p = 23, g = 5\). Alice 의 비밀 \(a = 6\), Bob 의 비밀 \(b = 15\). 두 사람의 공통 비밀 \(K\) 를 손으로 계산하라.

<details><summary>풀이</summary>

- \(A = 5^6 \bmod 23\). \(5^2 = 25 \equiv 2\). \(5^4 \equiv 4\). \(5^6 = 5^4 \cdot 5^2 \equiv 4 \cdot 2 = 8 \pmod{23}\).
- \(B = 5^{15} \bmod 23\). \(5^8 = (5^4)^2 \equiv 4^2 = 16\). \(5^{15} = 5^8 \cdot 5^4 \cdot 5^2 \cdot 5 = 16 \cdot 4 \cdot 2 \cdot 5 = 640 \equiv 640 - 27 \cdot 23 = 640 - 621 = 19 \pmod{23}\).
- \(K = B^a = 19^6 \bmod 23\). \(19 \equiv -4\). \(19^2 \equiv 16\). \(19^4 \equiv 16^2 = 256 \equiv 256 - 11 \cdot 23 = 3\). \(19^6 \equiv 3 \cdot 16 = 48 \equiv 2 \pmod{23}\).
- 검산: \(K = A^b = 8^{15} \bmod 23\). \(8^2 = 64 \equiv 64 - 2 \cdot 23 = 18\). \(8^4 \equiv 18^2 = 324 \equiv 324 - 14 \cdot 23 = 324 - 322 = 2\). \(8^8 \equiv 4\). \(8^{15} = 8^8 \cdot 8^4 \cdot 8^2 \cdot 8 = 4 \cdot 2 \cdot 18 \cdot 8 = 1152 \equiv 1152 - 50 \cdot 23 = 1152 - 1150 = 2 \pmod{23}\). 확인

\(\boxed{K = 2}\).

</details>

### 문제 4-6 (유형 4-①) — 원시근의 Lean 4 정의

```lean
-- 'r 이 mod p 의 원시근' 의 형식 정의
def isPrimitiveRoot (p : ℕ) [Fact p.Prime] (r : ZMod p) : Prop :=
  ____
```

<details><summary>정답</summary>

```lean
def isPrimitiveRoot (p : ℕ) [Fact p.Prime] (r : ZMod p) : Prop :=
  orderOf r = p - 1
```

(또는 Mathlib4 의 `IsPrimitiveRoot` 를 직접 인용.)

</details>

### 문제 4-7 (유형 4-②) — 부분 완성

```lean
-- 2 가 mod 11 의 원시근임 (구체 검증)
example : orderOf (2 : ZMod 11) = 10 := by
  ____
```

<details><summary>정답</summary>

```lean
example : orderOf (2 : ZMod 11) = 10 := by
  decide
```

(또는 `native_decide`. 작은 모듈러스이므로 `decide` 가 직접 통한다.)

</details>

### 문제 4-8 (유형 2) — DLP 의 ‘어려움'

> ‘이산 로그 문제(DLP)가 어렵다'는 가정이 양자 컴퓨터 환경에서 유지되지 않는 이유를 한 문장으로 서술하라.

<details><summary>모범 답</summary>

**Shor 의 알고리즘**이 양자 컴퓨터 위에서 다항시간(주기 찾기)으로 DLP 를 해결하기 때문이다. 따라서 ‘후양자(post-quantum) 암호'(격자, 해시, 코드 기반)가 연구된다.

</details>

---

## 5부 — RAG / AI 응용

### 문제 5-1 (유형 1) — 5 단계 빈칸

> RAG 5 단계: 질의 → ____ → ____ → ____ → 생성. 모듈러 산술이 직접 들어가는 단계는 ____, ____, ____.

<details><summary>정답</summary>

임베딩(Embed), 검색(Search), 검증(Verify), 생성(Generate). 모듈러 단계: 임베딩 / 검색 / 검증.

</details>

### 문제 5-2 (유형 2) — CRT 비유의 한계

> ‘분산 인덱스 합성 = CRT 비유'가 정확히 무엇을 보장하는가? 그리고 그 비유에서 ‘약하다'고 말할 수 있는 점이 있다면 한 가지 적으라.

<details><summary>모범 답</summary>

**보장** — ‘각 샤드의 부분 점수가 주어지면 전체 점수가 일의적으로 합성된다'. **약점** — 실제 RAG 에서 모듈러스는 ‘\(m_j\) 형태의 정수'가 아니라 ‘추상적인 분할'이며, ‘서로소'에 해당하는 가정이 ‘샤드 간 데이터 분리(disjointness)'로 더 약화된다.

</details>

### 문제 5-3 (유형 3) — RAG 샤드 합성 (강의 STUDENT TRY 와 유사)

> \(m_1 = 11, m_2 = 13, m_3 = 17\). 샤드 부분 점수 \(s \equiv 4 \pmod{11}, 7 \pmod{13}, 12 \pmod{17}\). CRT 로 \(0 \le s < 2431\) 인 유일 \(s\) 를 구하라.

<details><summary>풀이</summary>

\(M = 11 \cdot 13 \cdot 17 = 2431\). \(M_1 = 221, M_2 = 187, M_3 = 143\).

- \(221 \bmod 11 = 221 - 20 \cdot 11 = 1\). \(y_1 = 1\).
- \(187 \bmod 13 = 187 - 14 \cdot 13 = 5\). \(5 \cdot 8 = 40 \equiv 1 \pmod{13}\) → \(y_2 = 8\).
- \(143 \bmod 17 = 143 - 8 \cdot 17 = 7\). \(7 \cdot 5 = 35 \equiv 1 \pmod{17}\) → \(y_3 = 5\).

\(s \equiv 4 \cdot 221 \cdot 1 + 7 \cdot 187 \cdot 8 + 12 \cdot 143 \cdot 5 = 884 + 10472 + 8580 = 19936\).

\(19936 \bmod 2431 = 19936 - 8 \cdot 2431 = 19936 - 19448 = \mathbf{488}\).

검산 — \(488 \bmod 11 = 488 - 44 \cdot 11 = 4\) 확인. \(488 \bmod 13 = 488 - 37 \cdot 13 = 488 - 481 = 7\) 확인. \(488 \bmod 17 = 488 - 28 \cdot 17 = 488 - 476 = 12\) 확인.

</details>

### 문제 5-4 (유형 3) — Python 검산

> 문제 5-3 을 sympy 한 줄로 검산하는 코드를 작성하라.

<details><summary>정답</summary>

```python
from sympy.ntheory.modular import crt
crt([11, 13, 17], [4, 7, 12])
# (488, 2431)
```

</details>

### 문제 5-5 (유형 3) — RNS 수동 시연

> 큰 정수 \(a = 1234567\) 를 모듈러스 \(q_1 = 1009, q_2 = 1013\) (\(q_1 q_2 = 1022117 < 1234567\), **이 경우 RNS 표현이 일의적이지 않음**) 로 표현하려 시도할 때 무엇이 잘못되었는가? 그리고 어떻게 고쳐야 하는가?

<details><summary>모범 답</summary>

CRT 의 ‘유일 복원'은 \(a < M\) 인 경우에만 성립. \(a = 1234567 > 1022117 = M\) 이므로 두 개의 다른 \(a\) 가 같은 \((a \bmod q_1, a \bmod q_2)\) 를 가질 수 있다. **고침** — 더 큰 모듈러스 집합을 추가, 예: \(q_3 = 1019\). 그러면 \(M = 1009 \cdot 1013 \cdot 1019 = 1041548023 \gg a\) 가 되어 일의 복원 가능.

</details>

### 문제 5-6 (유형 2) — zk-SNARK 의 ‘영지식성' 직관

> ‘비밀 \(x\) 를 드러내지 않고 \(y = g^x \bmod p\) 를 안다는 사실을 증명한다'는 영지식 증명의 영지식성이 ‘\(x\) 를 절대 알 수 없다'는 정당화는 어느 가정에 기반하는가? 한 문장으로 서술하라.

<details><summary>모범 답</summary>

DLP(이산 로그 문제)의 어려움 — 검증자가 받은 정보 (\(g, y, p\)) 만으로는 \(x = \log_g y \pmod p\) 를 다항시간에 복원할 수 없다는 가정.

</details>

### 문제 5-7 (유형 4-②) — RAG 샤드 부분 완성

```lean
-- 두 샤드의 CRT 식 합성을 형식화
example (m n : ℕ) (h : Nat.Coprime m n) (a₁ : ZMod m) (a₂ : ZMod n) :
    ∃ a : ZMod (m * n),
      ____ = a₁ ∧ ____ = a₂ := by
  refine ⟨(ZMod.chineseRemainder h).symm (a₁, a₂), ?_, ?_⟩
  · ____
  · ____
```

<details><summary>정답(개요)</summary>

```lean
example (m n : ℕ) (h : Nat.Coprime m n) (a₁ : ZMod m) (a₂ : ZMod n) :
    ∃ a : ZMod (m * n),
      (ZMod.chineseRemainder h a).fst = a₁ ∧
      (ZMod.chineseRemainder h a).snd = a₂ := by
  refine ⟨(ZMod.chineseRemainder h).symm (a₁, a₂), ?_, ?_⟩
  · simp [RingEquiv.apply_symm_apply]
  · simp [RingEquiv.apply_symm_apply]
```

(`simp` 는 `rw [RingEquiv.apply_symm_apply]` 로 풀어 써도 동등.)

</details>

### 문제 5-8 (유형 2) — 양자화 정밀도 분석

> 8비트 양자화에서 행렬 곱 결과를 다시 8비트로 환원할 때 ‘scale 인수 \(s\)' 의 역할을 한 문장으로 설명하라.

<details><summary>모범 답</summary>

양자화 행렬곱은 16비트 정수로 결과가 나오므로, ‘\(s\) 로 나눈 뒤 mod \(2^8\) 으로 잘라' 8 비트 표현 영역에 다시 매핑한다 — ‘\(s\)' 는 ‘이 결과를 다시 8비트의 어느 해상도(scale)에 놓을 것인가'를 결정하는 인수이며, 정확도 손실을 최소화하기 위해 통계적으로 (max-abs 기반) 결정된다.

</details>

---

## 종합 점검 (선택)

### 문제 G-1 (유형 3) — 6 개의 정리·정의를 한 문제로

> 큰 소수 \(p = 31\), 원시근 \(g = 3\) 을 쓰는 단순화된 Diffie–Hellman 키 교환을 생각하자.
> (a) \(g = 3\) 이 정말 mod 31 의 원시근인가? 한 줄로 정당화하라.
> (b) Alice 의 비밀 \(a = 17\), Bob 의 \(b = 19\). \(A, B, K\) 를 손으로 계산.
> (c) 도청자가 \(K\) 를 구하려 할 때 풀어야 하는 ‘이산 로그' 한 줄을 적으라.
> (d) (a)–(c) 의 각 단계에서 ‘이번 절의 어느 정리·정의'가 쓰였는지 표기하라.

<details><summary>풀이</summary>

(a) \(\gcd(3, 31) = 1\). 차수가 30 인지 확인하면 충분. 30 의 진약수 1, 2, 3, 5, 6, 10, 15 에서 \(3^d \not\equiv 1 \pmod{31}\) 이면 차수 30 — 원시근. 직접 계산하면 \(3^1=3\), \(3^2=9\), \(3^3=27\), \(3^5\equiv 26\), \(3^6\equiv 16\), \(3^{10}\equiv 25\), \(3^{15}\equiv 30 \pmod{31}\) 이므로 30 의 진약수 지수에서는 모두 1 이 나오지 않는다. 따라서 차수는 30 이고, 3 은 mod 31 의 원시근이다.

(b) \(A = 3^{17} \bmod 31\). \(3^2 = 9, 3^4 = 81 \equiv 19, 3^8 \equiv 19^2 = 361 \equiv 361 - 11 \cdot 31 = 20, 3^{16} \equiv 20^2 = 400 \equiv 400 - 12 \cdot 31 = 28\). \(3^{17} = 3^{16} \cdot 3 = 28 \cdot 3 = 84 \equiv 84 - 2 \cdot 31 = \mathbf{22}\). → \(A = 22\).

\(B = 3^{19} \bmod 31 = 3^{16} \cdot 3^2 \cdot 3 = 28 \cdot 9 \cdot 3 = 756 \equiv 756 - 24 \cdot 31 = 756 - 744 = \mathbf{12}\). → \(B = 12\).

\(K = B^a = 12^{17} \bmod 31\). \(12^2 = 144 \equiv 144 - 4 \cdot 31 = 20\). \(12^4 \equiv 20^2 = 400 \equiv 28\). \(12^8 \equiv 28^2 = 784 \equiv 784 - 25 \cdot 31 = 9\). \(12^{16} \equiv 81 \equiv 19\). \(12^{17} = 12^{16} \cdot 12 = 19 \cdot 12 = 228 \equiv 228 - 7 \cdot 31 = 11\). → \(K = 11\).

검산: \(K = A^b = 22^{19} \bmod 31\). \(22 \equiv -9\). \(22^2 \equiv 81 \equiv 19\). \(22^4 \equiv 19^2 \equiv 20\). \(22^8 \equiv 20^2 \equiv 28\). \(22^{16} \equiv 28^2 \equiv 9\). \(22^{19} = 22^{16} \cdot 22^2 \cdot 22 = 9 \cdot 19 \cdot 22 = 3762 \equiv 3762 - 121 \cdot 31 = 3762 - 3751 = 11\). → \(K = 11\). 확인

(c) 도청자는 \(g = 3, p = 31, A = 22, B = 12\) 만 안다. \(K\) 를 얻으려면 \(a = \log_3 22 \pmod{30}\) 또는 \(b = \log_3 12 \pmod{30}\) 을 풀어야 한다.

(d) 사용된 도구:
- (a) — **정의 3 (원시근), 정리 3 (페르마: 차수 ∣ \(p-1\) = 30)**.
- (b) — **정리 3** (빠른 누승의 토대), **정리 1** (모듈러 곱셈의 well-definedness).
- (c) — **정의 4 (이산 로그)**, **DLP**.

</details>

### 문제 G-2 (유형 4-③) — 자유 증명 통합

> Lean 4 로 ‘\(\mathbb{Z}/15\mathbb{Z} \cong \mathbb{Z}/3\mathbb{Z} \times \mathbb{Z}/5\mathbb{Z}\)' 의 한 줄 증명을 작성하고, 이로부터 ‘\(3 \cdot 5 = 15\) 인 모든 잉여류가 (mod 3, mod 5) 쌍과 일대일 대응한다'는 사실을 형식적으로 끌어내라.

<details><summary>해설(개요)</summary>

```lean
example : ZMod 15 ≃+* ZMod 3 × ZMod 5 :=
  ZMod.chineseRemainder (by decide : Nat.Coprime 3 5)
```

‘일대일 대응' 은 `RingEquiv` 의 정의로부터 자동 — `Equiv.bijective` 또는 `RingEquiv.toEquiv.bijective`. 학생 풀이의 핵심은 ‘`Nat.Coprime 3 5`' 를 `decide` 로 닫고, 그 위에 `ZMod.chineseRemainder` 를 붙이는 한 줄.

</details>

---

## 부록 — 자가 채점표

| 문제 번호 | 채점 (확인 / 부분 / 미완료) | 비고 |
| --- | --- | --- |
| 1-1 | | |
| 1-2 | | |
| ... | | |
| G-2 | | |

‘부분' 는 ‘부분 정답' 또는 ‘답은 맞으나 풀이가 부정확'한 경우. 워크북 한 회 권장 풀이 시간은 약 6시간(절 전체).

---

## 마무리

이 워크북을 모두 풀고 나면, 4.4절의 6개 정리·정의를 다음 세 가지 차원에서 이해한 것이다.

1. **수학적 차원** — 진술과 증명 (유형 1·2·3).
2. **형식적 차원** — Lean 4 로 ‘기계가 검증한 증명' (유형 4).
3. **응용 차원** — RAG, 분산 시스템, 암호 (유형 3 일부, 5부 전체).

이 세 차원이 ‘하나의 같은 수학'의 세 얼굴임을 체득하는 것이 본 절의 궁극의 목표이다.

— 끝.
