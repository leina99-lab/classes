# 1부 데이터 마이닝과 pandas 복습

## 쉬운 버전 — 그림으로 이해하기

본 자료는 머신러닝 모델링에 들어가기 전 **데이터를 다루는 도구**인 pandas와 **데이터 마이닝의 핵심 개념**을 그림 중심으로 풀어쓴 입문 교재이다. 복잡한 수식이나 알고리즘 없이도 **데이터를 어떻게 준비하는지** 따라갈 수 있다.

본 부는 두 데이터셋을 **페어**(pair)로 사용한다.

| 데이터셋 | 역할 | 특성 |
|---|---|---|
| Ames (2,930 × 82) | 강사 시범 | 큰 부동산 데이터, 회귀 문제 |
| Cereals (77 × 16) | 학생 실습 | 작은 식품 영양 데이터, 회귀 문제 |

같은 기법을 **두 데이터셋에 적용**하면서 pandas의 **보편성**을 익힌다.

```python
# 환경 준비 (한 번만 실행)
# !pip install pandas numpy matplotlib scikit-learn koreanize-matplotlib

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import koreanize_matplotlib

URL_AMES   = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/AmesHousing.csv"
URL_CEREAL = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/Cereals.csv"

ames   = pd.read_csv(URL_AMES)
cereal = pd.read_csv(URL_CEREAL)
print(f"Ames:    {ames.shape}")
print(f"Cereals: {cereal.shape}")
```

---

## 0장 데이터 마이닝의 정신 — 모델 학습 전의 80%

### 0.1 데이터 과학자는 80%의 시간을 데이터 준비에 쓴다

업계에서 자주 듣는 격언 — **데이터 과학자는 80%의 시간을 데이터 준비에 쓰고 20%만 모델 학습에 쓴다**. 과장이 아니다.

이유는 단순하다. **모델은 입력 데이터의 품질을 넘어설 수 없다**. 결측치가 잘못 채워진 데이터, 이상치가 그대로 남은 데이터, 범주형이 잘못 인코딩된 데이터에 **아무리 정교한 모델**을 적용해도 결과는 평범하다. 반대로 **잘 다듬은 데이터**에 **단순한 선형회귀**를 적용해도 의외로 좋은 결과가 나온다.

1부에서 다루는 모든 기법은 **3부 이후의 모델링**을 위한 토대다. 트리·랜덤 포레스트·부스팅 같은 강력한 모델들도 **데이터가 잘 준비되어 있어야** 성능을 낸다.

### 0.2 데이터 마이닝의 8개 영역

본 부는 데이터 마이닝의 핵심 영역을 8개 장으로 나눠 다룬다.

| 장 | 영역 | 핵심 도구 |
|---|---|---|
| 1장 | 데이터 로딩과 첫 탐색 | `read_csv`, `info`, `describe` |
| 2장 | 변수 타입의 두 세계 | 수치형 vs 범주형 |
| 3장 | 결측치와 이상치 | `fillna`, IQR 규칙 |
| 4장 | 시각화 | 4종 그래프 |
| 5장 | 변수 변환 | 로그·표준화 |
| 6장 | 범주형 인코딩 | 라벨·원-핫 |
| 7장 | 그룹별 집계 | `groupby` |
| 8장 | 특성 공학 | 새 변수 만들기 |

### 0.3 두 데이터셋 한눈에 보기

![01 dataframe structure](figs/01_dataframe_structure.png)

<sub>그림 0-1. 1부에서 사용할 두 데이터셋. 둘 다 pandas DataFrame이며, 각 행은 한 *샘플*(주택 한 채 또는 시리얼 한 종류), 각 열은 한 *변수*다.</sub>

**Ames 데이터**는 2010년에 발표된 미국 아이오와주 Ames 시의 주택 거래 데이터다. 2,930채의 주택에 82개의 변수가 들어 있다. 머신러닝 학습에서 **부동산 데이터의 표준**이 되어 시리즈 3~5부에서 계속 사용된다.

**Cereals 데이터**는 1993년 **Consumer Reports**에서 수집한 77종 시리얼의 영양 정보다. 16개 변수로 **칼로리·단백질·지방·설탕·섬유** 같은 영양 성분과 시리얼의 **종합 평점**이 들어 있다. 작지만 **모든 데이터 마이닝 기법을 적용해 보기에 충분**한 데이터셋이다.

두 데이터셋의 **대조**가 1부의 학습 전략이다. **크기와 도메인이 완전히 다른 두 데이터**에 같은 기법을 적용하며 **pandas 기법의 보편성**을 익힌다.

---

## 1장 데이터 로딩과 첫 탐색

### 1.1 pandas의 두 주인공

pandas의 모든 작업은 두 자료구조 위에서 이루어진다.

- **Series**: 1차원 배열. 한 열이 곧 Series다.
- **DataFrame**: 2차원 표. 여러 Series가 한 묶음.

DataFrame은 **엑셀 시트와 거의 같은 모양**인데, **프로그래밍 가능**하다는 점이 다르다. 필터링·변환·계산·시각화를 **한 줄 코드**로 할 수 있다.

### 1.2 데이터 받기 — read_csv

CSV 파일은 가장 흔한 데이터 형식이다. `pd.read_csv`가 URL이나 로컬 파일을 받아 DataFrame으로 만들어 준다.

```python
URL = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/AmesHousing.csv"

try:
    ames = pd.read_csv(URL)
    print(f"로딩 성공: {ames.shape}")
except Exception as e:
    print(f"로딩 실패: {e}")
```

`try-except`로 **네트워크 실패에 대비**하는 게 좋은 습관이다.

### 1.3 첫 탐색 5종 세트

데이터를 받은 직후 **반드시** 해야 할 5가지 점검이 있다.

```python
print(ames.shape)           # (행 수, 열 수)
print(ames.head(3))         # 처음 3행
print(ames.tail(3))         # 마지막 3행
print(ames.info())          # 각 열의 타입과 결측치
print(ames.describe())      # 수치형 열의 요약 통계
```

각 메서드가 **서로 다른 정보**를 준다.

| 메서드 | 답하는 질문 |
|---|---|
| `shape` | 행이 몇 개, 열이 몇 개? |
| `head` | 데이터가 **어떻게 생겼나**? |
| `tail` | 끝부분에 **이상한 게** 있나? |
| `info` | 각 열의 **타입과 결측**은? |
| `describe` | **수치형 열**의 평균·중앙값·사분위수는? |

이 5가지를 **순서대로** 실행하면 **데이터의 그림**이 머릿속에 그려진다.

### 1.4 자주 만나는 함정 두 가지

**함정 1: 공백 있는 열 이름**. Ames의 `Overall Qual`, `Gr Liv Area`는 **공백이 들어 있다**. 점 접근(`df.Overall Qual`)은 **문법 오류**가 나므로 **항상 대괄호 접근**을 쓴다.

```python
# 공백 없는 열: 점 접근 가능 (그러나 권장 안 함)
print(cereal.calories.head())   # OK

# 공백 있는 열: 대괄호 접근만 가능
print(ames["Overall Qual"].head())   # OK
```

**함정 2: 정수 열이 float로 변함**. pandas의 `int64`는 **결측치를 표현할 수 없다**. 결측이 하나라도 있으면 **자동으로 `float64`로 변환**된다.

```python
print(ames["Year Built"].dtype)        # int64 (결측 없음)
print(ames["Garage Yr Blt"].dtype)     # float64 (결측 있음)
```

**NaN은 float 전용**이라는 점만 기억해 두면 **왜 정수 데이터가 소수점으로 보이는지** 자연스럽게 이해된다.

---

## 2장 변수 타입의 두 세계 — 수치형과 범주형

![02 variable types](figs/02_variable_types.png)

<sub>그림 2-1. 변수 타입의 두 세계. 왼쪽 calories는 수치형으로 값의 크기에 의미가 있고 히스토그램이 자연스럽다. 오른쪽 mfr(제조사 코드)은 범주형으로 값이 라벨이며 막대그래프로 빈도를 본다.</sub>

### 2.1 두 세계의 근본 차이

pandas의 모든 변수는 **근본적으로 두 세계**로 나뉜다.

**수치형**(numerical). 값의 **크기**에 의미가 있다. 키 180cm가 170cm보다 10cm 크다는 사실이 명확하다. 평균·표준편차 같은 통계량이 자연스럽다.

**범주형**(categorical). 값은 **라벨**이며, 크기는 무의미하다. 시리얼 제조사 'K'와 'N'은 **다른 회사**일 뿐 **K가 N보다 작다**는 의미가 없다. 평균을 계산할 수도 없다.

두 세계의 **처리 방식이 완전히 다르다**. 수치형은 그대로 모델에 넣을 수 있지만, 범주형은 **인코딩**(6장에서 다룸) 과정을 거쳐야 한다.

### 2.2 pandas의 타입 시스템

pandas 변수의 타입은 `dtypes`로 확인한다.

```python
print(ames.dtypes.value_counts())
# float64    38
# object     43  ← 범주형 (문자열)
# int64       1
```

Ames에서 **수치형이 39개, 범주형(object)이 43개**다. 두 세계가 거의 반반이다.

### 2.3 타입별 열 추출

`select_dtypes`로 한 세계의 열만 따로 가져올 수 있다.

```python
# 수치형만
num_cols = ames.select_dtypes(include="number").columns

# 범주형(문자열)만
cat_cols = ames.select_dtypes(include="object").columns

print(f"수치형: {len(num_cols)}개")
print(f"범주형: {len(cat_cols)}개")
```

### 2.4 위장된 범주형의 함정

가장 위험한 함정 하나. Ames의 `MS SubClass`는 **숫자로 저장**되어 있지만(`int64`), 의미상으로는 **주택 유형의 코드**다.

```python
print(ames["MS SubClass"].unique()[:10])
# [20, 60, 70, 50, 190, 45, ...]
```

값이 정수처럼 보이지만, **60이 20의 3배가 아니다**. 둘 다 **라벨**일 뿐이다. 60은 **2층 새 집**, 20은 **1층 새 집** 같은 **코드 의미**다.

이런 **위장된 범주형**을 수치형으로 다루면 모델이 **60 = 20 × 3**이라는 **없는 관계**를 학습한다. 해결책은 명시적 변환이다.

```python
ames["MS SubClass"] = ames["MS SubClass"].astype(str)
print(ames["MS SubClass"].dtype)             # object (정확히 처리됨)
```

이제 6장의 원-핫 인코딩으로 **안전하게** 처리할 수 있다.

---

## 3장 결측치와 이상치 — 데이터 마이닝의 두 함정

![03 missing outliers](figs/03_missing_outliers.png)

<sub>그림 3-1. 결측치와 이상치 — 데이터 마이닝의 두 함정. 왼쪽은 Ames의 결측치 상위 10개 컬럼, 오른쪽은 거실 면적의 상자그림으로 본 이상치(4000 초과).</sub>

### 3.1 결측치 세 가지 종류

결측치에는 **세 가지 종류**가 있다.

**(a) 진짜 결측**. 측정 실패·기록 누락 등으로 **값이 없는** 경우. Cereals의 `carbo`, `sugars`, `potass` 같은 결측이 여기 해당한다. **중앙값 등으로 채우면 된다**.

**(b) 의미 있는 결측**. **값이 없는 것 자체가 정보**. Ames의 `Pool QC`(수영장 품질)에 결측이 있으면 **수영장이 없는 집**이라는 뜻이다. **"None"이라는 라벨로 채워야** 한다.

**(c) 변환된 결측**. 데이터 수집 과정에서 **0이나 -999 같은 코드**로 결측을 표현한 경우. **도메인 지식이 없으면 못 찾는다**.

### 3.2 결측치 처리 코드

```python
# 의미 있는 결측을 "None"으로
none_cols = ["Pool QC", "Misc Feature", "Alley", "Fence", "Fireplace Qu",
             "Garage Qual", "Garage Cond", "Bsmt Qual", "Bsmt Cond"]
for c in none_cols:
    if c in ames.columns:
        ames[c] = ames[c].fillna("None")

# 수치형 진짜 결측은 중앙값으로
num_cols = ames.select_dtypes("number").columns
ames[num_cols] = ames[num_cols].fillna(ames[num_cols].median())

print(f"남은 결측: {ames.isnull().sum().sum()}")  # 거의 0
```

**중앙값을 쓰는 이유**는 **평균보다 이상치에 강건**하기 때문이다. 큰 이상치 하나가 평균을 끌어올리지만 중앙값은 거의 안 변한다.

### 3.3 이상치 — IQR 규칙

이상치는 **나머지 데이터와 너무 동떨어진 값**이다. 가장 흔한 **통계적 탐지 규칙**이 **IQR 규칙**이다.

IQR(Inter-Quartile Range)은 25% 지점($Q_1$)과 75% 지점($Q_3$) 사이의 **폭**이다. 이상치는 다음 범위 바깥의 값이다.

> **이상치 = $Q_1$에서 1.5 IQR 아래보다 작거나, $Q_3$에서 1.5 IQR 위보다 큰 값**

상자그림(boxplot)에서 점으로 표시되는 **극단값**이 바로 이상치다.

### 3.4 도메인 지식 컷오프 — Ames의 4000 규칙

IQR 규칙은 **통계적**이지만, **도메인 지식**이 있다면 **더 정확한 컷오프**를 정할 수 있다. Ames 데이터에는 유명한 권장 컷오프가 있다.

> **거주 면적(Gr Liv Area)이 4000 sq ft를 초과하는 5채는 모두 비정상 거래다.**

데이터 발표자 Dean De Cock 본인이 **논문에서 명시**했다. 이 5채는 **부자 집안의 비공개 거래**나 **시장의 비정상 거래**로, **일반 가격 모델**에 들어가면 안 된다.

```python
print(f"제거 전: {len(ames)}행")
ames = ames[ames["Gr Liv Area"] < 4000].copy()
print(f"제거 후: {len(ames)}행")    # 5채 감소
```

**도메인 지식의 컷오프가 통계 규칙보다 정확**한 경우가 많다. **데이터를 잘 아는 사람의 조언**은 항상 중요하다.

---

## 4장 시각화 — 데이터를 눈으로 보기

### 4.1 EDA의 네 가지 질문

시각화는 **데이터를 빠르게 이해하기 위한 도구**다. 데이터 분석 초반에 **네 가지 질문**에 답한다.

| 질문 | 시각화 종류 |
|---|---|
| 한 변수의 **분포 모양**은? | 히스토그램 |
| 두 변수의 **관계**는? | 산점도 |
| **그룹별로** 어떻게 다른가? | 박스플롯 |
| **여러 변수** 사이의 관계는? | 히트맵 |

이 네 가지가 **데이터 탐색(EDA)의 핵심 도구**다.

![04 visualization quartet](figs/04_visualization_quartet.png)

<sub>그림 4-1. 데이터 시각화 4종. (1) 히스토그램은 한 변수의 분포 모양을 본다. (2) 산점도는 두 변수의 관계를 본다. (3) 그룹별 박스플롯은 범주에 따른 분포 차이를 본다. (4) 히트맵은 다변수 상관관계를 본다.</sub>

### 4.2 히스토그램 — 한 변수의 분포

가장 기본적인 시각화다. 한 변수의 **분포 모양**을 본다.

```python
fig, ax = plt.subplots(figsize=(8, 5))
ax.hist(ames["SalePrice"] / 1000, bins=50, color="#1F3A5F", alpha=0.7, edgecolor="white")
ax.set_xlabel("SalePrice ($1000)")
ax.set_ylabel("빈도")
plt.show()
```

분포의 모양에서 **세 가지 신호**를 읽는다.

- **오른쪽 꼬리**: 작은 값에 모이고 큰 값으로 꼬리. 가격·소득에 흔하다. **로그 변환** 후보다.
- **이봉**(봉우리 두 개): **숨겨진 그룹**이 있을 가능성.
- **이상치**: 분포의 **극단에 떨어진** 점들.

### 4.3 산점도 — 두 변수의 관계

두 **수치형 변수**의 관계를 본다.

```python
ax.scatter(ames["Gr Liv Area"], ames["SalePrice"] / 1000, c="#1F3A5F", s=8, alpha=0.4)
```

산점도에서 읽는 신호.

- **선형 관계**: 점들이 직선을 따라 늘어남
- **곡선 관계**: 점들이 곡선을 그림
- **이상치**: 패턴에서 벗어난 점들

### 4.4 그룹별 박스플롯 — 범주에 따른 분포

`Overall Qual` 같은 **범주형 변수**에 따라 `SalePrice` 같은 **수치형 변수**가 어떻게 다른지 본다.

```python
import seaborn as sns
sns.boxplot(data=ames, x="Overall Qual", y="SalePrice")
```

품질 등급이 올라갈수록 가격이 **체계적으로** 오른다. **품질 등급이 좋은 예측 변수**임을 한 눈에 확인.

### 4.5 히트맵 — 다변수 상관관계

여러 **수치형 변수** 사이의 상관계수를 한 표로 본다.

```python
import seaborn as sns
corr = cereal[["calories", "protein", "fat", "sugars", "fiber", "rating"]].corr()
sns.heatmap(corr, annot=True, cmap="RdBu_r", center=0)
```

가장 강한 신호는 `sugars`와 `rating`의 **음의 상관**(-0.76 정도)이다. **설탕이 많은 시리얼일수록 평점이 낮다**. 영양 정보가 평점에 **직접 반영**되는 패턴이다.

### 4.6 라이브러리 두 가지 — matplotlib vs seaborn

**matplotlib**는 **가장 기본적인 라이브러리**다. **모든 그래프의 토대**다. 세밀한 제어가 가능하지만 코드가 길어진다.

**seaborn**은 matplotlib 위에 **통계 시각화**에 특화한 라이브러리다. 산점도+회귀선, 그룹별 박스플롯 같은 **흔한 패턴**이 한 줄로 가능하다.

실무에서는 **seaborn으로 빠르게 그리고 matplotlib으로 세부 조정**하는 패턴을 많이 쓴다.

---

## 5장 변수 변환 — 로그·표준화·정규화

### 5.1 왜 변환이 필요한가

선형회귀나 신경망 같은 모델은 **입력 분포에 가정**을 둔다.

- **선형회귀**는 **잔차가 정규분포**라고 가정.
- **신경망**은 **입력이 표준화**되어 있어야 **학습이 빠르다**.
- **거리 기반 모델**(kNN, SVM)은 **모든 변수가 같은 스케일**에 있어야 **공정한 거리**를 계산한다.

트리 기반 모델(랜덤 포레스트·부스팅)은 **변환에 무관**하다. 그러나 **그 외 거의 모든 모델**은 전처리된 입력을 요구한다.

### 5.2 로그 변환 — 오른쪽 꼬리 다루기

가격·소득·인구 같은 변수는 **오른쪽으로 길게 꼬리**가 늘어진다. 이를 **비대칭도가 크다**고 말한다 — 분포가 **대칭이 아니다**.

![05 log transform](figs/05_log_transform.png)

<sub>그림 5-1. 로그 변환의 효과. 원본 SalePrice는 비대칭도 1.74로 오른쪽 꼬리가 강하지만, 로그 변환 후에는 약 -0.01로 정규분포에 매우 가까워졌다.</sub>

로그 변환은 **큰 값을 더 많이 압축**해 분포를 **대칭에 가깝게** 만든다.

```python
ames["LogSalePrice"] = np.log1p(ames["SalePrice"])
print(f"원본 비대칭도:    {ames['SalePrice'].skew():.3f}")     # 약 1.74
print(f"로그 변환 후:    {ames['LogSalePrice'].skew():.3f}")  # 약 0.0
```

**np.log1p**는 `log(1 + x)`다. 왜 `log1p`를 쓰나? **0인 값에 대응**하기 위해서다. `log(0)`은 무한대로 가서 **연산이 깨지지만**, `log1p(0)`은 안전하게 0이다.

**되돌리기 — np.expm1**. 모델이 **로그 가격**을 예측했을 때, 실제 가격으로 되돌리려면 `np.expm1`을 쓴다.

```python
log_pred = 12.5
real_pred = np.expm1(log_pred)
print(f"실제 가격: ${real_pred:,.0f}")     # $268,336
```

`expm1`이 `log1p`의 **역함수**다.

### 5.3 표준화 — 평균 0, 표준편차 1

평균 0, 표준편차 1로 맞추는 변환이다. **데이터의 단위가 달라도 공정한 비교**가 가능해진다.

sklearn의 `StandardScaler`가 표준 도구다.

```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
num_cols = ames.select_dtypes("number").columns
X_scaled = scaler.fit_transform(ames[num_cols])

print(f"변환 후 평균:   {X_scaled.mean(axis=0)[:3]}")    # [0, 0, 0]
print(f"변환 후 표준편차: {X_scaled.std(axis=0)[:3]}")  # [1, 1, 1]
```

`fit_transform`은 학습 데이터에 적용한다. 검증 데이터에는 **같은 scaler**로 `transform`만 호출한다. (검증 데이터의 통계로 다시 fit하지 않는 게 중요하다.)

### 5.4 정규화 — Min-Max 스케일링

값을 **[0, 1] 범위**로 압축하는 변환이다.

```python
from sklearn.preprocessing import MinMaxScaler
mm = MinMaxScaler()
X_mm = mm.fit_transform(ames[num_cols])
```

표준화 vs 정규화 — 어느 걸 쓸까?

| 방법 | 변환 후 평균 | 변환 후 범위 | 어울리는 경우 |
|---|---|---|---|
| 표준화 | 0 | (제한 없음) | 정규분포 가정 모델 (선형회귀·신경망) |
| 정규화 | (제한 없음) | [0, 1] | 명확한 범위 필요 (이미지·픽셀) |

대부분의 머신러닝에서 **표준화가 기본 선택**이다.

### 5.5 전처리 파이프라인의 순서

세 가지 변환을 함께 쓸 때 **순서**가 중요하다.

1. **결측치 처리** — 먼저. 결측이 있으면 다른 변환이 작동 안 함.
2. **이상치 처리** — 둘째. 표준화는 **극단값에 영향**을 받음.
3. **로그 변환** — 셋째. 오른쪽 꼬리 정리.
4. **표준화** — 마지막. 평균과 표준편차는 **최종 분포**에서 계산해야 의미가 있다.

이 순서를 **데이터 마이닝의 표준 파이프라인**이라 부른다.

---

## 6장 범주형 인코딩 — 라벨과 원-핫

### 6.1 왜 인코딩이 필요한가

거의 모든 머신러닝 모델은 **수치 입력**만 받는다. `"빨강"`, `"K"` 같은 **문자열을 모델에 직접 넣을 수 없다**. 문자를 숫자로 변환해야 한다 — 이걸 **인코딩**이라 한다.

인코딩 방법에는 두 가지 표준이 있다. 둘은 **근본적으로 다른 가정**을 한다.

![06 encoding comparison](figs/06_encoding_comparison.png)

<sub>그림 6-1. 범주형 인코딩 두 종류. 라벨 인코딩(왼쪽)은 한 컬럼에 정수 코드, 원-핫 인코딩(오른쪽)은 K개 컬럼에 0/1.</sub>

### 6.2 라벨 인코딩 — 한 컬럼

각 범주값에 **정수 코드 0, 1, 2, ...**를 부여한다.

```python
from sklearn.preprocessing import LabelEncoder

le = LabelEncoder()
mfr_encoded = le.fit_transform(cereal["mfr"])
print(f"원본: {cereal['mfr'].unique()}")          # ['N', 'Q', 'K', ...]
print(f"인코딩: {sorted(set(mfr_encoded))}")      # [0, 1, 2, ...]
```

**장점**: **한 컬럼**으로 압축. 메모리 효율적.

**단점**: **순서 의미가 생긴다**. 모델이 0 < 1 < 2처럼 **없는 순서**를 학습할 위험. 트리 기반 모델은 **순서 가정에 강건**하므로 안전하지만, 선형회귀·신경망에는 **위험**하다.

### 6.3 원-핫 인코딩 — K개 컬럼

각 범주값에 **별도의 0/1 컬럼**을 만든다. K개의 범주값에 대해 **K개의 컬럼**이 만들어지고, 각 행에서 **정확히 한 컬럼**만 1이다.

```python
mfr_onehot = pd.get_dummies(cereal["mfr"], prefix="mfr")
print(mfr_onehot.head())
print(f"shape: {mfr_onehot.shape}")
```

**장점**: **순서 가정이 없음**. 모든 모델에 안전.

**단점**: **차원이 증가**. K가 크면(예: 도시 1000개) 메모리 부담.

### 6.4 drop_first 옵션 — 중복 정보 회피

원-핫 인코딩에는 **함정** 하나가 있다. K개 컬럼이 **완전한 정보**를 담지만, 사실 **K-1개로 충분**하다. 예를 들어 빨강·파랑·초록 세 컬럼이 있을 때, 빨강과 파랑이 0이면 **자동으로** 초록이 1이라는 **정보가 중복**된다.

이 **중복**이 선형회귀에서 **행렬의 역행렬 계산을 깨뜨린다**. 해결책은 `drop_first=True`. **첫 번째 범주를 기준으로 두고** K-1개 컬럼만 만든다.

```python
mfr_safe = pd.get_dummies(cereal["mfr"], prefix="mfr", drop_first=True)
print(f"전체 K개: {len(cereal['mfr'].unique())}")
print(f"drop_first 후: {mfr_safe.shape[1]}")    # K - 1
```

선형회귀·릴리지에는 **항상 `drop_first=True`**. 트리 기반 모델에서는 **어느 쪽이든 무관**하다.

### 6.5 어느 인코딩을 언제 쓰나

| 모델 종류 | 권장 인코딩 |
|---|---|
| 선형회귀·릴리지·로지스틱 | 원-핫 (drop_first=True) |
| 신경망 | 원-핫 |
| 트리 기반 (RF·GBM·XGBoost) | 라벨 또는 원-핫 |
| kNN·SVM | 원-핫 |
| **CatBoost** | **인코딩 안 함** (자동 처리) |

**원-핫이 가장 안전한 선택**이다. 어떤 모델에 넣어도 안전하기 때문이다.

---

## 7장 그룹별 집계 — groupby

### 7.1 groupby의 직관

`groupby`는 **데이터 분석에서 가장 강력한 도구** 중 하나다. 핵심 개념은 **세 단계**로 정리된다.

![07 groupby sac](figs/07_groupby_sac.png)

<sub>그림 7-1. groupby의 split-apply-combine. (1) Split: 데이터를 그룹별로 나눈다. (2) Apply: 각 그룹에 같은 함수(예: 평균)를 적용한다. (3) Combine: 그룹별 결과를 한 표로 결합한다.</sub>

각 단계를 풀어 보면 다음과 같다.

**(1) Split — 분할**. 데이터를 **그룹화 키**로 나눈다. Cereals에서 **제조사(mfr)별로** 나누면 K(켈로그), N(나비스코), G(제너럴 밀스) 등의 그룹이 만들어진다.

**(2) Apply — 집계**. 각 그룹에 **같은 함수**를 적용한다. 평균·합·표준편차·최댓값 등 어떤 **집계 함수**든 가능하다.

**(3) Combine — 결합**. 그룹별 결과를 한 표로 모은다. **그룹 키가 인덱스**가 되고, **집계값이 행**이 된다.

### 7.2 가장 단순한 groupby

```python
# Cereals 제조사별 평균 칼로리
mean_cal = cereal.groupby("mfr")["calories"].mean()
print(mean_cal.sort_values(ascending=False))
```

`groupby("mfr")`이 **분할 단계**, `["calories"].mean()`이 **적용 단계**, 결과 출력이 **결합 단계**다. 세 단계가 한 줄에 압축되어 있다.

### 7.3 여러 집계 함수 — agg

여러 집계 함수를 **한 번에** 적용하려면 `agg`를 쓴다.

```python
agg_result = cereal.groupby("mfr")["calories"].agg(["mean", "std", "min", "max", "count"])
print(agg_result.round(1))
```

각 그룹에 대해 **평균·표준편차·최소·최대·개수**가 모두 한 표에 들어간다. **그룹 비교**의 가장 강력한 도구다.

### 7.4 transform — 그룹별 통계를 원본에 붙이기

`groupby`의 결과는 **그룹별 한 행**으로 압축된 표다. 그런데 가끔은 **원본 데이터의 모든 행**에 **그 행이 속한 그룹의 통계**를 **붙이고 싶을 때**가 있다.

```python
# Ames에서 동네별 평균 가격을 원본에 붙이기
ames["NbhdMeanPrice"] = ames.groupby("Neighborhood")["SalePrice"].transform("mean")
print(ames[["Neighborhood", "SalePrice", "NbhdMeanPrice"]].head(10))
```

`transform`의 결과는 **원본과 같은 크기의 Series**. 각 행에 **그 동네의 평균 가격**이 채워진다. **그룹 정보를 행 수준으로 사용**하는 강력한 패턴이다.

### 7.5 Ames에서 동네별 분석

groupby를 활용한 **부동산 도메인 분석**의 예시다.

```python
nbhd_stats = ames.groupby("Neighborhood")["SalePrice"].agg(
    ["count", "mean", "median", "std"]
).sort_values("mean", ascending=False)

print("가격 상위 5개 동네:")
print(nbhd_stats.head().round(0))
```

**Stone Brook, Northridge Heights, Northridge**가 비싸고, **Iowa DOT and Rail Road, Meadow Village**가 저렴하다. **동네 변수가 강력한 예측 변수**임을 한 표로 확인.

### 7.6 자주 만나는 활용 시나리오

`groupby`는 **데이터 마이닝의 일상**이다. 자주 만나는 패턴.

- **고객 세그먼트별 매출**: `df.groupby("segment")["revenue"].sum()`
- **월별 트렌드**: `df.groupby(df["date"].dt.month)["sales"].mean()`
- **그룹별 비율**: `df.groupby("category")["target"].mean()`
- **그룹 내 순위**: `df.groupby("group")["score"].rank(ascending=False)`

이 패턴들이 **데이터 분석 면접 단골 문제**이기도 하다.

---

## 8장 특성 공학 — 도메인 지식을 변수로

### 8.1 좋은 변수가 좋은 모델을 만든다

머신러닝 모델은 **주어진 변수**만 본다. **변수가 좋아야 모델도 좋다**. 좋은 변수를 **만드는 기술**이 **특성 공학**(feature engineering)이다.

특성 공학이 **왜 그렇게 중요한지**를 한 예로 본다.

### 8.2 Total SF — 면적 변수 합치기

Ames의 **세 면적 변수**가 따로 있다.

- `1st Flr SF`: 1층 면적
- `2nd Flr SF`: 2층 면적
- `Total Bsmt SF`: 지하 면적

![08 feature engineering](figs/08_feature_engineering.png)

<sub>그림 8-1. 특성 공학의 효과. 왼쪽은 세 원본 변수와 가격의 관계 — 각각 어느 정도 상관이 있지만 명확하지 않다. 오른쪽은 셋을 합쳐 만든 Total SF — 가격과 매우 강한 양의 상관(약 0.81)을 보인다.</sub>

```python
ames["Total SF"] = ames["1st Flr SF"] + ames["2nd Flr SF"] + ames["Total Bsmt SF"]
```

원본 세 변수와 가격의 상관계수는 각각 0.4~0.6 정도지만, **Total SF**는 0.8 이상이다. **도메인 지식**("주택 가격은 총 면적에 비례한다")이 **데이터에서 더 강한 신호**를 만들어 냈다.

이게 특성 공학의 **본질**이다. **세상에 대한 지식**을 **변수의 형태로 모델에 전달**한다.

### 8.3 Total Bath — 화장실 변수 합치기

같은 원리로 화장실 변수도 합칠 수 있다. Ames에는 네 가지 화장실 변수가 있다.

```python
ames["Total Bath"] = (
    ames["Full Bath"]
    + 0.5 * ames["Half Bath"]
    + ames["Bsmt Full Bath"]
    + 0.5 * ames["Bsmt Half Bath"]
)
```

half bath는 **full bath의 절반**으로 계산. 도메인 지식이 들어간 **가중 합**이다.

### 8.4 상호작용항 — 두 변수의 곱

**두 변수의 곱**도 새로운 변수다. 종종 **각 변수 단독보다 더 강한 신호**를 준다.

```python
# 품질 × 면적 — 좋은 품질 위에서 면적의 효과가 더 크다
ames["Qual_Area"] = ames["Overall Qual"] * ames["Gr Liv Area"]
```

`Overall Qual`과 `Gr Liv Area`의 상관계수는 각각 0.80, 0.71 정도지만, **둘의 곱**은 0.85 이상이 흔하다. **상호작용**이 데이터에 내재해 있다.

### 8.5 도메인 지식 변환 — 세 가지 패턴

**(1) 비율 변수**. 두 변수의 비율이 더 의미 있을 때.

```python
ames["BsmtRatio"] = ames["Total Bsmt SF"] / (ames["Gr Liv Area"] + ames["Total Bsmt SF"])
```

지하 면적이 **전체에서 차지하는 비율** — 0과 1 사이.

**(2) 시간 차이 변수**. 두 날짜의 차이.

```python
ames["HouseAge"] = ames["Yr Sold"] - ames["Year Built"]
ames["YearsSinceRemodel"] = ames["Yr Sold"] - ames["Year Remod/Add"]
```

`HouseAge`는 **판매 시점의 집 나이**. `YearsSinceRemodel`은 **마지막 리모델링 이후 시간**. 둘 다 **원본에 없던 강력한 변수**다.

**(3) 이진 플래그 변수**. 조건의 만족 여부.

```python
ames["HasPool"] = (ames["Pool Area"] > 0).astype(int)
ames["HasGarage"] = (ames["Garage Area"] > 0).astype(int)
ames["IsRemodeled"] = (ames["Year Remod/Add"] != ames["Year Built"]).astype(int)
```

**수영장이 있는가**, **차고가 있는가**, **리모델링한 적 있는가** 같은 **yes/no 정보**를 변수로 만든다.

### 8.6 Cereals의 특성 공학

같은 사고를 Cereals에 적용한다.

```python
# 영양 밀도 — 단위 칼로리당 단백질
cereal["ProteinDensity"] = cereal["protein"] / cereal["calories"]

# 단 시리얼 vs 안 단 시리얼
cereal["IsSweet"] = (cereal["sugars"] >= 10).astype(int)

# 영양 점수 — 단순 가중 합 (도메인 지식: 단백질·섬유 좋음, 지방·설탕 나쁨)
cereal["NutritionScore"] = (
    2 * cereal["protein"]
    + 1.5 * cereal["fiber"]
    - cereal["fat"]
    - cereal["sugars"]
)

# rating과의 상관계수 확인
for c in ["ProteinDensity", "IsSweet", "NutritionScore"]:
    r = cereal[[c, "rating"]].corr().iloc[0, 1]
    print(f"  {c:<18s}  r = {r:+.3f}")
```

`NutritionScore`가 **rating과 매우 강한 상관**(약 +0.85)을 보인다. **영양학 도메인 지식**이 **예측에 직접 도움**이 됨을 한 표로 확인.

### 8.7 특성 공학을 잘하는 사람의 세 가지 습관

1. **도메인 전문가와 대화한다**. 부동산 전문가, 영양사, 의사 같은 **그 분야 사람**의 직관이 **데이터에서 가장 강한 신호**가 된다.

2. **EDA를 충분히 한다**. 4장의 시각화로 **데이터가 말하는 것**을 듣는다. 패턴이 보이면 **그 패턴을 변수로 만든다**.

3. **간단한 모델로 검증한다**. 새 변수가 정말 도움 되는지 **선형회귀나 결정 트리로** 빠르게 확인.

이 원칙들이 **캐글 우승자와 평범한 참가자의 차이**를 만든다.

---

## 마무리 — 1부에서 손에 들어온 것

이번 부에서 다룬 도구를 한 표로 정리한다.

| 도구 | 무엇을 하는가 |
|---|---|
| `pd.read_csv` | URL 또는 파일에서 데이터 로딩 |
| 첫 탐색 5종 (`shape`, `head`, `info`, `describe`) | 데이터 그림 파악 |
| `select_dtypes`, `astype` | 변수 타입 다루기 |
| `fillna` (None 또는 중앙값) | 결측치 처리 |
| IQR 규칙 + 도메인 컷오프 | 이상치 탐지 |
| matplotlib + seaborn 4종 | 데이터 탐색 |
| `np.log1p`, `expm1` | 로그 변환과 역변환 |
| `StandardScaler` | 표준화 (평균 0, 표준편차 1) |
| `pd.get_dummies` | 원-핫 인코딩 |
| `groupby`, `agg`, `transform` | 그룹별 집계 |
| 도메인 지식 + 변수 조합 | 특성 공학 |

### 가장 중요한 통찰 세 가지

**1**. **데이터 마이닝은 머신러닝의 80%다**. 모델은 입력의 품질을 넘어설 수 없다.

**2**. **변수에는 두 세계가 있다**. 수치형과 범주형은 처리 방식이 완전히 다르다. 위장된 범주형(`MS SubClass` 같은)을 빠뜨리지 않는다.

**3**. **특성 공학이 모델의 한계를 깬다**. 도메인 지식을 변수로 표현하면 **원본 데이터에 없던 강한 신호**가 만들어진다.

### 다음 부 예고

다음 부는 **2부 결정 트리 심화**다. 1부에서 준비한 **깨끗한 데이터**를 트리에 넣어 **어떤 패턴이 잡히는지** 본격적으로 분석한다.

3부에서 트리 **기초**를 먼저 다루고, 2부에서 **심화** 주제를 다룬다는 점이 **시리즈 구조의 특이점**이다. 학생은 **3부를 먼저 읽은 뒤** 2부로 돌아오는 흐름이 자연스럽다.
