# 1부 학생 워크북 — 데이터 마이닝과 pandas 복습

## 어려운 버전 — 학부 1~2학년용

이 워크북은 이론 교재 `00_data_mining_theory_HARD.md`를 읽으면서 함께 채우는 자가학습 자료이다. 빈칸을 채운 뒤 바로 아래의 **정답 보기** 토글을 펼쳐 확인할 수 있다.

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 0장 데이터 마이닝의 정신 — 모델 학습 전의 80%

![01 dataframe structure](figs/01_dataframe_structure.png)

<sub>그림 0-1. 1부에서 사용할 두 데이터셋의 구조.</sub>

**개념 1.** 업계 격언 — 데이터 과학자는 ____________________ %의 시간을 데이터 준비에 쓰고 ____________________ %를 모델 학습에 쓴다. 모델은 **입력 데이터의 ____________________ 을 넘어설 수 없기** 때문이다.

<details><summary>▶ 정답 보기</summary>

80 / 20 / 품질(quality)

</details>

**개념 2.** 1부의 두 데이터셋과 그 역할.

| 데이터셋 | shape | 역할 |
|---|---|---|
| Ames | ____________________ × ____________________ | 강사 시범(Ping) |
| Cereals | ____________________ × ____________________ | 학생 실습(Pong) |


<details><summary>▶ 정답 보기</summary>

| 데이터셋 | shape | 역할 |
|---|---|---|
| Ames | **2,930** × **82** | 강사 시범 |
| Cereals | **77** × **16** | 학생 실습 |


</details>

**개념 3.** Ames 데이터를 발표한 사람은 ____________________ 년 ____________________ 다. 이 데이터는 **Boston Housing 데이터의 현대적 ____________________ **로 자리잡았다.

<details><summary>▶ 정답 보기</summary>

2010 / Dean De Cock / 대체물(replacement)

</details>

---

## 1장 데이터 로딩과 첫 탐색
**개념 4.** pandas의 두 핵심 자료구조는 ____________________ (1차원)와 ____________________ (2차원)다. DataFrame에서 한 열을 따로 가져오면 ____________________ 가 된다.

<details><summary>▶ 정답 보기</summary>

Series / DataFrame / Series

</details>

**개념 5.** 데이터 로딩 직후 **반드시** 해야 할 5가지 점검과 각각이 답하는 질문을 적어 보자.

| 메서드 | 답하는 질문 |
|---|---|
| `df.shape` | ____________________ |
| `df.head()` | ____________________ |
| `df.tail()` | ____________________ |
| `df.info()` | ____________________ |
| `df.describe()` | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 메서드 | 답하는 질문 |
|---|---|
| `df.shape` | **행이 몇 개, 열이 몇 개인가** |
| `df.head()` | **데이터가 어떻게 생겼나** |
| `df.tail()` | **끝부분에 이상한 게 있나** (집계행 등) |
| `df.info()` | **각 열의 타입과 결측은** |
| `df.describe()` | **수치형 열의 평균·표준편차·사분위수** |


</details>

**개념 6.** pandas의 함정 두 가지:

(1) 공백 있는 열 이름 (`Overall Qual` 등): ____________________ 접근만 가능, ____________________ 접근(점)은 불가
(2) 결측치 있는 정수 열: 자동으로 ____________________ 타입으로 변환 (왜냐하면 NaN이 ____________________ 전용이므로)

<details><summary>▶ 정답 보기</summary>

대괄호(bracket) / 점(dot) / float64 / float (소수점 실수)

</details>

**코드 빈칸.** 데이터 로딩과 폴백 패턴.

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

폴백 패턴은 **네트워크 실패에 대비**해 합성 데이터로 진행할 수 있게 한다.

</details>

---

## 2장 변수 타입의 두 세계 — 수치형과 범주형

![02 variable types](figs/02_variable_types.png)

<sub>그림 2-1. 수치형과 범주형의 차이 — 처리 방식이 완전히 다르다.</sub>

**개념 7.** 두 세계의 근본 차이:

- **수치형**: 값의 ____________________ 에 의미가 있음. 사칙연산이 가능. 통계량 자연스러움.
- **범주형**: 값은 ____________________ 일 뿐 크기는 무의미. 평균 ·표준편차 계산 불가.

<details><summary>▶ 정답 보기</summary>

크기(magnitude) / 라벨(label)

</details>

**개념 8.** pandas의 dtype 5종.

| dtype | 의미 | 결측치 가능? |
|---|---|---|
| `int64` | ____________________ | ____________________ |
| `float64` | ____________________ | ____________________ |
| `object` | ____________________ | 가능 |
| `bool` | 참/거짓 | 가능 |
| `datetime64` | 날짜/시간 | 가능 |


<details><summary>▶ 정답 보기</summary>

| dtype | 의미 | 결측치 가능? |
|---|---|---|
| `int64` | **정수** | **불가** |
| `float64` | **실수** | **가능** |
| `object` | **문자열** (또는 혼합) | 가능 |


</details>

**개념 9.** 위장된 범주형의 함정. Ames의 ____________________ 변수는 **숫자로 저장**되어 있지만 의미상 **주택 유형의 코드** 다. 60이 20의 ____________________ 가 아니다 — 둘 다 **라벨**일 뿐이다.

해결책: ____________________ 메서드로 명시적 ____________________ 변환.

<details><summary>▶ 정답 보기</summary>

MS SubClass / 3배 / astype(str) / 문자열(str)

</details>

**코드 빈칸.** 타입별 열 추출과 위장된 범주형 변환.

```python
# 수치형 열만
num_cols = ames.____(include="____").columns
print(f"수치형: {len(num_cols)}개")

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

## 3장 결측치와 이상치 — 데이터 마이닝의 두 함정

![03 missing outliers](figs/03_missing_outliers.png)

<sub>그림 3-1. Ames의 결측치 분포(왼쪽)와 Gr Liv Area의 이상치(오른쪽).</sub>

**개념 10.** 결측치의 세 종류:

| 종류 | 의미 | 처리 |
|---|---|---|
| (a) 진짜 결측 | ____________________ | 중앙값/평균으로 채움 |
| (b) 의미 있는 결측 | ____________________ | "None" 라벨 |
| (c) 변환된 결측 | 0이나 -999 같은 코드로 표현 | 도메인 지식 필요 |


<details><summary>▶ 정답 보기</summary>

| 종류 | 의미 |
|---|---|
| (a) 진짜 결측 | **측정 실패·기록 누락 등으로 값이 없음** |
| (b) 의미 있는 결측 | **값이 없는 것 자체가 정보** (예: 수영장 없음) |


</details>

**개념 11.** Ames의 결측치 상위 컬럼들(`Pool QC`, `Misc Feature`, `Alley` 등)은 모두 ____________________ 결측에 해당한다. 처리 방법은 ____________________ 라벨로 채우기다.

<details><summary>▶ 정답 보기</summary>

의미 있는(structural) / "None" 

</details>

**개념 12.** IQR 규칙은 **통계적 이상치 탐지**의 표준이다. $Q_1$, $Q_3$, IQR을 사용하여:

$$\text{이상치} \iff x < Q_1 - \_\_\_ \cdot \text{IQR} \quad \text{또는} \quad x > Q_3 + \_\_\_ \cdot \text{IQR}$$

<details><summary>▶ 정답 보기</summary>

1.5 / 1.5

</details>

**개념 13.** Ames의 **도메인 지식 컷오프**: ____________________ > ____________________ sq ft인 주택은 ____ 채뿐이며, **비공개 거래나 시장 비정상**이므로 분석에서 제외한다. 발견자 본인이 데이터 발표 논문에서 명시한 권장 컷오프다.

<details><summary>▶ 정답 보기</summary>

Gr Liv Area / 4000 / 5

</details>

**코드 빈칸.** 의미 있는 결측을 "None"으로 채우기.

```python
none_cols = ["Pool QC", "Misc Feature", "Alley", "Fence", "Fireplace Qu",
             "Garage Qual", "Garage Cond", "Bsmt Qual", "Bsmt Cond"]
for c in none_cols:
    if c in ames.columns:
        ames[c] = ames[c].____("____")

# 수치형 진짜 결측: 중앙값으로
num_cols = ames.select_dtypes("number").columns
ames[num_cols] = ames[num_cols].____(ames[num_cols].____())
```

<details><summary>▶ 정답 보기</summary>

```python
ames[c] = ames[c].fillna("None")
ames[num_cols] = ames[num_cols].fillna(ames[num_cols].median())
```

중앙값은 **평균보다 이상치에 강건**하므로 결측치 채우기의 표준이다.

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
| 한 변수의 분포 | **히스토그램·KDE·박스플롯** |
| 두 변수의 관계 | **산점도·상관계수** |
| 그룹별 비교 | **그룹별 박스플롯·바이올린플롯** |
| 다변수 관계 | **히트맵·페어플롯** |


</details>

**개념 2.** 히스토그램에서 읽는 **세 가지 신호**:

- **오른쪽 꼬리** (skewed right): ____________________ 변환 후보
- **이봉** (bimodal): ____________________ 가 있을 가능성
- **이상치**: 분포의 ____________________ 에 떨어진 점

<details><summary>▶ 정답 보기</summary>

로그(log) / 숨겨진 그룹 / 극단(extreme)

</details>

**그림 해석.** 그림 4-1의 (4) 히트맵에서 가장 강한 **음의 상관**을 가진 변수 쌍은? 그리고 그 의미는 무엇인가?

<details><summary>▶ 정답 보기</summary>

**sugars ↔ rating** (약 -0.76)

설탕이 많은 시리얼일수록 **Consumer Reports의 종합 평점이 낮다**. 영양 정보가 평점에 **직접 반영**되는 흥미로운 패턴이다.

</details>

**개념 3.** matplotlib와 seaborn의 차이:

- **matplotlib**: 가장 ____________________ 라이브러리, **세밀한 제어** 가능
- **seaborn**: matplotlib 위에 **____________________ 시각화**에 특화

<details><summary>▶ 정답 보기</summary>

기본적인(foundational) / 통계(statistical)

</details>

**코드 빈칸.** 그룹별 박스플롯 (Ames Overall Qual별 SalePrice).

```python
import seaborn as sns
fig, ax = plt.subplots(figsize=(10, 5))
sns.____(data=ames, x="Overall Qual", y="SalePrice", ax=ax)
ax.set_title("품질 등급별 판매 가격")
plt.show()
```

<details><summary>▶ 정답 보기</summary>

```python
sns.boxplot(data=ames, x="Overall Qual", y="SalePrice", ax=ax)
```

`boxplot` 외에도 `violinplot`, `stripplot`, `swarmplot` 등이 그룹 비교에 자주 쓰인다.

</details>

---

## 5장 변수 변환 — 로그·표준화·정규화

![05 log transform](figs/05_log_transform.png)

<sub>그림 5-1. 로그 변환의 효과 — 비대칭도가 1.74에서 거의 0으로 줄어든다.</sub>

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
| 선형회귀 | **필요** (잔차 정규성 가정) |
| 신경망 | **필요** (학습 안정성) |
| kNN, SVM | **필요** (공정한 거리) |
| 트리 기반 | **불필요** (분할 기준은 순위만 봄) |


</details>

**개념 5.** 로그 변환 — Ames `SalePrice`의 비대칭도는 약 ____________________ (오른쪽 꼬리). 로그 변환 후에는 약 ____________________ (정규에 가까움). 사용 함수는 `np.____`, 역변환은 `np.____`이다.

<details><summary>▶ 정답 보기</summary>

1.74 / 0.0 (또는 -0.01) / log1p / expm1

</details>

**개념 6.** `np.log1p(x)` = `np.log(____)`. 왜 `np.log` 대신 `np.log1p`를 쓰나? `log(0) = ____________________` 이 되어 **연산이 깨지지만** `log1p(0) = ____` 으로 안전하다.

<details><summary>▶ 정답 보기</summary>

1 + x / -∞ (음의 무한대) / 0

</details>

**개념 7.** 표준화와 정규화의 차이:

|  | 표준화 (Z-score) | 정규화 (Min-Max) |
|---|---|---|
| 식 | $(x - \mu)/\sigma$ | ____________________ |
| 변환 후 평균 | ____ | (사용자 선택, 보통 0.5) |
| 변환 후 범위 | (정해진 범위 없음) | ____________________ |
| sklearn 클래스 | `StandardScaler` | `____________________` |


<details><summary>▶ 정답 보기</summary>

|  | 정규화 (Min-Max) |
|---|---|
| 식 | $(x - \min(x))/(\max(x) - \min(x))$ |
| 변환 후 평균 | (정해지지 않음) |
| 변환 후 범위 | **[0, 1]** |
| sklearn 클래스 | **MinMaxScaler** |

표준화의 변환 후 평균은 **0**, 표준편차는 1이다.

</details>

**개념 8.** 전처리 파이프라인의 **권장 순서**는?

1. ____________________ 처리
2. ____________________ 처리
3. ____________________ 변환 (오른쪽 꼬리 정리)
4. ____________________ 적용 (평균 0, 표준편차 1)

<details><summary>▶ 정답 보기</summary>

1. 결측치
2. 이상치
3. 로그
4. 표준화

이 순서는 **각 단계가 다음 단계의 통계량 계산을 깨지 않기 위해서**다.

</details>

**코드 빈칸.** 표준화 적용.

```python
from sklearn.preprocessing import StandardScaler

scaler = ____________________()
X_scaled = scaler.____(ames[num_cols])
print(f"평균: {X_scaled.____(axis=0)[:3]}")    # [0, 0, 0]
print(f"표준편차: {X_scaled.____(axis=0)[:3]}")  # [1, 1, 1]
```

<details><summary>▶ 정답 보기</summary>

```python
scaler = StandardScaler()
X_scaled = scaler.fit_transform(ames[num_cols])
X_scaled.mean(axis=0)
X_scaled.std(axis=0)
```

`fit_transform` = `fit` + `transform`. 검증 데이터에는 `transform`만 호출한다 (학습 데이터의 통계를 사용).

</details>

---

## 6장 범주형 인코딩 — 라벨과 원-핫

![06 encoding comparison](figs/06_encoding_comparison.png)

<sub>그림 6-1. 범주형 인코딩 — 라벨 vs 원-핫.</sub>

**개념 9.** 두 인코딩의 차이:

| | 라벨 인코딩 | 원-핫 인코딩 |
|---|---|---|
| 만들어지는 컬럼 수 | ____________________ | ____________________ (K = 범주값 수) |
| 값에 순서 의미? | ____________________ | ____________________ |
| 메모리 효율 | 높음 | ____________________ |
| 안전한 모델 | ____________________ | ____________________ |


<details><summary>▶ 정답 보기</summary>

| | 라벨 | 원-핫 |
|---|---|---|
| 컬럼 수 | **1개** | **K개** |
| 순서 의미 | **있음 (위험)** | **없음 (안전)** |
| 메모리 | 높음 | **낮음** (차원 증가) |
| 안전한 모델 | **트리 기반만** | **모든 모델** |


</details>

**개념 10.** `pd.get_dummies(df, drop_first=True)` 옵션의 효과 — K개 컬럼 중 ____________________ 개만 만들어 ____________________ 을 회피한다. 선형회귀에서 **반드시** 필요한 옵션이다.

<details><summary>▶ 정답 보기</summary>

K-1 / 다중공선성(multicollinearity)

</details>

**개념 11.** 모델별 권장 인코딩.

| 모델 | 권장 인코딩 |
|---|---|
| 선형회귀·릴리지·로지스틱 | ____________________ |
| 신경망 | ____________________ |
| 트리 기반 (RF·GBM·XGBoost) | ____________________ |
| **CatBoost** (특별 케이스) | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 모델 | 권장 인코딩 |
|---|---|
| 선형회귀 등 | **원-핫 (drop_first=True)** |
| 신경망 | **원-핫** |
| 트리 기반 | **라벨 또는 원-핫 (둘 다 안전)** |
| CatBoost | **인코딩 안 함** (자동 처리, 6부에서 다룸) |


</details>

**코드 빈칸.** Cereals 범주형 인코딩.

```python
# name은 유일 식별자라 제거
cereal_X = cereal.____(columns=["name", "rating"])

# mfr, type을 원-핫 (drop_first로 다중공선성 회피)
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

## 7장 그룹별 집계 — groupby와 split-apply-combine

![07 groupby sac](figs/07_groupby_sac.png)

<sub>그림 7-1. groupby의 split-apply-combine 세 단계.</sub>

**개념 1.** groupby의 세 단계와 각각이 하는 일:

| 단계 | 영문 이름 | 하는 일 |
|---|---|---|
| 1 | ____________________ | 데이터를 그룹화 키로 나눈다 |
| 2 | ____________________ | 각 그룹에 같은 함수를 적용한다 |
| 3 | ____________________ | 결과를 한 표로 결합한다 |


<details><summary>▶ 정답 보기</summary>

| 단계 | 영문 이름 |
|---|---|
| 1 | **Split** (분할) |
| 2 | **Apply** (적용/집계) |
| 3 | **Combine** (결합) |


</details>

**개념 2.** 가장 단순한 groupby — Cereals 제조사별 평균 칼로리.

```python
result = cereal.____("mfr")["calories"].____()
```

`groupby("mfr")`이 ____________________ 단계, `["calories"].mean()`이 ____________________ 단계, **결과 출력**이 ____________________ 단계다.

<details><summary>▶ 정답 보기</summary>

```python
result = cereal.groupby("mfr")["calories"].mean()
```

분할 / 적용 / 결합

</details>

**개념 3.** `agg`와 `transform`의 차이:

- **`agg`**: 결과가 **그룹별 한 행**. 그룹 수만큼 행을 가진 **압축된 표**.
- **`transform`**: 결과가 **원본과 같은 크기**. 각 행에 **그 행이 속한 그룹의 통계**가 채워짐.

<details><summary>▶ 정답 보기</summary>

압축된 / 원본과 같은

`agg`는 **그룹별 요약표**를 만들 때, `transform`은 **그룹 정보를 행 수준으로 사용**할 때 쓴다. 예: 동네별 평균을 **원본 모든 행**에 붙이려면 `transform`.

</details>

**코드 빈칸.** Cereals에서 제조사별 다중 집계.

```python
agg_result = cereal.groupby("mfr")["calories"].____(
    ["mean", "____", "min", "max", "count"]
).round(1)
```

<details><summary>▶ 정답 보기</summary>

```python
agg_result = cereal.groupby("mfr")["calories"].agg(
    ["mean", "std", "min", "max", "count"]
).round(1)
```

각 그룹에 대해 평균·표준편차·최소·최대·개수가 한 표에 들어간다.

</details>

**개념 4.** `transform`의 사용 예 — Ames에서 **동네별 평균 가격**을 **원본 모든 행**에 붙이기.

```python
ames["NbhdMeanPrice"] = ames.groupby("Neighborhood")["SalePrice"].____("____")
```

<details><summary>▶ 정답 보기</summary>

```python
ames["NbhdMeanPrice"] = ames.groupby("Neighborhood")["SalePrice"].transform("mean")
```

결과는 **원본과 같은 행 수**. 각 주택에 **그 동네의 평균 가격**이 채워진다. 8장의 특성 공학에서 매우 유용하다.

</details>

**개념 5.** `pivot_table`은 ____________________ 두 방향으로 그룹화한다. 엑셀의 ____________________ 와 같다.

<details><summary>▶ 정답 보기</summary>

행과 열 / 피벗 테이블

</details>

---

## 8장 특성 공학 — 도메인 지식을 변수로

![08 feature engineering](figs/08_feature_engineering.png)

<sub>그림 8-1. 특성 공학의 효과 — 셋을 합쳐 더 강한 변수 한 개를 만든다.</sub>

**개념 6.** 특성 공학의 본질 — **세상에 대한** ____________________ 을 **변수의 형태로 모델에 전달**한다.

<details><summary>▶ 정답 보기</summary>

도메인 지식(domain knowledge)

</details>

**그림 해석.** 그림 8-1에서:

- 원본 세 변수(`1st Flr SF`, `2nd Flr SF`, `Total Bsmt SF`)와 `SalePrice`의 평균 |상관계수|: 약 ____________________
- 셋을 합쳐 만든 `Total SF`와 `SalePrice`의 상관계수: 약 ____________________

이는 **세상의 지식** ("주택 가격은 ____________________ 에 비례한다")이 **데이터에서 더 강한 신호**를 만들어 낸 결과다.

<details><summary>▶ 정답 보기</summary>

0.4~0.6 / 0.81 / 총 면적(total area)

</details>

**개념 7.** Ames의 표준 특성 공학 변수 4가지:

| 새 변수 | 식 | 의미 |
|---|---|---|
| Total SF | ____________________ | 총 면적 |
| Total Bath | Full + 0.5 × Half + Bsmt Full + 0.5 × Bsmt Half | 총 화장실 수 |
| HouseAge | ____________________ | 판매 시점의 집 나이 |
| YearsSinceRemodel | ____________________ | 리모델링 후 시간 |


<details><summary>▶ 정답 보기</summary>

| 새 변수 | 식 |
|---|---|
| Total SF | **1st Flr SF + 2nd Flr SF + Total Bsmt SF** |
| HouseAge | **Yr Sold - Year Built** |
| YearsSinceRemodel | **Yr Sold - Year Remod/Add** |


</details>

**개념 8.** 도메인 지식 변환의 세 가지 패턴:

(1) ____________________ 변수: 두 변수의 비율이 더 의미 있을 때 (예: BsmtRatio = 지하 / 전체)
(2) ____________________ 차이 변수: 두 날짜의 차이 (예: HouseAge)
(3) ____________________ 플래그 변수: 조건의 만족 여부 (예: HasPool = (Pool Area > 0).astype(int))

<details><summary>▶ 정답 보기</summary>

(1) 비율(ratio)
(2) 시간(time)
(3) 이진(binary)

</details>

**개념 9.** 상호작용항이란? — 두 변수의 ____________________ 으로 만든 새 변수. **각 변수 단독보다 강한 신호**를 줄 수 있다.

예: Ames에서 ____________________ × ____________________ = Qual_Area. 두 원본 변수의 상관계수는 각각 0.80, 0.71인데 그들의 **곱**은 약 0.85+ 가 나온다.

<details><summary>▶ 정답 보기</summary>

곱(product) / Overall Qual / Gr Liv Area

</details>

**코드 빈칸.** Ames의 표준 특성 공학.

```python
# Total SF
ames["Total SF"] = ames["1st Flr SF"] + ames["____________________"] + ames["____________________"]

# Total Bath
ames["Total Bath"] = (ames["Full Bath"] + ____ * ames["Half Bath"]
                      + ames["Bsmt Full Bath"] + ____ * ames["Bsmt Half Bath"])

# HouseAge
ames["HouseAge"] = ames["____________________"] - ames["____________________"]

# 이진 플래그
ames["HasPool"] = (ames["Pool Area"] > 0).____(int)
```

<details><summary>▶ 정답 보기</summary>

```python
ames["Total SF"] = ames["1st Flr SF"] + ames["2nd Flr SF"] + ames["Total Bsmt SF"]
ames["Total Bath"] = (ames["Full Bath"] + 0.5 * ames["Half Bath"]
                      + ames["Bsmt Full Bath"] + 0.5 * ames["Bsmt Half Bath"])
ames["HouseAge"] = ames["Yr Sold"] - ames["Year Built"]
ames["HasPool"] = (ames["Pool Area"] > 0).astype(int)
```

</details>

**개념 10.** 특성 공학을 잘하는 사람의 **세 가지 습관**:

1. ____________________ 와 대화한다
2. ____________________ 를 충분히 한다 (시각화로 데이터의 패턴 파악)
3. ____________________ 모델로 새 변수 검증 (선형회귀나 단일 트리)

<details><summary>▶ 정답 보기</summary>

1. 도메인 전문가
2. EDA (탐색적 데이터 분석)
3. 간단한(simple)

</details>

---

## 응용 문제 — 직접 실행하며 풀기

각 문제의 코드를 실행하여 출력을 직접 확인한 뒤 정답 토글로 비교한다.

**문제 1.** Cereals 데이터의 모든 결측치를 **중앙값**으로 채운 뒤 결측 합계가 0인지 확인하라.

<details><summary>▶ 정답 보기</summary>

```python
import pandas as pd

URL = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/Cereals.csv"
cereal = pd.read_csv(URL)

print("결측 전:")
print(cereal.isnull().sum()[cereal.isnull().sum() > 0])

num_cols = cereal.select_dtypes("number").columns
cereal[num_cols] = cereal[num_cols].fillna(cereal[num_cols].median())

print(f"\n결측 합계: {cereal.isnull().sum().sum()}")   # 0
```

원본 결측: `carbo` 1, `sugars` 1, `potass` 2. 채운 후 모든 수치형이 결측 없는 상태.

</details>

**문제 2.** Ames의 `SalePrice`를 로그 변환하고 **비대칭도가 얼마나 바뀌는지** 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
import numpy as np

raw_skew = ames["SalePrice"].skew()
log_skew = np.log1p(ames["SalePrice"]).skew()

print(f"원본 비대칭도:    {raw_skew:.3f}")    # 약 1.74
print(f"로그 변환 후:    {log_skew:.3f}")    # 약 -0.01
print(f"개선 폭:        {raw_skew - log_skew:.3f}")
```

원본 1.74에서 거의 0으로 — **정규분포에 매우 가까워진다**. 선형회귀의 잔차 가정에 적합해진다.

</details>

**문제 3.** Cereals에서 **제조사별로 평균 칼로리·평균 평점·시리얼 개수**를 한 표로 만들어라.

<details><summary>▶ 정답 보기</summary>

```python
mfr_stats = cereal.groupby("mfr").agg(
    calories=("calories", "mean"),
    rating=("rating", "mean"),
    count=("name", "count"),
).round(2).sort_values("rating", ascending=False)

print(mfr_stats)
```

평점이 가장 높은 제조사는 보통 **N(Nabisco)**, 낮은 쪽은 **K(Kellogg's)** 나 **G(General Mills)**. 시리얼 개수는 K가 가장 많다 (23개).

</details>

**문제 4.** Cereals에서 4가지 새 특성을 만들어라.

- ProteinDensity = protein / calories
- IsSweet = 1 if sugars >= 10 else 0
- NutritionScore = 2·protein + 1.5·fiber - fat - sugars
- FatRatio = fat / (calories / 100)  ← 단위 칼로리당 지방

<details><summary>▶ 정답 보기</summary>

```python
cereal["ProteinDensity"] = cereal["protein"] / cereal["calories"]
cereal["IsSweet"] = (cereal["sugars"] >= 10).astype(int)
cereal["NutritionScore"] = (2 * cereal["protein"] + 1.5 * cereal["fiber"]
                            - cereal["fat"] - cereal["sugars"])
cereal["FatRatio"] = cereal["fat"] / (cereal["calories"] / 100)

# rating과의 상관계수
for c in ["ProteinDensity", "IsSweet", "NutritionScore", "FatRatio"]:
    r = cereal[[c, "rating"]].corr().iloc[0, 1]
    print(f"  {c:<18s}  r = {r:+.3f}")
```

**NutritionScore**가 가장 강한 상관(약 +0.85). 영양학 도메인 지식이 **예측에 직접 도움**이 됨을 한 표로 확인.

</details>

**문제 5.** Ames의 데이터 전체 전처리 파이프라인 (1~6단계) 한 함수로.

<details><summary>▶ 정답 보기</summary>

```python
def prepare_ames(df_in):
    df = df_in.copy()
    
    # 1. ID 컬럼 제거
    df = df.drop(columns=[c for c in ["Order", "PID"] if c in df.columns])
    
    # 2. 의미 있는 결측을 "None"으로
    none_cols = ["Pool QC", "Misc Feature", "Alley", "Fence", "Fireplace Qu",
                 "Garage Qual", "Garage Cond", "Garage Finish", "Garage Type",
                 "Bsmt Qual", "Bsmt Cond", "Bsmt Exposure",
                 "BsmtFin Type 1", "BsmtFin Type 2", "Mas Vnr Type"]
    for c in none_cols:
        if c in df.columns:
            df[c] = df[c].fillna("None")
    
    # 3. 수치형 결측을 중앙값으로
    num_cols = df.select_dtypes("number").columns
    df[num_cols] = df[num_cols].fillna(df[num_cols].median())
    
    # 4. 이상치 제거 (Gr Liv Area > 4000)
    if "Gr Liv Area" in df.columns:
        df = df[df["Gr Liv Area"] < 4000].copy()
    
    # 5. 특성 공학 (Total SF)
    if all(c in df.columns for c in ["1st Flr SF", "2nd Flr SF", "Total Bsmt SF"]):
        df["Total SF"] = df["1st Flr SF"] + df["2nd Flr SF"] + df["Total Bsmt SF"]
    
    # 6. 위장된 범주형 변환
    if "MS SubClass" in df.columns:
        df["MS SubClass"] = df["MS SubClass"].astype(str)
    
    return df

ames_clean = prepare_ames(ames)
print(f"전처리 후: {ames_clean.shape}")
print(f"결측 합계: {ames_clean.isnull().sum().sum()}")
```

이 함수가 **2~5부 모든 코드의 출발점**이다. 이론 교재 표지에 그대로 들어 있다.

</details>

---

## 다음 부 예고 — 2부 결정 트리 심화

다음 부는 **2부 결정 트리 심화**다. 3부에서 트리의 **기초**(불순도·분기·가지치기)를 먼저 다루고, 2부에서 **심화** 주제를 다룬다 — 시리즈 구조의 특이점이다.

미리 던지는 질문 — Ames의 약 80개 변수 중 **결정 트리가 처음으로 분기**하는 변수는 무엇일까?

<details><summary>▶ 정답 보기</summary>

거의 항상 **Overall Qual** 또는 **Total SF**다. 두 변수가 가격에 대한 **가장 강한 신호**이기 때문이다.

다음 부에서는 **왜** 트리가 이 변수를 우선 고르는지, **어떤 임계값**에서 분할하는지, 그리고 **분할 후 어떤 부분 트리**가 만들어지는지를 **알고리즘 수준**에서 본다.

</details>
