# 4주차 — **넘파이**(NumPy)와 **판다스**(Pandas) 핵심

## 세션 A: **이론 강의**(Theory Lecture) + **가이드 실습**(Guided Practice)

---

## 학습 목표

1. **넘파이**(NumPy)의 배열 연산과 **벡터화**(Vectorization)의 원리를 이해한다.
2. **판다스**(Pandas)의 **데이터프레임**(DataFrame)과 **시리즈**(Series) 개념을 익힌다.
3. CSV 파일을 불러오고 기본 탐색 메서드를 사용하여 데이터 구조를 파악한다.
4. **브로드캐스팅**(Broadcasting)의 원리를 이해하고 활용한다.

---

## 활용 데이터

**뉴욕 에어비앤비**(Airbnb NYC 2019) — Kaggle `AB_NYC_2019.csv`

| 항목 | 내용 |
|---|---|
| 행(rows) | 약 48,895개 |
| 열(columns) | 16개 (`id`, `name`, `host_name`, `neighbourhood_group`, `price`, `room_type` 등) |
| 출처 | Kaggle — New York City Airbnb Open Data |

---

# PART 1: **이론 강의**

---

## 1. 왜 **넘파이**(NumPy)인가? — `for`문의 한계

### 1.1 **속도 비교:** for문 vs NumPy

PART 1(1-3주)에서는 for문으로 모든 계산을 수행하였다. 그러나 데이터가 수만-수백만 행이 되면 for문은 너무 느리다.

```python
import numpy as np
import time

# 100만 개의 데이터
data = list(range(1_000_000))
arr = np.array(data)

# for문: 각 요소에 2를 곱하기
start = time.time()
result_for = [x * 2 for x in data]
time_for = time.time() - start

# NumPy: 배열 전체에 2를 곱하기
start = time.time()
result_np = arr * 2
time_np = time.time() - start

print(f"for문: {time_for:.4f}초")
print(f"NumPy: {time_np:.4f}초")
print(f"NumPy가 약 {time_for/time_np:.0f}배 빠름!")
```

```
시각화: for문 vs NumPy 연산 방식

for문 (하나씩 순서대로):
  [1] → ×2 → [2]
  [2] → ×2 → [4]
  [3] → ×2 → [6]
  ...한 번에 하나씩, 100만 번 반복

NumPy (한꺼번에 벡터 연산):
  [1, 2, 3, ..., 1000000]
          ↓ × 2 (한 번에!)
  [2, 4, 6, ..., 2000000]
```

> **핵심:** NumPy는 C언어로 최적화된 내부 연산을 사용하므로, 파이썬 for문보다 **50~100배 이상 빠르다.**

### 1.2 **벡터화 연산**(Vectorized Operation)

for문을 사용하지 않고, **배열 전체에 한꺼번에** 연산을 적용하는 것을 **벡터화 연산**이라 한다. 이것이 NumPy의 핵심 철학이다.

```python
a = np.array([1, 2, 3, 4, 5])

# 벡터화 연산 예시
print(a + 10)       # [11, 12, 13, 14, 15]
print(a * 2)         # [ 2,  4,  6,  8, 10]
print(a ** 2)        # [ 1,  4,  9, 16, 25]
print(a > 3)         # [False, False, False, True, True]
print(a[a > 3])      # [4, 5] — 불리언 인덱싱
```

---

## 2. **넘파이**(NumPy) 핵심 개념

### 2.1 `ndarray` — N차원 배열

NumPy의 기본 자료형은 **`ndarray`**(N-dimensional Array)이다.

```python
# 1차원 배열
a = np.array([1, 2, 3, 4, 5])
print(a.shape)      # (5,)
print(a.ndim)       # 1

# 2차원 배열 (행렬)
b = np.array([[1, 2, 3],
              [4, 5, 6]])
print(b.shape)      # (2, 3) — 2행 3열
print(b.ndim)       # 2
```

```
시각화: 1차원 vs 2차원 배열

1차원 (벡터):           2차원 (행렬):
┌───┬───┬───┬───┬───┐   ┌───┬───┬───┐
│ 1 │ 2 │ 3 │ 4 │ 5 │   │ 1 │ 2 │ 3 │ ← 행(row) 0
└───┴───┴───┴───┴───┘   ├───┼───┼───┤
  shape: (5,)            │ 4 │ 5 │ 6 │ ← 행(row) 1
                         └───┴───┴───┘
                           ↑   ↑   ↑
                          열0  열1  열2
                         shape: (2, 3)
```

### 2.2 배열 생성 함수

| 함수 | 설명 | 예시 |
|---|---|---|
| `np.array()` | 리스트 → 배열 변환 | `np.array([1,2,3])` |
| `np.zeros(shape)` | 0으로 채운 배열 | `np.zeros((3,4))` |
| `np.ones(shape)` | 1로 채운 배열 | `np.ones((2,3))` |
| `np.arange(start, stop, step)` | 범위 배열 | `np.arange(0, 10, 2)` |
| `np.linspace(start, stop, n)` | 균등 분할 | `np.linspace(0, 1, 5)` |
| `np.random.rand(shape)` | 0~1 난수 | `np.random.rand(3,3)` |
| `np.random.randint(low, high, size)` | 정수 난수 | `np.random.randint(1, 100, 10)` |

### 2.3 **인덱싱**(Indexing)과 **슬라이싱**(Slicing)

```python
a = np.array([10, 20, 30, 40, 50])

# 기본 인덱싱/슬라이싱 — 리스트와 동일
print(a[0])       # 10
print(a[1:4])     # [20, 30, 40]

# 불리언 인덱싱 — NumPy만의 강력한 기능!
print(a > 25)          # [False, False, True, True, True]
print(a[a > 25])       # [30, 40, 50]

# 팬시 인덱싱 — 인덱스 배열로 접근
idx = [0, 2, 4]
print(a[idx])          # [10, 30, 50]
```

### 2.4 **브로드캐스팅**(Broadcasting)

크기가 다른 배열 간에도 연산이 가능하도록, 작은 배열을 자동으로 확장하는 기능이다.

```python
a = np.array([[1, 2, 3],
              [4, 5, 6]])    # (2, 3)

b = np.array([10, 20, 30])   # (3,)

print(a + b)
# [[11, 22, 33],
#  [14, 25, 36]]
```

```
시각화: 브로드캐스팅 과정

  a (2×3):          b (1×3):             결과 (2×3):
  ┌───┬───┬───┐    ┌────┬────┬────┐     ┌────┬────┬────┐
  │ 1 │ 2 │ 3 │ +  │ 10 │ 20 │ 30 │  =  │ 11 │ 22 │ 33 │
  ├───┼───┼───┤    ├────┼────┼────┤     ├────┼────┼────┤
  │ 4 │ 5 │ 6 │    │ 10 │ 20 │ 30 │     │ 14 │ 25 │ 36 │
  └───┴───┴───┘    └────┴────┴────┘     └────┴────┴────┘
                    ↑ 자동으로 복제!
```

### 2.5 주요 통계 함수

```python
a = np.array([523, 681, 445, 892, 1023, 756, 634])

print(np.mean(a))     # 707.71  — 평균
print(np.median(a))   # 681.0   — 중앙값
print(np.std(a))      # 183.67  — 표준편차
print(np.var(a))      # 33733.9 — 분산
print(np.min(a))      # 445     — 최솟값
print(np.max(a))      # 1023    — 최댓값
print(np.sum(a))      # 4954    — 합계
print(np.argmax(a))   # 4       — 최댓값의 인덱스
```

---

## 3. **판다스**(Pandas) 핵심 개념

### 3.1 왜 **판다스**(Pandas)인가?

NumPy는 숫자 배열에 특화되어 있지만, 실제 데이터는 "이름", "지역", "날짜" 등 다양한 타입이 섞여 있다. **판다스**는 이러한 혼합 데이터를 표(Table) 형태로 다루는 도구이다.

> 비유: NumPy가 "계산기"라면, Pandas는 "엑셀"이다.

### 3.2 **시리즈**(Series)와 **데이터프레임**(DataFrame)

```
시각화: Series vs DataFrame

Series (1차원):           DataFrame (2차원 — 표):
┌───────┐                 ┌──────┬────────┬───────┐
│  523  │ ← index 0      │ 이름 │  지역   │ 가격  │
│  681  │ ← index 1      ├──────┼────────┼───────┤
│  445  │ ← index 2      │ 숙소A│ 맨해튼  │  150  │
│  892  │ ← index 3      │ 숙소B│ 브루클린│   80  │
└───────┘                 │ 숙소C│ 퀸즈    │   60  │
                          └──────┴────────┴───────┘
  하나의 열                  여러 열 = 여러 Series
```

```python
import pandas as pd

# Series 생성
s = pd.Series([523, 681, 445, 892], name="확진자")
print(s)

# DataFrame 생성
data = {
    "이름": ["숙소A", "숙소B", "숙소C"],
    "지역": ["Manhattan", "Brooklyn", "Queens"],
    "가격": [150, 80, 60]
}
df = pd.DataFrame(data)
print(df)
```

### 3.3 CSV 파일 불러오기

```python
# CSV 불러오기
df = pd.read_csv("AB_NYC_2019.csv")

# 기본 탐색 메서드
df.head()         # 처음 5행
df.tail()         # 마지막 5행
df.shape          # (행 수, 열 수)
df.info()         # 열별 타입, 결측값 수
df.describe()     # 숫자 열의 기술 통계
df.columns        # 열 이름 목록
df.dtypes         # 열별 데이터 타입
```

### 3.4 **데이터 선택**(Selection)

```python
# 열 선택
df["price"]                # 단일 열 → Series
df[["price", "room_type"]] # 복수 열 → DataFrame

# 행 선택
df.iloc[0]         # 인덱스 번호로 (첫 행)
df.iloc[0:5]       # 슬라이싱 (0~4행)
df.loc[0]          # 라벨로

# 조건 필터링 — NumPy의 불리언 인덱싱과 동일!
expensive = df[df["price"] > 500]
manhattan = df[df["neighbourhood_group"] == "Manhattan"]

# 복합 조건
cheap_manhattan = df[(df["price"] < 100) & (df["neighbourhood_group"] == "Manhattan")]
```

### 3.5 주요 **집계**(Aggregation) 메서드

```python
df["price"].mean()       # 평균
df["price"].median()     # 중앙값
df["price"].std()        # 표준편차
df["price"].min()        # 최솟값
df["price"].max()        # 최댓값
df["price"].value_counts()   # 값별 빈도

# 그룹별 집계 — groupby
df.groupby("neighbourhood_group")["price"].mean()
df.groupby("room_type")["price"].median()
```

### 3.6 **결측값**(Missing Value) 처리

```python
# 결측값 확인
df.isnull().sum()

# 결측값 제거
df_clean = df.dropna(subset=["name", "host_name"])

# 결측값 채우기
df["reviews_per_month"] = df["reviews_per_month"].fillna(0)
```

---

# PART 2: **가이드 실습**

---

## 실습 1: **넘파이**(NumPy) 기초

아래 코드를 직접 실행하며 결과를 확인하라.

```python
import numpy as np

# 1) 배열 생성
a = np.array([10, 20, 30, 40, 50])
print("배열:", a)
print("형태:", a.shape)
print("타입:", a.dtype)

# 2) 벡터화 연산
print("\na + 5 =", a + 5)
print("a * 2 =", a * 2)
print("a > 25:", a > 25)
print("25 초과:", a[a > 25])

# 3) 통계 함수
print(f"\n평균: {np.mean(a)}")
print(f"표준편차: {np.std(a):.2f}")
print(f"최댓값 인덱스: {np.argmax(a)}")

# 4) 2차원 배열
matrix = np.array([[1, 2, 3],
                    [4, 5, 6],
                    [7, 8, 9]])
print(f"\n행렬:\n{matrix}")
print(f"행 합계: {matrix.sum(axis=1)}")     # [6, 15, 24]
print(f"열 평균: {matrix.mean(axis=0)}")    # [4, 5, 6]

# 5) 브로드캐스팅
row = np.array([100, 200, 300])
print(f"\n브로드캐스팅:\n{matrix + row}")
```

---

## 실습 2: **판다스**(Pandas) 기초 — 에어비앤비 데이터 탐색

```python
import pandas as pd

# 1) CSV 불러오기
df = pd.read_csv("AB_NYC_2019.csv")

# 2) 기본 탐색
print("형태:", df.shape)
print("\n처음 5행:")
print(df.head())

print("\n열 정보:")
print(df.info())

print("\n기술 통계:")
print(df.describe())

# 3) 결측값 확인
print("\n결측값:")
print(df.isnull().sum())

# 4) 가격 분포 기초 통계
print(f"\n=== 가격 통계 ===")
print(f"  평균: ${df['price'].mean():.2f}")
print(f"  중앙값: ${df['price'].median():.2f}")
print(f"  최소: ${df['price'].min()}")
print(f"  최대: ${df['price'].max()}")

# 5) 지역별 매물 수
print("\n지역별 매물 수:")
print(df["neighbourhood_group"].value_counts())

# 6) 방 유형별 매물 수
print("\n방 유형별:")
print(df["room_type"].value_counts())
```

---

## 핵심 요약

| 도구 | 역할 | 핵심 기능 |
|---|---|---|
| **넘파이**(NumPy) | 수치 배열 연산 | 벡터화 연산, 브로드캐스팅, 통계 함수 |
| **판다스**(Pandas) | 표 형태 데이터 처리 | DataFrame, CSV 입출력, 필터링, groupby |

| 이것을 하려면 | 파이썬 for문 | NumPy/Pandas |
|---|---|---|
| 100만 개 요소에 2 곱하기 | `[x*2 for x in data]` | `arr * 2` |
| 조건 필터링 | `[x for x in data if x > 500]` | `arr[arr > 500]` |
| 그룹별 평균 | 직접 딕셔너리+for문 | `df.groupby("col").mean()` |

---

*다음 세션(세션 B)에서는 에어비앤비 데이터로 **"적정 숙박료"** 를 분석하는 프로젝트 실습을 진행한다.*
