# §4.4 합동 풀기 — 학생 워크북

## 안내 노트 · 부분 완성 노트

> **사용법**: 각 절의 빈칸을 직접 채우면서 개념을 정리한다. `____`는 정답을 쓸 자리이다. `<details>` 토글을 열어 정답을 확인한다.
> **총점**: 100점. A급 90점 이상, B급 75점 이상.
> **분량 가이드**: Section A~H, 약 90-120분.

---

## Section A. 역원 — 정의와 계산 (15점)

**A.1** (2점) 다음 빈칸을 채워라.

> $a$ 모듈로 $m$의 **역**이란, $\bar{a} \cdot a \equiv$ ____ $\pmod{m}$을 만족하는 정수 $\bar{a}$이다.

<details><summary>정답</summary>

$1$

</details>

**A.2** (3점) 다음 중 역이 존재하는 것은? (복수 가능)

1. $4$ 모듈로 $9$
2. $6$ 모듈로 $9$
3. $5$ 모듈로 $12$
4. $8$ 모듈로 $12$

<details><summary>정답</summary>

역이 존재하려면 $\gcd(a, m) = 1$.
- $\gcd(4, 9) = 1$ ✓
- $\gcd(6, 9) = 3$ ✗
- $\gcd(5, 12) = 1$ ✓
- $\gcd(8, 12) = 4$ ✗

답: **1, 3**

</details>

**A.3** (Rosen 연습 1, 3점) $15$가 $7$ 모듈로 $26$의 역임을 **검증**하라.

<details><summary>정답</summary>

$15 \cdot 7 = 105 = 4 \cdot 26 + 1$. 따라서 $15 \cdot 7 \equiv 1 \pmod{26}$. 검증 완료. $\blacksquare$

</details>

**A.4** (Rosen 연습 2, 3점) $937$이 $13$ 모듈로 $2436$의 역임을 **검증**하라.

<details><summary>정답</summary>

$937 \cdot 13 = 12181$. $12181 \div 2436 = 5.00$... 정확히 $12181 = 5 \cdot 2436 + 1 = 12180 + 1$. 따라서 $937 \cdot 13 \equiv 1 \pmod{2436}$. $\blacksquare$

</details>

**A.5** (Rosen 연습 5(a), 4점) 유클리드 알고리즘 + 베주로 $4$ 모듈로 $9$의 역을 구하라.

**풀이 과정 빈칸**:

1. 유클리드: $9 =$ ____ $\cdot 4 +$ ____
2. 다음: $4 =$ ____ $\cdot 1 +$ ____
3. 베주 계수 뽑기: $1 = 9 -$ ____ $\cdot 4$
4. 즉 $-$ ____ $\cdot 4 \equiv 1 \pmod 9$
5. 양의 표현: ____ 

<details><summary>정답</summary>

1. $9 = 2 \cdot 4 + 1$
2. $4 = 4 \cdot 1 + 0$
3. $1 = 9 - 2 \cdot 4$
4. $-2 \cdot 4 \equiv 1 \pmod 9$
5. $-2 + 9 = 7$

**답: 7**. 검증: $7 \cdot 4 = 28 = 3 \cdot 9 + 1 \equiv 1 \pmod 9$. $\blacksquare$

</details>

---

## Section B. 선형합동 풀기 (15점)

**B.1** (Rosen 연습 9, 5점) Section A.5에서 구한 $4$의 역을 이용해 $4x \equiv 5 \pmod 9$를 풀어라.

<details><summary>정답</summary>

$4$의 역은 $7$. 양변에 $7$을 곱하면
$$7 \cdot 4 x \equiv 7 \cdot 5 \pmod 9 \implies 28 x \equiv 35 \pmod 9 \implies x \equiv 35 - 3 \cdot 9 = 8 \pmod 9$$

**답**: $x \equiv 8 \pmod 9$, 즉 $x \in \{\ldots, -10, -1, 8, 17, 26, \ldots\}$.

검증: $4 \cdot 8 = 32 = 3 \cdot 9 + 5 \equiv 5 \pmod 9$. $\blacksquare$

</details>

**B.2** (4점) $5x \equiv 3 \pmod{12}$를 풀어라.

<details><summary>정답</summary>

$5$의 역 모듈로 $12$를 구한다. $\gcd(5, 12) = 1$이므로 역 존재.

검사로 빠르게: $5 \cdot 5 = 25 = 2 \cdot 12 + 1$. 즉 **$5$는 자기 자신의 역**이다.

$x \equiv 5 \cdot 3 = 15 \equiv 3 \pmod{12}$. 검증: $5 \cdot 3 = 15 \equiv 3 \pmod{12}$. $\blacksquare$

</details>

**B.3** (Rosen 연습 7, 6점) $a, m$이 서로소인 양의 정수라면, $a$ 모듈로 $m$의 역이 모듈로 $m$에서 **유일**함을 증명하라.

**증명 골격 빈칸**:

> 합동 $ax \equiv 1 \pmod m$에 두 해 $b, c$가 있다고 가정. 그러면 $ab \equiv$ ____ $\equiv ac \pmod m$. 즉 $ab - ac \equiv$ ____ $\pmod m$, 따라서 $a(b - c) \equiv 0 \pmod m$. 이는 $m \mid a(b - c)$를 의미한다. $\gcd(a, m) =$ ____ 이므로 ____ (정리 이름)에 의해 $m \mid (b - c)$. 따라서 $b \equiv c \pmod m$. $\blacksquare$

<details><summary>정답</summary>

> 합동 $ax \equiv 1 \pmod m$에 두 해 $b, c$가 있다고 가정. 그러면 $ab \equiv \mathbf{1} \equiv ac \pmod m$. 즉 $ab - ac \equiv \mathbf{0} \pmod m$, 따라서 $a(b - c) \equiv 0 \pmod m$. 이는 $m \mid a(b - c)$를 의미한다. $\gcd(a, m) = \mathbf{1}$이므로 **§4.3 정리 7** (즉, $\gcd(a,m)=1$이고 $m \mid ax$이면 $m \mid x$)에 의해 $m \mid (b - c)$. 따라서 $b \equiv c \pmod m$. $\blacksquare$

</details>

---

## Section C. CRT 기계적 풀기 (15점)

**C.1** (손자의 퍼즐, 8점) $x \equiv 2 \pmod 3$, $x \equiv 3 \pmod 5$, $x \equiv 2 \pmod 7$을 CRT 공식으로 풀어라.

**절차 빈칸**:
1. $m = 3 \cdot 5 \cdot 7 =$ ____
2. $M_1 = m/3 =$ ____ , $M_2 = m/5 =$ ____ , $M_3 = m/7 =$ ____
3. $y_1$은 ____ $y_1 \equiv 1 \pmod 3$을 만족 → $y_1 =$ ____
4. $y_2$는 ____ $y_2 \equiv 1 \pmod 5$을 만족 → $y_2 =$ ____
5. $y_3$는 ____ $y_3 \equiv 1 \pmod 7$을 만족 → $y_3 =$ ____
6. $x = 2 M_1 y_1 + 3 M_2 y_2 + 2 M_3 y_3 =$ ____
7. 모듈로 ____ 로 줄이면 $x =$ ____

<details><summary>정답</summary>

1. $m = 105$
2. $M_1 = 35$, $M_2 = 21$, $M_3 = 15$
3. $35 y_1 \equiv 1 \pmod 3$, $35 \equiv 2 \pmod 3$이므로 $2 y_1 \equiv 1 \pmod 3$ → $y_1 = 2$
4. $21 y_2 \equiv 1 \pmod 5$, $21 \equiv 1 \pmod 5$이므로 $y_2 = 1$
5. $15 y_3 \equiv 1 \pmod 7$, $15 \equiv 1 \pmod 7$이므로 $y_3 = 1$
6. $x = 2 \cdot 35 \cdot 2 + 3 \cdot 21 \cdot 1 + 2 \cdot 15 \cdot 1 = 140 + 63 + 30 = 233$
7. 모듈로 $105$로 줄이면 $x = 233 - 2 \cdot 105 = 23$

**답**: $x \equiv 23 \pmod{105}$. $\blacksquare$

</details>

**C.2** (Rosen 연습 22, 7점) **역대입법**으로 $x \equiv 3 \pmod 6$, $x \equiv 4 \pmod 7$을 풀어라.

<details><summary>정답</summary>

**단계 1**. 첫 식에서 $x = 6t + 3$.

**단계 2**. 둘째에 대입: $6t + 3 \equiv 4 \pmod 7$, 즉 $6t \equiv 1 \pmod 7$. $6 \equiv -1 \pmod 7$이므로 $-t \equiv 1$, 따라서 $t \equiv -1 \equiv 6 \pmod 7$. 즉 $t = 7u + 6$.

**단계 3**. $x = 6(7u + 6) + 3 = 42u + 39$.

**답**: $x \equiv 39 \pmod{42}$. 검증: $39 = 6 \cdot 6 + 3$, $39 = 5 \cdot 7 + 4$. $\blacksquare$

</details>

---

## Section D. 페르마의 작은 정리 (15점)

**D.1** (Rosen 연습 33, 5점) 페르마의 작은 정리를 사용하여 $7^{121} \bmod 13$을 계산하라.

<details><summary>정답</summary>

페르마: $p = 13$이므로 $7^{12} \equiv 1 \pmod{13}$ (단, $13 \nmid 7$ 확인: OK).

$121 = 10 \cdot 12 + 1$.

$7^{121} = (7^{12})^{10} \cdot 7 \equiv 1^{10} \cdot 7 = 7 \pmod{13}$.

**답**: $7^{121} \bmod 13 = 7$. $\blacksquare$

</details>

**D.2** (Rosen 연습 34, 5점) $23^{1002} \bmod 41$을 계산하라.

<details><summary>정답</summary>

페르마: $23^{40} \equiv 1 \pmod{41}$.

$1002 = 25 \cdot 40 + 2$.

$23^{1002} = (23^{40})^{25} \cdot 23^2 \equiv 1 \cdot 529 \pmod{41}$.

$529 = 12 \cdot 41 + 37$, 즉 $529 \equiv 37 \equiv -4 \pmod{41}$.

**답**: $23^{1002} \bmod 41 = 37$. $\blacksquare$

</details>

**D.3** (Rosen 연습 35, 5점) $p$가 소수이고 $p \nmid a$이면 $a^{p-2}$가 $a$ 모듈로 $p$의 역임을 증명하라.

<details><summary>정답</summary>

**증명**. 페르마의 작은 정리에 의해 $a^{p-1} \equiv 1 \pmod p$.

$a^{p-1} = a \cdot a^{p-2}$이므로
$$a \cdot a^{p-2} \equiv 1 \pmod p$$

따라서 $a^{p-2}$가 $a$ 모듈로 $p$의 역이다. $\blacksquare$

**응용**. 소수 $p$ 모듈로에서 역원을 구할 때 확장 유클리드 대신 **빠른 나머지 지수승 1회**로 역원 계산 가능. 예: $p = 7$, $a = 3$이면 $3^{7-2} = 3^5 = 243 = 34 \cdot 7 + 5 \equiv 5 \pmod 7$. 정확히 $3^{-1} = 5$ (§4.4 예제 1).

</details>

---

## Section E. Lean 4 증명 연습 (20점)

### E.1 기초 역원 검증 (3단계, 10점)

**Stage 1 — 빈칸 채우기** (3점). $5$가 $3$ 모듈로 $7$의 역임을 보여라.

```lean
example : (5 * 3 : Int) % 7 = ____ := by
  ____
```

<details><summary>정답</summary>

```lean
example : (5 * 3 : Int) % 7 = 1 := by
  rfl
```

이유: $5 \cdot 3 = 15 = 2 \cdot 7 + 1$이므로 나머지는 $1$. `rfl`로 계산 확인.

</details>

**Stage 2 — `____` 완성** (3점). $1601$이 $101$ 모듈로 $4620$의 역임을 보여라.

```lean
example : (1601 * 101 : Int) % 4620 = 1 := by
  ____
```

<details><summary>정답</summary>

```lean
example : (1601 * 101 : Int) % 4620 = 1 := by
  native_decide
```

이 큰 수 계산은 `rfl`도 되지만 컴파일이 느릴 수 있음. `native_decide`로 기계 계산.

혹은 `decide`도 됨.

</details>

**Stage 3 — 자유 증명** (4점). 베주 계수 $s, t$가 주어지면 $s$가 $a$의 모듈로 $m$ 역임을 Lean 4로 증명하라.

```lean
example (a m s t : Int) (h : s * a + t * m = 1) :
    (s * a) % m = 1 % m := by
  -- 힌트: s * a = 1 - t * m → s * a ≡ 1 (mod m)
  sorry
```

<details><summary>정답</summary>

```lean
example (a m s t : Int) (h : s * a + t * m = 1) :
    (s * a) % m = 1 % m := by
  have key : s * a = 1 + (-t) * m := by linarith
  rw [key]
  rw [Int.add_mul_emod_self]
```

학술체 주석:
- `have key` : $sa = 1 - tm$을 뽑아낸다. `linarith`는 선형 산술.
- `rw [key]` : 좌변 $sa$를 $1 + (-t)m$으로 치환.
- `rw [Int.add_mul_emod_self]` : $(1 + (-t) m) \bmod m = 1 \bmod m$.

rw-only 원칙 엄수를 위해 `have`의 `linarith` 대신 다음 방식도 가능:

```lean
example (a m s t : Int) (h : s * a + t * m = 1) :
    (s * a) % m = 1 % m := by
  have key : s * a + t * m = 1 := h
  have key2 : s * a = 1 - t * m := by
    rw [← key]
    ring
  rw [key2]
  -- 1 - t*m = 1 + (-t)*m
  rw [show (1 - t * m : Int) = 1 + (-t) * m from by ring]
  rw [Int.add_mul_emod_self]
```

완전 rw-only 버전은 `MathlibDemo_ch4_46.lean` 파일 참조.

</details>

### E.2 페르마 적용 (5점)

**Stage 2 — `____` 완성**. $7^{10} \equiv 1 \pmod{11}$을 Mathlib의 `ZMod.pow_card_sub_one_eq_one`으로 보여라.

```lean
example : (7 : ZMod 11) ^ 10 = 1 := by
  apply ZMod.pow_card_sub_one_eq_one
  ____
```

<details><summary>정답</summary>

```lean
example : (7 : ZMod 11) ^ 10 = 1 := by
  apply ZMod.pow_card_sub_one_eq_one
  decide
```

두 번째 전술 `decide`는 `(7 : ZMod 11) ≠ 0`을 기계 계산으로 확인.

Mathlib 구조:
- `ZMod.pow_card_sub_one_eq_one`은 $\forall [\text{Prime } p], a \neq 0 \Rightarrow a^{p-1} = 1$을 말한다.

</details>

### E.3 CRT 계산 검증 (5점)

**Stage 2**. 손자의 퍼즐 답 $x = 23$이 세 합동을 모두 만족함을 Lean으로 확인.

```lean
example : (23 : Int) % 3 = 2 ∧ (23 : Int) % 5 = 3 ∧ (23 : Int) % 7 = 2 := by
  ____
```

<details><summary>정답</summary>

```lean
example : (23 : Int) % 3 = 2 ∧ (23 : Int) % 5 = 3 ∧ (23 : Int) % 7 = 2 := by
  refine ⟨?_, ?_, ?_⟩ <;> rfl
```

또는 단순히

```lean
example : (23 : Int) % 3 = 2 ∧ (23 : Int) % 5 = 3 ∧ (23 : Int) % 7 = 2 := by
  decide
```

세 합동이 모두 `rfl` 또는 `decide`로 풀린다.

</details>

---

## Section F. 이산 로그와 기본 루트 (10점)

**F.1** (Rosen 연습 54, 3점) $2$가 $\mathbb{Z}_{19}$의 기본 루트임을 보여라.

<details><summary>정답</summary>

$2$의 $\bmod 19$ 누승 계산:
$$2^1 = 2, 2^2 = 4, 2^3 = 8, 2^4 = 16, 2^5 = 13, 2^6 = 7, 2^7 = 14, 2^8 = 9, 2^9 = 18$$
$$2^{10} = 17, 2^{11} = 15, 2^{12} = 11, 2^{13} = 3, 2^{14} = 6, 2^{15} = 12, 2^{16} = 5, 2^{17} = 10, 2^{18} = 1$$

$\{1, 2, \ldots, 18\}$이 모두 등장. **$2$는 $19$의 기본 루트**. $\blacksquare$

</details>

**F.2** (Rosen 연습 55, 3점) 밑 $2$ 모듈로 $19$에 대한 $5$와 $6$의 이산 로그를 구하라.

<details><summary>정답</summary>

F.1 표에서 $2^{16} = 5$, $2^{14} = 6$.

**답**: $\log_2 5 = 16$, $\log_2 6 = 14$ (모두 모듈로 $19$). $\blacksquare$

</details>

**F.3** (4점) Python으로 $p = 11$, 밑 $r = 2$의 모든 이산 로그 표를 만들고 출력해 보라.

```python
p, r = 11, 2
table = {}
v = 1
for e in range(p - 1):
    table[v] = e
    v = (v * r) % p

for a in range(1, p):
    print(f"log_{r} {a} = {table[a]}")
```

<details><summary>정답</summary>

출력:
```
log_2 1 = 0
log_2 2 = 1
log_2 3 = 8
log_2 4 = 2
log_2 5 = 4
log_2 6 = 9
log_2 7 = 7
log_2 8 = 3
log_2 9 = 6
log_2 10 = 5
```

예제 13 확인: $\log_2 3 = 8$, $\log_2 5 = 4$. ✓ $\blacksquare$

</details>

---

## Section G. 카마이클 수와 소수 판별 (10점)

**G.1** (Rosen 연습 46, 5점) **$1729$가 카마이클 수**임을 증명하라.

<details><summary>정답</summary>

$1729 = 7 \cdot 13 \cdot 19$. 세 소수의 곱이므로 합성수.

$\gcd(b, 1729) = 1$이면 $\gcd(b, 7) = \gcd(b, 13) = \gcd(b, 19) = 1$.

페르마로
$$b^6 \equiv 1 \pmod 7, \ b^{12} \equiv 1 \pmod{13}, \ b^{18} \equiv 1 \pmod{19}$$

$1728 = 2^6 \cdot 27 = 288 \cdot 6 = 144 \cdot 12 = 96 \cdot 18$임에 주목.

- $b^{1728} = (b^6)^{288} \equiv 1 \pmod 7$
- $b^{1728} = (b^{12})^{144} \equiv 1 \pmod{13}$
- $b^{1728} = (b^{18})^{96} \equiv 1 \pmod{19}$

연습 29의 보조정리(세 서로소 모듈 → 곱 모듈)에 의해 $b^{1728} \equiv 1 \pmod{1729}$. 따라서 **1729는 카마이클 수**. $\blacksquare$

**유명한 일화**. 수학자 하디(Hardy)가 병원의 라마누잔을 찾아가 "택시 번호가 1729였다. 재미없는 수네"라고 말했다. 라마누잔이 답했다: "아니, 재미있는 수입니다. 두 양의 세제곱의 합으로 **두 가지 방법**으로 표현되는 최소 수지요: $1729 = 1^3 + 12^3 = 9^3 + 10^3$." 이 일화로 $1729$는 'Hardy-Ramanujan 수'로도 불린다. 카마이클 수이기도 하다는 것은 덤.

</details>

**G.2** (5점) **$561$은 카마이클 수**임을 증명하라. (본교재 예제 11 재현)

<details><summary>정답</summary>

본교재 Part 4.5 참조. $561 = 3 \cdot 11 \cdot 17$이며 $560 = 2 \cdot 280 = 10 \cdot 56 = 16 \cdot 35$임을 이용하여 페르마 3회 + 연습 29의 결합. $\blacksquare$

</details>

---

## Section H. 종합 도전 (Rosen 연습 26, 27) (추가 점수 0 — 선택)

**H.1** (Rosen 연습 26). $x \equiv 5 \pmod 6$, $x \equiv 3 \pmod{10}$, $x \equiv 8 \pmod{15}$의 해가 존재하면 모두 구하라.

**주의**: $6, 10, 15$는 쌍으로 서로소가 아님. CRT 직접 적용 불가. 어떻게 할까?

<details><summary>정답</summary>

$6 = 2 \cdot 3$, $10 = 2 \cdot 5$, $15 = 3 \cdot 5$. $\text{lcm}(6, 10, 15) = 30$.

각 합동을 소수 모듈로 분해:
- $x \equiv 5 \pmod 6$ → $x \equiv 1 \pmod 2$, $x \equiv 2 \pmod 3$
- $x \equiv 3 \pmod{10}$ → $x \equiv 1 \pmod 2$, $x \equiv 3 \pmod 5$
- $x \equiv 8 \pmod{15}$ → $x \equiv 2 \pmod 3$, $x \equiv 3 \pmod 5$

모순 확인: 2, 3, 5에 대해 각각 일관된 값이 있는지 체크.
- 모듈로 2: 1 (첫째, 둘째 모두). 일관성 ✓
- 모듈로 3: 2 (첫째, 셋째 모두). 일관성 ✓
- 모듈로 5: 3 (둘째, 셋째 모두). 일관성 ✓

연립으로 재정리: $x \equiv 1 \pmod 2$, $x \equiv 2 \pmod 3$, $x \equiv 3 \pmod 5$.

CRT 공식 적용. $m = 30$, $M_1 = 15, M_2 = 10, M_3 = 6$, $y_1 \equiv 1 \pmod 2$ → $y_1 = 1$, $y_2$: $10 y_2 \equiv 1 \pmod 3$ → $y_2 = 1$, $y_3$: $6 y_3 \equiv 1 \pmod 5$ → $y_3 = 1$.

$x = 1 \cdot 15 \cdot 1 + 2 \cdot 10 \cdot 1 + 3 \cdot 6 \cdot 1 = 15 + 20 + 18 = 53 \equiv 23 \pmod{30}$.

**답**: $x \equiv 23 \pmod{30}$. 즉 $x \in \{23, 53, 83, \ldots\}$. $\blacksquare$

</details>

---

## 채점 가이드 (100점 만점)

| Section | 배점 |
|---|---|
| A. 역원 정의·계산 | 15 |
| B. 선형합동 풀기 | 15 |
| C. CRT 풀기 | 15 |
| D. 페르마 적용 | 15 |
| E. Lean 4 증명 | 20 |
| F. 이산 로그 | 10 |
| G. 카마이클 수 | 10 |
| H. 종합 도전 (선택) | (보너스) |

**A 등급** (90-100): 모든 절차 정확. Lean 4 증명 자유작성 포함 완료.
**B 등급** (75-89): 대부분 정확하지만 1-2절 실수. Lean은 Stage 2까지 성공.
**C 등급** (60-74): 기본 계산은 가능하나 증명 구성에 약점.

**핵심 실수 체크리스트**:
- 역원 존재 조건 $\gcd(a, m) = 1$ 빠뜨렸는가?
- CRT에서 $y_k$ 계산을 잘못했는가? (작은 수로 간단히 검산 필요)
- 페르마 적용에서 **소수 조건 + $p \nmid a$** 조건 확인했는가?
- Lean에서 `____`를 그대로 제출했는가? (반드시 모든 빈칸 채우기)

---

**다음 시간**: §4.6 암호학 워크북 — 카이사르부터 RSA까지.
