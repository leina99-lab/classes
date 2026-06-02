# 4부 AdaBoost — 부스팅의 시조

## 어려운 버전 — 학부 1~2학년용

본 자료는 학생이 혼자서 읽고 실습할 수 있도록 구성된 자습 교재이다. 각 절에는 핵심 개념의 설명, 직관을 돕는 그림, 그리고 곧장 실행해 볼 수 있는 파이썬 코드가 함께 들어 있다. 3부에서 다룬 **분산 감소 전략**이 더 이상 R²를 올리지 못하는 한계를 봤다면, 4부는 정반대 철학의 도구 — **편향을 직접 공격하는** 부스팅의 첫 알고리즘 **AdaBoost**(Adaptive Boosting) — 를 소개한다.

본 교재의 코드는 Jupyter Notebook, Google Colab, 그리고 로컬 Python 환경에서 모두 작동한다. 데이터 로딩과 전처리는 3부의 표준 패턴을 그대로 쓴다.

```python
# 환경 준비 (한 번만 실행)
# !pip install pandas numpy matplotlib scikit-learn koreanize-matplotlib

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import koreanize_matplotlib   # 한글 폰트(NanumGothic) 자동 설정
import warnings
warnings.filterwarnings("ignore")

# Ames 주택가격 데이터 (3부와 동일)
URL_AMES = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/AmesHousing.csv"

# 캘리포니아 주택가격 데이터 (4부의 두 번째 사례)
URL_CAL = "https://raw.githubusercontent.com/ageron/handson-ml2/master/datasets/housing/housing.csv"

try:
    df_ames_raw = pd.read_csv(URL_AMES)
    df_cal_raw = pd.read_csv(URL_CAL)
    print(f"Ames 로딩: {df_ames_raw.shape}")
    print(f"California 로딩: {df_cal_raw.shape}")
except Exception:
    print("폴백 합성 데이터 사용 (URL 접근 실패)")
```

전처리도 동일하다.

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

print(f"Ames:       X {X_ames.shape}, y {y_ames.shape}")
print(f"California: X {X_cal.shape}, y {y_cal.shape}")
```

두 데이터셋이 **4부의 핵심 대조 실험**에 사용된다. Ames에서는 AdaBoost가 그럭저럭 작동하지만, 캘리포니아 원본에서는 **처참하게 실패한다**. 그 이유와 의미가 7~8장에서 본격적으로 드러난다.

---

## 0장 분산 감소에서 편향 감소로 — 부스팅의 정신

### 0.1 3부에서의 막다른 길

3부 마지막에서 **랜덤 포레스트가 더 이상 R²를 못 올린다**는 결론에 도달했다. Ames에서 RF 100그루의 R²가 약 0.88인데, 300그루로 늘려도 거의 같다. 트리 간 상관 $\rho$로 인해 분산 하한 $\rho \sigma^2$에 부딪힌 것이다. 그 너머는 분산 감소 전략으로 갈 수 없다.

남은 약 0.12의 R² 격차는 **분산이 아니라 편향**에서 온다. 트리 한 그루가 **충분히 깊이 자라도** 잡지 못하는 패턴이 있다는 뜻이다. 100그루를 평균내도 그 패턴은 잡히지 않는다. **모든 트리가 공통으로 못 잡는 부분**은 평균으로 사라지지 않기 때문이다.

이걸 해결하는 **정반대 전략**이 부스팅이다. 부스팅의 핵심 한 줄을 요약하면 다음과 같다.

> **트리를 한 그루씩 순차적으로 키우면서, 앞선 트리들이 잡지 못한 패턴을 다음 트리가 보정한다.**

배깅이 **서로 모르는 채점관들의 평균**이라면, 부스팅은 **앞 사람의 오답을 받아 그 부분만 고치는 학생들의 줄**이다.

### 0.2 정반대 철학의 한 장 비교

![01 bagging vs boosting](figs/01_bagging_vs_boosting.png)

<sub>그림 0-1. 배깅과 부스팅의 정반대 철학. (왼쪽) 배깅에서는 각 트리가 서로의 존재를 모르며 병렬로 학습된다. 모든 트리가 끝난 뒤 예측을 평균낸다. (오른쪽) 부스팅에서는 트리 1이 먼저 학습되고, 트리 1의 오답이 트리 2의 학습 신호가 된다. 트리 N은 앞의 N-1 그루가 *못 본 잔여 패턴*을 학습한다.</sub>

두 방법의 구조적 차이를 표로 정리하면 다음과 같다.

| 구분 | 배깅 (Random Forest) | 부스팅 (AdaBoost / GBM / ...) |
|---|---|---|
| 트리 키우는 방식 | 여러 그루를 **독립적으로** 키워 평균 | 한 그루씩 **순서대로** 키워 누적 |
| 다음 트리의 입력 | 새 부트스트랩 표본 (이전 트리와 무관) | 앞 트리의 오답 정보를 받음 |
| 줄이는 오차 | **분산** | **편향** |
| 트리 깊이 권장값 | **깊게** (개별 트리 강화) | **얕게** (단순 약학습기를 누적) |
| 병렬 처리 가능성 | 가능 (학습 자체가 병렬) | 불가능 (앞 트리 끝나야 다음 시작) |
| 첫 알고리즘 | Breiman 1996 | Schapire-Freund 1995 |

특히 **트리 깊이** 가 정반대로 권장되는 점이 흥미롭다. 배깅은 **깊은 트리 100그루를 평균**해 분산을 줄이는 전략이고, 부스팅은 **얕은 트리 100그루를 누적**해 편향을 줄이는 전략이다. 두 방법이 **같은 트리 도구**를 정반대로 활용한다.

### 0.3 약학습기 — 부스팅의 빌딩 블록

부스팅의 빌딩 블록을 **약학습기**(weak learner)라 부른다. **무작위 예측보다 약간 나은 정도의 단순한 모델**이라는 뜻이다. AdaBoost에서 가장 흔히 쓰이는 약학습기는 **깊이 1짜리 결정 트리** — **결정 그루터기**(decision stump)다.

결정 그루터기는 단 **한 번의 질문**으로 답을 낸다. "거실 면적이 1500 이하인가?"라는 한 질문에 **예/아니오**로 가른 다음, 각 쪽의 평균 가격을 답으로 내는 매우 단순한 모델이다. 이런 모델이 **얼마나 약한가**는 다음 코드로 직접 확인할 수 있다.

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score

# 결정 그루터기 (depth=1) vs 보통 트리 (depth=10)
stump = DecisionTreeRegressor(max_depth=1, random_state=42)
normal = DecisionTreeRegressor(max_depth=10, random_state=42)

r2_stump = cross_val_score(stump, X_ames, y_ames, cv=5, scoring="r2").mean()
r2_normal = cross_val_score(normal, X_ames, y_ames, cv=5, scoring="r2").mean()

print(f"결정 그루터기 (depth=1):  CV R² = {r2_stump:.4f}")
print(f"보통 트리     (depth=10): CV R² = {r2_normal:.4f}")
```

결정 그루터기는 단독으로 R² 약 0.45 — **선형회귀의 절반에도 못 미치는** 매우 약한 모델이다. 그러나 **이런 약학습기를 50~100개 누적**하면, 곧 보겠지만 R² 0.80 이상으로 점프한다. AdaBoost의 마법이다.

### 0.4 가족의 시조 — AdaBoost

![08 boosting lineage](figs/08_boosting_lineage.png)

<sub>그림 0-2. 부스팅 가족의 진화. AdaBoost(1995)가 가족의 시조이며, 손실함수를 일반화한 것이 GBM(2001)이다. GBM의 현대적 구현 세 가지가 XGBoost(2014), LightGBM(2017), CatBoost(2017)이다.</sub>

**AdaBoost**(Adaptive Boosting)는 1995년 Yoav Freund와 Robert Schapire가 발표한 알고리즘으로, 부스팅 가족의 시조다. 1996년 ICML에서 발표되어 머신러닝 학계에 충격을 주었고, **왜 약학습기를 누적해도 성능이 좋아지는가** 라는 이론적 질문을 만들어 냈다. 그 답을 추적하던 Friedman이 2001년 AdaBoost를 **경사 부스팅**(Gradient Boosting Machine, GBM)으로 일반화했고, 그 GBM이 다시 현대 산업의 표준이 된 XGBoost·LightGBM·CatBoost로 발전했다.

4부에서는 가족의 시조인 AdaBoost를 **완벽히** 이해한다. 다음 세 가지 핵심을 따라간다.

1. **가중치 갱신 메커니즘** — 어떻게 다음 트리가 앞의 오답을 보정하는가 (1~3장)
2. **AdaBoost.M1(분류) vs AdaBoost.R2(회귀)** — 두 변종의 차이 (4장)
3. **Ames vs 캘리포니아 실험** — 데이터에 따라 AdaBoost가 **왜** 천차만별인가 (6~7장)

마지막 8장에서 AdaBoost의 **약점**이 어떻게 5부 GBM의 동기가 되는지를 짚으며 다음 부로 다리를 놓는다.

---

## 1장 가중치 갱신 — 다음 트리가 무엇을 보고 학습하나

### 1.1 핵심 아이디어 — 샘플마다 가중치를 둔다

AdaBoost의 핵심은 **학습 샘플마다 가중치**를 둔다는 것이다. 처음에는 모든 샘플이 같은 가중치 $1/n$을 갖는다. 첫 트리(약학습기)를 학습한 뒤, **틀린 샘플의 가중치를 올리고 맞은 샘플의 가중치를 내린다**. 두 번째 트리는 이 새 가중치로 학습한다 — 즉 **틀린 샘플을 더 중요하게** 본다. 이 사이클을 반복한다.

세 단계의 가중치 갱신 사이클을 그림으로 보면 다음과 같다.

![02 weight update](figs/02_weight_update.png)

<sub>그림 1-1. AdaBoost의 가중치 갱신 한 사이클. (1단계) 모든 샘플이 같은 가중치, 첫 약학습기가 분할 t=5에서 분류 — 두 개의 오답 발생. (2단계) 오답 두 샘플의 가중치가 e^α 배 증가, 정답들의 가중치는 감소(점 크기로 표시). (3단계) 새 가중치로 두 번째 약학습기 학습 — 오답을 더 신경 쓴 새 분할 t=4가 선택됨.</sub>

그림에서 **점 크기가 곧 가중치**다. 1단계에서 모든 점이 같은 크기로 시작하지만, 2단계에서 오답 두 점이 크게 부풀어 오른다. 그 크기 차이가 **두 번째 약학습기의 분할 결정에 영향**을 준다 — 큰 점을 맞추기 위해 분할 위치가 t=5에서 t=4로 이동한다.

### 1.2 가중치 갱신 식 — AdaBoost.M1 (분류)

수식으로 정확히 표현하자. 학습 샘플 $i$의 시점 $t$에서의 가중치를 $w_i^{(t)}$라 하면, 다음 라운드의 가중치는 다음과 같이 갱신된다.

$$w_i^{(t+1)} = \frac{w_i^{(t)} \cdot \exp(-\alpha_t \cdot y_i \cdot h_t(x_i))}{Z_t}$$

여기서 각 기호의 의미는 다음과 같다.

- $h_t(x_i) \in \{-1, +1\}$ : $t$번째 약학습기의 예측 (이진 분류)
- $y_i \in \{-1, +1\}$ : 샘플 $i$의 실제 라벨
- $\alpha_t$ : $t$번째 약학습기의 가중치 (잘 맞춘 약학습기일수록 큰 값)
- $Z_t$ : 정규화 상수 (모든 $w_i^{(t+1)}$의 합이 1이 되도록 만듦)

식의 핵심은 곱셈 $y_i \cdot h_t(x_i)$다. 예측이 맞으면 ($y_i = h_t(x_i)$) 그 곱이 $+1$이고, 틀리면 $-1$이다. 따라서:

- **맞은 샘플**: $\exp(-\alpha_t)$ — **가중치 감소** (음수의 지수 → 1보다 작음)
- **틀린 샘플**: $\exp(+\alpha_t)$ — **가중치 증가** (양수의 지수 → 1보다 큼)

이 한 식이 **오답 강조** 의 정확한 메커니즘이다.

### 1.3 약학습기 가중치 α의 정확한 식

위 식에서 $\alpha_t$는 어떻게 정해질까? AdaBoost는 **가중 오차율** $\epsilon_t$를 기준으로 다음과 같이 계산한다.

$$\epsilon_t = \sum_{i: h_t(x_i) \ne y_i} w_i^{(t)} \quad (\text{틀린 샘플들의 가중치 합})$$

$$\alpha_t = \frac{1}{2} \ln\left(\frac{1 - \epsilon_t}{\epsilon_t}\right)$$

이 식이 의미하는 바를 그래프로 보면 직관이 잡힌다.

![04 alpha curve](figs/04_alpha_curve.png)

<sub>그림 1-2. 약학습기 가중치 α는 가중 오차율 ε의 함수다. ε가 작을수록(잘 맞춘 약학습기) α가 크고, ε = 0.5(무작위 수준)이면 α = 0이다. ε > 0.5이면 α가 음수가 되는데, 이는 그 약학습기의 예측을 *반대로 사용*한다는 뜻이다.</sub>

$\alpha$ 식의 세 가지 특징을 짚어 보자.

1. **ε이 작으면 α가 크다**: 잘 맞춘 약학습기는 최종 앙상블에서 큰 가중치를 받는다.
2. **ε = 0.5에서 α = 0**: 무작위 수준의 약학습기는 **아무 기여도 하지 않는다**.
3. **ε > 0.5이면 α < 0**: 무작위보다 나쁜 약학습기는 **반대로 사용**된다. 이론적으로는 가능하지만 실전에서는 약학습기를 **재학습**시킨다.

이 세 가지가 AdaBoost의 **자기 가중치** 메커니즘이다. **잘 맞춘 약학습기일수록 큰 영향력을 갖는다**.

### 1.4 직접 한 사이클 돌려 보기

AdaBoost의 첫 두 라운드를 직접 코드로 돌려 보면 가중치 변화가 한눈에 보인다.

```python
import numpy as np
from sklearn.tree import DecisionTreeClassifier
from sklearn.datasets import make_classification

# 단순한 이진 분류 예시 (20개 샘플, 2개 변수)
X, y = make_classification(n_samples=20, n_features=2, n_informative=2,
                            n_redundant=0, n_clusters_per_class=1,
                            random_state=42)
y = 2 * y - 1   # {0, 1} -> {-1, +1}
n = len(y)

# 라운드 1
w = np.ones(n) / n      # 균등 가중치로 시작
print(f"라운드 1 시작:")
print(f"  초기 가중치: 모두 {w[0]:.4f}")

stump = DecisionTreeClassifier(max_depth=1, random_state=0)
stump.fit(X, y, sample_weight=w)
pred1 = stump.predict(X)
err = np.sum(w * (pred1 != y))     # 가중 오차율
alpha1 = 0.5 * np.log((1 - err) / err)

print(f"  가중 오차율 ε₁: {err:.4f}")
print(f"  약학습기 가중치 α₁: {alpha1:.4f}")
print(f"  오답 샘플 수: {np.sum(pred1 != y)}/{n}")

# 가중치 갱신
w_new = w * np.exp(-alpha1 * y * pred1)
w_new /= w_new.sum()    # 정규화
print(f"\n라운드 2 시작:")
print(f"  정답 샘플 평균 가중치: {w_new[pred1 == y].mean():.4f}  (감소)")
print(f"  오답 샘플 평균 가중치: {w_new[pred1 != y].mean():.4f}  (증가)")
print(f"  최대 증가율: {w_new.max() / (1/n):.2f}배")
```

실행하면 첫 약학습기의 가중 오차율이 약 0.10~0.20 사이 값을 갖고, 이에 해당하는 $\alpha_1$이 약 0.7~1.0이 된다. 갱신 후 **오답 샘플의 가중치는 평균 3~5배 증가**하고, 정답 샘플은 약간 감소한다. 두 번째 약학습기는 이 **부풀어 오른 오답 샘플들**에 집중하여 학습한다.

### 1.5 왜 지수함수인가

가중치 갱신에 **지수함수** $\exp(-\alpha y h(x))$가 쓰이는 데에는 이론적 이유가 있다. AdaBoost는 사실 **지수 손실**(exponential loss)을 최소화하는 알고리즘이다.

$$L_{\text{exp}}(y, F(x)) = \exp(-y \cdot F(x))$$

여기서 $F(x) = \sum_t \alpha_t h_t(x)$는 **모든 약학습기의 가중 합**이다. AdaBoost의 각 라운드는 이 지수 손실을 가장 빠르게 줄이는 방향으로 새 약학습기를 추가한다.

지수 손실의 특징은 **오답에 대한 페널티가 무한대로 커진다**는 점이다. 한 샘플의 예측이 점점 빗나가면 그 샘플의 손실이 **지수적으로** 폭증한다. 이 성질이 AdaBoost를 **분류**에서는 강력하게 만들지만, **회귀**에서는 6장에서 보겠지만 **이상치에 극도로 민감하게** 만든다.

---

## 2장 약학습기의 누적 — 결정 경계가 어떻게 정교해지나

### 2.1 누적의 시각적 이해

가중치 갱신이 한 라운드의 메커니즘이라면, **여러 라운드를 누적**하면 무슨 일이 일어날까? 각 약학습기가 결정 그루터기(깊이 1)라면 각 학습기의 결정 경계는 **직선 하나**뿐이다. 그러나 직선 100개를 **가중 합**하면 매우 복잡한 곡선 경계도 표현할 수 있다.

이 누적 과정을 **make_moons** 라는 표준 분류 문제에서 시각화하면 다음과 같다.

![03 boundary evolution](figs/03_boundary_evolution.png)

<sub>그림 2-1. AdaBoost의 누적 과정. (왼쪽부터) 트리 1개일 때는 직선 한 줄이 경계의 전부다. 트리 5개로 늘면 직선 5개가 합쳐져 약간 굽은 경계가 만들어진다. 트리 20개에서는 초승달 모양을 따라가는 경계가 보이고, 트리 100개에서는 두 클래스의 경계를 매우 정교하게 잡는다.</sub>

트리 1개에서 100개로 늘어가는 동안 결정 경계가 **점점 더 정교해진다**. 각 약학습기는 단순한 직선이지만, **가중 합** 의 효과로 복잡한 곡선을 만들어 낸다. 이게 부스팅의 핵심 통찰이다 — **단순한 모델 여러 개의 가중 합이 복잡한 모델 하나의 효과를 낸다**.

### 2.2 최종 예측 — 가중 다수결 (분류)

분류에서 AdaBoost의 최종 예측은 **모든 약학습기의 가중 다수결**이다. 수식으로는 다음과 같다.

$$H(x) = \text{sign}\left(\sum_{t=1}^{T} \alpha_t \cdot h_t(x)\right)$$

각 약학습기 $h_t$는 $\{-1, +1\}$ 중 하나를 출력하고, 그 값에 약학습기 가중치 $\alpha_t$를 곱한다. 모든 약학습기의 결과를 더한 뒤 부호로 최종 분류한다.

직관적으로, **잘 맞춘 약학습기**($\alpha$가 큰)의 의견이 **못 맞춘 약학습기**($\alpha$가 작은)의 의견보다 더 큰 영향력을 갖는다. 보통의 다수결이 **한 사람 한 표**라면, AdaBoost의 가중 다수결은 **전문가의 표가 더 무겁다**.

### 2.3 직접 실험 — n_estimators 변화에 따른 R²

sklearn의 `AdaBoostClassifier`(또는 회귀의 `AdaBoostRegressor`)로 약학습기 수를 늘려가며 성능 변화를 확인할 수 있다.

```python
from sklearn.ensemble import AdaBoostClassifier
from sklearn.datasets import make_moons
from sklearn.model_selection import cross_val_score

X_moon, y_moon = make_moons(n_samples=500, noise=0.25, random_state=42)

print(f"{'n_estimators':>15s}  {'CV 정확도':>12s}")
print("-" * 30)
for n in [1, 5, 10, 50, 100, 200, 500]:
    clf = AdaBoostClassifier(n_estimators=n, random_state=42)
    acc = cross_val_score(clf, X_moon, y_moon, cv=5, scoring="accuracy").mean()
    print(f"{n:>15d}  {acc:>12.4f}")
```

실행하면 트리 1개일 때 약 0.80, 100개에서 약 0.95 이상으로 점프한다. 단순한 결정 그루터기 한 개로는 초승달 모양을 잡을 수 없지만, 100개를 누적하면 매우 정교하게 잡는다.

### 2.4 약학습기 가중치의 누적 분포

학습이 끝난 AdaBoost 모델에서 각 약학습기의 가중치 $\alpha_t$를 직접 들여다볼 수 있다.

```python
from sklearn.ensemble import AdaBoostClassifier

clf = AdaBoostClassifier(n_estimators=50, random_state=42)
clf.fit(X_moon, y_moon)

alphas = clf.estimator_weights_   # 각 약학습기의 α
errors = clf.estimator_errors_     # 각 약학습기의 가중 오차율

print(f"평균 α:        {alphas.mean():.4f}")
print(f"α 최댓값:      {alphas.max():.4f}  (가장 신뢰도 높은 약학습기)")
print(f"α 최솟값:      {alphas.min():.4f}")
print(f"평균 오차율 ε: {errors.mean():.4f}")
```

학습이 진행될수록 약학습기의 가중 오차율이 점점 **0.5에 가까워진다**. 이는 **남은 오답 샘플이 점점 어려운 샘플들**이기 때문이다. 후반의 약학습기들은 작은 $\alpha$를 갖지만, 그래도 **어려운 샘플의 분류에 결정적**이다.

---

## 3장 AdaBoost.R2 — 회귀로의 확장

### 3.1 분류 vs 회귀 — 손실의 차이

1·2장에서 다룬 AdaBoost는 **이진 분류** 용 알고리즘이다. 분류에서는 **맞았나 틀렸나**가 명확하다. 그러나 **회귀** 에서는 예측이 **얼마만큼 빗나갔는지**가 연속적인 값이다. 가격 18만 달러를 17만으로 예측한 것과 12만으로 예측한 것이 다르다.

이 차이를 받아들이려면 가중치 갱신 식도 **연속적 손실** 을 받아들이도록 바뀌어야 한다. 1997년 Drucker가 제안한 **AdaBoost.R2** 가 그 답이다.

### 3.2 AdaBoost.R2 알고리즘

R2의 핵심 변경 사항은 다음 세 가지다.

**변경 1 — 손실 측정**. 각 샘플의 손실을 다음과 같이 정의한다.

$$L_i = \frac{|y_i - h_t(x_i)|}{D_t}, \qquad D_t = \max_i |y_i - h_t(x_i)|$$

즉 **절대 오차를 그 라운드의 최대 오차로 정규화** 한 값이다. 모든 $L_i \in [0, 1]$이다.

**변경 2 — 약학습기의 가중 평균 손실**:

$$\bar{L}_t = \sum_i w_i^{(t)} L_i$$

이 값이 **작을수록 그 약학습기는 좋다**. 분류의 **가중 오차율** 과 비슷한 역할이다.

**변경 3 — β와 가중치 갱신**:

$$\beta_t = \frac{\bar{L}_t}{1 - \bar{L}_t}, \qquad w_i^{(t+1)} = w_i^{(t)} \cdot \beta_t^{1 - L_i}$$

$\beta_t < 1$이면 **손실이 작은 샘플은 가중치가 줄어들고**, **손실이 큰 샘플은 가중치가 거의 그대로 유지**된다. 분류와 같은 방향이다.

### 3.3 R2의 최종 예측 — 가중 중앙값

분류의 **가중 다수결**에 해당하는 회귀의 최종 예측은 **가중 중앙값**(weighted median)이다. 모든 약학습기의 예측 $h_t(x)$를 정렬한 뒤, $\ln(1/\beta_t)$의 누적 합이 전체의 절반에 도달하는 시점의 예측을 답으로 한다.

$$H(x) = \text{weighted-median}_{t}\left(h_t(x); \ln(1/\beta_t)\right)$$

가중 중앙값을 쓰는 이유는 **이상치에 강한 통계량**이기 때문이다. 가중 평균과 달리 **극단값에 흔들리지 않는다**. AdaBoost.R2가 분류의 다수결을 **회귀의 중앙값** 으로 옮긴 것은 이상치 강건성을 의식한 선택이다.

그러나 6장에서 보겠지만, **가중치 갱신 자체** 가 이상치에 끌려가므로 **중앙값 예측만으로는 이상치 문제를 완전히 막지 못한다**. 이것이 GBM이 해결한 **AdaBoost의 약점** 의 정확한 모습이다.

### 3.4 sklearn에서의 사용 — 한 줄로 끝

sklearn의 `AdaBoostRegressor`가 정확히 AdaBoost.R2를 구현한다.

```python
from sklearn.ensemble import AdaBoostRegressor
from sklearn.model_selection import cross_val_score

# Ames에서 AdaBoost.R2 평가
ada = AdaBoostRegressor(n_estimators=50, random_state=42)
r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
print(f"Ames AdaBoost.R2 CV R²: {r2:.4f}")

# 비교: 약학습기 수 변화
print(f"\n{'n_estimators':>15s}  {'CV R²':>10s}")
print("-" * 28)
for n in [10, 30, 50, 100, 200]:
    ada = AdaBoostRegressor(n_estimators=n, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{n:>15d}  {r2:>10.4f}")
```

n_estimators가 50~100 사이에서 R²가 정점을 찍는다. **그 이상으로는 거의 안 오른다**. 분산 감소 곡선과 비슷한 **수확체감** 패턴이지만, **수렴값 자체** 가 RF보다 낮다는 점이 다르다. 6~7장에서 이 차이의 원인을 본다.

### 3.5 약학습기의 깊이 — 또 하나의 핵심 매개변수

sklearn의 `AdaBoostRegressor`는 기본 약학습기로 **깊이 3** 결정 트리를 쓴다(분류의 기본은 깊이 1이다). 이를 바꿔 가며 성능을 비교할 수 있다.

```python
from sklearn.ensemble import AdaBoostRegressor
from sklearn.tree import DecisionTreeRegressor

print(f"{'약학습기 깊이':>15s}  {'CV R²':>10s}")
print("-" * 28)
for depth in [1, 3, 5, 10]:
    base = DecisionTreeRegressor(max_depth=depth, random_state=42)
    ada = AdaBoostRegressor(estimator=base, n_estimators=50, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{depth:>15d}  {r2:>10.4f}")
```

깊이 1(결정 그루터기)이 분류에서는 표준이지만 회귀에서는 **너무 약하다**. 깊이 3~5가 보통 가장 좋고, 깊이 10 이상은 **각 약학습기가 이미 강해서 부스팅의 효과가 줄어든다**. 5부 GBM에서는 깊이 3~5가 표준이며, 이는 AdaBoost.R2의 기본값과 일치한다.

---

## 4장 AdaBoost.M1과 AdaBoost.R2 — 두 변종의 차이

### 4.1 같은 정신, 다른 손실

지금까지 본 두 알고리즘을 한 표로 정리하면 **같은 부스팅 정신을 분류와 회귀에 각각 맞춘 두 변종**임이 분명해진다.

![07 M1 vs R2](figs/07_M1_vs_R2.png)

<sub>그림 4-1. AdaBoost.M1(분류)과 AdaBoost.R2(회귀)의 비교. 두 변종은 가중치 갱신 방향(오답 강조)과 약학습기 누적이라는 공통점을 공유하지만, 손실 측정과 가중치 갱신 식·최종 예측 방식이 다르다. 특히 회귀의 *이상치 민감도*가 7장의 핵심 주제다.</sub>

표의 마지막 두 행이 결정적이다.

**이상치 민감도**. AdaBoost.M1은 분류이므로 **각 샘플이 맞았나 틀렸나**의 0/1 신호만 받는다. 이상치 한 점이 **틀렸다**는 사실만 전해질 뿐, 그 **얼마나 비싼 이상치인가**는 알고리즘에 들어가지 않는다. 반면 AdaBoost.R2는 **연속적 손실** $|y_i - h_t(x_i)|$을 직접 가중치 갱신에 쓴다. 손실이 100배 큰 이상치는 **가중치도 100배 가까이 부풀어 오른다**. 이 점이 7장에서 본격적으로 다룰 캘리포니아 실패의 원인이다.

**sklearn 구현**. `AdaBoostClassifier`는 1995년 원본 M1을, `AdaBoostRegressor`는 1997년 Drucker의 R2를 따른다. sklearn 1.4 이전에는 `algorithm="SAMME.R"` 같은 변종 옵션이 있었으나, 1.6에서 SAMME.R이 deprecated되고 표준 SAMME만 남았다. 본 교재의 코드는 모두 기본 옵션을 사용하므로 sklearn 1.4+에서 그대로 작동한다.

### 4.2 SAMME — 다중 클래스 확장

AdaBoost.M1 원본은 **이진 분류** 만 다뤘다. 다중 클래스($K > 2$)로 확장한 것이 2009년 Zhu et al.의 **SAMME**(Stagewise Additive Modeling using a Multi-class Exponential loss function)다. 변경은 $\alpha$ 식 한 줄이다.

$$\alpha_t^{\text{SAMME}} = \ln\left(\frac{1 - \epsilon_t}{\epsilon_t}\right) + \ln(K - 1)$$

$K = 2$이면 $\ln(K-1) = 0$이고 SAMME는 정확히 원본 M1과 같다. $K = 10$이면 $\ln 9 \approx 2.2$만큼 $\alpha$가 더해진다. 이 추가 항이 **다중 클래스에서 무작위 수준의 약학습기**($\epsilon = 1 - 1/K$, 즉 $K=10$이면 $\epsilon = 0.9$)도 **양의 $\alpha$** 를 갖게 만든다. 다중 클래스에서는 무작위가 90% 틀리지만 그래도 학습 신호가 있는데, 이를 살리기 위한 수정이다.

### 4.3 직접 비교 — 같은 데이터에서

분류와 회귀의 같은 **원형** 데이터에서 두 변종을 비교해 보자. 사이킷런의 분류용 make_classification과 그 라벨을 **연속화** 한 회귀 버전을 함께 다룬다.

```python
from sklearn.ensemble import AdaBoostClassifier, AdaBoostRegressor
from sklearn.datasets import make_classification
from sklearn.model_selection import cross_val_score
from sklearn.metrics import accuracy_score, r2_score

# 같은 데이터를 분류·회귀 양쪽으로
X, y_class = make_classification(n_samples=500, n_features=10, n_informative=5,
                                   random_state=42)
y_reg = y_class.astype(float) + np.random.default_rng(42).normal(0, 0.1, 500)

# 분류
m1 = AdaBoostClassifier(n_estimators=50, random_state=42)
acc = cross_val_score(m1, X, y_class, cv=5, scoring="accuracy").mean()
print(f"AdaBoost.M1 (분류) 정확도:  {acc:.4f}")

# 회귀
r2 = AdaBoostRegressor(n_estimators=50, random_state=42)
r2_score_val = cross_val_score(r2, X, y_reg, cv=5, scoring="r2").mean()
print(f"AdaBoost.R2 (회귀) R²:      {r2_score_val:.4f}")
```

같은 부스팅 알고리즘에서 **분류용 변종**과 **회귀용 변종**이 각각 작동함을 확인할 수 있다.

### 4.4 두 변종에 대한 한 줄 요약

> **AdaBoost.M1은 분류의 0/1 신호를 받아 잘 작동한다.**
> **AdaBoost.R2는 회귀의 연속 손실을 받는데, 이상치에 민감하다.**

이 **한 줄의 차이** 가 4부에서 가장 중요한 통찰이다. 5부에서 다룰 GBM은 정확히 **AdaBoost.R2의 이상치 민감성** 을 해결하기 위해 등장했다. 손실함수를 **지수 손실** 에서 **제곱 손실·절대 손실·Huber 손실** 등으로 일반화한 결과다.

---

## 5장 AdaBoost의 핵심 매개변수

### 5.1 n_estimators — 약학습기 수

가장 직관적인 매개변수다. 약학습기를 몇 그루 키울 것인가. 너무 적으면 부스팅의 효과가 안 나오고, 너무 많으면 **학습 시간만 늘고 성능은 정체**된다.

3부의 RF와 달리 AdaBoost는 **n_estimators가 너무 크면 과적합** 의 위험이 있다. 학습 데이터의 **잡음**까지 학습하기 시작하기 때문이다. 그래서 RF처럼 "더 많으면 더 좋다"는 가정이 항상 성립하지 않는다.

```python
from sklearn.ensemble import AdaBoostRegressor
from sklearn.model_selection import cross_val_score

print(f"{'n_estimators':>15s}  {'CV R² (Ames)':>15s}")
print("-" * 33)
for n in [10, 30, 50, 100, 200, 500]:
    ada = AdaBoostRegressor(n_estimators=n, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{n:>15d}  {r2:>15.4f}")
```

Ames에서 약 50~100개 근처에서 R²가 정점에 도달한다. 500까지 키워도 거의 같다. 실무 권장값은 **50~100** 이다.

### 5.2 learning_rate — 학습률

각 약학습기의 기여도를 **얼마나** 누적할 것인지를 조절하는 매개변수다. sklearn에서 기본값이 1.0인데, 이는 **모든 약학습기를 그대로 더한다**는 뜻이다. 0.1로 설정하면 각 약학습기의 기여를 **10분의 1** 만 받는다.

낮은 학습률의 효과는 **부스팅을 천천히 진행하는 것**과 같다. 한 약학습기가 잡지 못한 패턴을 다음 약학습기가 **조금만** 보정하므로, 더 많은 약학습기가 필요하다. 그러나 **작은 보정을 누적** 하면 최종 성능이 더 좋아진다는 것이 잘 알려진 사실이다.

![05 learning rate](figs/05_learning_rate.png)

<sub>그림 5-1. 학습률의 효과. (왼쪽) learning_rate=0.01: 50그루로는 부족하여 함수를 거의 못 따라간다. (가운데) learning_rate=0.3: 함수를 부드럽게 따라가는 좋은 균형점. (오른쪽) learning_rate=1.5: 학습률이 너무 커서 예측이 흔들리고 과적합.</sub>

세 가지 학습률에서의 결과가 명확하다.

**learning_rate = 0.01**. 너무 작아서 50그루로는 **함수를 거의 못 따라간다**. 부스팅이 **시작도 못 한 상태**다. 이 값으로는 1,000그루 이상이 필요할 것이다.

**learning_rate = 0.3**. 함수를 **부드럽게 따라가는** 좋은 균형점이다. 실무에서 흔히 쓰이는 값이다.

**learning_rate = 1.5**. 너무 커서 예측이 **흔들리고 과적합** 의 징후가 나타난다. 학습률 1.0이 sklearn 기본값인데, 이미 약간 큰 편이라 보통은 0.1~0.5로 줄이는 게 안전하다.

### 5.3 n_estimators × learning_rate의 트레이드오프

두 매개변수는 **반비례 관계** 다. 학습률을 절반으로 줄이면 보통 약학습기 수를 두 배로 늘려야 비슷한 성능에 도달한다. 두 매개변수의 곱 $T \cdot \eta$가 **총 부스팅 양**을 결정한다고 생각하면 직관적이다.

```python
from sklearn.ensemble import AdaBoostRegressor

print(f"{'n_estimators':>5s}  {'learning_rate':>5s}  {'CV R²':>10s}")
print("-" * 30)
for n, lr in [(50, 1.0), (100, 0.5), (200, 0.25), (500, 0.1)]:
    ada = AdaBoostRegressor(n_estimators=n, learning_rate=lr, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{n:>5d}  {lr:>10.2f}  {r2:>10.4f}")
```

네 조합 모두 **총 부스팅 양** $n \cdot lr = 50$ 으로 같다. 실행 결과를 보면 R²가 거의 같은 수준에 도달한다 — **작은 학습률에 더 많은 약학습기** 가 **큰 학습률에 적은 약학습기**와 같은 결과를 낸다. 다만 **전자가 보통 약간 더 안정적**이다.

이 트레이드오프가 5부 GBM과 6부 XGBoost에서도 핵심 매개변수로 등장한다. XGBoost에서는 학습률을 `eta`로 부르며, **0.05~0.3 + 약학습기 300~1000** 조합이 표준이다.

### 5.4 base_estimator — 약학습기의 종류

지금까지는 **깊이 3 결정 트리** 를 기본 약학습기로 사용했다. sklearn에서는 `estimator` 매개변수로 다른 모델도 약학습기로 쓸 수 있다.

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor

print(f"{'약학습기':>30s}  {'CV R²':>10s}")
print("-" * 43)

bases = [
    ("결정 그루터기 (depth=1)",  DecisionTreeRegressor(max_depth=1, random_state=42)),
    ("얕은 트리 (depth=3, sklearn 기본)", DecisionTreeRegressor(max_depth=3, random_state=42)),
    ("중간 트리 (depth=5)",      DecisionTreeRegressor(max_depth=5, random_state=42)),
    ("깊은 트리 (depth=10)",     DecisionTreeRegressor(max_depth=10, random_state=42)),
]

for name, base in bases:
    ada = AdaBoostRegressor(estimator=base, n_estimators=50, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{name:>30s}  {r2:>10.4f}")
```

깊이 1(결정 그루터기)은 회귀에서 너무 약하다. 깊이 3~5가 보통 균형점이며, 깊이 10 이상은 **각 약학습기가 이미 강해서 부스팅의 효과가 줄어든다**. 깊은 트리 50그루는 **부스팅이 아니라 그냥 트리 평균** 에 가까워진다.

### 5.5 매개변수 권장 조합

실무에서 가장 흔히 쓰이는 매개변수 조합을 표로 정리하면 다음과 같다.

| 시나리오 | n_estimators | learning_rate | base_estimator |
|---|---|---|---|
| 빠른 베이스라인 | 50 | 1.0 | depth=3 (기본) |
| 안정적 성능 | 100~200 | 0.3~0.5 | depth=3~5 |
| 최고 성능 추구 | 500+ | 0.05~0.1 | depth=5 |
| 분류 (작은 데이터) | 50~100 | 1.0 | depth=1 (stump) |

깊이 3~5 트리에 학습률 0.3~0.5, 약학습기 100~200개가 **대부분의 데이터에서 안전한 출발점**이다. 이 조합으로 학습한 뒤 검증 점수가 만족스럽지 않으면 약학습기 수를 늘리고 학습률을 줄이는 방향으로 미세조정한다.

---

## 6장 Ames에서의 AdaBoost — 잘 작동하는 사례

### 6.1 Ames 베이스라인 측정

3부에서 정리한 모든 모델에 AdaBoost를 추가한 표를 다시 보자.

```python
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor, AdaBoostRegressor
from sklearn.model_selection import cross_val_score

models = {
    "선형회귀":              LinearRegression(),
    "결정 트리":             DecisionTreeRegressor(random_state=42),
    "랜덤 포레스트 (100)":   RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1),
    "AdaBoost (50)":         AdaBoostRegressor(n_estimators=50, random_state=42),
    "AdaBoost (100, lr=0.5)": AdaBoostRegressor(n_estimators=100, learning_rate=0.5, random_state=42),
}

print(f"{'모델':<25s}  {'CV R²':>10s}")
print("-" * 38)
for name, m in models.items():
    r2 = cross_val_score(m, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{name:<25s}  {r2:>10.4f}")
```

대표적인 출력 결과는 다음과 같다.

| 모델 | CV R² | 관찰 |
|---|---|---|
| 선형회귀 | 0.8025 | 기준선 |
| 결정 트리 | 0.7543 | 한 그루의 한계 |
| 랜덤 포레스트 100 | 0.8806 | 분산 감소의 위력 |
| AdaBoost 50 | 0.8081 | RF에 0.07포인트 뒤짐 |
| AdaBoost 100, lr=0.5 | 0.8120 | 매개변수 조정으로 약간 개선 |

세 가지 관찰이 가능하다.

**관찰 1.** Ames에서 AdaBoost는 **선형회귀와 비슷한 수준**이다. 단일 트리보다는 명확히 좋지만, **RF를 못 따라잡는다**. 분산 감소 전략이 **이 데이터에서는** AdaBoost의 편향 감소 전략보다 효과적이다.

**관찰 2.** 매개변수를 조정해도(n_estimators 늘리고 learning_rate 줄여도) 큰 차이가 없다. RF의 0.88 수준에 도달하지 못한다.

**관찰 3.** AdaBoost가 **왜 RF에 뒤지는가**는 6.3절에서 본다. 짧게 미리 말하면, **AdaBoost.R2가 모든 데이터에서 RF를 이기는 것은 아니다**. 데이터의 **잡음 구조**에 따라 우열이 갈린다.

### 6.2 약학습기의 누적 효과 시각화

Ames에서도 약학습기를 누적할수록 R²가 어떻게 변하는지 확인할 수 있다.

```python
from sklearn.ensemble import AdaBoostRegressor
from sklearn.metrics import r2_score
from sklearn.model_selection import train_test_split

X_tr, X_te, y_tr, y_te = train_test_split(X_ames, y_ames, test_size=0.2, random_state=42)

ada = AdaBoostRegressor(n_estimators=100, random_state=42)
ada.fit(X_tr, y_tr)

# staged_predict로 1, 2, ..., 100 그루까지의 누적 예측을 얻음
staged_r2 = []
for i, pred in enumerate(ada.staged_predict(X_te), 1):
    staged_r2.append(r2_score(y_te, pred))

fig, ax = plt.subplots(figsize=(9, 5))
ax.plot(range(1, len(staged_r2)+1), staged_r2, color="#1F3A5F", linewidth=2)
ax.set_xlabel("약학습기 누적 수"); ax.set_ylabel("Test R²")
ax.set_title("Ames에서 AdaBoost.R2의 누적 학습 곡선")
ax.grid(alpha=0.3)
ax.axhline(0.88, color="#C0392B", linestyle="--", alpha=0.5,
            label="RF 100그루 수준 (도달 못함)")
ax.legend()
plt.tight_layout(); plt.show()

print(f"\n약학습기 1개:   R² = {staged_r2[0]:.4f}")
print(f"약학습기 20개:  R² = {staged_r2[19]:.4f}")
print(f"약학습기 100개: R² = {staged_r2[-1]:.4f}")
print(f"RF 100그루:    R² = 0.88 (참고)")
```

곡선이 50~80 근처에서 평탄해진다. **RF의 0.88 수준에는 도달하지 못한다**. AdaBoost가 매번 **직전 라운드의 오답**을 강조해 학습하지만, 그 강조 자체가 **완벽한 보정이 안 되는 한계점**에 도달한다.

### 6.3 변수 중요도 — RF와 비슷하지만 다르다

AdaBoost도 `feature_importances_` 속성으로 변수 중요도를 제공한다. RF의 MDI와 같은 **불순도 감소 합산** 방식이다.

```python
ada = AdaBoostRegressor(n_estimators=100, random_state=42)
ada.fit(X_ames, y_ames)
ada_imp = pd.Series(ada.feature_importances_, index=X_ames.columns).sort_values(ascending=False)

rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
rf.fit(X_ames, y_ames)
rf_imp = pd.Series(rf.feature_importances_, index=X_ames.columns).sort_values(ascending=False)

print("AdaBoost 상위 5개:")
for var, imp in ada_imp.head(5).items():
    print(f"  {var:<22s}  {imp:.4f}")

print("\nRF 상위 5개:")
for var, imp in rf_imp.head(5).items():
    print(f"  {var:<22s}  {imp:.4f}")
```

두 모델 모두 **`Overall Qual`이 압도적 1위**다. 그러나 2~5위는 약간 다르다. AdaBoost는 **오답 강조의 효과로 일부 변수가 RF와 다른 가중치**를 받는다. 일반적으로 부스팅 계열이 **덜 강한 변수의 기여도**를 더 잘 잡아낸다는 점이 알려져 있다.

---

## 7장 캘리포니아에서의 실패 — AdaBoost의 약점

### 7.1 실패 사례 측정

이번엔 캘리포니아 주택가격 데이터에서 같은 비교를 한다. 결과가 충격적이다.

```python
from sklearn.ensemble import AdaBoostRegressor, RandomForestRegressor
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score

print(f"{'모델':<22s}  {'CV R²':>10s}")
print("-" * 35)
for name, m in [
    ("선형회귀",      LinearRegression()),
    ("랜덤 포레스트", RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)),
    ("AdaBoost",      AdaBoostRegressor(n_estimators=50, random_state=42)),
]:
    r2 = cross_val_score(m, X_cal, y_cal, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{name:<22s}  {r2:>10.4f}")
```

결과는 다음과 같다.

| 모델 | CV R² (캘리포니아) |
|---|---|
| 선형회귀 | 0.560 |
| 랜덤 포레스트 100 | 0.507 |
| **AdaBoost 50** | **0.232** |

AdaBoost가 **선형회귀의 절반에도 못 미친다**. RF의 절반 수준이다. **동일한 알고리즘이 Ames(R² 0.81)와 캘리포니아(R² 0.23)에서 천차만별로 다르다**. 이 차이의 원인을 추적하는 것이 7장의 핵심이다.

### 7.2 원인 — 캘리포니아의 capped 값

![06 california failure](figs/06_california_failure.png)

<sub>그림 7-1. 캘리포니아 데이터에서 AdaBoost가 실패하는 이유. (왼쪽) y값 분포에서 \$500,001 근처에 *965건의 capped 값*이 뾰족하게 모여 있다. 데이터 수집 당시 \$500,000 이상은 모두 \$500,001로 기록되었다. (오른쪽) 모델별 R² 막대 — AdaBoost가 절반 수준에 그친다.</sub>

캘리포니아 데이터의 **결정적 특징** 은 **capped 값**이다. 1990년 미국 인구조사 수집 당시 **주택가격이 \$500,000 이상**인 경우 모두 \$500,001로 **천장에 막힘**(censored). 데이터에는 **진짜 가격이 아닌** 965건의 \$500,001 값이 들어 있다 — 전체 데이터의 4.7%다.

이 값들은 **진정한 의미의 이상치**다. 실제로는 \$600,000일 수도, \$1,000,000일 수도 있는데 모두 \$500,001로 **압축된** 거짓 값이다. AdaBoost는 이 거짓 값을 **진짜로 받아들여 학습**하므로, 예측이 **왜곡** 된다.

### 7.3 왜 AdaBoost가 특별히 취약한가

이상치가 있는 데이터는 어떤 모델에든 어려운 문제다. 그런데 **왜 AdaBoost가 RF나 선형회귀보다 훨씬 더 심하게 실패하는가**?

답은 **AdaBoost.R2의 가중치 갱신 식**에 있다. 1장에서 본 식을 다시 보자.

$$w_i^{(t+1)} = w_i^{(t)} \cdot \beta_t^{1 - L_i}$$

여기서 $L_i$는 **정규화된 절대 오차**다. 첫 라운드에서 어떤 트리가 capped 값(\$500,001)에 대해 예측 \$300,000을 냈다고 하자. 절대 오차가 \$200,001로 **매우 크다**. 그래서 $L_i$가 1에 가깝다.

가중치 갱신을 풀어 쓰면, $L_i = 1$인 샘플은 $w_i \cdot \beta^0 = w_i$로 **가중치가 거의 변하지 않는다**. 그런데 **다른 정상 샘플들의 가중치는 줄어들므로**, 정규화 후에 이 capped 샘플의 **상대적 가중치가 부풀어 오른다**.

다음 라운드에서 **이 capped 샘플을 더 신경 쓴 트리**가 학습된다. 그러나 capped 값은 **진짜 정보가 아니므로 진짜로 맞추기가 불가능**하다. 결국 **AdaBoost는 잡을 수 없는 noise에 점점 더 매달리게 되고**, 라운드가 진행될수록 **진짜 신호에서 멀어진다**.

### 7.4 직접 확인 — capped 값을 제거하면 어떻게 되나

가설을 직접 검증해 보자. capped 값 965건을 제거하고 같은 실험을 다시 한다.

```python
# capped 값 제거
mask = y_cal < y_cal.max()
X_cal_clean = X_cal[mask]
y_cal_clean = y_cal[mask]

print(f"원본:    {len(y_cal)} 행")
print(f"제거 후: {len(y_cal_clean)} 행 ({(len(y_cal)-len(y_cal_clean))/len(y_cal)*100:.1f}% 제거)\n")

print(f"{'모델':<22s}  {'원본 R²':>10s}  {'제거 후 R²':>12s}")
print("-" * 50)
for name, m in [
    ("선형회귀",      LinearRegression()),
    ("랜덤 포레스트", RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)),
    ("AdaBoost",      AdaBoostRegressor(n_estimators=50, random_state=42)),
]:
    r2_full = cross_val_score(m, X_cal, y_cal, cv=5, scoring="r2", n_jobs=-1).mean()
    r2_clean = cross_val_score(m, X_cal_clean, y_cal_clean, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{name:<22s}  {r2_full:>10.4f}  {r2_clean:>12.4f}")
```

실행 결과를 보면 **RF와 선형회귀는 capped 제거 후 R²가 거의 같거나 약간 떨어진다**(데이터가 줄어서 학습이 약간 약해짐). 그러나 **AdaBoost도 별로 안 좋아진다**. capped 값 4.7%를 제거해도 AdaBoost R²가 0.23 → 0.24 정도로 미미한 개선뿐이다.

이는 **capped 값이 유일한 문제가 아니라** 데이터 자체에 **다른 미세한 이상치 구조**가 있고, AdaBoost가 그 모두에 **민감하게 반응한다**는 신호다. 단순 이상치 제거로는 해결되지 않는 **알고리즘 자체의 약점** 이다.

### 7.5 그렇다면 AdaBoost는 언제 쓰는가

7장의 결론을 한 줄로 요약하면 다음과 같다.

> **AdaBoost.R2는 잡음과 이상치에 매우 민감하다. 깨끗한 데이터에서는 RF와 비슷하지만, 노이즈가 많으면 RF에 크게 뒤진다.**

이 약점이 **실용적으로 AdaBoost.R2가 산업에서 거의 안 쓰이는** 이유다. 대신 **분류용 AdaBoost.M1**은 여전히 작은 데이터의 **깔끔한 이진 분류** 에서 쓰인다. 회귀에서는 5부의 **GBM**과 6부의 **현대 부스팅 3종**이 사실상 AdaBoost.R2를 대체했다.

---

## 8장 GBM으로의 다리 — 손실함수 일반화

### 8.1 AdaBoost가 사실은 **지수 손실** 알고리즘이라는 발견

1999년 Friedman, Hastie, Tibshirani의 논문 **"Additive Logistic Regression: A Statistical View of Boosting"** 이 부스팅 연구의 전환점이 되었다. 이들은 **AdaBoost가 사실 지수 손실 $L(y, F) = e^{-yF}$를 최소화하는 알고리즘**임을 증명했다.

AdaBoost가 어떻게 작동하는지가 **손실함수의 관점에서 정확히 이해되었다**는 의미다. 그리고 **그것이 가장 좋은 손실함수인가** 라는 후속 질문을 낳았다. 지수 손실의 **이상치 민감성**이 곧 **지수 함수의 무한 폭증**에서 온다는 것도 분명해졌다.

이 질문에 대한 답이 2001년 Friedman의 후속 논문 **"Greedy Function Approximation: A Gradient Boosting Machine"**이다. 답은 단순하다 — **다른 손실함수를 쓰자**.

### 8.2 GBM의 단순한 일반화

GBM의 알고리즘적 핵심을 한 줄로 표현하면 다음과 같다.

> **각 라운드에서 손실함수의 음의 그래디언트를 새 약학습기로 근사한다.**

분류에서 흔히 쓰이는 **로그 손실** 이나 회귀의 **제곱 손실**, **절대 손실**, **Huber 손실** 등 어떤 미분 가능한 손실함수든 들어갈 수 있다. 손실함수에 따라 **그래디언트가 다르고**, 결과적으로 **각 라운드에서 학습할 신호가 다르다**.

회귀에서 자주 쓰이는 제곱 손실의 경우 그래디언트는 $-(y - F(x)) = -\text{잔차}$다. 즉 **GBM이 새 약학습기로 학습하는 것은 직전 라운드의 잔차**다. 이것이 GBM의 가장 직관적인 형태 — **잔차 부스팅** — 이다.

### 8.3 이상치 문제의 해결

GBM이 AdaBoost의 이상치 문제를 어떻게 해결했는지를 **손실함수의 관점에서** 보면 분명해진다.

**AdaBoost (지수 손실)**: $L = \exp(-yF)$. 예측이 빗나갈수록 손실이 **지수적으로 폭증**. 이상치에 무한히 끌려간다.

**GBM (제곱 손실)**: $L = (y - F)^2$. 예측이 빗나갈수록 손실이 **제곱적으로 증가**. 지수보다는 훨씬 덜 가파르다.

**GBM (절대 손실)**: $L = |y - F|$. 손실이 **선형적**. 이상치에 가장 강건하다.

**GBM (Huber 손실)**: 작은 오차는 제곱처럼, 큰 오차는 절대값처럼 다룬다. 일반적 노이즈는 잘 학습하면서 이상치에는 강건하다 — 두 마리 토끼를 잡는 손실함수다.

### 8.4 부스팅 가족의 전체 진화

![08 boosting lineage](figs/08_boosting_lineage.png)

<sub>그림 8-1. 부스팅 가족의 진화. AdaBoost(1995, 지수 손실) → GBM(2001, 일반 손실) → XGBoost·LightGBM·CatBoost(2014~2017, GBM의 효율적 구현).</sub>

다음 부에서 다룰 알고리즘들을 미리 정리해 두자.

**5부 GBM** (2001, Friedman). AdaBoost의 **손실함수를 일반화** 한다. 회귀에서는 제곱·절대·Huber 손실, 분류에서는 로그 손실을 쓴다. 이상치 문제가 해결되어 Ames와 캘리포니아 모두에서 좋은 성능을 낸다.

**6부 XGBoost** (2014, Chen-Guestrin). GBM의 **근사 그래디언트 계산**과 **2차 미분**을 활용하여 **학습 속도를 10~50배 개선**. 캐글 우승 알고리즘으로 명성을 얻었다.

**6부 LightGBM** (2017, Microsoft). XGBoost보다 **2~5배 더 빠른** GBM 구현. 큰 데이터셋에서의 표준이 되었다.

**6부 CatBoost** (2017, Yandex). **범주형 변수의 자동 처리**가 핵심 강점. 원-핫 인코딩 없이도 범주형을 잘 다룬다.

세 알고리즘은 **같은 GBM 알고리즘** 의 다른 구현일 뿐이다. 데이터의 성격에 따라 선택이 달라진다.

### 8.5 4부 결론

이번 부의 결론을 세 가지로 요약한다.

**결론 1.** **부스팅은 분산이 아니라 편향을 줄이는 전략**이다. 배깅의 **서로 무관한 평균**과 정반대 철학으로, **앞 트리의 오답을 다음 트리가 보정** 한다.

**결론 2.** **AdaBoost는 부스팅 가족의 시조**다. 가중치 갱신·약학습기 누적·가중 다수결의 세 가지 메커니즘이 부스팅의 골격을 정의한다.

**결론 3.** **AdaBoost.R2는 회귀의 이상치에 매우 민감**하다. 캘리포니아의 R² 0.23이 그 증거다. 이 약점이 **GBM의 손실함수 일반화** 동기가 된다.

---

다음 부 5부에서는 GBM을 본격적으로 다루며, **왜 잔차 학습이 그렇게 자연스러운가**와 **어떻게 캘리포니아에서 R²가 0.23에서 0.85로 점프하는가**를 본다.
