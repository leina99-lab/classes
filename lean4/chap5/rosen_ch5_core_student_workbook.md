# 로젠 5장 학생 워크북

이 워크북은 학생 참고용 완전판의 순서를 따른다. 빈칸을 먼저 채운 뒤 정답 보기를 열어 확인한다.

## 1. 수학적 귀납법

### 문제 1. 귀납법의 두 단계

수학적 귀납법은 기본 단계와 ___ 단계로 이루어진다.

<details><summary>정답 보기</summary>

귀납 단계.

</details>

### 문제 2. 귀납가정

합 공식 증명에서 귀납가정은 다음이다.

$$
1+2+\cdots+k=\underline{\hspace{3cm}}
$$

<details><summary>정답 보기</summary>

$$
\frac{k(k+1)}{2}
$$

</details>

### 문제 3. 합 공식 귀납 단계

다음을 채워라.

$$
\frac{k(k+1)}{2}+(k+1)
=\frac{k(k+1)+\underline{\hspace{2cm}}}{2}
$$

<details><summary>정답 보기</summary>

$$
2(k+1)
$$

</details>

### 문제 4. 합 공식 마지막 인수분해

$$
k(k+1)+2(k+1)=\underline{\hspace{3cm}}
$$

<details><summary>정답 보기</summary>

$$
(k+1)(k+2)
$$

</details>

### 문제 5. 홀수 합의 마지막 항

`(k+1)`번째 홀수는 `2(k+1)-1=___`이다.

<details><summary>정답 보기</summary>

`2k+1`.

</details>

### 문제 6. 홀수 합 계산

$$
k^2+2k+1=\underline{\hspace{3cm}}
$$

<details><summary>정답 보기</summary>

$$
(k+1)^2
$$

</details>

### 문제 7. 등비합

귀납가정이

$$
1+2+\cdots+2^k=2^{k+1}-1
$$

일 때, `P(k+1)`의 왼쪽은

$$
1+2+\cdots+2^k+\underline{\hspace{2cm}}
$$

이다.

<details><summary>정답 보기</summary>

$$
2^{k+1}
$$

</details>

### 문제 8. 배수성 전개

다음을 완성하라.

$$
(k+1)^3-(k+1)=k^3+3k^2+3k+1-k-1
=\underline{\hspace{4cm}}+3k^2+3k.
$$

<details><summary>정답 보기</summary>

$$
k^3-k
$$

</details>

### 문제 9. 배수성 결론

귀납가정 `k^3-k=3m`을 사용하면

$$
(k+1)^3-(k+1)=3m+3(k^2+k)=3(\underline{\hspace{3cm}})
$$

이다.

<details><summary>정답 보기</summary>

$$
m+k^2+k
$$

</details>

### 문제 10. 부등식 귀납

`k+1 ≤ 2^k`에서 `k+2 ≤ 2^{k+1}`을 보이기 위해 추가로 쓰는 쉬운 부등식은 `___ ≤ 2^k`이다.

<details><summary>정답 보기</summary>

`1 ≤ 2^k`.

</details>

## 2. 강귀납법과 순서화 원리

### 문제 11. 강귀납법

강귀납법은 `P(k)` 하나가 아니라 `k`보다 작은 ___ 경우를 가정한다.

<details><summary>정답 보기</summary>

모든.

</details>

### 문제 12. 소인수분해 존재

`n`이 합성수이면 `n=ab`이고 `a,b`는 모두 `n`보다 ___다.

<details><summary>정답 보기</summary>

작다.

</details>

### 문제 13. 강귀납가정 적용 대상

소인수분해 존재 증명에서 강귀납가정을 적용하는 두 대상은 ___와 ___이다.

<details><summary>정답 보기</summary>

`a`와 `b`.

</details>

### 문제 14. 순서화 원리

공집합이 아닌 자연수의 부분집합은 ___ 원소를 가진다.

<details><summary>정답 보기</summary>

최소.

</details>

### 문제 15. 최소 반례법

최소 반례 `m`보다 작은 경우들은 반례가 아니므로 모두 ___이다.

<details><summary>정답 보기</summary>

참.

</details>

### 문제 16. 우표 문제 기저값

4센트와 5센트 우표로 12, 13, 14, 15를 표현하라.

<details><summary>정답 보기</summary>

`12=4·3+5·0`, `13=4·2+5·1`, `14=4·1+5·2`, `15=4·0+5·3`.

</details>

### 문제 17. 우표 문제 귀납 이동

우표 문제에서 큰 `n`을 증명할 때 사용하는 작은 값은 `n-___`이다.

<details><summary>정답 보기</summary>

4.

</details>

### 문제 18. 우표 문제 결론

`n-4=4a+5b`이면 `n=___`이다.

<details><summary>정답 보기</summary>

`4(a+1)+5b`.

</details>

## 3. 재귀 정의

### 문제 19. 팩토리얼

팩토리얼의 초기값은 `0! = ___`이다.

<details><summary>정답 보기</summary>

1.

</details>

### 문제 20. 피보나치

피보나치 수열은 다음 항을 만들 때 이전 ___개의 항을 사용한다.

<details><summary>정답 보기</summary>

2개.

</details>

### 문제 21. Lean 자연수

다음 Lean 코드에서 `z`는 무엇을 뜻하는가.

```lean
inductive N where
| z : N
| s : N -> N
```

<details><summary>정답 보기</summary>

0을 뜻한다.

</details>

### 문제 22. Lean 덧셈

다음 빈칸을 채워라.

```lean
def add : N -> N -> N
| N.z, b => b
| N.s a, b => N.s (___ a b)
```

<details><summary>정답 보기</summary>

`add`.

</details>

### 문제 23. Lean 귀납가정

`add_z` 정리의 귀납 단계에서 `rw [add, ___]`에 들어갈 것은 무엇인가.

<details><summary>정답 보기</summary>

`ih`.

</details>

## 4. 구조적 귀납법

### 문제 24. 리스트의 생성자

리스트의 기본 생성자는 빈 리스트이고, 재귀 생성자는 원소를 앞에 붙이는 ___이다.

<details><summary>정답 보기</summary>

`cons`.

</details>

### 문제 25. 리스트 길이 정리

$$
len(xs++ys)=\underline{\hspace{4cm}}
$$

<details><summary>정답 보기</summary>

$$
len(xs)+len(ys)
$$

</details>

### 문제 26. 리스트 귀납 대상

`len(xs++ys)=len(xs)+len(ys)` 증명에서 구조적 귀납법을 적용하는 대상은 ___이다.

<details><summary>정답 보기</summary>

`xs`.

</details>

### 문제 27. 트리 mirror

`mirror(mirror(t))=___`이다.

<details><summary>정답 보기</summary>

`t`.

</details>

### 문제 28. 트리 node 경우

`node l r`에 대한 구조적 귀납법에서는 귀납가정이 ___개 필요하다.

<details><summary>정답 보기</summary>

2개. 왼쪽 부분트리와 오른쪽 부분트리에 대한 귀납가정이다.

</details>

### 문제 29. 포화 이진트리

포화 이진트리에서 잎 수와 내부 노드 수의 관계는

$$
leaves(t)=internal(t)+\underline{\hspace{1cm}}
$$

이다.

<details><summary>정답 보기</summary>

1.

</details>

## 5. 재귀 알고리즘

### 문제 30. 재귀 알고리즘 증명의 두 축

재귀 알고리즘의 전체 정확성은 종료성과 ___으로 이루어진다.

<details><summary>정답 보기</summary>

정확성 또는 부분 정확성.

</details>

### 문제 31. 유클리드 알고리즘 불변식

유클리드 알고리즘의 핵심 등식은

$$
\gcd(a,b)=\gcd(\underline{\hspace{1cm}},\underline{\hspace{2cm}})
$$

이다.

<details><summary>정답 보기</summary>

$$
\gcd(b,a\operatorname{mod} b)
$$

</details>

### 문제 32. 이진 탐색 불변식

이진 탐색에서 목표값이 배열 안에 있다면 항상 현재 검색 구간 ___ 안에 있다.

<details><summary>정답 보기</summary>

`[lo, hi)`.

</details>

### 문제 33. Python 우표 알고리즘

다음 코드의 빈칸을 채워라.

```python
def postage(n):
    base = {12:(3,0), 13:(2,1), 14:(1,2), 15:(0,3)}
    if n in base:
        return base[n]
    a, b = postage(n - 4)
    return ___, b
```

<details><summary>정답 보기</summary>

`a + 1`.

</details>

## 6. 선택 응용: 검색과 불변식

### 문제 34. 검색 시스템의 불변식

검색 기반 답변 시스템에서 필요한 근거가 후보 안에 남아 있어야 한다는 조건은 알고리즘 증명의 ___과 비슷하다.

<details><summary>정답 보기</summary>

불변식.

</details>

### 문제 35. 구조가 있는 데이터

트리나 그래프처럼 구조가 있는 데이터는 ___ 귀납법의 관점으로 검토할 수 있다.

<details><summary>정답 보기</summary>

구조적.

</details>

## 7. 추가 문제

### 문제 36. 순서화 원리에서 귀납법

반례 집합 `S`가 공집합이 아니면 순서화 원리에 의해 `S`에는 ___ 반례가 존재한다.

<details><summary>정답 보기</summary>

최소.

</details>

### 문제 37. 최소 반례 `m`

귀납법 증명에서 `P(0)`이 참이면 최소 반례 `m`은 0이 아니므로 `m=___+1` 꼴로 쓸 수 있다.

<details><summary>정답 보기</summary>

`r` 또는 어떤 자연수 `r`.

</details>

### 문제 38. 귀납법에서 순서화 원리

`P(n)`을 “0부터 n까지에는 S의 원소가 없다”라고 두면, 귀납법으로 모든 자연수에 대해 `P(n)`을 보인 뒤 `S`는 ___임을 얻는다.

<details><summary>정답 보기</summary>

공집합.

</details>

### 문제 39. 재귀적으로 정의된 짝수 집합

`0∈E`이고 `n∈E → n+2∈E`라면, `n=2t`일 때 `n+2=2(___)`이다.

<details><summary>정답 보기</summary>

`t+1`.

</details>

### 문제 40. 자연어와 Lean 대응

자연어 “귀납가정으로 치환한다”에 해당하는 Lean 패턴은 `rw [___]`이다.

<details><summary>정답 보기</summary>

`ih`.

</details>

### 문제 41. 리스트 길이 증명

`xs=x::tail`인 경우, `append`의 정의를 펼치면 `(x::tail)++ys = x::(___)`이다.

<details><summary>정답 보기</summary>

`tail++ys`.

</details>

### 문제 42. 이진 탐색 유지 조건

`x < A[mid]`이면 정렬성 때문에 `x`는 `mid`의 ___쪽에 있을 수 없다.

<details><summary>정답 보기</summary>

오른쪽.

</details>

### 문제 43. 이진 탐색 종료성

이진 탐색에서 재귀 호출마다 작아지는 자연수 값은 `___`이다.

<details><summary>정답 보기</summary>

`hi-lo`, 즉 현재 구간의 길이.

</details>

### 문제 44. 유클리드 알고리즘

`a=qb+r`이고 `d`가 `a`와 `b`를 나누면, `d`는 `r=___`도 나눈다.

<details><summary>정답 보기</summary>

`a-qb`.

</details>

### 문제 45. gcd 불변식

유클리드 알고리즘의 각 재귀 단계에서 보존되는 값은 ___이다.

<details><summary>정답 보기</summary>

최대공약수, 즉 gcd.

</details>
