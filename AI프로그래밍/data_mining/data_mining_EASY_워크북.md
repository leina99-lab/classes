# 1부 학생 워크북 — 데이터 마이닝과 pandas 복습

## 쉬운 버전 — 그림으로 채우기

이 워크북은 이론 교재 `00_data_mining_theory_EASY.md`를 함께 읽으면서 채우는 자가학습 자료이다. 수식 없이 그림과 직관 중심으로 구성되어 있다. 각 빈칸 아래의 정답 토글을 펼쳐 즉시 확인할 수 있다.

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 0장 데이터 마이닝의 정신 — 모델 학습 전의 80%

![01 dataframe structure](figs/01_dataframe_structure.png)

<sub>그림 0-1. 1부에서 사용할 두 데이터셋의 구조.</sub>

**개념 1.** 업계 격언 — 데이터 과학자는 ____________________ %의 시간을 데이터 준비에 쓰고 ____________________ %를 모델 학습에 쓴다. 모델은 **입력 데이터의 ____________________ 을 넘어설 수 없기** 때문이다.

<details><summary>▶ 정답 보기</summary>

80 / 20 / 품질

</details>

**개념 2.** 1부의 두 데이터셋:

| 데이터셋 | shape | 역할 |
|---|---|---|
| Ames | ____________________ × ____________________ | 강사 시범 |
| Cereals | ____________________ × ____________________ | 학생 실습 |


<details><summary>▶ 정답 보기</summary>

| 데이터셋 | shape |
|---|---|
| Ames | **2,930 × 82** |
| Cereals | **77 × 16** |

두 데이터셋의 대조가 1부의 학습 전략 — 크기와 도메인이 완전히 다른 두 데이터에 같은 기법을 적용한다.

</details>

---

## 1장 데이터 로딩과 첫 탐색
**개념 3.** pandas의 두 핵심 자료구조는 ____________________ (1차원)와 ____________________ (2차원)다. DataFrame에서 한 열을 따로 가져오면 ____________________ 가 된다.

<details><summary>▶ 정답 보기</summary>

Series / DataFrame / Series

</details>

**개념 4.** 데이터 로딩 직후 **반드시** 해야 할 5가지 점검:

| 메서드 | 답하는 질문 |
|---|---|
| `df.shape` | ____________________ |
| `df.head()` | 데이터가 어떻게 생겼나 |
| `df.info()` | ____________________ |
| `df.describe()` | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 메서드 | 답하는 질문 |
|---|---|
| `df.shape` | **행이 몇 개, 열이 몇 개인가** |
| `df.info()` | **각 열의 타입과 결측은** |
| `df.describe()` | **수치형 열의 평균·중앙값·사분위수** |


</details>

**개념 5.** pandas의 함정 두 가지:

(1) 공백 있는 열 이름 (`Overall Qual` 등): ____________________ 접근만 가능, 점 접근(`df.Overall Qual`)은 문법 오류
(2) 결측치 있는 정수 열: 자동으로 ____________________ 타입으로 변환 (NaN이 이 타입 전용이므로)

<details><summary>▶ 정답 보기</summary>

대괄호(bracket) / float64

</details>

**코드 빈칸.** 데이터 로딩.

```python
import pandas as pd

URL = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/AmesHousing.csv"

try:
    ames = pd.____(URL)
    print(f"shape: {ames.____}")
except ____ as e:
    print(f"로딩 실패: {e}")
```

<details><summary>▶ 정답 보기</summary>

```python
ames = pd.read_csv(URL)
print(f"shape: {ames.shape}")
except Exception as e:
```

</details>

---

## 2장 변수 타입의 두 세계

![02 variable types](figs/02_variable_types.png)

<sub>그림 2-1. 수치형과 범주형.</sub>

**개념 6.** 두 세계의 근본 차이:

- **수치형**: 값의 ____________________ 에 의미가 있음. 사칙연산 가능. 평균·표준편차 자연스럽다.
- **범주형**: 값은 ____________________ 일 뿐. 크기는 무의미. 평균을 **계산할 수도 없다**.

<details><summary>▶ 정답 보기</summary>

크기 / 라벨

</details>

**개념 7.** 위장된 범주형의 함정 — Ames의 ____________________ 변수는 **숫자로 저장**되어 있지만 의미상 **주택 유형의 코드**다. 60이 20의 ____________________ 가 아니다. 

해결책: ____________________ 메서드로 명시적 문자열 변환.

<details><summary>▶ 정답 보기</summary>

MS SubClass / 3배 / astype(str)

</details>

**코드 빈칸.** 타입별 열 추출.

```python
# 수치형 열만
num_cols = ames.____(include="____").columns

# 범주형 열만
cat_cols = ames.select_dtypes(include="____").columns

# 위장된 범주형 변환
ames["MS SubClass"] = ames["MS SubClass"].____(str)
```

<details><summary>▶ 정답 보기</summary>

```python
ames.select_dtypes(include="number")
include="object"
ames["MS SubClass"].astype(str)
```

</details>

---

## 3장 결측치와 이상치

![03 missing outliers](figs/03_missing_outliers.png)

<sub>그림 3-1. Ames의 결측치 분포(왼쪽)와 거실 면적 이상치(오른쪽).</sub>

**개념 8.** 결측치의 세 종류:

(a) ____________________ 결측: 측정 실패·기록 누락. **중앙값으로 채움**.
(b) ____________________ 결측: 값이 없는 것 자체가 정보 (예: 수영장 없음). **"None" 라벨로 채움**.
(c) 변환된 결측: 0이나 -999 같은 코드로 표현. **도메인 지식 필요**.

<details><summary>▶ 정답 보기</summary>

(a) 진짜 / (b) 의미 있는

</details>

**개념 9.** Ames의 결측치 상위 컬럼들(`Pool QC`, `Misc Feature`, `Alley` 등)은 모두 ____________________ 결측에 해당한다. 처리 방법은 ____________________ 라벨로 채우기다.

<details><summary>▶ 정답 보기</summary>

의미 있는 / "None" 

</details>

**개념 10.** IQR 규칙은 **통계적 이상치 탐지**의 표준이다.

> **이상치 = $Q_1$에서 ____________________ × IQR 아래보다 작거나, $Q_3$에서 ____________________ × IQR 위보다 큰 값**

<details><summary>▶ 정답 보기</summary>

1.5 / 1.5

</details>

**개념 11.** Ames의 **도메인 지식 컷오프**: ____________________ > ____________________ sq ft인 주택은 ____ 채뿐이며, **비공개 거래나 시장 비정상**이므로 제외한다.

<details><summary>▶ 정답 보기</summary>

Gr Liv Area / 4000 / 5

</details>

**코드 빈칸.** 의미 있는 결측을 "None"으로 채우기.

```python
none_cols = ["Pool QC", "Misc Feature", "Alley", "Bsmt Qual"]
for c in none_cols:
    if c in ames.columns:
        ames[c] = ames[c].____("____")

# 수치형 결측은 중앙값으로
num_cols = ames.select_dtypes("number").columns
ames[num_cols] = ames[num_cols].____(ames[num_cols].____())

# 이상치 제거
ames = ames[ames["Gr Liv Area"] < ____].copy()
```

<details><summary>▶ 정답 보기</summary>

```python
ames[c] = ames[c].fillna("None")
ames[num_cols] = ames[num_cols].fillna(ames[num_cols].median())
ames = ames[ames["Gr Liv Area"] < 4000].copy()
```

</details>

---

## 4장 시각화 — 데이터를 눈으로 보기

![04 visualization quartet](figs/04_visualization_quartet.png)

<sub>그림 4-1. 데이터 시각화 4종 — 한 변수·두 변수·그룹·다변수.</sub>

**개념 1.** EDA(탐색적 데이터 분석)의 네 가지 질문과 시각화:

| 질문 | 시각화 |
|---|---|
| 한 변수의 **분포 모양**은? | ____________________ |
| 두 변수의 **관계**는? | ____________________ |
| **그룹별로** 어떻게 다른가? | ____________________ |
| **여러 변수** 사이의 관계는? | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 질문 | 시각화 |
|---|---|
| 한 변수의 분포 | **히스토그램** |
| 두 변수의 관계 | **산점도** |
| 그룹별 비교 | **(그룹별) 박스플롯** |
| 다변수 관계 | **히트맵** |


</details>

**개념 2.** 히스토그램에서 읽는 **세 가지 신호**:

- **오른쪽 꼬리**: ____________________ 변환의 후보
- **이봉**(봉우리 두 개): ____________________ 가 있을 가능성
- **이상치**: 분포의 ____________________ 에 떨어진 점

<details><summary>▶ 정답 보기</summary>

로그 / 숨겨진 그룹 / 극단

</details>

**그림 해석.** 그림 4-1의 (4) 히트맵에서 가장 강한 **음의 상관**을 가진 변수 쌍은? 그 의미는?

<details><summary>▶ 정답 보기</summary>

**sugars ↔ rating** (약 -0.76)

설탕이 많은 시리얼일수록 **Consumer Reports의 종합 평점이 낮다**. 영양 정보가 평점에 **직접 반영**되는 패턴이다.

</details>

**개념 3.** 시각화 라이브러리 두 가지:

- **matplotlib**: 가장 ____________________ 라이브러리. 세밀한 제어 가능.
- **seaborn**: matplotlib 위에 **____________________ 시각화** 특화. 한 줄로 회귀선·박스플롯.

<details><summary>▶ 정답 보기</summary>

기본적인 / 통계

</details>

---

## 5장 변수 변환 — 로그·표준화·정규화

![05 log transform](figs/05_log_transform.png)

<sub>그림 5-1. 로그 변환의 효과 — 비대칭도가 1.74에서 거의 0으로.</sub>

**개념 4.** 변수 변환이 필요한 모델과 안 필요한 모델:

| 모델 | 변환 필요? |
|---|---|
| 선형회귀 | ____________________ |
| 신경망 | ____________________ |
| 거리 기반 (kNN, SVM) | ____________________ |
| 트리 기반 (RF, GBM) | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 모델 | 변환 필요? |
|---|---|
| 선형회귀 | **필요** |
| 신경망 | **필요** |
| 거리 기반 | **필요** |
| 트리 기반 | **불필요** (분할 기준은 순위만 봄) |


</details>

**개념 5.** 로그 변환의 효과 — Ames `SalePrice`의 비대칭도는 약 ____________________ (오른쪽 꼬리). 로그 변환 후에는 약 ____________________ (정규에 가까움). 

사용 함수는 `np.____`, 역변환은 `np.____`이다.

<details><summary>▶ 정답 보기</summary>

1.74 / 0.0 (또는 -0.01) / log1p / expm1

</details>

**개념 6.** `np.log1p(x)` = `np.log(____)`. `np.log` 대신 `np.log1p`를 쓰는 이유 — `log(0) = ____________________` 가 되어 **연산이 깨지지만** `log1p(0) = ____` 으로 안전.

<details><summary>▶ 정답 보기</summary>

1 + x / -∞ (무한대) / 0

</details>

**개념 7.** 표준화와 정규화 비교:

|  | 표준화 (Z-score) | 정규화 (Min-Max) |
|---|---|---|
| 변환 후 평균 | ____ | (정해지지 않음) |
| 변환 후 범위 | (정해지지 않음) | ____________________ |
| sklearn 클래스 | `StandardScaler` | `____________________` |


<details><summary>▶ 정답 보기</summary>

| | 표준화 | 정규화 |
|---|---|---|
| 변환 후 평균 | **0** | (정해지지 않음) |
| 변환 후 범위 | (정해지지 않음) | **[0, 1]** |
| sklearn 클래스 | StandardScaler | **MinMaxScaler** |


</details>

**개념 8.** 전처리 파이프라인의 **권장 순서**:

1. ____________________ 처리
2. ____________________ 처리
3. ____________________ 변환 (오른쪽 꼬리 정리)
4. ____________________ 적용

<details><summary>▶ 정답 보기</summary>

1. 결측치
2. 이상치
3. 로그
4. 표준화

</details>

**코드 빈칸.** 표준화 적용.

```python
from sklearn.preprocessing import ____________________

scaler = StandardScaler()
X_scaled = scaler.____(ames[num_cols])
print(f"평균: {X_scaled.____(axis=0)[:3]}")    # [0, 0, 0]
print(f"표준편차: {X_scaled.____(axis=0)[:3]}")  # [1, 1, 1]
```

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.preprocessing import StandardScaler
scaler.fit_transform(ames[num_cols])
X_scaled.mean(axis=0)
X_scaled.std(axis=0)
```

</details>

---

## 6장 범주형 인코딩 — 라벨과 원-핫

![06 encoding comparison](figs/06_encoding_comparison.png)

<sub>그림 6-1. 라벨 인코딩과 원-핫 인코딩.</sub>

**개념 9.** 두 인코딩의 차이:

| | 라벨 인코딩 | 원-핫 인코딩 |
|---|---|---|
| 컬럼 수 | ____________________ | ____________________ (K = 범주값 수) |
| 값에 순서 의미? | ____________________ | ____________________ |
| 안전한 모델 | ____________________ | ____________________ |


<details><summary>▶ 정답 보기</summary>

| | 라벨 | 원-핫 |
|---|---|---|
| 컬럼 수 | **1개** | **K개** |
| 순서 의미 | **있음 (위험)** | **없음 (안전)** |
| 안전한 모델 | **트리 기반만** | **모든 모델** |


</details>

**개념 10.** `pd.get_dummies(df, drop_first=True)` 옵션의 효과 — K개 컬럼 중 ____________________ 개만 만들어 **중복 정보**를 회피한다. 선형회귀에서 **반드시** 필요한 옵션이다.

<details><summary>▶ 정답 보기</summary>

K-1

</details>

**개념 11.** 모델별 권장 인코딩:

| 모델 | 권장 인코딩 |
|---|---|
| 선형회귀·릴리지·로지스틱 | ____________________ |
| 신경망 | ____________________ |
| 트리 기반 (RF·GBM·XGBoost) | ____________________ |
| **CatBoost** | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 모델 | 권장 인코딩 |
|---|---|
| 선형회귀 등 | **원-핫 (drop_first=True)** |
| 신경망 | **원-핫** |
| 트리 기반 | **라벨 또는 원-핫** |
| CatBoost | **인코딩 안 함** (자동 처리, 6부에서 다룸) |


</details>

**코드 빈칸.** Cereals 범주형 인코딩.

```python
# name은 유일 식별자라 제거
cereal_X = cereal.____(columns=["name", "rating"])

# mfr, type을 원-핫
cereal_encoded = pd.____(cereal_X,
                          columns=["mfr", "type"],
                          drop_first=____)
```

<details><summary>▶ 정답 보기</summary>

```python
cereal_X = cereal.drop(columns=["name", "rating"])
cereal_encoded = pd.get_dummies(cereal_X, columns=["mfr", "type"], drop_first=True)
```

</details>

---

## 7장 그룹별 집계 — groupby

![07 groupby sac](figs/07_groupby_sac.png)

<sub>그림 7-1. groupby의 split-apply-combine 세 단계.</sub>

**개념 1.** groupby의 세 단계와 각각이 하는 일:

| 단계 | 영문 | 하는 일 |
|---|---|---|
| 1 | ____________________ | 데이터를 그룹화 키로 나눈다 |
| 2 | ____________________ | 각 그룹에 같은 함수를 적용 |
| 3 | ____________________ | 결과를 한 표로 결합 |


<details><summary>▶ 정답 보기</summary>

| 단계 | 영문 |
|---|---|
| 1 | **Split** (분할) |
| 2 | **Apply** (적용/집계) |
| 3 | **Combine** (결합) |


</details>

**코드 빈칸.** 가장 단순한 groupby — Cereals 제조사별 평균 칼로리.

```python
result = cereal.____("mfr")["calories"].____()
```

`groupby("mfr")`이 ____________________ 단계, `["calories"].mean()`이 ____________________ 단계, 결과 출력이 ____________________ 단계다.

<details><summary>▶ 정답 보기</summary>

```python
cereal.groupby("mfr")["calories"].mean()
```

Split / Apply / Combine

</details>

**개념 2.** `agg`와 `transform`의 차이:

- **`agg`**: 결과가 **그룹별 한 행**. 그룹 수만큼 행을 가진 ____________________ 표.
- **`transform`**: 결과가 ____________________ 같은 크기. 각 행에 **그 행이 속한 그룹의 통계**가 채워짐.

<details><summary>▶ 정답 보기</summary>

압축된 / 원본과

</details>

**코드 빈칸.** transform으로 동네별 평균 가격을 원본에 붙이기.

```python
ames["NbhdMeanPrice"] = ames.groupby("Neighborhood")["SalePrice"].____("____")
```

<details><summary>▶ 정답 보기</summary>

```python
ames["NbhdMeanPrice"] = ames.groupby("Neighborhood")["SalePrice"].transform("mean")
```

원본과 같은 행 수. 각 주택에 **그 동네의 평균 가격**이 채워진다.

</details>

---

## 8장 특성 공학 — 도메인 지식을 변수로

![08 feature engineering](figs/08_feature_engineering.png)

<sub>그림 8-1. 특성 공학의 효과 — 세 변수를 합쳐 더 강한 변수 한 개를 만든다.</sub>

**개념 3.** 특성 공학의 본질 — **세상에 대한** ____________________ 을 **변수의 형태로 모델에 전달**한다.

<details><summary>▶ 정답 보기</summary>

도메인 지식

</details>

**그림 해석.** 그림 8-1의 비교:

- 원본 세 변수(`1st Flr SF`, `2nd Flr SF`, `Total Bsmt SF`)와 `SalePrice`의 평균 상관계수: 약 ____________________
- 셋을 합쳐 만든 `Total SF`와 `SalePrice`의 상관계수: 약 ____________________

이는 **세상의 지식** ("주택 가격은 ____________________ 에 비례한다")이 **데이터에서 더 강한 신호**를 만들어 낸 결과다.

<details><summary>▶ 정답 보기</summary>

0.4~0.6 / 0.81 / 총 면적

</details>

**개념 4.** Ames의 표준 특성 공학 변수 4가지:

| 새 변수 | 식 |
|---|---|
| Total SF | ____________________ |
| HouseAge | ____________________ |
| YearsSinceRemodel | Yr Sold - Year Remod/Add |
| HasPool | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 새 변수 | 식 |
|---|---|
| Total SF | **1st Flr SF + 2nd Flr SF + Total Bsmt SF** |
| HouseAge | **Yr Sold - Year Built** |
| HasPool | **(Pool Area > 0).astype(int)** |


</details>

**개념 5.** 도메인 지식 변환의 세 가지 패턴:

(1) ____________________ 변수: 두 변수의 비율 (예: BsmtRatio)
(2) ____________________ 차이 변수: 두 날짜의 차이 (예: HouseAge)
(3) ____________________ 플래그: 조건의 만족 여부 (예: HasPool)

<details><summary>▶ 정답 보기</summary>

(1) 비율
(2) 시간
(3) 이진(binary)

</details>

**개념 6.** 상호작용항이란? — 두 변수의 ____________________ 으로 만든 새 변수. **각 변수 단독보다 강한 신호**를 줄 수 있다. 예: Ames에서 ____________________ × ____________________ = Qual_Area.

<details><summary>▶ 정답 보기</summary>

곱 / Overall Qual / Gr Liv Area

</details>

**코드 빈칸.** Cereals의 특성 공학.

```python
# 영양 밀도 — 단위 칼로리당 단백질
cereal["ProteinDensity"] = cereal["protein"] / cereal["____________________"]

# 단 시리얼 vs 안 단 시리얼
cereal["IsSweet"] = (cereal["sugars"] >= 10).____(int)

# 영양 점수 (도메인: 단백질·섬유 좋음, 지방·설탕 나쁨)
cereal["NutritionScore"] = (
    ____ * cereal["protein"]
    + 1.5 * cereal["fiber"]
    - cereal["fat"]
    - cereal["sugars"]
)
```

<details><summary>▶ 정답 보기</summary>

```python
cereal["ProteinDensity"] = cereal["protein"] / cereal["calories"]
cereal["IsSweet"] = (cereal["sugars"] >= 10).astype(int)
cereal["NutritionScore"] = (2 * cereal["protein"] + 1.5 * cereal["fiber"] - cereal["fat"] - cereal["sugars"])
```

NutritionScore가 rating과 약 +0.85의 강한 상관을 보인다.

</details>

**개념 7.** 특성 공학을 잘하는 **세 가지 습관**:

1. ____________________ 와 대화한다
2. ____________________ 를 충분히 한다 (시각화로 패턴 파악)
3. ____________________ 모델로 새 변수 검증 (선형회귀나 단일 트리)

<details><summary>▶ 정답 보기</summary>

1. 도메인 전문가
2. EDA
3. 간단한(simple)

</details>

---

## 응용 문제 — 직접 풀어 보기

각 문제의 코드를 실행하여 결과를 확인한 뒤 정답 토글로 비교하자.

**문제 1.** Cereals 데이터의 모든 결측치를 중앙값으로 채우라.

<details><summary>▶ 정답 보기</summary>

```python
import pandas as pd

URL = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/Cereals.csv"
cereal = pd.read_csv(URL)

num_cols = cereal.select_dtypes("number").columns
cereal[num_cols] = cereal[num_cols].fillna(cereal[num_cols].median())

print(f"결측 합계: {cereal.isnull().sum().sum()}")   # 0
```

원본 결측 4개(carbo 1, sugars 1, potass 2)가 모두 채워진다.

</details>

**문제 2.** Ames `SalePrice`의 비대칭도를 로그 변환 전후로 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
import numpy as np

raw_skew = ames["SalePrice"].skew()
log_skew = np.log1p(ames["SalePrice"]).skew()

print(f"원본:    {raw_skew:.3f}")    # 1.74
print(f"로그 후: {log_skew:.3f}")    # -0.01
```

원본 1.74에서 거의 0으로 — **정규분포에 매우 가까워진다**.

</details>

**문제 3.** Cereals에서 제조사별 평균 칼로리·평균 평점·개수를 한 표로.

<details><summary>▶ 정답 보기</summary>

```python
mfr_stats = cereal.groupby("mfr").agg(
    calories=("calories", "mean"),
    rating=("rating", "mean"),
    count=("name", "count"),
).round(2).sort_values("rating", ascending=False)

print(mfr_stats)
```

평점 높은 제조사는 보통 N(Nabisco), 낮은 쪽은 K(Kellogg's). K는 시리얼 개수가 가장 많다(23개).

</details>

**문제 4.** Cereals에 ProteinDensity, IsSweet, NutritionScore 세 변수를 추가하고 **rating과의 상관계수**를 출력하라.

<details><summary>▶ 정답 보기</summary>

```python
cereal["ProteinDensity"] = cereal["protein"] / cereal["calories"]
cereal["IsSweet"] = (cereal["sugars"] >= 10).astype(int)
cereal["NutritionScore"] = (2 * cereal["protein"] + 1.5 * cereal["fiber"]
                            - cereal["fat"] - cereal["sugars"])

for c in ["ProteinDensity", "IsSweet", "NutritionScore"]:
    r = cereal[[c, "rating"]].corr().iloc[0, 1]
    print(f"  {c:<18s}  r = {r:+.3f}")
```

**NutritionScore**가 약 +0.85의 강한 상관. 도메인 지식의 가치를 한 표로 확인.

</details>

---

## 다음 부 예고 — 2부 결정 트리 심화

다음 부는 **2부 결정 트리 심화**다. 3부에서 트리의 **기초**(불순도·분기·가지치기)를 먼저 다루고, 2부에서 **심화** 주제를 다룬다 — 시리즈 구조의 특이점이다.

미리 던지는 질문 — Ames의 약 80개 변수 중 **결정 트리가 처음으로 분기**하는 변수는 무엇일까?

<details><summary>▶ 정답 보기</summary>

거의 항상 **Overall Qual** 또는 **Total SF**다. 두 변수가 가격에 대한 **가장 강한 신호**이기 때문이다.

다음 부에서는 **왜** 트리가 이 변수를 우선 고르는지, **어떤 임계값**에서 분할하는지를 알고리즘 수준에서 본다.

</details>
