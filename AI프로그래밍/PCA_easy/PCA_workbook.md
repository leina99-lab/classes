# 문과생을 위한 주성분분석(PCA) — 워크북

빈칸 `____` 을 채우며 책의 내용을 정리한다. 각 문제 아래의 **▶ 정답 보기** 를 누르면 답이 열린다.
코드 빈칸은 `scikit-learn` 의 도구 이름이나 메서드 이름을 채우는 것이다.

---

## 0부 · 숫자의 표로서의 행렬

**문제 0-1.** 행렬에서 가로줄(행) 하나는 한 `____` 를 가리키고, 세로줄(열) 하나는 한 `____` 를 가리킨다.

<details><summary>▶ 정답 보기</summary>

가로줄(행) → **사례**(예: 꽃 한 송이) · 세로줄(열) → **변수**(예: 꽃잎 길이)

</details>

**문제 0-2.** 전치(transpose)는 표를 `____` 도 돌려 가로줄과 세로줄을 맞바꾸는 일이다. 담긴 숫자는 (변한다 / 변하지 않는다).

<details><summary>▶ 정답 보기</summary>

**90** 도 · 담긴 숫자는 **변하지 않는다**. 보는 방향만 달라진다.

</details>

**문제 0-3.** 단위행렬 *I* 는 행렬 세계의 `____` 이고, 어떤 표 *A* 에 그 역행렬을 곱하면 `A × A⁻¹ = ____` 가 된다.

<details><summary>▶ 정답 보기</summary>

*I* 는 행렬 세계의 **1** · *A* × *A*⁻¹ = **I**(단위행렬)

</details>

**문제 0-4.** 대칭 행렬은 대각선을 거울 삼아 위아래가 같은 표이며, 식으로는 *A*ᵢⱼ = `____` 이다. 친구 관계도에 비유하면 친함이 언제나 `____` 이기 때문이다.

<details><summary>▶ 정답 보기</summary>

*A*ᵢⱼ = **A**ⱼᵢ · 친함이 언제나 **양방향**이기 때문이다.

</details>

**문제 0-5.** 두 화살표가 `____` 도로 만나 서로 영향을 주지 않는 관계를 `____` 라 한다.

<details><summary>▶ 정답 보기</summary>

**90** 도(직각) · **직교**(orthogonal)

</details>

---

## 1부 · 왜 PCA 가 필요한가

**문제 1-1.** 변수가 네 개인 자료는 `____` 차원에 살고, 그래서 그림으로 (그릴 수 있다 / 그릴 수 없다).

<details><summary>▶ 정답 보기</summary>

**4** 차원 · **그릴 수 없다**(4차원부터는 종이에도 화면에도 그릴 수 없다).

</details>

**문제 1-2.** PCA 는 변수를 버리는 대신, 서로 비슷하게 움직이는 변수들을 `____` 새 변수 몇 개로 만든다. 이 새 변수를 `____` 이라 부른다.

<details><summary>▶ 정답 보기</summary>

서로 비슷하게 움직이는 변수들을 **묶어** 새 변수로 만든다 · 새 변수 → **주성분**(PC, principal component)

</details>

---

## 2부 · PCA 의 일곱 단계

**문제 2-1.** 일곱 단계의 이름을 차례로 채운다.

1. `____` — 모든 값에서 평균을 뺀다
2. `____` — 단위를 같은 척도로 맞춘다
3. `____` — 변수끼리 함께 움직이는 정도를 표로 모은다
4. `____` — 자료가 늘어진 방향과 그 크기를 찾는다
5. 대칭의 마법 — 전치만으로 되돌릴 수 있다
6. `____` — 각 사례를 새 좌표 값으로 옮긴다
7. `____` — 큰 방향 몇 개만 남긴다

<details><summary>▶ 정답 보기</summary>

1. **센터링**(centering) 2. **표준화**(standardization) 3. **공분산행렬**(covariance matrix)
4. **고유치 분해**(eigen-decomposition) 6. **PC 스코어**(score) 7. **차원 축소**

</details>

---

## 3부 · 일곱 단계 자세히

**문제 3-1.** 키가 커질 때 몸무게도 함께 커지면 공분산은 `____`(양수 / 음수 / 0)다. 키와 신발 끈 길이처럼 무관하면 공분산은 `____` 에 가깝다.

<details><summary>▶ 정답 보기</summary>

함께 커지면 **양수** · 무관하면 **0** 에 가깝다.

</details>

**문제 3-2.** 분산은 어떤 변수를 자기 자신과 짝지은 공분산이다. 식으로는 `Var(x) = Cov(____, ____)` 이다.

<details><summary>▶ 정답 보기</summary>

Var(*x*) = Cov(**x**, **x**)

</details>

**문제 3-3.** 센터링은 모든 값에서 그 변수의 `____` 을 빼는 일이며, 그 결과 자료의 새 평균은 `____` 이 된다.

<details><summary>▶ 정답 보기</summary>

**평균**을 뺀다 · 새 평균은 **0** 이 된다.

</details>

**문제 3-4.** 표준화는 평균을 빼고 `____` 로 나누는 일이며, 그 결과 단위가 다른 변수들도 같은 척도가 된다. 공식 카드로는 `z = (x − μ) / ____` 이다.

<details><summary>▶ 정답 보기</summary>

**표준편차**(σ)로 나눈다 · *z* = (*x* − μ) / **σ**

</details>

**문제 3-5.** 공분산행렬은 변수끼리의 친한 정도를 모은 `____`(행 × 열) 표이며, 언제나 `____`(대칭 / 비대칭) 이다.

<details><summary>▶ 정답 보기</summary>

*p* × *p* 표 · 언제나 **대칭**이다.

</details>

**문제 3-6.** 고유치 분해에서 뽑아낸 방향을 `____`, 그 방향의 크기를 `____` 라 한다. 가장 큰 크기를 가진 방향이 곧 `____` 이다.

<details><summary>▶ 정답 보기</summary>

방향 → **고유벡터**(eigenvector) · 크기 → **고유치**(eigenvalue) · 가장 큰 방향 → **PC1**

</details>

**문제 3-7.** PCA 가 찾은 방향들을 세로줄로 모은 표 *X* 는 직교 행렬이라, 까다로운 역행렬 대신 `____`(90도 돌리기)만 하면 된다. 식으로는 `X⁻¹ = ____` 이다.

<details><summary>▶ 정답 보기</summary>

**전치**(transpose)만 하면 된다 · *X*⁻¹ = *X*ᵀ

</details>

**문제 3-8.** 각 사례를 새 좌표 위의 값으로 옮긴 것을 `____` 라 한다.

<details><summary>▶ 정답 보기</summary>

**PC 스코어**(score)

</details>

---

## 5부 · iris 자료로 직접 — 코드 채우기

아래 셀들을 차례로 채운다. 먼저 자료를 불러왔다고 가정한다(노트북의 준비 셀 참고).

**코드 3-1.** 네 변수를 같은 척도로 만드는 표준화 도구를 채운다.

```python
from sklearn.preprocessing import StandardScaler
Z = ____().fit_transform(iris.data)   # 빈칸: 표준화 도구 이름
print(Z.mean(axis=0).round(2))        # [0. 0. 0. 0.]
print(Z.std(axis=0).round(2))         # [1. 1. 1. 1.]
```

<details><summary>▶ 정답 보기</summary>

```python
Z = StandardScaler().fit_transform(iris.data)
```

</details>

**코드 3-2.** 방향을 찾고(맞추고) 각 PC 의 정보 비율을 출력한다.

```python
from sklearn.decomposition import PCA
pca = PCA().____(Z)                    # 빈칸 1: 자료에 맞추는 메서드
print(pca.________________.round(4))   # 빈칸 2: 설명 비율 속성
# [0.7296 0.2285 0.0367 0.0052]
```

<details><summary>▶ 정답 보기</summary>

```python
pca = PCA().fit(Z)
print(pca.explained_variance_ratio_.round(4))
```

</details>

**코드 3-3.** 각 꽃을 새 좌표(PC) 값으로 옮긴다.

```python
scores = pca.____(Z)                   # 빈칸: 새 좌표로 옮기는 메서드
print(scores[:3, :2].round(2))
```

<details><summary>▶ 정답 보기</summary>

```python
scores = pca.transform(Z)
```

</details>

**코드 3-4.** 누적 정보 비율을 확인한다. 앞쪽 두 방향이 약 96%를 채운다.

```python
import numpy as np
print(np.______(pca.explained_variance_ratio_).round(3))  # 빈칸: 누적합 함수
# [0.73 0.958 0.995 1.   ]
```

<details><summary>▶ 정답 보기</summary>

```python
print(np.cumsum(pca.explained_variance_ratio_).round(3))
```

</details>

**코드 3-5.** 각 변수가 PC1 에 기여하는 정도를 본다.

```python
print(pca.__________[0].round(2))      # 빈칸: 기여도(방향) 속성
# [ 0.52 -0.27  0.58  0.56]
```

<details><summary>▶ 정답 보기</summary>

```python
print(pca.components_[0].round(2))
```

</details>

---

## 마무리 · 결과 해석 채우기

**문제 5-1.** 표준화 후 PCA 에서 PC1 은 약 `____`%, PC2 는 약 `____`% 를 설명하며, 두 방향을 더하면 약 `____`% 다.

<details><summary>▶ 정답 보기</summary>

PC1 ≈ **73**% · PC2 ≈ **23**% · 합계 ≈ **96**%

</details>

**문제 5-2.** 기여도를 읽으면 PC1 은 `____` 축, PC2 는 사실상 `____` 축이다.

<details><summary>▶ 정답 보기</summary>

PC1 → **꽃 전체 크기** · PC2 → **꽃받침 너비**

</details>

**문제 5-3.** 세 품종 가운데 `____` 는 PC1 한 축만으로 다른 두 품종과 완전히 분리된다.

<details><summary>▶ 정답 보기</summary>

**setosa**

</details>
