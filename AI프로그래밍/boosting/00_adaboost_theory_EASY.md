# 4부 AdaBoost — 부스팅의 시조

## 쉬운 버전 — 그림으로 이해하기

본 자료는 AdaBoost를 그림과 직관 위주로 풀어쓴 입문 교재이다. 복잡한 수식 없이도 **왜 약학습기를 누적하면 강한 모델이 되는지**, **왜 캘리포니아 데이터에서는 AdaBoost가 실패하는지** 를 따라갈 수 있다. 어려운 버전과 같은 0~8장 구조를 따르며, 같은 Ames 주택가격 데이터와 캘리포니아 주택가격 데이터를 사용한다.

```python
# 환경 준비 (한 번만 실행)
# !pip install pandas numpy matplotlib scikit-learn koreanize-matplotlib

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import koreanize_matplotlib

URL_AMES = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/AmesHousing.csv"
URL_CAL = "https://raw.githubusercontent.com/ageron/handson-ml2/master/datasets/housing/housing.csv"

df_ames_raw = pd.read_csv(URL_AMES)
df_cal_raw = pd.read_csv(URL_CAL)
print(f"Ames: {df_ames_raw.shape}, California: {df_cal_raw.shape}")
```

전처리도 3부와 같은 표준 패턴이다.

```python
def prepare_ames(df_in):
    df = df_in.copy()
    df = df.drop(columns=[c for c in ["Order", "PID"] if c in df.columns])
    none_cols = ["Pool QC", "Misc Feature", "Alley", "Fence", "Fireplace Qu",
                 "Garage Qual", "Garage Cond", "Garage Finish", "Garage Type",
                 "Bsmt Qual", "Bsmt Cond", "Bsmt Exposure",
                 "BsmtFin Type 1", "BsmtFin Type 2", "Mas Vnr Type"]
    for c in none_cols:
        if c in df.columns:
            df[c] = df[c].fillna("None")
    num_cols = df.select_dtypes("number").columns
    df[num_cols] = df[num_cols].fillna(df[num_cols].median())
    if "Gr Liv Area" in df.columns:
        df = df[df["Gr Liv Area"] < 4000].copy()
    if all(c in df.columns for c in ["1st Flr SF", "2nd Flr SF", "Total Bsmt SF"]):
        df["Total SF"] = df["1st Flr SF"] + df["2nd Flr SF"] + df["Total Bsmt SF"]
    return df

def prepare_california(df_in):
    df = df_in.copy()
    df["total_bedrooms"] = df["total_bedrooms"].fillna(df["total_bedrooms"].median())
    df = pd.get_dummies(df, columns=["ocean_proximity"], drop_first=True)
    return df

df_ames = prepare_ames(df_ames_raw)
y_ames = np.log1p(df_ames["SalePrice"])
X_ames = df_ames.select_dtypes("number").drop(columns=["SalePrice"])

df_cal = prepare_california(df_cal_raw)
y_cal = df_cal["median_house_value"].values
X_cal = df_cal.drop(columns=["median_house_value"]).values
print(f"Ames 전처리: {X_ames.shape}")
print(f"California 전처리: {X_cal.shape}")
```

두 데이터셋이 4부의 **핵심 대조 실험**에 사용된다. Ames에서는 AdaBoost가 그럭저럭 작동하고, 캘리포니아에서는 처참하게 실패한다. 그 차이의 이유가 7~8장의 주요 발견이다.

---

## 0장 분산 감소에서 편향 감소로 — 부스팅의 정신

### 0.1 3부의 한계가 4부의 시작이다

3부 마지막에서 **랜덤 포레스트가 더 이상 R²를 못 올린다**는 결론을 봤다. Ames에서 RF 100그루로 R² 약 0.88인데, 300그루로 늘려도 거의 같다. 트리들이 서로 어느 정도 닮아서 **분산이 더 안 줄어드는 한계** 에 부딪힌 것이다.

남은 R² 격차는 **분산** 이 아니라 다른 곳에서 온다. **편향**이다. 트리 한 그루가 **충분히 깊이 자라도** 잡지 못하는 패턴이 있고, 그 패턴은 100그루를 평균내도 잡히지 않는다.

이를 해결하는 **정반대 전략**이 부스팅이다. 한 줄로 말하면 — **트리를 한 그루씩 순서대로 키우면서, 앞선 트리들이 잡지 못한 패턴을 다음 트리가 보정한다**. 배깅이 **서로 모르는 채점관들의 평균**이라면, 부스팅은 **앞 사람의 오답을 받아 그 부분만 고치는 학생들의 줄**이다.

### 0.2 두 철학을 한 장으로 비교하기

![01 bagging vs boosting](figs/01_bagging_vs_boosting.png)

<sub>그림 0-1. 배깅과 부스팅의 정반대 철학. 왼쪽 배깅에서는 각 트리가 서로의 존재를 모른 채 병렬로 학습되고, 마지막에 예측을 평균낸다. 오른쪽 부스팅에서는 트리 1이 먼저 학습되고, 트리 1의 오답이 트리 2의 학습 신호가 된다. 트리들이 한 줄로 서서 순차적으로 보정해 나간다.</sub>

두 방법의 차이를 표로 정리하면 다음과 같다.

| 구분 | 배깅 (랜덤 포레스트) | 부스팅 (AdaBoost 등) |
|---|---|---|
| 트리 키우는 방식 | 여러 그루를 독립적으로 키워 평균 | 한 그루씩 순서대로 키워 누적 |
| 비유 | 서로 모르는 채점관들의 평균 | 앞 사람의 오답을 고치는 학생들의 줄 |
| 줄이는 오차 | **분산** | **편향** |
| 트리 깊이 권장값 | 깊게 (개별 트리 강화) | 얕게 (단순 약학습기를 누적) |
| 병렬 처리 | 가능 | 불가능 |

특히 **트리 깊이**가 정반대로 권장된다는 점이 흥미롭다. 배깅은 **깊은 트리 100그루를 평균**해 분산을 줄이는 전략이고, 부스팅은 **얕은 트리 100그루를 누적**해 편향을 줄이는 전략이다. 같은 트리 도구를 정반대로 활용한다.

### 0.3 약학습기 — 부스팅의 빌딩 블록

부스팅의 빌딩 블록을 **약학습기**(weak learner)라 부른다. **무작위 예측보다 약간 나은 정도**의 단순한 모델이다. AdaBoost에서 가장 흔히 쓰이는 약학습기는 **깊이 1짜리 결정 트리** — 단 한 번의 질문으로 답을 내는 **결정 그루터기**(decision stump)다.

결정 그루터기는 매우 약한 모델이다. 단독으로는 R² 약 0.45 — 선형회귀의 절반 수준이다. 그런데 이런 약학습기를 50~100개 **누적**하면 R²가 0.80 이상으로 점프한다. 이게 AdaBoost의 마법이다.

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score

stump = DecisionTreeRegressor(max_depth=1, random_state=42)
normal = DecisionTreeRegressor(max_depth=10, random_state=42)

r2_stump = cross_val_score(stump, X_ames, y_ames, cv=5, scoring="r2").mean()
r2_normal = cross_val_score(normal, X_ames, y_ames, cv=5, scoring="r2").mean()

print(f"결정 그루터기 (depth=1):  R² = {r2_stump:.4f}")
print(f"보통 트리     (depth=10): R² = {r2_normal:.4f}")
```

### 0.4 가족의 시조 — AdaBoost

![08 boosting lineage](figs/08_boosting_lineage.png)

<sub>그림 0-2. 부스팅 가족의 진화. AdaBoost(1995)가 가족의 시조이며, GBM(2001)이 그 손실함수를 일반화했다. GBM의 현대적 구현 세 가지가 XGBoost·LightGBM·CatBoost이다.</sub>

**AdaBoost**(Adaptive Boosting)는 1995년 Yoav Freund와 Robert Schapire가 발표한 부스팅 가족의 시조다. 머신러닝 학계에 충격을 주었고, **왜 약학습기를 누적해도 성능이 좋아지는가** 라는 이론적 질문을 만들어 냈다.

2001년 Friedman이 AdaBoost를 **경사 부스팅**(Gradient Boosting Machine, GBM)으로 일반화했고, 그 GBM이 현대 산업의 표준이 된 XGBoost·LightGBM·CatBoost로 발전했다. 4부에서는 가족의 시조인 AdaBoost를 끝까지 따라가며 다음 세 가지를 본다.

1. **가중치 갱신** — 어떻게 다음 트리가 앞의 오답을 보정하는가 (1~3장)
2. **두 변종 비교** — 분류용 M1 vs 회귀용 R2 (4장)
3. **Ames vs 캘리포니아** — 데이터에 따라 AdaBoost가 **왜** 천차만별인가 (6~8장)

마지막 8장에서 AdaBoost의 약점이 어떻게 5부 GBM의 동기가 되는지를 짚는다.

---

## 1장 가중치 갱신 — 다음 트리가 무엇을 보고 학습하나

### 1.1 핵심 아이디어 — 샘플마다 가중치를 둔다

AdaBoost의 핵심 아이디어는 **학습 샘플마다 가중치**를 두는 것이다. 처음에는 모든 샘플이 같은 가중치를 갖는다. 첫 약학습기를 학습한 뒤, **틀린 샘플의 가중치는 올리고 맞은 샘플의 가중치는 내린다**. 두 번째 약학습기는 이 새 가중치로 학습한다 — 즉 **틀린 샘플을 더 중요하게** 본다.

이 사이클을 한 그림으로 보면 다음과 같다.

![02 weight update](figs/02_weight_update.png)

<sub>그림 1-1. AdaBoost의 가중치 갱신 한 사이클. (1단계) 모든 샘플이 같은 가중치, 첫 약학습기가 분할 t=5에서 분류. 두 개의 오답 발생. (2단계) 오답 두 샘플의 가중치가 부풀어 오르고, 정답 샘플들의 가중치는 줄어든다. (3단계) 새 가중치로 두 번째 약학습기 학습. 오답을 더 신경 쓴 새 분할 t=4가 선택된다.</sub>

그림에서 **점 크기가 곧 가중치**다. 1단계에서 모든 점이 같은 크기로 시작하지만, 2단계에서 오답 두 점이 크게 부풀어 오른다. 그 크기 차이가 **두 번째 약학습기의 분할 결정**에 영향을 준다. 결과적으로 분할 위치가 t=5에서 t=4로 옮겨 가, **오답이었던 샘플을 더 잘 잡는다**.

### 1.2 가중치 갱신의 직관 — 세 줄로

수식 없이 직관만 정리하면 세 줄이다.

- **오답 샘플**: 가중치가 **부풀어 오른다**. 다음 라운드에서 더 중요하게 학습된다.
- **정답 샘플**: 가중치가 **줄어든다**. 다음 라운드에서 덜 중요하게 학습된다.
- **정규화**: 모든 가중치의 합이 1이 되도록 다시 맞춘다.

이 세 단계가 **오답 강조**의 정확한 메커니즘이다. 매 라운드마다 모델이 **지난 라운드에서 못 잡은 부분**에 더 신경을 쓴다.

### 1.3 약학습기 가중치 — 잘 맞춘 약학습기가 더 큰 권력

![04 alpha curve](figs/04_alpha_curve.png)

<sub>그림 1-2. 약학습기 가중치 α는 그 학습기의 오차율에 따라 결정된다. 오차율이 낮으면(잘 맞춘 약학습기) α가 크고, 오차율 0.5(무작위 수준)이면 α는 0이다. 즉 무작위 수준 약학습기는 최종 결과에 영향을 못 미친다.</sub>

각 약학습기는 **자기 자신의 가중치 α** 도 받는다. 이 가중치는 **그 약학습기가 얼마나 잘 맞췄는가** 에 따라 결정된다.

- **잘 맞춘 약학습기** (오차율 낮음): α가 크다. 최종 결정에 **큰 권력**을 갖는다.
- **무작위 수준 약학습기** (오차율 0.5): α = 0. 영향력이 **없다**.
- **무작위보다 나쁜 약학습기** (오차율 > 0.5): α가 음수. 예측을 **반대로** 사용한다.

이게 AdaBoost의 **자기 가중치** 메커니즘이다. **잘 맞춘 약학습기일수록 큰 영향력을 갖는다**. 보통의 다수결이 **한 사람 한 표**라면, AdaBoost는 **전문가의 표가 더 무겁다**.

### 1.4 왜 이상치가 위험할 신호인가

가중치 갱신이 **오답을 강조**하는 메커니즘은 잘 작동하지만, **함정** 도 있다. 만약 어떤 샘플이 **진짜로 잡을 수 없는 잡음** 이거나 **이상치** 라면 어떻게 될까?

그 샘플은 **영원히 오답** 으로 남는다. 매 라운드마다 가중치가 부풀어 오르고, 다음 약학습기가 그 샘플에 더 신경을 쓰지만 **진짜 정보가 없으므로 맞출 수가 없다**. 결국 **진짜 신호에서 멀어지고 잡음에 끌려가는** 상황이 된다.

이게 7장에서 본격적으로 다룰 **캘리포니아 데이터 실패**의 정확한 원인이다. 일단 이런 위험이 **존재한다** 는 사실만 기억해 두자.

---

## 2장 약학습기의 누적 — 결정 경계가 어떻게 정교해지나

### 2.1 단순한 모델의 합이 복잡한 모델을 만든다

가중치 갱신이 한 라운드의 메커니즘이라면, **여러 라운드를 누적** 하면 무슨 일이 일어날까? 각 약학습기가 결정 그루터기(깊이 1)라면 각 학습기의 결정 경계는 **직선 한 줄** 뿐이다. 그러나 직선 100개를 **가중 합** 하면 매우 복잡한 곡선 경계도 표현할 수 있다.

![03 boundary evolution](figs/03_boundary_evolution.png)

<sub>그림 2-1. AdaBoost의 누적 과정. 트리 1개일 때는 직선 한 줄이 결정 경계의 전부다. 트리 5개에서는 약간 굽은 경계, 트리 20개에서는 초승달 모양을 따라가는 경계, 트리 100개에서는 매우 정교한 경계가 만들어진다.</sub>

트리 1개에서 100개로 늘어가는 동안 결정 경계가 **점점 더 정교해진다**. 각 약학습기는 단순한 직선이지만, 가중 합의 효과로 복잡한 곡선을 만들어 낸다. 이게 부스팅의 핵심 통찰이다.

> **단순한 모델 여러 개의 가중 합이 복잡한 모델 하나의 효과를 낸다.**

### 2.2 최종 예측 — 가중 다수결

분류에서 AdaBoost의 최종 예측은 **모든 약학습기의 가중 다수결** 이다. 각 약학습기가 **자기 의견**과 **자기 가중치 α**를 들고 투표에 참여한다. **큰 α를 가진 약학습기**의 의견이 더 큰 영향력을 갖는다.

회귀에서는 **가중 평균** 대신 **가중 중앙값**을 쓴다. 평균은 이상치에 끌려가지만 중앙값은 그렇지 않다. 회귀의 이상치 문제를 의식한 선택이지만, 7장에서 보겠지만 **완전히 막지는 못한다**.

### 2.3 직접 실험 — 약학습기 수에 따른 정확도

sklearn으로 약학습기 수를 늘려가며 성능 변화를 확인할 수 있다.

```python
from sklearn.ensemble import AdaBoostClassifier
from sklearn.datasets import make_moons
from sklearn.model_selection import cross_val_score

X_moon, y_moon = make_moons(n_samples=500, noise=0.25, random_state=42)

print(f"{'약학습기 수':>10s}  {'정확도':>10s}")
print("-" * 25)
for n in [1, 5, 10, 50, 100, 200]:
    clf = AdaBoostClassifier(n_estimators=n, random_state=42)
    acc = cross_val_score(clf, X_moon, y_moon, cv=5, scoring="accuracy").mean()
    print(f"{n:>10d}  {acc:>10.4f}")
```

실행하면 트리 1개에서 약 0.80, 100개에서 약 0.95 이상으로 점프한다. 단순한 결정 그루터기 한 개로는 초승달 모양을 못 잡지만 100개 누적으로 매우 정교하게 잡는다.

### 2.4 약학습기의 가중치 들여다보기

학습이 끝난 AdaBoost 모델에서 각 약학습기의 가중치 α를 직접 볼 수 있다.

```python
from sklearn.ensemble import AdaBoostClassifier

clf = AdaBoostClassifier(n_estimators=50, random_state=42)
clf.fit(X_moon, y_moon)

alphas = clf.estimator_weights_     # 각 약학습기의 α
errors = clf.estimator_errors_       # 각 약학습기의 오차율

print(f"α 최댓값:    {alphas.max():.4f}  (가장 신뢰도 높은 약학습기)")
print(f"α 평균:      {alphas.mean():.4f}")
print(f"오차율 평균: {errors.mean():.4f}")
```

학습이 진행될수록 약학습기의 오차율이 **0.5에 가까워진다**. 이는 **남은 오답 샘플이 점점 어려운 샘플들** 이기 때문이다. 후반의 약학습기들은 작은 α를 갖지만, 그래도 **어려운 샘플의 분류에 결정적**이다.

---

## 3장 AdaBoost.R2 — 회귀로의 확장

### 3.1 분류와 회귀는 무엇이 다른가

1·2장에서 본 AdaBoost는 **이진 분류** 용 알고리즘이다. 분류에서는 **맞았나 틀렸나**가 명확하다. 그러나 **회귀** 에서는 예측이 **얼마만큼 빗나갔는지**가 연속적인 값이다. 가격 18만 달러를 17만으로 예측한 것과 12만으로 예측한 것이 다르다.

이 차이를 받아들이려면 가중치 갱신도 **연속적 손실**을 받아들이도록 바뀌어야 한다. 1997년 Drucker가 제안한 **AdaBoost.R2** 가 회귀로의 확장이다.

### 3.2 R2의 핵심 변경 — 세 가지

AdaBoost.R2가 분류의 AdaBoost.M1과 다른 점은 세 가지다.

**변경 1 — 손실 측정**. 각 샘플의 손실을 **0과 1 사이의 값**으로 정규화한다. 절대 오차를 그 라운드의 최대 오차로 나눈 값이다. 예측이 거의 맞았으면 손실이 0에 가깝고, 가장 크게 빗나간 샘플은 손실이 1이다.

**변경 2 — 약학습기 평가**. 가중 평균 손실로 그 약학습기의 **전체 성능**을 평가한다. 평균 손실이 작을수록 좋은 약학습기다.

**변경 3 — 가중치 갱신**. 손실이 작은 샘플은 가중치가 **크게 줄어들고**, 손실이 큰 샘플은 가중치가 **거의 그대로 유지**된다. 분류와 같은 방향 — **어려운 샘플의 가중치 상대적으로 부풀어 오른다**.

### 3.3 최종 예측 — 가중 중앙값

분류의 가중 다수결에 해당하는 회귀의 최종 예측은 **가중 중앙값** 이다. 모든 약학습기의 예측을 모은 뒤, **가중치를 고려한 중앙값**을 답으로 한다.

왜 평균이 아니라 중앙값을 쓸까. 답은 한 단어 — **이상치 강건성**이다. 평균은 극단값 하나에 끌려가지만 중앙값은 그렇지 않다. AdaBoost.R2가 **이상치에 강한 통계량**을 선택한 것이다.

그러나 — 여기서 함정이 있다. **최종 예측이 이상치에 강해도**, **가중치 갱신 자체가 이상치에 끌려간다**. 이것이 7장에서 본격적으로 다룰 캘리포니아 실패의 정확한 원인이다.

### 3.4 sklearn에서 — 한 줄로 끝

sklearn의 `AdaBoostRegressor`가 정확히 AdaBoost.R2를 구현한다.

```python
from sklearn.ensemble import AdaBoostRegressor
from sklearn.model_selection import cross_val_score

ada = AdaBoostRegressor(n_estimators=50, random_state=42)
r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
print(f"Ames AdaBoost.R2 CV R²: {r2:.4f}")

print(f"\n{'약학습기 수':>10s}  {'CV R²':>10s}")
print("-" * 25)
for n in [10, 30, 50, 100, 200]:
    ada = AdaBoostRegressor(n_estimators=n, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{n:>10d}  {r2:>10.4f}")
```

약학습기 수가 50~100 사이에서 R²가 정점을 찍는다. **그 이상으로는 거의 안 오른다**. 분산 감소 곡선과 비슷한 **수확체감**패턴이지만, **수렴값 자체가 RF보다 낮다** 는 점이 다르다.

### 3.5 약학습기의 깊이

sklearn의 `AdaBoostRegressor`는 기본 약학습기로 **깊이 3 결정 트리**를 쓴다. 분류 기본값은 깊이 1(결정 그루터기)이지만 회귀에서는 **너무 약하다**. 깊이 3~5가 회귀의 표준이다.

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor

for depth in [1, 3, 5, 10]:
    base = DecisionTreeRegressor(max_depth=depth, random_state=42)
    ada = AdaBoostRegressor(estimator=base, n_estimators=50, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"약학습기 깊이 {depth:>2}:  R² = {r2:.4f}")
```

깊이 1은 회귀에서 너무 약하고, 깊이 10 이상은 **각 약학습기가 이미 강해서 부스팅 효과가 줄어든다**. 깊이 3~5가 균형점이다.

---

## 4장 AdaBoost.M1과 AdaBoost.R2 — 두 변종의 차이

### 4.1 같은 정신, 다른 손실

지금까지 본 두 알고리즘을 한 표로 정리하면 **같은 부스팅 정신을 분류와 회귀에 각각 맞춘 두 변종**임이 분명해진다.

![07 M1 vs R2](figs/07_M1_vs_R2.png)

<sub>그림 4-1. AdaBoost.M1(분류)과 AdaBoost.R2(회귀)의 비교. 두 변종은 가중치 갱신 방향(오답 강조)과 약학습기 누적이라는 공통점을 공유하지만, 손실 측정 방식과 최종 예측 방식이 다르다. 특히 회귀의 이상치 민감도가 7장의 핵심 주제다.</sub>

표의 마지막 두 행이 결정적이다.

**이상치 민감도**. AdaBoost.M1은 분류이므로 **각 샘플이 맞았나 틀렸나**의 0/1 신호만 받는다. 이상치 한 점이 **틀렸다** 는 사실만 전해질 뿐, 그 **얼마나 비싼 이상치인가** 는 알고리즘에 들어가지 않는다. 반면 AdaBoost.R2는 **연속적 손실**을 직접 가중치 갱신에 쓴다. 손실이 100배 큰 이상치는 **가중치도 100배 가까이 부풀어 오른다**. 이 점이 7장에서 본격적으로 다룰 캘리포니아 실패의 원인이다.

**sklearn 구현**. `AdaBoostClassifier`는 1995년 원본 M1을, `AdaBoostRegressor`는 1997년 Drucker의 R2를 따른다.

### 4.2 두 변종의 한 줄 요약

> **AdaBoost.M1은 분류의 0/1 신호를 받아 잘 작동한다.**
> **AdaBoost.R2는 회귀의 연속 손실을 받는데, 이상치에 매우 민감하다.**

이 **한 줄의 차이** 가 4부에서 가장 중요한 통찰이다. 5부의 GBM은 정확히 **AdaBoost.R2의 이상치 민감성** 을 해결하기 위해 등장했다. 손실함수를 더 부드럽게 바꾼 결과다.

---

## 5장 AdaBoost의 핵심 매개변수

### 5.1 n_estimators — 약학습기 수

가장 직관적인 매개변수다. 약학습기를 **몇 그루** 키울 것인가. 너무 적으면 부스팅의 효과가 안 나오고, 너무 많으면 **학습 시간만 늘고 성능은 정체**된다.

3부의 RF와 달리 AdaBoost는 **약학습기 수가 너무 크면 과적합** 의 위험이 있다. 학습 데이터의 **잡음**까지 학습하기 시작하기 때문이다. 그래서 RF처럼 "더 많으면 더 좋다"는 가정이 항상 성립하지 않는다. 실무 권장값은 **50~100** 개다.

### 5.2 learning_rate — 학습률

![05 learning rate](figs/05_learning_rate.png)

<sub>그림 5-1. 학습률의 효과. (왼쪽) 학습률 0.01: 50그루로는 부족하여 함수를 거의 못 따라간다. (가운데) 학습률 0.3: 함수를 부드럽게 따라가는 좋은 균형점. (오른쪽) 학습률 1.5: 학습률이 너무 커서 예측이 흔들리고 과적합.</sub>

학습률은 각 약학습기의 기여도를 **얼마나** 누적할 것인지 조절하는 매개변수다. sklearn 기본값이 1.0인데, 이는 **모든 약학습기를 그대로 더한다** 는 뜻이다. 0.1로 설정하면 각 약학습기의 기여를 **10분의 1만** 받는다.

낮은 학습률의 효과는 **부스팅을 천천히 진행하는 것**과 같다. 한 약학습기가 잡지 못한 패턴을 다음 약학습기가 **조금만** 보정하므로, 더 많은 약학습기가 필요하다. 그러나 **작은 보정을 누적**하면 **최종 성능이 더 좋아진다**.

그림 5-1의 세 학습률을 비교하면 직관이 분명하다.

- 학습률 0.01: 너무 작다 — **부스팅이 시작도 못 한 상태**
- 학습률 0.3: 함수를 **부드럽게 따라가는 좋은 균형점**
- 학습률 1.5: 너무 크다 — **예측이 흔들리고 과적합**

### 5.3 두 매개변수의 트레이드오프

n_estimators와 learning_rate는 **반비례 관계** 다. 학습률을 절반으로 줄이면 보통 약학습기 수를 두 배로 늘려야 비슷한 성능에 도달한다. 두 매개변수의 **곱** 이 **총 부스팅 양**을 결정한다고 생각하면 직관적이다.

```python
print(f"{'n_estimators':>5s}  {'learning_rate':>5s}  {'곱':>4s}  {'CV R²':>10s}")
print("-" * 35)
for n, lr in [(50, 1.0), (100, 0.5), (200, 0.25), (500, 0.1)]:
    ada = AdaBoostRegressor(n_estimators=n, learning_rate=lr, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{n:>5d}  {lr:>10.2f}  {n*lr:>4.0f}  {r2:>10.4f}")
```

네 조합 모두 **총 부스팅 양** n × lr = 50 으로 같다. 실행 결과를 보면 R²가 거의 같은 수준에 도달한다 — 작은 학습률에 많은 약학습기 조합이 **큰 학습률에 적은 약학습기**와 같은 결과를 낸다. 다만 **전자가 보통 더 안정적**이다.

### 5.4 실무 권장 조합

| 시나리오 | n_estimators | learning_rate | base_estimator |
|---|---|---|---|
| 빠른 베이스라인 | 50 | 1.0 | depth=3 (기본) |
| 안정적 성능 | 100~200 | 0.3~0.5 | depth=3~5 |
| 최고 성능 추구 | 500+ | 0.05~0.1 | depth=5 |

깊이 3~5 트리에 학습률 0.3~0.5, 약학습기 100~200개가 **대부분의 데이터에서 안전한 출발점**이다.

---

## 6장 Ames에서의 AdaBoost — 잘 작동하는 사례

### 6.1 베이스라인 한 표

3부에서 정리한 모든 모델에 AdaBoost를 추가한 표를 한눈에 보자.

```python
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor, AdaBoostRegressor
from sklearn.model_selection import cross_val_score

models = {
    "선형회귀":          LinearRegression(),
    "결정 트리":         DecisionTreeRegressor(random_state=42),
    "랜덤 포레스트 100": RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1),
    "AdaBoost 50":       AdaBoostRegressor(n_estimators=50, random_state=42),
}

for name, m in models.items():
    r2 = cross_val_score(m, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"  {name:<20s}  R² = {r2:.4f}")
```

대표적인 결과는 다음과 같다.

| 모델 | CV R² |
|---|---|
| 선형회귀 | 0.80 |
| 결정 트리 | 0.75 |
| 랜덤 포레스트 100 | 0.88 |
| **AdaBoost 50** | **0.81** |

AdaBoost는 **선형회귀와 비슷한 수준**이다. 단일 트리보다는 명확히 좋지만, **랜덤 포레스트를 못 따라잡는다**(약 0.07 차이). Ames 데이터에서는 분산 감소 전략(RF)이 AdaBoost의 편향 감소 전략보다 효과적이다.

이 결과만 보면 AdaBoost는 **그럭저럭 쓸 만한 모델**이다. 그러나 7장에서 보겠지만, 같은 알고리즘이 캘리포니아 데이터에서는 **완전히 무너진다**. 데이터에 따라 천차만별인 것이다.

### 6.2 변수 중요도 — RF와 비슷하지만 다르다

AdaBoost도 변수 중요도를 제공한다. RF의 MDI와 같은 **불순도 감소 합산** 방식이다.

```python
ada = AdaBoostRegressor(n_estimators=100, random_state=42)
ada.fit(X_ames, y_ames)

ada_imp = pd.Series(ada.feature_importances_, index=X_ames.columns).nlargest(5)
print("AdaBoost 상위 5개:")
for var, imp in ada_imp.items():
    print(f"  {var:<22s}  {imp:.4f}")
```

Ames에서 1위는 항상 `Overall Qual`이다 — 이건 RF에서도 같다. 그러나 2~5위는 약간 다르다. AdaBoost는 **오답 강조의 효과** 로 일부 변수가 RF와 다른 가중치를 받는다. 일반적으로 부스팅 계열이 **덜 강한 변수의 기여도** 를 더 잘 잡아낸다고 알려져 있다.

---

## 7장 캘리포니아에서의 실패 — AdaBoost의 약점

### 7.1 충격적인 결과

같은 비교를 캘리포니아 주택가격 데이터로 한다. 결과가 놀랍다.

```python
print(f"{'모델':<20s}  {'CV R²':>10s}")
print("-" * 32)
for name, m in [
    ("선형회귀",      LinearRegression()),
    ("랜덤 포레스트", RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)),
    ("AdaBoost",      AdaBoostRegressor(n_estimators=50, random_state=42)),
]:
    r2 = cross_val_score(m, X_cal, y_cal, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{name:<20s}  {r2:>10.4f}")
```

| 모델 | 캘리포니아 CV R² |
|---|---|
| 선형회귀 | 0.56 |
| 랜덤 포레스트 100 | 0.51 |
| **AdaBoost 50** | **0.23** |

AdaBoost가 **선형회귀의 절반에도 못 미친다**. RF의 절반 수준이다. **동일한 알고리즘이 Ames(R² 0.81)와 캘리포니아(R² 0.23)에서 천차만별로 다르다.** 이 차이의 원인이 7장의 핵심 발견이다.

### 7.2 원인 — 캘리포니아의 capped 값

![06 california failure](figs/06_california_failure.png)

<sub>그림 7-1. 캘리포니아 데이터에서 AdaBoost가 실패하는 이유. (왼쪽) y값 분포에서 \$500,001 근처에 965건의 capped 값이 뾰족하게 모여 있다. 데이터 수집 당시 \$500,000 이상은 모두 \$500,001로 기록되었다. (오른쪽) 모델별 R² 막대 — AdaBoost가 절반 수준에 그친다.</sub>

캘리포니아 데이터의 **결정적 특징** 은 **capped 값**이다. 1990년 미국 인구조사 수집 당시 **주택가격이 \$500,000 이상인 경우 모두 \$500,001로 천장에 막혔다**. 데이터에는 965건의 \$500,001 값이 들어 있다 — 전체의 약 4.7%다.

이 값들은 **진정한 의미의 이상치** 다. 실제로는 \$600,000일 수도, \$1,000,000일 수도 있는데 모두 \$500,001로 **압축된 거짓 값**이다. AdaBoost는 이 거짓 값을 **진짜로 받아들여 학습**하므로, 예측이 **왜곡** 된다.

### 7.3 왜 AdaBoost가 특별히 취약한가

이상치가 있는 데이터는 어떤 모델에든 어려운 문제다. 그런데 **왜 AdaBoost가 RF나 선형회귀보다 훨씬 더 심하게 실패하는가**?

답은 1장에서 본 **가중치 갱신 메커니즘**에 있다. AdaBoost는 매 라운드마다 **오답 샘플의 가중치를 부풀린다**. 그런데 이상치는 **영원히 오답**이다. 진짜 정보가 없으므로 어떤 트리도 그 샘플을 **진짜로 맞출 수 없다**.

따라서 매 라운드마다 capped 샘플의 가중치는 **더 부풀어 오르고**, 다음 트리는 **그 잘못된 신호에 더 매달린다**. 결국 **AdaBoost는 잡을 수 없는 잡음에 점점 더 끌려가며**, 라운드가 진행될수록 **진짜 신호에서 멀어진다**.

다른 모델들은 어떤가? RF는 **서로 무관한 100그루 트리의 평균**이므로 한 그루가 이상치에 끌려가도 **다른 트리들이 상쇄**해 준다. 선형회귀는 **모든 샘플을 똑같이 다루므로** 이상치 4.7%의 영향이 **전체에 흩어진다**. 그러나 AdaBoost는 **이상치를 가장 중요한 샘플로 강조**하므로 가장 크게 휘둘린다.

### 7.4 capped 값을 제거하면 어떻게 되나

가설을 직접 검증해 보자. capped 값 965건을 제거하고 같은 실험을 다시 한다.

```python
mask = y_cal < y_cal.max()
X_cal_clean = X_cal[mask]
y_cal_clean = y_cal[mask]

print(f"원본:    {len(y_cal)} 행")
print(f"제거 후: {len(y_cal_clean)} 행 ({(len(y_cal)-len(y_cal_clean))/len(y_cal)*100:.1f}% 제거)\n")

print(f"{'모델':<20s}  {'원본':>10s}  {'제거 후':>10s}")
print("-" * 45)
for name, m in [
    ("선형회귀",      LinearRegression()),
    ("랜덤 포레스트", RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)),
    ("AdaBoost",      AdaBoostRegressor(n_estimators=50, random_state=42)),
]:
    r2_full = cross_val_score(m, X_cal, y_cal, cv=5, scoring="r2", n_jobs=-1).mean()
    r2_clean = cross_val_score(m, X_cal_clean, y_cal_clean, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{name:<20s}  {r2_full:>10.4f}  {r2_clean:>10.4f}")
```

실행해 보면 **AdaBoost R²가 0.23 → 0.24** 정도로 거의 개선되지 않는다. capped 4.7%를 제거해도 AdaBoost의 실패가 **해결되지 않는 것** 이다.

이는 **capped 값이 유일한 문제가 아니라**, 데이터 자체에 다른 **미세한 이상치 구조** 가 있고, AdaBoost가 그 모두에 **민감하게 반응한다**는 신호다. **단순 이상치 제거로는 해결되지 않는 알고리즘 자체의 약점** 이다.

### 7.5 한 줄 결론

> **AdaBoost.R2는 잡음과 이상치에 매우 민감하다. 깨끗한 데이터(Ames)에서는 RF와 비슷하지만, 노이즈가 많은 데이터(캘리포니아)에서는 RF에 크게 뒤진다.**

이 약점이 **실용적으로 AdaBoost.R2가 산업에서 거의 안 쓰이는** 이유다. 대신 **분류용 AdaBoost.M1**은 여전히 작은 데이터의 **깔끔한 이진 분류**에서 쓰인다. 회귀에서는 5부의 **GBM**과 6부의 **현대 부스팅 3종**이 사실상 AdaBoost.R2를 대체했다.

---

## 8장 GBM으로의 다리 — 손실함수 일반화

### 8.1 AdaBoost가 사실은 **지수 손실** 알고리즘

1999년 Friedman·Hastie·Tibshirani의 발견 — **AdaBoost가 사실 지수 손실을 최소화하는 알고리즘이다**. 지수 손실이란, 예측이 빗나갈수록 손실이 **지수적으로** 폭증하는 함수다. 오차 1에 대해 손실이 2.7, 오차 2에 대해 7.4, 오차 5에 대해 148, 오차 10에 대해 22,026 — 이런 식으로 폭증한다.

이 **지수적 폭증** 이 AdaBoost를 분류에서 강력하게 만들지만, 회귀에서 **이상치를 만나면** 그 한 점의 손실이 **알고리즘 전체를 망가뜨릴 만큼 커진다**. 7장의 캘리포니아 실패가 이 손실함수에서 직접 나오는 결과다.

이 발견을 한 Friedman은 곧 후속 질문을 던졌다 — **그것이 가장 좋은 손실함수인가**? 답은 단순했다 — **다른 손실함수를 쓰자**. 2001년 Friedman의 **경사 부스팅**(Gradient Boosting Machine, GBM)이 그 답이다.

### 8.2 GBM이 푸는 문제 — 손실함수의 선택

GBM의 핵심 아이디어는 **각 라운드에서 손실함수의 음의 방향으로 한 걸음씩 가는 것** 이다. 어떤 손실함수를 쓸지 **자유롭게 선택**할 수 있다. 회귀에서 자주 쓰이는 선택지를 표로 보자.

| 손실 | 빗나갈수록 손실이 | 이상치 견고성 |
|---|---|---|
| 지수 (AdaBoost) | 지수적으로 폭증 | 매우 약함 |
| 제곱 (GBM 기본) | 제곱적으로 증가 | 보통 |
| 절대 | 선형적으로 증가 | 강함 |
| Huber | 작은 오차는 제곱처럼, 큰 오차는 절대값처럼 | 두 마리 토끼 |

지수에서 제곱으로 바꾼 것만으로도 **이상치 폭증이 크게 완화**된다. 절대 손실이나 Huber 손실을 쓰면 **이상치에 거의 휘둘리지 않는** 알고리즘이 된다. 이게 GBM이 캘리포니아 데이터에서 **AdaBoost의 R² 0.23을 0.59까지 끌어올리는** 이유다.

### 8.3 가장 직관적인 GBM — 잔차 부스팅

회귀에서 **제곱 손실**을 쓰는 GBM은 매우 직관적이다. 한 줄로 설명하면 — **각 라운드의 새 트리는 직전 라운드의 잔차를 학습한다**.

첫 트리가 가격을 예측하면, 그 예측과 실제 가격 사이에 **잔차**(차이)가 남는다. 두 번째 트리는 **그 잔차를 학습한다**. 셋째 트리는 둘째까지 학습 후의 **남은 잔차**를 학습한다. 이렇게 **잔차를 점점 줄여 나가는 트리들의 누적**이 GBM이다.

매우 직관적이라 **손으로도 거의 따라할 수 있는** 알고리즘이다. 5부에서 본격적으로 다룬다.

### 8.4 부스팅 가족의 전체 진화

![08 boosting lineage](figs/08_boosting_lineage.png)

<sub>그림 8-1. 부스팅 가족의 진화. AdaBoost(1995, 지수 손실)에서 GBM(2001, 일반 손실)으로 일반화되었고, GBM의 현대적 구현 셋이 XGBoost(2014), LightGBM(2017), CatBoost(2017)이다.</sub>

앞으로 다룰 알고리즘들을 미리 정리해 두자.

**5부 GBM** (2001, Friedman). AdaBoost의 **손실함수를 일반화**한다. 회귀에서는 제곱·절대·Huber 손실, 분류에서는 로그 손실을 쓴다. 이상치 문제가 해결되어 Ames와 캘리포니아 모두에서 좋은 성능을 낸다.

**6부 XGBoost** (2014). GBM의 **근사 그래디언트 계산**과 **2차 미분**을 활용하여 학습 속도를 10~50배 개선. 캐글 우승 알고리즘으로 명성을 얻었다.

**6부 LightGBM** (2017, Microsoft). XGBoost보다 **2~5배 더 빠른** GBM 구현. 큰 데이터셋에서의 표준이 되었다.

**6부 CatBoost** (2017, Yandex). **범주형 변수의 자동 처리**가 핵심 강점. 원-핫 인코딩 없이도 범주형을 잘 다룬다.

세 알고리즘은 **같은 GBM 알고리즘의 다른 구현**일 뿐이다. 데이터의 성격에 따라 선택이 달라진다.

### 8.5 4부 결론

이번 부의 결론을 세 가지로 요약한다.

**결론 1.** 부스팅은 **분산이 아니라 편향**을 줄이는 전략이다. 배깅의 **서로 무관한 평균**과 정반대 철학으로, **앞 트리의 오답을 다음 트리가 보정**한다.

**결론 2.** AdaBoost는 **부스팅 가족의 시조**다. 가중치 갱신, 약학습기 누적, 가중 다수결의 세 가지 메커니즘이 부스팅의 골격을 정의한다.

**결론 3.** AdaBoost.R2는 **회귀의 이상치에 매우 민감**하다. 캘리포니아의 R² 0.23이 그 증거다. 이 약점이 **GBM의 손실함수 일반화** 동기가 된다.

---

다음 부 5부에서는 GBM을 본격적으로 다루며, **왜 잔차 학습이 그렇게 자연스러운가** 와 **어떻게 캘리포니아에서 R²가 0.23에서 0.59로 점프하는가** 를 본다.
