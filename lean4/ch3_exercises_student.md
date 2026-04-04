# Chapter 3 종합 연습문제 — 학생용

> 3단계 구조: 빈칸 채우기 → sorry 완성 → 완전 자유 증명  
> 범위: 3.1 알고리즘 + 3.2 함수의 증가 + 3.3 복잡도

---

## Stage 1: 빈칸 채우기

> 핵심 개념을 코드의 빈칸으로 확인하는 단계이다.
> 각 빈칸에 들어갈 코드를 채워라.

---

### 문제 1-1. 최솟값 찾기 (Lean 4)

최댓값 찾기의 쌍둥이 문제이다. 방향만 반대.

```lean
def myMin : List Nat → Nat
  | []      => 0
  | [a]     => ___                    -- (a)
  | a :: as =>
    let m := ___                      -- (b)
    if ___ then a else m              -- (c)

#eval myMin [8, 4, 11, 3, 10]  -- 3
```

<details>
<summary>정답 보기</summary>

```lean
  | [a]     => a                      -- (a) 원소 하나면 그것이 최소
    let m := myMin as                 -- (b) 나머지의 최솟값
    if a ≤ m then a else m            -- (c) ≤ (myMax에서는 ≥)
```

myMax와 비교: `≥`가 `≤`로 바뀐 것뿐이다. 알고리즘의 구조는 동일하다.

</details>

---

### 문제 1-2. 최솟값 찾기 (Python)

```python
def my_min(lst):
    if not lst:
        return 0
    min_val = ___                     # (a)
    for i in range(1, len(lst)):
        if ___:                       # (b)
            min_val = lst[i]
    return ___                        # (c)

print(my_min([8, 4, 11, 3, 10]))  # 3
```

<details>
<summary>정답 보기</summary>

```python
    min_val = lst[0]                  # (a) 첫 원소를 min으로
        if lst[i] < min_val:          # (b) 더 작으면 갱신
    return min_val                    # (c) 최종 min 반환
```

</details>

---

### 문제 1-3. 리스트 뒤집기 (Lean 4)

```lean
def myReverse : List α → List α
  | []      => ___                    -- (a)
  | a :: as => ___ ++ ___             -- (b)

#eval myReverse [1, 2, 3, 4]  -- [4, 3, 2, 1]
```

<details>
<summary>정답 보기</summary>

```lean
  | []      => []                     -- (a) 빈 리스트의 뒤집기는 빈 리스트
  | a :: as => myReverse as ++ [a]    -- (b) 나머지를 뒤집고 + 첫 원소를 뒤에
```

</details>

---

### 문제 1-4. 리스트 뒤집기 (Python)

```python
def my_reverse(lst):
    result = []
    for x in lst:
        result = ___ + ___            # (a)
    return result

print(my_reverse([1, 2, 3, 4]))  # [4, 3, 2, 1]
```

<details>
<summary>정답 보기</summary>

```python
        result = [x] + result         # (a) 새 원소를 앞에 붙인다
```

</details>

---

### 문제 1-5. Big-O 증명 (Lean 4)

```lean
def BigO (f g : Nat → Nat) : Prop :=
  ∃ C : Nat, ∃ k : Nat, C > 0 ∧
    ∀ n : Nat, n > k → f n ≤ C * g n

-- 4n + 3 은 O(n)
theorem ex_4n3 : BigO (fun n => 4 * n + 3) (fun n => n) := by
  use ___, ___          -- (a) C와 k?
  constructor
  · ___                 -- (b) C > 0?
  · intro n hn
    ___                 -- (c) 부등식?
```

<details>
<summary>힌트 보기</summary>

4n + 3 ≤ Cn이 되려면 C는 최소 5 이상이어야 한다 (n > 3일 때 3 ≤ n이므로 4n + 3 ≤ 4n + n = 5n).

</details>

<details>
<summary>정답 보기</summary>

```lean
  use 5, 3              -- (a) C = 5, k = 3
  constructor
  · omega               -- (b) 5 > 0
  · intro n hn
    omega               -- (c) 4n + 3 ≤ 5n when n > 3
```

</details>

---

### 문제 1-6. 삽입 정렬의 insert (Lean 4)

Nat이 아닌 **Int**(정수)에 대해 insert를 구현하라.

```lean
def insertInt (x : Int) : List Int → List Int
  | []      => ___                           -- (a)
  | a :: as =>
    if ___ then ___                          -- (b)
    else a :: ___                            -- (c)

#eval insertInt (-3) [(-5), (-1), 2, 7]  -- [(-5), (-3), (-1), 2, 7]
```

<details>
<summary>정답 보기</summary>

```lean
  | []      => [x]                           -- (a)
    if x ≤ a then x :: a :: as               -- (b)
    else a :: insertInt x as                 -- (c)
```

Nat 버전과 동일하다. Lean 4에서 Int에도 `≤`가 정의되어 있기 때문이다.

</details>

---

### 문제 1-7. 시간복잡도 분류 (Python)

다음 각 함수의 시간복잡도를 구하라.

```python
# (a)
def f1(n):
    total = 0
    for i in range(n):
        for j in range(n):
            total += i * j
    return total

# (b)
def f2(n):
    i = 1
    while i < n:
        i *= 2
    return i

# (c)
def f3(n):
    total = 0
    for i in range(n):
        for j in range(i, n):
            total += 1
    return total

# (d)
def f4(n):
    if n <= 1:
        return 1
    return f4(n // 2) + f4(n // 2)
```

<details>
<summary>정답 보기</summary>

| 함수 | 복잡도 | 이유 |
|------|--------|------|
| f1 | O(n²) | 이중 루프, 각 n번 |
| f2 | O(log n) | i가 매번 2배 → log₂ n번 반복 |
| f3 | O(n²) | j가 i~n-1이므로 합은 n(n-1)/2 |
| f4 | O(n) | T(n) = 2T(n/2) + O(1), Master theorem으로 O(n) |

f4가 가장 까다롭다. 재귀가 2개 있지만, n이 매번 절반이므로 총 호출 수는 약 2n이다.

</details>

---

### 문제 1-8. P / NP 분류

다음 각 문제를 P, NP, NP-complete 중 하나로 분류하라.

| 번호 | 문제 | 분류 |
|------|------|------|
| (a) | 두 수의 최대공약수(GCD) 구하기 | ? |
| (b) | 해밀턴 경로 존재 여부 | ? |
| (c) | 배열에서 중복 원소 찾기 | ? |
| (d) | 부분집합의 합이 정확히 S인지 여부 | ? |
| (e) | 그래프에서 최단 경로 길이가 k 이하인지 여부 | ? |
| (f) | 그래프를 3가지 색으로 칠할 수 있는지 여부 | ? |

<details>
<summary>정답 보기</summary>

| 번호 | 문제 | 분류 | 이유 |
|------|------|------|------|
| (a) | GCD | **P** | 유클리드 호제법 O(log n) |
| (b) | 해밀턴 경로 | **NP-complete** | 알려진 다항 시간 해법 없음 |
| (c) | 중복 원소 | **P** | 정렬 후 인접 비교 O(n log n) |
| (d) | 부분집합 합 | **NP-complete** | 대표적 NP-완전 문제 |
| (e) | 최단 경로 ≤ k | **P** | Dijkstra O(n²) 또는 O(n log n) |
| (f) | 3-색칠 | **NP-complete** | 2-색칠은 P이지만 3-색칠은 NP-완전 |

(f)가 함정이다. 2가지 색은 BFS로 O(n+m)에 판별 가능하지만, 3가지 색부터는 NP-완전이 된다.

</details>

---

## Stage 2: sorry 완성

> Lean 4 증명의 뼈대가 주어진다. `sorry`를 실제 전술로 바꿔 증명을 완성하라.
> 각 문제에는 InfoView 힌트가 제공된다.

---

### 문제 2-1. myMax가 빈 리스트가 아니면 0보다 크다 (단순 사실)

```lean
-- myMax [a] = a 를 증명하라
theorem myMax_singleton (a : Nat) : myMax [a] = a := by
  sorry
```

<details>
<summary>힌트 보기</summary>

`myMax`의 정의를 펼치면 `[a]` 패턴에 의해 바로 `a`가 된다. `rfl` 또는 `simp [myMax]`로 해결 가능하다.

</details>

<details>
<summary>정답 보기</summary>

```lean
theorem myMax_singleton (a : Nat) : myMax [a] = a := by
  rfl
```

`myMax [a] = a`는 정의에 의해 자명하다. `rfl`(reflexivity)로 끝.

</details>

---

### 문제 2-2. insert의 길이 보존

```lean
-- insert x l 의 길이는 l의 길이 + 1
theorem insert_length (x : Nat) (l : List Nat) :
    (insert x l).length = l.length + 1 := by
  sorry
```

<details>
<summary>힌트 보기</summary>

`l`에 대한 귀납법(`induction l with`)을 사용한다. 기저 경우(`nil`)는 정의를 펼치면 된다. 귀납 단계(`cons a as ih`)에서는 `if x ≤ a` 여부에 따라 경우를 나눈다(`split`). 각 경우에서 `simp [insert, ih]` 또는 `omega`로 마무리한다.

</details>

<details>
<summary>정답 보기</summary>

```lean
theorem insert_length (x : Nat) (l : List Nat) :
    (insert x l).length = l.length + 1 := by
  induction l with
  | nil => simp [insert]
  | cons a as ih =>
    simp [insert]
    split
    · simp
    · simp [ih]
```

</details>

---

### 문제 2-3. insertionSort가 길이를 보존한다

```lean
-- insertionSort l 의 길이 = l의 길이
theorem insertionSort_length (l : List Nat) :
    (insertionSort l).length = l.length := by
  sorry
```

<details>
<summary>힌트 보기</summary>

`l`에 대한 귀납법을 사용한다. 귀납 단계에서 `insert_length` (문제 2-2)를 사용한다. `simp [insertionSort, insert_length, ih]`로 시도해 보라.

</details>

<details>
<summary>정답 보기</summary>

```lean
theorem insertionSort_length (l : List Nat) :
    (insertionSort l).length = l.length := by
  induction l with
  | nil => simp [insertionSort]
  | cons a as ih =>
    simp [insertionSort, insert_length, ih]
```

</details>

---

### 문제 2-4. Big-O의 상수 곱 보존

```lean
-- f가 O(g)이면, c*f도 O(g)이다 (c > 0)
theorem bigO_const_mult (c : Nat) (hc : c > 0)
    (h : BigO f g) :
    BigO (fun n => c * f n) g := by
  sorry
```

<details>
<summary>힌트 보기</summary>

`h`에서 `C, k`를 꺼낸다(`obtain ⟨C, k, hC, hf⟩ := h`). 새 상수는 `c * C`이다. `use c * C, k`. 그리고 `nlinarith`로 부등식을 마무리한다.

</details>

<details>
<summary>정답 보기</summary>

```lean
theorem bigO_const_mult (c : Nat) (hc : c > 0)
    (h : BigO f g) :
    BigO (fun n => c * f n) g := by
  obtain ⟨C, k, hC, hf⟩ := h
  use c * C, k
  constructor
  · positivity
  · intro n hn
    have := hf n hn
    nlinarith
```

`positivity`는 `c * C > 0`을 자동으로 증명한다 (`c > 0`이고 `C > 0`이므로).

</details>

---

### 문제 2-5. Big-O의 전이성 (Transitivity)

```lean
-- f가 O(g)이고 g가 O(h)이면, f는 O(h)이다
theorem bigO_trans (h1 : BigO f g) (h2 : BigO g h) :
    BigO f h := by
  sorry
```

<details>
<summary>힌트 보기</summary>

h1에서 C1, k1을, h2에서 C2, k2를 꺼낸다. 새 상수 C = C1 * C2, k = max(k1, k2). `f n ≤ C1 * g n ≤ C1 * (C2 * h n) = (C1*C2) * h n`. nlinarith로 마무리.

</details>

<details>
<summary>정답 보기</summary>

```lean
theorem bigO_trans (h1 : BigO f g) (h2 : BigO g h) :
    BigO f h := by
  obtain ⟨C1, k1, hC1, hf⟩ := h1
  obtain ⟨C2, k2, hC2, hg⟩ := h2
  use C1 * C2, max k1 k2
  constructor
  · positivity
  · intro n hn
    have h1 := hf n (by omega)
    have h2 := hg n (by omega)
    nlinarith
```

</details>

---

### 문제 2-6. 리스트 합의 상한

```lean
-- listSum l ≤ myMax l * l.length
-- (모든 원소가 최댓값 이하이므로, 합은 최댓값 × 길이 이하)
theorem listSum_le_max_times_length (l : List Nat) :
    listSum l ≤ myMax l * l.length := by
  sorry
```

<details>
<summary>힌트 보기</summary>

이 문제는 어렵다. l에 대한 귀납법을 사용하되, 보조 보조정리 "l의 모든 원소 ≤ myMax l"이 필요할 수 있다. 아직 증명하지 못해도 괜찮다 — 구조를 이해하는 것이 목표이다.

</details>

---

## Stage 3: 완전 자유 증명

> 정리문(theorem statement)만 주어진다. 증명을 처음부터 끝까지 직접 작성하라.

---

### 문제 3-1. myReverse의 길이 보존

```lean
theorem myReverse_length (l : List α) :
    (myReverse l).length = l.length := by
  sorry
```

---

### 문제 3-2. 이중 뒤집기는 원래와 같다

```lean
-- myReverse (myReverse l) = l
theorem myReverse_involution (l : List α) :
    myReverse (myReverse l) = l := by
  sorry
```

---

### 문제 3-3. contains와 linearSearch의 관계

```lean
-- contains x l = true ↔ linearSearch x l ≠ none
theorem contains_iff_search [BEq α] [LawfulBEq α]
    (x : α) (l : List α) :
    contains x l = true ↔ linearSearch x l ≠ none := by
  sorry
```

---

### 문제 3-4. Big-O: 로그는 선형보다 느리다

```lean
-- 이 정리는 쉽지 않다. 도전 문제이다.
-- Nat.log 2 n ≤ n (자연수에서)
-- Hint: Nat.log_le_self_of_pos 사용 가능
theorem log_le_linear :
    BigO (fun n => Nat.log 2 n) (fun n => n) := by
  sorry
```

---

### 문제 3-5. insertionSort이 정렬된 결과를 반환한다

```lean
-- 정렬됨의 정의
def Sorted : List Nat → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a ≤ b ∧ Sorted (b :: rest)

-- 도전: insertionSort의 결과는 항상 정렬되어 있다
theorem insertionSort_sorted (l : List Nat) :
    Sorted (insertionSort l) := by
  sorry
```

---

## Stage 4: Python 실전 문제

> Python으로 알고리즘을 구현하고 실험하는 문제이다.

---

### 문제 4-1. 비교 횟수를 세는 정렬 함수

버블 정렬과 삽입 정렬에서 **비교 횟수**를 직접 세는 함수를 작성하라.

```python
def bubble_sort_count(lst):
    """버블 정렬 실행 후 (정렬된 리스트, 비교 횟수)를 반환."""
    arr = lst[:]
    count = 0
    # 여기에 코드를 작성하라.
    # 비교할 때마다 count += 1
    return arr, count

def insertion_sort_count(lst):
    """삽입 정렬 실행 후 (정렬된 리스트, 비교 횟수)를 반환."""
    arr = lst[:]
    count = 0
    # 여기에 코드를 작성하라.
    return arr, count

# 테스트
import random
for n in [10, 50, 100, 500]:
    test = random.sample(range(1000), n)
    _, bc = bubble_sort_count(test)
    _, ic = insertion_sort_count(test)
    print(f"n={n:4d}: bubble={bc:6d}, insertion={ic:6d}, ratio={bc/ic:.2f}")
```

<details>
<summary>정답 보기</summary>

```python
def bubble_sort_count(lst):
    arr = lst[:]
    count = 0
    n = len(arr)
    for i in range(n - 1):
        for j in range(n - 1 - i):
            count += 1                    # 비교 1회
            if arr[j] > arr[j + 1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr, count

def insertion_sort_count(lst):
    arr = lst[:]
    count = 0
    for j in range(1, len(arr)):
        key = arr[j]
        i = j - 1
        while i >= 0:
            count += 1                    # 비교 1회
            if arr[i] > key:
                arr[i + 1] = arr[i]
                i -= 1
            else:
                break
        arr[i + 1] = key
    return arr, count
```

예상 결과: 버블 정렬은 항상 n(n-1)/2번이지만, 삽입 정렬은 평균적으로 더 적다. n=100일 때 버블 약 4,950회, 삽입 약 2,500회 정도.

</details>

---

### 문제 4-2. 이진 탐색의 재귀 깊이 측정

이진 탐색에서 **재귀 깊이**(비교 횟수)를 세는 함수를 작성하라.

```python
def binary_search_depth(arr, x):
    """이진 탐색 실행 후 (인덱스 또는 -1, 비교 횟수)를 반환."""
    # 여기에 코드를 작성하라.
    pass

# 테스트: n이 2배 될 때 비교 횟수가 1씩 증가하는지 확인
for k in range(5, 21):
    n = 2 ** k
    arr = list(range(n))
    _, depth = binary_search_depth(arr, -1)  # 최악: 없는 값
    print(f"n=2^{k:2d}={n:7d}: depth={depth:3d}, log2(n)={k}")
```

<details>
<summary>정답 보기</summary>

```python
def binary_search_depth(arr, x):
    lo, hi = 0, len(arr) - 1
    depth = 0
    while lo <= hi:
        depth += 1
        mid = (lo + hi) // 2
        if arr[mid] == x:
            return mid, depth
        elif arr[mid] < x:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1, depth
```

출력에서 depth와 log₂(n)이 정확히 일치하는 것을 확인할 수 있다.

</details>

---

### 문제 4-3. 욕심쟁이의 실패 사례 탐지

주어진 동전 체계에서 욕심쟁이 알고리즘이 **최적이 아닌 경우**를 찾는 프로그램을 작성하라.

```python
def greedy_change(coins, amount):
    """욕심쟁이 거스름돈. 동전 개수를 반환."""
    count = 0
    for c in coins:
        count += amount // c
        amount %= c
    return count

def brute_force_change(coins, amount):
    """동적 프로그래밍으로 최소 동전 개수를 반환."""
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    for i in range(1, amount + 1):
        for c in coins:
            if c <= i and dp[i - c] + 1 < dp[i]:
                dp[i] = dp[i - c] + 1
    return dp[amount]

# 동전 체계: [1, 3, 4]
coins = [4, 3, 1]
for amount in range(1, 20):
    g = greedy_change(coins, amount)
    b = brute_force_change([4, 3, 1], amount)
    marker = " <-- GREEDY FAILS!" if g > b else ""
    print(f"amount={amount:2d}: greedy={g}, optimal={b}{marker}")
```

<details>
<summary>정답 보기</summary>

실행하면 amount=6에서 greedy=3(4+1+1), optimal=2(3+3)로 욕심쟁이가 실패하는 것을 확인할 수 있다.

핵심 교훈: 동전 체계가 "정규(canonical)"가 아니면 욕심쟁이가 실패한다. 한국 동전(10,50,100,500)은 정규 체계이므로 욕심쟁이가 항상 최적이다.

</details>

---

### 문제 4-4. O(n²) vs O(n log n) 실전 비교

```python
import time, random

def bubble_sort(lst):
    arr = lst[:]
    n = len(arr)
    for i in range(n-1):
        for j in range(n-1-i):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr

# 크기별 실행 시간을 측정하고 표를 출력하라.
# sorted() (O(n log n))와 bubble_sort (O(n²))를 비교하라.
# n = [100, 500, 1000, 2000, 5000, 10000]으로 테스트하라.
# 각 크기에서 n이 2배 될 때 실행 시간이 몇 배 되는지 출력하라.
```

<details>
<summary>정답 보기</summary>

```python
import time, random

results = {}
for n in [100, 500, 1000, 2000, 5000, 10000]:
    arr = random.sample(range(n * 10), n)

    start = time.time()
    bubble_sort(arr)
    t_bubble = time.time() - start

    start = time.time()
    sorted(arr)
    t_sorted = time.time() - start

    results[n] = (t_bubble, t_sorted)
    ratio = t_bubble / t_sorted if t_sorted > 0 else float('inf')
    print(f"n={n:6d}: bubble={t_bubble:.4f}s, "
          f"sorted={t_sorted:.6f}s, ratio={ratio:.0f}x")
```

예상 결과: n=10000일 때 bubble은 약 5초, sorted는 약 0.003초. **약 1,500배** 차이. n이 커질수록 차이가 극적으로 벌어진다.

</details>

---

## Stage 5: 개념 확인 (서술형)

---

### 문제 5-1. 알고리즘의 7가지 속성

다음 프로그램이 알고리즘의 7가지 속성 중 어떤 것을 위반하는가? 이유를 설명하라.

```python
def mystery(n):
    while n != 1:
        if n % 2 == 0:
            n = n // 2
        else:
            n = 3 * n + 1
    return n
```

<details>
<summary>정답 보기</summary>

이것은 유명한 **콜라츠 추측**(Collatz conjecture)이다. 모든 양의 정수 n에 대해 이 프로그램이 반드시 멈추는지(유한성)는 아직 증명되지 않았다. 2026년 현재 미해결 문제이다.

따라서 이 프로그램은 **유한성**(finiteness)을 위반할 **수도** 있다 — 우리는 아직 모른다.

참고: Lean 4에서 이 함수를 정의하면 `termination_by` 증명을 요구하는데, 현재 수학으로는 그 증명을 작성할 수 없다.

</details>

---

### 문제 5-2. → 와 ↔ 의 실생활 예

다음 각 명제가 → (이면)인지, ↔ (필요충분)인지 판별하고, 역이 성립하지 않는 경우 반례를 들어라.

| 명제 | → 또는 ↔ |
|------|---------|
| (a) "비가 오면 우산을 쓴다" | ? |
| (b) "삼각형의 내각의 합이 180°이다" ↔ "유클리드 평면 위의 삼각형이다" | ? |
| (c) "x² = 4이면 x = 2이다" | ? |
| (d) "n이 4의 배수이면 n은 짝수이다" | ? |

<details>
<summary>정답 보기</summary>

| 명제 | 판별 | 이유 |
|------|------|------|
| (a) | → | 역: "우산을 쓰면 비가 온다" → 거짓 (햇볕을 피하려 쓸 수도) |
| (b) | ↔ | 양방향 모두 성립 (유클리드 기하학의 정리) |
| (c) | → 만, ↔ 아님 | 역: "x=2이면 x²=4" → 참. 하지만 원래 명제가 거짓! x=-2일 수도. 즉 → 조차 아님 |
| (d) | → 만, ↔ 아님 | 역: "짝수이면 4의 배수" → 거짓 (반례: n=6) |

(c)가 함정이다. "x²=4이면 x=2"는 거짓이다 (x=-2). 따라서 → 조차 성립하지 않는다.

</details>

---

### 문제 5-3. 정지 문제와 귀류법

정지 문제의 증명에서 프로그램 K를 다음과 같이 정의했다:

```
K(P) = if H(P, P) = "멈춤" then 무한루프
       else 멈춤
```

K(K)를 실행했을 때 모순이 발생하는 과정을 **자신의 말로** 설명하라. (슬라이드의 내용을 그대로 옮기지 말고, 자신이 이해한 대로 적어라.)

---

### 문제 5-4. NP-완전의 의미

"외판원 문제(TSP)가 NP-완전이다"라는 것이 왜 중요한지, 다음 관점에서 각각 설명하라.

(a) 만약 누군가 TSP의 다항 시간 알고리즘을 발견한다면?
(b) 만약 TSP에 다항 시간 알고리즘이 존재하지 않음을 증명한다면?
(c) 현실에서 TSP를 풀어야 할 때 어떤 접근법을 사용하는가?

<details>
<summary>정답 보기</summary>

(a) TSP의 다항 시간 알고리즘이 발견되면, NP-완전의 정의에 의해 **모든 NP 문제**가 다항 시간에 풀 수 있다. 즉 **P = NP**가 증명된다. 암호 체계 붕괴 등 혁명적 결과가 따른다.

(b) TSP에 다항 시간 알고리즘이 없음을 증명하면 **P ≠ NP**가 증명된다. 밀레니엄 문제 해결 + 100만 달러 상금.

(c) 현실에서는 **근사 알고리즘**(최적에 가까운 답을 빠르게 찾음), **휴리스틱**(경험 기반 탐색), **메타 휴리스틱**(유전 알고리즘, 담금질 기법 등)을 사용한다. 최적해를 포기하고 "충분히 좋은 해"를 추구하는 것이다.

</details>

---

