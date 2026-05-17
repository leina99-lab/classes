# Regularization — 학생용 설명 글

> 이 글은 노트북 `Regularization_notebook.ipynb` 의 흐름을 한국어 학술문어체로 풀어 설명한 자료이다.  
> OLS · PCA · Deming 의 세 노트북에서 \"같은 미분, 다른 제약, 한 가족\" 이라는 그림을 보았다면,  
> 본 글에서는 **OLS 의 가족 안에서 또 한 차례의 분기** — 정규화 회귀 — 를 다룬다.

---

## 0.  자료의 위치

세 자료 다음에 본 자료가 온다.

```
OLS (편미분으로 정규방정식)
  └─ 한계 1: X 에 측정오차 ──────→ Deming 회귀
  └─ 한계 2: 변수 너무 많음 ─────→ 주성분 회귀 (PCA 의 응용)
  └─ 한계 3: 다중공선성 / 과적합 ─→ Ridge · Lasso · ElasticNet  ← 본 자료
```

세 답 모두 \"OLS 의 손실함수에 무엇인가를 더하거나 빼서 행렬 미분 = 0 을 다시 푼다\" 라는 공통 사고방식 위에 있다. 본 자료는 그 마지막 가지이며, 사실상 가장 자주 쓰이는 가지이다.

---

## 1.  회귀분석을 언제 하는가

회귀는 \"한 변수의 값을 다른 변수들로 예측 또는 설명\" 하는 일이다. 다음 세 가지 상황에서 회귀가 적절하다.

1. **연속형 결과 예측** — 집값, 매출, 시간, 농도 등 (분류 문제에는 로지스틱 회귀나 분류 모델).
2. **변수 간의 관계 강도와 방향** — \"공부 시간이 시험 점수에 얼마나 영향을 주는가\".
3. **다른 변수의 영향을 통제한 효과** — 다중회귀에서 \"같은 나이 조건일 때 흡연이 폐활량에 미치는 영향\".

회귀가 적절하지 않은 경우도 있다.

- 자료가 너무 적을 때 (예: 변수 50 개에 관측 30 개).
- 변수 간 관계가 매우 비선형일 때 — 변수변환·다항회귀·트리 기반 모델을 먼저 고려.
- 측정오차가 매우 큰 X 가 있을 때 — Deming 회귀나 EIV 모형을 고려.

이 글의 정규화는 **첫 번째 상황** (자료가 적거나 변수가 많아 OLS 가 불안정) 에 대한 답이다.

---

## 2.  OLS 복습 — 행렬형 접근

스칼라 편미분으로 푼 단변량 OLS 는 OLS 핸드아웃에서 다뤘다. 정규화로 가기 위해서는 **행렬형 OLS** 가 더 편하므로 한 번 더 정리한다.

### 2.1  행렬 표기로 손실함수를 다시 쓴다

$\boldsymbol y \in \mathbb{R}^{n}$, 설계행렬 $\boldsymbol X \in \mathbb{R}^{n \times (p+1)}$ (첫 열이 1), $\boldsymbol\beta \in \mathbb{R}^{p+1}$ 이라 두면 잔차벡터는

$$ \boldsymbol r = \boldsymbol y - \boldsymbol X \boldsymbol\beta $$

이고 손실함수는

$$ S(\boldsymbol\beta) = \boldsymbol r^{\mathsf T}\boldsymbol r = (\boldsymbol y - \boldsymbol X \boldsymbol\beta)^{\mathsf T}(\boldsymbol y - \boldsymbol X \boldsymbol\beta) = \boldsymbol y^{\mathsf T}\boldsymbol y - 2\boldsymbol y^{\mathsf T}\boldsymbol X \boldsymbol\beta + \boldsymbol\beta^{\mathsf T}\boldsymbol X^{\mathsf T}\boldsymbol X\boldsymbol\beta. $$

### 2.2  행렬 미분 — 두 공식만 알면 된다

| 공식 | 결과 |
|---|---|
| $\boldsymbol a$ 가 $\boldsymbol\beta$ 와 무관할 때 | $\dfrac{\partial}{\partial \boldsymbol\beta}(\boldsymbol a^{\mathsf T}\boldsymbol\beta) = \boldsymbol a$ |
| $\boldsymbol A$ 가 대칭일 때 | $\dfrac{\partial}{\partial \boldsymbol\beta}(\boldsymbol\beta^{\mathsf T}\boldsymbol A\boldsymbol\beta) = 2\boldsymbol A\boldsymbol\beta$ |

손실함수의 세 항을 차례로 미분하면

$$ \frac{\partial S}{\partial \boldsymbol\beta} = 0 - 2\boldsymbol X^{\mathsf T}\boldsymbol y + 2\boldsymbol X^{\mathsf T}\boldsymbol X \boldsymbol\beta = \boldsymbol 0. $$

### 2.3  정규방정식과 닫힌 해

$$ \boldsymbol X^{\mathsf T}\boldsymbol X\,\hat{\boldsymbol\beta} = \boldsymbol X^{\mathsf T}\boldsymbol y \qquad \Longrightarrow \qquad \hat{\boldsymbol\beta} = (\boldsymbol X^{\mathsf T}\boldsymbol X)^{-1}\boldsymbol X^{\mathsf T}\boldsymbol y. $$

이 한 줄의 행렬 표기를 머리에 새겨두면, 다음에 등장하는 Ridge 의 해는 단지 \"$\boldsymbol X^{\mathsf T}\boldsymbol X$ 에 $\alpha I$ 를 더하기\" 만으로 끝난다.

---

## 3.  OLS 의 세 가지 한계 — 왜 정규화가 필요한가

### 3.1  다중공선성

설명변수들끼리 강하게 상관되면 $\boldsymbol X^{\mathsf T}\boldsymbol X$ 의 고유값 중 하나가 거의 0 이 된다. 이 행렬의 역행렬은 \"거의 0 으로 나누는\" 일과 같아서, 자료에 작은 잡음이 끼었을 때 추정 계수가 어이없이 큰 값(예: $\pm 10^{6}$)을 가질 수 있다. 이를 **추정량의 불안정** 이라고 한다.

### 3.2  변수 과다 ($p \geq n$)

설명변수의 수가 관측 수보다 크거나 같으면 $\boldsymbol X^{\mathsf T}\boldsymbol X$ 가 가역이 아니다. OLS 의 해 자체가 유일하게 존재하지 않는다. 유전체학·텍스트분류·이미지 회귀 등에서 흔히 발생한다.

### 3.3  과적합 (Overfitting)

훈련 자료에는 잘 맞지만 새 자료에는 못 맞는 현상이다. 특히 모수가 많거나 자료가 적을 때 일어난다. 다음 절에서 본격적으로 다룬다.

세 한계의 공통적인 원인은 \"모형이 너무 자유롭다\" 는 것이다. 정규화는 그 자유에 **패널티**를 매겨 분산을 줄이는 방법이다.

---

## 4.  과적합과 편향-분산 트레이드오프

### 4.1  과적합과 과소적합

- **과소적합(underfitting)**: 모형이 너무 단순해서 훈련 자료의 패턴조차 못 잡는 상태.
- **과적합(overfitting)**: 모형이 너무 복잡해서 훈련 자료의 잡음까지 외워버린 상태.
- 둘 사이에 \"잘 일반화되는 (generalize)\" 지점이 있다.

### 4.2  학습 곡선

훈련 오차와 검증 오차를 모형 복잡도(또는 모수의 자유도) 에 대해 그리면 일반적으로 다음과 같다.

```
오차
 │  ─── 검증 오차 (validation)
 │  ╲                    ╱
 │   ╲                  ╱
 │    ╲ _ _ _ _ _ _ _ ╱
 │           최저점 ← 잘 일반화되는 자리
 │
 │  ─── 훈련 오차 (training)
 │  ╲
 │   ╲_______________
 └──────────────────────────────→ 복잡도
       과소적합        과적합
```

훈련 오차는 복잡도가 늘수록 계속 줄지만, 검증 오차는 어느 지점부터 다시 늘기 시작한다. 그 \"다시 늘기 시작하는 자리\" 가 과적합의 시작점이다.

### 4.3  편향-분산 분해

예측 오차의 기댓값은 다음과 같이 분해된다.

$$ \mathbb{E}\bigl[(y - \hat y)^2\bigr] = \underbrace{\bigl(\mathbb{E}[\hat y] - y_{\text{true}}\bigr)^2}_{\text{Bias}^2} + \underbrace{\mathrm{Var}(\hat y)}_{\text{Variance}} + \underbrace{\sigma^2}_{\text{Noise}}. $$

- **Bias**: 모형의 평균이 참값에서 얼마나 떨어져 있는가.
- **Variance**: 자료가 바뀔 때 모형이 얼마나 출렁이는가.
- **Noise**: 어쩔 수 없는 잔차.

복잡도가 늘수록 Bias 는 줄지만 Variance 는 늘어난다. 정규화는 **Bias 를 약간 늘리는 대신 Variance 를 크게 줄임으로써** 합을 줄이는 도구이다.

---

## 5.  정규화의 사고방식 — 손실함수에 \"패널티\" 를 더한다

OLS 의 손실함수는 다음과 같다.

$$ S_{\text{OLS}}(\boldsymbol\beta) = \|\boldsymbol y - \boldsymbol X\boldsymbol\beta\|_2^{\,2}. $$

정규화 회귀는 여기에 **계수의 크기를 처벌하는 항** 을 더한다.

$$ S_{\text{reg}}(\boldsymbol\beta) = \|\boldsymbol y - \boldsymbol X\boldsymbol\beta\|_2^{\,2} \;+\; \alpha \cdot P(\boldsymbol\beta). $$

- $\alpha \geq 0$ 는 **정규화 강도**(regularization strength) 라는 하이퍼파라미터. 사용자가 정해야 한다.
- $P(\boldsymbol\beta)$ 는 패널티 함수. 어떤 함수를 쓰는가에 따라 회귀의 성격이 갈린다.

| 패널티 $P(\boldsymbol\beta)$ | 이름 | 핵심 효과 |
|---|---|---|
| $0$ | OLS | 처벌 없음 |
| $\|\boldsymbol\beta\|_2^{\,2} = \sum\beta_j^2$ | Ridge | 큰 계수를 작게 만든다 |
| $\|\boldsymbol\beta\|_1 = \sum\lvert\beta_j\rvert$ | Lasso | 일부 계수를 정확히 0 으로 만든다 |
| $(1-\rho)\|\boldsymbol\beta\|_2^2 / 2 + \rho\|\boldsymbol\beta\|_1$ | ElasticNet | 두 효과의 혼합 |

\"패널티를 더한다\" 는 한 문장이 이 가족 전체를 한 줄에 묶는다.

---

## 6.  표준화는 왜 정규화와 \"함께\" 가는가

정규화는 **계수의 크기** 를 처벌한다. 그런데 계수의 크기는 **변수의 단위** 에 좌우된다. 예를 들어 \"키\" 변수의 단위가 cm 에서 m 로 바뀌면 그 계수는 100 배가 된다 — 자료의 실질적 의미는 그대로지만, 패널티만 100 배가 늘어난다.

따라서 정규화 직전에는 거의 항상 **표준화** 를 한다.

$$ x_{ij}^{\,(\text{std})} = \frac{x_{ij} - \bar x_j}{\hat\sigma_j}. $$

이로써 모든 변수가 평균 0, 표준편차 1 의 \"공평한\" 척도에 놓이고, 패널티가 변수마다 같은 의미를 갖게 된다.

- 표준화는 sklearn 의 `StandardScaler` 로 한다.
- 절편($\beta_0$) 은 패널티에 포함하지 않는다 — `Ridge(fit_intercept=True)` 등 sklearn 함수가 자동으로 처리한다.
- 표준화는 **훈련 자료의 평균·표준편차** 로만 계산해서 그 값을 검증·시험 자료에도 적용한다. (검증 자료의 평균을 다시 쓰면 정보 누수)

PCA 에서 \"분산이 큰 방향\" 을 찾기 위해 표준화가 필수였던 것과 같은 이유다. 결국 \"규모 통일\" 은 PCA 와 정규화 회귀에서 같은 자리에 있다.

---

## 7.  Ridge 회귀 — L2 정규화

### 7.1  손실함수

$$ S_{\text{Ridge}}(\boldsymbol\beta) = \|\boldsymbol y - \boldsymbol X\boldsymbol\beta\|_2^{\,2} \;+\; \alpha\,\|\boldsymbol\beta\|_2^{\,2}. $$

### 7.2  행렬 미분으로 닫힌 해

$$ \frac{\partial S_{\text{Ridge}}}{\partial \boldsymbol\beta} = -2\boldsymbol X^{\mathsf T}\boldsymbol y + 2\boldsymbol X^{\mathsf T}\boldsymbol X\boldsymbol\beta + 2\alpha\boldsymbol\beta = \boldsymbol 0. $$

정리하면

$$ (\boldsymbol X^{\mathsf T}\boldsymbol X + \alpha\boldsymbol I)\,\hat{\boldsymbol\beta} = \boldsymbol X^{\mathsf T}\boldsymbol y. $$

따라서 Ridge 의 닫힌 해는

$$ \boxed{\;\;\hat{\boldsymbol\beta}_{\text{Ridge}} = (\boldsymbol X^{\mathsf T}\boldsymbol X + \alpha\boldsymbol I)^{-1}\boldsymbol X^{\mathsf T}\boldsymbol y.\;\;} $$

OLS 의 해 $(\boldsymbol X^{\mathsf T}\boldsymbol X)^{-1}\boldsymbol X^{\mathsf T}\boldsymbol y$ 에서 $\boldsymbol X^{\mathsf T}\boldsymbol X$ 자리에 $\alpha\boldsymbol I$ 만 더해진 모양이다. \"항등행렬을 살짝 섞어 행렬을 더 잘 가역으로 만든다\" 라는 직관이 그대로 살아 있다.

### 7.3  효과

- $\alpha = 0$ → 정확히 OLS.
- $\alpha \to \infty$ → 모든 계수가 0 에 가까워진다 (절편만 살아남는다).
- 그 사이에서 **모든 계수가 부드럽게 작아진다**. 정확히 0 으로 가지는 않는다.

### 7.4  Ridge 는 \"왜\" 분산을 줄이는가

$\boldsymbol X^{\mathsf T}\boldsymbol X$ 의 고유값 중 작은 값이 $\alpha$ 만큼 들어 올려진다. 결국 \"역행렬 곱하기\" 에서 폭주하는 작은 분모가 사라지고, 추정량의 분산이 작아진다. 대신 약간의 편향이 생긴다 — Bias-Variance 트레이드오프의 정확한 사례.

---

## 8.  Lasso 회귀 — L1 정규화

### 8.1  손실함수

$$ S_{\text{Lasso}}(\boldsymbol\beta) = \|\boldsymbol y - \boldsymbol X\boldsymbol\beta\|_2^{\,2} \;+\; \alpha\sum_{j=1}^{p}\lvert\beta_j\rvert. $$

### 8.2  미분 가능성이 깨진다

L1 항 $\lvert\beta_j\rvert$ 는 $\beta_j = 0$ 에서 미분 불가능하다. 즉 \"편미분 = 0\" 의 사고방식이 그 한 점에서 작동하지 않는다.

이때는 **부분 미분(subgradient)** 이나 **좌표하강법(coordinate descent)** 으로 해를 구한다. 좌표하강법의 한 좌표 갱신식은 다음과 같다 (soft-thresholding).

$$ \hat\beta_j \leftarrow S_{\alpha}\bigl(\beta_j^{\,\text{OLS-like}}\bigr), \qquad S_{\alpha}(z) = \mathrm{sign}(z)\cdot\max(\lvert z\rvert - \alpha, 0). $$

이 식의 의미는 다음과 같다.

- 임의의 좌표 계수의 \"OLS 적 후보값\" 이 $z$ 라고 하자.
- $\lvert z\rvert \leq \alpha$ 이면 그 계수를 **정확히 0** 으로 둔다.
- $\lvert z\rvert > \alpha$ 이면 $\alpha$ 만큼 0 쪽으로 끌어당긴다.

이 \"부드럽게 0 으로 자르는\" 동작이 Lasso 의 핵심이다.

### 8.3  Lasso 는 변수 선택을 자동으로 한다

위 식의 첫 줄이 의미하는 바는 \"어떤 계수는 정확히 0 이 된다\" 이다. 즉 Lasso 는 **자동으로 변수 선택** 을 수행한다 — 영향력이 작은 변수를 자료가 직접 골라 잘라낸다.

### 8.4  기하학적 직관

OLS 의 잔차 등고선을 그리고 그 위에 다음 두 영역을 겹쳐 그린다.

- Ridge 의 제약 영역: $\sum\beta_j^2 \leq C$ — 원 (구).
- Lasso 의 제약 영역: $\sum\lvert\beta_j\rvert \leq C$ — 마름모 (다이아몬드).

마름모의 꼭짓점은 좌표축 위에 있다. 잔차 등고선이 마름모와 처음 닿는 지점이 좌표축 위라면, 그 좌표의 계수는 0 이 된다. 이 \"꼭짓점이 좌표축에 있는 모양\" 이 Lasso 가 어떤 계수를 0 으로 만드는 기하학적 이유이다.

---

## 9.  Ridge vs Lasso — 정규화 경로

같은 자료에 $\alpha$ 를 0 에서 큰 값까지 변화시키며 계수를 추적한 것을 **정규화 경로(regularization path)** 라 한다.

- **Ridge 경로**: 모든 계수가 $\alpha$ 에 따라 부드럽게 0 으로 수렴. 어느 누구도 정확히 0 이 되지는 않는다.
- **Lasso 경로**: $\alpha$ 가 어떤 임계값을 넘는 순간 어떤 계수가 정확히 0 이 된다. 더 큰 $\alpha$ 에서 더 많은 계수가 0 으로 떨어진다.

노트북에서 이 경로를 직접 그려 본다. 한 그림으로 두 방법의 본질적 차이가 즉시 보인다.

---

## 10.  ElasticNet — 두 패널티의 혼합

### 10.1  손실함수

$$ S_{\text{EN}}(\boldsymbol\beta) = \|\boldsymbol y - \boldsymbol X\boldsymbol\beta\|_2^{\,2} \;+\; \alpha\Bigl[\,\rho\,\|\boldsymbol\beta\|_1 + \frac{1-\rho}{2}\,\|\boldsymbol\beta\|_2^{\,2}\Bigr]. $$

- $\rho = 0$ → Ridge.
- $\rho = 1$ → Lasso.
- $0 < \rho < 1$ → 두 패널티의 혼합.

scikit-learn 의 `ElasticNet` 에서는 $\rho$ 가 `l1_ratio` 매개변수이다.

### 10.2  왜 두 가지를 섞는가 — Lasso 의 한계

Lasso 가 좋지만 두 가지 약점이 있다.

1. **상관된 변수들 중 하나만 고른다** — 같은 정보를 가진 두 변수가 있으면 Lasso 는 그중 하나만 살리고 다른 하나는 0 으로 만든다. 어느 쪽이 살아남는지가 자료의 작은 흔들림에 매우 민감하다 (불안정).
2. **$p > n$ 일 때 최대 $n$ 개의 변수만 선택할 수 있다** — 변수가 매우 많을 때는 부족하다.

ElasticNet 은 L2 항을 같이 두어서 \"상관된 변수들을 함께 살리거나 함께 줄이는\" 그룹 효과 (grouping effect) 를 회복한다.

### 10.3  사용 시점

- 변수가 매우 많고 (수백~수만개) 서로 강하게 상관된 경우 — 유전체학, 텍스트분류, 화학 분광학 등.
- Lasso 가 너무 불안정할 때.

---

## 11.  네 회귀를 한 식으로 묶으면

$$ \hat{\boldsymbol\beta} \;=\; \mathop{\arg\min}_{\boldsymbol\beta} \Bigl\{ \|\boldsymbol y - \boldsymbol X\boldsymbol\beta\|_2^{\,2} \;+\; \alpha\cdot P(\boldsymbol\beta)\Bigr\}. $$

| 회귀 | $P(\boldsymbol\beta)$ | 해를 구하는 도구 | 효과 |
|---|---|---|---|
| OLS | $0$ | 행렬 미분 (정규방정식) | 처벌 없음, 가장 자유로움 |
| Ridge | $\|\boldsymbol\beta\|_2^{\,2}$ | 행렬 미분 (변형 정규방정식) | 모든 계수를 부드럽게 작게 |
| Lasso | $\|\boldsymbol\beta\|_1$ | 좌표하강법 (soft-threshold) | 일부 계수를 정확히 0 |
| ElasticNet | $\rho\|\boldsymbol\beta\|_1 + \frac{1-\rho}{2}\|\boldsymbol\beta\|_2^{\,2}$ | 좌표하강법 변형 | 그룹 효과 + 변수 선택 |

OLS 와 Ridge 만 \"편미분 = 0\" 으로 깔끔히 풀리고, Lasso 와 ElasticNet 은 L1 부분이 미분 불가능하므로 반복 알고리즘이 필요하다. 그러나 \"손실함수를 최소화하는 $\boldsymbol\beta$ 를 찾는다\" 라는 큰 그림은 모두 같다.

---

## 12.  $\alpha$ (정규화 강도) 의 선택 — 교차검증

$\alpha$ 는 자료가 알려주는 모수가 아니라 분석자가 정해야 하는 **하이퍼파라미터** 이다. 너무 작으면 정규화 효과가 없고, 너무 크면 계수가 모두 0 에 가까워진다.

표준 방법은 **k 겹 교차검증(k-fold cross-validation)** 이다.

1. 자료를 $k$ 등분.
2. 한 조각을 검증용으로 떼고 나머지로 모형 적합.
3. 검증 오차 측정.
4. 모든 조각이 한 번씩 검증용이 되도록 반복.
5. 평균 검증 오차가 가장 작은 $\alpha$ 를 선택.

scikit-learn 에서는 `RidgeCV`, `LassoCV`, `ElasticNetCV` 가 이 과정을 자동으로 한다. ElasticNet 의 경우 $\alpha$ 와 $\rho$ 를 동시에 격자 탐색(grid search) 한다.

---

## 13.  실제 자료로 보는 현상 — 노트북의 흐름

노트북에서는 다음 다섯 단계로 정규화의 효과를 직접 본다.

1. **자료 준비**: 상관이 강한 합성 자료 (또는 보스턴 주택가격), 표준화.
2. **OLS 적합**: 일부 계수가 불안정하게 큰 값을 가지는 모습 관찰.
3. **Ridge 적합 + 정규화 경로**: $\alpha$ 를 변화시키며 모든 계수가 부드럽게 줄어드는 모습.
4. **Lasso 적합 + 정규화 경로**: $\alpha$ 가 커질수록 어떤 계수가 정확히 0 으로 떨어지는 모습.
5. **교차검증**: `RidgeCV`, `LassoCV` 로 최적 $\alpha$ 자동 선택, 시험 자료 성능 비교.

노트북의 그래프 한 장 — \"$\alpha$ 에 따라 계수가 어떻게 움직이는가\" — 이 전체 정규화 모듈의 핵심 시각자료이다.

---

## 14.  실무 점검표

정규화 회귀를 실무에서 쓸 때 반드시 점검해야 할 다섯 가지.

1. **표준화를 했는가** — `StandardScaler` 를 훈련 자료에 fit, 시험 자료에는 transform.
2. **교차검증으로 $\alpha$ 를 골랐는가** — 임의의 $\alpha$ 를 쓰지 않는다.
3. **변수 선택의 결과 (Lasso) 가 자료 분할에 안정적인가** — 분할을 바꾸면 살아남는 변수가 매번 바뀌는지 확인.
4. **계수 해석이 가능한가** — 표준화 후 계수는 \"표준편차 1 단위 변화당 효과\" 임을 잊지 않는다.
5. **시험 자료 성능이 OLS 보다 좋은가** — 정규화는 항상 이기는 게 아니다. 자료에 따라 OLS 가 더 좋을 수도 있다.

---

## 15.  세 분야를 통합한 그림

| 회귀 | 한계가 무엇인가 | 답이 무엇인가 |
|---|---|---|
| OLS | (기준이 되는 회귀) | — |
| **Ridge / Lasso / EN** | 다중공선성 · 과적합 · 변수 과다 | 손실함수에 패널티 추가 |
| PCA / PCR | 변수가 너무 많고 직교화하고 싶음 | 변수를 주성분으로 회전 |
| Deming | X 에도 측정오차가 있음 | 가중 직교 거리 최소화 |

네 가지 답이 모두 \"손실함수를 정의하고 그것을 어떤 방식으로 최소화하는가\" 라는 한 사고방식에 기반한다. 그 결과로 회귀의 가족 지도가 완성된다.

> **회귀 강의의 한 문장.**  
> 모든 선형회귀는 \"손실함수를 정의하고, 그것을 (편)미분으로 풀거나 반복 알고리즘으로 푼다\" 라는 일을 변주한다. 무엇을 손실로 보고, 어떤 패널티를 더하고, 어떤 제약을 둘 것인가가 회귀의 종류를 결정한다.
