# 1부 학생 워크북 — 데이터 마이닝과 pandas 복습

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 1장 데이터 로딩과 첫 탐색

### 핵심 개념 채우기

**1.** `df.shape`은 `(행 개수, 열 개수)` 형식의 ____________________을 반환한다. 머신러닝 용어로 행은 ____________________, 열은 ____________________다.

**2.** `df.info()`에서 `Non-Null Count`는 ____________________의 개수이고, `Dtype` 중 `object`는 ____________________형 변수를 의미한다.

**3.** `Year Built`는 `int64`이지만 `Garage Yr Blt`가 `float64`인 까닭은 후자에 ____________________가 있기 때문이다. `NaN`은 ____________________형 전용이라 정수 컬럼에 결측 한 칸만 들어와도 `float64`로 바뀐다.

### 코드 빈칸 채우기

```python
import pandas as pd
import numpy as np

URL = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/AmesHousing.csv"

try:
    df = pd.____(URL)
except ____:
    raise RuntimeError("로딩 실패")

print(f"행: {df.____[0]:,}개")
print(f"열: {df.shape[____]:,}개")
df.____(10)        # 처음 10행
df.____(5)         # 마지막 5행
df.____()          # 전체 요약
df.____()          # 수치형 요약 통계
```

---

## 2장 변수 타입의 두 세계

### 핵심 개념 채우기

**1.** Ames 데이터의 82개 컬럼은 수치형 ____개, 범주형 ____개로 나뉜다.

**2.** `MS SubClass`는 숫자로 표기되지만 의미상 ____________________형 변수다. 60이 20의 3배가 아니라 *코드일 뿐*이기 때문에, 모델에 넣기 전 ____________________ 메서드로 문자열 변환해야 한다.

**3.** 원-핫 인코딩에서 한 행의 *정확히 ____개* 컬럼만 1이고 나머지는 모두 0이다. 이를 ____________________ 단위벡터라고 부른다.

### 코드 빈칸 채우기

```python
# 수치형만 추출
num_df = df.select_dtypes(include=____________________)

# 범주형만 추출
cat_df = df.select_dtypes(include=____________________)

# 컬럼 이름 리스트로 변환
num_cols = num_df.____________________.tolist()
```

---

## 3장 타깃 SalePrice의 분포

### 핵심 개념 채우기

**1.** ____________________(skewness)는 분포의 비대칭 정도를 한 숫자로 요약한다. 0이면 좌우 대칭, 양수면 ____________________ 꼬리가 길고, 음수면 ____________________ 꼬리가 길다.

**2.** Ames `SalePrice`의 왜도는 약 ____________________로 오른쪽으로 쏠려 있다. `np.log1p`를 적용하면 왜도가 약 ____________________까지 떨어져 거의 종 모양이 된다.

**3.** 캐글 House Prices 대회는 *log(SalePrice)*의 ____________________(RMSE)를 평가 지표로 사용한다. 이는 비싼 집의 큰 절대오차와 싼 집의 작은 절대오차를 *같은 비율 오차*로 다루기 위해서다.

**4.** 신경망의 ____________________(Batch Normalization)도 같은 동기에서 만들어졌다 — 각 층의 출력 분포를 안정화하면 학습이 잘 된다는 직관이다.

### 코드 빈칸 채우기

```python
# 왜도 계산
skew_before = df["SalePrice"].____()

# log1p 변환
log_price = np.____(df["SalePrice"])
skew_after = log_price.skew()

# 변동계수
cv = df["SalePrice"].____() / df["SalePrice"].____()
```

---

## 4장 결측치 — 함정과 의미

### 핵심 개념 채우기

**1.** Ames의 `Pool QC`는 99.6%가 결측이지만 *데이터 오류가 아니다*. 이는 "수영장 없음"을 NA로 표기한 ____________________ 결측이다. 단순 `dropna`를 적용하면 *2,930행 중 ____________________행을 잃는다*.

**2.** 반면 `Lot Frontage`의 16.7% 결측은 ____________________ 누락으로, 측정이 안 됐을 뿐이다. 이쪽은 ____________________이나 평균으로 채워야 한다.

**3.** 의미 있는 결측은 ____________________ 문자열로 채워 *별도 카테고리*가 되도록 한다. 진짜 누락은 ____________________ 메서드의 단일 인자로 처리한다.

**4.** sklearn 파이프라인에서 같은 일을 하는 도구는 ____________________ 클래스다.

### 코드 빈칸 채우기

```python
# 컬럼별 결측 개수 (0 제외, 내림차순)
miss = df.____().____()
miss = miss[miss > 0].____(ascending=False)

# 결측 비율 (%)
miss_pct = (miss / ____(df) * 100).round(1)

# 의미 있는 결측을 'None'으로
df["Pool QC"] = df["Pool QC"].____("None")

# 진짜 누락을 중앙값으로
median_lf = df["Lot Frontage"].____()
df["Lot Frontage"] = df["Lot Frontage"].____(median_lf)
```

---

## 5장 범주형 변수의 다양한 얼굴

### 핵심 개념 채우기

**1.** `value_counts()`는 *각 범주가 몇 번 등장하는지*를 ____________________ 순으로 정렬한 Series를 반환한다.

**2.** `idxmax()`는 ____________________을 반환하고, `mode()`는 *가장 자주 등장하는 값*을 반환한다.

**3.** 원-핫 인코딩에서 `drop_first=True`로 두면 각 변수당 컬럼이 ____개 줄어들어 ____________________ 다중공선성을 피할 수 있다. 트리 모델에서는 영향이 없지만 ____________________ 모델에서는 중요하다.

**4.** 범주가 많은 변수일수록 원-핫 후 컬럼이 *기하급수적으로* 늘어나며, 이를 ____________________ 저주(curse of dimensionality)라고 부른다. 딥러닝에서는 ____________________ 레이어(embedding layer)로 해결한다.

### 코드 빈칸 채우기

```python
# 가장 흔한 범주
top = df["Neighborhood"].____().____()

# 원-핫 인코딩
df_encoded = pd.____(df, columns=cat_cols, drop_first=____)

# nunique: 고유값 개수
n_cats = df["Neighborhood"].____()
```

---

## 6장 변수 간 관계와 상관계수

### 핵심 개념 채우기

**1.** Pearson 상관계수는 ____와 ____ 사이의 값을 가지며, 1에 가까울수록 ____________________ 선형 관계, -1에 가까울수록 ____________________ 선형 관계, 0에 가까울수록 *선형 관계가 없음*을 의미한다.

**2.** `Garage Cars`와 `Garage Area`의 상관계수는 약 ____________________로, 둘이 *사촌처럼 닮은 변수*임을 보여 준다. 이는 회귀에서 ____________________ 문제를 일으킨다.

**3.** Ames의 `Gr Liv Area` vs `SalePrice` 산점도에서 *거실 면적 ____________________ sq ft 이상*의 4건은 데이터셋 원작자가 명시적으로 제거를 권한 *유명한 이상치*다.

**4.** 부스팅이 이상치에 민감한 이유는, 첫 트리가 큰 잔차를 본 다음 두 번째 트리가 그 ____________________에 집중해 *극단값에만 맞춘 분할*을 만들기 때문이다.

### 코드 빈칸 채우기

```python
# 전체 상관계수 행렬 (수치형만)
corr = df.select_dtypes(include="number").____()

# 타깃과의 상관계수만 추출
target_corr = corr["SalePrice"].____("SalePrice").____.____(ascending=False)

# 이상치 제거
df_clean = df[df["Gr Liv Area"] < ____].copy()
```

---

## 7장 `groupby`로 집단별 패턴 발견하기

### 핵심 개념 채우기

**1.** `groupby` 다음에 오는 `transform("median")`은 *그룹 통계*를 ____________________ 길이로 펼쳐 반환한다. 반면 `agg("median")`이나 그냥 `.median()`은 ____________________ 길이의 결과를 준다.

**2.** Ames에서 가장 비싼 동네는 ____________________(평균 30만 달러 이상)이고, 가장 싼 동네는 ____________________다. *같은 도시에서 동네에 따라 평균 가격이 ____________________배 차이*가 난다.

**3.** `Overall Qual`이 9에서 10으로 한 단계 오를 때 평균 가격은 약 ____________________배가 된다. 이런 ____________________ 관계는 선형회귀가 잡지 못하고 트리가 빛을 발하는 영역이다.

### 코드 빈칸 채우기

```python
# 동네별 평균/중앙값/개수
result = (df.____("Neighborhood")["SalePrice"]
          .____(["mean", "median", "count"])
          .sort_values("median", ascending=False))

# 동네별 중앙값으로 결측 채우기
nbhd_median = df.groupby("Neighborhood")["Lot Frontage"].____("median")
df["Lot Frontage"] = df["Lot Frontage"].____(nbhd_median)

# 두 변수로 groupby + 교차표
cross = df.groupby(["Neighborhood", "Overall Qual"])["SalePrice"].mean().____()
```

---

## 8장 특성공학 — 새 변수 만들기

### 핵심 개념 채우기

**1.** Ames에서 면적 변수가 흩어져 있는 까닭은 *건물 구조의 분해 표현*이기 때문이다. 1층(`1st Flr SF`) + 2층(`2nd Flr SF`) + 지하실(`Total Bsmt SF`)을 합한 ____________________ 변수는 `Gr Liv Area`보다 더 강한 상관계수를 보인다.

**2.** 트리는 두 변수의 합을 *자동으로 학습하지 못한다*. `if A>a AND B>b AND C>c` 같은 분할 ____________________개를 거쳐야 비슷한 효과를 내므로, *미리 합쳐 주는 것이* 트리에게 한 분할로 끝낼 기회를 준다.

**3.** 비율 변수(예: 방당 면적)는 *비선형 ____________________ 작용*을 선형 형태로 변환한 결과다. 신경망이 자동 학습하는 패턴을 *손으로 짚어 주는* 작업이 곧 특성공학이다.

**4.** `clip(lower=0)`은 0보다 작은 값을 모두 0으로 자른다. Ames에는 *건축 연도가 매매 연도보다 뒤*인 ____________________ 1건이 있어 이 처리가 필요하다.

### 코드 빈칸 채우기

```python
# 총면적
df["Total SF"] = df["1st Flr SF"] + df["2nd Flr SF"] + df["____________________"]

# 주택 연령 (음수 방지)
df["House Age"] = (df["Yr Sold"] - df["Year Built"]).____(lower=0)

# 비율 변수
df["SF Per Room"] = df["Gr Liv Area"] ____ df["TotRms AbvGrd"]

# 조건부 비율 (0 나눗셈 방지)
df["Garage Density"] = np.____(
    df["Garage Area"] > 0,
    df["Garage Cars"] / df["Garage Area"] * 100,
    0
)
```

---

## 종합 점검 — 1부 도구표 채우기

| 도구 | 용도 | 빈칸 |
|---|---|---|
| `shape` | 데이터 구조 | 행 개수, ____ 개수 |
| `describe` | 수치형 요약 | 평균-중앙값 간격으로 ____________________ 감지 |
| `select_dtypes` | 타입 분리 | 수치 ____ + 범주 ____ |
| `log1p` | 분포 정규화 | 왜도 1.74 → ____________________ |
| `isna().sum()` | 결측 진단 | Pool QC ____________________% 결측 |
| `fillna("None")` | 의미 있는 결측 | "수영장 없음"을 ____________________로 |
| `value_counts` | 범주 분포 | 동네 ____개, 희소 범주 식별 |
| `get_dummies` | 원-핫 인코딩 | 82 → ____________________여 컬럼 |
| `corr` | 상관계수 | Overall Qual r = ____________________이 최강 |
| `groupby` + `transform` | 집단 통계 | ____________________별 중앙값으로 결측 채우기 |
| 산점도 + 이상치 | 관계의 깨짐 | 거실 ____________________ sq ft 이상치 4건 |
| 특성공학 | 새 변수 생성 | Total SF, House Age, ____________________ |

---

## 정답 모음 (자기 채점용)

<details><summary>▶ 1장 정답</summary>

**1.** 튜플 / 샘플 / 피처 &nbsp;&nbsp; **2.** 비결측 값 / 문자열(범주) &nbsp;&nbsp; **3.** 결측 / 실수

코드: `read_csv` / `Exception` / `shape` / `1` / `head` / `tail` / `info` / `describe`
</details>

<details><summary>▶ 2장 정답</summary>

**1.** 39 / 43 &nbsp;&nbsp; **2.** 범주 / `astype(str)` &nbsp;&nbsp; **3.** 1 / 직교

코드: `"number"` / `"object"` / `columns`
</details>

<details><summary>▶ 3장 정답</summary>

**1.** 왜도 / 오른쪽 / 왼쪽 &nbsp;&nbsp; **2.** 1.74 / 0.12 &nbsp;&nbsp; **3.** 평균 제곱근 오차 &nbsp;&nbsp; **4.** 배치 정규화

코드: `skew` / `log1p` / `std` / `mean`
</details>

<details><summary>▶ 4장 정답</summary>

**1.** 구조적(structural) / 2,917 &nbsp;&nbsp; **2.** 진짜(random) / 중앙값 &nbsp;&nbsp; **3.** `"None"` / `fillna` &nbsp;&nbsp; **4.** `SimpleImputer`

코드: `isna()` / `sum()` / `sort_values` / `len` / `fillna` / `median` / `fillna`
</details>

<details><summary>▶ 5장 정답</summary>

**1.** 내림차순(빈도) &nbsp;&nbsp; **2.** 최댓값의 인덱스 &nbsp;&nbsp; **3.** 1 / 완벽한 / 선형 &nbsp;&nbsp; **4.** 차원의 / 임베딩

코드: `value_counts` / `idxmax` / `get_dummies` / `True` / `nunique`
</details>

<details><summary>▶ 6장 정답</summary>

**1.** -1 / +1 / 강한 양의 / 강한 음의 &nbsp;&nbsp; **2.** 0.89 / 다중공선성 &nbsp;&nbsp; **3.** 4,000 &nbsp;&nbsp; **4.** 잔차

코드: `corr` / `drop` / `abs` / `sort_values` / `4000`
</details>

<details><summary>▶ 7장 정답</summary>

**1.** 원본 / 그룹 수 &nbsp;&nbsp; **2.** NoRidge·NridgHt·StoneBr / MeadowV·IDOTRR / 3 &nbsp;&nbsp; **3.** 1.5 / 비선형

코드: `groupby` / `agg` / `transform` / `fillna` / `unstack`
</details>

<details><summary>▶ 8장 정답</summary>

**1.** Total SF (총면적) &nbsp;&nbsp; **2.** 3 &nbsp;&nbsp; **3.** 상호 &nbsp;&nbsp; **4.** 데이터 오류

코드: `Total Bsmt SF` / `clip` / `/` / `where`
</details>

<details><summary>▶ 종합표 정답</summary>

열 / 비대칭 / 39 / 43 / 0.12 / 99.6 / 카테고리 / 28 / 280 / 0.80 / 동네 / 4000 / Total Bath
</details>
