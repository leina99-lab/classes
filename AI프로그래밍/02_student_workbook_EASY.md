# 4부 학생 워크북 — AdaBoost

## 쉬운 버전 — 그림으로 채우기

이 워크북은 이론 교재 `00_adaboost_theory_EASY.md`를 함께 읽으면서 채우는 자가학습 자료이다. 수식 없이 그림과 직관 중심으로 구성되어 있다. 각 빈칸 아래의 정답 토글을 펼쳐 즉시 확인할 수 있다.

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 0장 분산 감소에서 편향 감소로 — 부스팅의 정신

![01 bagging vs boosting](figs/01_bagging_vs_boosting.png)

<sub>그림 0-1. 배깅과 부스팅의 정반대 철학.</sub>

**개념 1.** 3부 마지막에서 랜덤 포레스트의 R²가 더 이상 안 오르는 한계를 봤다. 남은 R² 격차는 분산이 아니라 ____________________ 에서 온다.

<details><summary>▶ 정답 보기</summary>

편향(bias)

트리 한 그루가 충분히 깊이 자라도 잡지 못하는 패턴이 있고, 그 패턴은 100그루를 평균내도 잡히지 않는다.

</details>

**개념 2.** 부스팅의 핵심 한 줄: 트리를 한 그루씩 ____________________ 으로 키우면서, 앞선 트리들이 잡지 못한 패턴을 다음 트리가 ____________________ 한다.

<details><summary>▶ 정답 보기</summary>

순차적(sequential) / 보정

</details>

**그림 해석.** 그림 0-1을 보고 배깅과 부스팅의 차이 세 가지를 적어 보자.

<details><summary>▶ 정답 보기</summary>

1. **트리들의 관계**: 배깅은 **서로 무관** (병렬), 부스팅은 **한 줄로 서서** (순차)
2. **다음 트리의 입력**: 배깅은 **새 부트스트랩 표본**, 부스팅은 **앞 트리의 오답 정보**
3. **줄이는 오차**: 배깅은 **분산**, 부스팅은 **편향**

</details>

**개념 3.** 두 방법의 **트리 깊이 권장값**이 정반대다. 배깅은 **____________________ 트리 100그루를 평균**해 분산을 줄이고, 부스팅은 **____________________ 트리 100그루를 누적**해 편향을 줄인다.

<details><summary>▶ 정답 보기</summary>

깊은 / 얕은

</details>

**개념 4.** 부스팅의 빌딩 블록을 ____________________ (weak learner)라 부른다. 무작위 예측보다 약간 나은 정도의 단순한 모델이다. AdaBoost에서 가장 흔히 쓰이는 약학습기는 깊이 ____ 짜리 결정 트리, 즉 ____________________ 다.

<details><summary>▶ 정답 보기</summary>

약학습기 / 1 / 결정 그루터기(decision stump)

</details>

**개념 5.** AdaBoost는 ____________________ 년 Yoav ____________________ 와 Robert ____________________ 가 발표한, 부스팅 가족의 시조다. 후속 알고리즘이 GBM(2001)이고, 그 현대적 구현 셋이 XGBoost, ____________________, ____________________ 다.

<details><summary>▶ 정답 보기</summary>

1995 / Freund / Schapire / LightGBM / CatBoost

</details>

---

## 1장 가중치 갱신 — 다음 트리가 무엇을 보고 학습하나

![02 weight update](figs/02_weight_update.png)

<sub>그림 1-1. AdaBoost의 가중치 갱신 한 사이클 — 점 크기가 곧 가중치다.</sub>

**개념 6.** AdaBoost의 핵심 아이디어는 학습 샘플마다 ____________________ 를 두는 것이다. 처음에는 모두 ____________________ 가중치로 시작한다.

<details><summary>▶ 정답 보기</summary>

가중치 / 같은(균등한)

</details>

**개념 7.** 가중치 갱신의 직관 — 세 줄 요약:

- 오답 샘플: 가중치가 ____________________ 오른다
- 정답 샘플: 가중치가 ____________________ 든다
- 모든 가중치의 합이 ____________________ 이 되도록 정규화한다

<details><summary>▶ 정답 보기</summary>

부풀어 / 줄어 / 1

</details>

**그림 해석.** 그림 1-1의 세 단계가 무엇을 보여 주는가?

- 1단계: ____________________
- 2단계: ____________________
- 3단계: ____________________

<details><summary>▶ 정답 보기</summary>

1단계: **균등 가중치로 첫 약학습기 학습**. 분할 t=5에서 두 개의 오답 발생.

2단계: **오답 가중치 증가**. 두 오답 샘플의 점이 크게 부풀어 오르고, 정답 샘플들은 작아진다.

3단계: **새 가중치로 두 번째 약학습기 학습**. 부풀어 오른 오답을 더 신경 쓴 새 분할 t=4가 선택된다.

</details>


![04 alpha curve](figs/04_alpha_curve.png)

<sub>그림 1-2. 약학습기 가중치 α는 오차율에 따라 결정된다.</sub>

**개념 8.** 약학습기 가중치 α의 직관:

- **잘 맞춘 약학습기** (오차율 낮음): α가 ____________________
- **무작위 수준 약학습기** (오차율 0.5): α = ____
- **무작위보다 나쁜 약학습기** (오차율 > 0.5): α가 ____________________

<details><summary>▶ 정답 보기</summary>

크다 / 0 / 음수(반대로 사용)

</details>

**개념 9.** AdaBoost가 이상치에 위험한 이유 — 매 라운드마다 **진짜로 잡을 수 없는 잡음 샘플**의 가중치가 ____________________ 오르고, 다음 약학습기가 그 샘플에 **더 신경**을 쓰지만 **진짜 정보가 없으므로 맞출 수가 없다**. 결국 **진짜 신호에서 멀어지고 잡음에 끌려간다**.

<details><summary>▶ 정답 보기</summary>

부풀어

</details>

---

## 2장 약학습기의 누적 — 결정 경계가 어떻게 정교해지나

![03 boundary evolution](figs/03_boundary_evolution.png)

<sub>그림 2-1. AdaBoost의 누적 — 약학습기가 쌓일수록 경계가 정교해진다.</sub>

**개념 10.** 부스팅의 핵심 통찰을 한 줄로:

> **단순한 모델 여러 개의** ____________________ **이 복잡한 모델 하나의 효과를 낸다.**

<details><summary>▶ 정답 보기</summary>

가중 합(weighted sum)

</details>

**그림 해석.** 그림 2-1에서 트리 1개와 트리 100개의 결정 경계 차이를 적어 보자.

<details><summary>▶ 정답 보기</summary>

**트리 1개**: 결정 경계가 **직선 한 줄**뿐이다. 초승달 모양의 두 클래스를 깔끔하게 가를 수 없다.

**트리 100개**: 단순한 직선 100개를 가중 합한 결과, 매우 **정교한 곡선 경계**가 만들어진다. 두 초승달의 곡선 형태를 잘 따라간다.

</details>

**개념 11.** 분류에서 최종 예측은 모든 약학습기의 ____________________ 다. 회귀에서는 평균 대신 ____________________ 을 쓰는데, 그 이유는 **____________________ 에 강한 통계량** 이기 때문이다.

<details><summary>▶ 정답 보기</summary>

가중 다수결 / 가중 중앙값 / 이상치(outlier)

</details>

**코드 빈칸.** AdaBoostClassifier의 약학습기 가중치 들여다보기.

```python
from sklearn.ensemble import AdaBoostClassifier

clf = AdaBoostClassifier(n_estimators=50, random_state=42)
clf.fit(X_moon, y_moon)

alphas = clf.____________________   # 각 약학습기의 α
errors = clf.____________________    # 각 약학습기의 오차율

print(f"α 최댓값: {alphas.max():.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
alphas = clf.estimator_weights_
errors = clf.estimator_errors_
```

학습이 진행될수록 약학습기의 오차율이 **0.5에 가까워진다**. 남은 오답이 점점 어려운 샘플들이기 때문이다.

</details>

---

## 3장 AdaBoost.R2 — 회귀로의 확장
**개념 12.** 분류와 회귀의 결정적 차이 — 분류에서는 **맞았나 틀렸나**의 ____________________ 신호지만, 회귀에서는 **얼마만큼 빗나갔는지**가 ____________________ 값이다.

<details><summary>▶ 정답 보기</summary>

0/1 (binary) / 연속(continuous)

</details>

**개념 13.** AdaBoost.R2는 ____________________ 년 ____________________ 가 제안한 회귀로의 확장이다. sklearn의 ____________________ 가 이를 구현한다.

<details><summary>▶ 정답 보기</summary>

1997 / Drucker / AdaBoostRegressor

</details>

**개념 14.** AdaBoost.R2의 최종 예측은 ____________________ 이다. 가중 평균이 아닌 이유는 ____________________ 에 강한 통계량이기 때문이다. 그러나 **최종 예측이 강해도 가중치 갱신 자체가 이상치에 끌려간다**는 함정이 있다.

<details><summary>▶ 정답 보기</summary>

가중 중앙값(weighted median) / 이상치(outlier)

</details>

**개념 15.** sklearn의 `AdaBoostRegressor`는 기본 약학습기로 깊이 ____ 결정 트리를 쓴다. 분류 기본은 깊이 1(결정 그루터기)이지만 회귀에서는 **너무 ____________________**. 회귀의 표준은 깊이 ____________________ 다.

<details><summary>▶ 정답 보기</summary>

3 / 약하다(weak) / 3~5

</details>

**코드 빈칸.** AdaBoostRegressor의 약학습기 깊이 변경.

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor

base = DecisionTreeRegressor(max_depth=____, random_state=42)
ada = AdaBoostRegressor(____________________=base,  # 약학습기 지정 매개변수
                         n_estimators=50, random_state=42)
```

<details><summary>▶ 정답 보기</summary>

```python
base = DecisionTreeRegressor(max_depth=5, random_state=42)
ada = AdaBoostRegressor(estimator=base, ...)
```

sklearn 1.4 이전은 `base_estimator=base` 였으나 1.4부터 `estimator=base` 로 변경되었다.

</details>

---

## 4장 AdaBoost.M1과 AdaBoost.R2 — 두 변종의 차이

![07 M1 vs R2](figs/07_M1_vs_R2.png)

<sub>그림 4-1. AdaBoost.M1(분류)과 AdaBoost.R2(회귀)의 비교.</sub>

**개념 1.** 두 변종의 차이를 표로 완성하라.

| 항목 | AdaBoost.M1 | AdaBoost.R2 |
|---|---|---|
| 용도 | ____________________ | ____________________ |
| 발표 연도 | 1995 | ____________________ |
| 최종 예측 | α 가중 ____________________ | α 가중 ____________________ |
| 이상치 민감도 | 보통 | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 항목 | AdaBoost.M1 | AdaBoost.R2 |
|---|---|---|
| 용도 | **분류** | **회귀** |
| 발표 연도 | 1995 | **1997** |
| 최종 예측 | α 가중 **다수결** | α 가중 **중앙값** |
| 이상치 민감도 | 보통 | **매우 민감** |


</details>

**개념 2.** AdaBoost.M1의 이상치 처리 — 분류에서는 각 샘플이 **맞았나 틀렸나**의 ____________________ 신호만 받는다. 이상치 한 점이 **틀렸다**는 사실만 전해질 뿐, 그 **얼마나 비싼 이상치인가**는 알고리즘에 들어가지 않는다.

<details><summary>▶ 정답 보기</summary>

0/1 (binary)

</details>

**개념 3.** AdaBoost.R2의 이상치 민감성 — 회귀는 ____________________ 손실을 직접 가중치 갱신에 쓴다. 손실이 100배 큰 이상치는 가중치도 ____________________ 배 가까이 부풀어 오른다.

<details><summary>▶ 정답 보기</summary>

연속(continuous) / 100

</details>

**개념 4.** 두 변종의 한 줄 요약:

- AdaBoost.M1은 분류의 ____________________ 신호를 받아 잘 작동한다.
- AdaBoost.R2는 회귀의 ____________________ 손실을 받는데, ____________________ 에 민감하다.

<details><summary>▶ 정답 보기</summary>

0/1 / 연속 / 이상치(outlier)

</details>

---

## 5장 AdaBoost의 핵심 매개변수
**개념 5.** AdaBoost의 두 핵심 매개변수는 ____________________ (약학습기 수)와 ____________________ (학습률)이다. 두 매개변수는 ____________________ 관계로, 한쪽을 절반으로 줄이면 다른 쪽을 두 배로 늘려야 비슷한 성능에 도달한다.

<details><summary>▶ 정답 보기</summary>

n_estimators / learning_rate / 반비례(trade-off)

</details>

**개념 6.** 3부의 RF와 달리 AdaBoost는 약학습기 수가 너무 크면 ____________________ 의 위험이 있다. 학습 데이터의 **잡음**까지 학습하기 시작하기 때문이다.

<details><summary>▶ 정답 보기</summary>

과적합(overfitting)

</details>


![05 learning rate](figs/05_learning_rate.png)

<sub>그림 5-1. 학습률의 효과 — 작으면 부족, 크면 흔들림.</sub>

**그림 해석.** 그림 5-1의 세 학습률을 한 단어로 평가하라.

- 학습률 0.01: ____________________
- 학습률 0.3:  ____________________
- 학습률 1.5:  ____________________

<details><summary>▶ 정답 보기</summary>

학습률 0.01: **부족** (부스팅이 시작도 못 한 상태)
학습률 0.3:  **균형** (좋은 균형점)
학습률 1.5:  **과적합** (예측이 흔들림)

</details>

**개념 7.** 두 매개변수의 ____________________ 이 **총 부스팅 양**을 결정한다. 예를 들어 (n=50, lr=1.0)과 (n=100, lr=0.5)는 거의 같은 R²에 도달한다.

<details><summary>▶ 정답 보기</summary>

곱(product)

</details>

**개념 8.** 안정적 성능을 원할 때 권장 매개변수 조합:

- n_estimators = ____________________
- learning_rate = ____________________
- base_estimator depth = ____________________

<details><summary>▶ 정답 보기</summary>

100~200 / 0.3~0.5 / 3~5

</details>

**코드 빈칸.** 학습률에 따른 함수 근사 비교.

```python
from sklearn.ensemble import AdaBoostRegressor

for lr in [0.01, 0.3, 1.5]:
    ada = AdaBoostRegressor(n_estimators=50, learning_rate=____, random_state=42)
    ada.fit(X, y_noisy)
    y_pred = ada.____(X)
    r2 = r2_score(y_noisy, y_pred)
    print(f"lr={lr}: R² = {r2:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
learning_rate=lr
y_pred = ada.predict(X)
```

작은 학습률(0.01)은 부족, 중간(0.3)은 균형, 큰 값(1.5)은 흔들린다.

</details>

---

## 6장 Ames에서의 AdaBoost — 잘 작동하는 사례
**개념 9.** Ames에서 AdaBoost의 CV R²는 약 ____________________ 로, ____________________ 와 비슷한 수준이다. **랜덤 포레스트**(0.88)에 약 ____________________ 포인트 뒤진다.

<details><summary>▶ 정답 보기</summary>

0.80~0.81 / 선형회귀 / 0.07~0.08

</details>

**개념 10.** Ames에서 AdaBoost와 RF의 변수 중요도를 비교하면, 둘 다 ____________________ 이 압도적 1위다. 그러나 2~5위는 약간 다르며, 일반적으로 부스팅 계열이 **덜 강한 변수의 기여도**도 ____________________ (잘 / 못) 잡아낸다.

<details><summary>▶ 정답 보기</summary>

Overall Qual / 잘

</details>

**코드 빈칸.** 다섯 모델 한 표로 비교.

```python
models = {
    "선형회귀":         LinearRegression(),
    "결정 트리":        DecisionTreeRegressor(random_state=42),
    "RF 100":           RandomForestRegressor(n_estimators=____, random_state=42, n_jobs=-1),
    "AdaBoost 50":      AdaBoostRegressor(n_estimators=____, random_state=42),
}

for name, m in models.items():
    r2 = cross_val_score(m, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"{name}: R² = {r2:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
n_estimators=100   # RF
n_estimators=50    # AdaBoost
```

이 표가 Ames에서 **AdaBoost(0.81)가 선형회귀(0.80)와 비슷하고 RF(0.88)에 뒤지는** 사실을 한 줄로 보여 준다.

</details>

---

## 7장 캘리포니아에서의 실패 — AdaBoost의 약점

![06 california failure](figs/06_california_failure.png)

<sub>그림 7-1. 캘리포니아 데이터에서 AdaBoost가 실패하는 이유 — 이상치 민감성.</sub>

**개념 1.** 캘리포니아 데이터에서 세 모델의 CV R²를 적어 보자.

| 모델 | 캘리포니아 CV R² |
|---|---|
| 선형회귀 | ____________________ |
| 랜덤 포레스트 100 | ____________________ |
| AdaBoost 50 | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 모델 | 캘리포니아 CV R² |
|---|---|
| 선형회귀 | **0.56** |
| 랜덤 포레스트 100 | **0.51** |
| AdaBoost 50 | **0.23** |

AdaBoost가 **선형회귀의 절반**에도 못 미치는 충격적 결과다.

</details>

**개념 2.** 캘리포니아 데이터의 결정적 특징은 ____________________ 이다. 1990년 인구조사 수집 당시 **주택가격이 \$500,000 이상**인 경우 모두 \$500,001로 천장에 막혔다. 데이터의 약 ____________________ %가 이런 거짓 값이다.

<details><summary>▶ 정답 보기</summary>

capped 값 / 4.7

</details>

**그림 해석.** 그림 7-1의 왼쪽 패널을 보고 답하라.

- 가격 분포에서 \$500k 근처에 ____________________ 가 보인다.
- 그 위치에 ____________________ 건이 모여 있다.
- 이 값들은 모두 ____________________ 데이터 수집 결과다.

<details><summary>▶ 정답 보기</summary>

뾰족한 봉우리(spike) / 약 1,000건 (965건) / capped(천장에 막힌)

</details>

**개념 3.** AdaBoost가 **왜 RF나 선형회귀보다 더 심하게 실패하는가**. 답은 가중치 갱신 메커니즘에 있다.

이상치 샘플은 **영원히** ____________________ 이다. 진짜 정보가 없으므로 어떤 트리도 **진짜로 맞출 수 없다**. 그래서 매 라운드마다 가중치가 **____________________ 오르고**, 다음 트리는 **그 잘못된 신호에 더 매달린다**.

<details><summary>▶ 정답 보기</summary>

오답 / 부풀어

</details>

**개념 4.** capped 값 965건(4.7%)을 제거하고 다시 학습해도 AdaBoost R²가 거의 같다(0.23 → 0.24). 이는 **capped 값이 유일한 문제가 아니라** 데이터 자체에 다른 ____________________ 가 있고, AdaBoost가 그 모두에 ____________________ 반응한다는 신호다.

<details><summary>▶ 정답 보기</summary>

미세한 이상치 구조 / 민감하게

</details>

**개념 5.** 7장의 한 줄 결론을 적어 보자.

> AdaBoost.R2는 ____________________ 와 ____________________ 에 매우 민감하다. 깨끗한 데이터(Ames)에서는 RF와 비슷하지만, 노이즈가 많은 데이터(캘리포니아)에서는 RF에 ____________________ 뒤진다.

<details><summary>▶ 정답 보기</summary>

잡음(noise) / 이상치(outlier) / 크게

</details>

**코드 빈칸.** capped 값 제거 전후 비교.

```python
mask = y_cal < y_cal.____()      # capped 값(=최댓값) 제거 마스크
X_cal_clean = X_cal[____]
y_cal_clean = y_cal[____]

for name, m in models.items():
    r2_full  = cross_val_score(m, X_cal, y_cal, cv=5, scoring="r2", n_jobs=-1).mean()
    r2_clean = cross_val_score(m, X_cal_clean, y_cal_clean, cv=5, scoring="r2", n_jobs=-1).____()
    print(f"{name}: 원본 {r2_full:.4f} → 제거 후 {r2_clean:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
mask = y_cal < y_cal.max()
X_cal_clean = X_cal[mask]
y_cal_clean = y_cal[mask]
.mean()
```

capped 4.7%를 제거해도 AdaBoost R²가 거의 안 좋아진다. 알고리즘 자체의 약점이라는 증거다.

</details>

---

## 8장 GBM으로의 다리 — 손실함수 일반화

![08 boosting lineage](figs/08_boosting_lineage.png)

<sub>그림 8-1. 부스팅 가족의 진화.</sub>

**개념 6.** 1999년 Friedman·Hastie·Tibshirani의 발견 — AdaBoost가 사실은 ____________________ 손실을 최소화하는 알고리즘이다. 이 손실의 특징은 오차가 커질수록 손실이 ____________________ 으로 폭증한다는 것이다.

<details><summary>▶ 정답 보기</summary>

지수(exponential) / 지수적(exponentially)

</details>

**개념 7.** 2001년 Friedman의 답 — **다른 손실함수를 쓰자**. 이것이 ____________________ (Gradient Boosting Machine)이다. 각 라운드에서 손실함수의 ____________________ 방향으로 한 걸음씩 간다.

<details><summary>▶ 정답 보기</summary>

GBM / 음의 그래디언트(negative gradient)

</details>

**개념 8.** 회귀의 손실함수와 이상치 견고성을 표로:

| 손실 | 빗나갈수록 손실이 | 이상치 견고성 |
|---|---|---|
| 지수 (AdaBoost) | 지수적으로 폭증 | ____________________ |
| 제곱 (GBM 기본) | 제곱적으로 증가 | ____________________ |
| 절대 | 선형적으로 증가 | ____________________ |
| Huber | 작은 오차는 제곱, 큰 오차는 절대값 | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 손실 | 견고성 |
|---|---|
| 지수 | **매우 약함** |
| 제곱 | **보통** |
| 절대 | **강함** |
| Huber | **두 마리 토끼** (일반 잡음은 잘 학습, 이상치는 강건) |


</details>

**개념 9.** 가장 직관적인 GBM — **제곱 손실**을 쓰는 GBM은 한 줄로 설명 가능하다.

> 각 라운드의 새 트리는 직전 라운드의 ____________________ 를 학습한다.

첫 트리가 가격을 예측하면 **예측과 실제 가격의 차이**가 남는다. 두 번째 트리는 **그 차이를 학습한다**. 이렇게 **차이를 점점 줄여 나가는 트리들의 누적**이 GBM이다.

<details><summary>▶ 정답 보기</summary>

잔차(residual)

</details>

**개념 10.** 부스팅 가족 진화를 시간 순으로:

____________________ (1995, 가중치 부스팅) → ____________________ (2001, 경사 부스팅) → ____________________ (2014) → LightGBM (2017) → CatBoost (2017).

<details><summary>▶ 정답 보기</summary>

AdaBoost / GBM / XGBoost

</details>

---

## 응용 문제 — 직접 풀어 보기

각 문제의 코드를 실행하여 결과를 확인한 뒤 정답 토글로 비교하자.

**문제 1.** 결정 그루터기 한 그루의 단독 R²와 그것을 50개 누적한 AdaBoost의 R² 차이를 측정하라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor

stump = DecisionTreeRegressor(max_depth=1, random_state=42)
ada = AdaBoostRegressor(estimator=DecisionTreeRegressor(max_depth=1, random_state=42),
                         n_estimators=50, random_state=42)

r2_stump = cross_val_score(stump, X_ames, y_ames, cv=5, scoring="r2").mean()
r2_ada = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2").mean()

print(f"단독: {r2_stump:.4f}")
print(f"누적: {r2_ada:.4f}")
print(f"차이: {r2_ada - r2_stump:.4f}")
```

단독은 R² 약 0.40, 50개 누적은 약 0.75 — **약 0.35 점프**. 약학습기 누적의 위력이 한 줄로 확인된다.

</details>

**문제 2.** Ames에서 AdaBoost와 RF의 변수 중요도 상위 5위를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
ada = AdaBoostRegressor(n_estimators=100, random_state=42).fit(X_ames, y_ames)
rf = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1).fit(X_ames, y_ames)

ada_imp = pd.Series(ada.feature_importances_, index=X_ames.columns).nlargest(5)
rf_imp = pd.Series(rf.feature_importances_, index=X_ames.columns).nlargest(5)

print("AdaBoost 상위 5:")
print(ada_imp)
print("\nRF 상위 5:")
print(rf_imp)
```

둘 다 `Overall Qual`이 1위지만 2~5위에서 차이가 난다. AdaBoost가 **덜 강한 변수의 기여도**도 더 잘 잡아낸다.

</details>

**문제 3.** 캘리포니아 데이터에서 capped 값을 제거한 뒤 AdaBoost R²가 얼마나 개선되는지 측정하라.

<details><summary>▶ 정답 보기</summary>

```python
mask = y_cal < y_cal.max()
X_clean, y_clean = X_cal[mask], y_cal[mask]

ada = AdaBoostRegressor(n_estimators=50, random_state=42)
r2_full  = cross_val_score(ada, X_cal, y_cal, cv=5, scoring="r2", n_jobs=-1).mean()
r2_clean = cross_val_score(ada, X_clean, y_clean, cv=5, scoring="r2", n_jobs=-1).mean()

print(f"원본:    {r2_full:.4f}")
print(f"제거 후: {r2_clean:.4f}")
print(f"개선:    {r2_clean - r2_full:.4f}")
```

개선이 **거의 없다** (보통 0.01 미만). capped 값 제거가 AdaBoost의 실패를 해결하지 못한다 — **알고리즘 자체의 약점**이다.

</details>

**문제 4.** 학습률(learning_rate)을 1.0, 0.5, 0.1로 바꿔가며 R²를 비교하라.

<details><summary>▶ 정답 보기</summary>

```python
for lr in [1.0, 0.5, 0.1]:
    ada = AdaBoostRegressor(n_estimators=100, learning_rate=lr, random_state=42)
    r2 = cross_val_score(ada, X_ames, y_ames, cv=5, scoring="r2", n_jobs=-1).mean()
    print(f"lr={lr}: R² = {r2:.4f}")
```

lr=0.1은 100그루로는 부족, lr=1.0은 빠르게 오르지만 과적합 위험, lr=0.5가 가장 안정적이다.

</details>

---

## 다음 부 예고 — 5부 GBM

다음 부에서는 **GBM**(Gradient Boosting Machine)을 다룬다. 같은 부스팅 정신이지만 **이상치에 강건한 손실함수**(제곱·절대·Huber)를 자유롭게 선택할 수 있다.

미리 던지는 질문 — 캘리포니아 데이터에서 **AdaBoost R²가 0.23** 이었던 그 데이터에 GBM을 적용하면 R²가 어디까지 오를까?

<details><summary>▶ 정답 보기</summary>

GBM 기본값(100그루, lr=0.1, depth=3)에서 약 R² **0.59**로 점프한다. 매개변수 조정(300그루, lr=0.05, depth=5)하면 약 **0.62**까지 오른다. AdaBoost(0.23)에서 GBM(0.59~0.62)으로 **2.5배 이상 개선**되며, RF(0.51)보다도 명확히 앞선다.

이게 5부의 핵심 결론이다 — **손실함수 선택이 알고리즘 자체보다 더 중요할 수 있다**.

</details>
