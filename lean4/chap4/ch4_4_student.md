# 이산수학 4.4절 합동 풀기

## 0부 — 도입: 합동(congruence)이란

### 0.1 합동의 정의와 직관

두 정수 $a$ 와 $b$ 가 양의 정수 $m$ 에 대해 **합동**(congruent)이라 함은

$$a \equiv b \pmod{m} \iff m \mid (a - b)$$

이 성립한다는 뜻이다. 즉 $a - b$ 가 $m$ 의 배수이다.

직관적으로 합동은 **시계 산술**(clock arithmetic)이다. 12 시간 시계에서 17 시는 5 시와 같으며, 이를 합동의 언어로 적으면 $17 \equiv 5 \pmod{12}$ 이다. 마찬가지로 24 시간 시계에서 25 시는 1 시와 같고 $25 \equiv 1 \pmod{24}$ 이다. 일상에서 무심코 쓰는 "12 시간 후"나 "일주일 뒤"라는 사고가 모두 합동 산술이다.

본 절(4.4)에서는 이 합동 관계를 **풀어야 할 방정식**의 객체로 격상시킨다. " $5x \equiv 3 \pmod{11}$ 의 해는?" 같은 질문에 체계적으로 답하는 도구를 갖추는 것이 목적이다.

### 0.2 합동의 세 가지 기본 성질

합동은 정수 집합 위의 **동치관계**(equivalence relation)이다. 다음 세 가지가 성립한다.

1. **반사성**(reflexivity) — 모든 $a$ 에 대해 $a \equiv a \pmod{m}$.
2. **대칭성**(symmetry) — $a \equiv b \pmod{m}$ 이면 $b \equiv a \pmod{m}$.
3. **추이성**(transitivity) — $a \equiv b \pmod{m}$ 이고 $b \equiv c \pmod{m}$ 이면 $a \equiv c \pmod{m}$.

세 성질의 직접적 결과로 정수 전체가 **잉여류**(residue classes)로 분할된다. $\bmod m$ 에서 정확히 $m$ 개의 잉여류가 존재하며 이를 $\mathbb{Z}/m\mathbb{Z}$, 혹은 Lean 4 에서 `ZMod m` 으로 표기한다.

또한 합동은 **연산을 보존**한다. $a \equiv b \pmod m$, $c \equiv d \pmod m$ 이면

$$a + c \equiv b + d \pmod m, \qquad a \cdot c \equiv b \cdot d \pmod m$$

이 성립한다. 본 절의 모든 풀이가 이 두 사실에 의존한다.



## 1부 — 선형 합동과 모듈러 역원 (정리 1)

### 1.1 정리 1 — 모듈러 역원의 존재·유일성

> **정리 1**. 정수 $a$, $m$ 이 $\gcd(a, m) = 1$ 을 만족한다고 하자. 그러면 다음 합동을 만족하는 정수 $a^{-1}$ 이 $\bmod m$ 에 대해 **유일하게 존재한다**.
>
> $$a \cdot a^{-1} \equiv 1 \pmod{m}$$

이 $a^{-1}$ 을 $a$ 의 **모듈러 역원**(modular inverse)이라 부른다. 정리 1 은 본 절 전체의 골격이다 — 선형 합동을 풀고, CRT 의 명시적 해 공식 안에 들어가고, 페르마의 작은 정리를 매개로 RSA 까지 연결되는 모든 토대가 이 한 정리로부터 출발한다.

### 1.2 정리 1 의 증명

증명은 4 단계로 진행한다.

**1 단계 (베주 항등식 호출)** — $\gcd(a, m) = 1$ 이라는 가정으로부터 **베주 항등식**(Bézout's identity)이 성립한다. 즉 정수 $s, t$ 가 존재하여 다음이 성립한다.

$$sa + tm = 1$$

**2 단계 (양변을 mod $m$ 으로)** — 위 등식의 양변을 $\bmod m$ 으로 환원하면 $tm$ 항이 사라진다. 따라서

$$sa \equiv 1 \pmod{m}$$

가 얻어진다.

**3 단계 (역원의 정체)** — 위 식이 정확히 " $s$ 가 $a$ 의 역원이다"라는 뜻이다. 따라서 $a^{-1} = s$ 로 두면 존재성이 증명된다.

**4 단계 (유일성)** — $a$ 의 역원이 두 개 있다고 가정하자. 즉 $a_1^{-1}, a_2^{-1}$ 이 모두 $a \cdot a_i^{-1} \equiv 1 \pmod m$ 을 만족한다. 그러면

$$a_1^{-1} \equiv a_1^{-1} \cdot (a \cdot a_2^{-1}) \equiv (a_1^{-1} \cdot a) \cdot a_2^{-1} \equiv 1 \cdot a_2^{-1} \equiv a_2^{-1} \pmod{m}$$

이므로 두 역원은 $\bmod m$ 에서 같다. 곧 유일하다. $\blacksquare$

### 1.3 예제 1 — `3⁻¹ mod 7` 의 계산

정리 1 의 가정은 $\gcd(3, 7) = 1$ 로 만족된다. 베주 계수를 **확장 유클리드 호제법**(extended Euclidean algorithm)으로 구한다.

```
7 = 2·3 + 1     →     1 = 7 − 2·3
```

따라서 $1 = (-2) \cdot 3 + 1 \cdot 7$ 로 베주 항등식이 얻어진다. $a = 3$ 에 곱해진 계수가 $-2$ 이므로

$$3^{-1} \equiv -2 \equiv 5 \pmod{7}$$

**검산** — $3 \cdot 5 = 15 = 2 \cdot 7 + 1 \equiv 1 \pmod 7$. $\checkmark$

### 1.4 예제 2 — `5x ≡ 3 (mod 11)` 의 해

선형 합동 $ax \equiv b \pmod m$ 의 풀이는 두 단계이다.

1. $\gcd(a, m) = 1$ 이면 정리 1 로 $a^{-1}$ 을 구한다.
2. 양변에 $a^{-1}$ 을 곱하면 $x \equiv a^{-1} b \pmod m$ 이 해이다.

본 예제에서는 $\gcd(5, 11) = 1$ 이다. 확장 유클리드:

```
11 = 2·5 + 1   →   1 = 11 − 2·5
```

따라서 $5^{-1} \equiv -2 \equiv 9 \pmod{11}$. 양변에 곱하면

$$x \equiv 9 \cdot 3 = 27 \equiv 5 \pmod{11}$$

**검산** — $5 \cdot 5 = 25 = 2 \cdot 11 + 3 \equiv 3 \pmod{11}$. $\checkmark$

### 1.5 예제 3 — `12x ≡ 7 (mod 15)` 은 해가 있는가?

이번에는 $\gcd(12, 15) = 3$ 으로 1 이 아니다. 정리 1 의 가정이 깨진다.

일반 사실로서 $ax \equiv b \pmod m$ 의 해 존재 조건은 $\gcd(a, m) \mid b$ 이다. 본 예제에서는 $3 \mid 7$ 이 거짓이므로 **해가 존재하지 않는다**.

이는 1 부의 핵심 교훈이다 — " $\gcd = 1$"은 단순 가정이 아니라 **해의 존재성 자체를 결정하는 조건**이다.

### 1.6 Lean 4 — 선형 합동의 형식화

```lean
import Mathlib.Data.ZMod.Basic

-- (1) 모듈러 역원의 명시적 검증: 3⁻¹ ≡ 5 (mod 7)
example : (3 : ZMod 7) * 5 = 1 := by decide

-- (2) 선형 합동의 가해성: a ≠ 0 (in ZMod p, p 소수) 이면 모든 b 에 대해 해가 존재
example (a b : ZMod 7) (ha : a ≠ 0) :
    ∃ x : ZMod 7, a * x = b := by
  refine ⟨a⁻¹ * b, ?_⟩
  rw [← mul_assoc, ZMod.mul_inv_of_unit a (Ne.isUnit ha), one_mul]
```

**해설** — `ZMod 7` 은 7 이 소수이므로 **체**(field)이다. 따라서 0 이 아닌 모든 원소에 곱셈 역원이 존재한다(이것이 정리 1 의 형식 버전). `Ne.isUnit ha` 는 "0 이 아닌 원소는 단원(unit)이다"라는 사실을 추출하고, `ZMod.mul_inv_of_unit` 은 단원의 역원이 정의를 만족함을 보장한다. `rw` 만으로 $a \cdot (a^{-1} b) = (a \cdot a^{-1}) b = 1 \cdot b = b$ 가 미시적으로 전개되었다.

### 1.7 Python 으로 빠르게 확인

```python
from sympy import gcdex

# 5x ≡ 3 (mod 11)
g, s, t = gcdex(5, 11)        # 베주 계수
inv5 = int(s) % 11             # 9
x = (inv5 * 3) % 11            # 5
print(x)                       # 5

# 일반 함수
def linear_congruence(a, b, m):
    from math import gcd
    if b % gcd(a, m) != 0:
        return None             # 해 없음
    g, s, _ = gcdex(a, m)
    return (int(s) * b // g) % (m // g)

print(linear_congruence(5, 3, 11))    # 5
print(linear_congruence(12, 7, 15))   # None
```

Python 의 `sympy.gcdex` 가 $sa + tm = g$ 의 $(g, s, t)$ 를 한 번에 돌려주므로 베주 계수를 따로 손계산할 필요가 없다.

---

## 2부 — 중국인의 나머지 정리 (CRT, 정리 2)
# 중국인의 나머지 정리와 역대입법 설명

## 2.0. 문제

다음 세 합동식을 동시에 만족하는 모든 정수 $x$를 구한다.

$$
x \equiv 1 \pmod{5}
$$

$$
x \equiv 2 \pmod{6}
$$

$$
x \equiv 3 \pmod{7}
$$

결론은 다음이다.

$$
\boxed{x \equiv 206 \pmod{210}}
$$

즉 모든 정수해는

$$
\boxed{x = 210n + 206 \quad (n \in \mathbb Z)}
$$

이다.

예를 들면

$$
\ldots, -214, -4, 206, 416, 626, \ldots
$$

가 모두 해이다.

---

## 1. 합동식의 뜻

$$
x \equiv 1 \pmod{5}
$$

라는 말은

> $x$를 5로 나누면 나머지가 1이다.

라는 뜻이다.

따라서 $x$는 반드시 다음 꼴이다.

$$
x = 5t + 1
$$

여기서 $t$는 정수이다.

예를 들어 $t = 0, 1, 2, 3, \ldots$이면

$$
x = 1, 6, 11, 16, \ldots
$$

이다. 전부 5로 나누면 나머지가 1이다.

일반적으로 다음이 성립한다.

$$
x \equiv a \pmod{m}
$$

이라는 말은

$$
x = mk + a
$$

라고 쓸 수 있다는 뜻이다. 여기서 $k$는 정수이다.

---

## 2.1. 역대입법 풀이

역대입법은 조건을 하나씩 반영하면서 식을 점점 좁혀 가는 방법이다.

처음에는 첫 번째 조건만 만족하는 모든 수를 쓴다. 그다음 두 번째 조건을 넣고, 마지막으로 세 번째 조건을 넣는다.

---

## 2.2. 첫 번째 조건 사용

첫 번째 조건은

$$
x \equiv 1 \pmod{5}
$$

이다.

따라서

$$
x = 5t + 1
$$

이라고 쓸 수 있다.

여기까지는 “5로 나누면 나머지가 1인 모든 수”를 표현한 것이다.

---

## 2.3. 두 번째 조건 사용

두 번째 조건은

$$
x \equiv 2 \pmod{6}
$$

이다.

그런데 앞에서

$$
x = 5t + 1
$$

이라고 했으므로, 이것을 두 번째 조건에 대입한다.

$$
5t + 1 \equiv 2 \pmod{6}
$$

양변에서 1을 빼면

$$
5t \equiv 1 \pmod{6}
$$

이제 $t$를 구해야 한다.

$$
5 \equiv -1 \pmod{6}
$$

이므로

$$
5t \equiv -t \pmod{6}
$$

따라서

$$
-t \equiv 1 \pmod{6}
$$

양변에 마이너스를 붙이면

$$
t \equiv -1 \pmod{6}
$$

그런데 modulo 6에서 $-1$은 $5$와 같다.

$$
-1 \equiv 5 \pmod{6}
$$

따라서

$$
t \equiv 5 \pmod{6}
$$

이다.

이 말은 $t$가 6으로 나누었을 때 나머지가 5라는 뜻이다. 따라서

$$
t = 6u + 5
$$

라고 쓸 수 있다. 여기서 $u$는 정수이다.

---

## 2.4. 다시 $x$에 대입

처음에

$$
x = 5t + 1
$$

이었다.

그런데 방금

$$
t = 6u + 5
$$

라고 구했다.

따라서 $t$ 자리에 $6u+5$를 대입한다.

$$
x = 5(6u + 5) + 1
$$

계산하면

$$
x = 30u + 25 + 1
$$

$$
x = 30u + 26
$$

이제 중요한 점은 다음이다.

$$
x = 30u + 26
$$

꼴의 수는 첫 번째 조건과 두 번째 조건을 이미 자동으로 만족한다.

확인해 보자.

modulo 5에서 보면

$$
30u + 26 \equiv 0 + 1 \equiv 1 \pmod{5}
$$

이다. 왜냐하면 $30u$는 5의 배수이고, $26 \equiv 1 \pmod{5}$이기 때문이다.

modulo 6에서 보면

$$
30u + 26 \equiv 0 + 2 \equiv 2 \pmod{6}
$$

이다. 왜냐하면 $30u$는 6의 배수이고, $26 \equiv 2 \pmod{6}$이기 때문이다.

즉 지금까지 우리는

$$
x \equiv 1 \pmod{5}, \qquad x \equiv 2 \pmod{6}
$$

을 동시에 만족하는 모든 $x$를

$$
x = 30u + 26
$$

꼴로 정리한 것이다.

---

## 2.5. 세 번째 조건 사용

세 번째 조건은

$$
x \equiv 3 \pmod{7}
$$

이다.

그런데

$$
x = 30u + 26
$$

이므로, 이것을 세 번째 조건에 대입한다.

$$
30u + 26 \equiv 3 \pmod{7}
$$

이제 modulo 7에서 정리한다.

$$
30 \equiv 2 \pmod{7}
$$

왜냐하면

$$
30 = 7 \cdot 4 + 2
$$

이기 때문이다.

또

$$
26 \equiv 5 \pmod{7}
$$

왜냐하면

$$
26 = 7 \cdot 3 + 5
$$

이기 때문이다.

따라서

$$
30u + 26 \equiv 2u + 5 \pmod{7}
$$

이다.

그러므로 식은

$$
2u + 5 \equiv 3 \pmod{7}
$$

가 된다.

양변에서 5를 빼면

$$
2u \equiv -2 \pmod{7}
$$

그런데 modulo 7에서 $-2$는 $5$와 같다.

$$
-2 \equiv 5 \pmod{7}
$$

따라서

$$
2u \equiv 5 \pmod{7}
$$

이다.

이제 $2u \equiv 5 \pmod{7}$을 풀어야 한다.

2의 modulo 7에서의 역원은 4이다. 왜냐하면

$$
2 \cdot 4 = 8 \equiv 1 \pmod{7}
$$

이기 때문이다.

따라서 양변에 4를 곱한다.

$$
4 \cdot 2u \equiv 4 \cdot 5 \pmod{7}
$$

$$
8u \equiv 20 \pmod{7}
$$

그런데

$$
8 \equiv 1 \pmod{7}
$$

이고

$$
20 \equiv 6 \pmod{7}
$$

이므로

$$
u \equiv 6 \pmod{7}
$$

이다.

따라서

$$
u = 7v + 6
$$

이라고 쓸 수 있다. 여기서 $v$는 정수이다.

---

## 2.6. 마지막 대입

앞에서

$$
x = 30u + 26
$$

을 얻었다.

그리고 방금

$$
u = 7v + 6
$$

을 얻었다.

따라서 $u$ 자리에 $7v+6$을 대입한다.

$$
x = 30(7v + 6) + 26
$$

계산하면

$$
x = 210v + 180 + 26
$$

$$
x = 210v + 206
$$

따라서 모든 해는

$$
\boxed{x = 210v + 206 \quad (v \in \mathbb Z)}
$$

이다.

이를 합동식으로 쓰면

$$
\boxed{x \equiv 206 \pmod{210}}
$$

이다.

책에 마지막 줄이

$$
x = 30(7v+6)+26 = 210v+206
$$

$$
x = 210v + 206
$$

이어야 한다.

---

## 2.7. 검산

대표값으로 $x=206$을 넣어 보자.

첫 번째 조건:

$$
206 = 5 \cdot 41 + 1
$$

따라서

$$
206 \equiv 1 \pmod{5}
$$

이다.

두 번째 조건:

$$
206 = 6 \cdot 34 + 2
$$

따라서

$$
206 \equiv 2 \pmod{6}
$$

이다.

세 번째 조건:

$$
206 = 7 \cdot 29 + 3
$$

따라서

$$
206 \equiv 3 \pmod{7}
$$

이다.

모두 맞다.

그리고 $210$은 5, 6, 7의 공배수이다.

$$
210 = 5 \cdot 42 = 6 \cdot 35 = 7 \cdot 30
$$

그래서 $206$에 $210$을 더하거나 빼도 나머지는 변하지 않는다.

예를 들어

$$
206 + 210 = 416
$$

도 해이고,

$$
206 - 210 = -4
$$

도 해이다.

그래서 답은 하나의 숫자 $206$만이 아니라

$$
x = 210n + 206
$$

전체이다.

---

# 2.8. 중국인의 나머지 정리

중국인의 나머지 정리(Chinese Remainder Theorem)는 여러 개의 합동식을 한 번에 푸는 공식이다.

예를 들어 다음과 같은 식들이 있다고 하자.

$$
x \equiv a_1 \pmod{m_1}
$$

$$
x \equiv a_2 \pmod{m_2}
$$

$$
\cdots
$$

$$
x \equiv a_n \pmod{m_n}
$$

여기서 $m_1, m_2, \ldots, m_n$이 서로소라고 하자.

서로소라는 말은 서로 공통으로 나누는 수가 1밖에 없다는 뜻이다.

예를 들어 5, 6, 7은 서로소이다.

$$
\gcd(5,6)=1, \qquad \gcd(5,7)=1, \qquad \gcd(6,7)=1
$$

이때 전체 곱을

$$
m = m_1m_2\cdots m_n
$$

이라고 둔다.

그리고

$$
M_k = \frac{m}{m_k}
$$

라고 둔다.

즉 $M_k$는 전체 곱 $m$에서 $m_k$만 빼고 나머지를 곱한 것이다.

---

## 2.9. $y_k$의 의미

책에서 $y_k$라는 문자가 나온다.

$$
M_k y_k \equiv 1 \pmod{m_k}
$$

를 만족하는 수 $y_k$를 찾는 것이다.

이 말은 $y_k$가 $M_k$의 modulo $m_k$에서의 역원이라는 뜻이다.

쉽게 말하면 다음과 같다.

> $M_k$에 곱했을 때 나머지가 1이 되게 만드는 수가 $y_k$이다.

---

## 2.10. 중국인의 나머지 정리 공식

공식은 다음이다.

$$
x = a_1M_1y_1 + a_2M_2y_2 + \cdots + a_nM_ny_n
$$

이렇게 만든 $x$는 모든 합동식을 동시에 만족한다.

왜 작동하는지 감각적으로 보면, 각각의 항이 “자기 자리에서만 작동하는 스위치”처럼 만들어져 있기 때문이다.

---

## 2.11. 공식이 작동하는 이유

$k$번째 조건

$$
x \equiv a_k \pmod{m_k}
$$

을 확인한다고 하자.

전체 합은

$$
a_1M_1y_1 + \cdots + a_kM_ky_k + \cdots + a_nM_ny_n
$$

이다.

이 합을 modulo $m_k$에서 본다.

이때 $j \neq k$인 항들은 모두 0이 된다.

왜냐하면 $M_j$에는 $m_k$가 포함되어 있기 때문이다.

즉

$$
M_j \equiv 0 \pmod{m_k} \qquad (j \neq k)
$$

이다.

반면 $k$번째 항은

$$
a_kM_ky_k
$$

이다.

그런데 $y_k$를 일부러

$$
M_ky_k \equiv 1 \pmod{m_k}
$$

가 되도록 골랐다.

따라서

$$
a_kM_ky_k \equiv a_k \cdot 1 \equiv a_k \pmod{m_k}
$$

이다.

그래서 전체 합은 modulo $m_k$에서

$$
x \equiv a_k \pmod{m_k}
$$

가 된다.

이것이 모든 $k$에 대해 성립하므로, $x$는 모든 합동식을 동시에 만족한다.

---

# 2.12.  원래 문제를 중국인의 나머지 정리 공식으로 풀기

$$
x \equiv 1 \pmod{5}
$$

$$
x \equiv 2 \pmod{6}
$$

$$
x \equiv 3 \pmod{7}
$$

따라서

$$
a_1 = 1, \quad a_2 = 2, \quad a_3 = 3
$$

이고,

$$
m_1 = 5, \quad m_2 = 6, \quad m_3 = 7
$$

이다.

전체 곱은

$$
m = 5 \cdot 6 \cdot 7 = 210
$$

이다.

각각 $M_k$를 구하면 다음과 같다.

$$
M_1 = \frac{210}{5} = 42
$$

$$
M_2 = \frac{210}{6} = 35
$$

$$
M_3 = \frac{210}{7} = 30
$$

이제 각각의 역원 $y_k$를 찾는다.

첫째,

$$
42y_1 \equiv 1 \pmod{5}
$$

이다.

그런데

$$
42 \equiv 2 \pmod{5}
$$

이고

$$
2 \cdot 3 = 6 \equiv 1 \pmod{5}
$$

이므로

$$
y_1 = 3
$$

이다.

둘째,

$$
35y_2 \equiv 1 \pmod{6}
$$

이다.

그런데

$$
35 \equiv 5 \pmod{6}
$$

이고

$$
5 \cdot 5 = 25 \equiv 1 \pmod{6}
$$

이므로

$$
y_2 = 5
$$

이다.

셋째,

$$
30y_3 \equiv 1 \pmod{7}
$$

이다.

그런데

$$
30 \equiv 2 \pmod{7}
$$

이고

$$
2 \cdot 4 = 8 \equiv 1 \pmod{7}
$$

이므로

$$
y_3 = 4
$$

이다.

공식에 넣으면

$$
x = a_1M_1y_1 + a_2M_2y_2 + a_3M_3y_3
$$

$$
x = 1 \cdot 42 \cdot 3 + 2 \cdot 35 \cdot 5 + 3 \cdot 30 \cdot 4
$$

$$
x = 126 + 350 + 360
$$

$$
x = 836
$$

그런데

$$
836 = 210 \cdot 3 + 206
$$

이므로

$$
836 \equiv 206 \pmod{210}
$$

이다.

따라서

$$
\boxed{x \equiv 206 \pmod{210}}
$$

이다.

역대입법으로 풀어도 $206$, 중국인의 나머지 정리 공식으로 풀어도 $206$이 나온다.

---

# 2.13. 원래 문제를 중국인의 나머지 정리 공식으로 풀기

원래 문제는 다음이다.

$$
x \equiv 1 \pmod{5}
$$

$$
x \equiv 2 \pmod{6}
$$

$$
x \equiv 3 \pmod{7}
$$

따라서

$$
a_1 = 1, \quad a_2 = 2, \quad a_3 = 3
$$

이고,

$$
m_1 = 5, \quad m_2 = 6, \quad m_3 = 7
$$

이다.

전체 곱은

$$
m = 5 \cdot 6 \cdot 7 = 210
$$

이다.

각각 $M_k$를 구하면 다음과 같다.

$$
M_1 = \frac{210}{5} = 42
$$

$$
M_2 = \frac{210}{6} = 35
$$

$$
M_3 = \frac{210}{7} = 30
$$

이제 각각의 역원 $y_k$를 찾는다.

첫째,

$$
42y_1 \equiv 1 \pmod{5}
$$

이다.

그런데

$$
42 \equiv 2 \pmod{5}
$$

이고

$$
2 \cdot 3 = 6 \equiv 1 \pmod{5}
$$

이므로

$$
y_1 = 3
$$

이다.

둘째,

$$
35y_2 \equiv 1 \pmod{6}
$$

이다.

그런데

$$
35 \equiv 5 \pmod{6}
$$

이고

$$
5 \cdot 5 = 25 \equiv 1 \pmod{6}
$$

이므로

$$
y_2 = 5
$$

이다.

셋째,

$$
30y_3 \equiv 1 \pmod{7}
$$

이다.

그런데

$$
30 \equiv 2 \pmod{7}
$$

이고

$$
2 \cdot 4 = 8 \equiv 1 \pmod{7}
$$

이므로

$$
y_3 = 4
$$

이다.

공식에 넣으면

$$
x = a_1M_1y_1 + a_2M_2y_2 + a_3M_3y_3
$$

$$
x = 1 \cdot 42 \cdot 3 + 2 \cdot 35 \cdot 5 + 3 \cdot 30 \cdot 4
$$

$$
x = 126 + 350 + 360
$$

$$
x = 836
$$

그런데

$$
836 = 210 \cdot 3 + 206
$$

이므로

$$
836 \equiv 206 \pmod{210}
$$

이다.

따라서

$$
\boxed{x \equiv 206 \pmod{210}}
$$

이다.

역대입법으로 풀어도 $206$, 중국인의 나머지 정리 공식으로 풀어도 $206$이 나온다.

# 2.14 예제 5 
$$
x \equiv 2 \pmod{3}
$$

$$
x \equiv 3 \pmod{5}
$$

$$
x \equiv 2 \pmod{7}
$$

따라서

$$
a_1=2, \quad a_2=3, \quad a_3=2
$$

이고,

$$
m_1=3, \quad m_2=5, \quad m_3=7
$$

이다.

전체 곱은

$$
m = 3 \cdot 5 \cdot 7 = 105
$$

이다.

각각 $M_k$를 구하면 다음과 같다.

$$
M_1 = \frac{105}{3} = 35
$$

$$
M_2 = \frac{105}{5} = 21
$$

$$
M_3 = \frac{105}{7} = 15
$$

이제 역원을 찾는다.

첫째,

$$
35y_1 \equiv 1 \pmod{3}
$$

이다.

그런데

$$
35 \equiv 2 \pmod{3}
$$

이고

$$
2 \cdot 2 = 4 \equiv 1 \pmod{3}
$$

이므로

$$
y_1 = 2
$$

이다.

둘째,

$$
21y_2 \equiv 1 \pmod{5}
$$

이다.

그런데

$$
21 \equiv 1 \pmod{5}
$$

이므로

$$
y_2 = 1
$$

이다.

셋째,

$$
15y_3 \equiv 1 \pmod{7}
$$

이다.

그런데

$$
15 \equiv 1 \pmod{7}
$$

이므로

$$
y_3 = 1
$$

이다.

공식에 넣으면

$$
x = a_1M_1y_1 + a_2M_2y_2 + a_3M_3y_3
$$

$$
x = 2 \cdot 35 \cdot 2 + 3 \cdot 21 \cdot 1 + 2 \cdot 15 \cdot 1
$$

$$
x = 140 + 63 + 30
$$

$$
x = 233
$$

그런데

$$
233 = 105 \cdot 2 + 23
$$

이므로

$$
233 \equiv 23 \pmod{105}
$$

이다.

따라서

$$
x \equiv 23 \pmod{105}
$$

이다.

즉 모든 해는

$$
x = 105n + 23
$$

이다.

최소 양의 정수해는

$$
23
$$

이다.
---

# 2.15. 한 줄 핵심

핵심은 다음이다.

$$
\boxed{x \equiv a \pmod{m} \iff x = mk + a \text{ for some } k \in \mathbb Z}
$$

역대입법은 이 꼴을 반복해서 대입하면서 조건을 하나씩 누적하는 방법이다.

중국인의 나머지 정리는 이 누적 과정을 공식화한 방법이다.

### 2.1 정리 2 — CRT 진술

> **정리 2 (중국인의 나머지 정리, CRT)**. $m_1, m_2, \ldots, m_n$ 이 **쌍쌍 서로소**(pairwise coprime)인 양의 정수라 하자. 임의의 정수 $a_1, \ldots, a_n$ 에 대해 다음 연립 합동
>
> $$x \equiv a_j \pmod{m_j}, \quad j = 1, 2, \ldots, n$$
>
> 은 $\bmod M = m_1 m_2 \cdots m_n$ 에 대해 **유일한 해를 가진다**.

**용어 주의** — "쌍쌍 서로소"란 모든 쌍 $(m_i, m_j)$, $i \ne j$ 에 대해 $\gcd(m_i, m_j) = 1$ 임을 의미한다. 단순 "전체의 gcd 가 1" 보다 강한 조건이다. 예컨대 $\{6, 10, 15\}$ 는 $\gcd(6, 10, 15) = 1$ 이지만 $\gcd(6, 10) = 2$ 이므로 **쌍쌍 서로소는 아니다**.

### 2.2 명시적 해 — `M_k` 와 `y_k`

해 $x$ 의 닫힌 형은 다음과 같다.

$$M_k = \frac{M}{m_k}, \quad y_k \equiv M_k^{-1} \pmod{m_k}, \quad x \equiv \sum_{k=1}^{n} a_k M_k y_k \pmod{M}$$

**핵심 직관** — 각 $k$ 에 대해 $M_k$ 는 $m_k$ 를 제외한 나머지 모듈러스의 곱이다.   

그러므로 $j \ne k$ 일 때 $M_k$ 는 $m_j$ 의 배수이고 $M_k \equiv 0 \pmod{m_j}$. 한편 $\gcd(M_k, m_k) = 1$ 이므로 정리 1 에 의해 $y_k = M_k^{-1} \pmod{m_k}$ 이 존재하여 $M_k y_k \equiv 1 \pmod{m_k}$.   

따라서 합 $\sum_k a_k M_k y_k$ 를 $\bmod m_j$ 로 환원하면 정확히 $a_j M_j y_j \equiv a_j \pmod{m_j}$ 만 살아남고 다른 모든 항은 $\equiv 0 \pmod{m_j}$.

이것이 CRT 의 본질이다 —   

**정리 1 을 $n$ 개의 좌표마다 한 번씩 사용하여 구성적으로 해를 짜낸다**.  

### 2.3 손자(孫子) 문제

> 어떤 수가 3 으로 나누어 2 가 남고, 5 로 나누어 3 이 남고, 7 로 나누어 2 가 남는다. 그 수는 무엇인가?

이 문제는 약 1700 년 전 중국 산학서 *손자산경*(孫子算經)에 등장한다. 연립합동으로 표기하면

$$x \equiv 2 \pmod 3, \quad x \equiv 3 \pmod 5, \quad x \equiv 2 \pmod 7$$

이다. 모듈러스 3, 5, 7 이 쌍쌍 서로소이므로 CRT 가 적용된다.

**단계별 풀이**

- $M = 3 \cdot 5 \cdot 7 = 105$.
- $M_1 = M / m_1 = 105 / 3 = 35$. $M_2 = 105 / 5 = 21$. $M_3 = 105 / 7 = 15$.
- 
- $y_1 \equiv 35^{-1} \pmod 3$ 의 계산: $35 \equiv 2 \pmod 3$ 이므로 $2 \cdot y_1 \equiv 1 \pmod 3$ 의 해를 찾는다. $2 \cdot 2 = 4 \equiv 1 \pmod 3$ 이므로 $y_1 = 2$.
- 
- $y_2 \equiv 21^{-1} \pmod 5$: $21 \equiv 1 \pmod 5$ 이므로 $y_2 = 1$.
- 
- $y_3 \equiv 15^{-1} \pmod 7$: $15 \equiv 1 \pmod 7$ 이므로 $y_3 = 1$.
- 
- $x \equiv 2 \cdot 35 \cdot 2 + 3 \cdot 21 \cdot 1 + 2 \cdot 15 \cdot 1 = 140 + 63 + 30 = 233 \equiv 23 \pmod{105}$.

**검산** — $23 \bmod 3 = 2$, $23 \bmod 5 = 3$, $23 \bmod 7 = 2$. 세 조건 모두 만족. $\checkmark$

### 2.4 역대입법(back substitution)

CRT 의 또 다른 풀이법으로 한 합동씩 차례로 "쌓아 올리는" 방식이 있다. 명시적 공식보다 손계산이 간편한 경우가 많다.

**문제** — $x \equiv 1 \pmod 5$, $x \equiv 2 \pmod 6$, $x \equiv 3 \pmod 7$.

(모듈러스 5, 6, 7 의 쌍쌍 서로소 확인: $\gcd(5,6) = 1$, $\gcd(5,7) = 1$, $\gcd(6,7) = 1$. $\checkmark$)

**1 단계** — 첫 합동에서 $x = 5t + 1$ 로 둔다.   

두 번째 합동에 대입하면 $5t + 1 \equiv 2 \pmod 6$, 즉 $5t \equiv 1 \pmod 6$. $5 \equiv -1 \pmod 6$ 이므로 $-t \equiv 1 \pmod 6$, $t \equiv -1 \equiv 5 \pmod 6$.  

따라서 $t = 6u + 5$, $x = 5(6u + 5) + 1 = 30u + 26$.

**2 단계** — 세 번째 합동에 대입하면 $30u + 26 \equiv 3 \pmod 7$. $30 \equiv 2 \pmod 7$, $26 \equiv 5 \pmod 7$ 이므로 $2u + 5 \equiv 3 \pmod 7$, 즉 $2u \equiv -2 \pmod 7$, $u \equiv -1 \equiv 6 \pmod 7$. 따라서 $u = 7v + 6$.

**최종** — $x = 30(7v + 6) + 26 = 210v + 206$, 즉 $x \equiv 206 \pmod{210}$.

**검산** — $206 \bmod 5 = 1$, $206 \bmod 6 = 2$, $206 \bmod 7 = 3$. $\checkmark$

명시적 공식법과 역대입법은 결과가 같음이 보장된다(CRT 의 유일성). 


### 2.5 RNS — 큰 정수를 "쪼개어" 다루기

CRT 의 가장 직접적인 응용은 **잉여수 표현**(Residue Number System, RNS)이다. 큰 정수 $a$ ($0 \le a < M$, $M = m_1 \cdots m_n$)를 단일 정수가 아니라 튜플 $(a \bmod m_1, \ldots, a \bmod m_n)$ 으로 저장한다.

**장점** — 덧셈과 곱셈이 각 좌표마다 독립적으로 수행된다.

$$(a + b) \bmod m_k = ((a \bmod m_k) + (b \bmod m_k)) \bmod m_k$$

이는 GPU 의 SIMD(single instruction, multiple data) 명령과 잘 맞는다. 1024 비트 정수 한 개의 곱셈 대신 32 비트 정수 32 개의 곱셈을 병렬로 수행할 수 있다.

**정당성** — RNS 가 "올바른" 산술을 수행한다는 보장은 곧 **CRT 그 자체**이다. 좌표별 결과가 원래 정수의 결과와 일의적으로 일치한다는 사실이 정리 2 의 직접 따름정리이다.

이 RNS 가 5 부에서 다룰 **동형 암호**(homomorphic encryption)의 핵심 토대가 된다.

### 2.6 Lean 4 — CRT 형식화

```lean
import Mathlib.Data.ZMod.Basic

-- "ℤ/(m·n) ≃ ℤ/m × ℤ/n  (m, n 서로소일 때)" — 환 동형 사상
example (m n : ℕ) (hmn : Nat.Coprime m n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n :=
  ZMod.chineseRemainder hmn

-- 손자 문제의 해: 23 ∈ ZMod 105 가 세 합동을 만족함
example : (23 : ZMod 105).val % 3 = 2 ∧
          (23 : ZMod 105).val % 5 = 3 ∧
          (23 : ZMod 105).val % 7 = 2 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide
```

**해설** — `ZMod.chineseRemainder hmn` 은 정리 2 의 형식 버전이다. 두 모듈러스의 환 동형 사상을 직접 돌려주며, 일반 $n$ 개의 경우는 귀납적으로 합성하여 얻을 수 있다. `≃+*` 는 "환 동형"(ring isomorphism)을 뜻한다 — 덧셈과 곱셈을 모두 보존하는 일대일대응이라는 뜻이며, 이것이 정확히 CRT 의 대수적 표현이다.

### 2.7 Python 으로 자동화

```python
from sympy.ntheory.modular import crt

# 손자 문제
moduli = [3, 5, 7]
remainders = [2, 3, 2]
x, M = crt(moduli, remainders)
print(x, M)         # 23 105

# 역대입 예제도 동일
print(crt([5, 6, 7], [1, 2, 3]))    # (206, 210)
```

`sympy.ntheory.modular.crt` 는 모듈러스가 쌍쌍 서로소가 아닐 때도 일반화된 CRT(해가 존재하면 반환, 아니면 `None`)를 처리한다.

---

## 3부 — 페르마의 작은 정리 (정리 3)

### 3.1 정리 3 — 진술과 따름정리

> **정리 3 (페르마의 작은 정리, Fermat's Little Theorem)**. $p$ 가 소수이고 $\gcd(a, p) = 1$ 이면
>
> $$a^{p-1} \equiv 1 \pmod{p}$$

**따름정리** — 위 가정 없이 모든 정수 $a$ 에 대해 $a^p \equiv a \pmod p$ 가 성립한다(증명: $\gcd(a, p) = 1$ 이면 양변에 $a$ 를 곱하고, $p \mid a$ 이면 양변이 모두 0).

페르마의 작은 정리는 "큰 지수를 작게 만드는" 도구이다. RSA 암호의 모든 빠른 연산이 이 위에 있다.

### 3.2 정리 3 의 증명

증명은 3 단계로 진행한다.

**1 단계 (잉여 집합 보존, rearrangement)** — 집합

$$S = \{a, 2a, 3a, \ldots, (p-1)a\} \pmod p$$

이 정확히 $\{1, 2, \ldots, p-1\}$ 의 **순열**(permutation)임을 보인다.

서로 다른 $i, j \in \{1, \ldots, p-1\}$ 에 대해 $ia \equiv ja \pmod p$ 라 가정하면 $(j - i)a \equiv 0 \pmod p$.  

$\gcd(a, p) = 1$ 이므로 $p \mid (j - i)$. 그러나 $|j - i| < p$ 이므로 모순.  

따라서 $S$ 의 원소들은 모두 서로 다르며, $p - 1$ 개의 서로 다른 0 이 아닌 잉여류이므로 정확히 $\{1, 2, \ldots, p-1\}$ 의 재배열이다.   


**2 단계 (양변의 곱을 비교)** — 위 두 집합의 모든 원소를 곱하면 같다.

$$a \cdot 2a \cdot 3a \cdots (p-1)a \equiv 1 \cdot 2 \cdot 3 \cdots (p-1) \pmod p$$

좌변을 정리하면

$$a^{p-1} \cdot (p-1)! \equiv (p-1)! \pmod p$$

**3 단계 ($(p-1)!$ 의 약분)** — $\gcd((p-1)!, p) = 1$ 이므로 정리 1 에 의해 $(p-1)!$ 의 mod $p$ 역원이 존재한다. 양변에 곱하면

$$a^{p-1} \equiv 1 \pmod p$$

이로써 증명 종료. $\blacksquare$

이 증명에서 **정리 1** 이 사용됨에 주목하라. 정리 1 → 정리 3 의 의존이 본 절의 가장 중요한 의존 관계 중 하나이다.

### 3.3 예제 9 — `3³⁰² mod 5`

페르마: $\gcd(3, 5) = 1$ 이므로 $3^4 \equiv 1 \pmod 5$.

지수를 4 로 나누어 보정한다 — $302 = 4 \cdot 75 + 2$.

$$3^{302} = (3^4)^{75} \cdot 3^2 \equiv 1^{75} \cdot 9 \equiv 9 \equiv 4 \pmod 5$$

페르마 없이 직접 $3^{302}$ 를 계산하려면 천문학적 자릿수의 정수가 필요하지만, 페르마는 그것을 한 줄로 줄여 준다.

### 3.4 예제 9 확장 — `3³⁰² mod 385` (페르마 + CRT)

$385 = 5 \cdot 7 \cdot 11$. 세 소수가 쌍쌍 서로소이므로 각 소수에서 페르마를 적용하고 CRT 로 합성한다.

**3 부 결과**

- $\bmod 5$: $3^4 \equiv 1$, $302 = 4 \cdot 75 + 2$, $3^{302} \equiv 3^2 = 9 \equiv 4 \pmod 5$.
- 
- $\bmod 7$: $3^6 \equiv 1$, $302 = 6 \cdot 50 + 2$, $3^{302} \equiv 3^2 = 9 \equiv 2 \pmod 7$.
- 
- $\bmod 11$: $3^{10} \equiv 1$, $302 = 10 \cdot 30 + 2$, $3^{302} \equiv 3^2 = 9 \pmod{11}$.

**CRT 합성** — $x \equiv 4 \pmod 5$, $x \equiv 2 \pmod 7$, $x \equiv 9 \pmod{11}$.

- $M = 385$, $M_1 = 77$, $M_2 = 55$, $M_3 = 35$.
  
- $y_1 \equiv 77^{-1} \pmod 5$: $77 \equiv 2 \pmod 5$, $2 \cdot 3 \equiv 1$ → $y_1 = 3$.  
  
- $y_2 \equiv 55^{-1} \pmod 7$: $55 \equiv 6 \equiv -1 \pmod 7$, $(-1)(-1) \equiv 1$ → $y_2 = 6$. 

- $y_3 \equiv 35^{-1} \pmod{11}$: $35 \equiv 2 \pmod{11}$, $2 \cdot 6 \equiv 1$ → $y_3 = 6$.  

  
- $x \equiv 4 \cdot 77 \cdot 3 + 2 \cdot 55 \cdot 6 + 9 \cdot 35 \cdot 6 = 924 + 660 + 1890 = 3474$.  
  
- $3474 \bmod 385 = 3474 - 9 \cdot 385 = 3474 - 3465 = 9$.  

**최종** — $3^{302} \equiv 9 \pmod{385}$. 

이 예제는 **페르마와 CRT 의 결합**이 RSA 의 빠른 복호화에 사용되는 정확한 패턴이다. 1024 비트 모듈러스 $n = pq$ 위의 거듭제곱을 $\bmod p$ 와 $\bmod q$ 의 두 작은 거듭제곱으로 나누어 처리한 뒤 CRT 로 합치면 약 4 배 가속된다.

### 3.5 의사소수와 카마이클 수 — 페르마의 "역"이 거짓인 사례

페르마의 작은 정리는 " $p$ 소수 이면 $a^{p-1} \equiv 1$"이라는 한 방향이다. 그 **역** 명제 — " $a^{n-1} \equiv 1 \pmod n$ 이면 $n$ 은 소수"는 거짓이다.

- **페르마 의사소수**(Fermat pseudoprime, base $b$) — 합성수 $n$ 인데도 $b^{n-1} \equiv 1 \pmod n$ 을 만족하는 $n$. 가장 작은 예: $n = 341 = 11 \cdot 31$ (밑 2). $2^{340} \equiv 1 \pmod{341}$ 이지만 341 은 소수가 아니다.

  
- **카마이클 수**(Carmichael number) — $\gcd(b, n) = 1$ 인 **모든** $b$ 에 대해 $b^{n-1} \equiv 1 \pmod n$ 을 만족하는 합성수.

가장 작은 카마이클 수는

$$561 = 3 \cdot 11 \cdot 17$$

이다. 카마이클 수의 한 줄 판정 조건(코르셀트의 정리, Korselt's criterion):

> $n$ 은 카마이클 수 ⇔ $n$ 이 서로 다른 소수의 곱이며, 모든 소인수 $p_j$ 에 대해 $(p_j - 1) \mid (n - 1)$.

561 의 검증 — $3 - 1 = 2$, $11 - 1 = 10$, $17 - 1 = 16$, 이들이 모두 $560 = n - 1$ 을 나눈다. ($560 = 2 \cdot 280 = 10 \cdot 56 = 16 \cdot 35$. $\checkmark$)

이 사실은 실용적 의미가 있다 — **단순 페르마 검정으로는 소수 판정이 부족**하다. 따라서 RSA 의 키 생성은 페르마 검정이 아니라 더 강한 **밀러-라빈 검정**(Miller-Rabin test)을 사용한다.

### 3.6 Lean 4 — 페르마

```lean
import Mathlib.FieldTheory.Finite.Basic

-- 진술: a ≠ 0 in ZMod p (p 소수) → a^(p-1) = 1
example (p : ℕ) [Fact p.Prime] (a : ZMod p) (ha : a ≠ 0) :
    a ^ (p - 1) = 1 :=
  ZMod.pow_card_sub_one_eq_one ha

-- 따름정리: 모든 a 에 대해 a^p = a
example (p : ℕ) [Fact p.Prime] (a : ZMod p) : a ^ p = a := by
  by_cases ha : a = 0
  · rw [ha, zero_pow (Nat.Prime.pos Fact.out).ne']
  · have h := ZMod.pow_card_sub_one_eq_one ha
    have hp : p = (p - 1) + 1 := by
      rw [Nat.sub_add_cancel (Nat.Prime.pos Fact.out)]
    rw [hp, pow_succ, h, one_mul]
```

**해설** — `ZMod.pow_card_sub_one_eq_one` 이 페르마의 형식 버전이다. `Fact p.Prime` 은 " $p$ 가 소수라는 사실을 인스턴스로 가지고 있다"는 뜻으로, Lean 의 타입 클래스 시스템이 자동으로 합성한다. 따름정리 증명에서 `a = 0` 분기와 그 외 분기를 나누는 패턴은 모든 페르마 응용 증명의 표준이다.

### 3.7 Python — 페르마 + CRT 응용

```python
def fast_pow_mod_via_crt(a, e, factors):
    """페르마 + CRT 로 a^e mod (factors 의 곱) 계산"""
    from math import prod
    from sympy.ntheory.modular import crt

    n = prod(factors)
    parts = []
    for p in factors:
        # p 소수 가정
        ep = e % (p - 1)         # 페르마: 지수 축약
        parts.append(pow(a, ep, p))
    x, _ = crt(factors, parts)
    return x % n

# 예제 9 확장 검산: 3^302 mod 385
print(fast_pow_mod_via_crt(3, 302, [5, 7, 11]))     # 9
```

`pow(a, e, n)` 은 Python 내장으로 이미 빠른 모듈러 거듭제곱을 수행하지만, 위 RSA 스타일 분해는 모듈러스가 매우 클 때(예: 2048 비트) 의미 있는 가속을 제공한다.

---

## 4부 — 원시근과 이산 로그

### 4.1 정의 3 — 원시근(primitive root)

> $r \in (\mathbb{Z}/p\mathbb{Z})^*$ 이 mod $p$ 의 **원시근**(primitive root)이라 함은 다음을 의미한다.
>
> $$\{r^1, r^2, r^3, \ldots, r^{p-1}\} \equiv \{1, 2, 3, \ldots, p-1\} \pmod p$$
>
> 즉 $r$ 의 거듭제곱이 0 이 아닌 모든 잉여류를 정확히 한 번씩 만든다.

군론의 언어로는 $(\mathbb{Z}/p\mathbb{Z})^*$ 가 **순환군**(cyclic group)이고 $r$ 이 그 **생성원**(generator)이라는 뜻이다. $r$ 의 차수(order)가 $p - 1$ 과 같다고 표현해도 동일하다.

**중요한 사실** — $p$ 가 소수이면 mod $p$ 의 원시근은 **반드시 존재한다**. 이는 자명하지 않은 정리이다(가우스, 1801). 일반 모듈러스 $n$ 에 대해서는 $n \in \{1, 2, 4, p^k, 2p^k\}$ 인 경우에만 원시근이 존재한다.

원시근의 개수도 알려져 있다 — mod $p$ 에서 정확히 $\varphi(p - 1)$ 개. 여기서 $\varphi$ 는 오일러의 토션트 함수이다.

### 4.2 예제 12 — `mod 11` 의 원시근 찾기

$p = 11$, 따라서 $p - 1 = 10$. 원시근의 개수는 $\varphi(10) = 4$.

후보 $r = 2$ 의 거듭제곱을 차례로 계산한다.

| $k$ | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| $2^k \bmod 11$ | 2 | 4 | 8 | 5 | 10 | 9 | 7 | 3 | 6 | 1 |

10 개의 값이 모두 서로 다르며 정확히 $\{1, 2, \ldots, 10\}$ 을 채운다. 따라서 $2$ 는 mod 11 의 원시근이다.

같은 방법으로 검사하면 mod 11 의 원시근은 정확히 $\{2, 6, 7, 8\}$ 의 4 개이다 — $\varphi(10) = 4$ 와 일치한다.

### 4.3 정의 4 — 이산 로그(discrete logarithm)

> $r$ 이 mod $p$ 의 원시근이고 $a \in (\mathbb{Z}/p\mathbb{Z})^*$ 이라 하자. 정의에 의해 $r^e \equiv a \pmod p$ 를 만족하는 유일한 $e \in \{1, 2, \ldots, p - 1\}$ 이 존재한다. 이 $e$ 를 $a$ 의 **이산 로그**(discrete logarithm)라 하고 $\log_r a$ 로 표기한다.
>
> $$\log_r a := e \in \{1, 2, \ldots, p-1\} \text{ 인데, } r^e \equiv a \pmod p$$

이산 로그는 실수 로그의 이산 판본이다. 곱셈을 덧셈으로 바꾸는 성질이 그대로 성립한다.

### 4.4 예제 13 — `log₂ 3 mod 11`

위 표에서 $2^8 \equiv 3 \pmod{11}$. 따라서 $\log_2 3 \equiv 8 \pmod{10}$.

이산 로그의 결과는 **mod $p - 1$** 에서 의미를 가진다. $r$ 의 차수가 $p - 1$ 이므로 $r^{p-1} \equiv 1$ 이고, 지수에 $p - 1$ 을 더해도 결과가 변하지 않기 때문이다.

### 4.5 이산 로그의 곱셈 성질

실수 로그의 " $\log(ab) = \log a + \log b$" 성질이 이산 로그에서도 성립한다.

$$\log_r (ab) \equiv \log_r a + \log_r b \pmod{p - 1}$$

**증명** — $a = r^{\log_r a}$, $b = r^{\log_r b}$ 이므로

$$ab = r^{\log_r a + \log_r b}$$

$r$ 의 차수가 $p - 1$ 이므로 지수는 mod $p - 1$ 에서 일의적으로 결정된다. $\blacksquare$

이 성질은 곱셈 합동 방정식을 덧셈 합동 방정식으로 환원하는 도구이다. 단, 그 환원의 전제 조건은 "이산 로그를 효율적으로 계산할 수 있다"인데 그것이 다음 절에서 다루는 **DLP** 의 어려움이다.

### 4.6 DLP — 이산 로그 문제

> **DLP**(Discrete Logarithm Problem). 큰 소수 $p$, 원시근 $r$, 그리고 $a \in (\mathbb{Z}/p\mathbb{Z})^*$ 이 주어졌을 때 $\log_r a \pmod{p - 1}$ 을 구하라.

**알려진 사실** — $p$ 가 약 2048 비트일 때, 가장 빠른 알려진 알고리즘(general number field sieve, GNFS 변종)도 **준지수 시간**(sub-exponential time)을 요구한다. 다항 시간 알고리즘은 알려져 있지 않다(고전 컴퓨터 가정).

**중요한 단서** — Shor 의 양자 알고리즘은 양자 컴퓨터 위에서 DLP 를 다항 시간에 푼다. 따라서 큰 양자 컴퓨터가 실용화되면 DLP 기반 암호는 모두 깨진다. 이것이 **포스트 양자 암호**(post-quantum cryptography) 연구의 출발점이다.

### 4.7 Diffie-Hellman 키 교환

DLP 의 어려움을 직접 이용한 첫 공개 키 프로토콜.

| 공개 정보 | 큰 소수 $p$, 원시근 $g$ |
| --- | --- |
| Alice 의 비밀 $a$ | 공개값 $A = g^a \bmod p$ 를 보냄 |
| Bob 의 비밀 $b$ | 공개값 $B = g^b \bmod p$ 를 보냄 |
| Alice 가 계산 | 공통 비밀 $K = B^a \bmod p$ |
| Bob 이 계산 | 공통 비밀 $K = A^b \bmod p$ |

**두 사람이 같은 $K$ 를 얻는 이유** — $K_{\text{Alice}} = B^a = (g^b)^a = g^{ab}$, $K_{\text{Bob}} = A^b = (g^a)^b = g^{ab}$ 로 둘 다 $g^{ab} \pmod p$ 와 같다.

**도청자의 어려움** — 채널을 도청하는 제 3 자는 $p, g, A, B$ 만 본다. $K$ 를 알려면 $a$ 또는 $b$ 를 복원해야 하는데 그것이 정확히 DLP 이다. $A = g^a \bmod p$ 에서 $a$ 를 구하라.

**구체적 사례 — $p = 23$, $g = 5$, $a = 6$, $b = 15$**

- $A = 5^6 \bmod 23 = 8$.
- $B = 5^{15} \bmod 23 = 19$.
- Alice: $K = 19^6 \bmod 23 = 2$.
- Bob: $K = 8^{15} \bmod 23 = 2$. $\checkmark$

```python
p, g = 23, 5
a, b = 6, 15
A, B = pow(g, a, p), pow(g, b, p)
K1, K2 = pow(B, a, p), pow(A, b, p)
print(A, B, K1, K2)         # 8 19 2 2
```

### 4.8 Lean 4 — 원시근의 형식화

```lean
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.SpecificGroups.Cyclic

-- 'r 이 mod p 의 원시근' 의 형식 정의
def isPrimitiveRoot (p : ℕ) [Fact p.Prime] (r : ZMod p) : Prop :=
  orderOf r = p - 1

-- 2 가 mod 11 의 원시근임 (구체 검증)
example : orderOf (2 : ZMod 11) = 10 := by decide
```

**해설** — Lean 에서 " $r$ 이 원시근"이라는 명제를 `orderOf r = p - 1` 로 형식화한다. `orderOf` 는 Mathlib4 의 표준 정의로 군 원소의 차수(order)를 돌려준다. mod 11 같은 작은 모듈러스에 대해서는 `decide` 로 직접 검증된다 — 11 까지의 모든 거듭제곱을 컴파일 시점에 계산해서 차수가 10 임을 확인한다.

이산 로그의 존재성·유일성을 형식 증명하려면 $(\mathbb{Z}/p\mathbb{Z})^*$ 가 순환군이라는 사실(`IsCyclic`) 을 거쳐 generator 의 거듭제곱이 모든 원소를 만든다는 군론 정리를 인용해야 한다. 본 노트에서는 골격까지만 다루고, 세부는 워크북의 4-6, 4-7 문제에서 단계적으로 작성한다.

---

## 5부 — RAG / AI 응용

### 5.1 RAG 파이프라인 5 단계

**RAG**(Retrieval-Augmented Generation)는 거대 언어 모델(LLM)에 외부 지식을 결합하는 표준 아키텍처이다. 다음 5 단계로 동작한다.

$$\text{질의(Query)} \to \text{임베딩(Embed)} \to \text{검색(Search)} \to \text{검증(Verify)} \to \text{생성(Generate)}$$

이 가운데 가운데 세 단계 — 임베딩·검색·검증 — 가 **모듈러 산술을 직접 사용**한다. 본 절의 6 개 카드(정리 1, 정리 2, 정리 3, 정의 3, 정의 4, DLP)가 다음과 같이 RAG 의 인프라를 구성한다.

| RAG 단계 | 사용되는 4.4절 도구 |
| --- | --- |
| 임베딩 | 해싱(정리 1 — 모듈러 곱셈의 well-definedness) |
| 검색 | 분산 인덱스 / 샤딩(정리 2 — CRT) |
| 검증 | 디지털 서명·영지식 증명(정리 3 + 정의 3 + DLP) |

ChatGPT, Claude, Perplexity 같은 시스템이 모두 이 골격 위에서 동작한다.

### 5.2 분산 인덱스의 CRT 비유

거대 벡터 데이터베이스(예: 1 억 개의 1536 차원 임베딩)를 한 대의 기계에 담을 수 없다. 따라서 데이터를 $n$ 개의 **샤드**(shard)로 분할한다. 샤드 $j$ 는 특정 모듈러스 $m_j$ 에 해당하는 부분 집합을 보유한다.

질의가 들어오면 모든 샤드가 자신의 부분 결과 $r_j \in \mathbb{Z}/m_j\mathbb{Z}$ 를 반환하고, 마스터 노드가 이를 합성하여 전체 결과 $R \in \mathbb{Z}/M\mathbb{Z}$ 을 복원한다 ($M = m_1 \cdots m_n$).

**수학적 정당성** — 각 샤드의 부분 정보가 주어지면 전체 결과가 **유일하게 복원된다**는 사실이 정확히 정리 2 (CRT) 이다. 실제 구현에서는 $M_k, y_k$ 같은 정수가 직접 보이지는 않지만, "부분 → 전체"의 일의성을 보장하는 추상이 모두 CRT 의 일반화이다.

샤드 분할의 표준 기법 중 하나인 **일관성 해싱**(consistent hashing)도 CRT 의 직접 응용이다. 노드가 추가되거나 제거될 때 영향받는 데이터를 최소화하는 수학적 보장이 모두 모듈러 산술의 좌표 독립성으로부터 나온다.

### 5.3 동형 암호와 RNS

**동형 암호**(homomorphic encryption, HE)는 "암호문 위에서 직접 연산하는" 암호 방식이다. 평문 $m_1, m_2$ 를 암호화한 $c_1, c_2$ 가 있을 때 $c_1 + c_2$ 또는 $c_1 \cdot c_2$ 를 복호하면 $m_1 + m_2$ 또는 $m_1 \cdot m_2$ 가 나온다.

대표적 구현인 **CKKS**, **BFV** 같은 격자 기반 HE 는 매우 큰 모듈러스 $q \approx 2^{600}$ 위에서 다항식 산술을 수행한다. 이 큰 모듈러스를 한 번에 다루기는 불가능하므로

$$q = q_1 q_2 \cdots q_\ell, \quad q_i \text{ 은 32~64 비트 소수}$$

로 분해하여 RNS 표현으로 처리한다. 정당성은 정리 2 (CRT). 결과적으로 GPU 의 32 비트 정수 곱셈 하나가 600 비트 정수 곱셈에 대응한다.

이는 의료 데이터·금융 데이터를 클라우드에서 처리하면서도 평문을 노출하지 않는 핵심 기술이다.

### 5.4 zk-SNARK — 영지식 증명의 토대

**영지식 증명**(zero-knowledge proof, ZKP)은 "비밀 $x$ 의 값을 드러내지 않으면서 $x$ 가 어떤 성질을 만족한다는 사실을 증명"하는 프로토콜이다.

가장 단순한 형태 — 검증자에게 $y = g^x \bmod p$ 만 보내고 $x$ 자체는 숨긴다. 검증자는 $y$ 만으로는 $x$ 를 복원할 수 없다(DLP 의 어려움). 그러나 prover 는 원할 때 $x$ 의 다양한 성질(예: $x$ 가 특정 범위에 있다)을 검증자에게 확인시킬 수 있다.

블록체인의 **zk-SNARK**(succinct non-interactive argument of knowledge), Zcash·StarkNet 같은 프라이버시 코인의 모든 안전성은 결국

$$g^x \equiv y \pmod p \text{ 에서 } x \text{ 를 구하기 어렵다}$$

는 가정 — DLP 의 어려움 — 으로 환원된다. 정의 3, 정의 4, 그리고 DLP 가 곧 ZKP 의 인프라이다.

### 5.5 LLM 양자화의 모듈러 산술

GPT-4 급 거대 언어 모델은 수천억 개의 가중치를 가진다. 16 비트 부동소수로 저장하면 메모리 요구량이 엄청나다. 따라서 모든 가중치를 **8 비트 정수**(int8)로 양자화하여 저장하는 기법이 표준이다.

8 비트 정수 = mod $2^8$ = mod 256 의 잉여류. 따라서 모든 행렬곱이 **mod 256 산술**로 수행된다. 16 비트 누적 후 다시 8 비트로 환원할 때 **scale 인수**($s$)와 **mod 256** 가 결합된 구조가 사용되며, 이는 정리 1(모듈러 역원의 well-definedness)과 정리 2(CRT 가 보장하는 좌표 독립성)가 함께 동작하는 구조이다.

극단적으로는 4 비트(mod 16), 2 비트(mod 4) 양자화까지 시도된다. 각각의 정확도-압축률 trade-off 가 연구 주제이며, 토대는 모두 본 절의 정수론이다.

### 5.6 종합 사례 — RAG 샤드 합성

마지막으로 본 절 5 부의 모든 도구를 결합한 종합 예제를 본다.

**문제** — RAG 시스템이 3 개의 샤드를 운영한다. 모듈러스는 $m_1 = 7$, $m_2 = 11$, $m_3 = 13$. 어떤 질의에 대해 각 샤드가 부분 점수 $s$ 를 반환했다.

$$s \equiv 3 \pmod 7, \quad s \equiv 5 \pmod{11}, \quad s \equiv 9 \pmod{13}$$

**유일 복원** — 모듈러스가 쌍쌍 서로소이므로 정리 2 가 적용된다. $M = 7 \cdot 11 \cdot 13 = 1001$. 명시적 공식으로 $0 \le s < 1001$ 인 유일 $s$ 를 구하면

$$s = 269$$

**Python 한 줄 검산**

```python
from sympy.ntheory.modular import crt
print(crt([7, 11, 13], [3, 5, 9]))    # (269, 1001)
```

**한 샤드 손실 시** — 만약 두 번째 샤드($m_2 = 11$)가 다운되어 부분 정보를 받지 못하면, 정리 2 의 "모든 $m_j$ 에 대한 부분 정보" 가정이 깨진다. 후보 $s$ 는 $1001 / 11 = 91$ 개로 분기되며 유일성이 사라진다. 이것이 분산 시스템에서 **장애 허용**(fault tolerance) 설계가 비단순한 이유이다.

---

## 부록 A — Mathlib4 (2026) 정리 인덱스

본 절에서 다룬 수학 개념의 Lean 4 / Mathlib4 대응표이다.

| 수학 개념 | Mathlib4 이름 |
| --- | --- |
| 합동의 정의 (정수) | `Int.ModEq` |
| 합동의 정의 (자연수) | `Nat.ModEq` |
| 모듈러 환 | `ZMod n` |
| 모듈러 역원의 존재(소수 모듈러스) | `ZMod.mul_inv_of_unit` |
| 페르마의 작은 정리 | `ZMod.pow_card_sub_one_eq_one` |
| 페르마의 따름정리 | `ZMod.pow_card` |
| CRT (두 모듈러스) | `ZMod.chineseRemainder` |
| 일반 CRT | `Nat.chineseRemainder` |
| 소인수 분해 리스트 | `Nat.primeFactorsList` |
| 소인수 분해의 곱 | `Nat.prod_primeFactorsList` |
| 군 원소의 차수 | `orderOf` |
| 순환군 | `IsCyclic` |
| 베주 항등식 (자연수) | `Nat.gcd_eq_gcd_ab` |
| 베주 항등식 (정수) | `Int.gcd_eq_gcd_ab` |

이 표는 4.4절 한정이다. Mathlib4 의 정수론 영역은 매우 방대하며, 본 절 이후의 자료에서도 점진적으로 확장한다.

---

## 부록 B — 한 페이지 정리 시트

본 절을 한 페이지로 압축한 요약. 시험 전·자기 점검 시 이 한 페이지만 정확히 외우면 된다.

**6 개 핵심 정리·정의**

1. **정리 1** — $ax \equiv b \pmod m$, $\gcd(a, m) = 1$ ⇒ 유일 해 $x \equiv a^{-1} b \pmod m$.
2. **정리 2 (CRT)** — 쌍쌍 서로소 모듈러스에서 연립 합동의 유일 해 $\bmod M$ ($M = m_1 \cdots m_n$).
3. **정리 3 (페르마)** — $p$ 소수, $\gcd(a, p) = 1$ ⇒ $a^{p-1} \equiv 1 \pmod p$.
4. **정의 3 (원시근)** — $r$ 의 거듭제곱이 모든 비영 잉여를 만든다 ⇔ $\text{ord}(r) = p - 1$.
5. **정의 4 (이산 로그)** — 원시근 $r$ 에 대해 $r^e \equiv a$ 인 유일한 $e \in \{1, \ldots, p - 1\}$.
6. **DLP** — 이산 로그를 효율적으로 계산하기 어려움 (고전 컴퓨터 가정). 모든 공개키 안전성의 토대 중 하나.

**6 개 응용**

1. **RSA** — 페르마(정리 3) + CRT 가속.
2. **Diffie-Hellman** — DLP 의 어려움.
3. **RAG 샤딩** — CRT (정리 2) 의 일반화.
4. **동형 암호** — RNS = CRT 끝까지 밀어붙임.
5. **zk-SNARK** — 원시근 + DLP.
6. **양자화 LLM** — 정리 1 + mod $2^8$ 산술.

**한 줄 격언** — 정수론은 AI 의 인프라 언어이다.
