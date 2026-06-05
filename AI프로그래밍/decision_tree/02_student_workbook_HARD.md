# 3부 학생 워크북 — 결정 트리, 배깅, 랜덤 포레스트

## 어려운 버전 — 학부 1~2학년용

이 워크북은 이론 교재 `00_bagging_random_forest_theory_HARD.md`를 읽으면서 함께 채우는 자가학습 자료이다. 교재의 0~8장 흐름을 그대로 따라가며, 각 장의 핵심 개념과 코드를 빈칸으로 두었다. 빈칸을 채운 뒤 바로 아래의 **정답 보기**를 펼쳐 확인할 수 있다.

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 0장 결정 트리 — 질문의 사슬로 답을 찾는 모델

### 0.1 결정 트리란 무엇인가

![01 decision tree basic](figs/01_decision_tree_basic.png)

<sub>그림 0-1. 결정 트리는 뿌리에서 잎까지의 한 경로를 따라 예측한다.</sub>

**개념 1.** 결정 트리는 데이터에 대한 일련의 ____________________ 질문을 트리 모양으로 쌓아 답을 내는 모델이다. 뿌리 노드에서 시작하여 각 노드의 질문에 답한 방향으로 가지를 따라 내려가다가 ____________________ 노드에 도달하면, 그 노드가 가진 값이 입력에 대한 예측이다.

<details><summary>▶ 정답 보기</summary>

예/아니오 / 잎(leaf)

</details>

**개념 2.** 트리 모델의 두 매력적인 성질은 매우 높은 ____________________(어떤 입력이 왜 그런 예측을 받았는지 설명 가능)과 입력 변수의 ____________________(예: 로그·제곱근)에 대한 불변성이다.

<details><summary>▶ 정답 보기</summary>

해석 가능성(interpretability) / 단조 변환(monotone transformation)

</details>

**코드 빈칸 1.** 깊이 무제한 트리의 잎 개수와 학습 R²를 출력하는 코드.

```python
from sklearn.tree import DecisionTreeRegressor

full_tree = DecisionTreeRegressor(random_state=42)
full_tree.____(X, y)

print(f"트리 깊이:   {full_tree.____()}")
print(f"잎 노드 수:  {full_tree.____()}")
print(f"학습 R²:     {full_tree.____(X, y):.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
full_tree.fit(X, y)
full_tree.get_depth()
full_tree.get_n_leaves()
full_tree.score(X, y)
```

깊이 무제한 트리는 학습 데이터를 거의 외워 잎이 2,000개를 넘고 학습 R²가 1.0에 가깝다.

</details>

### 0.2 분류 트리의 불순도 — 엔트로피와 지니

![02 entropy gini curve](figs/02_entropy_gini_curve.png)

<sub>그림 0-2. 엔트로피와 지니 불순도는 둘 다 p=0.5에서 최댓값을 갖는다.</sub>

**개념 3.** 한 노드에 클래스 $k$가 비율 $p_k$로 들어 있을 때, 엔트로피는 다음과 같이 정의된다.

$$H = - \sum_{k=1}^{K} p_k \, \_\_\_\_\_\_\_\_$$

이진 분류에서 $p_k = 1$이면 엔트로피는 ____, $p_k = 0.5$이면 엔트로피는 ____ 이다.

<details><summary>▶ 정답 보기</summary>

$\log_2 p_k$ / 0 / 1

</details>

**개념 4.** 지니 불순도는 한 노드에서 두 샘플을 무작위로 뽑았을 때 두 샘플이 서로 ____________________ 클래스에 속할 확률이다. 식으로는 $G = 1 - \sum p_k^2 = \sum p_k(\_\_\_\_)$이다.

<details><summary>▶ 정답 보기</summary>

다른 / $1 - p_k$

</details>

**개념 5.** 엔트로피와 지니는 거의 같은 모양의 곡선이며, 트리가 선택하는 분할도 대부분 같다. 다만 엔트로피는 ____________________를 포함하여 계산이 약간 느리고, 지니는 ____________________만 있어 빠르다. sklearn의 `DecisionTreeClassifier` 기본값이 `criterion='gini'`인 이유는 이 속도 차이 때문이다.

<details><summary>▶ 정답 보기</summary>

로그(logarithm) / 곱셈(multiplication)

</details>

**코드 빈칸 2.** 엔트로피와 지니 곡선을 직접 그리는 코드의 핵심 두 줄.

```python
p = np.linspace(0.001, 0.999, 200)

# 엔트로피
entropy = -p * np.____(p) - (1-p) * np.log2(1-p)

# 지니 불순도
gini = ____ * p * (1-p)
```

<details><summary>▶ 정답 보기</summary>

```python
entropy = -p * np.log2(p) - (1-p) * np.log2(1-p)
gini = 2 * p * (1-p)
```

`np.log`(자연로그)와 `np.log2`(밑이 2)를 헷갈리지 않도록 주의한다. 엔트로피의 표준은 밑이 2다.

</details>

### 0.3 회귀 트리의 불순도 — 분산**개념 6.** 회귀 트리의 표준 불순도는 ____________________(MSE)이며, 한 노드 안의 ____________________과 같다. 회귀 트리의 잎 노드 예측값은 그 노드에 속한 학습 샘플들의 $y$ ____________________이다.

<details><summary>▶ 정답 보기</summary>

평균 제곱 오차 / 분산(variance) / 평균(mean)

</details>

**개념 7.** MAE(평균 절대 오차) 분기 기준은 이상치에 더 ____________________(견고하다/민감하다) 하지만, 분할마다 ____________________를 다시 계산해야 해서 MSE보다 약 ____배 느리다.

<details><summary>▶ 정답 보기</summary>

견고하다 / 중앙값 / 10

</details>

### 0.4 분기 — 가장 큰 정보이득을 주는 분할 찾기

![03 split process](figs/03_split_process.png)

<sub>그림 0-3. 결정 트리의 한 번의 분할 과정.</sub>

**개념 8.** 분기 한 번이 줄인 불순도를 ____________________(information gain)이라 부른다. 식으로는 다음과 같다.

$$\text{정보이득} = I_{\text{before}} - I_{\text{after}}, \qquad I_{\text{after}} = \frac{n_L}{n} I_L + \frac{n_R}{n} I_R$$

가중 평균을 쓰는 이유는, 큰 자식 노드의 불순도가 작은 자식 노드의 불순도보다 ____________________ 비중을 가져야 공평하기 때문이다.

<details><summary>▶ 정답 보기</summary>

정보이득 / 더 큰

</details>

**개념 9.** Ames 데이터에서 `Overall Qual ≤ 7` 한 번의 분할이 전체 MSE의 약 ____________________ % 이상을 깎는다. sklearn의 트리는 모든 변수의 모든 후보 임계값에 대해 같은 계산을 반복하고, 정보이득이 최대인 한 쌍을 선택한다.

<details><summary>▶ 정답 보기</summary>

50

</details>

**코드 빈칸 3.** `Overall Qual ≤ 7` 분할의 정보이득 계산.

```python
y_all = y.values
mse_before = y_all.____()

left_mask = X["Overall Qual"] <= 7
y_left = y_all[left_mask]
y_right = y_all[____]

n_total = len(y_all)
mse_after = (len(y_left)/n_total) * y_left.var() + (len(y_right)/n_total) * y_right.____()
gain = ____ - mse_after
```

<details><summary>▶ 정답 보기</summary>

```python
mse_before = y_all.var()
y_right = y_all[~left_mask]
y_right.var()
gain = mse_before - mse_after
```

`~left_mask`는 boolean 마스크의 NOT 연산자이다. `not left_mask`가 아니라 `~`를 써야 numpy 배열에 적용된다.

</details>

### 0.5 트리 성장과 멈춤 — 가지치기**개념 10.** 과적합을 막는 두 가지 전략은 ____________________ 가지치기(`max_depth`, `min_samples_leaf` 같은 멈춤 조건)와 ____________________ 가지치기(완전히 자란 트리에서 덜 중요한 가지를 잘라내기, `ccp_alpha` 사용)이다.

<details><summary>▶ 정답 보기</summary>

사전(pre-pruning) / 사후(post-pruning)

</details>

**개념 11.** 학습 R²는 깊이가 깊어질수록 1.0에 계속 가까워지지만, 검증 R²는 보통 깊이 ____________________ 근처에서 정점을 찍고 다시 떨어진다. 그 정점이 과적합 시작점이며, 단일 트리에서 `max_depth`를 그 근처로 두는 것이 좋다.

<details><summary>▶ 정답 보기</summary>

6~10

</details>

**개념 12.** `max_depth`가 **깊이의 상한**이라는 거친 도구라면 `ccp_alpha`는 ____________________ 의 가치를 검토하는 정교한 도구이다. 둘은 함께 쓸 수도 있다.

<details><summary>▶ 정답 보기</summary>

각 가지(branch)

</details>

**코드 빈칸 4.** 깊이별 학습 R²와 5-fold CV R²를 측정하는 루프.

```python
from sklearn.model_selection import cross_val_score

depths = [1, 2, 3, 5, 8, 12, 20, None]
train_r2, cv_r2 = [], []

for d in depths:
    t = DecisionTreeRegressor(max_depth=____, random_state=42)
    t.fit(X, y)
    train_r2.append(t.____(X, y))
    cv_r2.append(cross_val_score(t, X, y, cv=____, scoring="____").mean())
```

<details><summary>▶ 정답 보기</summary>

```python
t = DecisionTreeRegressor(max_depth=d, random_state=42)
t.score(X, y)
cv=5, scoring="r2"
```

`cv=5`는 5-fold 교차검증을 의미하며, `scoring="r2"`은 결정계수를 평가 지표로 쓴다는 뜻이다.

</details>

---

## 1장 한 그루 트리의 흔들림과 평균의 안정
**개념 1.** 통계학에서 데이터의 작은 흔들림에 결과가 크게 흔들리는 추정량을 ____________________이 큰 추정량이라고 부른다. 단일 결정 트리는 이 추정량의 대표 예시이다.

<details><summary>▶ 정답 보기</summary>

분산(variance)

</details>

**개념 2.** 서로 독립인 추정량 $B$개를 평균내면 분산이 정확히 ____________________ 배로 줄어든다. 100그루의 트리를 평균내면 분산이 ____________________ 배 작아지고 예측이 그만큼 안정된다.

<details><summary>▶ 정답 보기</summary>

$B$분의 1(1/B) / 100

</details>

**개념 3.** 그러나 같은 원본 데이터에서 만든 트리들은 약 ____________________ %의 행을 공유하므로, 거기서 만들어진 트리들은 어느 정도 ____________________ 되어 있다. 이 상관 때문에 분산이 1/B로 깔끔하게 줄지 않는다.

<details><summary>▶ 정답 보기</summary>

63.2 / 상관(correlation)

</details>

**개념 4.** 두 가지 어려움을 해결하는 두 도구는 ____________________ 표본(데이터의 무작위성 주입)과 ____________________ 변수 선택(변수의 무작위성 주입)이다.

<details><summary>▶ 정답 보기</summary>

부트스트랩(bootstrap) / 무작위(random)

</details>

**코드 빈칸 1.** 70% 부분집합 학습을 20번 반복하여 뿌리 노드 분할 변수의 분포를 확인하는 코드.

```python
from collections import Counter

rng = np.random.default_rng(42)
n = len(X)
first_splits = []

for seed in range(20):
    idx = rng.choice(n, size=int(n * 0.7), replace=____)
    t = DecisionTreeRegressor(max_depth=3, random_state=42)
    t.fit(X.iloc[idx], y.iloc[idx])
    root_feature_idx = t.tree_.____[0]
    first_splits.append(X.columns[root_feature_idx])

for var, cnt in Counter(first_splits).____():
    print(f"  {var:<20s}  {cnt}회")
```

<details><summary>▶ 정답 보기</summary>

```python
replace=False     # 비복원 추출
t.tree_.feature[0]   # 뿌리 노드의 분할 변수 인덱스
Counter(first_splits).most_common()
```

`tree_.feature`는 sklearn 내부 트리의 각 노드 분할 변수 인덱스 배열이다. 인덱스 0은 뿌리 노드를 가리킨다.

</details>

---

## 2장 복원 추출과 부트스트랩 표본

![04 bagging diagram](figs/04_bagging_diagram.png)

<sub>그림 2-1. 배깅의 세 단계 — 부트스트랩 표본 → 독립적 트리 학습 → 평균(다수결).</sub>

**개념 5.** 부트스트랩 표본은 원본에서 ____________________ 추출로 만든 **같은 크기**의 표본이다. 어떤 행은 ____________________ 으로 뽑히고, 어떤 행은 한 번도 뽑히지 않는다.

<details><summary>▶ 정답 보기</summary>

복원(with replacement) / 중복(여러 번)

</details>

**개념 6.** 표본 크기 $n$이 충분히 클 때, 어떤 특정 행이 한 번도 뽑히지 않을 확률은 다음으로 수렴한다.

$$\lim_{n\to\infty} \left(1 - \frac{1}{n}\right)^n = \_\_\_\_\_\_\_\_ \approx \_\_\_\_\_\_\_\_$$

즉 약 ____ % 의 행이 한 번도 안 뽑힌다.

<details><summary>▶ 정답 보기</summary>

$e^{-1}$ / 0.368 / 36.8

</details>

**개념 7.** 부트스트랩 표본에 한 번도 안 뽑힌 약 36.8%를 ____________________ 표본이라 부른다. 이 표본은 그 트리의 학습에 사용되지 않았으므로, 별도의 ____________________ 데이터처럼 쓸 수 있다.

<details><summary>▶ 정답 보기</summary>

OOB (Out-of-Bag) / 검증(validation)

</details>

**개념 8.** 부트스트랩 표본 $B$개를 만들면 각각 다른 36.8%가 빠진다. 즉 어떤 한 행은 평균적으로 전체 트리의 ____________________ %에서 OOB가 된다. 100그루의 숲을 만들면 행 한 개당 약 ____________________ 그루가 그 행을 한 번도 본 적이 없다.

<details><summary>▶ 정답 보기</summary>

36.8 / 37

</details>

**코드 빈칸 2.** 부트스트랩 표본과 OOB 인덱스를 분리하는 코드.

```python
rng = np.random.default_rng(42)
n = len(X)

boot_idx = rng.choice(n, size=n, replace=____)
unique_idx = np.____(boot_idx)
oob_idx = np.____(np.arange(n), unique_idx)

print(f"고유 인덱스: {len(unique_idx)/n*100:.1f}%")
print(f"OOB:         {len(oob_idx)/n*100:.1f}%")
```

<details><summary>▶ 정답 보기</summary>

```python
replace=True               # 복원 추출
unique_idx = np.unique(boot_idx)
oob_idx = np.setdiff1d(np.arange(n), unique_idx)
```

`np.setdiff1d(A, B)`는 A에서 B에 속하는 원소를 뺀 차집합을 반환한다.

</details>

**코드 빈칸 3.** 한 그루 트리의 OOB R² 측정.

```python
from sklearn.metrics import r2_score

boot_idx = rng.choice(n, size=n, replace=True)
oob_mask = np.setdiff1d(np.arange(n), np.unique(boot_idx))

t = DecisionTreeRegressor(max_depth=10, random_state=42)
t.fit(X.iloc[____], y.iloc[____])   # 부트스트랩 표본으로 학습

oob_pred = t.____(X.iloc[oob_mask])     # OOB로 예측
score = ____(y.iloc[oob_mask], oob_pred)
```

<details><summary>▶ 정답 보기</summary>

```python
t.fit(X.iloc[boot_idx], y.iloc[boot_idx])
oob_pred = t.predict(X.iloc[oob_mask])
score = r2_score(y.iloc[oob_mask], oob_pred)
```

</details>

---

## 3장 분산 감소의 수학 — 독립이 깨지면 어떻게 되는가

![05 variance reduction](figs/05_variance_reduction.png)

<sub>그림 3-1. 트리 개수 B에 따른 앙상블 분산. ρ가 클수록 분산 하한이 높다.</sub>

**개념 9.** 상관계수 $\rho$로 연결된 추정량들의 평균 분산은 다음과 같다.

$$\text{Var}(\bar{f}) = \rho \sigma^2 + \frac{\_\_\_\_\_\_\_\_}{\_\_\_\_\_\_\_\_} \sigma^2$$

첫 번째 항은 트리 수 $B$와 ____________________(무관하다 / 비례한다). 두 번째 항은 $B$가 커지면 ____ 에 수렴한다.

<details><summary>▶ 정답 보기</summary>

$1 - \rho$ / $B$ / 무관하다 / 0

</details>

**개념 10.** $B \to \infty$의 극한에서 분산은 ____________________에 수렴한다. 이것이 배깅의 분산 ____________________(아래로 더 못 내려가는 한계값)이다.

<details><summary>▶ 정답 보기</summary>

$\rho \sigma^2$ / 하한(lower bound)

</details>

**개념 11.** 따라서 배깅의 성능을 더 올리는 두 가지 길은 트리 수 $B$를 늘리는 것과 ____________________ 자체를 줄이는 것이다. 후자가 더 강력하다.

<details><summary>▶ 정답 보기</summary>

상관 $\rho$ (트리 간 상관)

</details>

**개념 12.** 데이터에서 **강한 변수**가 압도적이면 어떤 부트스트랩 표본을 만들어도 그 변수가 ____________________ 분할에 등장한다. 결과적으로 모든 트리가 비슷한 첫 분할을 갖게 되고 $\rho$가 ____________________ 진다.

<details><summary>▶ 정답 보기</summary>

첫(root) / 커진다(증가한다)

</details>

**코드 빈칸 4.** 트리 간 상관계수 ρ를 직접 측정.

```python
rng = np.random.default_rng(42)
preds = []
for b in range(20):
    boot_idx = rng.choice(n, size=n, replace=True)
    t = DecisionTreeRegressor(max_features=____, max_depth=10, random_state=b)
    t.fit(X.iloc[boot_idx], y.iloc[boot_idx])
    preds.append(t.predict(X_val))

preds = np.array(preds)

# 모든 트리 쌍의 평균 상관계수
corrs = [np.____(preds[i], preds[j])[0, 1]
         for i in range(20) for j in range(i+1, 20)]
print(f"평균 트리 간 ρ = {np.mean(corrs):.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
max_features=mf_val          # 변수 무작위성 매개변수
np.corrcoef(preds[i], preds[j])[0, 1]
```

`np.corrcoef`는 상관계수 행렬을 반환하므로 `[0, 1]`로 두 변수의 상관계수를 추출한다.

</details>

---

## 4장 무작위 변수 선택과 트리 간 상관 깨기

![06 mtry tradeoff](figs/06_mtry_tradeoff.png)

<sub>그림 4-1. mtry의 균형점 — 개별 트리 강도와 트리 간 상관의 줄다리기.</sub>

**개념 1.** 랜덤 포레스트의 핵심 아이디어는 매 분할마다 변수의 ____________________ 부만 무작위로 골라 쓰는 것이다. 이 매개변수를 sklearn에서는 ____________________ 로 부른다.

<details><summary>▶ 정답 보기</summary>

일(some) / `max_features`

</details>

**개념 2.** Breiman의 경험칙으로 회귀에서는 mtry $=$ ____________________, 분류에서는 mtry $=$ ____________________ 이 권장된다. Ames 데이터의 변수 80개 기준으로는 회귀에서 약 ____, 분류에서 약 ____ 개이다.

<details><summary>▶ 정답 보기</summary>

$\lfloor p/3 \rfloor$ / $\lfloor \sqrt{p} \rfloor$ / 27 / 9

</details>

**개념 3.** mtry가 작을수록 개별 트리가 ____________________ 지고 트리 간 상관 $\rho$는 ____________________ 진다. mtry가 클수록 그 반대다. 두 힘의 ____________________ 이 mtry 튜닝의 본질이다.

<details><summary>▶ 정답 보기</summary>

약해(weak) / 작아(small) / 균형(balance)

</details>

**개념 4.** 단일 트리에서는 깊이 제한이 과적합 방지에 필수였지만, 랜덤 포레스트에서는 **각 트리를 ____________________ 두는 것** 이 보통 최적이다. 개별 트리가 깊으면 ____________________ 이 작고, 분산은 평균이 줄여 주기 때문이다.

<details><summary>▶ 정답 보기</summary>

깊이 제한 없이(max_depth=None) / 편향(bias)

</details>

**코드 빈칸 1.** max_features 튜닝 곡선 그리기.

```python
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import cross_val_score

n_features = X.shape[1]
mtry_candidates = [3, 5, n_features // 4, n_features // ____, n_features // 2, n_features]

results = []
for mf in mtry_candidates:
    rf = RandomForestRegressor(n_estimators=100, max_features=____,
                                random_state=42, n_jobs=____)
    r2 = cross_val_score(rf, X, y, cv=5, scoring="r2", n_jobs=-1).mean()
    results.append((mf, r2))
```

<details><summary>▶ 정답 보기</summary>

```python
n_features // 3        # 권장 mtry
max_features=mf
n_jobs=-1              # 모든 CPU 사용
```

`n_jobs=-1`은 모든 CPU 코어를 사용한다는 의미이며, 4코어 기준 약 4배 빠르다.

</details>

---

## 5장 OOB 점수 — 외부 검증 없는 일반화 추정
**개념 5.** 행 $i$의 OOB 예측은, 그 행을 ____________________ 로 가진 트리들만의 예측을 평균낸 값이다. 그 행을 학습에 본 적 없는 트리들의 예측이므로 ____________________ 데이터와 통계적으로 같은 의미를 갖는다.

<details><summary>▶ 정답 보기</summary>

OOB(부트스트랩에 안 들어간) / 검증(validation)

</details>

**개념 6.** OOB 점수의 가장 큰 장점은 ____________________ 없이 일반화 성능을 추정한다는 것이다. 5-fold CV는 모델을 5번 학습시켜야 하지만, OOB 점수는 ____________________ 의 학습으로 같은 효과를 낸다.

<details><summary>▶ 정답 보기</summary>

교차검증(CV) / 한 번

</details>

**개념 7.** 이론적으로 트리 수가 충분히 크면 OOB 점수는 ____________________ 교차검증과 점근적으로 일치한다. LOO-CV는 $n$번 학습해야 하므로 Ames에서는 약 2,900번 학습인데, OOB는 한 번 학습으로 같은 정보를 준다.

<details><summary>▶ 정답 보기</summary>

leave-one-out (LOO)

</details>

**개념 8.** OOB 점수의 주의점은, 트리 수가 ____________________ 면 일부 행의 OOB 예측이 불안정하다는 점이다. 그리고 진정한 외부 데이터에 대한 일반화는 별도 ____________________ 으로 확인하는 것이 안전하다.

<details><summary>▶ 정답 보기</summary>

적으(n_estimators < 50) / hold-out (test set)

</details>

**코드 빈칸 2.** OOB 점수 계산.

```python
rf = RandomForestRegressor(n_estimators=100,
                            ____________________=True,
                            random_state=42, n_jobs=-1)
rf.fit(X, y)

print(f"OOB R²: {rf.____________________:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
oob_score=True
rf.oob_score_         # 속성 끝의 underscore 주의
```

sklearn 관례상 `fit` 후에 계산되는 속성은 끝에 `_`가 붙는다. `oob_score`는 생성자 매개변수, `oob_score_`는 학습 후 속성이다.

</details>

**코드 빈칸 3.** `warm_start`로 트리 수에 따른 OOB 점수 누적 측정.

```python
rf = RandomForestRegressor(n_estimators=10, oob_score=True,
                            ____________________=True,  # 트리 추가만 누적
                            random_state=42, n_jobs=-1)
oob_curve = []
for n_tr in range(10, 201, 10):
    rf.____________________(n_estimators=n_tr)
    rf.fit(X, y)
    oob_curve.append(rf.oob_score_)
```

<details><summary>▶ 정답 보기</summary>

```python
warm_start=True
rf.set_params(n_estimators=n_tr)
```

`warm_start=True`는 이전 학습 결과를 유지하고 새 트리만 추가하므로 누적 학습이 빠르다.

</details>

---

## 6장 변수 중요도 — 두 가지 계산 방법

![07 importance compare](figs/07_importance_compare.png)

<sub>그림 6-1. MDI와 순열 중요도의 비교 — 사촌 변수에서 가장 크게 갈라진다.</sub>

**개념 9.** **MDI**(평균 ____________________ 감소)는 학습 과정 중에 자동 계산되며, sklearn의 ____________________ 속성으로 즉시 얻을 수 있다. 단점은 카디널리티 높은 변수에 대한 ____________________ 이다.

<details><summary>▶ 정답 보기</summary>

불순도(impurity) / `feature_importances_` / 편향(bias)

</details>

**개념 10.** **순열 중요도**는 검증 데이터에서 어떤 변수의 값을 행 사이에서 ____________________(셔플) 모델 성능이 얼마나 떨어지는지 측정한다. 어떤 모델에도 적용 가능한 일반적 방법이며, MDI의 편향이 ____________________(있다 / 없다).

<details><summary>▶ 정답 보기</summary>

무작위로 섞어 / 없다

</details>

**개념 11.** **사촌처럼 닮은 변수**가 있을 때 두 측정은 다른 답을 준다. MDI는 둘 다 ____________________ 중요도를 주지만(분할마다 번갈아 사용), 순열 중요도는 ____________________ 0의 중요도를 준다(서로 ____________________).

<details><summary>▶ 정답 보기</summary>

적당한(moderate) / 거의 / 대체 가능(replaceable)

</details>

**개념 12.** 두 측정의 핵심 차이를 한 문장으로 정리하면, MDI는 **어떤 변수가 ____________________ 사용되었는가**를 보고, 순열 중요도는 **그 변수가 ____________________ 되는가**를 본다.

<details><summary>▶ 정답 보기</summary>

실제로(in practice) / 없어도(replaceable, 대체 가능)

</details>

**코드 빈칸 4.** MDI와 순열 중요도 동시 계산.

```python
from sklearn.inspection import ____________________
from sklearn.model_selection import train_test_split

# 학습된 RF에서 MDI 추출
mdi = pd.Series(rf.____________________, index=X.columns).sort_values(ascending=False)

# 순열 중요도
X_tr, X_te, y_tr, y_te = train_test_split(X, y, test_size=0.2, random_state=42)
rf.fit(X_tr, y_tr)

perm = permutation_importance(rf, X_te, y_te,
                                n_repeats=____, random_state=42, n_jobs=-1)
perm_imp = pd.Series(perm.____________________, index=X.columns).sort_values(ascending=False)
```

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.inspection import permutation_importance
mdi = pd.Series(rf.feature_importances_, ...)
n_repeats=10                     # 각 변수를 10번 섞어 평균
perm_imp = pd.Series(perm.importances_mean, ...)
```

`n_repeats=10`이 안정적인 표준이다. 작은 데이터에서는 5도 가능하지만 통계적 신뢰도가 떨어진다.

</details>

**코드 빈칸 5.** 사촌 변수 효과 — 한 쪽만 제거 vs 둘 다 제거.

```python
X_no_cars = X.____(columns=["Garage Cars"])
X_no_area = X.drop(columns=["Garage Area"])
X_no_both = X.drop(columns=["Garage Cars", "Garage Area"])

for name, X_subset in [("전체", X), 
                        ("Cars만 제거", X_no_cars),
                        ("Area만 제거", X_no_area),
                        ("둘 다 제거", X_no_both)]:
    rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
    r2 = cross_val_score(rf, X_subset, y, cv=5, scoring="r2", n_jobs=-1).____()
    print(f"  {name:<15s}  R² = {r2:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
X.drop(columns=["Garage Cars"])
.mean()        # cross_val_score는 배열을 반환하므로 평균 필요
```

한 쪽만 제거하면 R²가 거의 변하지 않다가, 둘 다 제거해야 비로소 떨어진다. 사촌 변수의 **대체 가능성**이 데이터로 확인되는 실험이다.

</details>

---

## 7장 Ames 데이터에서 랜덤 포레스트의 동작
**개념 1.** Ames에서 단일 결정 트리의 CV R²는 약 ____________________ 으로, 선형회귀(0.80)보다도 못하다. 한 그루의 ____________________ 이 너무 커서 일반화가 약하기 때문이다.

<details><summary>▶ 정답 보기</summary>

0.7543 (약 0.75) / 분산(variance)

</details>

**개념 2.** 랜덤 포레스트 100그루는 CV R²가 약 ____________________ 로, 단일 트리보다 약 ____________________ 포인트 앞선다. 이 점프가 ____________________ 감소의 직접적 결과이다.

<details><summary>▶ 정답 보기</summary>

0.8806 (약 0.88) / 0.13 / 분산

</details>

**개념 3.** 100그루에서 500그루로 5배 늘려도 R²는 약 ____________________ 정도밖에 안 오른다. 실무에서는 보통 ____________________ 그루가 가성비 최적이며, 그 이상은 시간 대비 효과가 미미하다.

<details><summary>▶ 정답 보기</summary>

0.001 / 100~200

</details>

**개념 4.** Ames에서 RF의 MDI 1위는 ____________________ (중요도 약 0.55)이며, 3위에 1부에서 우리가 만든 ____________________ 가 들어온다. 이는 ____________________ 이 트리 모델에서도 유효함을 보여 준다.

<details><summary>▶ 정답 보기</summary>

`Overall Qual` / `Total SF` / 특성공학(feature engineering)

</details>

**코드 빈칸 1.** 5개 모델의 CV R² 한 표로 비교.

```python
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import cross_val_score

models = {
    "선형회귀":             LinearRegression(),
    "결정 트리":            DecisionTreeRegressor(random_state=42),
    "결정 트리 (가지치기)": DecisionTreeRegressor(max_depth=____, min_samples_leaf=10, random_state=42),
    "RF 100그루":           RandomForestRegressor(n_estimators=____, random_state=42, n_jobs=-1),
    "RF 300그루":           RandomForestRegressor(n_estimators=300, random_state=42, n_jobs=-1),
}

for name, m in models.items():
    r2 = cross_val_score(m, X, y, cv=____, scoring="r2", n_jobs=-1).mean()
    print(f"{name:<25s}  CV R² = {r2:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
max_depth=8           # 가지치기 트리의 표준 깊이
n_estimators=100      # RF 표준 그루 수
cv=5                  # 5-fold 교차검증
```

이 코드의 출력으로 단일 트리(0.75)가 선형회귀(0.80)보다 못하고, RF(0.88)가 선형회귀를 크게 능가하는 패턴이 확인된다.

</details>

---

## 8장 배깅의 한계와 부스팅으로의 다리

![08 bias variance](figs/08_bias_variance.png)

<sub>그림 8-1. 편향-분산 분해의 과녁 비유 — 단일 트리(고분산), 랜덤 포레스트(저분산·저편향), 선형회귀(고편향).</sub>

**개념 5.** 예측 오차는 다음 세 부분으로 분해된다.

$$\mathbb{E}[(\hat{y} - y)^2] = \_\_\_\_\_\_\_\_^2 + \_\_\_\_\_\_\_\_ + \_\_\_\_\_\_\_\_$$

마지막 항은 데이터 자체의 무작위성으로, ____________________ 모델로도 줄일 수 없다.

<details><summary>▶ 정답 보기</summary>

편향(bias) / 분산(variance) / 잡음(noise) / 어떤

</details>

**개념 6.** 과녁 비유에서 점들의 **중심이 어긋난 정도**가 ____________________ 이고, **점들이 흩어진 정도**가 ____________________ 이다. 검은 점(참값)이 과녁 중심이다.

<details><summary>▶ 정답 보기</summary>

편향(bias) / 분산(variance)

</details>

**개념 7.** 단일 트리는 ____________________ 편향에 ____________________ 분산. 랜덤 포레스트는 ____________________ 편향에 ____________________ 분산. 선형회귀는 ____________________ 편향에 ____________________ 분산. 세 모델의 강점과 약점이 한 표로 정리된다.

<details><summary>▶ 정답 보기</summary>

저 / 고 / 저 / 저 / 고 / 저

</details>

**개념 8.** 배깅과 랜덤 포레스트는 ____________________ 항을 공격한다. ____________________ 항은 거의 건드리지 못한다. 따라서 RF의 성능 상한은 충분히 깊은 단일 트리의 ____________________ 수준에서 멈춘다.

<details><summary>▶ 정답 보기</summary>

분산(variance) / 편향(bias) / 편향(bias)

</details>

**개념 9.** Ames에서 RF의 성능 상한이 약 R² ____________________ 근처이며, 남은 0.12의 격차를 줄이려면 ____________________ 자체를 공격하는 새 전략이 필요하다. 그 전략이 다음 부에서 다룰 ____________________(boosting)이다.

<details><summary>▶ 정답 보기</summary>

0.88 / 편향(bias) / 부스팅(boosting)

</details>

**개념 10.** 배깅과 부스팅의 차이를 한 줄로 요약하면, 배깅은 트리들을 ____________________ 으로 키워 평균하고(분산 감소), 부스팅은 트리들을 ____________________ 으로 키워 누적한다(편향 감소). 두 방법은 서로의 약점을 보완한다.

<details><summary>▶ 정답 보기</summary>

독립적(parallel) / 순차적(sequential)

</details>

**코드 빈칸 2.** 한 점에 대한 50번 부트스트랩 학습으로 예측 분포 그리기.

```python
from sklearn.linear_model import LinearRegression

rng = np.random.default_rng(42)
val_idx = rng.choice(len(X), size=int(len(X)*0.2), replace=False)
train_idx = np.setdiff1d(np.arange(len(X)), val_idx)
X_train, y_train = X.iloc[train_idx], y.iloc[train_idx]
X_test_one = X.iloc[[val_idx[0]]]

preds_tree, preds_rf, preds_lr = [], [], []
for run in range(50):
    boot = rng.choice(len(X_train), size=len(X_train), replace=____)
    
    t = DecisionTreeRegressor(max_depth=10, random_state=run)
    t.fit(X_train.iloc[boot], y_train.iloc[boot])
    preds_tree.append(t.predict(X_test_one)[____])    # 한 점이라 [0]
    
    rf = RandomForestRegressor(n_estimators=____, random_state=run, n_jobs=-1)
    rf.fit(X_train.iloc[boot], y_train.iloc[boot])
    preds_rf.append(rf.predict(X_test_one)[0])
```

<details><summary>▶ 정답 보기</summary>

```python
replace=True              # 부트스트랩은 복원 추출
t.predict(X_test_one)[0]  # 한 점이므로 첫 원소
n_estimators=50           # 빠른 시연용
```

학생이 직접 실행 시 50번 학습은 약 1분 정도 걸린다. 강의 도중에는 50번이 적당하며, 더 자세한 분포가 필요하면 100번 이상으로 늘려도 된다.

</details>

---

## 응용 문제 — 직접 실행하며 풀기

다음 문제들은 이론 교재의 코드를 변형·확장한 것이다. 코드를 직접 실행해 본 뒤 정답 토글로 확인하기를 권한다.

**문제 1.** `max_depth=2`인 단일 결정 트리의 잎 노드 수와 CV R²를 구하라.

<details><summary>▶ 정답 보기</summary>

```python
t = DecisionTreeRegressor(max_depth=2, random_state=42)
t.fit(X, y)
print(f"잎 노드: {t.get_n_leaves()}")
print(f"CV R²:   {cross_val_score(t, X, y, cv=5, scoring='r2').mean():.4f}")
```

깊이 2 트리는 잎이 최대 4개이고 CV R²는 약 0.55~0.65 수준이다. 너무 단순한 트리라 패턴을 잡지 못한다(고편향).

</details>

**문제 2.** 부트스트랩 표본을 100번 만들어 **고유 인덱스 비율**의 표준편차를 구하라.

<details><summary>▶ 정답 보기</summary>

```python
rng = np.random.default_rng(42)
ratios = []
for _ in range(100):
    idx = rng.choice(len(X), size=len(X), replace=True)
    ratios.append(len(np.unique(idx)) / len(X))
print(f"평균: {np.mean(ratios):.4f}")
print(f"표준편차: {np.std(ratios):.4f}")
```

평균은 약 0.632(63.2%), 표준편차는 약 0.005~0.008로 매우 작다. 부트스트랩이 **극도로 안정적인** 통계량이라는 증거다.

</details>

**문제 3.** 단일 트리 5번을 **부트스트랩 학습**하여 그 평균 예측의 R²와, 5개 트리 각각의 평균 R²를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.metrics import r2_score

rng = np.random.default_rng(42)
preds = np.zeros((5, len(X)))
for i in range(5):
    b = rng.choice(len(X), len(X), replace=True)
    t = DecisionTreeRegressor(random_state=i)
    t.fit(X.iloc[b], y.iloc[b])
    preds[i] = t.predict(X)

single_r2 = np.mean([r2_score(y, preds[i]) for i in range(5)])
avg_r2 = r2_score(y, preds.mean(axis=0))
print(f"단일 평균: {single_r2:.4f}")
print(f"5개 평균:  {avg_r2:.4f}")
```

5개 평균이 단일 평균보다 높게 나온다. 그러나 5는 너무 적어 차이가 작다. 100그루로 늘리면 차이가 훨씬 커진다.

</details>

**문제 4.** `max_features=1`(매 분할에서 변수 1개만 후보)로 랜덤 포레스트 100그루를 학습하고 CV R²를 구하라.

<details><summary>▶ 정답 보기</summary>

```python
rf = RandomForestRegressor(n_estimators=100, max_features=1, random_state=42, n_jobs=-1)
r2 = cross_val_score(rf, X, y, cv=5, scoring='r2', n_jobs=-1).mean()
print(f"CV R² = {r2:.4f}")
```

R²가 약 0.70 정도로 단일 트리(0.75)보다도 못하다. mtry를 너무 작게 두면 **개별 트리가 너무 약해서** 평균을 내도 약하다. ρ는 거의 0이지만 σ²가 너무 크다.

</details>

**문제 5.** `oob_score=True`로 학습한 랜덤 포레스트의 OOB R²와 5-fold CV R²의 차이를 구하라.

<details><summary>▶ 정답 보기</summary>

```python
rf = RandomForestRegressor(n_estimators=100, oob_score=True, random_state=42, n_jobs=-1)
rf.fit(X, y)
cv_r2 = cross_val_score(rf, X, y, cv=5, scoring='r2', n_jobs=-1).mean()
print(f"OOB: {rf.oob_score_:.4f}")
print(f"CV:  {cv_r2:.4f}")
print(f"차이: {abs(rf.oob_score_ - cv_r2):.4f}")
```

차이가 보통 ±0.005 이내로 매우 작다. OOB가 CV의 신뢰할 만한 대체임을 확인한다.

</details>

**문제 6.** MDI 1위와 순열 중요도 1위가 같은 변수인지 확인하라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.inspection import permutation_importance

rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
rf.fit(X, y)
mdi_top = X.columns[rf.feature_importances_.argmax()]

perm = permutation_importance(rf, X, y, n_repeats=5, random_state=42)
perm_top = X.columns[perm.importances_mean.argmax()]

print(f"MDI 1위:   {mdi_top}")
print(f"순열 1위:  {perm_top}")
```

거의 항상 둘 다 `Overall Qual`이 1위다. 이 변수는 **대체 불가능한 강한 변수**라 두 측정 모두에서 최상위다.

</details>

**문제 7.** `Overall Qual`만 제거하고 랜덤 포레스트의 CV R²를 측정하라. 얼마나 떨어지는가?

<details><summary>▶ 정답 보기</summary>

```python
X_no_oq = X.drop(columns=["Overall Qual"])
rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
r2_full = cross_val_score(rf, X, y, cv=5, scoring='r2', n_jobs=-1).mean()
r2_drop = cross_val_score(rf, X_no_oq, y, cv=5, scoring='r2', n_jobs=-1).mean()
print(f"전체:        {r2_full:.4f}")
print(f"제거 후:     {r2_drop:.4f}")
print(f"성능 저하:   {r2_full - r2_drop:.4f}")
```

보통 R²가 0.02~0.04 떨어진다. 가장 중요한 변수를 제거했지만 **대체 변수가 많아** 큰 추락은 없다. 트리 앙상블의 **대체 가능 변수 풀**이 만들어 내는 견고함이다.

</details>

**문제 8.** 트리 1그루와 랜덤 포레스트 100그루의 **예측 시간**을 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
import time

t = DecisionTreeRegressor(random_state=42).fit(X, y)
rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1).fit(X, y)

t0 = time.time(); _ = t.predict(X); dt_tree = time.time() - t0
t0 = time.time(); _ = rf.predict(X); dt_rf = time.time() - t0

print(f"단일 트리: {dt_tree*1000:.2f}ms")
print(f"RF 100:    {dt_rf*1000:.2f}ms")
print(f"비율:      {dt_rf/dt_tree:.1f}배")
```

RF가 약 50~100배 느리다. 100그루를 모두 거쳐야 하기 때문이다. 실시간 시스템에서 이 차이는 결정적일 수 있다.

</details>

**문제 9.** `n_estimators`를 1, 10, 100, 500으로 늘리며 **학습 시간**이 어떻게 증가하는지 확인하라(병렬화 끄기 위해 `n_jobs=1`).

<details><summary>▶ 정답 보기</summary>

```python
import time

for n in [1, 10, 100, 500]:
    rf = RandomForestRegressor(n_estimators=n, random_state=42, n_jobs=1)
    t0 = time.time()
    rf.fit(X, y)
    dt = time.time() - t0
    print(f"n={n:>3}: {dt:.2f}s")
```

거의 정확히 선형 증가다. 트리 한 그루 학습 시간이 일정하므로 그루 수에 비례한다. `n_jobs=-1`로 두면 CPU 코어 수만큼 빨라진다(보통 4~8배).

</details>

**문제 10.** 학습한 단일 트리의 **잎 노드 평균 샘플 수**를 구하라.

<details><summary>▶ 정답 보기</summary>

```python
t = DecisionTreeRegressor(max_depth=8, random_state=42).fit(X, y)

# 잎 노드 식별: children_left == -1
is_leaf = (t.tree_.children_left == -1)
leaf_samples = t.tree_.n_node_samples[is_leaf]

print(f"잎 노드 수:        {len(leaf_samples)}")
print(f"평균 샘플 수:      {leaf_samples.mean():.1f}")
print(f"최소 샘플 수:      {leaf_samples.min()}")
print(f"최대 샘플 수:      {leaf_samples.max()}")
```

깊이 8 트리는 잎이 약 100~200개이고, 잎당 평균 15~30개 샘플이 들어간다. 잎이 너무 작으면(샘플 1~2개) 과적합 신호다.

</details>

---

## 다음 부 예고

다음 부에서는 같은 트리 기반이지만 **철학이 정반대** 인 **부스팅**(boosting)을 다룬다. 부스팅의 첫 알고리즘인 **AdaBoost**(Adaptive Boosting)부터 시작해 **GBM**(Gradient Boosting Machine)으로 일반화되는 과정을 따라간다. 그 후 GBM의 현대적 구현체 세 가지 — **XGBoost**, **LightGBM**, **CatBoost** — 가 어떻게 같은 알고리즘에서 서로 다른 강점을 가진 도구로 발전했는지를 본다.

흥미로운 한 가지를 미리 알려 둔다 — Ames 데이터에서 AdaBoost 회귀의 R²는 약 0.80으로 선형회귀와 비슷하지만, 캘리포니아 주택가격 데이터에서는 ____________________ 까지 떨어진다. 이상치에 매우 민감한 AdaBoost의 약점이 어떻게 등장하는지가 다음 부의 핵심 교훈이다.

<details><summary>▶ 정답 보기 (캘리포니아에서의 AdaBoost R²)</summary>

약 0.40 — 선형회귀(0.64)보다도 훨씬 못하다. AdaBoost가 이상치에 가중치를 폭증시키는 알고리즘 구조 때문이다. GBM이 이 약점을 어떻게 해결하는지가 5부의 이야기다.

</details>
