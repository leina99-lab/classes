# 3부 학생 워크북 — 결정 트리, 배깅, 랜덤 포레스트

## 쉬운 버전 — 그림으로 채우기

이 워크북은 이론 교재 `00_bagging_random_forest_theory_EASY.md`를 함께 읽으면서 채우는 자가학습 자료이다. 수식 없이 그림과 직관 중심으로 구성되어 있다. 각 빈칸 아래의 정답 토글을 펼쳐 즉시 확인할 수 있다.

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 0장 결정 트리 — 질문의 사슬로 답을 찾는 모델

![01 decision tree basic](figs/01_decision_tree_basic.png)

<sub>그림 0-1. 결정 트리는 뿌리에서 잎까지의 한 길을 따라간다.</sub>

**개념 1.** 결정 트리는 ____________________ 질문을 차례차례 던져 답을 찾는 모델이다. 트리의 맨 위 노드를 ____________________ 라 하고, 끝에서 더 이상 질문이 없는 노드를 ____________________ 라 한다.

<details><summary>▶ 정답 보기</summary>

예/아니오 / 뿌리(root) / 잎(leaf)

</details>

**개념 2.** 트리 모델의 두 매력은 ____________________ 가 좋다는 것(어떤 입력이 왜 그런 예측을 받았는지 설명 가능)과 변수의 ____________________(예: 로그·제곱근)에 흔들리지 않는다는 것이다.

<details><summary>▶ 정답 보기</summary>

해석 가능성 / 단위·변환

</details>

**그림 해석.** 그림 0-1에서 입력 [Overall Qual=8, Total Bath=3.0]이라면, 어느 잎으로 가는가? 그리고 그 잎의 예측값은 얼마인가?

<details><summary>▶ 정답 보기</summary>

오른쪽 → 오른쪽 경로를 따라 가장 오른쪽 잎(\$340k)에 도달.

Overall Qual=8은 7보다 크므로 No → 오른쪽으로 간다. Total Bath=3.0은 2.5보다 크므로 다시 No → 오른쪽. 결과적으로 \$340k를 예측받는다.

</details>

**코드 빈칸.** 깊이 무제한 트리를 학습하고 그 크기를 출력하는 코드.

```python
from sklearn.tree import DecisionTreeRegressor

tree = DecisionTreeRegressor(random_state=42)
tree.____(X, y)

print(f"트리 깊이:  {tree.____()}")
print(f"잎 노드 수: {tree.____()}")
print(f"학습 R²:    {tree.____(X, y):.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
tree.fit(X, y)
tree.get_depth()
tree.get_n_leaves()
tree.score(X, y)
```

깊이 무제한 트리는 학습 데이터를 **외워 버려서** 잎이 약 2,000개 이상이고 학습 R²가 1.0에 가깝다. **외운 트리는 새 데이터에 약하다** — 이게 과적합이다.

</details>

### 0.2 불순도 — 엔트로피와 지니

![02 entropy gini curve](figs/02_entropy_gini_curve.png)

<sub>그림 0-2. 두 측정값이 거의 같은 모양의 곡선이다.</sub>

**개념 3.** 한 노드 안의 데이터가 **얼마나 섞여 있는지** 측정한 값을 ____________________ 라 한다. 한 색만 있으면 값이 ____ 이고, 반반 섞이면 ____________________ 가 된다.

<details><summary>▶ 정답 보기</summary>

불순도(impurity) / 0 / 최댓값(최대치)

</details>

**개념 4.** 분류 트리의 두 표준 불순도 측정값은 ____________________ 와 ____________________ 다. 둘은 **거의 같은 곡선**이라 어느 쪽을 써도 결과가 비슷하다. sklearn 기본값은 ____________________ 인데, 그 이유는 ____________________ 가 약간 더 빠르기 때문이다.

<details><summary>▶ 정답 보기</summary>

엔트로피(entropy) / 지니 불순도(Gini) / 지니(gini) / 곱셈(로그가 없어서)

</details>

**그림 해석.** 그림 0-2에서 두 곡선의 **공통점**과 **차이점**을 각각 하나씩 적어 보자.

<details><summary>▶ 정답 보기</summary>

**공통점**: 둘 다 **p = 0.5에서 최댓값**, **p = 0 또는 1에서 0**. 즉 **완전 순수면 0, 반반 섞이면 최대**.

**차이점**: 엔트로피가 살짝 더 **위로 부풀어** 있다. 같은 비율에서 엔트로피 값이 지니보다 약간 크다. 그러나 **분할 결과는 거의 같다**.

</details>

### 0.3 회귀에서의 불순도 — 분산
**개념 5.** 회귀 문제에서 한 노드의 불순도는 그 노드 안 가격들의 ____________________ 이다. 모든 가격이 같으면 분산이 ____ 이고, 가격들이 흩어져 있을수록 분산이 ____________________.

<details><summary>▶ 정답 보기</summary>

분산(variance, MSE) / 0 / 커진다

</details>

**개념 6.** 회귀 트리의 잎 노드 예측값은, 그 노드에 속한 학습 가격들의 ____________________ 이다.

<details><summary>▶ 정답 보기</summary>

평균(mean)

</details>

### 0.4 분기 — 어떤 질문을 고르나

![03 split process](figs/03_split_process.png)

<sub>그림 0-3. 분기 한 번의 전체 과정.</sub>

**개념 7.** 트리는 **모든 후보 분할**을 시도하고 가장 ____________________ 를 많이 줄이는 분할을 고른다. 이 줄어든 양을 ____________________ 이라 부른다.

<details><summary>▶ 정답 보기</summary>

불순도(분산) / 정보이득(information gain)

</details>

**그림 해석.** 그림 0-3 가운데 패널의 곡선은 무엇을 그린 것인가? 곡선의 꼭대기는 무엇을 의미하나?

<details><summary>▶ 정답 보기</summary>

각 **후보 임계점**마다 **그 임계점으로 분할했을 때의 정보이득**을 계산해 그린 곡선이다.

꼭대기는 **정보이득이 최대인 임계점** — 즉 **트리가 선택할 분할 위치**다. 그림에서 약 4.5 근처에서 정점을 찍는다.

</details>

**코드 빈칸.** `Overall Qual ≤ 7` 분할의 정보이득 계산.

```python
y_all = y.values
mse_before = y_all.____()

left  = y_all[X["Overall Qual"] <= 7]
right = y_all[X["Overall Qual"] >  7]

n = len(y_all)
mse_after = (len(left)/n) * left.var() + (len(right)/n) * right.____()
gain = ____ - mse_after
```

<details><summary>▶ 정답 보기</summary>

```python
mse_before = y_all.var()
right.var()
gain = mse_before - mse_after
```

이 한 번의 분할이 **전체 분산의 절반 이상**을 깎는다. 그래서 트리가 이 분할을 첫 분기로 **반드시 선택**한다.

</details>

### 0.5 가지치기**개념 8.** 과적합을 막는 두 방법은 트리가 자라기 **전에** 멈춤 조건을 두는 ____________________ 가지치기와 트리를 끝까지 키운 **뒤** 덜 중요한 가지를 잘라내는 ____________________ 가지치기다.

<details><summary>▶ 정답 보기</summary>

사전(pre-pruning) / 사후(post-pruning)

</details>

**개념 9.** 학습 R²는 깊이를 늘릴수록 ____________________ (커진다 / 작아진다), 검증 R²는 어느 시점부터 ____________________ (커진다 / 작아진다). 두 곡선이 갈라지는 지점이 ____________________ 의 시작이다.

<details><summary>▶ 정답 보기</summary>

커진다 / 작아진다(떨어진다) / 과적합(overfitting)

</details>

---

## 1장 한 그루 트리의 흔들림과 평균의 안정
**개념 10.** 통계학에서 데이터가 조금 흔들리면 결과가 크게 흔들리는 모델을 ____________________ 이 큰 모델이라 부른다. 단일 결정 트리는 이 모델의 **대표 예시**다.

<details><summary>▶ 정답 보기</summary>

분산(variance)

</details>

**개념 11.** 분산이 큰 모델의 해결책은, **서로 조금씩 다른 모델 여러 개를 키워서** ____________________ 내는 것이다. 한 모델의 **우연**이 상쇄된다.

<details><summary>▶ 정답 보기</summary>

평균(을)

</details>

**개념 12.** 완전히 독립인 100개 모델을 평균내면 분산이 원래의 ____________________ 로 줄어든다. 즉 분산이 ____ 배 작아진다.

<details><summary>▶ 정답 보기</summary>

1/100 / 100

</details>

**개념 13.** 그런데 같은 원본 데이터에서 만든 트리들은 **완전히 독립이 아니라** ____________________ 있어서, 분산이 1/100까지 깔끔하게 줄지 않는다. 이 닮음을 어떻게 깰 것인가가 4장의 주제다.

<details><summary>▶ 정답 보기</summary>

닮아(서로 상관되어)

</details>

**코드 빈칸.** 70% 부분집합 학습 20번 반복으로 뿌리 분할 변수 분포 확인.

```python
from collections import Counter

rng = np.random.default_rng(42)
n = len(X)
first_splits = []

for seed in range(20):
    idx = rng.choice(n, size=int(n * ____), replace=False)
    t = DecisionTreeRegressor(max_depth=3, random_state=42)
    t.fit(X.iloc[idx], y.iloc[idx])
    first_splits.append(X.columns[t.tree_.____[0]])

for var, cnt in Counter(first_splits).most_common():
    print(f"  {var:<20s}  {cnt}회")
```

<details><summary>▶ 정답 보기</summary>

```python
size=int(n * 0.7)
t.tree_.feature[0]
```

20번 중 17번 정도가 `Overall Qual`이 뿌리에 오고, 나머지 3번은 **다른 변수**. 데이터의 30%만 빠져도 트리의 첫 질문이 바뀐다 — 이게 단일 트리의 흔들림이다.

</details>

---

## 2장 복원 추출과 부트스트랩 표본

![04 bagging diagram](figs/04_bagging_diagram.png)

<sub>그림 2-1. 배깅의 세 단계 — 부트스트랩 → 독립적 트리 학습 → 평균.</sub>

**개념 14.** 카드 한 장을 뽑고 **다시 더미에 넣은 다음** 또 한 장을 뽑는 방식을 ____________________ 추출이라 한다. 같은 카드가 여러 번 뽑힐 수 있다.

<details><summary>▶ 정답 보기</summary>

복원(with replacement)

</details>

**개념 15.** 원본 데이터에서 복원 추출로 **같은 크기**의 새 데이터셋을 만들면, 원본의 약 ____________________ % 의 행이 거기 들어가고, 약 ____________________ %는 한 번도 안 들어간다. 안 들어간 부분을 ____________________ 표본이라 부른다.

<details><summary>▶ 정답 보기</summary>

63.2 / 36.8 / OOB(Out-of-Bag)

</details>

**개념 16.** OOB 표본의 매력은, **그 트리의 학습에 쓰이지 않았다**는 점이다. 따라서 OOB 표본을 **별도의 ____________________ 데이터**처럼 쓸 수 있다.

<details><summary>▶ 정답 보기</summary>

검증(validation)

</details>

**그림 해석.** 그림 2-1에서 **세 단계**를 순서대로 적어 보자.

<details><summary>▶ 정답 보기</summary>

1. **부트스트랩 표본 생성** — 원본 데이터에서 복원 추출로 여러 표본을 만든다 (각 표본은 원본의 약 63.2% 고유 행).
2. **각 표본에서 트리 학습** — 트리들은 **서로 무관하게** 학습된다(병렬).
3. **예측 평균(또는 다수결)** — 새 입력에 대해 모든 트리의 예측을 모아 평균(회귀)이나 다수결(분류)을 취한다.

</details>

**코드 빈칸.** 부트스트랩 표본과 OOB 인덱스 분리.

```python
rng = np.random.default_rng(42)
n = len(X)

boot_idx   = rng.choice(n, size=n, replace=____)
unique_idx = np.____(boot_idx)
oob_idx    = np.____(np.arange(n), unique_idx)
```

<details><summary>▶ 정답 보기</summary>

```python
replace=True            # 복원 추출
np.unique(boot_idx)
np.setdiff1d(np.arange(n), unique_idx)
```

`np.setdiff1d(A, B)`는 A에서 B에 속하는 원소를 뺀 **차집합**을 반환한다.

</details>

---

## 3장 평균의 한계 — 트리들이 닮으면 어떻게 되나

![05 variance reduction](figs/05_variance_reduction.png)

<sub>그림 3-1. 트리 수에 따른 앙상블 분산. 닮음(ρ)이 클수록 일찍 평탄해진다.</sub>

**개념 17.** 트리들이 ____________________ 수록 평균의 효과가 줄어든다. 극단적으로 모든 트리가 **완전히 같다**면 100그루를 평균내도 한 그루와 ____________________.

<details><summary>▶ 정답 보기</summary>

닮을 / 똑같다(같다)

</details>

**개념 18.** 그래서 배깅의 성능을 올리는 두 가지 길은:

길 1: 트리 수를 ____________________
길 2: 트리 간 ____________________ 을 줄이기

둘 중 **후자가 더 강력하다**. 이게 4장 변수 무작위성의 동기다.

<details><summary>▶ 정답 보기</summary>

늘리기 / 닮음(상관, ρ)

</details>

**그림 해석.** 그림 3-1에서 **세 곡선**(초록·남색·빨강)이 **언제 평탄해지는가**가 다르다. 어떤 색이 가장 **오래** 줄어드는가? 그리고 그 이유는?

<details><summary>▶ 정답 보기</summary>

**초록**(ρ = 0, 완전 독립)이 가장 오래 줄어든다.

트리들이 **서로 닮지 않으면** 평균이 분산을 **더 많이** 줄일 수 있기 때문이다. 닮음이 클수록(빨강) 일찍 **바닥**에 부딪힌다. 그 바닥이 ρσ² — 트리들 사이의 **공통된 우연**이다.

</details>

**개념 19.** 100그루에서 200그루로 늘려도 R²가 거의 안 오른다. 이 현상을 ____________________ 이라 부른다. 트리 수를 늘리는 것에는 한계가 있다.

<details><summary>▶ 정답 보기</summary>

수확체감(diminishing returns)

</details>

---

## 4장 트리들을 덜 닮게 만들기 — 무작위 변수 선택

![06 mtry tradeoff](figs/06_mtry_tradeoff.png)

<sub>그림 4-1. mtry의 균형점 — 개별 트리 강도와 트리 간 닮음의 줄다리기.</sub>

**개념 1.** 부트스트랩만으로는 트리 간 닮음을 충분히 못 깬다. 이유는 **데이터의 가장 강한 변수** 가 어느 부트스트랩 표본에도 ____________________ 기 때문이다. Ames에서 가장 강한 변수는 ____________________ 이다.

<details><summary>▶ 정답 보기</summary>

살아남(살아 있)기 / Overall Qual

</details>

**개념 2.** 랜덤 포레스트의 핵심 아이디어는 **매 분할마다 변수의** ____________________ **만 무작위로 골라 쓰는 것**이다. sklearn에서 이 매개변수를 ____________________ 로 부른다.

<details><summary>▶ 정답 보기</summary>

일부(부분) / max_features

</details>

**개념 3.** Breiman의 권장값은 회귀에서 전체 변수의 ____________________, 분류에서 ____________________ 이다. Ames(변수 80개) 기준으로는 회귀에서 약 ____ 개, 분류에서 약 ____ 개이다.

<details><summary>▶ 정답 보기</summary>

1/3 / √p / 27 / 9

</details>

**그림 해석.** 그림 4-1에서 **녹색 곡선**(개별 트리 강도)과 **빨강 곡선**(트리 간 닮음)이 mtry가 커질수록 어떻게 변하는가?

<details><summary>▶ 정답 보기</summary>

**녹색**(개별 트리 강도): mtry가 커지면 **증가**. 변수를 많이 볼수록 강한 변수를 보고 좋은 분할을 찾을 수 있다.

**빨강**(트리 간 닮음 ρ): mtry가 커지면 **증가**. 변수를 많이 볼수록 강한 변수가 모든 트리에 들어가 트리들이 닮는다.

두 곡선이 **같은 방향으로** 움직이므로, 두 효과가 **상쇄**되는 가운데에서 앙상블 성능이 최대가 된다.

</details>

**개념 4.** mtry를 너무 작게 두면 개별 트리가 ____________________ 지고, 너무 크게 두면 트리들이 ____________________ 진다. 두 가지 사이의 균형점이 회귀에서 보통 ____________________ 근처이다.

<details><summary>▶ 정답 보기</summary>

약해 / 닮아 / p/3

</details>

**개념 5.** 단일 트리에서는 깊이를 6~10으로 **제한** 해야 했지만, 랜덤 포레스트에서는 정반대로 **각 트리를** ____________________ 두는 게 보통 최적이다. 왜냐하면 ____________________ 이 분산을 줄여 주기 때문이다.

<details><summary>▶ 정답 보기</summary>

깊이 제한 없이(끝까지 키워) / 평균(앙상블)

</details>

**코드 빈칸.** max_features 곡선 그리기.

```python
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import cross_val_score

p = X.shape[1]
candidates = [3, 5, p // 4, p // ____, p // 2, p]

for mf in candidates:
    rf = RandomForestRegressor(n_estimators=100, max_features=____,
                                random_state=42, n_jobs=____)
    r2 = cross_val_score(rf, X, y, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"max_features={mf:>3}:  CV R² = {r2:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
p // 3           # 권장 mtry
max_features=mf
n_jobs=-1        # 모든 CPU 사용
```

곡선이 p/3 근처에서 정점을 찍고, 양 극단에서 떨어진다.

</details>

---

## 5장 검증 데이터 없이 점수 매기기 — OOB 점수
**개념 6.** 행 **i**의 OOB 예측은, 그 행을 ____________________ 로 가진 트리들만 모아 예측을 ____________________ 낸 값이다.

<details><summary>▶ 정답 보기</summary>

OOB(부트스트랩에 안 들어간) / 평균(을)

</details>

**개념 7.** OOB 점수의 두 가지 매력:

매력 1: **모든 데이터를** ____________________ 에 쓸 수 있다.
매력 2: 5-fold CV가 5번 학습해야 하는 일을 ____________________ 의 학습으로 끝낸다.

그래서 시간이 약 ____ 배 빠르다.

<details><summary>▶ 정답 보기</summary>

학습 / 한 번 / 5

</details>

**개념 8.** 트리 수가 충분히 크면 OOB 점수는 **가장 비싼 검증 방법**인 ____________________ 와 사실상 같다. 거의 **공짜로** 가장 정확한 검증을 얻는 셈이다.

<details><summary>▶ 정답 보기</summary>

leave-one-out CV (LOO-CV)

</details>

**코드 빈칸.** OOB 점수 계산.

```python
rf = RandomForestRegressor(n_estimators=100,
                            ____=True,         # OOB 계산 켜기
                            random_state=42, n_jobs=-1)
rf.fit(X, y)

print(f"OOB R²: {rf.____:.4f}")    # 학습 후 자동 계산된 점수
```

<details><summary>▶ 정답 보기</summary>

```python
oob_score=True
rf.oob_score_
```

sklearn 관례: 생성자 옵션은 `oob_score`(끝에 _ 없음), 학습 후 속성은 `oob_score_`(끝에 _ 있음). 헷갈리지 않도록 주의.

</details>

**개념 9.** 곡선이 **어느 시점에 평탄해지는지** 가 **최소 필요한 트리 수** 다. Ames에서는 약 ____ 그루부터 OOB 점수가 거의 변하지 않는다.

<details><summary>▶ 정답 보기</summary>

50

</details>

---

## 6장 어떤 변수가 중요한가 — 두 가지 답

![07 importance compare](figs/07_importance_compare.png)

<sub>그림 6-1. MDI와 순열 중요도의 비교 — 사촌 변수에서 가장 크게 갈라진다.</sub>

**개념 10.** **MDI**(Mean Decrease in Impurity)는 **학습 중 자동 계산** 되며, sklearn에서는 ____________________ 한 줄로 얻는다. 어떤 변수가 분할에 **얼마나 자주 쓰였는지** 를 본다.

<details><summary>▶ 정답 보기</summary>

rf.feature_importances_

</details>

**개념 11.** **순열 중요도**는 어떤 변수의 값을 행 사이에서 **무작위로** ____________________, 모델 성능이 얼마나 떨어지는지 본다. 변수를 망쳐도 성능이 거의 안 떨어지면 그 변수는 **____________________ 도 되는** 변수다.

<details><summary>▶ 정답 보기</summary>

섞어(셔플하여) / 없어

</details>

**개념 12.** 두 측정이 다른 답을 주는 **대표적 상황**은 ____________________ 처럼 닮은 변수가 있을 때다. 예를 들어 Ames의 `Garage Cars`와 `Garage Area`는 상관계수 약 0.89로 사실상 같은 정보다.

<details><summary>▶ 정답 보기</summary>

사촌

</details>

**그림 해석.** 그림 6-1에서 빨강으로 표시된 세 변수(`Total SF`, `Garage Cars`, `Garage Area`)가 MDI와 순열 중요도에서 어떻게 **다르게** 평가되는가?

<details><summary>▶ 정답 보기</summary>

**MDI**: 셋 다 **적당히 높은** 중요도를 받는다. 트리가 분할마다 **셋 중 하나** 를 골라 사용했으므로 모두 적당히 쓰였다.

**순열 중요도**: 셋 다 **거의 0**. 한 변수를 망쳐도 **남은 사촌이 정보를 대신** 제공하므로 모델 성능이 거의 안 떨어진다.

</details>

**개념 13.** 두 측정을 한 줄로 요약하면 — MDI는 **어떤 변수가** ____________________ **되었는가** 를 보고, 순열 중요도는 **어떤 변수가** ____________________ **되는가** 를 본다.

<details><summary>▶ 정답 보기</summary>

실제로 사용 / 없어도 됨(대체 가능)

</details>

**코드 빈칸.** MDI와 순열 중요도 동시 계산.

```python
from sklearn.inspection import ____________________
from sklearn.model_selection import train_test_split

# MDI는 학습된 RF에서 즉시
mdi = pd.Series(rf.____, index=X.columns).sort_values(ascending=False)

# 순열 중요도는 검증 데이터에서
X_tr, X_te, y_tr, y_te = train_test_split(X, y, test_size=0.2, random_state=42)
rf.fit(X_tr, y_tr)
perm = permutation_importance(rf, X_te, y_te,
                                n_repeats=____,    # 각 변수를 10번 섞어 평균
                                random_state=42, n_jobs=-1)
perm_imp = pd.Series(perm.____, index=X.columns).sort_values(ascending=False)
```

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.inspection import permutation_importance
rf.feature_importances_
n_repeats=10
perm.importances_mean
```

`n_repeats=10`이 표준이다. 각 변수를 10번 섞고 평균낸다.

</details>

**코드 빈칸.** 사촌 변수 효과 확인 — 한 쪽만 vs 둘 다 제거.

```python
for name, drop_cols in [("전체", []),
                         ("Cars 제거", ["Garage Cars"]),
                         ("Area 제거", ["Garage Area"]),
                         ("둘 다 제거", ["Garage Cars", "Garage Area"])]:
    X_sub = X.____(columns=drop_cols)
    rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
    r2 = cross_val_score(rf, X_sub, y, cv=5, scoring="r2", n_jobs=-1).____()
    print(f"  {name:<12s}  CV R² = {r2:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
X.drop(columns=drop_cols)
.mean()        # cross_val_score는 배열을 반환하므로 평균 필요
```

한 쪽만 제거하면 거의 안 떨어지고, 둘 다 제거해야 비로소 떨어진다. **사촌 변수의 대체 가능성** 이 데이터로 확인되는 실험이다.

</details>

---

## 7장 Ames에서 모든 모델 한눈에 비교하기
**개념 1.** Ames에서 **단일 결정 트리**의 CV R²는 약 ____________________ 으로, 선형회귀(0.80)보다 **못하다**. 한 그루의 ____________________ 이 너무 커서 일반화가 약하기 때문이다.

<details><summary>▶ 정답 보기</summary>

0.75 / 흔들림(분산)

</details>

**개념 2.** **랜덤 포레스트 100그루** 는 CV R²가 약 ____________________ 로, 단일 트리보다 약 ____________________ 포인트 점프했다. 이 점프가 **평균의 위력**이다.

<details><summary>▶ 정답 보기</summary>

0.88 / 0.13

</details>

**개념 3.** 100그루에서 300그루로 **3배** 늘려도 R²는 약 ____________________ 정도밖에 안 오른다. 실무 황금률은 보통 ____________________ 그루이다.

<details><summary>▶ 정답 보기</summary>

0.0004 (거의 0) / 100~200

</details>

**개념 4.** Ames에서 MDI 1위는 ____________________(중요도 약 0.55), 3위에는 1부에서 우리가 **손으로 만든** ____________________ 가 들어온다. 이는 ____________________ 이 트리 모델에서도 유효함을 보여 준다.

<details><summary>▶ 정답 보기</summary>

Overall Qual / Total SF / 특성공학(feature engineering)

</details>

**코드 빈칸.** 다섯 모델 한 표로 비교.

```python
models = {
    "선형회귀":         LinearRegression(),
    "결정 트리":        DecisionTreeRegressor(random_state=42),
    "트리(가지치기)":   DecisionTreeRegressor(max_depth=____, min_samples_leaf=10, random_state=42),
    "RF 100그루":       RandomForestRegressor(n_estimators=____, random_state=42, n_jobs=-1),
    "RF 300그루":       RandomForestRegressor(n_estimators=300, random_state=42, n_jobs=-1),
}

for name, m in models.items():
    r2 = cross_val_score(m, X, y, cv=____, scoring="r2", n_jobs=-1).mean()
    print(f"{name:<20s}  CV R² = {r2:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
max_depth=8         # 가지치기 표준
n_estimators=100    # RF 표준
cv=5                # 5-fold 교차검증
```

다섯 모델의 R²로 **단일 트리 < 선형회귀 < 랜덤 포레스트** 의 순서가 명확히 확인된다.

</details>

---

## 8장 랜덤 포레스트의 한계 — 부스팅으로 가는 다리

![08 bias variance](figs/08_bias_variance.png)

<sub>그림 8-1. 과녁 비유 — 세 모델의 강약점.</sub>

**개념 5.** 예측 오차는 다음 세 가지로 나뉜다.

1) **편향**(bias): 모델이 ____________________ 못 잡는 패턴
2) **분산**(variance): ____________________ 따라 모델이 흔들리는 정도
3) **잡음**(noise): 데이터 자체의 무작위성 — ____________________ 모델로도 줄일 수 없음

<details><summary>▶ 정답 보기</summary>

근본적으로(아무리 해도) / 데이터에 / 어떤

</details>

**그림 해석.** 그림 8-1의 세 패널을 보고, 각 모델의 **편향**과 **분산**을 평가해 보자.

| 모델 | 편향 | 분산 |
|---|---|---|
| 단일 트리 | ___________ | ___________ |
| 랜덤 포레스트 | ___________ | ___________ |
| 선형회귀 | ___________ | ___________ |

<details><summary>▶ 정답 보기</summary>

| 모델 | 편향 | 분산 |
|---|---|---|
| 단일 트리 | **저** (중심 근처) | **고** (크게 흩어짐) |
| 랜덤 포레스트 | **저** (중심) | **저** (좁게 모임) |
| 선형회귀 | **고** (중심에서 비껴 있음) | **저** (좁게 모임) |

세 모델의 강약점이 한 그림에 박혀 있다.

</details>

**개념 6.** 배깅과 랜덤 포레스트는 **____________________ 항만 공격**하고, **____________________ 항은 거의 못 줄인다**. 따라서 RF의 성능 상한이 정해진다 — Ames에서 그 상한이 약 R² ____________________ 이다.

<details><summary>▶ 정답 보기</summary>

분산 / 편향 / 0.88

</details>

**개념 7.** 남은 편향을 줄이려면 **정반대 철학** 의 새 도구가 필요하다. 그 도구가 ____________________ 다. 트리들을 **순차적으로** 키워 **앞선 트리의 실수를 다음 트리가 보정** 하는 방식이다.

<details><summary>▶ 정답 보기</summary>

부스팅(boosting)

</details>

**개념 8.** 배깅과 부스팅의 결정적 차이를 적어 보자.

| | 랜덤 포레스트 (배깅) | 부스팅 |
|---|---|---|
| 트리들의 관계 | ___________ | ___________ |
| 비유 | ___________ | ___________ |
| 줄이는 오차 | ___________ | ___________ |


<details><summary>▶ 정답 보기</summary>

| | 랜덤 포레스트 (배깅) | 부스팅 |
|---|---|---|
| 트리들의 관계 | **서로 무관** (병렬) | **한 줄로 서서** 순차 학습 |
| 비유 | 서로 모르는 채점관들의 평균 | 앞 사람의 오답을 받아 고치는 학생들의 줄 |
| 줄이는 오차 | **분산** | **편향** |

</details>

**개념 9.** 부스팅 가족의 발전사를 시간순으로 정리하면:

____________________ (1995, 가중치 부스팅의 원조) → ____________________ (손실함수 일반화) → ____________________, ____________________, ____________________ (GBM의 현대적 구현 세 가지).

<details><summary>▶ 정답 보기</summary>

AdaBoost / GBM(Gradient Boosting Machine) / XGBoost / LightGBM / CatBoost

</details>

---

## 응용 문제 — 직접 풀어 보기

각 문제의 코드를 노트북에 복사해 실행한 뒤 정답 토글로 결과를 확인하자.

**문제 1.** `max_depth=2`인 트리를 학습하여 잎 노드 수와 학습 R²를 출력하라.

<details><summary>▶ 정답 보기</summary>

```python
t = DecisionTreeRegressor(max_depth=2, random_state=42)
t.fit(X, y)
print(f"잎: {t.get_n_leaves()}")
print(f"학습 R²: {t.score(X, y):.4f}")
```

깊이 2는 잎이 최대 4개. 학습 R²가 약 0.5~0.6 수준이다 — **너무 단순해서** 데이터를 못 잡는다(고편향).

</details>

**문제 2.** 부트스트랩을 50번 반복하여 OOB 비율 평균과 표준편차를 구하라.

<details><summary>▶ 정답 보기</summary>

```python
rng = np.random.default_rng(42)
n = len(X)
ratios = []
for _ in range(50):
    idx = rng.choice(n, size=n, replace=True)
    ratios.append((n - len(np.unique(idx))) / n)
print(f"평균: {np.mean(ratios):.4f}")
print(f"표준편차: {np.std(ratios):.4f}")
```

평균은 약 0.368($e^{-1}$), 표준편차는 약 0.005~0.01로 매우 작다. 부트스트랩이 **극도로 안정적**인 통계량이다.

</details>

**문제 3.** 단일 트리 vs 랜덤 포레스트 10그루의 CV R² 차이를 측정하라.

<details><summary>▶ 정답 보기</summary>

```python
t = DecisionTreeRegressor(random_state=42)
rf = RandomForestRegressor(n_estimators=10, random_state=42, n_jobs=-1)

r2_t = cross_val_score(t, X, y, cv=5, scoring="r2").mean()
r2_rf = cross_val_score(rf, X, y, cv=5, scoring="r2").mean()
print(f"단일 트리:   {r2_t:.4f}")
print(f"RF 10그루:   {r2_rf:.4f}")
print(f"차이:        {r2_rf - r2_t:.4f}")
```

10그루만 키워도 단일 트리보다 약 0.08~0.10 점프한다. **분산 감소의 첫 효과**다.

</details>

**문제 4.** `oob_score=True`로 학습한 RF의 OOB R²와 5-fold CV R² 차이를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
rf = RandomForestRegressor(n_estimators=100, oob_score=True,
                            random_state=42, n_jobs=-1)
rf.fit(X, y)
cv_r2 = cross_val_score(rf, X, y, cv=5, scoring="r2", n_jobs=-1).mean()

print(f"OOB R²: {rf.oob_score_:.4f}")
print(f"CV R²:  {cv_r2:.4f}")
print(f"차이:   {abs(rf.oob_score_ - cv_r2):.4f}")
```

차이는 보통 ±0.005 이내로 매우 작다. OOB가 **CV의 신뢰할 만한 대체**임을 데이터로 확인하는 실험이다.

</details>

**문제 5.** `Overall Qual`만 제거하고 RF의 CV R²를 측정하라. 얼마나 떨어지는가?

<details><summary>▶ 정답 보기</summary>

```python
X_drop = X.drop(columns=["Overall Qual"])
rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)

r2_full = cross_val_score(rf, X, y, cv=5, scoring="r2", n_jobs=-1).mean()
r2_drop = cross_val_score(rf, X_drop, y, cv=5, scoring="r2", n_jobs=-1).mean()

print(f"전체:      {r2_full:.4f}")
print(f"제거 후:   {r2_drop:.4f}")
print(f"감소량:    {r2_full - r2_drop:.4f}")
```

R²가 약 0.02~0.04 떨어진다. 가장 강한 변수를 제거했지만, **대체 변수가 많아** 큰 폭락은 없다. 트리 앙상블의 **견고함**을 보여 주는 실험이다.

</details>

---

## 다음 부 예고

다음은 **4부 AdaBoost** 이다. 같은 트리 기반인데 **철학이 정반대** 다. 평균이 아니라 **순차 보정**. 첫 트리의 오답을 받아 두 번째 트리가 고치고, 둘의 오답을 받아 세 번째 트리가 고친다.

흥미로운 사실 하나를 미리 알려 둔다. AdaBoost는 Ames에서는 그럭저럭 한다(R² 약 0.80)지만, **원본 그대로의 캘리포니아 주택 데이터**에서는 R²가 약 ____________________ 까지 떨어진다. 선형회귀에도 **훨씬 못 미친다**. 같은 알고리즘이 데이터에 따라 **극단적으로 달라지는** 이유가 4부의 핵심이다.

<details><summary>▶ 정답 보기 (캘리포니아에서의 AdaBoost R²)</summary>

약 0.40 — 선형회귀(0.64)에도 못 미친다.

이유는 AdaBoost가 **이상치에 가중치를 폭증시키는** 알고리즘 구조 때문이다. Ames는 1부에서 이상치를 제거했지만, 캘리포니아 원본에는 이상치가 그대로 있어 AdaBoost가 망가진다. GBM이 **어떻게 이 약점을 해결했는지** 가 5부의 이야기다.

</details>
