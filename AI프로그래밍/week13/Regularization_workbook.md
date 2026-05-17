# Regularization — 학생 워크북

> 핸드아웃 `Regularization_handout.md` 의 본문을 따라가며 핵심 단어·식을 빈칸으로 둔다.  
> 빈칸을 직접 채우며 **\"왜 정규화가 필요한가\" → \"왜 표준화가 함께 가는가\" → \"Ridge·Lasso·ElasticNet 의 관계\"** 의 흐름을 손으로 재구성한다.  
> 답은 워크북 가장 아래의 \"정답 보기\" 토글에 모아 두었다.

---

## 1.  자료의 위치 (각 1점, 총 5점)

OLS 의 세 가지 한계와 그에 대한 답을 다음 표로 정리하시오.

| OLS 의 한계 | 답이 되는 회귀 |
|---|---|
| (1) X 에 측정오차가 있을 때 | (㉠) 회귀 |
| (2) 변수가 너무 많을 때 (또는 직교화하고 싶을 때) | (㉡) (또는 PCR) |
| (3) 다중공선성 · 과적합 | (㉢) · (㉣) · (㉤) |

> ㉠ \_\_\_\_\_\_\_\_  ㉡ \_\_\_\_  ㉢ \_\_\_\_\_\_\_\_  ㉣ \_\_\_\_\_\_\_\_  ㉤ \_\_\_\_\_\_\_\_

---

## 2.  회귀분석을 언제 하는가 (각 2점, 총 6점)

회귀가 적절한 세 가지 상황을 채우시오.

1. 결과가 (㉠) 형 (예: 집값, 매출, 농도) 일 때.
2. 변수 간 관계의 (㉡) 와 (㉢) 를 알고 싶을 때.
3. 다른 변수의 영향을 (㉣) 한 효과를 보고 싶을 때 (다중회귀).

회귀가 적절하지 않은 경우의 예 두 가지.

- 자료가 너무 (㉤) 때.
- 측정오차가 매우 큰 X 가 있을 때 → (㉥) 회귀.

> ㉠ \_\_\_\_\_\_\_\_  ㉡ \_\_\_\_  ㉢ \_\_\_\_  ㉣ \_\_\_\_  ㉤ \_\_\_\_  ㉥ \_\_\_\_\_\_\_\_

---

## 3.  OLS 행렬형 복습 (각 2점, 총 10점)

손실함수의 행렬 표기는

$$ S(\boldsymbol\beta) = \boldsymbol y^{\mathsf T}\boldsymbol y - 2(㉠) + (㉡). $$

행렬 미분 두 공식만 알면 다음이 곧장 따라온다.

$$ \frac{\partial S}{\partial \boldsymbol\beta} = -2\boldsymbol X^{\mathsf T}\boldsymbol y + 2(㉢)\,\boldsymbol\beta = \boldsymbol 0. $$

정리하면 정규방정식 $\boldsymbol X^{\mathsf T}\boldsymbol X\,\boldsymbol\beta = (㉣)$, 닫힌 해

$$ \hat{\boldsymbol\beta} = (㉤). $$

> ㉠ \_\_\_\_\_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_  ㉢ \_\_\_\_\_\_\_\_  
>
> ㉣ \_\_\_\_\_\_\_\_  ㉤ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## 4.  OLS 의 세 가지 한계 (각 2점, 총 6점)

| 한계 | 어떤 현상이 일어나는가 |
|---|---|
| 다중공선성 | $\boldsymbol X^{\mathsf T}\boldsymbol X$ 의 (㉠) 중 하나가 거의 0 → 추정량 (㉡) |
| 변수 과다 ($p \geq n$) | $\boldsymbol X^{\mathsf T}\boldsymbol X$ 가 (㉢) 가 아니라 OLS 해 유일하지 않음 |
| 과적합 | 훈련 자료에는 잘 맞지만 (㉣) 자료에 못 맞음 |

> ㉠ \_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_  ㉢ \_\_\_\_\_\_\_\_  ㉣ \_\_\_\_

---

## 5.  편향-분산 분해 (각 2점, 총 8점)

예측 오차의 기댓값은 다음과 같이 분해된다.

$$ \mathbb{E}\bigl[(y - \hat y)^2\bigr] = \underbrace{(㉠)}_{\text{Bias}^2} + \underbrace{(㉡)}_{\text{Variance}} + \underbrace{(㉢)}_{\text{Noise}}. $$

복잡도가 커지면 (㉣) 은 줄지만 (㉤) 은 늘어난다. 정규화는 (㉣) 을 약간 늘리는 대신 (㉤) 을 크게 줄여서 합을 줄이는 도구이다.

> ㉠ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_\_\_\_\_  ㉢ \_\_\_\_  ㉣ \_\_\_\_  ㉤ \_\_\_\_

---

## 6.  정규화의 사고방식 (각 1점, 총 5점)

정규화 회귀의 일반형 손실함수는

$$ S_{\text{reg}}(\boldsymbol\beta) = \|\boldsymbol y - \boldsymbol X\boldsymbol\beta\|_2^{\,2} \;+\; (㉠) \cdot P(\boldsymbol\beta). $$

| 패널티 $P(\boldsymbol\beta)$ | 이름 |
|---|---|
| $0$ | (㉡) |
| $\sum \beta_j^{\,2}$ | (㉢) |
| $\sum \lvert\beta_j\rvert$ | (㉣) |
| 두 패널티의 혼합 | (㉤) |

> ㉠ \_\_\_\_  ㉡ \_\_\_\_  ㉢ \_\_\_\_\_\_\_\_  ㉣ \_\_\_\_\_\_\_\_  ㉤ \_\_\_\_\_\_\_\_\_\_\_\_

---

## 7.  표준화는 왜 함께 가는가 (각 2점, 총 6점)

정규화는 **(㉠) 의 크기**를 처벌한다. 그런데 그 크기는 변수의 (㉡) 에 좌우된다. 따라서 정규화 직전에는 거의 항상

$$ x_{ij}^{\,(\text{std})} = \frac{x_{ij} - (㉢)}{(㉣)} $$

로 표준화한다. sklearn 에서는 (㉤) 클래스를 사용한다. (㉥) 은 패널티에 포함하지 않는다.

> ㉠ \_\_\_\_  ㉡ \_\_\_\_  ㉢ \_\_\_\_  ㉣ \_\_\_\_\_\_\_\_  ㉤ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_  ㉥ \_\_\_\_

---

## 8.  Ridge — L2 정규화 (각 2점, 총 12점)

손실함수에 $\alpha (㉠)$ 를 더한다. 행렬 미분 = 0 으로 정리하면

$$ (\boldsymbol X^{\mathsf T}\boldsymbol X + (㉡))\,\hat{\boldsymbol\beta} = \boldsymbol X^{\mathsf T}\boldsymbol y. $$

닫힌 해는

$$ \hat{\boldsymbol\beta}_{\text{Ridge}} = (㉢)^{-1}\boldsymbol X^{\mathsf T}\boldsymbol y. $$

OLS 의 해 $(X^{\mathsf T}X)^{-1}X^{\mathsf T}y$ 에서 $X^{\mathsf T}X$ 자리에 (㉡) 만 더해진 모양이다.

효과:

- $\alpha = 0$ → 정확히 (㉣).
- $\alpha \to \infty$ → 모든 계수가 (㉤) 에 가까워진다.
- 어떤 계수도 (㉥) 0 으로 가지는 않는다.

> ㉠ \_\_\_\_\_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_  ㉢ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_  
>
> ㉣ \_\_\_\_  ㉤ \_\_\_\_  ㉥ \_\_\_\_\_\_\_\_

---

## 9.  Lasso — L1 정규화 (각 2점, 총 12점)

손실함수에 $\alpha \sum \lvert\beta_j\rvert$ 를 더한다. L1 항은 $\beta_j = 0$ 에서 (㉠) 가 안 된다.

따라서 (㉡) 미분이나 **좌표하강법(coordinate descent)** 으로 푼다. 한 좌표의 갱신식은

$$ \hat\beta_j \leftarrow (㉢)(z), \qquad (㉣)(z) = \mathrm{sign}(z)\cdot\max(\lvert z\rvert - \alpha, 0). $$

이 갱신식의 의미:

- $\lvert z\rvert \leq \alpha$ 이면 계수를 (㉤) 0 으로 둔다.
- $\lvert z\rvert > \alpha$ 이면 $\alpha$ 만큼 (㉥) 으로 끌어당긴다.

결과로 Lasso 는 자동으로 (㉦) 을 수행한다.

> ㉠ \_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_  ㉢ \_\_\_\_\_\_\_\_  ㉣ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_  
>
> ㉤ \_\_\_\_\_\_\_\_  ㉥ \_\_\_\_  ㉦ \_\_\_\_\_\_\_\_

---

## 10.  Ridge vs Lasso — 정규화 경로 (각 2점, 총 6점)

| | $\alpha$ 가 커지면 |
|---|---|
| Ridge | 모든 계수가 (㉠) 0 으로 수렴. 어떤 누구도 (㉡) 0 이 되지는 않음 |
| Lasso | 어떤 계수가 (㉢) 임계값 이상의 $\alpha$ 에서 (㉣) 0 으로 떨어진 후 그대로 |

> ㉠ \_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_  ㉢ \_\_\_\_\_\_\_\_  ㉣ \_\_\_\_\_\_\_\_

---

## 11.  ElasticNet — 두 패널티의 혼합 (각 2점, 총 6점)

손실함수: $\|y - X\beta\|^2 + \alpha\bigl[\rho\,\|\beta\|_1 + \frac{1-\rho}{2}\,\|\beta\|_2^{\,2}\bigr]$.

| $\rho$ | 의미 |
|---|---|
| 0 | (㉠) 와 동일 |
| 1 | (㉡) 와 동일 |
| 0 ~ 1 | 두 패널티의 혼합 |

Lasso 의 한계 두 가지 — (1) 상관된 변수들 중 (㉢) 만 고르고 나머지는 0, (2) $p > n$ 일 때 최대 (㉣) 개만 선택. ElasticNet 은 이 두 문제를 (㉤) 효과로 보완한다.

> ㉠ \_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_  ㉢ \_\_\_\_  ㉣ \_\_\_\_  ㉤ \_\_\_\_

---

## 12.  네 회귀를 한 식으로 (각 2점, 총 8점)

$$ \hat{\boldsymbol\beta} = \arg\min_{\boldsymbol\beta}\Bigl\{ \|\boldsymbol y - \boldsymbol X\boldsymbol\beta\|_2^{\,2} + \alpha\cdot P(\boldsymbol\beta)\Bigr\}. $$

| 회귀 | $P(\boldsymbol\beta)$ | 푸는 도구 |
|---|---|---|
| OLS | (㉠) | 행렬 미분 = 0 |
| Ridge | (㉡) | 행렬 미분 = 0 |
| Lasso | (㉢) | (㉣) |
| ElasticNet | $\rho\|\boldsymbol\beta\|_1 + \frac{1-\rho}{2}\|\boldsymbol\beta\|_2^{\,2}$ | (㉣) 변형 |

> ㉠ \_\_\_\_  ㉡ \_\_\_\_\_\_\_\_  ㉢ \_\_\_\_\_\_\_\_  ㉣ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## 13.  $\alpha$ 의 선택 — 교차검증 (각 2점, 총 4점)

$\alpha$ 는 자료가 결정하지 못하는 (㉠) 이다. 표준 방법은 (㉡) 겹 교차검증으로 최적 $\alpha$ 를 자동 선택하는 것이다. sklearn 에서는 `RidgeCV`, `LassoCV`, `ElasticNetCV` 가 이를 수행한다.

> ㉠ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_  ㉡ \_\_\_\_

---

## 14.  코드 빈칸 (각 2점, 총 12점)

```python
from sklearn.linear_model import RidgeCV, LassoCV
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split

X_tr, X_te, y_tr, y_te = train_test_split(X, y, test_size=0.3, random_state=0)

# 1) 표준화 — 훈련에서 fit, 시험에는 transform 만
sc = (㉠)().fit(X_tr)
X_tr_s = sc.transform(X_tr)
X_te_s = sc.(㉡)(X_te)

# 2) Ridge — 5겹 교차검증으로 α 자동 선택
ridge = RidgeCV(alphas=np.logspace(-3, 3, 50), cv=(㉢)).fit(X_tr_s, y_tr)
print(\"선택된 α:\", ridge.(㉣))

# 3) Lasso
lasso = LassoCV(alphas=np.logspace(-3, 1, 50), cv=5, max_iter=20000).fit(X_tr_s, y_tr)
n_zero = int(np.sum(np.abs(lasso.coef_) < 1e-8))   # 0 이 된 계수의 수
print(f\"0 이 된 계수: {n_zero}\")

# 4) 시험 자료 성능
from sklearn.metrics import mean_squared_error
rmse_test = np.sqrt(mean_squared_error((㉤), ridge.predict((㉥))))
print(\"시험 RMSE:\", rmse_test)
```

> ㉠ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_\_\_\_\_  ㉢ \_\_\_\_  
>
> ㉣ \_\_\_\_\_\_\_\_  ㉤ \_\_\_\_  ㉥ \_\_\_\_\_\_\_\_

---

## 15.  OX 문제 (각 2점, 총 12점)

| | 문장 | OX |
|---|---|---|
| (1) | Ridge 는 $X^{\mathsf T}X$ 가 가역이 아니어도 항상 해를 가진다. | |
| (2) | Lasso 는 모든 계수를 동일한 비율로 줄인다. | |
| (3) | 정규화 직전에 표준화하지 않으면 단위가 큰 변수의 계수가 부당하게 많이 처벌된다. | |
| (4) | $\alpha$ 가 0 이면 Ridge 의 결과는 OLS 와 같다. | |
| (5) | ElasticNet 의 `l1_ratio` 가 1 이면 Ridge 와 같다. | |
| (6) | Lasso 는 변수 선택을 자동으로 수행하므로 해석이 단순해진다. | |

---

## 16.  도구 선택 시나리오 (각 2점, 총 10점)

| 상황 | 어떤 도구가 적절한가 |
|---|---|
| (가) 변수 50 개 중 의미 있는 것이 5 개 정도라 추측. 변수 선택 자동화하고 싶음. | (㉠) |
| (나) 모든 변수가 약한 효과를 가지고 있다고 가정. 한 변수를 \"버리고 싶지 않음\". | (㉡) |
| (다) 변수가 수천 개이며 서로 강하게 상관. Lasso 가 너무 불안정. | (㉢) |
| (라) 변수 개수 5 개로 적고 다중공선성도 없음. | (㉣) |
| (마) $p > n$ 인 자료. OLS 가 풀리지 않음. | (㉤) (여러 답) |

> ㉠ \_\_\_\_\_\_\_\_  ㉡ \_\_\_\_\_\_\_\_  ㉢ \_\_\_\_\_\_\_\_\_\_\_\_  ㉣ \_\_\_\_  ㉤ \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

---

## 부록.  학습 점검

> [ ]  회귀분석을 언제 / 언제 하지 말아야 하는지 안다.  
> [ ]  OLS 의 세 가지 한계를 모두 말할 수 있다.  
> [ ]  편향-분산 분해를 식으로 적을 수 있다.  
> [ ]  정규화 회귀의 일반형 손실함수를 적을 수 있다.  
> [ ]  Ridge 의 닫힌 해 $\hat{\boldsymbol\beta} = (X^{\mathsf T}X + \alpha I)^{-1}X^{\mathsf T}y$ 를 행렬 미분으로 유도할 수 있다.  
> [ ]  Lasso 가 변수 선택을 자동으로 하는 이유를 soft-thresholding 으로 설명할 수 있다.  
> [ ]  Ridge / Lasso / ElasticNet 의 차이를 한 식과 한 그림으로 비교할 수 있다.  
> [ ]  표준화가 정규화와 \"세트\" 인 이유를 단위로 설명할 수 있다.  
> [ ]  교차검증으로 $\alpha$ 를 선택하는 절차를 안다.

---

<details>
<summary>▶ 정답 보기</summary>

**1.**  ㉠ Deming · ㉡ PCA · ㉢ Ridge · ㉣ Lasso · ㉤ ElasticNet

**2.**  ㉠ 연속 · ㉡ 강도 · ㉢ 방향 · ㉣ 통제 · ㉤ 적을 · ㉥ Deming

**3.**  ㉠ $\boldsymbol y^{\mathsf T}\boldsymbol X\boldsymbol\beta$ · ㉡ $\boldsymbol\beta^{\mathsf T}\boldsymbol X^{\mathsf T}\boldsymbol X\boldsymbol\beta$ · ㉢ $\boldsymbol X^{\mathsf T}\boldsymbol X$ · ㉣ $\boldsymbol X^{\mathsf T}\boldsymbol y$ · ㉤ $(\boldsymbol X^{\mathsf T}\boldsymbol X)^{-1}\boldsymbol X^{\mathsf T}\boldsymbol y$

**4.**  ㉠ 고유값 · ㉡ 불안정 (큰 값으로 폭주) · ㉢ 가역 · ㉣ 새 (검증/시험)

**5.**  ㉠ $\bigl(\mathbb{E}[\hat y] - y_{\text{true}}\bigr)^2$ · ㉡ $\mathrm{Var}(\hat y)$ · ㉢ $\sigma^2$ · ㉣ Bias (편향) · ㉤ Variance (분산)

**6.**  ㉠ $\alpha$ · ㉡ OLS · ㉢ Ridge · ㉣ Lasso · ㉤ ElasticNet

**7.**  ㉠ 계수 · ㉡ 단위(스케일) · ㉢ $\bar x_j$ · ㉣ $\hat\sigma_j$ · ㉤ `StandardScaler` · ㉥ 절편($\beta_0$)

**8.**  ㉠ $\|\boldsymbol\beta\|_2^{\,2}$ · ㉡ $\alpha \boldsymbol I$ · ㉢ $(\boldsymbol X^{\mathsf T}\boldsymbol X + \alpha\boldsymbol I)$ · ㉣ OLS · ㉤ 0 · ㉥ 정확히

**9.**  ㉠ 미분 · ㉡ 부분(subgradient) · ㉢ $S_\alpha$ · ㉣ $S_\alpha$ (soft-threshold) · ㉤ 정확히 · ㉥ 0 쪽 · ㉦ 변수 선택

**10.**  ㉠ 부드럽게 · ㉡ 정확히 · ㉢ 어떤 · ㉣ 정확히

**11.**  ㉠ Ridge · ㉡ Lasso · ㉢ 하나 · ㉣ $n$ · ㉤ 그룹(grouping)

**12.**  ㉠ 0 · ㉡ $\|\boldsymbol\beta\|_2^{\,2}$ · ㉢ $\|\boldsymbol\beta\|_1$ · ㉣ 좌표하강법 (coordinate descent)

**13.**  ㉠ 하이퍼파라미터 · ㉡ $k$ (보통 5 또는 10)

**14.**  ㉠ `StandardScaler` · ㉡ `transform` · ㉢ 5 · ㉣ `alpha_` · ㉤ `y_te` · ㉥ `X_te_s`

**15.**  (1) ○ · (2) × · (3) ○ · (4) ○ · (5) × · (6) ○

**16.**  ㉠ Lasso · ㉡ Ridge · ㉢ ElasticNet · ㉣ OLS · ㉤ Ridge / Lasso / ElasticNet (정규화 회귀)

</details>
