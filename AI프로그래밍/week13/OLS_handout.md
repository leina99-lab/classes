# OLS — 학생용 설명 글

> 이 글은 노트북 `OLS_notebook.ipynb` 의 흐름을 한국어 학술문어체로 풀어 설명한 자료이다.
> 본 부록은 PCA·Deming 회귀 강의의 **수학적 토대**를 마련한다.

---

## 1.  왜 \"편미분 = 0\" 부터 시작하는가

회귀 강의는 보통 결과식 $\hat\beta_1 = \mathrm{Cov}(x,y) / \mathrm{Var}(x)$ 부터 외우게 한다. 그러나 이 식의 출처가 \"손실함수를 편미분해서 0 으로 놓았다\" 라는 한 줄임을 알아야, 같은 사고방식을 PCA 와 Deming 회귀에 그대로 가져갈 수 있다.

세 가지 방법은 모두 **같은 패턴**을 따른다.

| 방법 | 목적함수 | 제약 |
|---|---|---|
| OLS | $\sum (y_i - \beta_0 - \beta_1 x_i)^2$ 최소화 | 없음 |
| PCA | $v^{\mathsf T}\Sigma v$ 최대화 | $\|v\| = 1$ |
| Deming | 가중 직교거리² 최소화 | $\lambda = \mathrm{Var}(\varepsilon)/\mathrm{Var}(\delta)$ 고정 |

OLS 는 제약 없는 평범한 미분, PCA 와 Deming 은 라그랑주가 추가될 뿐이다.

---

## 2.  손실함수와 편미분

OLS 의 손실함수는

$$ S(\beta_0, \beta_1) = \sum_{i=1}^{n} (y_i - \beta_0 - \beta_1 x_i)^2 $$

이다. 이는 두 변수 $\beta_0, \beta_1$ 에 대한 매끄러운 이차함수이므로 임계점이 곧 전역 최솟값이다. 두 변수 각각에 대한 편미분을 0 으로 놓는다.

$$
\frac{\partial S}{\partial \beta_0} = -2 \sum_i (y_i - \beta_0 - \beta_1 x_i) = 0
$$

$$
\frac{\partial S}{\partial \beta_1} = -2 \sum_i x_i (y_i - \beta_0 - \beta_1 x_i) = 0
$$

두 식을 정리하면 **정규방정식(normal equations)** 두 개가 얻어진다.

---

## 3.  닫힌 형태의 해

정규방정식을 풀면

$$
\hat\beta_1 = \frac{\sum_i (x_i - \bar x)(y_i - \bar y)}{\sum_i (x_i - \bar x)^2}, \qquad
\hat\beta_0 = \bar y - \hat\beta_1 \bar x.
$$

이 식은 다음과 같이 읽는다.

- **분자**: $x$ 와 $y$ 의 공동 변동(공분산의 분자).
- **분모**: $x$ 의 변동(분산의 분자).
- 즉 $\hat\beta_1 = \mathrm{Cov}(x,y) / \mathrm{Var}(x)$ 이다.

다변량으로 일반화하면 행렬 표기로

$$ \hat{\boldsymbol{\beta}} = (\boldsymbol{X}^{\mathsf T} \boldsymbol{X})^{-1} \boldsymbol{X}^{\mathsf T} \boldsymbol{y} $$

가 된다. 같은 사고방식이지만 미지수가 $p$ 개 늘었을 뿐이다.

---

## 4.  수직 잔차의 기하학적 의미

OLS 가 최소화하는 것은 \"수직(Y축) 잔차의 제곱합\" 이다. 즉 각 점 $(x_i, y_i)$ 에서 회귀선까지의 **세로 방향** 거리이다. 이는 \"X 는 정확히 측정되었고, 오차는 오직 Y 에만 있다\" 라는 가정에서 자연스럽게 따라온다.

만약 X 도 측정오차를 가진다면 \"수직 거리\" 만 최소화하는 일은 적절하지 않다. 이때 직교 거리(또는 가중 직교 거리)를 최소화하는 것이 **직교 회귀** 와 **Deming 회귀** 이다.

---

## 5.  Gauss-Markov 정리

다음 다섯 가정이 성립할 때, OLS 의 추정량 $\hat{\boldsymbol{\beta}}$ 는 **BLUE**(Best Linear Unbiased Estimator) 이다.

1. **선형성** — 모형이 모수에 대해 선형이다.
2. **외생성** — $\mathbb{E}[\delta_i \mid X_i] = 0$.
3. **등분산성** — $\mathrm{Var}(\delta_i) = \sigma^2$ 가 모든 $i$ 에서 같다.
4. **무상관** — 잔차들끼리 상관이 없다.
5. **X 에 측정오차가 없다**.

이 다섯 중 어느 하나라도 깨지면 \"OLS 보다 더 나은\" 추정량이 존재한다. 그중 가정 5 가 깨질 때의 답이 **Deming 회귀** 이다. 가정 1 의 모수 수가 너무 많을 때(다중공선성)의 답이 **주성분 회귀(PCR)** 이다.

---

## 6.  코드 확인 — 세 방법이 일치한다

노트북에서는 다음 세 방법으로 같은 자료를 적합한다.

1. **수동 계산**: $\hat\beta_1 = \sum(x_i - \bar x)(y_i - \bar y) / \sum(x_i - \bar x)^2$.
2. **행렬 계산**: `np.linalg.lstsq` 를 이용해 $\hat{\boldsymbol{\beta}} = (\boldsymbol{X}^{\mathsf T} \boldsymbol{X})^{-1}\boldsymbol{X}^{\mathsf T}\boldsymbol{y}$.
3. **scikit-learn**: `LinearRegression().fit(x, y)`.

세 방법이 모두 같은 추정값을 준다는 점이 중요하다. 즉, **편미분 = 0 이라는 한 줄에서 시작해서 어떻게 끝까지 가도 같은 답에 도착한다**.

---

## 7.  다음 노트북으로

- **`PCA_notebook.ipynb`**: 같은 \"편미분 = 0\" 사고방식에 \"제약을 라그랑주로 추가\" 한다.
- **`Deming_notebook.ipynb`**: X 의 측정오차를 인정할 때, OLS 의 감쇠 편향을 어떻게 보정하는가.

세 노트북을 차례로 읽으면 회귀의 한 가족이 한눈에 들어온다.
