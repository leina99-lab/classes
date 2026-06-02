# 2부 학생 워크북 — 결정 트리 심화

## 쉬운 버전 — 그림으로 채우기

이 워크북은 이론 교재 `part2_tree_advanced_EASY_이론.md`를 함께 읽으면서 채우는 자가학습 자료이다. 수식 없이 그림과 직관 중심으로 구성되어 있다.

본 워크북은 **3부 학생 워크북을 먼저 마친 후** 진행하기를 권한다. 3부 0장의 트리 기초 내용이 본 워크북의 출발점이다.

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 0장 왜 트리 심화가 필요한가

![01 basic vs advanced](figs/01_basic_vs_advanced.png)

<sub>그림 0-1. 3부 트리 기초와 2부 트리 심화의 차이.</sub>

**개념 1.** 본 시리즈의 권장 학습 순서는?

1부 → ____________________ → ____________________ → 4부 (AdaBoost) → 5부 (GBM) → 6부 → 7부

부 번호 순서와 일치하지 않는 이유 — **트리 기초**가 **3부 랜덤 포레스트의 토대**이기 때문에 ____________________ 에 자연스럽게 포함되기 때문이다.

<details><summary>▶ 정답 보기</summary>

3부 (트리 기초 + RF) / 2부 (트리 심화) / 3부 0장

</details>

**개념 2.** 2부의 핵심 메시지 두 가지:

(1) 단일 트리도 잘 다듬으면 R² ____________________ 까지 도달 (3부 기본 0.77에서 끌어올림)
(2) 본 부의 매개변수는 ____________________ 에도 그대로 적용된다 (RF, GBM, XGBoost 등)

<details><summary>▶ 정답 보기</summary>

0.83 / 앙상블 모델

</details>

---

## 1장 분할 알고리즘의 복잡도

![02 split complexity](figs/02_split_complexity.png)

<sub>그림 1-1. 결정 트리 학습 시간 — O(n log n) 비례.</sub>

**개념 3.** sklearn 결정 트리의 학습 시간 복잡도는 ____________________ 다. (단순 구현은 O(d·n²)였지만 **정렬 기반 알고리즘**으로 줄임)

여기서 d는 ____________________, n은 ____________________ 이다.

<details><summary>▶ 정답 보기</summary>

O(d · n log n) / 변수 수 / 샘플 수

</details>

**그림 해석.** 그림 1-1에서 n을 100배 (100 → 10,000) 늘렸을 때 실제 학습 시간 증가는 약 ____________________ 배다.

만약 O(n²)이라면 ____________________ 배가 나와야 하므로, 실측이 **O(n log n)에 매우 가까운 결과**다.

<details><summary>▶ 정답 보기</summary>

76 / 10,000

</details>

**개념 4.** sklearn 트리 학습이 **실용적인 속도**인 이유 세 가지:

(1) ____________________ 으로 작성된 C 코드 호출
(2) 정렬 순서 ____________________
(3) `n_jobs=-1`로 ____________________ 가능

<details><summary>▶ 정답 보기</summary>

(1) Cython
(2) 캐싱 (메모리 재사용)
(3) 변수 평가 병렬화

</details>

---

## 2장 비용 복잡도 가지치기

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
| 매개변수 | max_depth 등 | **ccp_alpha** |

두 방법은 **함께 쓸 수 있다**.

</details>

**개념 6.** `ccp_alpha`가 조절하는 것은 **복잡도 페널티**다. 직관:

> **전체 비용 = 트리의 불순도 + α × 잎 수**

- α = 0 이면 ____________________ 트리가 최적
- α 가 크면 ____________________ 트리가 선호됨
- α 가 매우 크면 ____________________ 만 남음

<details><summary>▶ 정답 보기</summary>

완전히 자란 / 작은 / 루트 한 그루

</details>

**그림 해석.** 그림 2-1에서:

(왼쪽) 알파가 작을 때 학습 R²는 약 ____________________ (과적합 사인), 검증 R²는 약 0.80. 최적 알파 ≈ ____________________ 에서 검증 R²가 정점.

(오른쪽) 무가지치기 잎 수 약 ____________________, 알파 0.0002에서 약 100개로 감소.

<details><summary>▶ 정답 보기</summary>

1.0 / 0.0002 / 1988

</details>

**개념 7.** Ames에서 ccp_alpha 효과:

| ccp_alpha | 잎 수 | 깊이 | test R² |
|---|---|---|---|
| 0 (무가지치기) | 1988 | 25 | ____________________ |
| **0.0001 (최적)** | **89** | **10** | ____________________ |
| 0.001 | 15 | 5 | 0.80 |
| 0.01 | 4 | 2 | 0.68 |


<details><summary>▶ 정답 보기</summary>

| ccp_alpha | test R² |
|---|---|
| 0 | **0.78** |
| **0.0001** | **0.83** ← 최적 |


</details>

**코드 빈칸.** sklearn에서 ccp_alpha 적용.

```python
from sklearn.tree import DecisionTreeRegressor

tree_pruned = DecisionTreeRegressor(____________________=0.0001, random_state=42)
tree_pruned.fit(X_ames, y_ames)

print(f"잎 수: {tree_pruned.____________________}")
print(f"깊이:  {tree_pruned.____________________}")
```

<details><summary>▶ 정답 보기</summary>

```python
ccp_alpha=0.0001
tree_pruned.get_n_leaves()
tree_pruned.get_depth()
```

</details>

---

## 3장 매개변수 미세 조정

![04 hyperparameters](figs/04_hyperparameters.png)

<sub>그림 3-1. 네 매개변수의 효과.</sub>

**개념 8.** 사전 가지치기 매개변수 4종:

| 매개변수 | 의미 |
|---|---|
| `max_depth` | ____________________ |
| `min_samples_leaf` | ____________________ |
| `min_samples_split` | ____________________ |
| `min_impurity_decrease` | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 매개변수 | 의미 |
|---|---|
| `max_depth` | **트리의 최대 깊이** |
| `min_samples_leaf` | **각 잎이 가져야 할 최소 샘플 수** |
| `min_samples_split` | **분할 가능한 노드의 최소 샘플 수** |
| `min_impurity_decrease` | **분할이 얻어야 할 최소 불순도 감소** |


</details>

**그림 해석.** Ames에서 각 매개변수의 최적값:

| 매개변수 | 최적값 |
|---|---|
| max_depth | ____________________ |
| min_samples_leaf | ____________________ |
| min_samples_split | ____________________ |
| min_impurity_decrease | ____________________ |

네 매개변수 모두 **극단으로 가면 성능이 떨어진다**.

<details><summary>▶ 정답 보기</summary>

| 매개변수 | 최적값 |
|---|---|
| max_depth | **5~7** |
| min_samples_leaf | **10** (가장 강력!) |
| min_samples_split | **20** |
| min_impurity_decrease | **1e-4** |


</details>

**개념 9.** `min_samples_leaf`가 너무 작으면(예: 1)? 너무 크면(예: 100)?

- 너무 작음(1): ____________________
- 너무 큼(100): ____________________

<details><summary>▶ 정답 보기</summary>

- 너무 작음: **잎 하나에 한 샘플만** (극단 과적합)
- 너무 큼: **세밀한 패턴 못 잡음**

</details>

**개념 10.** 매개변수 조합 탐색의 표준 도구는 ____________________ 다. 모든 조합을 5-fold CV로 평가하여 **최적 조합**을 자동으로 찾는다.

이 도구의 결과로 단일 트리의 **현실적 상한선**인 R² ____________________ 정도까지 갈 수 있다.

<details><summary>▶ 정답 보기</summary>

GridSearchCV / 0.83

</details>

---

## 4장 단조성 제약

![05 monotonic constraint](figs/05_monotonic_constraint.png)

<sub>그림 4-1. 단조성 제약의 효과 — 비단조 구간이 사라진다.</sub>

**개념 1.** 도메인 지식의 자연스러운 단조 관계 예시 4가지:

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
| 콜레스테롤 → 심장병 | **증가** |
| 운전 경력 → 사고율 | **감소** |


</details>

**그림 해석.** 그림 4-1의 두 트리 비교:

(왼쪽 제약 없는 트리) 잡음을 따라가다 ____________________ 구간이 생긴다 (빨간 띠).

(오른쪽 단조 제약 트리) 계단형이지만 ____________________ 만 허용한다.

단조 제약 트리는 **해석 가능성**에서 우위다.

<details><summary>▶ 정답 보기</summary>

비단조(감소) / 단조 증가

</details>

**개념 2.** sklearn의 `monotonic_cst` 값:

| 값 | 의미 |
|---|---|
| `0` | ____________________ |
| `1` | ____________________ |
| `-1` | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 값 | 의미 |
|---|---|
| `0` | **제약 없음** |
| `1` | **단조 증가** (변수↑ → 예측↑) |
| `-1` | **단조 감소** (변수↑ → 예측↓) |


</details>

**개념 3.** Ames에서 `Overall Qual`에 단조 증가 제약을 부과한 R²:

| 제약 | R² |
|---|---|
| 없음 | ____________________ |
| 단조 증가 | ____________________ |

흥미롭게도 **제약이 R²를 약간 올렸다**. 잡음을 따라가는 과적합 방어 효과.

<details><summary>▶ 정답 보기</summary>

0.7956 / 0.8085

</details>

**개념 4.** 단조 제약의 진짜 가치 4가지 (R² 향상이 아니라):

(1) ____________________ — 명확한 보장
(2) ____________________ — 의료·금융처럼 방향 보장 필수
(3) ____________________ 안정성 — 극단값에서도 합리적
(4) ____________________ 준수 — GDPR 등 알고리즘 설명 의무

<details><summary>▶ 정답 보기</summary>

(1) 해석 가능성
(2) 의사 결정 신뢰성
(3) 외삽
(4) 규제

</details>

**코드 빈칸.** Ames에서 단조 제약 부과.

```python
cols = X_ames.columns.tolist()
constraints = [____] * len(cols)            # 모두 제약 없음
constraints[cols.index("Overall Qual")] = ____    # 단조 증가

tree = DecisionTreeRegressor(max_depth=8,
                              ____________________=constraints,
                              random_state=42)
```

<details><summary>▶ 정답 보기</summary>

```python
constraints = [0] * len(cols)
constraints[cols.index("Overall Qual")] = 1
monotonic_cst=constraints
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
| 부동산 | **(가격, 판매까지 일수)** |
| 의료 | **(수축기 혈압, 이완기 혈압)** |
| 화학 | **(끓는점, 어는점, 용해도)** |
| 영상 | **(R, G, B)** — 컬러 예측 |


</details>

**개념 6.** 다중 출력 트리의 분할 기준은? **단일 출력의 분산 최소화**를 어떻게 일반화하나?

답: 모든 타깃의 분산을 ____________________ 한 값을 최소화한다. 각 잎에는 ____________________ 개의 평균이 저장된다.

<details><summary>▶ 정답 보기</summary>

합산 / K (타깃 개수)

</details>

**개념 7.** 다중 출력 트리가 이득인 경우 vs 손해인 경우:

- 이득: 타깃들이 ____________________ 를 공유할 때 (한 트리가 동시에 잘 학습)
- 손해: 타깃들이 ____________________ 일 때 (한 분할이 두 타깃의 절충이 됨)

<details><summary>▶ 정답 보기</summary>

공통 구조 / 무관(independent)

</details>

**코드 빈칸.** sklearn에서 다중 출력 트리.

```python
import numpy as np
from sklearn.tree import DecisionTreeRegressor

# y를 2D로 (n × K)
y_multi = np.____________________([y_target1, y_target2])

# 학습 — 별다른 설정 없이
tree = DecisionTreeRegressor(max_depth=5, random_state=42)
tree.fit(X, y_multi)

# 예측도 자동으로 2D
pred = tree.predict(X)
print(f"pred shape: {pred.shape}")    # (n, 2)
```

<details><summary>▶ 정답 보기</summary>

```python
y_multi = np.column_stack([y_target1, y_target2])
```

`np.column_stack`이 두 1D 배열을 **2D 배열의 두 열**로 합친다.

</details>

---

## 6장 범주형 변수의 트리 분할

![07 categorical handling](figs/07_categorical_handling.png)

<sub>그림 6-1. 범주형 처리 세 가지 방법.</sub>

**개념 8.** 트리에서 범주형 처리의 세 방법과 각각의 단점:

| 방법 | 단점 |
|---|---|
| 라벨 인코딩 | ____________________ |
| 원-핫 인코딩 | ____________________ |
| 네이티브 처리 | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 방법 | 단점 |
|---|---|
| 라벨 인코딩 | **순서 가정** (`mfr <= 1.5` 같은 의미 없는 분할) |
| 원-핫 인코딩 | **차원 증가** (K가 크면 K개 새 컬럼) |
| 네이티브 처리 | **sklearn 1.4+ 필요**, 소형 데이터에선 원-핫이 더 좋을 수도 |


</details>

**개념 9.** sklearn 1.4+ 에서 `HistGradientBoostingRegressor`의 네이티브 범주형 처리:

```python
hgb = HistGradientBoostingRegressor(
    categorical_features="____________________",
    random_state=42
)
```

입력 데이터의 범주형 컬럼을 ____________________ 타입으로 변환해야 자동 인식된다.

<details><summary>▶ 정답 보기</summary>

from_dtype / category

`X["mfr"] = X["mfr"].astype("category")` 로 변환한 뒤 categorical_features="from_dtype"를 설정.

</details>

**개념 10.** Cereals(작은 데이터)에서 세 방법의 R² 비교:

| 방법 | R² |
|---|---|
| 라벨 + GBM | 약 ____________________ |
| 원-핫 + GBM | 약 ____________________ |
| 네이티브 HistGB | 약 ____________________ |

작은 데이터셋에서는 **원-핫이 가장 잘 작동**하는 경우가 많다.

<details><summary>▶ 정답 보기</summary>

0.77 / 0.84 / 0.75

</details>

**개념 11.** 데이터 크기별 권장 방법:

| 데이터 크기 | 권장 |
|---|---|
| 소형 (수백 행) | ____________________ |
| 중형 (수천 ~ 수만 행) | ____________________ |
| 대형 (수십만 행 이상) | ____________________ |
| 매우 많은 범주 (>100) | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 크기 | 권장 |
|---|---|
| 소형 | **원-핫** |
| 중형 | **원-핫 또는 네이티브** |
| 대형 | **네이티브** |
| 많은 범주 | **CatBoost** (자동 target encoding) |


</details>

---

## 7장 트리 시각화 도구
**개념 1.** 세 가지 시각화 도구 비교:

| 도구 | 출력 형식 | 사용 시점 |
|---|---|---|
| `plot_tree` | ____________________ | 중간 트리 (깊이 3~5) |
| `export_text` | ____________________ | 작은 트리, 코드 안에 넣기 |
| `dtreeviz` | ____________________ | 분포까지 시각화 |


<details><summary>▶ 정답 보기</summary>

| 도구 | 출력 형식 |
|---|---|
| `plot_tree` | **matplotlib 그림** |
| `export_text` | **텍스트 (들여쓰기 형식)** |
| `dtreeviz` | **풍부한 SVG** |


</details>

**개념 2.** `plot_tree`에서 각 노드에 표시되는 정보 4가지:

(1) ____________________ (예: `Overall Qual <= 7.5`)
(2) ____________________ (회귀에서는 MSE)
(3) ____________________
(4) ____________________ (회귀에서는 평균)

색은 **예측값의 크기**. 진한 색일수록 **극단적 예측**이다.

<details><summary>▶ 정답 보기</summary>

(1) 분할 조건
(2) 불순도
(3) 샘플 수
(4) 예측값

</details>

**코드 빈칸.** plot_tree 사용.

```python
from sklearn.tree import DecisionTreeRegressor, ____________________
import matplotlib.pyplot as plt
import koreanize_matplotlib

tree = DecisionTreeRegressor(max_depth=____, random_state=42)  # 보기 좋게 작은 트리
tree.fit(X_ames, y_ames)

fig, ax = plt.subplots(figsize=(20, 10), dpi=100)
plot_tree(tree,
          feature_names=X_ames.____,
          filled=____,         # 색으로 예측값 표시
          rounded=True,
          fontsize=9, ax=ax)
plt.show()
```

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import DecisionTreeRegressor, plot_tree
max_depth=3
feature_names=X_ames.columns
filled=True
```

</details>

**개념 3.** 깊이 8 이상의 큰 트리를 다루는 세 가지 방법:

(1) `plot_tree(max_depth=____)` — 위쪽 일부만 시각화
(2) 특정 ____________________ 의 예측 경로 추적
(3) 변수 ____________________ 로 요약 (트리 자체 안 보고)

<details><summary>▶ 정답 보기</summary>

(1) 3
(2) 샘플
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
| 단일 트리 (전체 튜닝) | ____________________ |
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

**개념 5.** 단일 트리의 본질적 한계 두 가지:

(1) ____________________ 가 크다 — 학습 데이터에 매우 민감, 약간만 달라도 완전히 다른 트리
(2) ____________________ 가 크다 — 축에 평행한 분할만 가능, 부드러운 함수를 계단형으로 근사

각 한계의 해결 모델:

- (1)의 해결 → 3부의 ____________________
- (2)의 해결 → 5부의 ____________________

<details><summary>▶ 정답 보기</summary>

(1) 분산 → 랜덤 포레스트
(2) 편향 → GBM (부스팅)

</details>

**개념 6.** 본 부의 매개변수가 앙상블에서도 작동하는 표:

| 매개변수 | 단일 트리 | RF | GBM | XGBoost |
|---|---|---|---|---|
| `max_depth` | ✓ | ✓ | ✓ | ✓ |
| `min_samples_leaf` | ✓ | ____________________ | ____________________ | ____________________ |
| `monotonic_cst` | ✓ | ✗ | ✗ | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 매개변수 | RF | GBM | XGBoost |
|---|---|---|---|
| `min_samples_leaf` | ✓ | ✓ | ✓ |
| `monotonic_cst` | ✗ | ✗ | ✓ (`monotone_constraints`) |


</details>

---

## 응용 문제 — 직접 풀어 보기

**문제 1.** Ames에서 `ccp_alpha=0`, `ccp_alpha=0.0001`, `ccp_alpha=0.001` 세 가지 단일 트리의 잎 수와 R²를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score

X_tr, X_te, y_tr, y_te = train_test_split(X_ames, y_ames, test_size=0.3, random_state=42)

for a in [0, 0.0001, 0.001]:
    t = DecisionTreeRegressor(ccp_alpha=a, random_state=42)
    t.fit(X_tr, y_tr)
    r2 = r2_score(y_te, t.predict(X_te))
    print(f"alpha={a}: leaves={t.get_n_leaves()}, R²={r2:.4f}")
```

전형적 결과:
- alpha=0:      leaves=1988, R²=0.78
- alpha=0.0001: leaves=89,   R²=0.83  ← 최적
- alpha=0.001:  leaves=15,   R²=0.80

</details>

**문제 2.** Ames에서 `Overall Qual`에 **단조 증가 제약**을 부과한 트리와 **제약 없는 트리**의 R²를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score

cols = X_ames.columns.tolist()
constraints = [0] * len(cols)
constraints[cols.index("Overall Qual")] = 1

tree_free = DecisionTreeRegressor(max_depth=8, random_state=42)
tree_mono = DecisionTreeRegressor(max_depth=8, monotonic_cst=constraints, random_state=42)

r2_free = cross_val_score(tree_free, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
r2_mono = cross_val_score(tree_mono, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()

print(f"제약 없음:   {r2_free:.4f}")
print(f"단조 증가:   {r2_mono:.4f}")
```

전형적 결과: 0.7956 vs 0.8085. **제약이 약간 더 좋다**.

</details>

**문제 3.** plot_tree로 깊이 3 트리를 시각화하고 **루트 노드의 분할 변수**를 읽어 보라.

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
plt.show()

# 루트 노드 정보 확인
print(f"루트 분할 변수: {X_ames.columns[tree.tree_.feature[0]]}")
print(f"루트 임계값:   {tree.tree_.threshold[0]:.2f}")
```

전형적 결과: 루트 분할 변수는 **Overall Qual** 또는 **Total SF**. 두 변수가 **가격에 대한 가장 강한 신호**이기 때문이다.

</details>

**문제 4.** 변수 중요도 상위 5개를 출력하라.

<details><summary>▶ 정답 보기</summary>

```python
import pandas as pd

tree = DecisionTreeRegressor(max_depth=10, random_state=42)
tree.fit(X_ames, y_ames)

imp = pd.Series(tree.feature_importances_, index=X_ames.columns)
print(imp.nlargest(5).round(4))
```

전형적 상위: **Total SF**, **Overall Qual**, **Gr Liv Area**, **Year Built**, **Total Bsmt SF**. 도메인 지식과 일치하는 결과.

</details>

---

## 다음 부 예고 — 4부 AdaBoost

본 2부에서 **단일 트리의 한계가 R² 0.83**임을 봤다. 다음 4부는 **앙상블**의 첫 번째 종류 — **AdaBoost**다.

미리 던지는 질문 — **AdaBoost는 단일 트리보다 얼마나 더 좋을까**? 그리고 **왜 캘리포니아 데이터에서는 AdaBoost가 처참하게 실패할까**?

<details><summary>▶ 정답 보기</summary>

AdaBoost는 Ames에서 약 **R² 0.81** — **튜닝한 단일 트리(0.83)와 비슷하거나 약간 낮다**. 의외다.

캘리포니아 데이터에서는 AdaBoost가 **R² 0.23**으로 처참하게 실패. **capped 값 $500,001**이라는 **이상치**가 AdaBoost의 **지수 손실**에서 **무한 폭증**을 일으키기 때문이다.

이 **부스팅의 본질**과 **손실함수의 영향**이 5부 GBM의 출발점이다.

</details>
