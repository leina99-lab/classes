# Chapter 3.1: 알고리즘(Algorithms) — 학생용

> Rosen 이산수학 8판 3.1절 + Lean 4 형식화  
> 학습 흐름: 이론 → 추적 예시 → Lean 4 구현 → Python 구현 → 빈칸 연습

---

## 1. 왜 알고리즘을 배우는가?

### 1.1 일상 속의 알고리즘

우리는 이미 매일 알고리즘을 사용하고 있다.

- **라면 끓이기:** 물 550ml 넣기 → 끓으면 면+스프 → 4분 30초 → 완성
- **도서관에서 책 찾기:** 분류 번호 확인 → 해당 서가 이동 → 번호순 탐색
- **내비게이션:** 출발지/목적지 입력 → 가능한 경로 계산 → 최단 경로 제시

이 모든 과정의 공통점이 있다:

1. **입력**이 있다 (라면 종류, 찾는 책, 출발지/목적지)
2. **정해진 단계**를 따른다
3. **결과**(출력)가 나온다
4. **반드시 끝난다** (무한히 계속되지 않는다)

### 1.2 컴퓨터과학에서 알고리즘을 배우는 이유

- 같은 문제를 푸는 방법이 여러 가지 있다
- 어떤 방법이 더 빠른지 비교할 수 있어야 한다
- "이 문제는 절대 풀 수 없다"는 것도 증명할 수 있다 (정지 문제)

---

## 2. 알고리즘의 정의

### 2.1 정의 (Rosen 3.1절)

> **알고리즘**(algorithm)은 계산을 하거나, 문제를 풀기 위한 **정확한 명령의 유한한 서열**이다.

이 정의에서 핵심 단어 세 가지:

| 단어 | 의미 | 반례 |
|------|------|------|
| **정확한**(precise) | 각 단계가 모호하지 않다 | "적당히 섞는다" (X) |
| **명령의**(instructions) | 수행해야 할 동작이다 | 단순한 관찰이 아님 |
| **유한한**(finite) | 반드시 끝나야 한다 | 무한 루프 (X) |

### 2.2 '알고리즘'이라는 이름의 유래

9세기 페르시아 수학자 **알-콰리즈미**(Al-Khowarizmi)의 이름에서 왔다. 그는 현대 십진법의 기반이 된 인도 숫자 체계에 대한 책을 썼다. algorism → algorithm으로 변형되어 오늘날에 이르렀다.

---

## 3. 알고리즘의 7가지 속성

모든 알고리즘이 갖추어야 할 필수 조건이다. 라면 끓이기와 최댓값 찾기를 예시로 각 속성을 이해한다.

### 3.1 입력(Input)

특정한 집합으로부터 입력값을 받는다.

- 라면: 라면 종류, 물의 양이 입력이다.
- 최댓값 찾기: 정수의 리스트가 입력이다.

### 3.2 출력(Output)

각 입력에 대해 출력값을 생성한다.

- 라면: 완성된 라면이 출력이다.
- 최댓값 찾기: 가장 큰 정수가 출력이다.

### 3.3 명확성(Definiteness)

각 단계가 명확하게 정의되어야 한다.

- "물을 **550ml** 넣는다" (O) vs "물을 **적당히** 넣는다" (X)
- 컴퓨터는 "적당히"를 이해하지 못한다.

### 3.4 정확성(Correctness)

어떤 입력에 대해서도 항상 정답을 구해야 한다.

- 최댓값 알고리즘이 [3,1,4,1,5]에서 5가 아닌 4를 반환하면 정확하지 않다.
- 이것을 **증명하는 것**이 가장 어렵고 중요한 속성이다.

### 3.5 유한성(Finiteness)

어떤 입력에 대해서도 유한한 횟수의 단계를 거쳐 답을 내야 한다.

```python
while True:
    pass   # <- 이것은 알고리즘이 아니다 (영원히 끝나지 않음)
```

참고로 Lean 4의 종료 검사기(termination checker)가 유한성을 자동 보장한다. 즉, Lean 4에서 컴파일이 되면 그것은 반드시 멈추는 프로그램이다.

### 3.6 효율성(Effectiveness)

각 단계를 정확하고 유한한 시간에 수행할 수 있어야 한다.

- "다음 소수를 구하라"는 유한한 시간에 수행 가능하다.
- 하지만 "우주의 모든 원자를 세라"는 현실적으로 수행 불가능하다.

### 3.7 일반성(Generality)

특정 입력뿐 아니라, 조건을 만족하는 모든 입력에 적용되어야 한다.

- [1,2,3]에서만 작동하는 것이 아니라, **어떤 리스트**에서든 작동해야 한다.

---

## 4. 의사 코드(Pseudocode)

### 4.1 의사 코드란?

**의사 코드**는 알고리즘을 사람이 읽을 수 있는 형태로 표현한 것이다. 특정 프로그래밍 언어의 문법을 따르지 않으며, 인간의 언어와 프로그래밍 언어의 중간 역할을 한다.

### 4.2 왜 의사 코드를 사용하는가?

- 특정 언어에 종속되지 않아 누구나 이해할 수 있다
- 알고리즘의 **핵심 로직**에 집중할 수 있다
- Java, Python, Lean 4 등 어떤 언어로든 번역 가능하다

### 4.3 의사 코드의 기본 요소

| 요소 | 의미 | 예시 |
|------|------|------|
| `procedure 이름(매개변수)` | 알고리즘의 시작 | `procedure max(a1,...,an)` |
| `:=` | 값을 변수에 할당 | `max := a1` (a1의 값을 max에 저장) |
| `for i := 1 to n` | i를 1부터 n까지 반복 | 반복문 |
| `while 조건` | 조건이 참인 동안 반복 | 조건 반복문 |
| `if 조건 then` | 조건이 참이면 실행 | 조건문 |
| `return 값` | 결과를 반환하고 종료 | `return max` |

이 수업에서는 **의사 코드 → Lean 4 → Python** 순서로 구현한다.

---

## 5. 예제 1: 최댓값 찾기(Finding the Maximum)

### 5.1 문제

유한한 길이의 수열에서 가장 큰 값을 찾아라.

### 5.2 일상 비유

줄 서 있는 학생들 중 가장 키가 큰 학생을 찾는다고 하자. 모든 학생을 한꺼번에 비교할 수는 없다. 한 번에 **두 명씩만** 비교할 수 있다. 그러면 어떻게 할까?

### 5.3 핵심 아이디어

1. 첫 번째 학생을 "현재 가장 키 큰 사람"으로 기억한다
2. 다음 학생과 비교한다
3. 새 학생이 더 크면, "현재 가장 키 큰 사람"을 갱신한다
4. 마지막 학생까지 반복한다
5. 최종 "현재 가장 키 큰 사람"이 답이다

이 아이디어를 "**전진하며 기록을 갱신하기**"(scan and update)라고 부른다. 육상 경기에서 현재 기록 보유자를 계속 업데이트하는 것과 같다.

### 5.4 추적 예시: [8, 4, 11, 3, 10]

| 단계 | 비교 대상 | 현재 max | 갱신? | 이유 |
|------|---------|---------|------|------|
| 초기 | - | 8 | 초기값 | 첫 번째 원소 |
| 1 | 4 | 8 | X | 4 <= 8 |
| 2 | 11 | 11 | O | 11 > 8 |
| 3 | 3 | 11 | X | 3 <= 11 |
| 4 | 10 | 11 | X | 10 <= 11 |

결과: max = 11, 비교 횟수 = 4회 = n - 1

**왜 n - 1번인가?** 원소가 n개이면, 첫 번째를 기준으로 잡고 나머지 n - 1개와 비교한다. 어떤 입력이 와도 항상 정확히 n - 1번 비교한다.

### 5.5 의사 코드

```
procedure max(a1, a2, ..., an: integers)
  max := a1
  for i := 2 to n
    if max < ai then max := ai
  return max
```

### 5.6 Lean 4 구현

의사 코드의 각 줄이 Lean 4에서 어떻게 대응되는지 1:1로 살펴본다.

```lean
-- Lean 4: 최댓값 찾기
def myMax : List Nat → Nat
  | []      => 0            -- 빈 리스트: 기본값 0
  | [a]     => a            -- 원소 하나: 그것이 최대
  | a :: as =>              -- 첫 원소 a + 나머지 as
    let m := myMax as       -- 나머지의 최대를 재귀로 구함
    if a ≥ m then a else m  -- 더 큰 쪽을 반환

#eval myMax [8, 4, 11, 3, 10]  -- 11
```

**1:1 대응 표:**

| 의사 코드 | Lean 4 | 의미 |
|----------|--------|------|
| `max := a1` | `\| [a] => a` | 기저 경우(base case) |
| `for i := 2 to n` | `\| a :: as =>` | 재귀로 나머지 처리 |
| `if max < ai` | `if a >= m then a else m` | 비교 후 큰 쪽 선택 |
| `return max` | 함수의 반환값 | 최종 결과 |

**핵심 관찰:** 의사 코드의 **for 루프**가 Lean 4에서는 **재귀(recursion) + 패턴 매칭(pattern matching)**으로 표현된다. Lean 4는 함수형 언어이므로, 반복문 대신 재귀를 사용하는 것이 자연스럽다.

잠깐, 왜 Lean 4에는 for 루프가 없을까? 사실 있기는 하다. 하지만 수학적 증명을 위해서는 재귀가 훨씬 다루기 쉽다. 재귀 함수는 **수학적 귀납법**과 정확히 같은 구조이기 때문이다.


### 5.7 Python 구현

```python
def my_max(lst):
    """리스트에서 최댓값을 찾는다."""
    if not lst:
        return 0           # 빈 리스트: 기본값
    max_val = lst[0]        # 첫 원소를 max로 설정
    for i in range(1, len(lst)):
        if lst[i] > max_val:
            max_val = lst[i]  # 더 크면 갱신
    return max_val

print(my_max([8, 4, 11, 3, 10]))  # 11
```

**3단 비교표:**

| 의사 코드 | Lean 4 | Python |
|----------|--------|--------|
| `max := a1` | `\| [a] => a` | `max_val = lst[0]` |
| `for i := 2 to n` | `\| a :: as =>` (재귀) | `for i in range(1, len(lst)):` |
| `if max < ai` | `if a >= m then a else m` | `if lst[i] > max_val:` |
| `return max` | 함수 반환값 | `return max_val` |

**관찰:** Python은 의사 코드와 거의 1:1로 대응된다. Lean 4는 재귀를 사용하므로 구조가 다르다. 하지만 세 가지 모두 **같은 알고리즘**을 표현한다.

### 5.8 Lean 4에서 재귀가 동작하는 원리

`myMax [8, 4, 11, 3, 10]`이 어떻게 계산되는지 추적해 보자.

```
myMax [8, 4, 11, 3, 10]
= let m := myMax [4, 11, 3, 10] in if 8 ≥ m then 8 else m
  = let m := myMax [11, 3, 10] in if 4 ≥ m then 4 else m
    = let m := myMax [3, 10] in if 11 ≥ m then 11 else m
      = let m := myMax [10] in if 3 ≥ m then 3 else m
        = 10  (기저 경우: 원소 하나)
      = if 3 ≥ 10 then 3 else 10 = 10
    = if 11 ≥ 10 then 11 else 10 = 11
  = if 4 ≥ 11 then 4 else 11 = 11
= if 8 ≥ 11 then 8 else 11 = 11
```

재귀는 **먼저 끝까지 내려간 뒤**, 결과를 **거꾸로 올라오며** 합치는 것이다. 마치 러시아 인형(마트료시카)을 열어 가장 안쪽 인형을 꺼낸 뒤, 다시 하나씩 닫는 것과 같다.

### 5.9 빈칸 연습

```lean
def myMax : List Nat → Nat
  | []      => ___       -- (a) 빈 리스트의 최대값?
  | [a]     => ___       -- (b) 원소가 하나일 때?
  | a :: as =>
    let m := ___         -- (c) 나머지의 최대값을 구하려면?
    if ___ then a else m -- (d) a가 더 크거나 같은 조건?
```

<details>
<summary>힌트 보기</summary>

- (a) 빈 리스트에는 원소가 없으므로 기본값 0
- (b) 원소가 하나뿐이면 그것이 최대
- (c) myMax as — 재귀 호출
- (d) a >= m — 첫 원소가 나머지 최대보다 크거나 같으면

</details>

<details>
<summary>정답 보기</summary>

```lean
def myMax : List Nat → Nat
  | []      => 0            -- (a)
  | [a]     => a            -- (b)
  | a :: as =>
    let m := myMax as       -- (c)
    if a ≥ m then a else m  -- (d)
```

</details>

---

## 6. 예제 2: 선형 탐색(Linear Search)

### 6.1 문제

리스트에서 특정 값 x의 위치를 찾아라. 없으면 0을 반환하라.

### 6.2 일상 비유

정리가 안 된 서랍에서 열쇠를 찾는 것과 같다.
- 서랍을 하나씩 열어본다
- 열쇠가 있으면 찾은 것이다
- 마지막 서랍까지 없으면 "집에 없다"

### 6.3 왜 "선형"인가?

리스트의 처음부터 끝까지 **일직선(linear)으로** 탐색하기 때문이다. 첫 번째, 두 번째, 세 번째, ... 순서대로 하나씩 살펴본다. 다른 전략 없이 순수하게 처음부터 끝까지 훑는 것이다.

### 6.4 추적 예시 1: [3, 5, 7, 8, 10]에서 7을 찾을 때

| 위치 | 원소 | 비교 | 결과 |
|------|------|------|------|
| 1 | 3 | 3 = 7? | 아니오, 다음으로 |
| 2 | 5 | 5 = 7? | 아니오, 다음으로 |
| 3 | 7 | 7 = 7? | **예! 위치 3 반환** |

비교 횟수: 3회. 운이 좋은 편이다.

### 6.5 추적 예시 2: [3, 5, 7, 8, 10]에서 4를 찾을 때

| 위치 | 원소 | 비교 | 결과 |
|------|------|------|------|
| 1 | 3 | 3 = 4? | 아니오 |
| 2 | 5 | 5 = 4? | 아니오 |
| 3 | 7 | 7 = 4? | 아니오 |
| 4 | 8 | 8 = 4? | 아니오 |
| 5 | 10 | 10 = 4? | 아니오 |

비교 횟수: 5회 (전체 리스트를 다 살펴봄) → **0 반환 (없음)**

이것이 최악의 경우이다. 찾는 값이 리스트에 아예 없으면, 모든 원소를 빠짐없이 확인해야 하기 때문이다.

### 6.6 복잡도 분석

- **최악의 경우**(원소가 리스트에 없을 때): n번 비교 → **O(n)**
- **최선의 경우**(첫 번째에서 바로 발견): 1번 비교 → **O(1)**
- **평균**(리스트에 있고 각 위치에 있을 확률이 같을 때): (n+1)/2번 → **O(n)**

### 6.7 의사 코드

```
procedure linear_search(x: integer, a1, a2, ..., an: integers)
  i := 1
  while (i ≤ n and ai ≠ x)
    i := i + 1
  if i ≤ n then location := i
  else location := 0
  return location
```

### 6.8 Lean 4 구현

```lean
-- Lean 4: 선형 탐색
-- BEq는 "같다(=)"를 판별하는 타입 클래스이다
def linearSearch [BEq α] (x : α) : List α → Option Nat
  | []      => none             -- 빈 리스트: 못 찾음
  | a :: as =>
    if a == x then some 0       -- 찾았다! 위치 0
    else match linearSearch x as with
      | none   => none          -- 나머지에도 없음
      | some i => some (i + 1)  -- 나머지에서 i번째 → 전체에서 i+1번째

#eval linearSearch 7 [3, 5, 7, 8, 10]  -- some 2  (0-indexed)
#eval linearSearch 4 [3, 5, 7, 8, 10]  -- none
```

**1:1 대응 표:**

| 의사 코드 | Lean 4 | 의미 |
|----------|--------|------|
| `i := 1; while` | 재귀 + 패턴 매칭 | 순차 탐색 |
| `ai ≠ x` | `if a == x then` | 현재 원소와 비교 |
| `location := i` | `some 0` / `some (i+1)` | 위치 반환 |
| `location := 0` | `none` | 못 찾음 |

**`Option`이란?** Lean 4에서 "값이 있을 수도, 없을 수도 있다"를 표현하는 타입이다. `some v`는 값 v가 있음을, `none`은 값이 없음을 의미한다. 의사 코드에서 "없으면 0을 반환"하는 것보다 더 안전한 방식이다. 왜냐하면 0이 진짜 위치일 수도 있으니까.


### 6.9 Python 구현

```python
def linear_search(x, lst):
    """리스트에서 x의 위치를 찾는다. 없으면 -1."""
    for i in range(len(lst)):
        if lst[i] == x:
            return i      # 찾았다! 위치 반환
    return -1             # 못 찾음

print(linear_search(7, [3, 5, 7, 8, 10]))  # 2 (0-indexed)
print(linear_search(4, [3, 5, 7, 8, 10]))  # -1
```

**3단 비교표:**

| 의사 코드 | Lean 4 | Python |
|----------|--------|--------|
| `while (i <= n and ai != x)` | 재귀 + 패턴 매칭 | `for i in range(len(lst)):` |
| `ai = x?` | `if a == x` | `if lst[i] == x:` |
| `location := i` | `some i` | `return i` |
| `location := 0` | `none` | `return -1` |

**Python의 -1 vs Lean 4의 none:** Python에서는 관례적으로 -1을 "못 찾음"으로 사용한다. Lean 4의 `Option` 타입(`some`/`none`)이 더 안전한 방식이다.

### 6.10 빈칸 연습

```lean
def linearSearch [BEq α] (x : α) : List α → Option Nat
  | []      => ___                    -- (a) 빈 리스트일 때?
  | a :: as =>
    if ___ then some 0                -- (b) 찾았을 때의 조건?
    else match ___ with               -- (c) 나머지에서 재귀 탐색?
      | none   => ___                 -- (d) 나머지에도 없으면?
      | some i => ___                 -- (e) 나머지에서 i번째면?
```

<details>
<summary>정답 보기</summary>

```lean
def linearSearch [BEq α] (x : α) : List α → Option Nat
  | []      => none                        -- (a)
  | a :: as =>
    if a == x then some 0                  -- (b)
    else match linearSearch x as with      -- (c)
      | none   => none                     -- (d)
      | some i => some (i + 1)             -- (e)
```

</details>

---

## 7. 예제 3: 이진 탐색(Binary Search)

### 7.1 문제

**정렬된** 리스트에서 특정 값 x의 위치를 찾아라.

**전제 조건:** 리스트가 **오름차순으로 정렬**되어 있어야 한다! 이 조건이 없으면 이진 탐색은 사용할 수 없다.

### 7.2 일상 비유: 전화번호부에서 "김철수" 찾기

**방법 1** (선형 탐색): 첫 페이지부터 한 장씩 넘긴다 → 매우 느리다!

**방법 2** (이진 탐색):
1. 전화번호부의 **정가운데**를 편다
2. "ㄴ" 부분이 나왔다 → "김"은 "ㄴ"보다 뒤 → **뒤쪽 절반만** 탐색
3. 뒤쪽 절반의 **정가운데**를 편다
4. "ㅂ" 부분이 나왔다 → "김"은 "ㅂ"보다 앞 → **앞쪽 절반만** 탐색
5. 이렇게 범위를 계속 줄여 나간다

아무도 전화번호부를 첫 페이지부터 읽지 않는다. 이것이 이진 탐색의 직관이다.

### 7.3 핵심 통찰: 매 단계마다 절반이 사라진다

n개의 원소가 있으면:
- 1단계 후: n/2개
- 2단계 후: n/4개
- 3단계 후: n/8개
- ...
- k단계 후: n/2ᵏ개

n/2ᵏ = 1이 되면 탐색이 종료된다. 따라서 k = log₂(n).

이것이 이진 탐색이 O(log n)인 이유이다.

### 7.4 추적 예시

리스트: [1, 3, 5, 7, 8, 10, 12, 15, 16, 18, 19, 20, 22, 25] (14개 원소)에서 19를 찾자.

| 단계 | lo | hi | mid | arr[mid] | 비교 | 다음 범위 |
|------|----|----|-----|----------|------|---------|
| 1 | 0 | 13 | 6 | 12 | 12 < 19 | 오른쪽 [7..13] |
| 2 | 7 | 13 | 10 | 19 | 19 = 19 | **발견!** |

단 **2번의 비교**로 14개 원소에서 19를 찾았다! 선형 탐색이었다면 **11번** 비교가 필요했을 것이다.

**mid는 어떻게 계산하는가?** `mid = (lo + hi) / 2` (정수 나눗셈, 소수점 이하 버림)

### 7.5 선형 vs 이진: 극적인 차이

| n | 선형 탐색(최악) | 이진 탐색(최악) | 차이 |
|---|---------------|---------------|------|
| 10 | 10번 | 4번 | 2.5배 |
| 100 | 100번 | 7번 | 14배 |
| 1,000 | 1,000번 | 10번 | 100배 |
| 1,000,000 | 1,000,000번 | 20번 | **50,000배** |

n이 100만일 때 50,000배 차이가 난다. "정렬되어 있다"는 조건 하나가 이 엄청난 차이를 만든다. 공짜 점심은 없다 — 그 대신 먼저 정렬하는 비용을 지불해야 한다.

### 7.6 의사 코드

```
procedure binary_search(x: integer, a1, a2, ..., an: increasing integers)
  i := 1        {i는 탐색 범위의 왼쪽 끝}
  j := n        {j는 탐색 범위의 오른쪽 끝}
  while i < j
    m := ⌊(i + j) / 2⌋
    if x > am then i := m + 1
    else j := m
  if x = ai then location := i
  else location := 0
  return location
```

### 7.7 Lean 4 구현

```lean
-- Lean 4: 이진 탐색 (배열 버전)
def binarySearch (arr : Array Nat) (x : Nat) : Option Nat :=
  go 0 (arr.size - 1)
where
  go (lo hi : Nat) : Option Nat :=
    if lo > hi then none
    else
      let mid := (lo + hi) / 2
      let v := arr[mid]!
      if v == x then some mid
      else if v < x then go (mid + 1) hi
      else if mid == 0 then none
      else go lo (mid - 1)
  termination_by hi - lo

#eval binarySearch #[1,3,5,7,8,10,12,15,16,18,19,20,22,25] 19
-- some 10
```

**`termination_by`란?** Lean 4는 모든 함수가 반드시 종료됨을 보장한다. `termination_by hi - lo`는 "매 재귀 호출마다 `hi - lo`가 줄어들므로 결국 종료된다"는 것을 Lean에게 알려주는 것이다.


### 7.8 Python 구현

```python
def binary_search(arr, x):
    """정렬된 리스트에서 x의 위치를 찾는다."""
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = (lo + hi) // 2    # 정수 나눗셈
        if arr[mid] == x:
            return mid           # 찾았다!
        elif arr[mid] < x:
            lo = mid + 1         # 오른쪽 탐색
        else:
            hi = mid - 1         # 왼쪽 탐색
    return -1                    # 못 찾음

arr = [1,3,5,7,8,10,12,15,16,18,19,20,22,25]
print(binary_search(arr, 19))  # 10
```

**3단 비교표:**

| 의사 코드 | Lean 4 | Python |
|----------|--------|--------|
| `i := 1; j := n` | `go 0 (arr.size-1)` | `lo, hi = 0, len(arr)-1` |
| `while i < j` | 재귀 + `termination_by` | `while lo <= hi:` |
| `m := (i+j)/2` | `let mid := (lo+hi)/2` | `mid = (lo+hi)//2` |
| `if x > am` | `if v < x then go (mid+1) hi` | `elif arr[mid] < x: lo = mid+1` |

**관찰:** Python의 while 루프가 의사 코드와 가장 비슷하다. Lean 4는 재귀를 사용하며 `termination_by`로 종료를 보장한다.

### 7.9 빈칸 연습

```lean
def binarySearch (arr : Array Nat) (x : Nat) : Option Nat :=
  go 0 (arr.size - 1)
where
  go (lo hi : Nat) : Option Nat :=
    if lo > hi then ___           -- (a) 범위가 비었을 때?
    else
      let mid := ___              -- (b) 중간 인덱스?
      let v := arr[mid]!
      if v == x then ___          -- (c) 찾았을 때?
      else if v < x then ___      -- (d) 오른쪽 탐색?
      else if mid == 0 then none
      else ___                    -- (e) 왼쪽 탐색?
  termination_by hi - lo
```

<details>
<summary>정답 보기</summary>

```lean
  go (lo hi : Nat) : Option Nat :=
    if lo > hi then none                  -- (a)
    else
      let mid := (lo + hi) / 2           -- (b)
      let v := arr[mid]!
      if v == x then some mid            -- (c)
      else if v < x then go (mid + 1) hi -- (d)
      else if mid == 0 then none
      else go lo (mid - 1)               -- (e)
```

</details>

---

## 8. 정렬 알고리즘 1: 버블 정렬(Bubble Sort)

### 8.1 문제

리스트를 오름차순으로 정렬하라.

### 8.2 일상 비유: 키 순서대로 줄 세우기

1. 옆에 서 있는 두 사람의 키를 비교한다
2. 순서가 잘못되어 있으면 위치를 바꾼다
3. 줄의 처음부터 끝까지 한 번 훑는다 (= 1 패스)
4. 한 번 훑으면 **가장 키가 큰 사람이 맨 뒤로** 이동한다
5. 이 과정을 반복하면 전체가 정렬된다

### 8.3 이름의 유래

"거품(bubble)" 정렬 — 수영장 바닥에서 올라오는 공기 방울처럼, **큰 원소가 위로(뒤로) 떠오른다**.

### 8.4 추적: [3, 2, 4, 1, 5]를 정렬하자

**Pass 1:** (가장 큰 원소 5가 맨 뒤로 확정된다)
```
[3, 2, 4, 1, 5]
 3>2 → 교환 → [2, 3, 4, 1, 5]
 3<4 → 유지 → [2, 3, 4, 1, 5]
 4>1 → 교환 → [2, 3, 1, 4, 5]
 4<5 → 유지 → [2, 3, 1, 4, 5]
```
결과: 5가 맨 뒤에 확정!

**Pass 2:** (두 번째로 큰 원소 4가 확정된다)
```
[2, 3, 1, 4, 5]
 2<3 → 유지
 3>1 → 교환 → [2, 1, 3, 4, 5]
 3<4 → 유지
```
결과: 4도 확정!

**Pass 3:**
```
[2, 1, 3, 4, 5]
 2>1 → 교환 → [1, 2, 3, 4, 5]
 2<3 → 유지
```

**Pass 4:** (교환 없음 → 정렬 완료!)

### 8.5 비교 횟수

4 + 3 + 2 + 1 = **10** = n(n−1)/2 = 5 x 4 / 2

일반적으로: (n-1) + (n-2) + ... + 1 = **n(n−1)/2**

복잡도: **Theta(n²)**

이것은 많이 느린 것인가? n = 1000이면 약 50만 번 비교해야 한다. n = 100만이면 약 5000억 번이다. 현대 컴퓨터에서 초당 약 10억 번 연산이 가능하므로, n = 100만짜리 버블 정렬은 약 500초(8분 이상) 걸린다.

### 8.6 의사 코드

```
procedure bubble_sort(a1, a2, ..., an: real numbers, n ≥ 2)
  for i := 1 to n - 1
    for j := 1 to n - i
      if aj > aj+1 then interchange aj and aj+1
```

### 8.7 Lean 4 구현

```lean
-- Lean 4: 버블 정렬 (배열 버전)
def bubblePass (arr : Array Nat) (endIdx : Nat) : Array Nat :=
  go arr 0
where
  go (a : Array Nat) (i : Nat) : Array Nat :=
    if i + 1 ≥ endIdx then a
    else
      let a' := if a[i]! > a[i+1]! then a.swap! i (i+1) else a
      go a' (i + 1)
  termination_by endIdx - i

def bubbleSort (arr : Array Nat) : Array Nat :=
  go arr arr.size
where
  go (a : Array Nat) (n : Nat) : Array Nat :=
    if n ≤ 1 then a
    else go (bubblePass a n) (n - 1)
  termination_by n

#eval bubbleSort #[3, 2, 4, 1, 5]  -- #[1, 2, 3, 4, 5]
```


### 8.8 Python 구현

```python
def bubble_sort(lst):
    """버블 정렬: 인접 원소를 비교하여 교환한다."""
    arr = lst[:]              # 원본 보존을 위해 복사
    n = len(arr)
    for i in range(n - 1):          # n-1번 패스
        for j in range(n - 1 - i):  # 매 패스마다 범위 축소
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]  # 교환
    return arr

print(bubble_sort([3, 2, 4, 1, 5]))  # [1, 2, 3, 4, 5]
```

**Python의 swap:** `a, b = b, a`는 Python만의 간결한 교환 문법이다. C나 Java에서는 임시 변수가 필요하다.

---

## 9. 정렬 알고리즘 2: 삽입 정렬(Insertion Sort)

### 9.1 일상 비유: 카드 게임에서 손에 든 카드 정리하기

1. 처음에 카드 1장을 손에 든다 (이미 "정렬됨")
2. 새 카드를 받으면, 이미 정리된 카드 사이의 **올바른 위치에 끼워 넣는다**
3. 카드를 다 받을 때까지 반복한다

이것이 삽입 정렬의 전부이다. 실제로 트럼프 카드를 정리할 때 대부분의 사람이 무의식적으로 삽입 정렬을 사용한다.

### 9.2 핵심 아이디어

- 리스트를 "**정렬된 부분**"과 "**아직 정렬 안 된 부분**"으로 나눈다
- 정렬 안 된 부분에서 원소를 하나 꺼내서
- 정렬된 부분의 올바른 위치에 삽입한다
- 이 과정을 반복하면 "정렬된 부분"이 점점 커진다

### 9.3 추적: [3, 2, 4, 1, 5]

| 단계 | 삽입할 원소 | 정렬된 부분 | 삽입 과정 | 결과 |
|------|---------|---------|---------|------|
| 초기 | - | [3] | - | [3] |
| j=2 | 2 | [3] | 2 < 3이므로 3 앞에 삽입 | [**2**, 3] |
| j=3 | 4 | [2,3] | 4 > 3이므로 끝에 유지 | [2, 3, **4**] |
| j=4 | 1 | [2,3,4] | 1 < 2이므로 맨 앞에 삽입 | [**1**, 2, 3, 4] |
| j=5 | 5 | [1,2,3,4] | 5 > 4이므로 끝에 유지 | [1, 2, 3, 4, **5**] |

### 9.4 버블 정렬과의 비교

| 항목 | 버블 정렬 | 삽입 정렬 |
|------|---------|---------|
| 핵심 연산 | 인접 원소 교환 | 올바른 위치에 삽입 |
| 최악 | Theta(n²) | Theta(n²) |
| 최선 | O(n) (최적화 시) | **O(n)** (이미 정렬) |
| 실제 성능 | 대체로 느림 | **대체로 더 빠름** |
| 거의 정렬된 데이터 | 여전히 느림 | **매우 빠름** |

삽입 정렬이 거의 정렬된 데이터에서 빠른 이유: 새 원소를 삽입할 올바른 위치가 바로 근처에 있으므로, 비교 횟수가 매우 적어진다. 버블 정렬은 이런 상황에서도 매번 전체를 훑어야 한다.

### 9.5 의사 코드

```
procedure insertion_sort(a1, a2, ..., an: real numbers, n ≥ 2)
  for j := 2 to n
    i := 1
    while aj > ai
      i := i + 1
    m := aj
    for k := 0 to j - i - 1
      aj-k := aj-k-1
    ai := m
```

### 9.6 Lean 4 구현

```lean
-- Lean 4: 삽입 정렬 (리스트 버전)
def insert (x : Nat) : List Nat → List Nat
  | []      => [x]
  | a :: as =>
    if x ≤ a then x :: a :: as   -- x가 더 작으면 앞에 삽입
    else a :: insert x as        -- 아니면 다음 위치에서 시도

def insertionSort : List Nat → List Nat
  | []      => []
  | a :: as => insert a (insertionSort as)

#eval insertionSort [3, 2, 4, 1, 5]  -- [1, 2, 3, 4, 5]
```

**Lean 4 코드가 의사 코드보다 훨씬 간결한 이유:** 패턴 매칭과 재귀를 사용하면 인덱스 관리가 불필요하다. `insert` 함수가 "올바른 위치에 삽입"이라는 핵심만 정확히 표현한다.


### 9.7 Python 구현

```python
def insertion_sort(lst):
    """삽입 정렬: 올바른 위치에 삽입한다."""
    arr = lst[:]
    for j in range(1, len(arr)):
        key = arr[j]              # 삽입할 원소
        i = j - 1
        while i >= 0 and arr[i] > key:
            arr[i + 1] = arr[i]   # 한 칸씩 뒤로 밀기
            i -= 1
        arr[i + 1] = key          # 올바른 위치에 삽입
    return arr

print(insertion_sort([3, 2, 4, 1, 5]))  # [1, 2, 3, 4, 5]
```

**Lean 4 vs Python 구조 비교:**

| Lean 4 | Python |
|--------|--------|
| `insert` 함수 (재귀) | `while` 루프 (밀어내기) |
| `insertionSort` (재귀) | `for j in range(1, n):` |
| 새 리스트 생성 (함수형) | 제자리 수정 (명령형) |

Lean 4는 **함수형**: 원본을 수정하지 않고 새 리스트를 반환한다. Python은 **명령형**: 배열을 직접 수정한다. 같은 알고리즘을 다른 "세계관"으로 표현한 것이다.

### 9.8 빈칸 연습

```lean
def insert (x : Nat) : List Nat → List Nat
  | []      => ___                   -- (a) 빈 리스트에 삽입?
  | a :: as =>
    if ___ then x :: a :: as         -- (b) x를 앞에 놓는 조건?
    else a :: ___                    -- (c) 아니면?

def insertionSort : List Nat → List Nat
  | []      => ___                   -- (d) 빈 리스트 정렬?
  | a :: as => ___                   -- (e) 첫 원소를 나머지 정렬 결과에?
```

<details>
<summary>정답 보기</summary>

```lean
def insert (x : Nat) : List Nat → List Nat
  | []      => [x]                          -- (a)
  | a :: as =>
    if x ≤ a then x :: a :: as              -- (b)
    else a :: insert x as                   -- (c)

def insertionSort : List Nat → List Nat
  | []      => []                           -- (d)
  | a :: as => insert a (insertionSort as)  -- (e)
```

</details>

---

## 10. 욕심쟁이 알고리즘(Greedy Algorithms)

### 10.1 핵심 아이디어

최적화 문제에서 **각 단계마다 그 순간에 가장 좋은 선택**을 한다.

### 10.2 일상 비유: 뷔페에서 접시 채우기

- 가장 맛있어 보이는 것부터 담는다
- 매 순간 최선의 선택을 한다
- 하지만 결과적으로 **최적의 식사**가 아닐 수 있다 (디저트 공간이 없어짐!)

### 10.3 예제: 거스름돈 문제

500원, 100원, 50원, 10원 동전으로 760원을 줄 때, 최소 동전 개수는?

욕심쟁이 전략: **가장 큰 동전부터** 최대한 많이 사용한다.

| 단계 | 동전 | 개수 | 사용액 | 남은 금액 |
|------|------|------|-------|---------|
| 1 | 500원 | 1개 | 500원 | 260원 |
| 2 | 100원 | 2개 | 200원 | 60원 |
| 3 | 50원 | 1개 | 50원 | 10원 |
| 4 | 10원 | 1개 | 10원 | 0원 |

총 **5개** 동전. 이것이 최소인가? **그렇다!** (증명 가능)

### 10.4 욕심쟁이가 실패하는 경우

동전: 1원, 3원, 4원 / 거스름돈: 6원

- 욕심쟁이: 4 + 1 + 1 = **3개**
- 최적: 3 + 3 = **2개**

**욕심쟁이가 항상 최적은 아니다!** 각 문제마다 최적임을 증명해야 한다.

### 10.5 Lean 4 구현

```lean
-- Lean 4: 거스름돈 문제 (욕심쟁이)
def greedyChange (coins : List Nat) (amount : Nat) : List (Nat × Nat) :=
  go coins amount []
where
  go : List Nat → Nat → List (Nat × Nat) → List (Nat × Nat)
  | [], _, acc => acc
  | _, 0, acc => acc
  | c :: cs, rem, acc =>
    let count := rem / c
    go cs (rem % c) (acc ++ [(c, count)])

#eval greedyChange [500, 100, 50, 10] 760
-- [(500, 1), (100, 2), (50, 1), (10, 1)]
```


### 10.6 Python 구현

```python
def greedy_change(coins, amount):
    """욕심쟁이 거스름돈: 큰 동전부터 최대한 사용."""
    result = []
    for c in coins:
        count = amount // c    # 이 동전을 최대 몇 개 쓸 수 있나?
        if count > 0:
            result.append((c, count))
            amount -= c * count  # 남은 금액 갱신
    return result

print(greedy_change([500, 100, 50, 10], 760))
# [(500, 1), (100, 2), (50, 1), (10, 1)]
```

---

## 11. if(→)와 iff(↔)의 차이

이 절은 Lean 4에서 자주 등장하는 두 가지 논리 연결자를 명확히 구분하기 위한 것이다.

### 11.1 → (조건문, "이면")

한 방향만 성립하는 관계이다.

- "비가 오면 땅이 젖는다" (참)
- 역: "땅이 젖으면 비가 오는가?" → 반드시 아님 (스프링클러일 수도!)

Lean 4에서:

```lean
-- P → Q: P가 참이면 Q도 참이다
-- "P를 받아서 Q를 돌려주는 함수"로 이해하면 된다
example (h : P → Q) (hp : P) : Q := h hp
```

### 11.2 ↔ (쌍조건문, "필요충분조건")

양방향 모두 성립하는 관계이다.

- "n이 짝수이다 ↔ n을 2로 나누면 나머지가 0이다"
- → 방향: 짝수이면 나머지 0 (참)
- ← 방향: 나머지 0이면 짝수 (참)
- 두 방향 모두 참이므로 **동치**(equivalent)이다.

Lean 4에서:

```lean
-- P ↔ Q: P이면 Q이고, Q이면 P이다
-- 즉, (P → Q) ∧ (Q → P)와 같다.
example (h : P ↔ Q) (hp : P) : Q := h.mp hp    -- → 방향
example (h : P ↔ Q) (hq : Q) : P := h.mpr hq   -- ← 방향
```

### 11.3 한눈에 비교

| 항목 | → (이면) | ↔ (필요충분) |
|------|---------|------------|
| 방향 | 한 방향 | 양방향 |
| 의미 | P이면 Q | P이면 Q이고, Q이면 P |
| Lean 4 구성 | `intro hp; ...` | `constructor; ...` (두 방향 각각) |
| Lean 4 사용 | `h hp` 또는 `apply h` | `h.mp hp` / `h.mpr hq` |
| 일상 비유 | 일방통행 도로 | 양방향 도로 |

---

## 12. 정지 문제(The Halting Problem)

### 12.1 "풀 수 없는 문제"가 존재하는가?

지금까지 모든 문제에 알고리즘이 존재했다. 그렇다면 모든 문제에 알고리즘이 존재하는가?

**앨런 튜링**(Alan Turing, 1936)이 충격적인 답을 내놓았다: **아니다.**

### 12.2 정지 문제란?

> 임의의 프로그램 P와 입력 I가 주어졌을 때,
> "P가 입력 I에 대해 유한한 시간 안에 멈추는가?"를
> 판별하는 알고리즘은 존재하지 않는다.

직관적으로: "이 프로그램이 영원히 돌까, 아니면 언젠가 멈출까?"를 모든 경우에 정확히 판별할 수 있는 범용 프로그램은 만들 수 없다.

### 12.3 증명 아이디어 (귀류법)

정지 문제를 풀 수 있다고 가정하면 모순이 발생한다.

1. `H(P, I)`라는 함수가 있다고 하자:
   - P가 입력 I에 대해 멈추면 "멈춤" 반환
   - P가 입력 I에 대해 멈추지 않으면 "무한" 반환

2. 새 프로그램 `K(P)`를 만들자:
   ```
   K(P) = if H(P, P) = "멈춤" then 무한루프
          else 멈춤
   ```

3. 이제 `K(K)`를 실행하면?
   - K(K)가 멈춘다고 가정 → H(K,K) = "멈춤" → K의 정의에 의해 무한루프 → 모순!
   - K(K)가 멈추지 않는다고 가정 → H(K,K) = "무한" → K의 정의에 의해 멈춤 → 모순!

4. 어느 쪽이든 모순 → H는 존재할 수 없다.

이 증명은 "이발사의 역설"과 구조가 같다: "마을에서 스스로 면도하지 않는 사람만 면도해주는 이발사"는 존재할 수 없다.

---

## 13. 종합 연습

### 13.1 빈칸 채우기 연습

**문제 1:** 리스트의 합을 구하는 함수

```lean
def listSum : List Nat → Nat
  | []      => ___           -- (a)
  | a :: as => ___           -- (b)

#eval listSum [1, 2, 3, 4, 5]  -- 15
```

<details>
<summary>정답 보기</summary>

```lean
def listSum : List Nat → Nat
  | []      => 0                   -- (a) 빈 리스트의 합은 0
  | a :: as => a + listSum as      -- (b) 첫 원소 + 나머지의 합
```

</details>

**문제 2:** 리스트의 길이를 구하는 함수

```lean
def myLength : List α → Nat
  | []      => ___           -- (a)
  | _ :: as => ___           -- (b)

#eval myLength [10, 20, 30]  -- 3
```

<details>
<summary>정답 보기</summary>

```lean
def myLength : List α → Nat
  | []      => 0                    -- (a) 빈 리스트의 길이는 0
  | _ :: as => 1 + myLength as      -- (b) 1 + 나머지의 길이
```

</details>

**문제 3:** 리스트에 특정 원소가 있는지 판별하는 함수

```lean
def contains [BEq α] (x : α) : List α → Bool
  | []      => ___           -- (a)
  | a :: as => ___           -- (b)

#eval contains 3 [1, 2, 3, 4]  -- true
#eval contains 5 [1, 2, 3, 4]  -- false
```

<details>
<summary>정답 보기</summary>

```lean
def contains [BEq α] (x : α) : List α → Bool
  | []      => false                             -- (a) 빈 리스트에는 없다
  | a :: as => a == x || contains x as           -- (b) 현재 원소이거나 나머지에 있거나
```

</details>

### 13.2 sorry 완성 연습

**문제 4:** `myMax`의 정확성 — 모든 원소보다 크거나 같다

```lean
-- 이 정리는 myMax이 리스트의 모든 원소보다 크거나 같음을 말한다.
-- 아직 증명하기 어려울 수 있다. 구조만 이해하는 것이 목표이다.
theorem myMax_ge_all (l : List Nat) (h : l ≠ []) :
    ∀ x ∈ l, x ≤ myMax l := by
  sorry
```

이 문제는 3.2절(함수의 증가)과 3.3절(복잡도)을 배운 후 다시 도전할 수 있다.

### 13.3 완전 자유 증명 연습

**문제 5:** 삽입 정렬의 `insert` 함수가 원소를 보존함을 증명하라.

```lean
-- insert x l 의 길이는 l의 길이 + 1 이다.
theorem insert_length (x : Nat) (l : List Nat) :
    (insert x l).length = l.length + 1 := by
  sorry
```

<details>
<summary>힌트 보기</summary>

`l`에 대한 귀납법(induction)을 사용한다. 기저 경우는 `l = []`이고, 귀납 단계는 `l = a :: as`이다. `if x <= a`인 경우와 아닌 경우를 나누어 분석한다.

</details>

---

## 14. 핵심 요약

| 알고리즘 | 핵심 아이디어 | 최악 복잡도 | Lean 4 핵심 패턴 |
|---------|-----------|---------|-------------|
| 최댓값 찾기 | 전진하며 기록 갱신 | O(n) | 재귀 + if |
| 선형 탐색 | 처음부터 끝까지 비교 | O(n) | 재귀 + Option |
| 이진 탐색 | 절반씩 범위 축소 | O(log n) | 재귀 + termination_by |
| 버블 정렬 | 인접 교환, 큰 것이 떠오름 | O(n²) | 이중 재귀 + swap |
| 삽입 정렬 | 올바른 위치에 삽입 | O(n²) | insert + 재귀 |
| 욕심쟁이 | 매 순간 최선 선택 | 문제마다 다름 | 재귀 + 나눗셈/나머지 |

---

*이 수업자료는 Rosen 이산수학 8판 3.1절을 기반으로, Lean 4 형식화와 단계별 연습을 통합하여 설계되었다.*
