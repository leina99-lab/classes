# 2부 결정 트리 심화

## 쉬운 버전 — 그림으로 이해하기

본 자료는 결정 트리의 **심화 주제**를 그림 중심으로 풀어쓴 입문 교재이다. 복잡한 수식이나 알고리즘 없이도 **어떤 매개변수가 어떤 효과를 가지는지** 따라갈 수 있다.

본 자료의 흐름은 **3부 학생 워크북을 먼저 마친 후 본 자료로 돌아오는** 것이다. 시리즈 구조의 특이점이다 — 3부 0장에서 결정 트리의 **기초**를 다루고, 본 2부에서 **심화 주제**를 다룬다.

두 데이터셋을 페어로 사용한다.

| 데이터셋 | 역할 | 특성 |
|---|---|---|
| Ames (2,930 × 82) | 강사 시범 | 회귀, 큰 데이터, 깊은 트리 가능 |
| Cereals (77 × 16) | 학생 실습 | 회귀, 작은 데이터, 매개변수 효과 시각화 적합 |

```python
# 환경 준비 (한 번만 실행)
# !pip install pandas numpy matplotlib scikit-learn koreanize-matplotlib

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import koreanize_matplotlib

URL_AMES   = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/AmesHousing.csv"
URL_CEREAL = "https://raw.githubusercontent.com/leina99-lab/classes/main/AI%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D/data/Cereals.csv"

ames_raw   = pd.read_csv(URL_AMES)
cereal_raw = pd.read_csv(URL_CEREAL)
```

1부의 표준 전처리 함수를 가져와 **깨끗한 데이터** 상태에서 출발한다.

```python
def prepare_ames(df_in):
    df = df_in.copy()
    df = df.drop(columns=[c for c in ["Order", "PID"] if c in df.columns])
    for c in ["Pool QC", "Misc Feature", "Alley", "Fence", "Fireplace Qu",
              "Garage Qual", "Garage Cond", "Bsmt Qual", "Bsmt Cond"]:
        if c in df.columns:
            df[c] = df[c].fillna("None")
    num = df.select_dtypes("number").columns
    df[num] = df[num].fillna(df[num].median())
    df = df[df["Gr Liv Area"] < 4000].copy()
    df["Total SF"] = df["1st Flr SF"] + df["2nd Flr SF"] + df["Total Bsmt SF"]
    return df

ames = prepare_ames(ames_raw)
y_ames = np.log1p(ames["SalePrice"])
X_ames = ames.select_dtypes("number").drop(columns=["SalePrice"])
```

---

## 0장 왜 트리 심화가 필요한가

### 0.1 시리즈 학습 순서의 특이점

본 시리즈의 **권장 학습 순서**는 부 번호 순이 **아니다**.

**1부** (데이터 마이닝) → **3부** (트리 기초 + RF) → **2부** (트리 심화) → **4부** (AdaBoost) → 이후

이유는 단순하다. **트리 기초**는 **3부 랜덤 포레스트의 토대**이므로 3부 0장에 자연스럽게 포함된다. 그러나 **트리 심화 주제**는 **단일 트리에 깊이 들어가는** 내용이라, **별도의 부**로 분리했다.

학생은 3부에서 **기초**를 다지고 **랜덤 포레스트의 위력**을 본 다음, 2부로 돌아와 **왜 단일 트리도 잘 만들면 강한가**를 본다.

![01 basic vs advanced](figs/01_basic_vs_advanced.png)

<sub>그림 0-1. 3부 트리 기초와 2부 트리 심화의 차이. 기초는 *트리가 무엇이며 어떻게 학습되는가*를, 심화는 *학습된 트리를 어떻게 다듬고 활용하는가*를 다룬다.</sub>

### 0.2 2부의 8개 장 한눈에

| 장 | 주제 | 다루는 질문 |
|---|---|---|
| 1장 | 분할 알고리즘의 복잡도 | sklearn의 트리 학습은 얼마나 빠른가? |
| 2장 | 비용 복잡도 가지치기 | `ccp_alpha`로 과적합 트리를 어떻게 자르나? |
| 3장 | 매개변수 미세 조정 | `min_samples_leaf` 등 4종의 효과는? |
| 4장 | 단조성 제약 | 도메인 지식을 트리에 어떻게 부과? |
| 5장 | 다중 출력 트리 | 한 트리로 여러 타깃 동시 예측? |
| 6장 | 범주형 분할 | 라벨 vs 원-핫 vs 네이티브 비교 |
| 7장 | 시각화 도구 | `plot_tree`, `export_text`, `dtreeviz` |
| 8장 | 한계와 앙상블 | 단일 트리는 어디까지 갈 수 있는가? |

### 0.3 본 부의 두 가지 핵심 메시지

**메시지 1**: **단일 트리도 잘 다듬으면 강하다**. 3부 기본 단일 트리 R² 0.77에서, 본 부의 심화 매개변수로 **R² 0.83까지** 끌어올린다.

**메시지 2**: **본 부의 매개변수는 앙상블에도 그대로 작동**. `ccp_alpha`, `min_samples_leaf`, `monotonic_cst` 같은 매개변수는 **RF, GBM, XGBoost** 모두에 적용된다.

---

## 1장 분할 알고리즘의 복잡도

### 1.1 sklearn은 얼마나 빠르게 트리를 학습하는가

3부 0장에서 **분할이 어떻게 선택되는가**를 봤다. **모든 변수와 모든 임계값**을 시도하여 **불순도 감소가 가장 큰 분할**을 찾는다는 것이다. 그러나 **실제로** 모든 임계값을 시도하면 **얼마나 오래 걸릴까**?

연속형 변수 한 개에 대해 **n개 샘플**이 있으면 **분할 후보 임계값**은 **(n-1)개**다. 변수 **d개** 전체에 대해 총 **d × (n-1)**개 후보가 된다.

### 1.2 sklearn의 효율적 알고리즘

sklearn의 결정 트리는 **매우 똑똑한 알고리즘**을 쓴다. 각 변수에 대해 **한 번만 정렬**한 뒤, **임계값을 차례로 옮기면서 누적 합을 업데이트**하는 방식이다.

복잡도는 **O(d · n log n)**이다.

- **n이 100배 늘면** 시간은 약 **200배** (이론값)
- 실측은 **약 76배** — 작은 데이터의 오버헤드 때문에 더 작다

![02 split complexity](figs/02_split_complexity.png)

<sub>그림 1-1. 결정 트리 학습 시간 측정. 실제 측정(남색)이 이론적 O(n log n)(빨강 점선)을 잘 따른다. 비교용 O(n²)(회색 점선)은 훨씬 가파르게 증가한다.</sub>

실측 결과 사례:

| n | 학습 시간 (ms) |
|---|---|
| 100 | 1.5 |
| 1,000 | 7.5 |
| 10,000 | 114.5 |

**n이 100배 늘 때 시간이 약 76배 증가**. **O(n²)이라면 10,000배**가 나와야 하므로, 실측이 **O(n log n)에 매우 가까운 결과**다.

### 1.3 sklearn의 추가 최적화

sklearn의 트리는 **Cython으로 작성된 C 코드**를 호출한다. Python 수준 호출의 오버헤드를 **최소화**하기 위해서다.

또한 다음 최적화가 들어 있다.

- **메모리 캐싱**: 정렬 순서를 재사용
- **희소 행렬 지원**: 원-핫 인코딩된 거대 데이터 효과적 처리
- **병렬화**: `n_jobs=-1`로 변수 평가 병렬화 (RF에서 본격적)

이 덕분에 sklearn의 트리가 **실용적인 속도**로 작동한다.

### 1.4 1장의 한 줄 결론

**sklearn의 결정 트리는 O(d · n log n) 시간에 학습된다.** $n = 10,000$의 트리도 1초 미만에 학습된다. 이게 **왜 트리 기반 앙상블이 실용적인가**의 출발점이다.

---

## 2장 비용 복잡도 가지치기

### 2.1 사전 vs 사후 가지치기

3부에서 **사전 가지치기** — `max_depth`, `min_samples_leaf` 같은 매개변수로 **학습 중에** 트리 성장을 제한 — 를 다뤘다.

본 2장의 주제는 **사후 가지치기**(post-pruning)다. 트리를 **일단 끝까지 키운 뒤**, **불필요한 가지를 잘라내는** 방법이다. sklearn에서는 `ccp_alpha` 매개변수로 구현된다.

| 구분 | 사전 가지치기 | 사후 가지치기 |
|---|---|---|
| 시점 | 학습 중 | 학습 후 |
| 매개변수 | `max_depth` 등 | `ccp_alpha` |
| 장점 | 빠름 | 더 **최적에 가까운** 트리 |
| 단점 | 언제 멈출지 미리 정해야 | 완전히 키운 뒤 잘라야 함 |

두 방법은 **함께 쓸 수 있다**.

### 2.2 알파(α)는 무엇을 조절하는가

`ccp_alpha`는 **복잡도 페널티 계수**다. 식의 직관:

> **전체 비용 = 트리의 불순도 + α × 잎 수**

α가 **0**이면 **잎 수 페널티가 없다** — 완전 자란 트리가 최적. α가 **클수록** **작은 트리**가 페널티를 덜 받아 선호된다. α가 **매우 크면** **루트 한 그루**만 남는 트리가 최적이 된다.

### 2.3 알파에 따른 R² 변화

![03 ccp alpha path](figs/03_ccp_alpha_path.png)

<sub>그림 2-1. ccp_alpha 경로의 효과. (왼쪽) 알파가 작으면 *학습 R²는 1.0에 가까운 과적합*, 검증 R²는 약 0.0002 근처에서 정점. (오른쪽) 잎 수는 알파가 커질수록 *로그적으로 감소*.</sub>

그림 2-1의 두 패턴이 보여 주는 결과:

**왼쪽 패널** — 알파가 작을 때 **학습 R²는 1.0에 가깝다** (트리가 학습 데이터를 **완벽히 외운다**). 그러나 **검증 R²는 약 0.80**에 그친다 (일반화가 약하다). 알파를 키우면 두 R²가 **수렴**하고, **α ≈ 0.0002에서 검증 R²가 정점**에 도달한다.

**오른쪽 패널** — 알파에 따라 잎 수가 **로그적으로 감소**. 무가지치기에서 **약 2,000개 잎**이 있던 트리가, α≈0.0002에서 **약 100개**, α≈0.01에서 **약 5개**로 줄어든다.

### 2.4 sklearn에서 ccp_alpha 사용

```python
from sklearn.tree import DecisionTreeRegressor

# 추천 알파로 학습
tree_pruned = DecisionTreeRegressor(ccp_alpha=0.0001, random_state=42)
tree_pruned.fit(X_ames, y_ames)

print(f"잎 수: {tree_pruned.get_n_leaves()}")
print(f"깊이:  {tree_pruned.get_depth()}")
```

`ccp_alpha=0.0001`을 지정하면 **학습 후 자동으로 가지치기**된다. 무가지치기 트리의 R² 0.78이 가지치기 후 **0.83**까지 오른다.

### 2.5 최적 알파 찾기 — 교차 검증

알파 경로의 어느 점이 **가장 좋은 트리**인가? 답은 **교차 검증으로 측정**해야 한다.

```python
from sklearn.model_selection import cross_val_score
import numpy as np

alphas = np.geomspace(1e-5, 0.05, 10)

for a in alphas:
    t = DecisionTreeRegressor(ccp_alpha=a, random_state=42)
    r2 = cross_val_score(t, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"alpha={a:.5f}: R² = {r2:.4f}")
```

알파 0.0001 근처에서 **R²가 정점**을 찍고, 그 알파의 트리는 **약 100개 잎**을 가진다. 해석 가능하면서 성능도 좋은 트리다.

### 2.6 2장의 한 줄 결론

**`ccp_alpha`는 단일 트리의 성능을 R² 0.78에서 0.83까지 끌어올린다.** 알파 0.0001~0.0005 근처가 Ames에서 **최적 영역**이다.

---

## 3장 매개변수 미세 조정

### 3.1 사전 가지치기 4종의 효과

![04 hyperparameters](figs/04_hyperparameters.png)

<sub>그림 3-1. Ames에서 4종 매개변수의 효과. 모두 *극단으로 가면 성능이 떨어진다*.</sub>

sklearn `DecisionTreeRegressor`의 핵심 매개변수 4종.

| 매개변수 | 의미 | 너무 작으면 | 너무 크면 |
|---|---|---|---|
| `max_depth` | 트리 최대 깊이 | 과소적합 | 과적합 |
| `min_samples_leaf` | 각 잎의 최소 샘플 수 | 잎 하나에 한 샘플만 (극단 과적합) | 세밀한 패턴 못 잡음 |
| `min_samples_split` | 분할 시도 최소 샘플 | 작은 노드 굳이 분할 | 분할 자체 안 됨 |
| `min_impurity_decrease` | 분할 최소 불순도 감소 | 의미 없는 분할 허용 | 유의미한 분할 차단 |

### 3.2 Ames에서 매개변수별 최적값

| 매개변수 | 최적값 | 최적 R² |
|---|---|---|
| max_depth | 5~7 | 0.80 |
| min_samples_leaf | 10 | **0.82** |
| min_samples_split | 20 | 0.80 |
| min_impurity_decrease | 1e-4 | 0.80 |

`min_samples_leaf=10`이 **단일 매개변수만 조정**해도 R² 0.82를 만든다. 이게 **심화 매개변수의 힘**이다.

### 3.3 매개변수 조합 — GridSearchCV

각 매개변수를 **따로** 조정하기보다 **함께** 조정하면 더 좋다. sklearn의 `GridSearchCV`로 **체계적 탐색**이 가능하다.

```python
from sklearn.model_selection import GridSearchCV
from sklearn.tree import DecisionTreeRegressor

param_grid = {
    "max_depth": [5, 7, 10],
    "min_samples_leaf": [5, 10, 20],
    "ccp_alpha": [0, 1e-5, 1e-4]
}

grid = GridSearchCV(DecisionTreeRegressor(random_state=42),
                     param_grid, cv=5, scoring="r2", n_jobs=-1)
grid.fit(X_ames, y_ames)
print(f"최적 매개변수: {grid.best_params_}")
print(f"최적 CV R²:    {grid.best_score_:.4f}")
```

이 조합 탐색으로 **R² 0.83+**까지 도달할 수 있다. 단일 트리의 **현실적 상한선**이다.

### 3.4 3장의 한 줄 결론

**단일 트리도 4종 매개변수를 조합하면 R² 0.83까지 도달한다.** 본 장의 매개변수 직관은 **RF, GBM, XGBoost에도 동일하게** 작동한다.

---

## 4장 단조성 제약

### 4.1 단조성이란

수학에서 **단조 함수**는 **입력이 증가할 때 출력이 항상 증가하거나 항상 감소**하는 함수다. **도메인 지식**에서 **단조성이 자연스러운 변수**가 많다.

| 도메인 | 변수 | 단조 관계 |
|---|---|---|
| 부동산 | 면적 → 가격 | 단조 증가 |
| 부동산 | 품질 → 가격 | 단조 증가 |
| 부동산 | 나이 → 가격 | 단조 감소 (오래된 집은 보통 싸다) |
| 보험 | 운전 경력 → 사고율 | 단조 감소 |
| 의료 | 콜레스테롤 → 심장병 위험 | 단조 증가 |

이런 관계는 **데이터에 잡음이 있어도** 진정한 신호다. 그러나 **일반 트리는 잡음에 끌려가** 잘못된 비단조 분할을 만들기도 한다.

### 4.2 단조성 제약이 필요한 이유

![05 monotonic constraint](figs/05_monotonic_constraint.png)

<sub>그림 4-1. 단조성 제약의 효과. (왼쪽) 제약 없는 트리는 잡음을 따라가다 *비단조 구간*(감소 구간)이 생긴다. (오른쪽) 단조 증가 제약 트리는 *계단형이지만 단조 증가만* 유지한다.</sub>

그림 4-1 왼쪽의 비단조 구간(빨간 영역)이 **왜 문제**인가? 도메인 지식상 **분명한 단조 관계**인데, 데이터의 **잡음**에 끌려가 **작은 역행 구간**을 만든다. 이런 트리를 의사 결정에 쓰면 **잘못된 메시지**를 준다.

단조성 제약은 이런 **역행 구간을 금지**한다. 트리가 **어떤 임계값으로 분할해도 단조 관계를 유지**하도록 강제한다.

### 4.3 sklearn의 monotonic_cst 매개변수

sklearn 1.4+ 에서 다음과 같이 단조 제약을 부과한다.

```python
from sklearn.tree import DecisionTreeRegressor

# 변수 인덱스
cols = X_ames.columns.tolist()
qual_idx = cols.index("Overall Qual")

# 제약 벡터 — 모두 0 (제약 없음)으로 초기화
constraints = [0] * len(cols)
constraints[qual_idx] = 1   # Overall Qual에 단조 증가 제약

tree = DecisionTreeRegressor(max_depth=8,
                              monotonic_cst=constraints,
                              random_state=42)
tree.fit(X_ames, y_ames)
```

`monotonic_cst` 값의 의미:

| 값 | 의미 |
|---|---|
| `0` | 제약 없음 |
| `1` | 단조 증가 (변수↑ → 예측↑) |
| `-1` | 단조 감소 (변수↑ → 예측↓) |

### 4.4 Ames에서 단조 제약의 효과

`Overall Qual → SalePrice`는 **명백한 단조 증가**다. 단조 제약을 부과해 보자.

| 제약 | R² |
|---|---|
| 없음 | 0.7956 |
| Overall Qual 단조 증가 | 0.8085 |

흥미롭게도 **제약이 R²를 약간 올렸다**. 이는 **제약이 잡음을 따라가는 과적합을 방어**했기 때문이다.

### 4.5 단조 제약의 진짜 가치

R² 향상이 아니라 **해석 가능성**과 **신뢰성**에 있다.

| 가치 | 설명 |
|---|---|
| 해석 가능성 | "품질이 올라가면 가격은 항상 같거나 오른다"라는 **명확한 보장** |
| 의사 결정 신뢰성 | 의료·금융처럼 **예측 방향이 보장**되어야 하는 도메인에 필수 |
| 외삽 안정성 | 학습 데이터 밖 **극단값**에서도 비합리적 예측 방지 |
| 규제 준수 | GDPR 등 **알고리즘 설명 의무**가 있는 분야 |

### 4.6 4장의 한 줄 결론

**단조 제약은 R²보다 **해석 가능성**과 **신뢰성**을 위한 도구다.** 도메인 지식이 명확한 단조 관계는 트리에 **직접 부과**하면 좋다.

XGBoost, LightGBM, CatBoost 모두 **비슷한 단조 제약 기능**을 제공한다.

---

## 5장 다중 출력 트리

### 5.1 한 트리로 여러 타깃 동시 예측

지금까지 모든 트리는 **한 타깃 y**를 예측하는 모델이었다. 그러나 실무에서는 **여러 타깃을 동시에 예측**하고 싶을 때가 많다.

| 도메인 | 입력 | 다중 출력 |
|---|---|---|
| 부동산 | 주택 속성 | (가격, 판매까지 일수) |
| 의료 | 환자 정보 | (수축기 혈압, 이완기 혈압) |
| 화학 | 화합물 구조 | (끓는점, 어는점, 용해도) |
| 영상 | 픽셀 | (R, G, B) — 컬러 예측 |

각 타깃을 **따로 학습**할 수도 있지만, **한 트리로 동시에 학습**하는 게 더 효율적이다.

![06 multi output](figs/06_multi_output.png)

<sub>그림 5-1. 다중 출력 트리. 한 입력 X에 대해 트리가 두 타깃 y1, y2를 *동시에 예측*한다. 분할 기준은 두 타깃의 *분산 합*을 최소화하는 방향이다.</sub>

### 5.2 다중 출력 트리의 작동 원리

핵심 아이디어는 **분할 기준의 일반화**다. 단일 출력에서 분할 기준은 **왼쪽·오른쪽 자식의 분산 합 최소화**였다. 다중 출력에서는 **각 타깃의 분산을 모두 합쳐** 최소화한다.

각 잎에는 **K개의 평균**이 저장된다. 예측 시 한 입력에 대해 **K개 수치를 동시에 반환**.

### 5.3 sklearn 사용법

`DecisionTreeRegressor`는 **별다른 설정 없이** 다중 출력을 지원한다. 학습 시 `y`를 **2차원 배열**로 넘기면 된다.

```python
import numpy as np
from sklearn.tree import DecisionTreeRegressor

# y를 2D로
y_multi = np.column_stack([y_target1, y_target2])
print(f"y_multi shape: {y_multi.shape}")    # (n, 2)

# 학습
tree = DecisionTreeRegressor(max_depth=5, random_state=42)
tree.fit(X, y_multi)

# 예측도 자동으로 2D
pred = tree.predict(X)
print(f"pred shape: {pred.shape}")    # (n, 2)
```

별다른 매개변수 변경 없이 **한 트리가 두 타깃을 동시 예측**한다.

### 5.4 언제 이득이고 언제 손해인가

**시나리오 A: 타깃들이 공통 구조를 공유** — 한 트리가 두 타깃을 동시에 잘 학습. **시간·메모리 절약**.

**시나리오 B: 타깃들이 무관** — 한 트리의 분할이 두 타깃 사이의 절충. 각 타깃을 **따로 학습**하는 게 더 좋다.

**실험으로 확인**하는 게 표준 방법이다.

### 5.5 분류 트리에서도 다중 출력

분류 트리도 다중 출력을 지원한다. `DecisionTreeClassifier`에 **다중 라벨 y**를 넘기면 **다중 라벨 분류**가 된다.

### 5.6 5장의 한 줄 결론

**다중 출력 트리는 **공통 구조를 공유하는 타깃들**에 효과적이다.** sklearn은 **별다른 설정 없이** 지원하므로, 다중 타깃 문제에서 **먼저 시도해 볼 가치**가 있다.

---

## 6장 범주형 변수의 트리 분할

### 6.1 트리에서 범주형 처리의 세 방법

1부 6장에서 **라벨 인코딩**과 **원-핫 인코딩**을 다뤘다. 본 6장에서는 **트리 모델 관점에서** 두 방법의 트레이드오프와 **최근에 도입된 네이티브 처리**를 정리한다.

![07 categorical handling](figs/07_categorical_handling.png)

<sub>그림 6-1. 범주형 변수의 트리 분할 세 가지 방법.</sub>

### 6.2 방법 1: 라벨 인코딩 — 위험한 단순함

라벨 인코딩은 K개 범주를 **정수 0, 1, ..., K-1**로 변환한다. 코드가 간단하지만, **트리에 넣었을 때 위험**하다.

이유: 트리는 **수치형으로 처리**하므로 `mfr <= 1.5` 같은 분할을 만들 수 있다. 의미는 **"제조사 A 또는 G"**인가? 사실 **알파벳 순서로 우연히** 그렇게 된 것이다. **데이터 본질과 무관한 분할**이다.

### 6.3 방법 2: 원-핫 인코딩 — 표준이지만 비용 있는 안전성

원-핫 인코딩은 K개 범주를 **K개의 0/1 컬럼**으로 변환. 트리가 각 컬럼에 대해 **0 vs 1**로 분할하므로 **각 범주를 독립적으로** 다룬다.

**장점**: **안전하다**. 순서 가정 없이 트리가 **자유롭게** 각 범주를 다룬다.

**단점**: **차원 증가**. K가 크면(예: 도시 1000개) **1000개 새 컬럼**. 학습 시간↑.

### 6.4 방법 3: 네이티브 범주형 처리 (HistGradientBoosting)

sklearn 1.4 이후 `HistGradientBoostingRegressor`가 **범주형 변수를 직접 처리**하는 기능을 제공한다.

```python
from sklearn.ensemble import HistGradientBoostingRegressor

# 범주형 컬럼을 category 타입으로
X["mfr"] = X["mfr"].astype("category")
X["type"] = X["type"].astype("category")

# categorical_features="from_dtype"가 핵심
hgb = HistGradientBoostingRegressor(
    categorical_features="from_dtype",   # category 타입 자동 인식
    random_state=42
)
hgb.fit(X, y)
```

원-핫 인코딩 없이도 **각 범주를 모델이 직접 분할**한다.

### 6.5 세 방법의 성능 비교 (Cereals)

Cereals 같은 **작은 데이터**에서의 결과:

| 방법 | R² |
|---|---|
| 라벨 + GBM | 약 0.77 |
| 원-핫 + GBM | 약 0.84 |
| 네이티브 HistGB | 약 0.75 |

흥미롭게도 이 작은 데이터셋에서는 **원-핫 인코딩**이 가장 잘 작동한다. **각 범주에 대한 명시적 분할**이 좋은 신호를 잡는다.

### 6.6 데이터 크기별 권장 방법

| 데이터 크기 | 범주 수 | 권장 |
|---|---|---|
| 소형 (수백 행) | 적음 | **원-핫** |
| 중형 (수천~수만 행) | 보통 | **원-핫** 또는 **네이티브** |
| 대형 (수십만 행 이상) | 많음 | **네이티브** |
| 매우 많은 범주 (>100) | - | **CatBoost** (자동 target encoding) |

### 6.7 트리 기반 모델별 범주형 처리 능력

| 모델 | 원-핫 | 네이티브 |
|---|---|---|
| sklearn `DecisionTreeRegressor` | ✓ | ✗ |
| sklearn `RandomForestRegressor` | ✓ | ✗ |
| sklearn `HistGradientBoostingRegressor` | ✓ | ✓ |
| XGBoost (`enable_categorical=True`) | ✓ | ✓ |
| LightGBM (`categorical_feature`) | ✓ | ✓ |
| **CatBoost** (`cat_features`) | ✗ | ✓ (자동) |

CatBoost는 **원-핫 인코딩 없이도 범주형을 가장 잘 처리**하는 모델이다. 6부에서 자세히 다룬다.

### 6.8 6장의 한 줄 결론

**트리 기반 모델에서 범주형 처리는 **데이터 크기와 범주 수**에 따라 다르다.** Cereals 같은 **작은 데이터에서는 원-핫이 표준**. 대형 데이터나 범주가 많으면 **네이티브 처리**가 빛난다.

---

## 7장 트리 시각화 도구

### 7.1 시각화의 가치

결정 트리의 **가장 큰 강점**은 **해석 가능성**이다. 다른 머신러닝 모델이 **블랙박스**인 반면, 트리는 **모든 결정 규칙이 명시적으로 보인다**. 그러나 **그 규칙을 사람이 읽기 좋게** 보여 주는 것은 **별도의 작업**이다.

### 7.2 세 가지 시각화 도구

| 도구 | 출력 형식 | 장점 | 단점 |
|---|---|---|---|
| `plot_tree` | matplotlib 그림 | sklearn 표준, 즉시 사용 | 큰 트리에서 가독성↓ |
| `export_text` | 텍스트 | 코드에 들어감, 검색 가능 | 시각적이지 않음 |
| `dtreeviz` | 풍부한 SVG | 분포 시각화 포함 | 별도 설치 필요 |

### 7.3 plot_tree — sklearn 표준

sklearn의 `plot_tree`는 **별도 설치 없이** 트리를 그릴 수 있다.

```python
from sklearn.tree import DecisionTreeRegressor, plot_tree
import matplotlib.pyplot as plt
import koreanize_matplotlib

# 작은 트리 학습 (보기 좋게 max_depth=3)
tree_small = DecisionTreeRegressor(max_depth=3, random_state=42)
tree_small.fit(X_ames, y_ames)

fig, ax = plt.subplots(figsize=(20, 10), dpi=100)
plot_tree(tree_small,
          feature_names=X_ames.columns,
          filled=True,
          rounded=True,
          fontsize=9, ax=ax)
plt.show()
```

각 노드에 다음 정보가 표시된다.

- 분할 조건: `Overall Qual <= 7.5`
- 불순도 (회귀: MSE)
- 샘플 수
- 예측값 (회귀: 평균)

색은 **예측값의 크기**. 진한 색일수록 **극단적 예측**.

### 7.4 export_text — 텍스트 출력

작은 트리는 **텍스트 형식**이 오히려 **보기 좋다**. 코드 주석이나 보고서에 직접 붙여 넣기 좋다.

```python
from sklearn.tree import export_text

text_rules = export_text(tree_tiny,
                          feature_names=X_ames.columns.tolist(),
                          max_depth=3)
print(text_rules)
```

출력 예시:

```
|--- Overall Qual <= 7.50
|   |--- Total SF <= 2376.50
|   |   |--- value: [11.85]
|   |--- Total SF >  2376.50
|   |   |--- value: [12.36]
|--- Overall Qual >  7.50
|   |--- ...
```

`export_text`의 장점:

- **검색 가능**: `grep "Overall Qual"`로 찾기
- **버전 관리**: git으로 **트리 변화** 추적
- **자동 변환**: SQL, Excel 수식으로 변환 가능

### 7.5 dtreeviz — 분포까지 보여 주는 도구

별도 패키지로 **훨씬 풍부한 시각화**를 제공한다.

```python
# 설치
# !pip install dtreeviz

from dtreeviz import model

viz_model = model(tree,
                   X_train=X_ames,
                   y_train=y_ames,
                   feature_names=X_ames.columns.tolist(),
                   target_name="LogSalePrice")

v = viz_model.view()
v.save("dtreeviz_tree.svg")
```

각 노드에 **데이터 분포가 작은 히스토그램**으로 표시되어 **분할이 어떻게 데이터를 나누는지** 한눈에 보인다.

### 7.6 큰 트리를 다루는 세 가지 방법

깊이 8 이상의 트리는 **전체를 보기 어렵다**. 다음 방법들이 있다.

1. **`max_depth=3`으로 부분만**: `plot_tree(max_depth=3, ...)`
2. **특정 샘플의 예측 경로만**: 한 샘플이 **어느 노드를 통과**하는지 추적
3. **변수 중요도로 요약**: 트리 자체를 안 보고 **어느 변수가 많이 쓰였는지**만

```python
import pandas as pd

tree = DecisionTreeRegressor(max_depth=10, random_state=42)
tree.fit(X_ames, y_ames)

imp = pd.Series(tree.feature_importances_, index=X_ames.columns)
print(imp.nlargest(10).round(4))
```

Ames의 결과: `Total SF`, `Overall Qual`, `Gr Liv Area`, `Year Built` 같은 **예상되는 핵심 변수**가 상위.

### 7.7 시각화 도구 선택

| 상황 | 권장 도구 |
|---|---|
| 깊이 3 이하 작은 트리 + 개발자 보기 | `export_text` |
| 깊이 3 이하 작은 트리 + 비전문가 보기 | `dtreeviz` |
| 깊이 4~5 중간 트리 | `plot_tree` |
| 깊이 8+ 큰 트리 | 부분 시각화 + 변수 중요도 |

### 7.8 7장의 한 줄 결론

**작은 트리는 `export_text`나 `dtreeviz`, 중간 트리는 `plot_tree`, 큰 트리는 **부분 시각화**하거나 **변수 중요도로 요약**하는 게 표준이다.** 트리의 **해석 가능성**은 결국 **어떻게 보여 주는가**에 달렸다.

---

## 8장 단일 트리의 한계와 앙상블로의 다리

![08 single to ensemble](figs/08_single_to_ensemble.png)

<sub>그림 8-1. 단일 트리에서 앙상블로 — Ames의 모델별 R². 본 2부에서 단일 트리를 R² 0.77 → 0.83까지 끌어올렸다. 그러나 RF나 GBM의 R² 0.88+에는 못 미친다.</sub>

### 8.1 본 부에서 단일 트리가 얼마나 좋아졌나

1~7장에서 적용한 **심화 기법**의 효과:

| 모델 | Ames CV R² | 적용 기법 |
|---|---|---|
| 단일 트리 (튜닝 안 함) | 0.77 | sklearn 기본값 |
| 단일 트리 (max_depth=7) | 0.80 | 3장 |
| 단일 트리 (+min_samples_leaf=10) | 0.82 | 3장 |
| 단일 트리 (+ccp_alpha=1e-4) | 0.83 | 2장 |
| **단일 트리 (전체 튜닝)** | **0.83** | 모든 매개변수 조합 |

단일 트리를 **잘 다듬으면 R² 0.83**까지. **튜닝 안 한 트리 0.77**에서 **6 포인트 향상**.

### 8.2 그러나 앙상블에는 못 미친다

| 모델 | Ames CV R² |
|---|---|
| 단일 트리 (기본) | 0.77 |
| 단일 트리 (튜닝) | 0.83 |
| **랜덤 포레스트** | **0.88** |
| **GBM** | **0.89** |

단일 트리의 **튜닝 한계는 0.83 근처**. 그 이상은 **앙상블의 영역**.

### 8.3 단일 트리의 두 가지 본질적 한계

**한계 1: 분산이 크다**. 단일 트리는 **학습 데이터에 매우 민감**하다. 데이터가 약간만 달라도 **완전히 다른 트리**가 만들어진다.

**한계 2: 편향이 크다**. 단일 트리는 **축에 평행한 분할**만 가능하다. **연속 함수** (예: $y = x^2$) 같은 부드러운 패턴은 **계단형으로 근사**할 수밖에 없다.

### 8.4 두 한계의 해결책

| 한계 | 해결 모델 | 부 | 방법 |
|---|---|---|---|
| 분산이 크다 | **랜덤 포레스트** | 3부 | 부트스트랩 + 변수 무작위 + 100그루 평균 |
| 편향이 크다 | **GBM** | 5부 | 잔차 학습 + 누적 가중합 |

랜덤 포레스트는 **여러 트리를 평균**해서 분산을 줄인다. GBM은 **여러 트리를 순차로 더해서** 편향을 줄인다. 두 방법이 **서로 보완적**.

### 8.5 본 부의 매개변수가 앙상블에서도 작동

본 부에서 익힌 **심화 매개변수**들은 **RF, GBM, XGBoost**에도 **동일하게** 작동한다.

| 매개변수 | 단일 트리 | RF | GBM | XGBoost |
|---|---|---|---|---|
| `max_depth` | ✓ | ✓ | ✓ | ✓ |
| `min_samples_leaf` | ✓ | ✓ | ✓ | ✓ |
| `min_samples_split` | ✓ | ✓ | ✓ | ✓ |
| `monotonic_cst` | ✓ | ✗ | ✗ | ✓ (`monotone_constraints`) |

본 부의 매개변수 직관이 **앙상블 모델 튜닝의 출발점**이다.

### 8.6 본 부의 종합 결론

본 부에서 다룬 **심화 주제 8가지**를 한 표로:

| 장 | 주제 | 핵심 메시지 |
|---|---|---|
| 1장 | 분할 복잡도 | sklearn 트리는 O(n log n)으로 빠르다 |
| 2장 | ccp_alpha | 사후 가지치기로 R² 0.78 → 0.83 |
| 3장 | 매개변수 미세 조정 | 4종 조합으로 R² 0.83 도달 |
| 4장 | 단조성 제약 | 도메인 지식 부과 + 해석 가능성 |
| 5장 | 다중 출력 트리 | 한 트리로 여러 타깃 동시 예측 |
| 6장 | 범주형 분할 | 원-핫이 표준, 네이티브 처리 등장 |
| 7장 | 시각화 도구 | plot_tree, export_text, dtreeviz |
| 8장 | 한계와 앙상블 | 단일 트리 0.83 → 앙상블 0.88+ |

**단일 트리도 잘 다듬으면 강하다.** R² 0.77에서 0.83까지. 그러나 **앙상블의 0.88~0.89**에는 못 미친다.

**본 부의 매개변수가 앙상블의 토대다.** **심화 매개변수 직관**이 RF, GBM, XGBoost, LightGBM 모두에 **그대로** 적용된다.

### 8.7 시리즈에서 본 부의 위치

권장 학습 순서에서 본 부는 **3부 직후**에 위치한다.

**3부** (트리 기초 + RF) → **2부** (본 부) → **4부** (AdaBoost) → **5부** (GBM) → **6부** (XGBoost·LightGBM·CatBoost) → **7부** (종합)

본 부에서 익힌 **심화 매개변수**들은 **4부 이후 모든 부에 등장**한다. 본 부가 **시리즈 전체의 토대** 중 하나다.

### 8.8 다음 부 예고

4부에서 본격적으로 **앙상블의 첫 번째 종류 — AdaBoost**를 다룬다. 흥미로운 질문 — **AdaBoost는 단일 트리보다 얼마나 더 좋을까**?

답은 **데이터에 따라 다르다**. Ames에서 AdaBoost는 R² 0.81 — **튜닝한 단일 트리(0.83)와 비슷하거나 약간 낮다**. 그러나 캘리포니아에서는 **AdaBoost가 처참하게 실패**(R² 0.23). 이 **부스팅의 본질**과 **손실함수의 영향**이 5부 GBM의 출발점이다.
