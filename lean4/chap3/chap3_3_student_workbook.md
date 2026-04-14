# Chapter 3.3: 알고리즘의 복잡도 (Algorithm Complexity)
## 학생 워크북 (안내 노트)

Rosen 이산수학 8판 §3.3

> 각 `____` 한 칸 = 값 또는 전술 한 줄.

---

# I — 코드에서 시간복잡도 읽기

## 핵심 원칙

알고리즘의 시간복잡도는 **입력 크기 n**에 대한 **연산 횟수**를 빅오로 표현한 것이다.

### Q1. 다음 패턴과 복잡도를 연결하라

| 코드 패턴 | 시간복잡도 | 이유 |
|----------|-----------|------|
| 단일 `for i in range(n)` | **\_\_\_\_** | n번 반복 |
| 이중 `for i` / `for j in range(n)` | **\_\_\_\_** | n × n |
| `while i > 0: i = i // 2` | **\_\_\_\_** | 매번 절반으로 줄어듦 |
| `for i in range(n): for j in range(i)` | **\_\_\_\_** | 합 = n(n-1)/2 |
| 함수 호출 없는 단일 연산 | **\_\_\_\_** | 입력과 무관 |

### Q2. 다음 각 코드의 시간복잡도를 구하라

**(a)**
```python
for i in range(n):
    print(i)
```
복잡도: **\_\_\_\_**  이유: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

**(b)**
```python
for i in range(n):
    for j in range(n):
        print(i, j)
```
복잡도: **\_\_\_\_**  이유: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

**(c)**
```python
i = n
while i > 0:
    i = i // 2
```
복잡도: **\_\_\_\_**  이유: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

**(d)**
```python
for i in range(n):
    for j in range(i):
        print(i, j)
```
복잡도: **\_\_\_\_**  이유: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## (c)가 O(log n)인 이유 — 자세히

### Q3. 빈칸을 채워 추적 과정을 완성하라 (n = 16)

| 반복 횟수 | i 값 |
|----------|------|
| 0 | 16 |
| 1 | **\_\_\_\_** |
| 2 | **\_\_\_\_** |
| 3 | **\_\_\_\_** |
| 4 | **\_\_\_\_** |
| 5 | 0 → 종료 |

총 반복 횟수: **\_\_\_\_**,  log₂ 16 = **\_\_\_\_**

### Q4. 수식으로 유도 — 빈칸을 채워라

k번 반복 후 i의 값: $i_k = \dfrac{n}{2^k}$

루프 종료 조건: $\dfrac{n}{2^k} < 1$  →  $2^k >$ **\_\_\_\_**  →  $k >$ **\_\_\_\_**

따라서 반복 횟수 = **\_\_\_\_** = O(**\_\_\_\_**)

---

# II — Tractable vs Intractable

## 정의

| 용어 | 의미 |
|------|------|
| **Tractable** (다루기 쉬운) | **\_\_\_\_** 시간 O(nᵏ)에 풀리는 문제 |
| **Intractable** (다루기 어려운) | **\_\_\_\_** 시간 이상이 필요한 문제 |

### Q5. 다음 알고리즘을 Tractable / Intractable로 분류하라

| 알고리즘 | 복잡도 | 분류 |
|---------|--------|------|
| 이진 탐색 | O(log n) | **\_\_\_\_** |
| 병합 정렬 | O(n log n) | **\_\_\_\_** |
| 버블 정렬 | O(n²) | **\_\_\_\_** |
| 부분집합 열거 | O(2ⁿ) | **\_\_\_\_** |
| 순열 열거 | O(n!) | **\_\_\_\_** |

### Q6. 왜 지수 시간은 Intractable인가? — 표를 채워라

| n | O(n²) | O(2ⁿ) |
|---|-------|-------|
| 10 | 100 | **\_\_\_\_** |
| 50 | 2,500 | **\_\_\_\_** (약 10¹⁵) |
| 100 | 10,000 | **\_\_\_\_** (약 10³⁰) |
| 1,000 | 1,000,000 | **\_\_\_\_** (사실상 불가) |

---

# III — Python 복잡도 실험

### Q7. 다음 Python 코드의 빈칸을 채워라

```python
import time, random

def bubble_sort(lst):
    arr = lst[:]
    n = len(arr)
    for i in range(____(1)):          # (1) 패스 횟수
        for j in range(____(2)):      # (2) 매 패스 범위
            if arr[j] > arr[j + 1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

# 크기별 실행 시간 비교
for n in [100, 500, 1000, 5000]:
    arr = random.sample(range(n * 10), n)
    start = time.time()
    bubble_sort(arr)
    t_bubble = ____(3)                # (3) 경과 시간 계산
    start = time.time()
    sorted(arr)
    t_sorted = time.time() - start
    print(f"n={n}: bubble={t_bubble:.4f}s, sorted={t_sorted:.6f}s")
```

| 위치 | 빈칸 내용 |
|------|----------|
| (1) | **\_\_\_\_** |
| (2) | **\_\_\_\_** |
| (3) | **\_\_\_\_** |

### Q8. 실험 결과 예측 — 빈칸을 채워라

n이 2배가 될 때:
- O(n²) 알고리즘의 실행 시간은 약 **\_\_\_\_** 배가 된다.
- O(n log n) 알고리즘의 실행 시간은 약 **\_\_\_\_** 배가 된다.

---

# IV — 복잡도 계층 총정리

### Q9. 느린 순서대로 빈칸을 채워라

$$O(1) \lt O(\text{\_\_\_\_}) \lt O(\text{\_\_\_\_}) \lt O(\text{\_\_\_\_}) \lt O(\text{\_\_\_\_}) \lt O(2^n) \lt O(n!)$$

### Q10. 다음 탐색/정렬 알고리즘의 복잡도를 채워라

| 알고리즘 | 최선 | 평균 | 최악 |
|---------|------|------|------|
| 선형 탐색 | **\_\_\_\_** | O(n) | O(n) |
| 이진 탐색 | **\_\_\_\_** | O(log n) | O(log n) |
| 보간 탐색 | **\_\_\_\_** | O(log log n) | O(n) |
| 버블 정렬 | **\_\_\_\_** | O(n²) | O(n²) |
| 삽입 정렬 | **\_\_\_\_** | O(n²) | O(n²) |
| 병합 정렬 | **\_\_\_\_** | O(n log n) | O(n log n) |

---

# V — Lean 4: 복잡도 형식화

## contains 함수 — 선형 탐색

```lean4
import Mathlib

def contains (x : Nat) : List Nat → Bool
  | []      => false
  | a :: as => (a == x) || contains x as
```

### Q11. contains의 최악 시간복잡도가 O(n)인 이유를 설명하라

> \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

## isSorted 함수 — 정렬 확인

```lean4
def isSorted : List Nat → Bool
  | [] | [_]          => true
  | a :: b :: rest    => (a ≤ b) && isSorted (b :: rest)
```

### Q12. isSorted의 빈칸을 채워라

```lean4
-- isSorted는 리스트를 정확히 몇 번 순회하는가?
-- 따라서 시간복잡도는?

-- n = 리스트 길이
-- 순회 횟수: ____        -- (1)
-- 시간복잡도: O(____)    -- (2)
```

## Lean 4 rw 증명: contains의 기저 단계

```lean4
-- 빈 리스트에서 탐색하면 항상 false
theorem contains_nil (x : Nat) :
    contains x [] = false := by
  ____              -- (1) rfl로 정의 전개
```

### Q13. cons 단계 증명 — 빈칸을 채워라 (각 빈칸 = 전술 1줄)

```lean4
-- arr[0] = x이면 바로 성공
theorem contains_head (x : Nat) (t : List Nat) :
    contains x (x :: t) = true := by
  unfold contains
  -- 목표: (x == x) || contains x t = true
  rw [____]         -- (1) beq_self_eq_true: x == x = true
  -- 목표: true || contains x t = true
  rw [____]         -- (2) Bool.true_or
  -- 목표: true = true  →  rfl
```

---

# 부록 1: 빈칸 정답

## Q1 정답

| 코드 패턴 | 시간복잡도 |
|----------|-----------|
| 단일 for | O(n) |
| 이중 for (n×n) | O(n²) |
| while i = i//2 | O(log n) |
| for i / for j in range(i) | O(n²) |
| 단일 연산 | O(1) |

## Q2 정답

(a) O(n) — n번 출력  
(b) O(n²) — n × n번 출력  
(c) O(log n) — 매번 절반: 16→8→4→2→1→0, log₂ n번  
(d) O(n²) — j가 0~i-1이므로 합 = 0+1+2+...+(n-1) = n(n-1)/2

## Q3 정답

| 반복 | i |
|------|---|
| 1 | 8 |
| 2 | 4 |
| 3 | 2 |
| 4 | 1 |
| 5 | 0 |

총 5회, log₂ 16 = **4** (≈ 5회)

## Q4 정답

$2^k > n$  →  $k > \log_2 n$

따라서 반복 횟수 = ⌈log₂ n⌉ = **O(log n)**

## Q5 정답

| 알고리즘 | 분류 |
|---------|------|
| 이진 탐색 O(log n) | Tractable |
| 병합 정렬 O(n log n) | Tractable |
| 버블 정렬 O(n²) | Tractable |
| 부분집합 열거 O(2ⁿ) | **Intractable** |
| 순열 열거 O(n!) | **Intractable** |

## Q6 정답

| n | O(2ⁿ) |
|---|-------|
| 10 | 1,024 |
| 50 | 약 10¹⁵ |
| 100 | 약 10³⁰ |
| 1,000 | 10³⁰⁰ 이상 |

## Q7 정답

```python
for i in range(n - 1):          # (1) n-1번 패스
    for j in range(n - 1 - i):  # (2) 매 패스마다 범위 줄임
        ...
t_bubble = time.time() - start  # (3) 경과 시간
```

## Q8 정답

n이 2배 → O(n²)은 약 **4배**, O(n log n)은 약 **2배** 조금 넘게

## Q9 정답

$$O(1) \lt O(\log n) \lt O(n) \lt O(n \log n) \lt O(n^2) \lt O(2^n) \lt O(n!)$$

## Q10 정답

| 알고리즘 | 최선 |
|---------|------|
| 선형 탐색 | O(1) |
| 이진 탐색 | O(1) |
| 보간 탐색 | O(1) |
| 버블 정렬 | O(n) |
| 삽입 정렬 | O(n) |
| 병합 정렬 | O(n log n) |

## Q11 정답

리스트를 처음부터 끝까지 최악의 경우 한 번 순회한다. x가 맨 마지막에 있거나 없으면 n번 비교한다. 따라서 O(n)이다.

## Q12 정답

```
순회 횟수: n - 1      -- (1) 인접 쌍을 모두 비교
시간복잡도: O(n)      -- (2)
```

## Q13 정답

```lean4
theorem contains_head (x : Nat) (t : List Nat) :
    contains x (x :: t) = true := by
  unfold contains
  rw [beq_self_eq_true]   -- (1) x == x = true
  rw [Bool.true_or]       -- (2) true || _ = true
```

---

# 부록 2: 연습 문제

**문제 1.** 다음 코드의 시간복잡도를 구하고 이유를 설명하라.

```python
# (a)
i = 1
while i < n:
    i = i * 3

# (b)
for i in range(n):
    j = 1
    while j < n:
        j = j * 2

# (c)
for i in range(n):
    for j in range(n):
        for k in range(n):
            pass
```

<details>
<summary>정답 보기</summary>

(a) O(log₃ n) — i가 1, 3, 9, 27, ... 3ᵏ으로 증가. 3ᵏ ≥ n이 되면 종료. k ≥ log₃ n.

(b) O(n log n) — 외부 루프 O(n) × 내부 루프 O(log n).

(c) O(n³) — 삼중 루프, n × n × n.

</details>

---

**문제 2.** `i = i // 2` 대신 `i = i // 3`을 사용하면 복잡도는?

<details>
<summary>정답 보기</summary>

O(log₃ n)이다. 3ᵏ ≥ n이 되면 종료되므로 k ≥ log₃ n이다.

빅오 표기법에서 log의 밑은 상수 배수 차이이므로 O(log₃ n) = O(log n)이다.
log₃ n = log₂ n / log₂ 3 이고, 1/log₂ 3은 상수이기 때문이다.

</details>

---

**문제 3.** n = 1,000일 때 O(n log n)과 O(n²)의 연산 횟수를 계산하고 비율을 구하라.

<details>
<summary>정답 보기</summary>

O(n log n): 1,000 × log₂ 1,000 ≈ 1,000 × 10 = **10,000**

O(n²): 1,000 × 1,000 = **1,000,000**

비율: 1,000,000 / 10,000 = **100배** 차이.

n이 커질수록 이 격차는 더 벌어진다.

</details>

---

**문제 4.** Lean 4 코드의 빈칸을 채워 isSorted 기저 단계를 증명하라.

```lean4
-- 빈 리스트는 항상 정렬된 상태이다
theorem isSorted_nil : isSorted [] = true := by
  ____

-- 원소가 1개인 리스트는 항상 정렬된 상태이다
theorem isSorted_singleton (a : Nat) :
    isSorted [a] = true := by
  ____
```

<details>
<summary>정답 보기</summary>

```lean4
theorem isSorted_nil : isSorted [] = true := by
  rfl    -- 정의상 [] → true

theorem isSorted_singleton (a : Nat) :
    isSorted [a] = true := by
  rfl    -- 정의상 [_] → true
```

두 경우 모두 `isSorted`의 패턴 매칭 첫 번째 줄 `| [] | [_] => true`에 해당하므로 `rfl`로 바로 닫힌다.

</details>

---

**문제 5.** Tractable과 Intractable의 경계선이 왜 다항 시간(polynomial time)인지 설명하라.

<details>
<summary>정답 보기</summary>

다항 시간 O(nᵏ)은 n이 10배 증가할 때 실행 시간이 10ᵏ배 증가한다. k가 고정된 상수이므로 컴퓨터 성능이 향상되면 더 큰 입력을 처리할 수 있다.

반면 지수 시간 O(2ⁿ)은 n이 1 증가할 때마다 실행 시간이 2배가 된다. 컴퓨터가 1000배 빨라져도 처리 가능한 n은 약 10밖에 늘어나지 않는다.

다항 시간은 "규모 확장이 가능하다(scalable)"는 의미에서 실용적 경계선으로 채택되었다.

</details>
