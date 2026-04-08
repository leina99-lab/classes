# Chapter 3.3: 알고리즘의 복잡도(Complexity of Algorithms) — 학생용

> Rosen 이산수학 8판 3.3절 + Lean 4 형식화 + Python 실험  
> 학습 흐름: 복잡도 분석 → 복잡도 클래스 → P vs NP → Lean 4 + Python

---

## 1. 시간복잡도란 무엇인가?

알고리즘의 **시간복잡도**(time complexity)란, 입력 크기 n에 대한 **기본 연산의 횟수**를 함수로 표현한 것이다.

탐색과 정렬 알고리즘에서 기본 연산은 **비교 연산**이다. 모든 탐색/정렬 알고리즘의 핵심 작업이 "두 값 비교"이기 때문이다.

### 1.1 최악/최선/평균

- **최악**(worst case): 모든 입력 중 가장 오래 걸리는 경우
- **최선**(best case): 가장 빨리 끝나는 경우
- **평균**(average case): 모든 입력의 기대값

주로 **최악의 경우**를 분석한다. "최악의 경우에도 이 정도면 된다"는 **보장**을 주기 때문이다.

---

## 2. 3.1절 알고리즘의 복잡도 분석

### 2.1 선형 탐색: O(n)

$$T_{\text{linear}}(n) = n \quad \Longrightarrow \quad O(n)$$

- 최악: 원소가 없을 때 → n번 비교
- 최선: 첫 번째에서 발견 → 1번 비교
- 평균: (n+1)/2번

리스트가 정렬되어 있지 않으면, 어떤 알고리즘도 O(n)보다 빠를 수 없다.

### 2.2 이진 탐색: O(log n)

$$T_{\text{binary}}(n) = \lfloor \log_2 n \rfloor + 1 \quad \Longrightarrow \quad O(\log n)$$

매 단계마다 탐색 범위가 절반: n → n/2 → n/4 → ... → 1

k단계 후 n/2^k = 1이므로 k = log₂ n.

O(log n)은 "입력이 2배 되어도 비교 횟수가 1회만 증가"한다는 의미이다.

### 2.3 버블 정렬: Θ(n²)

$$T_{\text{bubble}}(n) = \frac{n(n-1)}{2} \quad \Longrightarrow \quad \Theta(n^2)$$

입력에 관계없이 항상 정확히 n(n−1)/2번 비교한다. 최선이든 최악이든 같다.

### 2.4 삽입 정렬: 최악 O(n²), 최선 O(n)

- **최악**: 역순 정렬 → n(n−1)/2 = O(n²)
- **최선**: 이미 정렬 → n−1 = O(n)

거의 정렬된 데이터에서는 삽입 정렬이 매우 빠르다.

### 2.5 행렬 곱셈: O(n³)

```python
def matrix_mult(A, B):
    n = len(A)
    C = [[0]*n for _ in range(n)]
    for i in range(n):        # n번
        for j in range(n):    # n번
            for k in range(n):# n번
                C[i][j] += A[i][k] * B[k][j]
    return C
# 3중 루프 → O(n) × O(n) × O(n) = O(n³)
```

### 2.6 복잡도 총정리표

| 알고리즘 | 최선 | 최악 | 평균 |
|---------|------|------|------|
| 선형 탐색 | O(1) | O(n) | O(n) |
| 이진 탐색 | O(1) | O(log n) | O(log n) |
| 버블 정렬 | Θ(n²) | Θ(n²) | Θ(n²) |
| 삽입 정렬 | O(n) | O(n²) | O(n²) |
| 행렬 곱셈 | O(n³) | O(n³) | O(n³) |

---

## 3. 다루기 쉬운 문제 vs 다루기 어려운 문제

### 3.1 Tractable (다루기 쉬운)

**다항 시간(polynomial time)** 알고리즘이 존재하는 문제. 즉, O(nᵏ) (k는 상수) 시간에 풀 수 있다.

예: 정렬 O(n log n), 탐색 O(log n), 최단 경로 O(n²), 행렬 곱셈 O(n³).

### 3.2 Intractable (다루기 어려운)

알려진 최선의 알고리즘이 **지수 시간(exponential time)**인 문제. O(2ⁿ), O(n!) 등.

$$\underbrace{O(1),\; O(\log n),\; O(n),\; O(n \log n),\; O(n^2),\; O(n^3)}_{\text{Tractable}} \quad \Big| \quad \underbrace{O(2^n),\; O(n!)}_{\text{Intractable}}$$

O(2ⁿ)일 때: n=20이면 약 100만(즉시), n=60이면 약 10¹⁸(수만 년), n=100이면 10³⁰(우주 수명 초과).

---

## 4. 복잡도 클래스: P와 NP

### 4.1 클래스 P

$$\mathbf{P} = \bigl\{\, L \;\big|\; \exists\;\text{deterministic TM deciding } L \text{ in } O(n^k) \,\bigr\}$$

"빠르게 **풀 수 있는**" 문제의 집합이다. 결정론적 튜링 기계가 다항 시간 O(nᵏ)에 풀 수 있는 결정 문제의 집합.

예: 정렬, 탐색, 최단 경로, 소수 판별(AKS), 오일러 회로.

### 4.2 클래스 NP

$$\mathbf{NP} = \bigl\{\, L \;\big|\; \exists\;\text{nondeterministic TM deciding } L \text{ in } O(n^k) \,\bigr\}$$

"빠르게 **검증할 수 있는**" 문제의 집합이다. 답이 주어지면 다항 시간에 검증 가능한 문제.

**스도쿠 비유:** 스도쿠를 푸는 것은 어렵다. 하지만 누군가 답을 보여주면 "맞는지 확인"은 빠르게 할 수 있다. 풀기는 어렵지만 검증은 쉬운 문제 = NP.

**주의:** NP는 "Not Polynomial"이 아니다. "**N**ondeterministic **P**olynomial"의 약자이다.

### 4.3 P ⊆ NP

P에 속하는 문제는 "풀 수 있다" → 당연히 "검증"도 가능하다. 따라서 P의 모든 문제는 NP에도 속한다.

하지만 역은? NP에 속하지만 P에 속하지 않는 문제가 있는가? → 이것이 P = NP? 문제이다.

### 4.4 NP-완전(NP-Complete)

NP에 속하면서, NP의 모든 문제를 다항 시간에 변환(reduction)할 수 있는 문제이다. NP에서 "가장 어려운" 문제들이다.

**핵심 성질:** NP-완전 문제 하나라도 다항 시간에 풀 수 있으면 → P = NP. 반대로, 하나라도 지수 시간에만 풀 수 있으면 → P ≠ NP.

대표적 NP-완전 문제: SAT, 외판원 문제(TSP), 해밀턴 경로, 그래프 색칠, 부분집합 합, 배낭 문제.

---

## 5. P = NP? — 밀레니엄 문제

$$\mathbf{P} \stackrel{?}{=} \mathbf{NP}$$

**만약 P = NP라면:** 모든 NP 문제를 효율적으로 풀 수 있다. 암호 체계 붕괴, 최적화 문제 즉시 해결, 수학 정리 자동 증명 가능.

**만약 P ≠ NP라면:** 효율적으로 풀 수 없는 문제가 본질적으로 존재한다. 현재 암호 체계 안전. 근사 알고리즘/휴리스틱 필요.

클레이 수학연구소 밀레니엄 문제 중 하나이다. 풀면 100만 달러 상금. 2026년 현재 미해결.

---

## 6. Lean 4: 복잡도의 형식화

```lean
-- 비교 횟수를 반환하는 함수
def linearSearchCount [BEq α] (x : α) : List α → Nat
  | []      => 0
  | a :: as =>
    if a == x then 1
    else 1 + linearSearchCount x as

-- 최악의 경우: 리스트 전체 순회
theorem linear_worst (x : Nat) (l : List Nat)
    (h : x ∉ l) :
    linearSearchCount x l = l.length := by
  induction l with
  | nil => simp [linearSearchCount]
  | cons a as ih =>
    simp [linearSearchCount]
    split
    · next heq => simp [heq] at h
    · next hne => exact ih (by tauto)
```

Lean 4로 알고리즘의 복잡도까지 **형식적으로 증명**할 수 있다.

---

## 7. Python: 복잡도 실험

```python
import time, random

def measure_time(sort_fn, n, trials=5):
    """정렬 함수의 평균 실행 시간 측정."""
    total = 0
    for _ in range(trials):
        arr = random.sample(range(n*10), n)
        start = time.time()
        sort_fn(arr)
        total += time.time() - start
    return total / trials

for n in [100, 500, 1000, 2000, 5000]:
    t_bubble = measure_time(bubble_sort, n)
    t_insert = measure_time(insertion_sort, n)
    t_builtin = measure_time(sorted, n)
    print(f'n={n:5d}: bubble={t_bubble:.4f}s'
          f' insert={t_insert:.4f}s'
          f' sorted={t_builtin:.6f}s')
```

직접 실행하여 O(n²)과 O(n log n)의 차이를 체감해 보라.

---

## 8. 연습 문제

### 연습 1: 복잡도 분류

다음 각 코드의 시간복잡도를 구하라.

```python
# (a)
for i in range(n):
    print(i)

# (b)
for i in range(n):
    for j in range(n):
        print(i, j)

# (c)
i = n
while i > 0:
    i = i // 2

# (d)
for i in range(n):
    for j in range(i):
        print(i, j)
```

<details>
<summary>정답 보기</summary>

(a) O(n) — 단일 루프, n번 반복
(b) O(n²) — 이중 루프, n × n
(c) O(log n) — 매번 절반으로 줄어듦
(d) O(n²) — j가 0~i-1이므로 합은 0+1+2+...+(n-1) = n(n−1)/2

</details>

### 연습 2: P / NP / NP-complete 분류

| 문제 | 분류 |
|------|------|
| 배열 정렬 | ? |
| 외판원 문제 (최적해) | ? |
| 소수 판별 | ? |
| 스도쿠 풀기 | ? |
| 그래프 연결 확인 | ? |

<details>
<summary>정답 보기</summary>

| 문제 | 분류 | 이유 |
|------|------|------|
| 배열 정렬 | P | O(n log n) 알고리즘 존재 |
| 외판원 문제 | NP-complete | 알려진 다항 시간 해법 없음 |
| 소수 판별 | P | AKS 알고리즘 (2002) |
| 스도쿠 풀기 | NP-complete | 검증은 O(n²)이나 풀기는 지수 시간 |
| 그래프 연결 확인 | P | BFS/DFS O(n+m) |

</details>

---

## 9. 핵심 요약

| 개념 | 의미 |
|------|------|
| 시간복잡도 | 입력 크기 n 대비 연산 횟수 |
| Tractable | 다항 시간 O(nᵏ)에 풀림 |
| Intractable | 지수 시간 O(2ⁿ) 이상 |
| P | 다항 시간에 풀 수 있는 문제 |
| NP | 다항 시간에 검증 가능한 문제 |
| NP-complete | NP에서 가장 어려운 문제 |
| P = NP? | 밀레니엄 문제, 2026년 현재 미해결 |

---

*이 수업자료는 Rosen 이산수학 8판 3.3절을 기반으로, Lean 4 형식화와 Python 실험을 통합하여 설계되었다.*
