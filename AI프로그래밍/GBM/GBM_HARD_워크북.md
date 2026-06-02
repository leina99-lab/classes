# 5부 학생 워크북 — GBM

## 어려운 버전 — 학부 1~2학년용

이 워크북은 이론 교재 `00_gbm_theory_HARD.md`를 읽으면서 함께 채우는 자가학습 자료이다. 교재의 0~8장 흐름을 그대로 따라가며, 각 장의 핵심 개념과 코드를 빈칸으로 두었다. 빈칸을 채운 뒤 바로 아래의 **정답 보기**를 펼쳐 확인할 수 있다.

이름: ____________________   학번: ____________________   날짜: ____________________

---

## 0장 GBM의 동기 — 왜 손실함수 일반화인가

![02 adaboost vs gbm](figs/02_adaboost_vs_gbm.png)

<sub>그림 0-1. AdaBoost와 GBM의 작동 원리 비교.</sub>

**개념 1.** 4부에서 AdaBoost가 ____________________ 손실 $L(y, F) = \exp(-yF)$을 최소화하는 알고리즘임을 봤다. 이 손실의 특징은 오답에 대한 페널티가 ____________________ 폭증한다는 것이다. 캘리포니아에서 AdaBoost의 R² 0.23이 이 손실의 직접적 결과다.

<details><summary>▶ 정답 보기</summary>

지수(exponential) / 지수적으로

</details>

**개념 2.** 2001년 Friedman의 GBM 핵심 발상을 한 줄로 적으면 — 각 라운드에서 손실함수의 ____________________ 를 새 약학습기로 근사한다.

<details><summary>▶ 정답 보기</summary>

음의 그래디언트(negative gradient)

</details>

**그림 해석.** 그림 0-1을 보고 AdaBoost와 GBM의 핵심 차이 세 가지를 적어 보자.

| 구분 | AdaBoost | GBM |
|---|---|---|
| 무엇을 갱신하는가 | ____________________ | ____________________ |
| 다음 트리가 학습하는 것 | ____________________ | ____________________ |
| 손실함수 | ____________________ | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 구분 | AdaBoost | GBM |
|---|---|---|
| 무엇을 갱신하는가 | **샘플 가중치** | **누적 예측 함수 F_t(x)** |
| 다음 트리가 학습하는 것 | **재가중된 데이터** | **잔차 y - F_{t-1}(x)** (제곱 손실) |
| 손실함수 | **지수 손실 고정** | **자유 선택** (제곱·절대·Huber·로그) |


</details>

**개념 3.** GBM의 일반적 알고리즘에서 **유사 잔차**(pseudo-residual)는 다음과 같이 정의된다.

$$r_{i,t} = -\frac{\partial L(y_i, F(x_i))}{\partial F(x_i)}\bigg|_{F=F_{t-1}}$$

이 값은 **손실을 가장 빠르게 줄이는** ____________________ 이다. 제곱 손실의 경우 유사 잔차는 ____________________ 와 같다.

<details><summary>▶ 정답 보기</summary>

방향(direction) / 잔차 (y - F)

</details>

**개념 4.** GBM의 한 라운드는 다섯 단계로 표현된다. 비어 있는 곳을 채워 보자.

- Step 0: $F_0(x) = \arg\min_c \sum L(y_i, c)$ — 제곱 손실이면 ____________________
- Step 1: 각 샘플의 ____________________ 계산
- Step 2: 결정 트리 $h_t(x)$를 학습하여 ____________________ 를 근사
- Step 3: 단계 길이 $\gamma_t$ 결정 (라인 서치)
- Step 4: $F_t(x) = F_{t-1}(x) + \eta \cdot \gamma_t \cdot h_t(x)$

<details><summary>▶ 정답 보기</summary>

$\bar{y}$ (평균) / 유사 잔차 / 유사 잔차

</details>

---

## 1장 잔차 학습 — 제곱 손실 GBM의 직관
**개념 5.** 제곱 손실 $L = \frac{1}{2}(y - F)^2$의 $F$에 대한 편미분은 $-(y - F)$이다. 따라서 음의 그래디언트는 ____________________ 와 같다. GBM의 각 라운드는 직전 라운드의 ____________________ 를 새 트리로 학습한다.

<details><summary>▶ 정답 보기</summary>

잔차 (y - F) / 잔차

</details>


![01 residual boosting](figs/01_residual_boosting.png)

<sub>그림 1-1. 잔차 부스팅의 직관 — 라운드가 진행될수록 잔차의 표준편차가 줄어든다.</sub>

**그림 해석.** 그림 1-1의 잔차 표준편차 진화를 적어 보자.

- Round 0 (평균만 예측): 잔차 표준편차 ____________________
- Round 1 (트리 1개 추가): 잔차 표준편차 ____________________
- Round 5 (트리 5개 누적): 잔차 표준편차 ____________________

<details><summary>▶ 정답 보기</summary>

1.06 / 0.60 / 0.21

5라운드만에 잔차 표준편차가 **원래의 약 1/5 수준**까지 떨어졌다. 각 라운드의 새 트리가 **남은 잔차 구조**를 잡아내며 함수 근사를 정교화한다.

</details>

**코드 빈칸.** 잔차 부스팅 직접 구현 — GBM의 핵심 10줄.

```python
from sklearn.tree import DecisionTreeRegressor
import numpy as np

lr = 0.1
n_est = 50
F = np.full(len(y), y.____())   # 시작: 평균 예측

for t in range(n_est):
    residual = y - ____                                        # 잔차 계산
    tree = DecisionTreeRegressor(max_depth=3, random_state=t)
    tree.fit(X, ____)                                          # 잔차 학습
    F = F + ____ * tree.predict(X)                             # 모델 갱신
```

<details><summary>▶ 정답 보기</summary>

```python
F = np.full(len(y), y.mean())   # 시작: 평균
residual = y - F                # 잔차 = 실제 - 누적예측
tree.fit(X, residual)           # 잔차를 학습 타깃으로
F = F + lr * tree.predict(X)    # 학습률만큼 더하기
```

이 코드의 결과가 sklearn `GradientBoostingRegressor`(loss='squared_error')와 **정확히 일치**한다. 잔차 부스팅 = 제곱 손실 GBM의 등식이 직접 확인된다.

</details>

**개념 6.** 잔차 부스팅 직접 구현과 sklearn GBM의 R² 차이는 약 ____________________ 다. 이는 두 알고리즘이 **수학적으로 동등**함을 보여 준다.

<details><summary>▶ 정답 보기</summary>

0.000000 (완전히 일치)

</details>

---

## 2장 누적의 위력 — 평균에서 정교한 함수까지
**개념 7.** GBM의 마법은 **각 라운드의 약학습기는 매우 약한데, 누적된 결과는 매우 강하다**는 것이다. Ames에서 단일 트리(depth=3)의 R²는 약 ____________________ 이지만, GBM 50그루(같은 depth=3)의 R²는 약 ____________________ 까지 점프한다.

<details><summary>▶ 정답 보기</summary>

0.70 / 0.87 (약 17포인트 점프)

</details>

**코드 빈칸.** sklearn GBM의 누적 학습 곡선 그리기.

```python
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score

X_tr, X_te, y_tr, y_te = train_test_split(X_ames, y_ames, test_size=0.2, random_state=42)

gbm = GradientBoostingRegressor(n_estimators=200, learning_rate=0.1, max_depth=3, random_state=42)
gbm.fit(X_tr, y_tr)

# staged_predict로 누적 예측 yield
train_r2 = [r2_score(y_tr, p) for p in gbm.____(X_tr)]
test_r2  = [r2_score(y_te, p) for p in gbm.____(X_te)]
```

<details><summary>▶ 정답 보기</summary>

```python
gbm.staged_predict(X_tr)
gbm.staged_predict(X_te)
```

`staged_predict()`는 1, 2, ..., T그루까지의 누적 예측을 generator로 yield한다. 학습 곡선 그리기에 필수 메서드.

</details>


![04 lr n tradeoff](figs/04_lr_n_tradeoff.png)

<sub>그림 2-1. 학습률과 트리 수의 트레이드오프.</sub>

**그림 해석.** 그림 2-1에서 네 학습률 곡선의 패턴을 평가하라.

- lr=0.01: ____________________
- lr=0.1:  ____________________
- lr=0.5:  ____________________
- lr=1.0:  ____________________

<details><summary>▶ 정답 보기</summary>

- lr=0.01: **부족** — 200그루로도 부스팅이 충분히 진행 안 됨
- lr=0.1:  **균형점** — 50그루 근처에서 빠르게 정점 후 평탄 유지 (권장)
- lr=0.5:  **빠른 수렴** — 30그루에서 정점, 약간 흔들림
- lr=1.0:  **과적합** — 빠르게 오르지만 50그루 이후 검증 R² 하락

</details>

**개념 8.** GBM의 두 매개변수 학습률 $\eta$와 트리 수 $T$의 곱 $\eta T$가 ____________________ 을 결정한다. 일반적으로 **작은 학습률 + 많은 트리** 조합이 **큰 학습률 + 적은 트리**보다 더 ____________________.

<details><summary>▶ 정답 보기</summary>

총 부스팅 양 / 안정적(stable)

</details>

**개념 9.** GBM의 약학습기 깊이 권장값은 ____________________ 이다. AdaBoost 분류의 **깊이 1**과 다른 이유는 ____________________ 의 **지수 폭증**이 없어서 약학습기가 약간 강해도 안전하기 때문이다.

<details><summary>▶ 정답 보기</summary>

3~5 / 지수 손실

</details>

**개념 10.** RF의 OOB 점수처럼 GBM에서 **무료 검증**을 제공하는 메커니즘은 ____________________ 이다. sklearn의 `validation_fraction`과 `n_iter_no_change` 매개변수로 자동 조기 종료를 설정할 수 있다.

<details><summary>▶ 정답 보기</summary>

조기 종료(early stopping) + staged_predict

</details>

**코드 빈칸.** GBM 자동 조기 종료 설정.

```python
gbm = GradientBoostingRegressor(
    n_estimators=500,
    learning_rate=0.05,
    max_depth=5,
    ____________________=0.1,    # 학습 데이터 중 10%를 검증용으로
    ____________________=10,     # 10라운드 동안 개선 없으면 중단
    random_state=42
)
gbm.fit(X_ames, y_ames)
print(f"실제 사용된 트리 수: {gbm.____________________}")
```

<details><summary>▶ 정답 보기</summary>

```python
validation_fraction=0.1
n_iter_no_change=10
gbm.n_estimators_         # 학습 후 속성(끝에 _)
```

조기 종료가 작동하면 **최대 500**을 잡았어도 **과적합 시작점에서 자동 멈춤**. Ames에서 보통 100~300그루로 수렴한다.

</details>

---

## 3장 일반 그래디언트 부스팅 — 손실함수 일반화

![03 loss functions](figs/03_loss_functions.png)

<sub>그림 3-1. 회귀 손실함수 4종 비교.</sub>

**개념 1.** 손실함수의 음의 그래디언트가 **유사 잔차**다. 손실별로 유사 잔차의 형태를 적어 보자.

| 손실 | 식 $L(y, F)$ | 음의 그래디언트 |
|---|---|---|
| 제곱 | $\frac{1}{2}(y-F)^2$ | ____________________ |
| 절대 | $\|y - F\|$ | ____________________ |
| Huber ($\delta=1$) | 두 모드 | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 손실 | 음의 그래디언트 |
|---|---|
| 제곱 | $y - F$ (잔차) |
| 절대 | $\text{sign}(y - F)$ |
| Huber | 작은 잔차는 $y - F$, 큰 잔차는 $\delta \cdot \text{sign}(y - F)$ |


</details>

**그림 해석.** 그림 3-1의 네 손실함수의 **이상치 강건성**을 평가하라.

- 제곱:  ____________________
- 절대:  ____________________
- Huber: ____________________
- 지수:  ____________________

<details><summary>▶ 정답 보기</summary>

- 제곱:  **보통** — 오차가 커질수록 제곱적으로 증가하지만 **유한**
- 절대:  **강함** — 선형 증가, 단 0에서 미분 불가능
- Huber: **매우 강함** — 작은 오차는 제곱처럼·큰 오차는 절대값처럼 (두 마리 토끼)
- 지수:  **매우 약함** — AdaBoost의 손실, **지수적으로 폭증**

</details>

**개념 2.** Huber 손실의 특징은 매개변수 $\delta$를 기준으로 **두 모드**로 작동한다는 것이다.

- $|y - F| \le \delta$: ____________________ 손실처럼
- $|y - F| > \delta$: ____________________ 손실처럼

이상치(큰 잔차)는 부호 신호만 받지만, 일반 데이터는 그대로 잔차를 받는다. **두 마리 토끼**를 잡는 손실이다.

<details><summary>▶ 정답 보기</summary>

제곱(squared) / 절대(absolute)

</details>

**코드 빈칸.** 캘리포니아에서 손실함수별 R² 측정.

```python
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import cross_val_score

for loss in ["squared_error", "____________________", "____________________"]:
    gbm = GradientBoostingRegressor(loss=____, n_estimators=100, random_state=42)
    r2 = cross_val_score(gbm, X_cal, y_cal, cv=3, scoring="r2", n_jobs=-1).mean()
    print(f"{loss}: R² = {r2:.4f}")
```

<details><summary>▶ 정답 보기</summary>

```python
for loss in ["squared_error", "absolute_error", "huber"]:
    gbm = GradientBoostingRegressor(loss=loss, ...)
```

세 손실 모두 AdaBoost(0.232)를 압도적으로 능가한다 (R² 약 0.625~0.646).

</details>

**개념 3.** 분류 GBM의 표준 손실은 ____________________ 손실이며 식은 $L(y, F) = \log(1 + \exp(-yF))$다. AdaBoost의 **지수 손실**과 비교하면 **오답에 대한 페널티가** ____________________ 이다. 따라서 **무한 폭증**이 없다.

<details><summary>▶ 정답 보기</summary>

로그(log loss, cross-entropy) / 선형(linear)

</details>

---

## 4장 분위수 회귀와 GBM의 특수 사례
**개념 4.** **조건부 평균**이 아닌 **조건부 분위수**를 예측하고 싶을 때 사용하는 손실은 ____________________ 손실이다. 매개변수 $\alpha$로 분위수를 지정한다.

<details><summary>▶ 정답 보기</summary>

분위수(quantile)

</details>

**개념 5.** $\alpha$ 분위수 손실의 그래디언트는 다음과 같다.

$$r_i = \begin{cases} \_\_\_\_ & y_i \ge F(x_i) \\ \_\_\_\_ & y_i < F(x_i) \end{cases}$$

매 라운드마다 **각 샘플이 두 값 중 하나**의 신호를 보낸다.

<details><summary>▶ 정답 보기</summary>

$\alpha$ / $\alpha - 1$

예시: $\alpha = 0.9$이면 **과소 예측한 샘플**은 $+0.9$, **과대 예측한 샘플**은 $-0.1$을 받는다. 모델은 **위쪽으로 치우친 예측**을 학습한다.

</details>

**코드 빈칸.** 5%/50%/95% 분위수 GBM 세 개로 예측 구간 만들기.

```python
predictions = {}
for alpha in [0.05, 0.5, 0.95]:
    gbm = GradientBoostingRegressor(loss="____________________",
                                     alpha=____,
                                     n_estimators=100, random_state=42)
    gbm.fit(X_ames, y_ames)
    predictions[alpha] = gbm.predict(X_ames)
```

<details><summary>▶ 정답 보기</summary>

```python
loss="quantile"
alpha=alpha
```

세 GBM의 출력으로 **예측 구간**(prediction interval)을 만들 수 있다. **주택 가격이 \$120k~\$180k 사이**라는 구간 예측이 가능해진다.

</details>

**개념 6.** 4장의 핵심 정리 — **하나의 알고리즘에** ____________________ **만 바꾸면 모든 지도학습 문제를 다룰 수 있다**. 회귀(제곱·절대·Huber·분위수)와 분류(로그·다항)와 랭킹·생존분석 등이 모두 같은 GBM 골격을 공유한다.

<details><summary>▶ 정답 보기</summary>

손실함수(loss function)

</details>

---

## 5장 GBM의 핵심 매개변수
**개념 7.** GBM의 **가장 결정적인 두 매개변수**는 ____________________ 와 ____________________ 다. 두 매개변수는 ____________________ 관계로, 학습률을 절반으로 줄이면 트리 수를 두 배로 늘려야 한다.

<details><summary>▶ 정답 보기</summary>

n_estimators (T) / learning_rate (η) / 반비례(trade-off)

</details>

**개념 8.** GBM의 약학습기 깊이 권장값을 한 단어로:

- AdaBoost 분류: 깊이 ____ (결정 그루터기)
- AdaBoost 회귀: 깊이 ____ 
- **GBM** (회귀·분류): 깊이 ____________________

이유는 GBM의 **제곱·로그 손실**에는 ____________________ 의 지수 폭증이 없기 때문이다.

<details><summary>▶ 정답 보기</summary>

1 / 3 / 3~5 / AdaBoost (지수 손실)

</details>


![06 subsample effect](figs/06_subsample_effect.png)

<sub>그림 5-1. subsample 매개변수의 효과.</sub>

**개념 9.** **확률적 그래디언트 부스팅**은 각 라운드에서 학습 샘플의 ____________________ 만 무작위로 선택하여 트리를 학습한다. 매개변수는 ____________________ 이며, 권장값은 ____________________ 사이다.

<details><summary>▶ 정답 보기</summary>

일부(subset) / subsample / 0.5~0.8

</details>

**개념 10.** 확률적 GBM의 두 효과:

1. **과적합 위험** ____________________ — 각 트리가 다른 데이터를 봄
2. **학습 시간** ____________________ — 50%만 보면 시간이 거의 절반

<details><summary>▶ 정답 보기</summary>

감소(reduction) / 단축(reduction)

</details>


![07 staged overfitting](figs/07_staged_overfitting.png)

<sub>그림 5-2. GBM의 학습 곡선 — 너무 많은 트리는 과적합을 부른다.</sub>

**그림 해석.** 그림 5-2를 보고 답하라.

- 학습 R² 곡선의 진행 방향: ____________________
- 검증 R² 곡선의 진행 방향: ____________________
- 조기 종료의 최적 지점: ____________________ 그루

<details><summary>▶ 정답 보기</summary>

- 학습 R²: **계속 오름** (1에 수렴)
- 검증 R²: **약 100그루에서 정점 후 떨어짐** (과적합 시작)
- 최적 지점: **약 100그루** (녹색 점선 위치)

</details>

**개념 11.** GBM 매개변수 튜닝 우선순위를 적어 보자.

1. ____________________ × ____________________ (가장 중요)
2. ____________________ (보통 3, 5, 7 세 가지 시도)
3. ____________________ (0.7 또는 0.8)
4. 나머지는 보통 기본값으로 충분

<details><summary>▶ 정답 보기</summary>

1. learning_rate × n_estimators
2. max_depth
3. subsample

</details>

---

## 6장 Ames에서의 GBM — RF를 미세하게 능가
**개념 1.** Ames에서 다섯 모델의 CV R²를 적어 보자.

| 모델 | CV R² |
|---|---|
| 선형회귀 | ____________________ |
| 결정 트리 | ____________________ |
| 랜덤 포레스트 100 | ____________________ |
| AdaBoost 50 | ____________________ |
| **GBM 기본 100** | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 모델 | CV R² |
|---|---|
| 선형회귀 | **0.897** |
| 결정 트리 | **0.769** |
| 랜덤 포레스트 100 | **0.882** |
| AdaBoost 50 | **0.808** |
| **GBM 기본 100** | **0.890** |

GBM 기본값이 **RF를 거의 따라잡고** 튜닝하면 **미세하게 능가**한다.

</details>

**개념 2.** Ames에서 GBM이 RF보다 약간 더 좋은 이유는 편향-분산 분해에서 찾을 수 있다.

- RF는 ____________________ 만 줄인다 (편향은 단일 트리의 한계)
- GBM은 ____________________ 까지 줄인다 (잔차를 점점 정확히 학습)

이 **0.01 차이**가 편향 감소의 직접적 효과다.

<details><summary>▶ 정답 보기</summary>

분산(variance) / 편향(bias)

</details>

**개념 3.** GBM이 RF보다 약 ____________________ 배 느린 이유는 부스팅의 ____________________ 학습 때문이다. RF는 100그루를 **병렬**로 키울 수 있지만, GBM은 **한 그루씩 순서대로** 키워야 한다. 이 학습 속도 문제가 **6부 XGBoost·LightGBM·CatBoost**의 등장 배경이다.

<details><summary>▶ 정답 보기</summary>

4~15 / 순차(sequential)

</details>

**코드 빈칸.** 5개 모델 한 표로 비교.

```python
models = {
    "선형회귀":           LinearRegression(),
    "결정 트리":          DecisionTreeRegressor(random_state=42),
    "랜덤 포레스트 100":  RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1),
    "AdaBoost 50":        AdaBoostRegressor(n_estimators=50, random_state=42),
    "GBM 기본":           ____________________(n_estimators=100, random_state=42),
    "GBM 튜닝":           ____________________(n_estimators=200, learning_rate=____, max_depth=5, random_state=42),
}
```

<details><summary>▶ 정답 보기</summary>

```python
"GBM 기본":  GradientBoostingRegressor(n_estimators=100, random_state=42)
"GBM 튜닝":  GradientBoostingRegressor(n_estimators=200, learning_rate=0.05, max_depth=5, random_state=42)
```

</details>

---

## 7장 캘리포니아 회복 — AdaBoost(0.23) → GBM(0.65)

![05 california recovery](figs/05_california_recovery.png)

<sub>그림 7-1. 캘리포니아 회복 — GBM이 AdaBoost의 실패를 어떻게 극복하는가.</sub>

**개념 4.** 캘리포니아 데이터에서 모델별 CV R²를 적어 보자.

| 모델 | California CV R² |
|---|---|
| AdaBoost 50 | ____________________ |
| 랜덤 포레스트 100 | ____________________ |
| **GBM 기본** | ____________________ |
| **GBM (Huber)** | ____________________ |


<details><summary>▶ 정답 보기</summary>

| 모델 | California CV R² |
|---|---|
| AdaBoost 50 | **0.232** |
| 랜덤 포레스트 100 | **0.507** |
| **GBM 기본** | **0.646** |
| **GBM (Huber)** | **0.646** |

GBM이 AdaBoost를 **약 2.8배 능가**한다. 손실함수 일반화 하나가 만들어 낸 차이다.

</details>

**개념 5.** GBM이 캘리포니아에서 안 무너지는 이유는 ____________________ 다. 제곱 손실의 페널티는 **제곱적**으로 증가하지만 **유한**하다. AdaBoost의 ____________________ 손실은 **지수적으로 폭증**했지만 GBM의 손실들은 그렇지 않다.

<details><summary>▶ 정답 보기</summary>

손실함수의 차이 / 지수(exponential)

</details>

**개념 6.** capped 값(\$500,001) 965건을 제거한 캘리포니아 데이터에서:

- AdaBoost R² 0.23 → ____________________ (거의 그대로, **알고리즘 자체의 약점**)
- GBM R² 0.65 → ____________________ (더 좋아짐, **이상치 제거 효과를 받음**)

<details><summary>▶ 정답 보기</summary>

0.24 / 0.69

AdaBoost는 이상치 제거에도 거의 회복 못함 → 알고리즘 자체가 잡음에 약함.
GBM은 **원본에서도 안 무너지면서** 이상치 제거 시 추가 개선 → 손실함수가 안전 마진을 제공.

</details>

**개념 7.** 캘리포니아에서 손실함수별 R² (cv=3):

- squared_error: ____________________
- absolute_error: ____________________ (그래디언트가 부호만이라 학습이 약간 느림)
- huber: ____________________

<details><summary>▶ 정답 보기</summary>

0.646 / 0.625 / 0.646

</details>

**개념 8.** 7장의 한 줄 결론:

> **GBM이 AdaBoost를** ____________________ **배 능가했다. 같은 데이터, 같은 부스팅 정신, 다른** ____________________.

<details><summary>▶ 정답 보기</summary>

2.8 / 손실함수(loss function)

</details>

---

## 8장 XGBoost로의 다리 — GBM이 잘하는데 왜 더 빠른 구현이 필요한가
**개념 9.** GBM의 두 가지 약점:

1. 학습 시간 — RF의 ____________________ 배 느림 (부스팅의 순차 학습)
2. 규제 부족 — sklearn의 GBM에는 **명시적** ____________________ ·____________________ 규제 옵션이 거의 없음

<details><summary>▶ 정답 보기</summary>

4~15 / L1 / L2

</details>

**개념 10.** XGBoost(2014, Tianqi Chen)가 GBM을 개선한 세 가지:

1. 손실의 ____________________ 미분(헤시안) 활용 → 더 정확한 단계 추정
2. 명시적 ____________________ — L1·L2 + 트리 복잡도 페널티
3. 시스템 수준 최적화 — 병렬 분할, 캐시, 결측치 자동 처리

<details><summary>▶ 정답 보기</summary>

2차 (second-order) / 규제(regularization)

</details>

**개념 11.** XGBoost의 정규화된 손실함수는 다음과 같다.

$$L_{\text{XGBoost}} = \sum_{i=1}^n L(y_i, F(x_i)) + \sum_{t=1}^T \Omega(h_t)$$

여기서 트리 규제 항 $\Omega(h_t) = \gamma T + \frac{1}{2}\lambda \sum_{j=1}^J w_j^2$가 의미하는 바는:

- $\gamma T$ : ____________________ 페널티
- $\lambda w_j^2$ : ____________________ 페널티

<details><summary>▶ 정답 보기</summary>

트리 잎 수 (트리 복잡도) / 잎 가중치의 L2

</details>


![08 xgboost bridge](figs/08_xgboost_bridge.png)

<sub>그림 8-1. 부스팅 가족의 진화.</sub>

**개념 12.** 부스팅 가족 세 현대 구현체의 강점을 한 단어로:

| 알고리즘 | 강점 | 권장 상황 |
|---|---|---|
| **XGBoost** (2014) | ____________________ | 중소 데이터, 캐글 |
| **LightGBM** (2017) | ____________________ | 대용량 데이터 |
| **CatBoost** (2017) | ____________________ | 범주형 변수 많음 |


<details><summary>▶ 정답 보기</summary>

| 알고리즘 | 강점 |
|---|---|
| XGBoost | **균형 잡힌 성능 + 다양한 규제** |
| LightGBM | **가장 빠름 + 메모리 효율** (XGBoost의 2~5배 빠름) |
| CatBoost | **범주형 자동 처리** (원-핫 없이) |


</details>

**개념 13.** 5부 결론 세 줄을 적어 보자.

1. GBM은 ____________________ 일반화로 AdaBoost의 약점을 해결했다.
2. 캘리포니아 회복(AdaBoost 0.23 → GBM 0.65)이 ____________________ 보다 ____________________ 가 중요할 수 있음을 증명한다.
3. GBM의 약점은 ____________________ 다. 이를 해결한 것이 XGBoost·LightGBM·CatBoost.

<details><summary>▶ 정답 보기</summary>

1. 손실함수
2. 알고리즘 / 손실함수
3. 학습 속도(순차 학습으로 느림)

</details>

---

## 응용 문제 — 직접 실행하며 풀기

각 문제의 코드를 실행하여 출력을 직접 확인한 뒤 정답 토글로 비교한다.

**문제 1.** 잔차 부스팅 직접 구현이 sklearn GBM과 같은 결과를 내는지 직접 검증하라.

<details><summary>▶ 정답 보기</summary>

```python
import numpy as np
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.metrics import r2_score
from sklearn.datasets import make_regression

X, y = make_regression(n_samples=500, n_features=10, noise=10, random_state=42)

# 직접 구현
F = np.full(len(y), y.mean())
for t in range(50):
    residual = y - F
    tree = DecisionTreeRegressor(max_depth=3, random_state=t)
    tree.fit(X, residual)
    F = F + 0.1 * tree.predict(X)
r2_manual = r2_score(y, F)

# sklearn
gbm = GradientBoostingRegressor(n_estimators=50, learning_rate=0.1, max_depth=3,
                                 random_state=42, loss="squared_error")
gbm.fit(X, y)
r2_sklearn = r2_score(y, gbm.predict(X))

print(f"직접 구현: {r2_manual:.6f}")
print(f"sklearn:  {r2_sklearn:.6f}")
print(f"차이:     {abs(r2_manual - r2_sklearn):.6f}")
```

차이가 **0.000000** 으로 정확히 일치한다 — 잔차 부스팅 = 제곱 손실 GBM.

</details>

**문제 2.** 학습률 0.01, 0.1, 0.5로 GBM 200그루를 학습하고 staged 학습 곡선을 그려라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score
import matplotlib.pyplot as plt
import koreanize_matplotlib

X_tr, X_te, y_tr, y_te = train_test_split(X_ames, y_ames, test_size=0.2, random_state=42)

fig, ax = plt.subplots(figsize=(9, 5))
for lr, color in [(0.01, "#5A8C5A"), (0.1, "#1F3A5F"), (0.5, "#C0392B")]:
    gbm = GradientBoostingRegressor(n_estimators=200, learning_rate=lr,
                                     max_depth=3, random_state=42)
    gbm.fit(X_tr, y_tr)
    r2_curve = [r2_score(y_te, p) for p in gbm.staged_predict(X_te)]
    ax.plot(range(1, 201), r2_curve, color=color, label=f"lr={lr}")
ax.legend(); ax.grid(alpha=0.3)
ax.set_xlabel("n_estimators"); ax.set_ylabel("Test R²")
plt.show()
```

lr=0.01은 너무 느려 200그루로도 부족. lr=0.1은 안정적 균형. lr=0.5는 빠르게 정점 후 과적합으로 떨어진다.

</details>

**문제 3.** 캘리포니아에서 손실함수 3종(squared_error, absolute_error, huber)의 CV R²를 측정하라.

<details><summary>▶ 정답 보기</summary>

```python
from sklearn.ensemble import GradientBoostingRegressor

for loss in ["squared_error", "absolute_error", "huber"]:
    gbm = GradientBoostingRegressor(loss=loss, n_estimators=100, random_state=42)
    r2 = cross_val_score(gbm, X_cal, y_cal, cv=3, scoring="r2", n_jobs=-1).mean()
    print(f"{loss:<18s}: R² = {r2:.4f}")
```

세 손실 모두 AdaBoost(0.232)를 압도. squared_error와 huber가 약 0.646, absolute_error가 약간 낮은 0.625.

</details>

**문제 4.** 5%, 50%, 95% 분위수 GBM으로 Ames 첫 10채의 예측 구간을 만들어 보라.

<details><summary>▶ 정답 보기</summary>

```python
predictions = {}
for alpha in [0.05, 0.5, 0.95]:
    gbm = GradientBoostingRegressor(loss="quantile", alpha=alpha,
                                     n_estimators=100, random_state=42)
    gbm.fit(X_ames, y_ames)
    predictions[alpha] = gbm.predict(X_ames)

print(f"{'i':>3} {'5%':>10} {'50%':>10} {'95%':>10} {'실제':>10}")
for i in range(10):
    print(f"{i:>3} "
          f"{predictions[0.05][i]:>10.4f} "
          f"{predictions[0.5][i]:>10.4f} "
          f"{predictions[0.95][i]:>10.4f} "
          f"{y_ames.iloc[i]:>10.4f}")
```

세 분위수 GBM이 만드는 **예측 구간**. 실제 값이 5%와 95% 사이에 들어가야 정상.

</details>

**문제 5.** GBM의 조기 종료(early stopping)를 켜고 실제 사용된 트리 수를 확인하라.

<details><summary>▶ 정답 보기</summary>

```python
gbm = GradientBoostingRegressor(
    n_estimators=500,            # 최대
    learning_rate=0.05,
    max_depth=5,
    validation_fraction=0.1,
    n_iter_no_change=20,
    tol=0.0001,
    random_state=42
)
gbm.fit(X_ames, y_ames)
print(f"최대 트리 수:    500")
print(f"실제 사용된 트리: {gbm.n_estimators_}")
```

보통 **150~300그루**에서 자동 종료. 과적합 시작 직전에서 멈춤.

</details>

---

## 다음 부 예고 — 6부 XGBoost·LightGBM·CatBoost

다음 부에서는 **GBM의 세 가지 현대적 구현체**를 다룬다. 같은 GBM 알고리즘이지만 **각자 다른 강점**을 가졌다.

흥미로운 예고 하나 — 이 셋 중 **Ames에서 가장 좋은 R²를 내는 알고리즘**은 무엇일까? 각각 어떤 **데이터에서** 가장 빛날까?

<details><summary>▶ 정답 보기</summary>

Ames(약 2,900행)에서는 **세 알고리즘 모두 R² 0.89~0.91 범위**로 거의 같다. 작은 데이터에서는 차이가 미미하다.

큰 데이터(수십만 행 이상)에서 비로소 차이가 드러난다:
- **XGBoost**: 균형 잡힌 선택, 다양한 규제 옵션
- **LightGBM**: XGBoost의 2~5배 빠름 (대용량 데이터 표준)
- **CatBoost**: 범주형 변수 많은 데이터에서 원-핫 인코딩 없이도 좋은 성능

캐글 우승자들은 보통 **두세 가지를 학습한 뒤 앙상블**한다 — 각자 다른 종류의 패턴을 잡기 때문이다.

</details>
