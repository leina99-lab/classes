# 군, 환, CRT, 그리고 RNS — 정식 정리

> 본 문서는 다음 순서로 정의 → 정리 → 증명의 형식으로 서술한다.
>
> 1. **이항 연산**(binary operation)
> 2. **군**(group)
> 3. **환**(ring), **곱환**(product ring), **환 준동형**(ring homomorphism), **환 동형**(ring isomorphism)
> 4. **중국인의 나머지 정리**(Chinese Remainder Theorem, CRT) — 정식 진술과 증명
> 5. **잉여수계**(Residue Number System, RNS) — 정식 정의와 정리
>
> 핵심 관찰은 다음이다.
>
> **RNS의 모든 알고리즘은 CRT의 환 동형사상 증명에서 직접 도출된다.** RNS는 CRT의 결론을 표현 체계로 구현한 것이며, CRT의 구성적 증명이 곧 RNS의 정방향/역방향 변환 알고리즘이다.

---

## 1. 사전 — 군과 환

### 1.1 이항 연산

**정의 1.1** ([이항 연산](#)). 집합 $S$ 위의 **이항 연산**(binary operation)이란 함수

```math
* : S \times S \longrightarrow S
```

를 말한다. 즉 임의의 $a, b \in S$에 대해 $a * b \in S$가 정의되어 있어야 한다. 결과가 다시 $S$ 안에 있다는 사실을 **닫힘**(closure)이라 부른다.

### 1.2 군

**정의 1.2** ([군](#)). 집합 $G$와 그 위의 이항 연산 $*$의 쌍 $(G, *)$가 **군**(group)이라는 것은 다음 세 공리가 모두 성립함을 뜻한다.

| 공리 | 내용 |
|---|---|
| (G1) 결합법칙 | $\forall a, b, c \in G,\; (a * b) * c = a * (b * c)$ |
| (G2) 항등원 | $\exists e \in G,\; \forall a \in G,\; e * a = a * e = a$ |
| (G3) 역원 | $\forall a \in G,\; \exists a^{-1} \in G,\; a * a^{-1} = a^{-1} * a = e$ |

추가로 $\forall a, b \in G,\; a * b = b * a$가 성립하면 $(G, *)$를 **가환군**(commutative group) 또는 **아벨군**(abelian group)이라 부른다.

**예시 1.3**. $(\mathbb{Z}, +)$는 가환군이다. 항등원 $0$, $a$의 역원 $-a$.

**예시 1.4**. $(\mathbb{Z}/n\mathbb{Z}, +)$는 가환군이다. 항등원 $[0]$, $[a]$의 역원 $[-a] = [n - a]$.

### 1.3 환

**정의 1.5** ([환](#)). 집합 $R$과 그 위의 두 이항 연산 $+, \cdot$의 쌍 $(R, +, \cdot)$이 **환**(ring)이라는 것은 다음 네 공리가 모두 성립함을 뜻한다.

| 공리 | 내용 |
|---|---|
| (R1) 덧셈 가환군 | $(R, +)$가 가환군 |
| (R2) 곱셈 결합법칙 | $\forall a, b, c \in R,\; (a \cdot b) \cdot c = a \cdot (b \cdot c)$ |
| (R3) 곱셈 항등원 | $\exists 1 \in R,\; \forall a \in R,\; 1 \cdot a = a \cdot 1 = a$ |
| (R4) 분배법칙 | $\forall a, b, c \in R,\; a \cdot (b + c) = a \cdot b + a \cdot c$ 및 $(a + b) \cdot c = a \cdot c + b \cdot c$ |

추가로 $\forall a, b \in R,\; a \cdot b = b \cdot a$가 성립하면 $(R, +, \cdot)$을 **가환환**(commutative ring)이라 부른다.

**예시 1.6**. $(\mathbb{Z}, +, \cdot)$은 가환환이다.

**예시 1.7**. 임의의 양의 정수 $n$에 대해 $(\mathbb{Z}/n\mathbb{Z}, +, \cdot)$은 가환환이다. 여기서 연산은 잉여류 대표자의 정수 연산을 통한 잘 정의된 사상이다.

### 1.4 곱환

**정리 1.8** ([곱환](#)). 두 환 $(R, +_R, \cdot_R)$과 $(S, +_S, \cdot_S)$의 곱집합 $R \times S$에 다음과 같이 성분별 연산을 부여하자.

```math
(r_1, s_1) + (r_2, s_2) := (r_1 +_R r_2,\; s_1 +_S s_2)
```

```math
(r_1, s_1) \cdot (r_2, s_2) := (r_1 \cdot_R r_2,\; s_1 \cdot_S s_2)
```

이때 $(R \times S, +, \cdot)$도 환이며, 단위원은 $(1_R, 1_S)$이고 영원은 $(0_R, 0_S)$이다.

**증명 스케치**. 환의 네 공리 (R1)–(R4)가 모두 성분별로 자동 성립한다. 예를 들어 분배법칙은 다음과 같이 확인된다.

```math
(r_1, s_1) \cdot ((r_2, s_2) + (r_3, s_3)) = (r_1, s_1) \cdot (r_2 + r_3, s_2 + s_3) = (r_1 \cdot (r_2 + r_3), s_1 \cdot (s_2 + s_3))
```

각 성분에서 $R, S$ 각각의 분배법칙을 쓰면 결론. ■

**귀결**. $k$개의 환 $R_1, \ldots, R_k$에 대해 곱환 $R_1 \times \cdots \times R_k$도 환이다.

### 1.5 환 준동형

**정의 1.9** ([환 준동형](#)). 두 환 $(R, +_R, \cdot_R)$과 $(S, +_S, \cdot_S)$ 사이의 사상 $\phi : R \to S$가 **환 준동형**(ring homomorphism)이라는 것은 다음 세 조건을 모두 만족함을 뜻한다.

| 조건 | 내용 |
|---|---|
| (H1) 덧셈 보존 | $\phi(a +_R b) = \phi(a) +_S \phi(b)$ |
| (H2) 곱셈 보존 | $\phi(a \cdot_R b) = \phi(a) \cdot_S \phi(b)$ |
| (H3) 단위원 보존 | $\phi(1_R) = 1_S$ |

### 1.6 환 동형

**정의 1.10** ([환 동형사상](#)). 환 준동형 $\phi : R \to S$가 **전단사**(bijective)이면 $\phi$를 **환 동형사상**(ring isomorphism)이라 부른다. 이때 $R$과 $S$가 **동형**(isomorphic)이라 하고

```math
R \cong S
```

로 표기한다. Lean 4 Mathlib에서는 `≃+*` 기호로 표현한다.

**주석 1.11**. 환 동형 $\phi$가 전단사이므로 역함수 $\phi^{-1} : S \to R$이 존재하며, $\phi^{-1}$ 역시 자동으로 환 준동형이 된다. 따라서 동형 관계 $\cong$는 동치관계이다.

---

## 2. **중국인의 나머지 정리**(CRT) — 진술과 증명

### 2.1 두 가지 형태의 진술

**정리 2.1** ([CRT — 고전 형태](#)). $m_1, m_2, \ldots, m_k$가 둘씩 서로소인 양의 정수이고 $M = m_1 m_2 \cdots m_k$라 하자. 임의의 정수 $a_1, a_2, \ldots, a_k$에 대해 다음 합동방정식 시스템

```math
\begin{aligned}
x &\equiv a_1 \pmod{m_1} \\
x &\equiv a_2 \pmod{m_2} \\
&\vdots \\
x &\equiv a_k \pmod{m_k}
\end{aligned}
```

은 $M$을 법으로 하여 **유일한 해**를 가진다.

**정리 2.2** ([CRT — 환 동형 형태](#)). 위와 같은 조건에서 다음 사상

```math
\phi : \mathbb{Z}/M\mathbb{Z} \longrightarrow \mathbb{Z}/m_1\mathbb{Z} \times \mathbb{Z}/m_2\mathbb{Z} \times \cdots \times \mathbb{Z}/m_k\mathbb{Z}
```

```math
\phi([x]_M) := ([x]_{m_1},\; [x]_{m_2},\; \ldots,\; [x]_{m_k})
```

는 환 동형사상이다. 즉

```math
\mathbb{Z}/M\mathbb{Z} \;\cong\; \mathbb{Z}/m_1\mathbb{Z} \times \mathbb{Z}/m_2\mathbb{Z} \times \cdots \times \mathbb{Z}/m_k\mathbb{Z}
```

이 성립한다.

### 2.2 두 형태의 동치성

**명제 2.3**. 정리 2.1과 정리 2.2는 논리적으로 동치이다.

**증명**.

(2.2 → 2.1) $\phi$가 전사이므로 임의의 튜플 $([a_1], [a_2], \ldots, [a_k])$에 대해 $\phi([x]_M) = ([a_1], \ldots, [a_k])$를 만족하는 $[x]_M$이 존재한다. 이는 $x \equiv a_i \pmod{m_i}$를 모든 $i$에 대해 만족함을 의미하므로 **존재성** 확보. 또한 $\phi$가 단사이므로 그러한 $[x]_M$은 유일, 즉 $M$을 법으로 해가 유일. **유일성** 확보.

(2.1 → 2.2) 정리 2.6의 (1), (2)에서 $\phi$의 잘 정의됨과 환 준동형성을 보인다. (3) 단사성은 정리 2.1의 유일성으로부터, (4) 전사성은 정리 2.1의 존재성으로부터 따라온다. ■

### 2.3 구성적 증명

**정리 2.4** ([CRT 구성적 증명](#)).

$m_1, \ldots, m_k$를 둘씩 서로소인 양의 정수, $M = \prod_{i=1}^k m_i$라 하자. 각 $i$에 대해

```math
M_i := M / m_i = \prod_{j \neq i} m_j
```

라 정의한다. 그러면 다음이 성립한다.

**(a)** 각 $i$에 대해 $\gcd(M_i, m_i) = 1$.

**(b)** 따라서 확장 유클리드 호제법(Extended Euclidean Algorithm)에 의해 다음을 만족하는 정수 $y_i$가 존재한다.

```math
M_i \cdot y_i \equiv 1 \pmod{m_i}
```

**(c)** 임의의 정수 튜플 $(a_1, a_2, \ldots, a_k)$에 대해

```math
x := \sum_{i=1}^k a_i \cdot M_i \cdot y_i
```

는 합동방정식 시스템

```math
x \equiv a_i \pmod{m_i}, \quad i = 1, 2, \ldots, k
```

의 해이며, $M$을 법으로 유일하다.

**증명**.

**(a)** $j \neq i$이면 $\gcd(m_j, m_i) = 1$ (가정). $M_i$는 그러한 $m_j$들의 곱이므로 $\gcd(M_i, m_i) = 1$.

**(b)** (a)와 베주 항등식(또는 확장 유클리드 호제법)에 의해 $M_i u + m_i v = 1$인 정수 $u, v$가 존재. $y_i := u$로 놓으면 $M_i y_i \equiv 1 \pmod{m_i}$.

**(c)** 임의의 $i$를 고정하자. 위 정의의 $x$에 대해

```math
x = \sum_{j=1}^k a_j M_j y_j
```

각 $j \neq i$에 대해, $m_i \mid M_j$ (왜냐하면 $M_j$의 정의에 $m_i$가 포함되어 있음). 따라서

```math
a_j M_j y_j \equiv 0 \pmod{m_i}, \quad j \neq i
```

한편 $j = i$에 대해서는 (b)에 의해

```math
a_i M_i y_i \equiv a_i \cdot 1 = a_i \pmod{m_i}
```

따라서

```math
x \equiv a_i \pmod{m_i}
```

이 모든 $i$에 대해 성립. **존재성** 증명 완료.

**유일성**. $x_1, x_2$가 모두 해라 하면 모든 $i$에 대해 $m_i \mid (x_1 - x_2)$. $m_i$들이 둘씩 서로소이므로, 다음 보조정리에 의해 $M = \prod m_i$도 $(x_1 - x_2)$를 나눈다. 따라서 $x_1 \equiv x_2 \pmod{M}$. ■

**보조정리 2.5** ([서로소 곱의 정리](#)). $m_1, \ldots, m_k$가 둘씩 서로소이고 모두 정수 $n$을 나누면 $\prod m_i$도 $n$을 나눈다.

**증명**. $k$에 대한 귀납. $k = 1$은 자명. $k = 2$의 경우, $m_1 \mid n$이므로 $n = m_1 t$로 쓸 수 있다. $m_2 \mid n = m_1 t$, 그리고 $\gcd(m_1, m_2) = 1$이므로 $m_2 \mid t$. 따라서 $t = m_2 s$, $n = m_1 m_2 s$, 즉 $m_1 m_2 \mid n$. 일반 $k$는 귀납으로. ■

### 2.4 환 동형 진술의 증명

**정리 2.6** (정리 2.2의 증명). 정리 2.2의 사상 $\phi$는 환 동형사상이다.

**증명**. 네 단계로 보인다.

**(1) 잘 정의됨**. $[x]_M = [y]_M$이면 $M \mid (x - y)$. 각 $i$에 대해 $m_i \mid M$이므로 $m_i \mid (x - y)$, 즉 $[x]_{m_i} = [y]_{m_i}$. 따라서 $\phi([x]_M) = \phi([y]_M)$.

**(2) 환 준동형**. 정의 1.9의 세 조건을 확인한다.

- (H1) 덧셈 보존: $\phi([x] + [y]) = \phi([x + y]) = ([x+y]_{m_1}, \ldots) = ([x]_{m_1} + [y]_{m_1}, \ldots) = \phi([x]) + \phi([y])$.
- (H2) 곱셈 보존: 동일한 방식으로 $\phi([x] \cdot [y]) = \phi([x]) \cdot \phi([y])$.
- (H3) 단위원 보존: $\phi([1]_M) = ([1]_{m_1}, [1]_{m_2}, \ldots, [1]_{m_k}) = 1_{R_1 \times \cdots \times R_k}$.

**(3) 단사**. $\phi([x]_M) = \phi([y]_M)$이면 모든 $i$에 대해 $[x]_{m_i} = [y]_{m_i}$, 즉 $m_i \mid (x - y)$. 보조정리 2.5에 의해 $M \mid (x - y)$, 즉 $[x]_M = [y]_M$.

**(4) 전사**. 임의의 튜플 $([a_1], [a_2], \ldots, [a_k])$가 주어지면, 정리 2.4 (c)에 의해 $x = \sum_i a_i M_i y_i$가 $x \equiv a_i \pmod{m_i}$를 만족. 따라서 $\phi([x]_M) = ([a_1], [a_2], \ldots, [a_k])$.

(1)–(4)에 의해 $\phi$는 환 동형사상. ■

---

## 3. **잉여수계**(RNS) — 정식 정의와 정리

### 3.1 RNS의 정의

**정의 3.1** ([잉여수계, RNS](#)).

다음 세 요소가 갖춰진 표현 체계를 **잉여수계**(Residue Number System, RNS)라 부른다.

| 요소 | 정의 |
|---|---|
| **법 집합**(moduli set, 기저 basis) | 둘씩 서로소인 양의 정수의 유한 집합 $\mathcal{B} = \{m_1, m_2, \ldots, m_k\}$ |
| **동적 범위**(dynamic range) | $M := m_1 m_2 \cdots m_k$ |
| **RNS 표현**(RNS representation) | 각 $x \in \{0, 1, \ldots, M-1\}$에 대해 튜플 $\mathrm{RNS}_{\mathcal{B}}(x) := (x_1, x_2, \ldots, x_k)$를 대응시키되, $x_i := x \bmod m_i$ |

이 표현 체계를 $\mathcal{B}$에 대한 RNS라 하고, 튜플 $(x_1, \ldots, x_k)$를 $x$의 RNS 표현이라 한다.

### 3.2 RNS 표현 정리 (CRT의 환 동형 형태의 직접 응용)

**정리 3.2** ([RNS 표현 정리](#)).

법 집합 $\mathcal{B} = \{m_1, \ldots, m_k\}$의 RNS에 대해 다음이 성립한다.

대응 $\mathrm{RNS}_{\mathcal{B}}$는 집합

```math
\{0, 1, \ldots, M-1\}
```

과

```math
\mathbb{Z}/m_1\mathbb{Z} \times \mathbb{Z}/m_2\mathbb{Z} \times \cdots \times \mathbb{Z}/m_k\mathbb{Z}
```

사이의 **일대일대응**(bijection)이다. 즉 모든 $x \in \{0, 1, \ldots, M-1\}$에 대해 RNS 표현이 유일하게 결정되고, 역으로 모든 튜플 $(a_1, \ldots, a_k) \in \prod_i \mathbb{Z}/m_i\mathbb{Z}$에 대해 유일한 $x \in \{0, 1, \ldots, M-1\}$가 존재하여 $\mathrm{RNS}_{\mathcal{B}}(x) = ([a_1], \ldots, [a_k])$.

**증명**. $\{0, 1, \ldots, M-1\}$이 $\mathbb{Z}/M\mathbb{Z}$의 표준적 대표자 집합이므로, $\mathrm{RNS}_{\mathcal{B}}$는 본질적으로 정리 2.2의 환 동형사상 $\phi$와 동일하다. $\phi$가 전단사이므로 끝. ■

### 3.3 RNS 산술 정리 (CRT의 환 준동형 성질의 직접 응용)

**정리 3.3** ([RNS 산술 정리](#)).

$x, y \in \{0, 1, \ldots, M-1\}$이고 그 RNS 표현이 각각 $\mathrm{RNS}_{\mathcal{B}}(x) = (x_1, \ldots, x_k)$, $\mathrm{RNS}_{\mathcal{B}}(y) = (y_1, \ldots, y_k)$라 하자. 그러면 다음이 성립한다.

**(A) 덧셈**:

```math
\mathrm{RNS}_{\mathcal{B}}((x + y) \bmod M) = ((x_1 + y_1) \bmod m_1,\; (x_2 + y_2) \bmod m_2,\; \ldots,\; (x_k + y_k) \bmod m_k)
```

**(B) 곱셈**:

```math
\mathrm{RNS}_{\mathcal{B}}((x \cdot y) \bmod M) = ((x_1 \cdot y_1) \bmod m_1,\; (x_2 \cdot y_2) \bmod m_2,\; \ldots,\; (x_k \cdot y_k) \bmod m_k)
```

**증명**. 정리 2.6 (2) (H1), (H2)에 의해 $\phi$는 덧셈과 곱셈을 보존한다. 즉

```math
\phi([x] + [y]) = \phi([x]) + \phi([y]), \qquad \phi([x] \cdot [y]) = \phi([x]) \cdot \phi([y])
```

우변의 덧셈/곱셈은 곱환 $\prod_i \mathbb{Z}/m_i\mathbb{Z}$에서의 연산이며, 정리 1.8에 의해 성분별 연산이다. 좌변을 RNS 표현으로 옮겨 쓰면 결론 (A), (B). ■

### 3.4 RNS의 본질적 이점 — 자릿수 올림 부재 정리

**정리 3.4** ([RNS 독립성 정리, Independence](#)).

정리 3.3에서 $i$번째 컴포넌트의 결과 $(x_i \pm y_i) \bmod m_i$ 또는 $(x_i \cdot y_i) \bmod m_i$는 오로지 $x_i, y_i, m_i$에만 의존하며, 다른 $j \neq i$ 컴포넌트 $x_j, y_j, m_j$에 전혀 의존하지 않는다.

따라서 $k$개의 컴포넌트 연산은 **완전히 독립**이며, $k$개의 코어 또는 회로 단위가 동시에 병렬 수행 가능하다. 컴포넌트 사이에 **자릿수 올림**(carry)이 발생하지 않는다.

**증명**. 정리 3.3의 (A), (B) 진술 자체가 각 컴포넌트의 결과를 다른 컴포넌트와 독립적으로 정의하고 있으므로 자명. ■

### 3.5 정방향 변환 알고리즘

**알고리즘 3.5** ([정방향 변환 — 정수에서 RNS로](#)).

- **입력**: $x \in \{0, 1, \ldots, M-1\}$, 법 집합 $\mathcal{B} = \{m_1, \ldots, m_k\}$.
- **출력**: RNS 표현 $(x_1, x_2, \ldots, x_k)$.
- **계산**: 각 $i$에 대해 $x_i \leftarrow x \bmod m_i$.

이는 정의 3.1의 직접 적용이다. 즉 **정방향 변환은 CRT 사상 $\phi$의 정의 그 자체**이다.

### 3.6 역방향 변환 알고리즘 — CRT 증명에서 직접 도출

**알고리즘 3.6** ([역방향 변환 — RNS에서 정수로, CRT 공식](#)).

- **입력**: RNS 표현 $(a_1, a_2, \ldots, a_k)$, 법 집합 $\mathcal{B} = \{m_1, \ldots, m_k\}$.
- **출력**: $x \in \{0, 1, \ldots, M-1\}$ with $\mathrm{RNS}_{\mathcal{B}}(x) = (a_1, \ldots, a_k)$.
- **전처리**(법 집합마다 한 번):
  1. $M_i \leftarrow M / m_i$, $i = 1, \ldots, k$.
  2. 확장 유클리드 호제법으로 $y_i$ 계산: $M_i y_i \equiv 1 \pmod{m_i}$.
- **본 계산**:

```math
x \leftarrow \left( \sum_{i=1}^{k} a_i \cdot M_i \cdot y_i \right) \bmod M
```

**정당성**. 알고리즘 3.6이 올바른 출력을 내는 이유는 정리 2.4 (c)이다. **CRT 증명의 (c)에 등장한 공식이 정확히 알고리즘 3.6의 본 계산이다.**

### 3.7 RNS = CRT의 표현화 — 핵심 관찰

**관찰 3.7**.

표 3.7. CRT 증명과 RNS의 1대1 대응.

| CRT 증명의 구성 요소 | RNS의 대응 요소 |
|---|---|
| 사상 $\phi([x]_M) = ([x]_{m_1}, \ldots, [x]_{m_k})$ | 정방향 변환 (알고리즘 3.5) |
| $\phi$의 환 준동형성 (정리 2.6 (2)) | RNS 산술 정리 (정리 3.3) |
| $\phi$의 단사성 (정리 2.6 (3)) | RNS 표현의 유일성 (정리 3.2) |
| $\phi$의 전사성 (정리 2.6 (4)) | 임의의 RNS 표현이 정수로 복원 가능 (정리 3.2) |
| 정리 2.4 (c) 공식 $x = \sum_i a_i M_i y_i$ | 역방향 변환 (알고리즘 3.6) |
| $M_i y_i \equiv 1 \pmod{m_i}$ (정리 2.4 (b)) | 전처리 단계 |

**즉, RNS는 CRT의 결론을 표현 체계로 구현한 것**이다. CRT를 증명하는 순간, RNS의 모든 알고리즘과 정리가 동시에 증명된다.

### 3.8 구체 예제 — 손자 법 집합으로 RNS 동작 확인

법 집합 $\mathcal{B} = \{3, 5, 7\}$, $M = 105$.

**전처리**:

```math
M_1 = 35, \quad M_2 = 21, \quad M_3 = 15
```

확장 유클리드로:

- $35 y_1 \equiv 1 \pmod 3$. $35 \equiv 2 \pmod 3$이므로 $2 y_1 \equiv 1 \pmod 3$, $y_1 = 2$.
- $21 y_2 \equiv 1 \pmod 5$. $21 \equiv 1 \pmod 5$이므로 $y_2 = 1$.
- $15 y_3 \equiv 1 \pmod 7$. $15 \equiv 1 \pmod 7$이므로 $y_3 = 1$.

**정방향 (정수 → RNS)**:

```math
\mathrm{RNS}_{\mathcal{B}}(23) = (23 \bmod 3,\; 23 \bmod 5,\; 23 \bmod 7) = (2, 3, 2)
```

```math
\mathrm{RNS}_{\mathcal{B}}(47) = (2, 2, 5)
```

**RNS 덧셈 (정리 3.3 (A) 검증)**:

```math
\mathrm{RNS}_{\mathcal{B}}(23) + \mathrm{RNS}_{\mathcal{B}}(47) = (2+2 \bmod 3,\; 3+2 \bmod 5,\; 2+5 \bmod 7) = (1, 0, 0)
```

역방향 검증: $1 \cdot 35 \cdot 2 + 0 \cdot 21 \cdot 1 + 0 \cdot 15 \cdot 1 = 70$. 또한 $23 + 47 = 70$. ✓

**RNS 곱셈 (정리 3.3 (B) 검증)**:

```math
\mathrm{RNS}_{\mathcal{B}}(23) \cdot \mathrm{RNS}_{\mathcal{B}}(47) = (2 \cdot 2 \bmod 3,\; 3 \cdot 2 \bmod 5,\; 2 \cdot 5 \bmod 7) = (1, 1, 3)
```

역방향: $x = 1 \cdot 35 \cdot 2 + 1 \cdot 21 \cdot 1 + 3 \cdot 15 \cdot 1 = 70 + 21 + 45 = 136 \equiv 31 \pmod{105}$. 한편 $23 \cdot 47 = 1081 \equiv 31 \pmod{105}$. ✓

**역방향 변환 직접 예시 (알고리즘 3.6)**. 튜플 $(2, 3, 2)$로부터 $x$ 복원.

```math
x = 2 \cdot 35 \cdot 2 + 3 \cdot 21 \cdot 1 + 2 \cdot 15 \cdot 1 = 140 + 63 + 30 = 233 \equiv 23 \pmod{105}
```

손자 문제의 답과 일치. ✓

---

## 4. 통합 그림 — 빌드업과 의존 관계

흐름:

![CRT와 RNS의 빌드업 및 의존 관계도](images/crt_rns_buildup.png)

*그림 4.1. 이항 연산부터 RNS 알고리즘까지의 정의·정리 의존 관계. CRT의 환 동형사상 정리와 그 구성적 증명에서 RNS의 모든 정리·알고리즘이 직접 도출됨을 보여 준다.*

**핵심 명제**.

$$
\boxed{
\begin{aligned}
&\text{RNS 정방향} = \phi \text{ 자체} \\
&\text{RNS 산술} = \phi \text{의 환 준동형성} \\
&\text{RNS 역방향} = \text{CRT 증명 (c)의 공식 } x = \sum_i a_i M_i y_i \\
&\text{RNS 독립성} = \text{성분별 연산의 자동 성질}
\end{aligned}
}
$$

즉 **CRT의 환 동형사상 정리와 그 구성적 증명이 곧 RNS의 정의·정리·알고리즘 모두를 포함한다.** RNS는 별개의 정리 체계가 아니라 CRT의 결론을 표현 체계로 구현·재명명한 것이다.

이것이 "RNS는 CRT 다음에 자연스럽게 나온다"는 말의 정식 의미이다.
