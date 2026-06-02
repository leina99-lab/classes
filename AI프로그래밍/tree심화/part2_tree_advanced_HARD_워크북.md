# 2부 학생 워크북 — 결정 트리 심화

## 어려운 버전 — 학부 1~2학년용

이 워크북은 이론 교재 `part2_tree_advanced_HARD_이론.md`를 읽으면서 함께 채우는 자가학습 자료이다. 빈칸을 채운 뒤 바로 아래의 **정답 보기** 토글을 펼쳐 확인할 수 있다.

본 워크북은 **3부 학생 워크북을 먼저 마친 후** 진행하기를 권한다. 3부 0장의 트리 기초 내용이 본 워크북의 출발점이다.

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 0장 왜 트리 심화가 필요한가

![01 basic vs advanced](figs/01_basic_vs_advanced.png)

<sub>그림 0-1. 3부 0장(트리 기초)과 2부(트리 심화)가 다루는 주제의 차이.</sub>

**개념 1.** 본 시리즈의 **권장 학습 순서**는?

1부 (데이터 마이닝) → ____________________ → ____________________ → 4부 (AdaBoost) → 5부 (GBM) → 6부 → 7부

부 번호 순서와 **완전히 일치하지 않는다**. 이유는 ____________________ 가 **3부 랜덤 포레스트의 토대**이기 때문에 3부 0장에 포함되기 때문이다.

<details><summary>▶ 정답 보기</summary>

3부 (트리 기초 + RF) / 2부 (트리 심화) / 트리 기초

</details>

**개념 2.** 2부의 핵심 메시지 두 가지:

(1) 단일 트리도 잘 다듬으면 ____________________ 까지 갈 수 있다 (3부 기본 0.77 → 2부 심화 후 0.83)
(2) 본 부의 매개변수는 ____________________ 에도 그대로 적용된다 (RF, GBM, XGBoost 등)

<details><summary>▶ 정답 보기</summary>

R² 0.83 / 앙상블 모델

</details>

---

## 1장 분할 알고리즘의 복잡도

![02 split complexity](figs/02_split_complexity.png)

<sub>그림 1-1. 결정 트리 학습 시간 — O(n log n) 비례.</sub>

**개념 3.** 결정 트리 학습의 시간 복잡도는 단순 구현은 ____________________ 이지만, sklearn은 ____________________ 알고리즘을 사용해 ____________________ 로 줄였다.

<details><summary>▶ 정답 보기</summary>

O(d · n²) / 정렬 기반 / O(d · n log n)

여기서 d는 변수 수, n은 샘플 수다. 변수에 대해 한 번 정렬한 뒤 **임계값을 차례로 옮기면서 누적 합을 업데이트**하는 방식이다.

</details>

**개념 4.** Ames 분할 후보 임계값의 개수는?

연속형 변수 한 개에 대해 후보는 ____________________ 개. (n개 샘플의 정렬된 값들의 **중간점**)

변수 d개 전체에 대해 총 ____________________ 개 분할 후보.

<details><summary>▶ 정답 보기</summary>

n - 1 / d · (n - 1)

</details>

**그림 해석.** 그림 1-1에서 n을 100배 늘렸을 때 실제 학습 시간 증가는 약 ____________________ 배다.

이론적으로 O(n log n)에서 예측되는 값(약 200배)보다 **작은 이유**는 ____________________ 와 ____________________ 때문이다.

<details><summary>▶ 정답 보기</summary>

76 / vectorized 연산 효율 / 작은 데이터의 오버헤드

</details>

**코드 빈칸.** 트리 학습 시간 측정.

```python
import time
from sklearn.tree import DecisionTreeRegressor
from sklearn.datasets import make_regression

for n in [100, 500, 1000, 5000, 10000]:
    X, y = make_regression(n_samples=n, n_features=10, random_state=42)
    t0 = time.time()
    tree = DecisionTreeRegressor(random_state=42)
    tree.____(X, y)
    dt = (time.time() - t0) * 1000
    print(f"n={n}: {dt:.2f} ms")
```

<details><summary>▶ 정답 보기</summary>

```python
tree.fit(X, y)
```

</details>

---

## 2장 비용 복잡도 가지치기 — ccp_alpha

![03 ccp alpha path](figs/03_ccp_alpha_path.png)

<sub>그림 2-1. ccp_alpha 경로의 효과.</sub>

**개념 5.** 사전 가지치기와 사후 가지치기의 차이:

| 구분 | 사전 가지치기 | 사후 가지치기 |
|---|---|---|
| 시점 | ____________________ | ____________________ |
| 매개변수 | max_depth, min_samples_leaf | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 구분 | 사전 | 사후 |
|---|---|---|
| 시점 | **학습 중** | **학습 후** |
| 매개변수 | max_depth, min_samples_leaf | **ccp_alpha** |

두 방법은 **함께 쓸 수 있다**. 실무에서는 **어느 정도 사전 가지치기 후 사후 가지치기**가 표준 흐름이다.

</details>

**개념 6.** 비용 복잡도의 정의: 

$$R_\alpha(T) = R(T) + \alpha |T|$$

여기서

- $R(T)$: 트리의 ____________________
- $|T|$: 트리의 ____________________
- $\alpha$: ____________________

$\alpha$가 클수록 ____________________ 트리가 선호된다.

<details><summary>▶ 정답 보기</summary>

총 불순도 (잎의 분산 합) / 잎 수 / 복잡도 페널티 계수 / 작은(small)

</details>

**그림 해석.** 그림 2-1에서:

(왼쪽 패널) 알파가 작을 때 학습 R²는 약 ____________________, 검증 R²는 약 0.80. 최적 알파 ≈ ____________________ 에서 검증 R²가 정점.

(오른쪽 패널) 무가지치기에서 잎 수 약 ____________________, 알파 0.0002에서 약 ____________________ 개로 줄어든다.

<details><summary>▶ 정답 보기</summary>

1.0 (과적합) / 0.0002 / 1988 / 100

</details>

**개념 7.** Ames에서 `ccp_alpha=0.0001`을 적용했을 때:

- 무가지치기 트리: 잎 ____________________ 개, 깊이 25, test R² 0.78
- α=0.0001 적용: 잎 ____________________ 개, 깊이 10, test R² ____________________

<details><summary>▶ 정답 보기</summary>

1988 / 89 / 0.83

</details>

**코드 빈칸.** 알파 경로 얻기와 최적 알파 적용.

```python
from sklearn.tree import DecisionTreeRegressor

# 알파 경로 얻기
tree = DecisionTreeRegressor(random_state=42)
tree.fit(X_tr, y_tr)
path = tree.____(X_tr, y_tr)
print(f"알파 경로: {len(path.ccp_alphas)}개")

# 추천 알파로 학습
tree_pruned = DecisionTreeRegressor(____=0.0001, random_state=42)
tree_pruned.fit(X_ames, y_ames)
print(f"잎 수: {tree_pruned.____}")
```

<details><summary>▶ 정답 보기</summary>

```python
path = tree.cost_complexity_pruning_path(X_tr, y_tr)
ccp_alpha=0.0001
tree_pruned.get_n_leaves()
```

</details>

---

## 3장 매개변수 미세 조정

![04 hyperparameters](figs/04_hyperparameters.png)

<sub>그림 3-1. 네 매개변수의 효과.</sub>

**개념 8.** 사전 가지치기 매개변수 4종과 각각의 의미:

| 매개변수 | 의미 |
|---|---|
| `max_depth` | ____________________ |
| `min_samples_split` | ____________________ |
| `min_samples_leaf` | ____________________ |
| `min_impurity_decrease` | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 매개변수 | 의미 |
|---|---|
| `max_depth` | **트리의 최대 깊이** |
| `min_samples_split` | **분할 가능한 노드의 최소 샘플 수** |
| `min_samples_leaf` | **각 잎이 가져야 할 최소 샘플 수** |
| `min_impurity_decrease` | **분할이 얻는 최소 불순도 감소** |


</details>

**그림 해석.** Ames에서 각 매개변수의 최적값과 그 R²는?

| 매개변수 | 최적값 | 최적 R² |
|---|---|---|
| max_depth | ____________________ | 약 0.80 |
| min_samples_leaf | ____________________ | 약 ____________________ |
| min_samples_split | ____________________ | 약 0.80 |
| min_impurity_decrease | ____________________ | 약 0.80 |


<details><summary>▶ 정답 보기</summary>

| 매개변수 | 최적값 | 최적 R² |
|---|---|---|
| max_depth | **5~7** | 0.80 |
| min_samples_leaf | **10** | **0.82** |
| min_samples_split | **20** | 0.80 |
| min_impurity_decrease | **1e-4** | 0.80 |


</details>

**개념 9.** `min_samples_leaf`가 너무 작으면(예: 1) 어떤 문제가 생기는가? 너무 크면(예: 100) 어떤 문제가 생기는가?

<details><summary>▶ 정답 보기</summary>

너무 작음(1): 잎 하나에 **한 샘플만 있는** 극단적 과적합

너무 큼(100): **세밀한 패턴을 잡지 못함**

</details>

**코드 빈칸.** GridSearchCV로 매개변수 조합 탐색.

```python
from sklearn.model_selection import ____________________
from sklearn.tree import DecisionTreeRegressor

param_grid = {
    "max_depth": [5, 7, 10],
    "min_samples_leaf": [5, 10, 20],
    "ccp_alpha": [0, 1e-5, 1e-4]
}

grid = GridSearchCV(
    DecisionTreeRegressor(random_state=42),
    param_grid,
    cv=____,
    scoring="r2",
    n_jobs=-1
)
grid.fit(X_ames, y_ames)
print(f"최적 매개변수: {grid.____________________}")
print(f"최적 CV R²:    {grid.____________________:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.model_selection import GridSearchCV
cv=5
grid.best_params_
grid.best_score_
```

</details>

---

## 4장 단조성 제약

![05 monotonic constraint](figs/05_monotonic_constraint.png)

<sub>그림 4-1. 단조성 제약의 효과 — 잡음을 따라가는 비단조 구간이 사라진다.</sub>

**개념 1.** 도메인 지식에서 **자연스러운 단조 관계** 예시 4가지:

| 도메인 | 변수 | 단조 방향 |
|---|---|---|
| 부동산 | 면적 → 가격 | ____________________ |
| 부동산 | 나이 → 가격 | ____________________ |
| 의료 | 콜레스테롤 → 심장병 위험 | ____________________ |
| 보험 | 운전 경력 → 사고율 | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 도메인 | 단조 방향 |
|---|---|
| 면적 → 가격 | **증가** |
| 나이 → 가격 | **감소** (오래된 집은 보통 싸다) |
| 콜레스테롤 → 심장병 위험 | **증가** |
| 운전 경력 → 사고율 | **감소** |


</details>

**개념 2.** sklearn의 `monotonic_cst` 매개변수에서 값의 의미:

| 값 | 의미 |
|---|---|
| `0` | ____________________ |
| `1` | ____________________ |
| `-1` | ____________________ |

`monotonic_cst`는 **변수 개수와 같은 길이의 리스트**다.

<details><summary>▶ 정답 보기</summary>

| 값 | 의미 |
|---|---|
| `0` | **제약 없음** |
| `1` | **단조 증가** (변수↑ → 예측↑) |
| `-1` | **단조 감소** (변수↑ → 예측↓) |


</details>

**그림 해석.** 그림 4-1의 두 트리 비교:

(왼쪽 제약 없는 트리) 잡음을 따라가다 **____________________ 구간**이 생긴다. 빨간 띠로 표시된 부분이다.

(오른쪽 단조 제약 트리) 계단형이지만 **____________________ 만 허용**한다.

두 트리 모두 참값(녹색)에 **근접**하지만, 단조 제약 트리는 **해석 가능성**에서 우위다.

<details><summary>▶ 정답 보기</summary>

비단조(감소) / 단조 증가

</details>

**개념 3.** Ames에서 `Overall Qual`에 단조 증가 제약을 부과했을 때 R²:

| 제약 | R² |
|---|---|
| 없음 | ____________________ |
| Overall Qual 단조 증가 | ____________________ |

흥미롭게도 이 경우 **제약이 R²를 약간 올렸다**. 이는 **제약이 잡음을 따라가는 과적합을 방어**했기 때문이다.

<details><summary>▶ 정답 보기</summary>

0.7956 / 0.8085

</details>

**개념 4.** 단조 제약의 **진짜 가치**는 R² 향상이 아니라 다음 4가지다:

(1) ____________________ — "품질이 올라가면 가격은 항상 같거나 오른다"
(2) ____________________ — 의료·금융처럼 예측 방향 보장 필수
(3) ____________________ 안정성 — 학습 데이터 밖 극단값에서도 합리적
(4) ____________________ 준수 — GDPR 등 알고리즘 설명 의무

<details><summary>▶ 정답 보기</summary>

(1) 해석 가능성
(2) 의사 결정 신뢰성
(3) 외삽(extrapolation)
(4) 규제(regulation)

</details>

**코드 빈칸.** Ames에서 여러 변수에 단조 제약 부과.

```python
cols = X_ames.columns.tolist()
constraints = [____] * len(cols)

# Overall Qual 증가
constraints[cols.index("Overall Qual")] = ____
# Total SF 증가
constraints[cols.index("Total SF")] = ____
# Year Built 증가 (새 집일수록 비쌈)
constraints[cols.index("Year Built")] = ____

tree = DecisionTreeRegressor(max_depth=8,
                              ____________________=constraints,
                              random_state=42)
tree.fit(X_ames, y_ames)
```

<details><summary>▶ 정답 보기</summary>

```python
constraints = [0] * len(cols)
constraints[cols.index("Overall Qual")] = 1
constraints[cols.index("Total SF")] = 1
constraints[cols.index("Year Built")] = 1
tree = DecisionTreeRegressor(max_depth=8, monotonic_cst=constraints, random_state=42)
```

</details>

---

## 5장 다중 출력 트리

![06 multi output](figs/06_multi_output.png)

<sub>그림 5-1. 다중 출력 트리 — 한 트리가 여러 타깃 동시 예측.</sub>

**개념 5.** 다중 출력 회귀의 예시 4가지:

| 도메인 | 입력 | 다중 출력 |
|---|---|---|
| 부동산 | 주택 속성 | ____________________ |
| 의료 | 환자 정보 | ____________________ |
| 화학 | 화합물 구조 | ____________________ |
| 영상 | 픽셀 | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 도메인 | 다중 출력 |
|---|---|
| 부동산 | **(가격, 판매까지 걸린 일수)** |
| 의료 | **(혈압 수축기, 혈압 이완기)** |
| 화학 | **(끓는점, 어는점, 용해도)** |
| 영상 | **(R, G, B)** — 컬러 예측 |


</details>

**개념 6.** 다중 출력 트리에서 **분할 기준**은? 단일 출력의 분산 최소화를 어떻게 일반화하나?

답: 모든 타깃의 분산의 ____________________ 을 최소화하는 분할을 찾는다.

식: $\text{분할 비용}(s) = \sum_{j=1}^K [\frac{n_L}{n}\sigma^2_{L,j} + \frac{n_R}{n}\sigma^2_{R,j}]$

각 잎에는 ____________________ 개의 평균이 저장된다.

<details><summary>▶ 정답 보기</summary>

합(sum) / K (타깃 개수)

</details>

**개념 7.** 다중 출력 트리가 **언제 이득**인가? **언제 손해**인가?

- 이득: 타깃들이 ____________________ 를 공유할 때 (한 트리가 동시에 잘 학습)
- 손해: 타깃들이 ____________________ 일 때 (한 분할이 두 타깃 사이의 절충이 됨)

<details><summary>▶ 정답 보기</summary>

공통 구조(common structure) / 무관(independent)

</details>

**코드 빈칸.** sklearn에서 다중 출력 트리.

```python
import numpy as np
from sklearn.tree import DecisionTreeRegressor

# 두 타깃을 한 배열로
y_multi = np.column_stack([y_single, y_single * 2 + noise])
print(f"y_multi shape: {y_multi.____}")    # (n, 2)

# 학습 — 별다른 설정 없이
tree = DecisionTreeRegressor(max_depth=5, random_state=42)
tree.____(X, y_multi)

# 예측도 자동으로 2D
pred = tree.____(X)
print(f"pred shape: {pred.____}")    # (n, 2)
```

<details><summary>▶ 정답 보기</summary>

```python
y_multi.shape
tree.fit(X, y_multi)
tree.predict(X)
pred.shape
```

별다른 매개변수 변경 없이 **한 트리가 두 타깃을 동시에 예측**한다.

</details>

---

## 6장 범주형 변수의 트리 분할

![07 categorical handling](figs/07_categorical_handling.png)

<sub>그림 6-1. 범주형 처리의 세 가지 방법.</sub>

**개념 8.** 트리에서 범주형 처리의 **세 가지 방법**과 각각의 단점:

| 방법 | 단점 |
|---|---|
| 라벨 인코딩 | ____________________ |
| 원-핫 인코딩 | ____________________ |
| 네이티브 처리 (HistGB) | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 방법 | 단점 |
|---|---|
| 라벨 인코딩 | **순서 가정** — `mfr <= 1.5` 같은 의미 없는 분할 발생 |
| 원-핫 인코딩 | **차원 증가** — K가 크면 K개 새 컬럼, 학습 시간↑ |
| 네이티브 처리 | sklearn 1.4+ 필요, **소형 데이터에서는 원-핫이 더 좋을 수도** |


</details>

**개념 9.** sklearn 1.4+ 에서 `HistGradientBoostingRegressor`의 네이티브 범주형 처리 옵션:

```python
hgb = HistGradientBoostingRegressor(
    categorical_features="____________________",   # category 타입 자동 인식
    random_state=42
)
```

이를 위해 **입력 데이터**에서 범주형 컬럼을 ____________________ 타입으로 미리 변환해 둬야 한다.

<details><summary>▶ 정답 보기</summary>

from_dtype / category

`X["mfr"] = X["mfr"].astype("category")` 로 변환한 뒤 `categorical_features="from_dtype"`를 설정하면 자동으로 인식된다.

</details>

**개념 10.** Cereals(작은 데이터)에서 세 방법의 R² 비교:

| 방법 | R² |
|---|---|
| 라벨 + GBM | 약 ____________________ |
| 원-핫 + GBM | 약 ____________________ |
| 네이티브 HistGB | 약 ____________________ |

작은 데이터셋에서는 **원-핫이 가장 잘 작동**하는 경우가 흔하다.

<details><summary>▶ 정답 보기</summary>

0.77 / 0.84 / 0.75

</details>

**개념 11.** 데이터 크기에 따른 **권장 방법**:

| 데이터 크기 | 권장 |
|---|---|
| 소형 (수백 행) | ____________________ |
| 중형 (수천~수만 행) | ____________________ |
| 대형 (수십만 행 이상) | ____________________ |
| 매우 많은 범주 (>100) | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 크기 | 권장 |
|---|---|
| 소형 | **원-핫 + 트리** |
| 중형 | **원-핫 또는 네이티브** |
| 대형 | **네이티브 (CatBoost 등)** |
| 매우 많은 범주 | **CatBoost** (자동 target encoding) |


</details>

---

## 7장 트리 시각화 도구
**개념 1.** 세 가지 시각화 도구의 특징:

| 도구 | 출력 형식 | 장점 | 단점 |
|---|---|---|---|
| `plot_tree` | ____________________ | sklearn 표준 | 큰 트리에서 가독성↓ |
| `export_text` | ____________________ | 검색 가능, 보고서에 적합 | 시각적이지 않음 |
| `dtreeviz` | ____________________ | 분포까지 시각화 | 별도 설치 필요 |


<details><summary>▶ 정답 보기</summary>

| 도구 | 출력 형식 |
|---|---|
| `plot_tree` | **matplotlib 그림** |
| `export_text` | **텍스트 (들여쓰기 형식)** |
| `dtreeviz` | **풍부한 SVG** (각 노드의 분포 시각화 포함) |


</details>

**개념 2.** `plot_tree`에서 각 노드에 표시되는 정보 4가지:

(1) ____________________ (예: `Overall Qual <= 7.5`)
(2) ____________________ (회귀에서는 MSE)
(3) ____________________
(4) ____________________ (회귀에서는 평균)

<details><summary>▶ 정답 보기</summary>

(1) 분할 조건
(2) 불순도
(3) 샘플 수
(4) 예측값

</details>

**코드 빈칸.** plot_tree로 트리 시각화.

```python
from sklearn.tree import DecisionTreeRegressor, ____________________
import matplotlib.pyplot as plt
import koreanize_matplotlib

tree_small = DecisionTreeRegressor(max_depth=____, random_state=42)
tree_small.fit(X_ames, y_ames)

fig, ax = plt.subplots(figsize=(20, 10), dpi=100)
plot_tree(tree_small,
          feature_names=X_ames.____,
          filled=____,        # 색으로 예측값 표시
          rounded=____,        # 둥근 모서리
          fontsize=9,
          ax=ax)
plt.show()
```

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import DecisionTreeRegressor, plot_tree
max_depth=3        # 보기 좋게 작은 트리
feature_names=X_ames.columns
filled=True
rounded=True
```

</details>

**코드 빈칸.** export_text로 텍스트 트리.

```python
from sklearn.tree import ____________________

text_rules = export_text(tree_tiny,
                          feature_names=X_ames.columns.____,
                          max_depth=3)
print(text_rules)
```

출력은 **들여쓰기 트리 구조**. 코드 주석이나 보고서에 **직접 붙여 넣기** 좋다.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import export_text
feature_names=X_ames.columns.tolist()
```

</details>

**개념 3.** 큰 트리(깊이 8 이상)를 다루는 **세 가지 방법**:

(1) `plot_tree(____________________=3, ...)` — 위쪽 일부만 보여줌
(2) 특정 ____________________ 의 예측 경로만 추적
(3) 변수 ____________________ 로 요약 (트리 자체 안 보고 어느 변수가 많이 쓰였는지만)

<details><summary>▶ 정답 보기</summary>

(1) max_depth (시각화 깊이 제한)
(2) 샘플(sample)
(3) 중요도(feature_importances_)

</details>

---

## 8장 단일 트리의 한계와 앙상블로의 다리

![08 single to ensemble](figs/08_single_to_ensemble.png)

<sub>그림 8-1. 단일 트리에서 앙상블로.</sub>

**개념 4.** Ames에서 모델별 CV R²:

| 모델 | R² |
|---|---|
| 단일 트리 (튜닝 안 함) | ____________________ |
| 단일 트리 (튜닝, max_depth+ccp_alpha 등) | ____________________ |
| 랜덤 포레스트 | ____________________ |
| GBM | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 모델 | R² |
|---|---|
| 단일 트리 (기본) | **0.77** |
| 단일 트리 (튜닝) | **0.83** ← 2부의 성과 |
| 랜덤 포레스트 | **0.88** ← 3부 |
| GBM | **0.89** ← 5부 |


</details>

**개념 5.** 단일 트리의 **본질적 한계 두 가지**:

(1) ____________________ 가 크다 — 학습 데이터에 매우 민감, 약간만 달라도 완전히 다른 트리
(2) ____________________ 가 크다 — 축에 평행한 분할만 가능, 부드러운 함수를 계단형으로 근사

3부의 ____________________ 가 (1)을 해결, 5부의 ____________________ 가 (2)를 해결한다.

<details><summary>▶ 정답 보기</summary>

(1) 분산(variance)
(2) 편향(bias)
(3) 랜덤 포레스트
(4) GBM (부스팅)

</details>

**개념 6.** 본 부의 매개변수가 **앙상블에도 적용**되는 표:

| 매개변수 | 단일 트리 | RF | GBM | XGBoost |
|---|---|---|---|---|
| `max_depth` | ✓ | ✓ | ✓ | ✓ |
| `min_samples_leaf` | ✓ | ____________________ | ____________________ | ____________________ |
| `ccp_alpha` | ✓ | ____________________ | ____________________ (다른 방식) | ____________________ (다른 방식) |
| `monotonic_cst` | ✓ | ____________________ | ____________________ | ✓ (`monotone_constraints`) |


<details><summary>▶ 정답 보기</summary>

| 매개변수 | RF | GBM | XGBoost |
|---|---|---|---|
| `min_samples_leaf` | ✓ | ✓ | ✓ |
| `ccp_alpha` | ✓ | ✗ (gamma 매개변수 사용) | ✗ (gamma 매개변수 사용) |
| `monotonic_cst` | ✗ | ✗ | ✓ |

본 장의 매개변수 직관이 **모든 트리 기반 모델**에 적용된다.

</details>

---

## 응용 문제 — 직접 풀어 보기

각 문제의 코드를 실행하여 결과를 확인한 뒤 정답 토글로 비교하자.

**문제 1.** Ames에서 `ccp_alpha=0`, `ccp_alpha=0.0001`, `ccp_alpha=0.001` 세 가지 단일 트리를 학습하고 잎 수, 깊이, test R²를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score

X_tr, X_te, y_tr, y_te = train_test_split(X_ames, y_ames, test_size=0.3, random_state=42)

print(f"{'alpha':>10s}  {'leaves':>8s}  {'depth':>6s}  {'R²':>8s}")
print("-" * 38)
for a in [0, 0.0001, 0.001]:
    t = DecisionTreeRegressor(ccp_alpha=a, random_state=42)
    t.fit(X_tr, y_tr)
    r2 = r2_score(y_te, t.predict(X_te))
    print(f"{a:>10.4f}  {t.get_n_leaves():>8d}  {t.get_depth():>6d}  {r2:>8.4f}")
```

전형적 결과:
- alpha=0:      leaves=1988, depth=25, R²=0.78
- alpha=0.0001: leaves=89,   depth=10, R²=0.83
- alpha=0.001:  leaves=15,   depth=5,  R²=0.80

</details>

**문제 2.** Ames에서 `Overall Qual`에 **단조 증가 제약**을 부과한 트리와 **제약 없는 트리**의 CV R²를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score

cols = X_ames.columns.tolist()
qual_idx = cols.index("Overall Qual")
constraints = [0] * len(cols)
constraints[qual_idx] = 1

tree_free = DecisionTreeRegressor(max_depth=8, random_state=42)
tree_mono = DecisionTreeRegressor(max_depth=8, monotonic_cst=constraints, random_state=42)

r2_free = cross_val_score(tree_free, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
r2_mono = cross_val_score(tree_mono, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()

print(f"제약 없음:     {r2_free:.4f}")
print(f"Qual 단조 ↑:  {r2_mono:.4f}")
```

전형적 결과: 0.7956 vs 0.8085. **제약이 약간의 R² 향상도 가져왔다** (잡음 따라가는 과적합 방어 효과).

</details>

**문제 3.** Cereals에 (1) 라벨 인코딩, (2) 원-핫 인코딩, (3) 네이티브 범주형 세 방법으로 모델을 학습하고 CV R²를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
import pandas as pd, numpy as np
from sklearn.ensemble import GradientBoostingRegressor, HistGradientBoostingRegressor
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import cross_val_score

df = cereal.copy()
num = df.select_dtypes("number").columns
df[num] = df[num].fillna(df[num].median())

# (1) 라벨
df_le = df.copy()
for c in ["mfr", "type"]:
    df_le[c] = LabelEncoder().fit_transform(df_le[c])
X_le = df_le.drop(columns=["name", "rating"])

# (2) 원-핫
X_oh = pd.get_dummies(df.drop(columns=["name", "rating"]),
                       columns=["mfr", "type"], drop_first=True)

# (3) 네이티브
df_cat = df.drop(columns=["name"]).copy()
df_cat["mfr"] = df_cat["mfr"].astype("category")
df_cat["type"] = df_cat["type"].astype("category")
X_cat = df_cat.drop(columns=["rating"])

y = df["rating"]

for name, X, model in [
    ("라벨+GBM",    X_le, GradientBoostingRegressor(random_state=42)),
    ("원-핫+GBM",   X_oh, GradientBoostingRegressor(random_state=42)),
    ("네이티브 HGB", X_cat, HistGradientBoostingRegressor(categorical_features="from_dtype", random_state=42, max_iter=100)),
]:
    r2 = cross_val_score(model, X, y, cv=5, scoring="r2").mean()
    print(f"{name:<15s}  R² = {r2:.4f}")
```

전형적 결과: 라벨 0.77, 원-핫 0.84, 네이티브 0.75. **작은 데이터에서는 원-핫이 가장 잘 작동**.

</details>

**문제 4.** 다중 출력 트리로 **Ames에서 SalePrice와 Total SF**를 동시에 예측해 보라. (Total SF는 1부에서 만든 새 변수)

<details><summary>▶ 정답 보기</summary>

```python
import numpy as np
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score

# 두 타깃: log(SalePrice)와 log(Total SF)
y_multi = np.column_stack([
    np.log1p(ames["SalePrice"]),
    np.log1p(ames["Total SF"])
])

# 입력에서 두 타깃 제외
X = X_ames.drop(columns=["Total SF"])

X_tr, X_te, y_tr, y_te = train_test_split(X, y_multi, test_size=0.3, random_state=42)

tree = DecisionTreeRegressor(max_depth=7, random_state=42)
tree.fit(X_tr, y_tr)
pred = tree.predict(X_te)

print(f"y1 (SalePrice) R²: {r2_score(y_te[:,0], pred[:,0]):.4f}")
print(f"y2 (Total SF)  R²: {r2_score(y_te[:,1], pred[:,1]):.4f}")
```

전형적 결과: y1 약 0.79, y2 약 0.99 (Total SF는 입력 변수에서 거의 직접 추정 가능). **한 트리가 두 타깃을 동시에 잘 학습**한다.

</details>

**문제 5.** plot_tree로 **깊이 3** 트리를 시각화하고 그림에서 **루트 노드의 분할 변수와 임계값**을 읽어 보라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import DecisionTreeRegressor, plot_tree
import matplotlib.pyplot as plt
import koreanize_matplotlib

tree = DecisionTreeRegressor(max_depth=3, random_state=42)
tree.fit(X_ames, y_ames)

fig, ax = plt.subplots(figsize=(20, 10), dpi=100)
plot_tree(tree,
          feature_names=X_ames.columns,
          filled=True, rounded=True,
          fontsize=10, ax=ax)
plt.tight_layout()
plt.show()

# 루트 노드 정보 확인
print(f"루트 분할 변수: {X_ames.columns[tree.tree_.feature[0]]}")
print(f"루트 임계값:   {tree.tree_.threshold[0]:.2f}")
```

전형적 결과: 루트 분할 변수는 **Overall Qual** 또는 **Total SF**. 두 변수가 **가격에 대한 가장 강한 신호**이기 때문이다.

</details>

---

## 다음 부 예고 — 4부 AdaBoost

본 2부에서 **단일 트리의 한계가 R² 0.83**임을 봤다. 다음 4부는 **앙상블** 의 첫 번째 종류 — **AdaBoost**다.

미리 던지는 질문 — **AdaBoost는 단일 트리보다 얼마나 더 좋을까**? 그리고 **왜 캘리포니아 데이터에서는 AdaBoost가 처참하게 실패할까**?

<details><summary>▶ 정답 보기</summary>

AdaBoost는 Ames에서 약 **R² 0.81** — **튜닝한 단일 트리(0.83)와 비슷하거나 약간 낮다**. 의외다.

캘리포니아 데이터에서는 AdaBoost가 **R² 0.23**으로 처참하게 실패. **capped 값 \$500,001**이라는 **이상치**가 AdaBoost의 **지수 손실**에서 **무한 폭증**을 일으키기 때문이다.

이 **부스팅의 본질**과 **손실함수의 영향**이 5부 GBM의 출발점이다.

</details>
