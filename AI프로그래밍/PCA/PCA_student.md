# PCA — 학생용 
> 이 글은 노트북 `PCA_notebook.ipynb` 의 흐름을 풀어 설명한 자료이다.

---

## 1.  왜 PCA 를 OLS 다음에 배우는가

OLS 는 \"손실함수를 편미분 = 0\" 이라는 한 줄로 추정식이 자동으로 나왔다. PCA 도 정확히 같은 원리이다. 단지 두 가지가 추가된다.

1. **목적함수가 최소화에서 최대화로 바뀐다** — 분산을 \"최대\" 로 만든다.
2. **제약이 등장한다** — 방향벡터의 크기가 1 이어야 한다.

제약이 있는 최적화는 라그랑주 승수법으로 다룬다. 그 한 번의 단계만 OLS 와 다르다.

---

## 2.  세 단계 유도

### Step 1.  무엇을 최대화하는가

자료 $\boldsymbol{X} \in \mathbb{R}^{n \times p}$ 가 중심화되어 있다고 하자. 단위벡터 $\boldsymbol{v}$ 방향으로 사영한 자료 $\boldsymbol{X v}$ 의 표본 분산은

$$ \mathrm{Var}(\boldsymbol{X v}) = \boldsymbol{v}^{\mathsf T} \Sigma \boldsymbol{v}, \qquad \Sigma = \frac{1}{n-1}\boldsymbol{X}^{\mathsf T}\boldsymbol{X}. $$

PCA 가 푸는 문제는

$$ \max_{\boldsymbol{v}} \;\; \boldsymbol{v}^{\mathsf T}\Sigma\boldsymbol{v} \quad \text{subject to} \quad \boldsymbol{v}^{\mathsf T}\boldsymbol{v} = 1. $$

크기 제약이 없으면 분산은 무한대로 커질 수 있으므로 단위벡터로 고정한다.

### Step 2.  라그랑주 함수

제약 있는 최적화의 라그랑주 함수는

$$ L(\boldsymbol{v}, \lambda) = \boldsymbol{v}^{\mathsf T}\Sigma\boldsymbol{v} - \lambda(\boldsymbol{v}^{\mathsf T}\boldsymbol{v} - 1). $$

$\lambda$ 는 라그랑주 승수 — 지금은 아직 미지수이다.

### Step 3.  편미분 = 0

$\boldsymbol{v}$ 에 대해 편미분을 0 으로 놓는다.

$$ \frac{\partial L}{\partial \boldsymbol{v}} = 2\Sigma\boldsymbol{v} - 2\lambda\boldsymbol{v} = \boldsymbol{0}. $$

정리하면

$$ \Sigma\boldsymbol{v} = \lambda\boldsymbol{v}. $$

이것은 공분산행렬 $\Sigma$ 의 **고유값-고유벡터 방정식**이다.

---

## 3.  두 결론

위 결과로부터 자동으로 두 가지가 따라온다.

1. **$\boldsymbol{v}$ 는 $\Sigma$ 의 고유벡터이다.**  
   즉 \"분산을 최대로 보존하는 방향\" 을 찾는 일이 \"공분산행렬을 대각화하는 일\" 과 같아진다.

2. **$\lambda$ 가 곧 분산이다.**  
   $\Sigma\boldsymbol{v} = \lambda\boldsymbol{v}$ 의 양변에 $\boldsymbol{v}^{\mathsf T}$ 를 곱하고 제약 $\boldsymbol{v}^{\mathsf T}\boldsymbol{v} = 1$ 을 적용하면 $\boldsymbol{v}^{\mathsf T}\Sigma\boldsymbol{v} = \lambda$. 즉 \"라그랑주 승수\" 라는 추상적 도구가 다름 아닌 \"사영 후 분산값\" 이라는 의미를 갖는다.

따라서 **가장 큰 고유값** $\lambda_1$ 에 대응하는 고유벡터 $\boldsymbol{v}_1$ 이 \"가장 분산이 큰 방향\" — 제 1 주성분이다. 두 번째로 큰 고유값에 대응하는 고유벡터가 제 2 주성분, 이런 식으로 계속된다.

---

## 4.  OLS 와의 비교

| | OLS | PCA |
|---|---|---|
| 목적함수 | $\sum (y_i - \beta_0 - \beta_1 x_i)^2$ 최소 | $\boldsymbol{v}^{\mathsf T}\Sigma\boldsymbol{v}$ 최대 |
| 제약 | 없음 | $\|\boldsymbol{v}\| = 1$ |
| 추가 도구 | 그냥 편미분 | 라그랑주 + 편미분 |
| 최종 식 | $\hat{\boldsymbol{\beta}} = (X^{\mathsf T}X)^{-1}X^{\mathsf T}y$ | $\Sigma\boldsymbol{v} = \lambda\boldsymbol{v}$ |
| 푸는 도구 | 연립방정식 | 고유분해 |
| 결과의 \"의미\" | $y$ 를 $x$ 로 가장 잘 예측하는 직선 | 자료의 분산이 가장 큰 방향 |

두 방법 모두 같은 사고방식 — \"미분 = 0\" — 에서 출발한다.

---

## 5.  실무에서 반드시 짚을 것

### 5.1  표준화는 거의 필수

PCA 는 \"분산이 큰 방향\" 을 찾는다. 변수의 단위가 다르면 (예: 키는 cm, 몸무게는 10kg) 단위가 큰 변수가 결과를 지배한다. 거의 모든 실무 상황에서 PCA 직전에 `StandardScaler` 로 평균 0, 표준편차 1 로 표준화한다.

### 5.2  주성분 개수의 결정

세 가지 표준 기준이 있다.

- **Kaiser 기준**: 상관행렬의 고유값이 1 이상인 주성분만 선택한다.
- **누적 분산 비율**: 70 ~ 85 % 를 만족하는 최소 개수.
- **Scree plot 의 팔꿈치**: 고유값 곡선이 급격히 꺾이는 지점 직전까지.

세 기준이 비슷한 답을 줄 때가 많지만, 결정은 분석가의 몫이다.

### 5.3  로딩 해석

각 주성분이 원래 변수들과 어떻게 결합되어 있는지를 보여주는 것이 \"로딩(loadings)\" 이다. 노트북에서 본 iris 의 PC1 은 꽃잎 길이·너비·꽃받침 길이가 함께 큰 양수 — 즉 \"꽃 전체의 크기\" 축이고, PC2 는 꽃받침 너비만 큰 양수 — \"꽃받침 너비의 변동\" 축이다. 로딩을 이름 붙여 해석하는 일이 PCA 의 진짜 가치이다.

---

## 6.  사용 시점 네 가지

1. **차원 축소**
2. **시각화**
3. **다중공선성 해결** (주성분 회귀, PCR)
4. **잡음 제거**

위 네 가지가 아니라면 PCA 를 굳이 쓸 이유가 없다. 도구 선택은 항상 \"왜\" 가 먼저이다.

---

## 7.  다음 노트북으로

- **`Deming_notebook.ipynb`** — X 에도 측정오차가 있을 때, OLS 의 \"수직 잔차 최소화\" 가 \"가중 직교 거리 최소화\" 로 어떻게 일반화되는지. 라그랑주 승수 비율 $\lambda$ 가 등장하며, $\lambda = 1$ 인 특수 경우가 PCA 의 제 1 주성분 방향과 정확히 같음을 본다.

세 노트북을 차례로 읽으면 \"같은 미분, 다른 제약, 한 가족\" 이라는 그림이 한눈에 들어온다.
