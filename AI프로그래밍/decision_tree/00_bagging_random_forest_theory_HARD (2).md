# 3부 결정 트리, 배깅, 그리고 랜덤 포레스트

## 어려운 버전 — 학부 1~2학년용

본 자료는 학생이 혼자서 읽고 실습할 수 있도록 구성된 자습 교재이다. 각 절에는 핵심 개념의 설명, 직관을 돕는 그림, 그리고 곧장 실행해 볼 수 있는 파이썬 코드가 함께 들어 있다. Ames 주택가격 데이터(2,930채, 82개 변수)를 단일 사례로 사용하여 결정 트리 한 그루의 작동부터 랜덤 포레스트 100그루의 앙상블까지를 같은 데이터 위에서 따라간다.

본 교재의 코드는 Jupyter Notebook, Google Colab, 그리고 로컬 Python 환경에서 모두 작동한다. 첫 코드 블록을 실행하기 전에 필요한 라이브러리를 한 번 설치해 두면 된다.

```python
# 필요 라이브러리 (한 번만 실행)
# !pip install pandas numpy matplotlib scikit-learn koreanize-matplotlib
```

`koreanize-matplotlib`는 NanumGothic을 자동으로 적용하여 그래프의 한글 깨짐을 막아 주는 라이브러리이다. 그래프를 그릴 때 한 줄 import만 추가하면 된다.

데이터 로딩은 전체 교재에서 한 번만 실행하면 되는 표준 패턴을 따른다.

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import koreanize_matplotlib  # 한글 폰트(NanumGothic) 자동 설정
import warnings
warnings.filterwarnings("ignore")

URL = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/AmesHousing.csv"

try:
    df_raw = pd.read_csv(URL)
    print(f"로딩 성공: {df_raw.shape}")
except Exception:
    rng = np.random.default_rng(42)
    n = 2930
    df_raw = pd.DataFrame({
        "Overall Qual": rng.integers(1, 11, n),
        "Gr Liv Area": (rng.gamma(2.5, 600, n) + 400).astype(int),
        "Total Bsmt SF": (rng.gamma(2.0, 400, n) + 100).astype(int),
        "Year Built": rng.integers(1900, 2011, n),
        "Garage Cars": rng.integers(0, 4, n),
        "SalePrice": (rng.gamma(2.0, 80000, n) + 60000).astype(int),
    })
    print("폴백 합성 데이터 사용")
```

전처리는 1부에서 정의한 `prepare_ames` 함수를 그대로 사용한다.

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
    if "Year Built" in df.columns and "Yr Sold" in df.columns:
        df["House Age"] = (df["Yr Sold"] - df["Year Built"]).clip(lower=0)
    
    return df

df = prepare_ames(df_raw)
y = np.log1p(df["SalePrice"])
X = df.select_dtypes("number").drop(columns=["SalePrice"])
print(f"X: {X.shape}, y: {y.shape}")
```

전처리된 데이터 `X`(약 2,926행, 수치형 변수)와 타깃 `y`(log SalePrice)가 0장부터 8장까지의 모든 실습에서 사용된다.

---

## 0장 결정 트리 — 질문의 사슬로 답을 찾는 모델

### 0.1 결정 트리란 무엇인가

결정 트리는 데이터에 대한 일련의 예/아니오 질문을 트리 모양으로 쌓아 답을 내는 모델이다. 뿌리 노드에서 시작하여 각 노드의 질문에 답한 방향으로 가지를 따라 내려가다 보면, 더 이상 질문이 없는 잎 노드에 도달한다. 그 잎 노드가 가진 값이 그 입력에 대한 예측이다.

예를 들어 Ames 데이터의 한 주택에 대해 결정 트리는 다음과 같이 작동한다.

![01 decision tree basic](figs/01_decision_tree_basic.png)

<sub>그림 0-1. 결정 트리는 뿌리에서 잎까지의 한 경로를 따라 예측한다. 입력값이 [Overall Qual=8, Gr Liv Area=2100, Total Bath=3.0]이면 첫 노드에서 'Overall Qual ≤ 7?'에 No이므로 오른쪽으로 가고, 다음 노드의 'Total Bath ≤ 2.5?'에도 No이므로 다시 오른쪽으로 가서 잎 노드 $340k를 예측값으로 받는다.</sub>

트리 모델은 두 가지 매력적인 성질을 갖는다. 첫째, **해석 가능성**(interpretability)이 매우 높다. 어떤 입력이 왜 그런 예측을 받았는지를 질문의 사슬로 명확히 설명할 수 있다. 둘째, 입력 변수의 **단조 변환**(monotone transformation)에 불변이다. `Gr Liv Area`에 로그를 씌우든 제곱근을 씌우든, 트리의 분할 결과는 똑같다. 선형 모델은 변수 변환에 매우 민감하지만, 트리는 임계값으로만 변수를 본다.

#### 실습 — 한 그루 트리를 직접 키워 보기

`DecisionTreeRegressor`를 깊이 제한 없이 학습시키면 학습 데이터에 거의 완벽하게 맞춰진다. 그러나 그 트리의 깊이와 잎 개수를 보면 한 그루가 위험한 이유가 한눈에 드러난다.

```python
from sklearn.tree import DecisionTreeRegressor

# 깊이 제한 없는 트리
full_tree = DecisionTreeRegressor(random_state=42)
full_tree.fit(X, y)

print(f"트리 깊이:   {full_tree.get_depth()}")
print(f"잎 노드 수:  {full_tree.get_n_leaves()}")
print(f"학습 R²:     {full_tree.score(X, y):.4f}")
```

위 코드를 실행하면 다음과 같은 출력을 보게 된다.

```
트리 깊이:   26
잎 노드 수:  2376
학습 R²:     0.9989
```

학습 R²가 1.0에 가깝다는 것은 트리가 학습 데이터의 거의 모든 패턴을 외워 버렸다는 의미다. 잎 노드가 2,376개라는 점도 충격적이다 — Ames 행이 2,926개이므로 사실상 행 하나에 잎 하나가 대응한 셈이다. 새 집이 들어오면 트리는 학습 데이터에서 그와 비슷한 한 채만 찾아 그 가격을 그대로 돌려준다. 이런 모델이 새로운 데이터에 잘 일반화될 리 없다. 이 현상이 **과적합**(overfitting)이다.

깊이를 제한하면 어떻게 될까. 곧장 비교해 본다.

```python
for d in [3, 5, 10, None]:
    t = DecisionTreeRegressor(max_depth=d, random_state=42)
    t.fit(X, y)
    label = f"max_depth={d}" if d else "max_depth=무제한"
    print(f"{label:<20s}  잎 {t.get_n_leaves():>5d}개  학습 R² {t.score(X,y):.4f}")
```

깊이 3은 잎이 8개뿐이며 학습 R²가 약 0.65에 그친다. 단순한 트리가 학습 데이터에 **덜** 맞춰진다는 뜻이다. 이것이 좋은 일인지 나쁜 일인지는 **검증 R²**를 봐야 알 수 있다. 단순한 트리가 새 데이터에서 더 잘 작동할 수도 있다. 단일 트리에서 **깊이를 어떻게 정하는가**는 0장 마지막 절에서 본격적으로 다룬다.

### 0.2 분류 트리의 불순도 — 엔트로피와 지니

분류 문제부터 보자. 한 노드에 빨강 공 8개와 파랑 공 2개가 들어 있다. 이 노드는 비교적 순수하다(빨강이 압도적이다). 다른 노드에는 빨강 5개, 파랑 5개가 들어 있다. 이 노드는 완전히 불순하다(어느 색이라고 단정할 수 없다).

이 순수도와 불순도를 한 숫자로 요약하는 두 가지 표준 척도가 있다.

**엔트로피**(entropy)는 정보이론에서 가져온 척도다. 한 노드에 클래스 $k$가 비율 $p_k$로 들어 있을 때 다음과 같이 정의한다.

$$H = -\sum_{k=1}^{K} p_k \log_2 p_k$$

이 식을 풀어 보면, 한 클래스가 노드를 완전히 차지할 때 ($p_k = 1$, 나머지는 0) 엔트로피는 0이다. 모든 클래스가 균등하게 들어 있을 때 ($p_k = 1/K$) 엔트로피는 최댓값 $\log_2 K$가 된다. 이진 분류라면 최댓값은 1이다.

직관적으로 엔트로피는 그 노드의 답을 알리는 데 필요한 평균 정보량이다. 이미 답이 정해진 노드(엔트로피 0)는 알릴 정보가 없고, 완전히 불순한 노드(엔트로피 1)는 1비트의 정보가 필요하다.

**지니 불순도**(Gini impurity)는 같은 목적의 다른 척도다.

$$G = 1 - \sum_{k=1}^{K} p_k^2 = \sum_{k=1}^{K} p_k(1 - p_k)$$

지니 불순도는 그 노드에서 두 샘플을 무작위로 뽑았을 때 두 샘플이 서로 다른 클래스에 속할 확률이다. 한 클래스가 노드를 완전히 차지하면 두 샘플이 같은 클래스에 속할 확률이 1이므로 지니 불순도는 0이다. 균등 분포에서는 최댓값 $1 - 1/K$가 된다.

#### 실습 — 두 척도를 직접 그려 비교하기

두 척도의 모양을 이진 분류 ($K=2$)에 대해 그려 비교한다.

```python
import numpy as np
import matplotlib.pyplot as plt

p = np.linspace(0.001, 0.999, 200)

# 엔트로피: H(p) = -p log2(p) - (1-p) log2(1-p)
entropy = -p * np.log2(p) - (1-p) * np.log2(1-p)

# 지니 불순도: G(p) = 2 p (1-p)  [이진 분류에서]
# 지니 곡선이 엔트로피와 비교되도록 2를 곱하여 같은 최댓값으로 정규화
gini_scaled = 2 * p * (1 - p) * 2

fig, ax = plt.subplots(figsize=(8, 5))
ax.plot(p, entropy, color="#1F3A5F", linewidth=2.5, label="엔트로피 H(p)")
ax.plot(p, gini_scaled, color="#C0392B", linewidth=2.5, label="지니 불순도 × 2 (정규화)")
ax.axvline(0.5, color="gray", linestyle=":", alpha=0.5)
ax.set_xlabel("한 클래스의 비율 p"); ax.set_ylabel("불순도 값")
ax.set_title("엔트로피와 지니 — 같은 모양, 다른 척도")
ax.legend(); ax.grid(alpha=0.3)
plt.tight_layout(); plt.show()
```

위 코드의 출력을 미리 그려 두면 다음과 같다.

![02 entropy gini curve](figs/02_entropy_gini_curve.png)

<sub>그림 0-2. 엔트로피와 지니 불순도는 둘 다 p=0.5에서 최댓값을, p=0 또는 p=1에서 최솟값 0을 갖는다. 같은 정점을 갖는 같은 모양의 곡선이다.</sub>

두 척도는 거의 같은 모양이며, 실제로 트리가 선택하는 분할도 대부분 동일하다. 다만 차이가 있다. 엔트로피는 로그를 포함하므로 계산이 약간 느리고, 지니는 곱셈만 있어 빠르다. sklearn의 `DecisionTreeClassifier`는 기본값이 `criterion='gini'`이며, 큰 데이터에서의 속도 차이가 그 이유다.

### 0.3 회귀 트리의 불순도 — 분산

회귀 문제에서는 정답이 클래스가 아니라 실수다. 같은 불순도의 개념이 **분산**(variance)이 된다. 한 노드에 들어 있는 $y$값들의 분산이 크면 그 노드는 불순하다(예측이 잘 안 된다). 분산이 작으면 노드 안의 $y$값들이 거의 같다는 뜻이므로 좋은 예측을 줄 수 있다.

회귀 트리의 표준 불순도는 **평균 제곱 오차**(MSE, Mean Squared Error)이며, 한 노드 안의 분산과 같다.

$$\text{MSE}(\text{노드}) = \frac{1}{n_{\text{node}}} \sum_{i \in \text{노드}} (y_i - \bar{y}_{\text{node}})^2$$

이 식을 풀면, 노드 안의 모든 $y$ 값들의 평균 $\bar{y}_{\text{node}}$을 중심으로 얼마나 흩어져 있는가를 측정한다. 모든 $y$가 같으면 MSE는 0이다. 회귀 트리의 잎 노드 예측값은 그 노드에 속한 학습 샘플들의 $y$ **평균**이다.

#### 실습 — MSE vs MAE 분기 기준 비교

sklearn은 회귀 트리의 분기 기준으로 MSE(`squared_error`)와 MAE(`absolute_error`) 두 가지를 지원한다. MAE는 절댓값을 사용하여 이상치에 견고하지만 학습이 더 느리다.

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score
import time

for crit in ["squared_error", "absolute_error"]:
    t = DecisionTreeRegressor(criterion=crit, max_depth=5, random_state=42)
    t0 = time.time()
    r2 = cross_val_score(t, X, y, cv=5, scoring="r2").mean()
    dt = time.time() - t0
    print(f"criterion={crit:<18s}  CV R² {r2:.4f}  ({dt:.1f}s)")
```

전형적으로 MSE 기준이 약 10배 빠르다. 분할마다 평균만 계산하면 되는 MSE와 달리, MAE는 중앙값을 다시 계산해야 하기 때문이다. 이상치가 거의 없는 데이터(우리는 1부에서 거실 4,000 sq ft 이상 이상치 4건을 제거했다)에서는 두 기준의 점수가 거의 같다. 그래서 회귀 트리에서는 보통 MSE를 기본값으로 사용한다.

### 0.4 분기 — 가장 큰 정보이득을 주는 분할 찾기

이제 핵심 메커니즘이다. 분할 후보가 무수히 많다 — 어떤 변수를 쓸 것인가, 그 변수의 어떤 임계값에서 자를 것인가. 결정 트리는 모든 후보를 시도해 보고 불순도 감소가 가장 큰 후보를 고른다. 이 불순도 감소를 **정보이득**(information gain)이라 부른다.

분할 전 노드의 불순도를 $I_{\text{before}}$, 분할 후 두 자식 노드의 가중 평균 불순도를 $I_{\text{after}}$라 하면,

$$\text{정보이득} = I_{\text{before}} - I_{\text{after}}, \qquad I_{\text{after}} = \frac{n_L}{n} I_L + \frac{n_R}{n} I_R$$

여기서 $n_L, n_R$은 왼쪽과 오른쪽 자식의 샘플 수이고, $I_L, I_R$은 각 자식의 불순도다. 가중평균을 쓰는 이유는, 큰 자식의 불순도가 작은 자식의 불순도보다 더 큰 비중을 갖는 것이 공평하기 때문이다.

#### 실습 — 정보이득 직접 계산하기

Ames 데이터의 `Overall Qual ≤ 7` 분할이 얼마만큼의 MSE를 줄이는지 손으로 계산해 본다.

```python
import numpy as np

y_all = y.values
mse_before = y_all.var()

# Overall Qual ≤ 7 기준으로 분할
left_mask = X["Overall Qual"] <= 7
y_left = y_all[left_mask]
y_right = y_all[~left_mask]

n_total = len(y_all)
w_left = len(y_left) / n_total
w_right = len(y_right) / n_total

mse_after = w_left * y_left.var() + w_right * y_right.var()
gain = mse_before - mse_after

print(f"분할 전 MSE:    {mse_before:.5f}")
print(f"왼쪽 ({len(y_left):>4}개) MSE: {y_left.var():.5f}")
print(f"오른쪽 ({len(y_right):>3}개) MSE: {y_right.var():.5f}")
print(f"가중 평균 MSE: {mse_after:.5f}")
print(f"정보이득:       {gain:.5f}  (전체 MSE의 {gain/mse_before*100:.1f}% 감소)")
```

실행하면 `Overall Qual ≤ 7` 한 번의 분할이 전체 MSE의 약 50% 이상을 한 번에 깎는다. sklearn의 트리는 모든 변수의 모든 후보 임계값에 대해 같은 계산을 반복하고, 정보이득이 최대인 한 쌍을 선택한다. 분기 한 번의 과정을 그림으로 따라가면 다음과 같다.

![03 split process](figs/03_split_process.png)

<sub>그림 0-3. 결정 트리의 한 번의 분할 과정. (왼쪽) 분할 전 노드는 빨강과 파랑이 섞여 있어 불순도가 크다. (가운데) 변수의 모든 후보 임계값에 대해 분할을 가상으로 수행하고 정보이득을 계산한다. 곡선의 정점이 최적 임계값이다. (오른쪽) 최적 임계값으로 자르면 왼쪽은 거의 빨강, 오른쪽은 거의 파랑으로 분리되어 불순도가 크게 감소한다.</sub>

다른 임계값을 시도하면 정보이득이 어떻게 달라지는지도 확인할 수 있다.

```python
# Overall Qual의 여러 임계값 비교
print(f"{'임계값':>6}  {'좌 n':>5}  {'우 n':>5}  {'정보이득':>10}")
print("-" * 35)
for t in [5, 6, 7, 8, 9]:
    left = y_all[X["Overall Qual"] <= t]
    right = y_all[X["Overall Qual"] > t]
    if len(left) == 0 or len(right) == 0:
        continue
    mse_after = (len(left)/n_total)*left.var() + (len(right)/n_total)*right.var()
    gain = mse_before - mse_after
    print(f"{t:>6}  {len(left):>5}  {len(right):>5}  {gain:>10.5f}")
```

임계값 7이 가장 큰 정보이득을 주는 것을 데이터로 확인할 수 있다. 너무 낮으면 왼쪽 그룹이 덜 동질적이 되고, 너무 높으면 오른쪽 그룹이 너무 작아져 가중치가 떨어진다. 균형 잡힌 분할이 보통 가장 정보이득이 크다.

#### 실습 — 트리 시각화로 분기 구조 보기

학습한 트리를 그림으로 그리면 어떤 분할이 어떤 순서로 일어났는지 한눈에 보인다. sklearn의 `plot_tree`는 한 줄로 트리를 그려 준다.

```python
from sklearn.tree import plot_tree

tree_viz = DecisionTreeRegressor(max_depth=3, random_state=42)
tree_viz.fit(X, y)

fig, ax = plt.subplots(figsize=(16, 8))
plot_tree(tree_viz, feature_names=X.columns.tolist(),
          filled=True, rounded=True, fontsize=9, ax=ax)
ax.set_title("Ames에서 학습된 결정 트리 (깊이 3)", fontsize=13)
plt.tight_layout(); plt.show()
```

뿌리 노드 근처에 어떤 변수가 등장하는지를 보면 그 변수의 중요성을 짐작할 수 있다. Ames에서는 보통 `Overall Qual`이 뿌리에 오고, 그 아래에 `Gr Liv Area`나 `Total SF`가 따라온다. 이 순서가 6장의 변수 중요도와 거의 일치하게 된다.

### 0.5 트리 성장과 멈춤 — 가지치기

분기를 반복하면 트리가 자란다. 이론적으로는 각 잎 노드에 샘플이 1개만 남을 때까지 계속 분할할 수 있다. 그 상태의 트리를 완전히 자란 트리(fully grown tree)라 부른다. 완전히 자란 트리는 학습 데이터를 정확하게 외우지만 새로운 데이터에 대해서는 성능이 끔찍하게 나쁘다. 이를 막는 두 가지 전략이 있다.

**사전 가지치기**(pre-pruning)는 트리가 자라는 도중에 멈춤 조건을 두는 방법이다.

- `max_depth`: 트리의 최대 깊이
- `min_samples_split`: 노드를 분할하려면 최소 몇 개의 샘플이 있어야 하는가
- `min_samples_leaf`: 한 잎 노드에 최소 몇 개의 샘플이 있어야 하는가
- `min_impurity_decrease`: 정보이득이 이 값보다 작으면 분할하지 않는다

**사후 가지치기**(post-pruning)는 일단 트리를 완전히 자란 상태로 키운 뒤, 통계적 검정이나 검증 데이터의 성능을 기준으로 덜 중요한 가지를 잘라내는 방법이다. sklearn에서는 `ccp_alpha` 매개변수로 비용 복잡도 가지치기를 지원한다.

#### 실습 — 과적합의 전환점 찾기

깊이를 늘리면 학습 R²는 계속 오르지만, 검증 R²는 어느 시점부터 떨어진다. 그 전환점이 과적합이 시작되는 지점이다.

```python
from sklearn.model_selection import cross_val_score

depths = [1, 2, 3, 5, 8, 12, 20, None]
train_r2, cv_r2 = [], []

for d in depths:
    t = DecisionTreeRegressor(max_depth=d, random_state=42)
    t.fit(X, y)
    train_r2.append(t.score(X, y))
    cv_r2.append(cross_val_score(t, X, y, cv=5, scoring="r2").mean())

# 시각화
fig, ax = plt.subplots(figsize=(9, 5))
x_pos = list(range(len(depths)))
ax.plot(x_pos, train_r2, "o-", label="학습 R²", color="#1F3A5F", linewidth=2)
ax.plot(x_pos, cv_r2, "s-", label="검증 R² (5-fold CV)", color="#C0392B", linewidth=2)
ax.set_xticks(x_pos)
ax.set_xticklabels([str(d) if d is not None else "무제한" for d in depths])
ax.set_xlabel("max_depth"); ax.set_ylabel("R²")
ax.legend(); ax.set_title("깊이에 따른 학습 vs 검증 성능 — 과적합의 전환점")
ax.grid(alpha=0.3)
plt.tight_layout(); plt.show()
```

학습 R²는 깊이가 깊어질수록 1에 계속 가까워지지만, 검증 R²는 보통 깊이 6~10 근처에서 정점을 찍고 다시 떨어진다. 그 정점이 과적합 시작점이며, 단일 트리에서 `max_depth`를 그 근처로 두는 것이 좋다.

#### 실습 — 사후 가지치기의 효과

```python
alphas = [0.0, 0.001, 0.005, 0.01, 0.02]
print(f"{'alpha':>8}  {'잎 개수':>8}  {'CV R²':>8}")
print("-" * 30)
for a in alphas:
    t = DecisionTreeRegressor(ccp_alpha=a, random_state=42)
    r2 = cross_val_score(t, X, y, cv=5, scoring="r2").mean()
    t.fit(X, y)
    print(f"{a:>8.4f}  {t.get_n_leaves():>8d}  {r2:>8.4f}")
```

`ccp_alpha`가 0이면 잎이 수천 개에 달하지만, 0.01 근처로 키우면 잎이 수백 개로 줄면서 CV R²가 거의 같거나 더 좋아진다. 간단한 트리가 더 잘 일반화하는 전형적인 패턴이다.

`max_depth`가 깊이의 상한이라는 거친 도구라면 `ccp_alpha`는 각 가지의 가치를 검토하는 정교한 도구다. 둘은 함께 쓸 수도 있다.

#### 단일 트리의 한계 — 다음 장으로의 다리

가지치기를 잘 해도 단일 트리에는 근본적인 한계가 남는다. 학습 데이터가 조금만 달라져도 트리의 첫 분할 변수가 통째로 바뀐다. 분기점이 임계값 한 줄 차이로 결정되므로, 임계값 근처의 샘플 한두 개의 흔들림이 트리 전체 구조를 바꾸어 버린다. 이 데이터에 대한 민감성이 바로 1장에서 다룰 **분산이 큰 추정량**의 문제다.

---

## 1장 한 그루 트리의 흔들림과 평균의 안정

결정 트리 한 그루는 학습 데이터에 매우 민감하다. 같은 모집단에서 뽑은 두 개의 다른 데이터셋으로 트리를 키우면, 두 트리의 분할 기준이 통째로 달라질 수 있다. 예를 들어 Ames 데이터의 절반으로 트리를 키우면 첫 분할이 `Overall Qual ≤ 7`일 수 있고, 다른 절반으로 키우면 `Gr Liv Area ≤ 1700`일 수 있다. 같은 모집단을 묘사하는 두 트리가 근본적으로 다른 구조를 갖는 셈이다.

이를 통계학에서는 **분산이 큰**(high variance) 추정량이라고 부른다. 데이터가 조금만 흔들려도 결과가 크게 흔들리는 추정량이다. 분산이 큰 추정량은 예측의 일관성이 떨어진다. 같은 집의 가격을 예측할 때 어떤 트리는 18만 달러를, 다른 트리는 24만 달러를 답하는 식이다.

이 문제를 해결하는 가장 단순한 아이디어가 있다. **여러 트리의 예측을 평균낸다**. 수학적으로 다음이 성립한다.

서로 독립인 추정량 $\hat{f}_1, \hat{f}_2, \ldots, \hat{f}_B$의 분산이 모두 $\sigma^2$으로 같다면, 그들의 평균의 분산은 다음과 같다.

$$\bar{f} = \frac{1}{B}\sum_{b=1}^{B} \hat{f}_b, \qquad \text{Var}(\bar{f}) = \frac{\sigma^2}{B}$$

이를 풀어쓰면, $B$개의 독립 추정량을 평균내면 분산이 정확히 $B$분의 1로 줄어든다. 100그루의 트리를 평균내면 분산이 100배 작아지고, 예측이 100배 안정된다. 평균의 이런 성질을 **분산 감소**(variance reduction)라고 부른다.

#### 실습 — 데이터의 부분집합으로 흔들림 측정하기

같은 데이터에서 두 부분집합을 뽑아 트리를 따로 키우면, 두 트리의 첫 분할 변수가 통째로 달라지는 경우가 생긴다.

```python
from sklearn.tree import DecisionTreeRegressor
from collections import Counter

rng = np.random.default_rng(42)
n = len(X)

first_splits = []
for seed in range(20):
    idx = rng.choice(n, size=int(n * 0.7), replace=False)
    X_sub, y_sub = X.iloc[idx], y.iloc[idx]
    t = DecisionTreeRegressor(max_depth=3, random_state=42)
    t.fit(X_sub, y_sub)
    root_feature_idx = t.tree_.feature[0]
    first_splits.append(X.columns[root_feature_idx])

print("20번 학습 시 뿌리 노드 분할 변수의 분포:")
for var, cnt in Counter(first_splits).most_common():
    print(f"  {var:<20s}  {cnt}회")
```

20번의 학습 모두에서 같은 변수가 뿌리에 오지는 않는다. 보통 `Overall Qual`이 가장 자주 등장하지만, `Total SF`나 `Gr Liv Area`가 뿌리를 차지하는 경우도 섞여 있다. 데이터의 70%만 봐도 트리의 기본 골격이 흔들린다. 이 흔들림이 단일 트리의 분산이며, 100그루를 평균내는 배깅이 줄이려는 대상이다.

같은 입력에 대해 20번 학습한 트리들이 각자 얼마나 다른 예측을 내는지도 직접 측정할 수 있다.

```python
test_row = X.iloc[[100]]      # 100번 행 한 줄
true_y = y.iloc[100]

predictions = []
for seed in range(20):
    idx = rng.choice(n, size=int(n * 0.7), replace=False)
    t = DecisionTreeRegressor(max_depth=8, random_state=42)
    t.fit(X.iloc[idx], y.iloc[idx])
    predictions.append(t.predict(test_row)[0])

predictions = np.array(predictions)
print(f"실제값:       {true_y:.4f}")
print(f"예측 평균:    {predictions.mean():.4f}")
print(f"예측 표준편차: {predictions.std():.4f}  ← 단일 트리의 분산")
print(f"예측 범위:    {predictions.min():.4f} ~ {predictions.max():.4f}")
```

20번의 예측이 표준편차 0.05~0.10 정도로 흔들린다. log 스케일이므로 원래 가격으로 환산하면 약 10% 흔들림이다. 같은 한 채의 집에 대해 트리마다 다른 예측을 내는 셈이다.

#### 두 가지 현실의 어려움

여기에 두 가지 현실의 어려움이 있다.

첫째, 서로 독립인 트리를 어떻게 얻는가. 데이터는 하나뿐이다. 같은 데이터로 두 번 학습하면 똑같은 트리가 나오므로, 평균을 내도 분산이 절반이 되지 않고 그대로다.

둘째, 만들어 낸 트리들이 진짜 독립인가. 두 트리가 같은 원본 데이터에서 만들어진 부분 표본들로 학습된다면, 둘은 완전한 독립이 아니라 어느 정도 상관되어 있을 것이다. 이 상관이 분산 감소 효과를 어떻게 깎는가는 곧 정량화하게 된다.

이 두 어려움을 해결하는 도구가 각각 **부트스트랩 표본**(bootstrap sampling)과 **무작위 변수 선택**(random feature selection)이다.

---

## 2장 복원 추출과 부트스트랩 표본

원본 데이터에서 **복원 추출**(sampling with replacement)로 같은 크기의 새 데이터셋을 만든다. 이를 부트스트랩 표본이라 부른다. Ames 데이터는 2,930행이므로, 부트스트랩 표본 한 개도 2,930행이다. 단 복원 추출이므로 어떤 행은 중복으로 뽑히고, 어떤 행은 한 번도 뽑히지 않는다.

특정 행 하나가 한 번도 뽑히지 않을 확률을 계산해 보자. 한 번 뽑을 때 그 행이 안 뽑힐 확률은 $1 - 1/n$이다. 이를 $n$번 반복하므로,

$$P(\text{어떤 행이 한 번도 안 뽑힐 확률}) = \left(1 - \frac{1}{n}\right)^n$$

이 식의 극한값이 핵심이다. $n$이 커질 때 그 값은 다음에 수렴한다.

$$\lim_{n\to\infty} \left(1 - \frac{1}{n}\right)^n = e^{-1} \approx 0.3679$$

말로 풀면, 표본 크기가 충분히 크면 어떤 특정 행이 한 번도 뽑히지 않을 확률은 약 36.79%로 고정된다. 거꾸로 약 63.21%의 행은 적어도 한 번 뽑힌다. Ames의 경우 2,930행 중 약 1,850행이 부트스트랩 표본에 들어가고, 약 1,080행은 들어가지 않는다.

이 들어가지 않은 약 36.8%를 **OOB**(Out-of-Bag) 표본이라 부른다. OOB 표본은 그 트리의 학습에 사용되지 않은 행들이므로, 별도의 검증 데이터처럼 쓸 수 있다.

#### 실습 — 부트스트랩 표본 직접 만들기

`np.random.choice`로 원본 크기와 같은 표본을 복원 추출하여 만든다. 고유 인덱스와 OOB 인덱스를 분리할 수 있다.

```python
rng = np.random.default_rng(42)
n = len(X)

boot_idx = rng.choice(n, size=n, replace=True)
unique_idx = np.unique(boot_idx)
oob_idx = np.setdiff1d(np.arange(n), unique_idx)

print(f"원본 크기:        {n}")
print(f"부트스트랩 크기:  {len(boot_idx)}")
print(f"고유 인덱스 수:   {len(unique_idx)}  ({len(unique_idx)/n*100:.1f}%)")
print(f"OOB 크기:         {len(oob_idx)}  ({len(oob_idx)/n*100:.1f}%)")
```

고유 인덱스가 약 63.2%, OOB가 약 36.8% 나온다. 이는 우연이 아니라 위에서 유도한 $e^{-1} \approx 0.368$의 극한이 실현된 결과다.

부트스트랩을 100번 반복하면 OOB 비율이 매번 거의 정확히 36.8%가 나옴을 확인할 수 있다.

```python
oob_ratios = []
for _ in range(100):
    boot_idx = rng.choice(n, size=n, replace=True)
    unique = np.unique(boot_idx)
    oob_ratios.append((n - len(unique)) / n)

oob_ratios = np.array(oob_ratios)
print(f"OOB 비율 평균:     {oob_ratios.mean():.4f}")
print(f"OOB 비율 표준편차: {oob_ratios.std():.4f}")
print(f"이론적 극한:       {np.exp(-1):.4f}")
```

평균이 $e^{-1} \approx 0.3679$에 매우 가깝게 수렴한다. 100번의 부트스트랩이라는 작은 실험에서도 대수의 법칙이 잘 보인다.

#### 실습 — OOB 점수 직접 측정하기

부트스트랩 표본으로 트리를 학습시키고, OOB 표본으로 평가하면 별도 검증 데이터 없이도 그 트리의 일반화 성능을 추정할 수 있다.

```python
from sklearn.metrics import r2_score

rng = np.random.default_rng(42)
oob_scores = []
for b in range(5):
    boot_idx = rng.choice(n, size=n, replace=True)
    oob_mask = np.setdiff1d(np.arange(n), np.unique(boot_idx))
    
    t = DecisionTreeRegressor(max_depth=10, random_state=42)
    t.fit(X.iloc[boot_idx], y.iloc[boot_idx])
    
    oob_pred = t.predict(X.iloc[oob_mask])
    score = r2_score(y.iloc[oob_mask], oob_pred)
    oob_scores.append(score)
    print(f"트리 {b+1}: OOB 크기 {len(oob_mask)}, OOB R² = {score:.4f}")

print(f"\nOOB 점수 평균: {np.mean(oob_scores):.4f}")
```

다섯 그루 트리의 OOB 점수가 약 0.6~0.7 사이로 흔들리는 것이 단일 트리의 분산이다. 5장에서 보겠지만, 수백 그루의 평균 OOB 예측은 훨씬 안정적이다.

이렇게 만든 $B$개의 부트스트랩 표본 각각에 트리 한 그루씩 학습시키고, 예측을 평균내는 방법이 **배깅**(Bagging, Bootstrap AGGregatING)이다. 1장 마지막의 평균 분산 정리를 그대로 적용하려는 시도다. 배깅의 전체 흐름을 그림으로 보면 다음과 같다.

![04 bagging diagram](figs/04_bagging_diagram.png)

<sub>그림 2-1. 배깅의 세 단계. (1) 원본 데이터에서 복원추출로 여러 부트스트랩 표본을 만든다. 각 표본은 원본의 약 63.2% 고유 행을 포함하고 약 36.8%는 OOB로 빠진다. (2) 각 표본에서 독립적으로 트리 한 그루씩 학습한다. 트리들은 서로의 존재를 모른다. (3) 새 입력에 대해 모든 트리의 예측을 모아 회귀에서는 평균을, 분류에서는 다수결을 취한다.</sub>

배깅의 결정적 성질이 그림에 담겨 있다 — 각 트리는 서로의 존재를 모른다. 이것이 부스팅과의 가장 큰 구조적 차이다. 부스팅은 각 트리가 앞선 트리들이 한 일을 알고 그것을 보정한다. 배깅은 완전히 독립적이라 트리 학습을 병렬로 처리할 수 있다는 실용적 장점도 따라온다.

---

## 3장 분산 감소의 수학 — 독립이 깨지면 어떻게 되는가

1장의 분산 감소 정리는 추정량들이 서로 독립이라는 가정 아래 성립한다. 그러나 배깅으로 만든 트리들은 완전한 독립이 아니다. 같은 원본 데이터에서 만들어진 부트스트랩 표본들은 약 63.2%의 행을 공유하므로, 거기서 만들어진 트리들도 어느 정도 닮는다. 이 닮음의 정도를 추정량 사이의 **상관계수**(correlation) $\rho$로 표현하자.

서로 상관계수 $\rho$로 연결된 추정량들의 평균 분산은 다음과 같다.

$$\text{Var}(\bar{f}) = \rho \sigma^2 + \frac{1 - \rho}{B}\sigma^2$$

이 식을 두 부분으로 나누어 본다. 첫 번째 항 $\rho \sigma^2$는 트리 수 $B$와 무관하다. 즉 트리를 아무리 많이 만들어도 이 항만큼의 분산은 줄지 않는다. 두 번째 항 $(1-\rho)\sigma^2/B$는 $B$가 커지면 0에 수렴한다.

$B \to \infty$의 극한을 보면,

$$\lim_{B\to\infty} \text{Var}(\bar{f}) = \rho \sigma^2$$

배깅이 도달할 수 있는 분산의 하한은 $\rho \sigma^2$이다. 트리들이 완전히 독립이면 $\rho = 0$이고 분산이 0에 수렴하지만, 실제로는 $\rho > 0$이므로 분산이 그 수준에서 멈춘다.

이 식이 시각적으로 어떻게 작동하는지 보자.

![05 variance reduction](figs/05_variance_reduction.png)

<sub>그림 3-1. 트리 개수 B에 따른 앙상블 분산. 트리 간 상관 ρ가 클수록(빨강) 분산 하한이 높아져 더 일찍 수확체감에 도달한다. ρ가 작을수록(녹색) 더 오래 분산이 줄어든다. 가운데(남색)가 랜덤 포레스트 근처의 전형적 패턴이다.</sub>

#### 실습 — 트리 수에 따른 R² 곡선 측정

여러 트리를 학습시키고 그들의 예측을 평균하면 단일 트리 한 그루보다 얼마나 안정적인지 데이터로 확인한다.

```python
from sklearn.metrics import r2_score

rng = np.random.default_rng(42)

val_idx = rng.choice(n, size=int(n * 0.2), replace=False)
train_idx = np.setdiff1d(np.arange(n), val_idx)
X_train, y_train = X.iloc[train_idx], y.iloc[train_idx]
X_val, y_val = X.iloc[val_idx], y.iloc[val_idx]

B_max = 50
predictions_matrix = np.zeros((B_max, len(X_val)))

for b in range(B_max):
    boot_idx = rng.choice(len(X_train), size=len(X_train), replace=True)
    t = DecisionTreeRegressor(max_depth=10, random_state=b)
    t.fit(X_train.iloc[boot_idx], y_train.iloc[boot_idx])
    predictions_matrix[b] = t.predict(X_val)

r2_curve = [r2_score(y_val, predictions_matrix[:B].mean(axis=0)) for B in range(1, B_max+1)]

print(f"트리 1그루:   R² = {r2_curve[0]:.4f}")
print(f"트리 10그루:  R² = {r2_curve[9]:.4f}")
print(f"트리 30그루:  R² = {r2_curve[29]:.4f}")
print(f"트리 50그루:  R² = {r2_curve[49]:.4f}")

# 곡선 시각화
fig, ax = plt.subplots(figsize=(9, 5))
ax.plot(range(1, B_max+1), r2_curve, "o-", color="#1F3A5F", markersize=4)
ax.set_xlabel("트리 개수 B"); ax.set_ylabel("앙상블 R²")
ax.set_title("배깅의 분산 감소 — 50그루 이후 수확체감")
ax.grid(alpha=0.3); plt.tight_layout(); plt.show()
```

트리 1그루에서 50그루로 평균내는 것만으로 R²가 0.65에서 0.85 안팎으로 크게 오른다. 정확한 식 $\text{Var}(\bar{f}) = \rho \sigma^2 + (1-\rho)\sigma^2/B$가 데이터로 검증되는 순간이다. 다만 50을 100으로 늘려도 거의 오르지 않는다 — 수확체감이 시작된다.

#### 실습 — 상관 ρ의 효과 측정

`max_features`를 바꿔 가며 트리 간 상관 ρ가 어떻게 변하는지 측정한다. 같은 입력에 대해 두 트리의 예측이 얼마나 닮았는지가 ρ다.

```python
rng = np.random.default_rng(42)
n_features = X.shape[1]

val_idx = rng.choice(len(X), size=int(len(X) * 0.2), replace=False)
train_idx = np.setdiff1d(np.arange(len(X)), val_idx)
X_train, y_train = X.iloc[train_idx], y.iloc[train_idx]
X_val = X.iloc[val_idx]

for mf_name, mf_val in [("전체 변수", n_features), ("p/3 (랜덤 포레스트)", n_features // 3)]:
    preds = []
    for b in range(20):
        boot_idx = rng.choice(len(X_train), size=len(X_train), replace=True)
        t = DecisionTreeRegressor(max_features=mf_val, max_depth=10, random_state=b)
        t.fit(X_train.iloc[boot_idx], y_train.iloc[boot_idx])
        preds.append(t.predict(X_val))
    preds = np.array(preds)
    
    corrs = [np.corrcoef(preds[i], preds[j])[0, 1]
             for i in range(20) for j in range(i+1, 20)]
    print(f"{mf_name:<25s} (max_features={mf_val:>3}): 평균 트리 간 ρ = {np.mean(corrs):.4f}")
```

전체 변수를 본 트리들은 모두 강한 변수 `Overall Qual`을 거의 첫 분할로 선택하므로 트리들이 닮고 ρ가 약 0.85~0.95로 매우 크다. p/3로 줄이면 같은 변수가 후보에서 빠지는 트리가 생겨 ρ가 약 0.6~0.7로 떨어진다. 이것이 4장에서 다룰 변수 무작위성의 정확한 효과다.

따라서 배깅의 성능을 더 올리려면 두 가지 길이 있다.

첫째, 트리 수 $B$를 늘리는 것이다. 그러나 $B$가 커질수록 두 번째 항이 작아지는 효과는 수확체감이다. $B$를 100에서 200으로 늘려도 분산은 거의 줄지 않는다. 이미 $\rho \sigma^2$에 가까워졌기 때문이다.

둘째, $\rho$ 자체를 줄이는 것이다. 트리들 사이의 상관을 깨면 분산의 하한이 낮아진다. 같은 강한 변수에만 매달리는 트리들을 서로 다른 변수에 매달리도록 만드는 장치가 필요해진다.

배깅의 분산은 트리 수가 아니라 **트리 간 상관**에 의해 결정된다. 이 한 줄이 배깅과 랜덤 포레스트의 모든 설계 결정을 지배한다.

---

## 4장 무작위 변수 선택과 트리 간 상관 깨기

부트스트랩 표본만으로는 트리 간 상관을 충분히 깨지 못한다. 데이터의 가장 강한 신호는 어느 부트스트랩 표본에도 살아남기 때문이다. Ames 데이터에서 `Overall Qual`은 `SalePrice`와의 상관계수가 0.80인 강력한 변수다. 어떤 부트스트랩 표본을 만들어도 이 변수가 첫 분할에 선택될 가능성이 매우 높다. 결과적으로 100그루의 트리 모두 비슷한 첫 분할을 갖게 되고, 트리 간 상관 $\rho$가 크다.

랜덤 포레스트는 이 문제를 단순한 아이디어로 해결한다. **매 분할마다 변수의 일부만 무작위로 골라 쓴다**. 전체 80개 변수 중에서 매번 8~27개만 후보로 두고, 그 안에서 최적 분할을 찾는다. 이렇게 하면 강한 변수 `Overall Qual`이 후보에 들어가지 못한 트리가 만들어지고, 그 트리는 다른 변수로 분할한다. 트리들의 첫 분할이 다양해지고, 결과적으로 트리 간 상관이 깨진다.

매 분할마다 고려할 변수 수를 보통 **mtry** 또는 **max_features**로 표기한다. 전체 변수 수를 $p$라 할 때, 경험칙은 다음과 같다.

| 문제 유형 | 권장 mtry | $p=80$일 때 | 출처 |
|---|---|---|---|
| 회귀 | $\lfloor p/3 \rfloor$ | 약 27개 | Breiman (2001) |
| 분류 | $\lfloor \sqrt{p} \rfloor$ | 약 9개 | Breiman (2001) |

이 경험칙은 1990년대 후반 Breiman의 실험에서 나왔다. 회귀는 분류보다 더 많은 변수를 보게 두는데, 회귀의 분할이 분류보다 더 미세한 차이에 민감하기 때문이다.

직관적으로 정리하면, 부트스트랩은 데이터의 무작위성을 주입하고, mtry는 변수의 무작위성을 주입한다. 두 무작위성이 결합하여 트리 간 상관 $\rho$를 줄인다.

mtry를 너무 작게 두면 각 트리가 약한 변수만 보고 분할해야 하므로 개별 트리의 성능이 떨어진다. 너무 크게 두면 트리들이 비슷해져 상관 $\rho$가 커진다. 두 가지 사이의 균형이 mtry 튜닝의 본질이다.

![06 mtry tradeoff](figs/06_mtry_tradeoff.png)

<sub>그림 4-1. mtry의 균형점. 녹색(개별 트리의 강도)은 mtry가 커질수록 증가하고, 빨강(트리 간 상관 ρ)도 mtry가 커질수록 증가한다. 두 요인이 곱해진 앙상블 성능(남색)은 둘 사이의 균형점에서 최대가 된다 — 회귀에서 보통 p/3 근처다.</sub>

이 두 힘의 줄다리기를 표로 정리하면 다음과 같다.

| mtry가 작을 때 | mtry가 클 때 |
|---|---|
| 후보 변수가 적어 강한 변수가 못 들어가는 경우 발생 | 후보 변수가 많아 강한 변수가 거의 항상 들어감 |
| 개별 트리가 약함 → $\sigma^2$ 커짐 | 개별 트리가 강함 → $\sigma^2$ 작아짐 |
| 트리마다 다른 변수에 의존 → $\rho$ 작음 | 모든 트리가 강한 변수에 매달림 → $\rho$ 큼 |
| 분산 하한 $\rho\sigma^2$가 낮음 | 분산 하한 $\rho\sigma^2$가 높음 |

회귀에서 보통 mtry = $p/3$ 근처가 두 힘이 균형을 이루는 지점이다. 데이터에 따라 미세 조정이 필요할 수 있지만, 기본값에서 크게 벗어나는 경우는 드물다.

#### 실습 — max_features 튜닝 곡선

`max_features`를 바꿔 가며 CV R² 곡선을 그려 균형점을 직접 찾아본다.

```python
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import cross_val_score

n_features = X.shape[1]
mtry_candidates = [3, 5, n_features // 4, n_features // 3, n_features // 2, n_features]

results = []
for mf in mtry_candidates:
    rf = RandomForestRegressor(n_estimators=100, max_features=mf,
                                random_state=42, n_jobs=-1)
    r2 = cross_val_score(rf, X, y, cv=5, scoring="r2", n_jobs=-1).mean()
    results.append((mf, r2))
    print(f"max_features={mf:>3}:  CV R² = {r2:.4f}")

# 시각화
fig, ax = plt.subplots(figsize=(9, 5))
mfs, r2s = zip(*results)
ax.plot(mfs, r2s, "o-", color="#1F3A5F", linewidth=2, markersize=8)
ax.axvline(n_features // 3, color="#C0392B", linestyle="--", alpha=0.5,
           label=f"권장 p/3 = {n_features // 3}")
ax.set_xlabel("max_features"); ax.set_ylabel("CV R²")
ax.legend(); ax.set_title(f"mtry 균형점 — Ames의 경우 p/3 근처가 최적 (p={n_features})")
plt.tight_layout(); plt.show()
```

곡선이 $p/3$ 근처에서 최댓값을 갖는 것이 Breiman의 경험칙과 일치한다. 양쪽 극단에서는 R²가 떨어진다 — 왼쪽은 개별 트리가 약해서, 오른쪽은 트리 간 상관이 커져서다. 분산 공식 $\text{Var}(\bar{f}) = \rho\sigma^2 + (1-\rho)\sigma^2/B$의 두 항이 시각화된 셈이다.

#### 실습 — 깊이와 mtry의 결합 효과

랜덤 포레스트에서는 단일 트리와 정반대로 **각 트리를 깊이 제한 없이 키우는 것**이 보통 최적이다. 개별 트리가 깊으면 편향이 작고, 그 분산은 평균이 줄여 주기 때문이다.

```python
for depth in [None, 10, 20]:
    for mf in [5, n_features // 3, n_features]:
        rf = RandomForestRegressor(n_estimators=100, max_depth=depth,
                                    max_features=mf, random_state=42, n_jobs=-1)
        r2 = cross_val_score(rf, X, y, cv=5, scoring="r2", n_jobs=-1).mean()
        print(f"depth={str(depth):>4}, mf={mf:>3}:  CV R² = {r2:.4f}")
```

격자 탐색 결과 보통 `max_depth=None`이 가장 좋은 점수를 낸다. 단일 트리에서는 깊이 제한이 과적합을 막는 데 필수였지만, 랜덤 포레스트에서는 평균이 분산을 줄여 주므로 **개별 트리의 편향만 작으면 된다**.

---

## 5장 OOB 점수 — 외부 검증 없는 일반화 추정

2장에서 정의한 OOB 표본은 해당 트리의 학습에 사용되지 않았다. 이 사실이 매우 유용한 결과를 낳는다.

원본의 행 $i$를 생각해 보자. $B$그루의 숲 중에서 이 행을 OOB로 가진 트리들이 평균 약 $0.368B$그루 있다. 이 OOB 트리들로만 행 $i$의 예측을 모아 평균을 내자. 그 평균을 **OOB 예측**이라 부른다.

$$\hat{f}_{\text{OOB}}(x_i) = \frac{1}{|\mathcal{B}_i|} \sum_{b \in \mathcal{B}_i} \hat{f}_b(x_i)$$

여기서 $\mathcal{B}_i$는 행 $i$를 OOB로 가진 트리들의 집합이다.

이 OOB 예측은 행 $i$를 전혀 본 적 없는 트리들의 예측이므로, 별도 검증 데이터의 예측과 통계적으로 같은 성질을 갖는다. 따라서 전체 행에 대한 OOB 예측을 모아 $R^2$나 RMSE를 계산하면, 그것이 **OOB 점수**가 된다.

OOB 점수의 결정적 장점은, 교차검증 없이 일반화 성능을 추정할 수 있다는 것이다. 일반적인 5-fold CV는 모델을 5번 학습시켜야 하지만, OOB 점수는 한 번의 학습으로 같은 효과를 낸다. 100그루의 숲을 한 번 키우는 비용으로 검증까지 끝난다.

이론적 결과로, 트리 수 $B$가 충분히 크면 OOB 점수는 leave-one-out cross-validation 점수와 점근적으로 일치한다. 즉 가장 비싼 검증 방법과 같은 정확도를 거의 무료로 얻는 셈이다.

#### 실습 — OOB vs 5-fold CV 시간 비교

sklearn에서는 `oob_score=True` 한 줄 옵션으로 OOB 점수가 자동 계산된다.

```python
import time

# OOB 점수 켜고 학습
t0 = time.time()
rf = RandomForestRegressor(n_estimators=100, oob_score=True,
                            random_state=42, n_jobs=-1)
rf.fit(X, y)
oob_time = time.time() - t0

# 비교용: 5-fold CV
t0 = time.time()
cv_r2 = cross_val_score(rf, X, y, cv=5, scoring="r2", n_jobs=-1).mean()
cv_time = time.time() - t0

print(f"OOB R²:        {rf.oob_score_:.4f}   (시간 {oob_time:.1f}s)")
print(f"5-fold CV R²:  {cv_r2:.4f}            (시간 {cv_time:.1f}s)")
print(f"속도 차이:     CV가 OOB의 약 {cv_time/oob_time:.1f}배 느림")
```

OOB와 CV의 점수가 매우 가깝다(보통 ±0.005 이내). 그러나 OOB는 한 번의 학습으로 점수를 얻는 반면 CV는 5번 학습해야 한다. 큰 데이터에서 이 시간 차이는 결정적이다.

#### 실습 — 트리 수에 따른 OOB 점수 수렴

`n_estimators`를 늘리면 OOB 점수가 어떻게 수렴하는지 직접 그려 본다. `warm_start=True`를 쓰면 트리만 추가하여 빠르게 누적 학습할 수 있다.

```python
rf = RandomForestRegressor(n_estimators=10, oob_score=True,
                            warm_start=True, random_state=42, n_jobs=-1)
oob_curve = []
n_trees_list = list(range(10, 201, 10))

for n_tr in n_trees_list:
    rf.set_params(n_estimators=n_tr)
    rf.fit(X, y)
    oob_curve.append(rf.oob_score_)

fig, ax = plt.subplots(figsize=(9, 5))
ax.plot(n_trees_list, oob_curve, "o-", color="#1F3A5F", markersize=4)
ax.set_xlabel("트리 개수"); ax.set_ylabel("OOB R²")
ax.set_title("OOB 점수의 수렴 — 50~100그루 이후 평탄")
ax.grid(alpha=0.3); plt.tight_layout(); plt.show()

print(f"10그루:  {oob_curve[0]:.4f}")
print(f"100그루: {oob_curve[9]:.4f}")
print(f"200그루: {oob_curve[-1]:.4f}")
```

OOB 점수에도 두 가지 주의점이 있다. 첫째, OOB는 각 행이 평균 약 37%의 트리에서만 검증되므로, 트리 수가 적으면 일부 행에 대해 OOB 예측이 불안정하다. 둘째, OOB는 한 번의 학습 내부에서 계산되므로, 진정한 바깥 데이터에 대한 일반화는 여전히 별도 hold-out 데이터로 확인하는 것이 안전하다.

---

## 6장 변수 중요도 — 두 가지 계산 방법

여러 트리로 만든 숲의 또 다른 부산물이 **변수 중요도**(feature importance)다. 어떤 변수가 예측에 얼마나 기여했는가를 단일 숫자로 요약한다.

표준 방법이 두 가지 있다.

**평균 불순도 감소**(Mean Decrease in Impurity, MDI). 트리의 각 분할마다, 그 분할로 얼마만큼의 불순도 감소가 일어났는지 계산할 수 있다. 회귀에서 불순도는 MSE다. 분할 전 노드의 MSE에서 두 자식 노드의 가중평균 MSE를 뺀 값이 분할이 줄인 MSE다. 각 변수에 대해 그 변수가 사용된 모든 분할의 MSE 감소를 합산한 뒤, 전체 트리에서 평균을 낸다. 이것이 MDI다.

MDI는 학습 과정 중에 자연스럽게 계산되므로 계산 비용이 0에 가깝다. sklearn에서는 `model.feature_importances_`로 즉시 얻을 수 있다. 단점은 연속형 변수와 카디널리티 높은 범주형 변수에 편향이 있다는 점이다. 분할 후보가 많은 변수일수록 우연히 높은 MDI를 얻을 가능성이 크다.

**순열 중요도**(Permutation Importance). 검증 데이터에서 어떤 변수의 값을 행 사이에서 무작위로 섞은 뒤 모델 성능이 얼마나 떨어지는지 측정한다. 변수를 망쳤을 때 성능이 크게 떨어졌다면 그 변수는 중요하다. 거의 안 떨어졌다면 그 변수는 중요하지 않다.

순열 중요도는 어떤 모델에도 적용 가능한 일반적 방법이며, MDI의 편향이 없다. 대신 검증 데이터에서 변수마다 한 번씩 다시 평가해야 하므로 계산 비용이 크다.

두 방법은 서로 다른 답을 줄 수 있다. **사촌처럼 닮은 변수**가 있을 때가 대표적이다. `Garage Cars`와 `Garage Area`는 상관계수 0.89로 거의 같은 정보를 담는다.

#### 실습 — MDI 측정

학습된 랜덤 포레스트에서 `feature_importances_` 속성으로 MDI를 즉시 얻는다.

```python
rf = RandomForestRegressor(n_estimators=200, random_state=42, n_jobs=-1)
rf.fit(X, y)

mdi = pd.Series(rf.feature_importances_, index=X.columns).sort_values(ascending=False)

print("MDI 상위 10개 변수:")
for var, imp in mdi.head(10).items():
    print(f"  {var:<25s}  {imp:.4f}")

# 시각화
fig, ax = plt.subplots(figsize=(9, 6))
top15 = mdi.head(15)
ax.barh(top15.index, top15.values, color="#1F3A5F")
ax.invert_yaxis()
ax.set_xlabel("MDI (평균 불순도 감소)")
ax.set_title("Ames에서 랜덤 포레스트 변수 중요도 (MDI 기준 상위 15)")
plt.tight_layout(); plt.show()
```

Ames에서 `Overall Qual`이 압도적 1위, `Total SF`와 `Gr Liv Area`가 그 뒤를 잇는다. 1부에서 손으로 만든 `Total SF`가 상위에 들어왔다는 점이 인상적이다. 특성공학이 트리에서도 유효함을 보여 준다.

#### 실습 — 순열 중요도 측정

```python
from sklearn.inspection import permutation_importance
from sklearn.model_selection import train_test_split

X_tr, X_te, y_tr, y_te = train_test_split(X, y, test_size=0.2, random_state=42)

rf_perm = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
rf_perm.fit(X_tr, y_tr)

perm = permutation_importance(rf_perm, X_te, y_te,
                                n_repeats=10, random_state=42, n_jobs=-1)
perm_imp = pd.Series(perm.importances_mean, index=X.columns).sort_values(ascending=False)

print("순열 중요도 상위 10개:")
for var, imp in perm_imp.head(10).items():
    print(f"  {var:<25s}  {imp:.4f}")
```

순열 중요도에서도 `Overall Qual`이 압도적이지만, `Total SF`의 순위가 MDI보다 낮아진다. 사촌 변수 효과다 — `Total SF = 1st Flr SF + 2nd Flr SF + Total Bsmt SF`이므로 `Total SF`를 망쳐도 원래 세 변수가 정보를 대신 제공한다.

![07 importance compare](figs/07_importance_compare.png)

<sub>그림 6-1. Ames에서의 MDI와 순열 중요도 비교. 빨강으로 표시된 세 변수(Total SF, Garage Cars, Garage Area)는 서로 사촌처럼 닮은 변수다. MDI에서는 각자 적당한 중요도를 갖지만(여러 분할에서 번갈아 선택됨), 순열 중요도에서는 두 사촌이 서로의 정보를 대신 제공하므로 각자 거의 0의 중요도를 받는다.</sub>

두 측정의 차이를 표로 정리하면 다음과 같다.

| 측정 | 관점 | 사촌 변수의 처리 | 비용 | 편향 |
|---|---|---|---|---|
| MDI | 예측에 실제로 사용되었는가 | 둘 다 적당한 값을 얻음 (분할마다 번갈아 사용) | 학습 중 무료 계산 | 카디널리티 높은 변수에 유리 |
| 순열 중요도 | 그 변수가 없어도 되는가 | 둘 다 거의 0 (서로 대체 가능) | 변수마다 검증 한 번씩 | 없음 (모델 무관) |

#### 실습 — 사촌 변수 효과 직접 확인

`Garage Cars`와 `Garage Area`를 한 쪽만 제거 vs 둘 다 제거하여 R² 차이를 본다.

```python
X_full = X
X_no_cars = X.drop(columns=["Garage Cars"])
X_no_area = X.drop(columns=["Garage Area"])
X_no_both = X.drop(columns=["Garage Cars", "Garage Area"])

for name, X_subset in [("전체", X_full),
                        ("Garage Cars 제거", X_no_cars),
                        ("Garage Area 제거", X_no_area),
                        ("둘 다 제거", X_no_both)]:
    rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
    r2 = cross_val_score(rf, X_subset, y, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"  {name:<20s}  CV R² = {r2:.4f}  ({X_subset.shape[1]} 변수)")
```

한 쪽만 제거하면 R²가 거의 변하지 않는다 — 남은 사촌이 정보를 제공하기 때문이다. 둘 다 제거하면 비로소 R²가 떨어진다. 순열 중요도가 **대체 가능성** 관점에서 사촌 변수에 낮은 점수를 주는 이유가 이 실험으로 확인된다.

둘 중 어느 답이 맞는가는 **무엇을 알고 싶은가**에 따라 다르다. **예측에서 어떤 변수가 실제로 사용되었는가**를 알고 싶으면 MDI, **그 변수가 없어도 되는가**를 알고 싶으면 순열 중요도다. 둘 다 의미 있는 관점이며, 실제 분석에서는 둘 모두를 보고 종합하는 것이 표준 관행이다.

---

## 7장 Ames 데이터에서 랜덤 포레스트의 동작

Ames 데이터에 랜덤 포레스트를 적용해 보자. 1부의 `prepare_ames` 함수로 전처리한 뒤, `RandomForestRegressor(n_estimators=100)`을 5-fold CV로 평가하면 $R^2 = 0.8806$이 나온다.

비교를 위해 단일 결정 트리는 $R^2 = 0.7543$이었다. 한 그루에서 100그루로 늘리는 것만으로 $R^2$가 0.13포인트 올라간 셈이다. 이 차이가 3장에서 설명한 분산 감소의 직접적 결과다. 단일 트리는 학습 데이터의 작은 흔들림에 크게 흔들렸지만, 100그루의 평균은 그 흔들림을 상쇄한다.

선형회귀 $R^2 = 0.8025$와도 비교하면, 단일 트리(0.7543)는 선형회귀보다도 못하다. 그러나 100그루를 합친 랜덤 포레스트(0.8806)는 선형회귀보다 0.08포인트 앞선다. 한 그루의 한계와 앙상블의 위력을 한 데이터로 확인할 수 있다.

#### 실습 — 다섯 모델의 CV R² 한 표로 비교

세 모델을 같은 5-fold CV로 평가하여 단일 트리의 한계와 랜덤 포레스트의 위력을 한 표로 확인한다.

```python
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import cross_val_score
import time

models = {
    "선형회귀":                    LinearRegression(),
    "결정 트리 (1그루, 기본)":     DecisionTreeRegressor(random_state=42),
    "결정 트리 (가지치기)":        DecisionTreeRegressor(max_depth=8, min_samples_leaf=10, random_state=42),
    "랜덤 포레스트 (100그루)":     RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1),
    "랜덤 포레스트 (300그루)":     RandomForestRegressor(n_estimators=300, random_state=42, n_jobs=-1),
}

print(f"{'모델':<30s}  {'CV R²':>10s}  {'시간':>8s}")
print("-" * 55)
for name, m in models.items():
    t0 = time.time()
    r2 = cross_val_score(m, X, y, cv=5, scoring="r2", n_jobs=-1).mean()
    dt = time.time() - t0
    print(f"{name:<30s}  {r2:>10.4f}  {dt:>6.1f}s")
```

결과 표:

| 모델 | CV R² | 비고 |
|---|---|---|
| 선형회귀 | 0.8025 | 기준선 |
| 결정 트리 1그루 | 0.7543 | 선형회귀보다 못함 |
| 결정 트리 (가지치기) | 0.7752 | 가지치기로도 선형회귀 못 따라잡음 |
| 랜덤 포레스트 100그루 | 0.8806 | 분산 감소의 위력 |
| 랜덤 포레스트 300그루 | 0.8810 | 200그루를 더 써도 거의 차이 없음 |

세 가지 결정적 관찰이 한 표에 담긴다.

첫째, 단일 결정 트리는 선형회귀보다 못하다 (0.75 vs 0.80). 한 그루의 분산이 너무 커서 일반화가 약하기 때문이다.

둘째, 가지치기로 단일 트리를 다듬어도 선형회귀를 따라잡기 어렵다. 깊이와 잎 샘플 제한이 분산을 약간 줄이지만, 근본적인 한 그루의 한계는 그대로다.

셋째, 랜덤 포레스트는 단일 트리를 0.13포인트 이상 능가한다 (0.75 → 0.88). 100그루든 300그루든 거의 같은 점수에서 평탄해진다 — 3장의 분산 하한 $\rho\sigma^2$를 데이터로 확인한다.

#### 실습 — 트리 수에 따른 시간과 성능

```python
n_estimators_list = [10, 50, 100, 200, 500]

print(f"{'트리 수':>8s}  {'CV R²':>10s}  {'시간':>8s}")
print("-" * 32)
for n_est in n_estimators_list:
    rf = RandomForestRegressor(n_estimators=n_est, random_state=42, n_jobs=-1)
    t0 = time.time()
    r2 = cross_val_score(rf, X, y, cv=5, scoring="r2", n_jobs=-1).mean()
    dt = time.time() - t0
    print(f"{n_est:>8d}  {r2:>10.4f}  {dt:>6.1f}s")
```

100그루에서 500그루로 5배 늘리면 시간은 비례해서 늘지만 R²는 0.001 정도밖에 안 오른다. 실무에서는 보통 100~200그루가 가성비 최적이다.

Ames에서 변수 중요도를 보면, MDI 상위는 `Overall Qual`(0.55), `Gr Liv Area`(0.10), `Total SF`(0.08), `Total Bath`(0.04) 순이다. 1부에서 손으로 만든 `Total SF`가 상위에 들어왔다는 점이 흥미롭다. 특성공학이 트리에서도 효과적임을 보여 준다.

---

## 8장 배깅의 한계와 부스팅으로의 다리

랜덤 포레스트는 분산 감소를 통해 단일 트리를 크게 능가한다. 그러나 그것이 가능한 모든 개선을 다 한 것인가. 그렇지 않다.

예측 오차는 일반적으로 세 부분으로 분해된다.

$$\mathbb{E}[(\hat{y} - y)^2] = \text{편향}^2 + \text{분산} + \text{잡음}$$

세 항은 각각 다음을 뜻한다.

**편향**(bias)은 모델이 근본적으로 잡지 못하는 패턴에서 오는 오차다. 예를 들어 직선만 그릴 수 있는 모델로 곡선을 잡으려 하면 큰 편향이 생긴다. **분산**(variance)은 데이터의 흔들림에 따라 모델이 흔들리는 정도다. 같은 모집단의 다른 데이터로 학습할 때마다 예측이 얼마나 달라지는가다. **잡음**(noise)은 데이터 자체에 내재한 무작위성으로, 어떤 모델로도 줄일 수 없다.

이 세 가지를 과녁에 비유하면 차이가 분명해진다.

![08 bias variance](figs/08_bias_variance.png)

<sub>그림 8-1. 편향-분산 분해의 과녁 비유. 검은 점이 참값(과녁의 중심)이고 색 점들이 여러 번 학습한 모델의 예측이다. (왼쪽) 단일 트리는 점들의 중심은 과녁 가운데에 있지만(저편향) 점들이 크게 흩어진다(고분산). (가운데) 랜덤 포레스트는 점들의 중심도 가운데, 흩어짐도 작다 — 분산만 줄였으나 결과가 가장 좋다. (오른쪽) 선형회귀는 점들이 모여 있지만(저분산) 중심이 비껴 있다(고편향).</sub>

#### 실습 — 한 점에 대한 예측 분포 직접 그리기

검증 데이터의 한 점에 대해 여러 부트스트랩에서 학습한 모델들의 예측 분포를 그려, 단일 트리·랜덤 포레스트·선형회귀의 분산과 편향을 시각적으로 비교한다.

```python
from sklearn.linear_model import LinearRegression

rng = np.random.default_rng(42)

val_idx = rng.choice(len(X), size=int(len(X) * 0.2), replace=False)
train_idx = np.setdiff1d(np.arange(len(X)), val_idx)
X_train, y_train = X.iloc[train_idx], y.iloc[train_idx]
X_test_one = X.iloc[[val_idx[0]]]
y_test_one = y.iloc[val_idx[0]]

n_runs = 50    # 50번이면 충분히 분포가 드러남
preds_tree, preds_rf, preds_lr = [], [], []

for run in range(n_runs):
    boot = rng.choice(len(X_train), size=len(X_train), replace=True)
    
    t = DecisionTreeRegressor(max_depth=10, random_state=run)
    t.fit(X_train.iloc[boot], y_train.iloc[boot])
    preds_tree.append(t.predict(X_test_one)[0])
    
    rf = RandomForestRegressor(n_estimators=50, random_state=run, n_jobs=-1)
    rf.fit(X_train.iloc[boot], y_train.iloc[boot])
    preds_rf.append(rf.predict(X_test_one)[0])
    
    lr = LinearRegression()
    lr.fit(X_train.iloc[boot], y_train.iloc[boot])
    preds_lr.append(lr.predict(X_test_one)[0])

# 분포 비교
fig, ax = plt.subplots(figsize=(10, 5))
ax.axvline(y_test_one, color="black", linewidth=2, label=f"참값 = {y_test_one:.3f}")
ax.hist(preds_tree, bins=20, alpha=0.5, label=f"단일 트리 (std={np.std(preds_tree):.3f})", color="#C0392B")
ax.hist(preds_rf, bins=20, alpha=0.5, label=f"랜덤 포레스트 (std={np.std(preds_rf):.3f})", color="#1F3A5F")
ax.hist(preds_lr, bins=20, alpha=0.5, label=f"선형회귀 (std={np.std(preds_lr):.3f})", color="#5A8C5A")
ax.set_xlabel("log(SalePrice) 예측값"); ax.set_ylabel("빈도")
ax.legend(); ax.set_title("같은 한 점에 대한 50번 학습 — 분산과 편향 비교")
plt.tight_layout(); plt.show()
```

세 분포의 모양이 결정적이다. 단일 트리는 분포가 가장 넓게 퍼져 있다(분산이 크다). 중심은 대체로 참값 근처(저편향)다. 랜덤 포레스트는 분포가 좁고 참값 근처에 모여 있다 — 분산도 작고 편향도 작다. 선형회귀는 분포가 매우 좁지만 참값에서 비껴 있다 — 분산은 작은데 편향이 크다.

배깅과 랜덤 포레스트는 분산 항을 공격한다. 편향 항은 거의 건드리지 못한다. 개별 트리들이 깊이 자라 각자 학습 데이터에 거의 완벽하게 적합하므로 개별 트리의 편향은 작고, 평균을 내는 과정도 편향을 줄이지 않는다.

따라서 랜덤 포레스트의 성능 상한은 **충분히 깊은 단일 트리의 편향 수준**에서 멈춘다. Ames에서 이 상한이 $R^2 \approx 0.88$ 근처임을 7장의 결과로 확인했다.

남은 0.12의 $R^2$ 격차를 줄이려면 다른 전략이 필요하다. 편향 자체를 줄이는 전략이다. 그 전략이 **부스팅**(boosting)이다. 부스팅은 트리를 한 그루씩 순서대로 키우면서, 앞선 트리들이 잡지 못한 패턴을 다음 트리가 잡도록 한다. 분산 감소가 아니라 편향 감소가 목표다.

배깅과 부스팅의 차이는 다음 한 줄로 요약된다.

| 갈래 | 트리 키우는 방식 | 줄이는 오차 | 트리 간 관계 |
|---|---|---|---|
| 배깅 (Random Forest) | 여러 그루를 독립적으로 키워 평균 | 분산 | 서로 무관 (병렬) |
| 부스팅 (AdaBoost, GBM, ...) | 여러 그루를 순서대로 키워 누적 | 편향 | 다음 트리는 앞의 결과를 봄 (순차) |

같은 트리 기반이면서도 두 방법의 설계 철학은 정반대다. 정반대이기 때문에 두 방법은 서로의 약점을 보완한다.

부스팅의 가장 단순한 구현이 **AdaBoost**(Adaptive Boosting)다. AdaBoost를 손실함수의 일반화로 확장한 것이 **GBM**(Gradient Boosting Machine)이며, **XGBoost**·**LightGBM**·**CatBoost**는 모두 GBM의 현대적 구현체다. 이들은 모두 한 그루씩 순서대로 키우면서 잔차를 줄여 나간다는 부스팅의 한 가지 아이디어를 다양한 방식으로 풀어낸다.

배깅의 분산 하한 $\rho \sigma^2$를 보면서 트리 수를 늘려도 분산이 더 줄지 않는다는 좌절감과, 한 번 더 0.12포인트의 $R^2$를 짜낼 수 있는 다른 길이 존재한다는 기대감이 부스팅을 향한다. 부스팅의 첫 트리는 단순한 평균 예측이고, 두 번째 트리는 그 평균 예측이 만든 잔차를 학습하며, 세 번째 트리는 그 잔차의 잔차를 학습한다. 단순한 누적이 어떻게 편향을 깎아 가는가, 그리고 그 과정에서 어떤 새로운 문제가 등장하는가를 보는 일이 부스팅 가족 전체의 이야기다.
