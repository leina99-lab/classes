# 선형판별분석(LDA) 학생 워크북

라벨이 있을 때 무리를 가장 잘 가르는 축을 찾는 이야기

---

이 워크북은 빈칸을 채우며 **선형판별분석**(LDA)의 흐름을 스스로 복원하는 자료다. 각 빈칸의 번호 ①②③ 아래에 있는 **정답 보기** 토글을 누르면 답을 확인할 수 있다. 먼저 스스로 채운 뒤에 펼쳐 확인하는 순서를 권한다. 개념 빈칸과 코드 빈칸이 번갈아 나오며, 마지막에는 코드 연습문제 12개가 정답과 함께 붙어 있다.

---

## 0부 · 평균과 흩어짐을 한 점·한 수로 보기

### 0.1 평균은 한 무리의 중심 한 점이다

여러 점이 흩어져 있을 때 그 점들을 대표하는 한 점을 고른다면 ①\_\_\_\_\_\_ 이 가장 자연스럽다. 가로 위치끼리, 세로 위치끼리 각각 평균을 내면 무리 한가운데에 점 하나가 찍힌다. 이 점이 그 무리의 ②\_\_\_\_\_\_ 이다. 어느 한 점이 무리에서 멀리 떨어져 있어도 중심은 전체를 고르게 반영한 위치에 놓인다.

<details><summary>▶ 정답 보기</summary>

① 평균  ② 중심

</details>

### 0.2 흩어짐은 중심에서 점들이 퍼진 정도다

같은 중심을 가진 두 무리라도 한쪽은 중심 가까이 옹기종기 모여 있고 다른 쪽은 넓게 퍼져 있을 수 있다. 중심에서 점들이 얼마나 멀리까지 퍼졌는지를 한 수로 나타낸 것이 ①\_\_\_\_\_\_ 이다. 점들이 중심 가까이 모이면 흩어짐이 ②\_\_\_\_(작/크)고, 멀리까지 번지면 흩어짐이 ③\_\_\_\_(작/크)다.

<details><summary>▶ 정답 보기</summary>

① 흩어짐  ② 작  ③ 크

</details>

### 0.3 두 무리를 가를 때는 중심 사이 거리와 각자의 퍼짐을 함께 본다

무리가 둘로 나뉘어 있을 때 두 무리가 잘 갈렸는가를 따지려면 두 가지를 함께 봐야 한다. 하나는 두 무리의 ①\_\_\_\_\_\_ 이 얼마나 멀리 떨어졌나이고, 다른 하나는 각 무리가 자기 중심 둘레에 얼마나 좁게 ②\_\_\_\_\_\_ 인가이다. 중심이 멀어도 각 무리가 넓게 번져 서로 겹치면 깨끗이 갈렸다고 하기 어렵다. 그래서 "중심 사이 거리는 ③\_\_\_\_(멀게/좁게), 각자의 퍼짐은 ④\_\_\_\_(멀게/좁게)"라는 두 조건을 함께 본다. 이 두 가지가 LDA 의 핵심 잣대가 된다.

<details><summary>▶ 정답 보기</summary>

① 중심  ② 모였(모였나)  ③ 멀게  ④ 좁게

</details>

---

## 1부 · 라벨이 있을 때 PCA 로는 아쉬운 점

### 1.1 자료에 무리 라벨이 붙어 있을 때

어떤 자료에는 각 점이 어느 무리에 속하는지를 적은 ①\_\_\_\_ 이 함께 있다. 학생들의 공부 시간과 출석률을 점으로 찍었는데 각 점이 합격인지 불합격인지가 표시돼 있는 경우다. **주성분분석**(PCA)은 라벨을 ②\_\_\_\_(쓴/쓰지 않는)다. **선형판별분석**(LDA)은 라벨을 ③\_\_\_\_(무시/적극 활용)한다.

<details><summary>▶ 정답 보기</summary>

① 라벨  ② 쓰지 않는  ③ 적극 활용

</details>

### 1.2 PCA 의 축과 LDA 의 축은 다를 수 있다

PCA 는 라벨을 보지 않고 자료 전체가 가장 ①\_\_\_\_ 퍼지는 방향을 고른다. 그런데 라벨이 있는 자료에서는 전체가 가장 넓게 퍼지는 방향과 두 무리가 가장 잘 ②\_\_\_\_\_\_ 방향이 서로 다를 수 있다. 운동장의 두 팀에 비유하면, PCA 는 사람들이 가장 넓게 퍼져 보이는 각도로 사진을 찍고, LDA 는 두 팀이 가장 깔끔하게 ③\_\_\_\_\_\_ 보이는 각도로 사진을 찍는다.

<details><summary>▶ 정답 보기</summary>

① 넓게  ② 갈라지는  ③ 갈라져

</details>

---

## 2부 · LDA 의 여섯 단계 한눈에 보기

LDA 는 여섯 개의 작은 단계로 이루어진다. 단계의 묶음을 빈칸으로 채워 본다.

| 묶음 | 단계 | 하는 일 |
| --- | --- | --- |
| 준비 | 1·2·3단계 | 무리의 ①\_\_\_\_ 을 잰다 |
| 실행 | 4·5·6단계 | ②\_\_\_\_ 을 골라 점을 비춘다 |

PCA 가 "전체 퍼짐"을 재서 가장 퍼진 방향을 골랐다면, LDA 는 "③\_\_\_\_\_\_ ÷ ④\_\_\_\_\_\_"를 재서 가장 잘 갈리는 방향을 고른다. 무엇을 재느냐만 다를 뿐, 재서 방향을 고르고 비춘다는 큰 흐름은 같다.

<details><summary>▶ 정답 보기</summary>

① 모양  ② 방향  ③ 무리 간(클래스 간)  ④ 무리 내(클래스 내)

</details>

---

## 3부 · 여섯 단계를 차례로 풀기

### 3.1 (1단계) 무리 중심과 전체 중심을 구한다

무리마다 ①\_\_\_\_ 을 찍는다. A 무리의 점들로 평균을 내면 A 의 중심이, B 무리의 점들로 평균을 내면 B 의 중심이 나온다. 여기에 더해 무리를 가리지 않고 모든 점으로 평균을 낸 ②\_\_\_\_ 중심도 하나 구한다. 전체 중심은 두 무리 중심의 ③\_\_\_\_ 어딘가에 놓인다.

<details><summary>▶ 정답 보기</summary>

① 중심  ② 전체  ③ 사이

</details>

### 3.2 (2단계) 클래스 내 흩어짐 — 각 무리가 얼마나 모였나

각 무리의 점들이 자기 무리 중심에서 얼마나 퍼졌는지를 재서 모두 더한 것이 ①\_\_\_\_\_\_\_\_(within-class scatter)이다. 각 점에서 자기 무리 중심까지 이은 선들이 모두 짧으면 이 흩어짐이 ②\_\_\_\_(작/크)다. LDA 는 이 흩어짐이 ③\_\_\_\_(작을/클)수록 좋다고 본다. 무리가 좁게 모여 있어야 다른 무리와 겹치지 않기 때문이다.

<details><summary>▶ 정답 보기</summary>

① 클래스 내 흩어짐  ② 작  ③ 작을

</details>

### 3.3 (3단계) 클래스 간 흩어짐 — 무리 중심들이 얼마나 떨어졌나

각 무리의 중심이 ①\_\_\_\_ 중심에서 얼마나 멀리 떨어졌는지를 재서 모은 것이 ②\_\_\_\_\_\_\_\_(between-class scatter)이다. 무리 중심들이 서로 멀리 떨어질수록 이 흩어짐이 ③\_\_\_\_(작/크)다. LDA 는 이 흩어짐이 ④\_\_\_\_(작을/클)수록 좋다고 본다.

<details><summary>▶ 정답 보기</summary>

① 전체  ② 클래스 간 흩어짐  ③ 크  ④ 클

</details>

### 3.4 (4단계) 판별 방향 — 비율을 가장 크게 하는 축

두 흩어짐을 한 비율로 묶는다. 클래스 간 흩어짐을 클래스 내 흩어짐으로 ①\_\_\_\_ 비율이다. 식으로 쓰면 다음과 같다.

$$ J(w) = \frac{\text{클래스 간 흩어짐}}{\text{클래스 내 흩어짐}} = \frac{w^{\top} S_B\, w}{w^{\top} S_W\, w} $$

이 비율이 ②\_\_\_(클/작을)수록 "무리 중심은 멀고 각 무리는 좁게 모인" 좋은 상태다. LDA 는 이 비율을 가장 ③\_\_\_\_ 만드는 방향을 찾고, 그 방향을 ④\_\_\_\_\_\_(LD1)이라 한다.

<details><summary>▶ 정답 보기</summary>

① 나눈  ② 클  ③ 크게  ④ 판별 방향

</details>

### 3.5 (5·6단계) 사영과 무리 가르기

방향을 찾았으면 각 점을 그 방향 위에 비춘다. 점을 한 방향 위의 값으로 옮기는 일을 ①\_\_\_\_ 이라 하고, 그렇게 얻은 값을 ②\_\_\_\_\_\_ 라 한다. 점들을 판별 방향에 비추면 A 무리는 한쪽으로, B 무리는 다른 쪽으로 몰려 둘이 거의 ③\_\_\_\_(겹치지 않/겹치)는다. 이제 선 위에서 어느 지점을 ④\_\_\_\_ 로 삼으면 두 무리를 깔끔하게 나눌 수 있다.

<details><summary>▶ 정답 보기</summary>

① 사영  ② LD 스코어  ③ 겹치지 않  ④ 경계

</details>

---

## 4부 · 새 축의 개수와 PCA 와의 한눈 비교

### 4.1 LDA 가 만들 수 있는 새 축의 개수

PCA 는 원래 ①\_\_\_\_ 의 개수만큼 새 축(주성분)을 만들 수 있었다. 그러나 LDA 가 만들 수 있는 새 축의 개수는 무리(클래스)의 개수에서 ②\_\_\_\_ 을 뺀 값까지다. 무리가 둘이면 LDA 축은 ③\_\_ 개, 셋이면 ④\_\_ 개, 넷이면 ⑤\_\_ 개다. 변수가 아무리 많아도 이 개수를 넘지 못한다.

<details><summary>▶ 정답 보기</summary>

① 변수  ② 하나(1)  ③ 1  ④ 2  ⑤ 3

</details>

### 4.2 PCA 와 LDA 를 한 표로

빈칸을 채워 두 방법의 차이를 정리한다.

| 항목 | PCA | LDA |
| --- | --- | --- |
| 라벨 사용 | ①\_\_\_\_(쓴다/안 쓴다) | ②\_\_\_\_(쓴다/안 쓴다) |
| 고르는 방향 | 전체가 가장 ③\_\_\_ 퍼지는 방향 | 무리가 가장 잘 ④\_\_\_\_ 방향 |
| 재는 기준 | 전체 퍼짐 | 클래스 간 ÷ 클래스 ⑤\_ |
| 새 축 최대 개수 | 변수 개수 | 클래스 개수 − ⑥\_ |
| 목적 | 자료를 가장 잘 ⑦\_\_\_\_ | 무리를 가장 잘 ⑧\_\_\_\_ |

<details><summary>▶ 정답 보기</summary>

① 안 쓴다  ② 쓴다  ③ 넓게  ④ 갈리는(갈라지는)  ⑤ 내  ⑥ 1  ⑦ 보존(재현)  ⑧ 가른다(분리)

</details>

한 문장으로 줄이면, PCA 는 자료를 가장 잘 보존하는 방향을, LDA 는 무리를 가장 잘 가르는 방향을 찾는다. 라벨이 없거나 자료의 큰 구조를 살피려면 PCA 를, 라벨이 있고 그 무리를 잘 가르는 것이 목적이면 LDA 를 고른다.

---

## 5부 · iris 자료로 처음부터 끝까지 (코드 핑퐁)

아래 코드의 빈칸 `____` 을 채워 실행한다. 각 칸의 정답은 토글에 있다.

### 5.1 자료 가져오기와 LDA 한 줄

붓꽃 자료(150 송이, 4 변수, 3 품종)를 표준화한 뒤 LDA 를 적용한다. PCA 와 달리 LDA 는 품종 라벨 `y` 를 반드시 함께 넣는다.

```python
# iris 에 LDA 적용 — 라벨 y 를 함께 넣는다 (sklearn)
from sklearn.datasets import load_iris
from sklearn.preprocessing import StandardScaler
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

iris = load_iris()
Z = StandardScaler().fit_transform(iris.____)        # ①  4 변수 표준화
y = iris.____                                        # ②  품종 라벨
lds = LinearDiscriminantAnalysis(n_components=____)\
        .fit_transform(Z, ____)                      # ③ 축 개수, ④ 라벨
print(lds.shape)                                     # (150, 2)
```

<details><summary>▶ 정답 보기</summary>

① `data`  ② `target`  ③ `2`  ④ `y`

`fit_transform(Z, y)` 에 라벨 `y` 가 들어간 점이 PCA 와 결정적으로 다르다. 라벨을 빼면 LDA 는 동작하지 않는다.

</details>

### 5.2 LDA 평면에 세 품종 그리기

옮긴 좌표를 LD1·LD2 평면에 찍어 세 품종을 본다.

```python
import matplotlib.pyplot as plt

for k, name in enumerate(iris.target_names):
    sel = (y == ____)                  # ① 현재 품종만 고르기
    plt.scatter(lds[sel, 0], lds[sel, ____], label=name)   # ② LD2 열
plt.xlabel("LD1"); plt.ylabel("LD2")
plt.legend(); plt.show()
```

<details><summary>▶ 정답 보기</summary>

① `k`  ② `1`

세 품종이 뚜렷한 세 덩어리로 갈린다. 특히 가로축 LD1 하나만으로도 품종이 거의 다 나뉜다.

</details>

### 5.3 PCA 와 LDA 를 한 축으로 견주기

같은 iris 를 PCA 의 한 축(PC1)과 LDA 의 한 축(LD1)으로 각각 압축해 견준다.

```python
from sklearn.decomposition import PCA

pc1 = PCA(n_components=2).fit_transform(____)[:, 0]            # ① 라벨 없이 Z 만
ld1 = LinearDiscriminantAnalysis(n_components=2)\
        .fit_transform(Z, ____)[:, 0]                         # ② 라벨 함께
print("PCA 첫 꽃 PC1:", pc1[0].round(2))
print("LDA 첫 꽃 LD1:", ld1[0].round(2))
```

<details><summary>▶ 정답 보기</summary>

① `Z`  ② `y`

PCA 한 축으로 압축하면 versicolor 와 virginica 가 가운데서 제법 겹치지만, LDA 한 축으로 압축하면 세 품종이 좌·중·우로 거의 겹치지 않고 갈린다.

</details>

---

## 6부 · 코드 연습문제 12제 (빈칸 채우기)

LDA 와 PCA 의 sklearn 사용 유형을 반복 연습한다. 빈칸 `____` 을 채운 뒤 정답을 확인한다.

### 연습 1 — LDA 임포트

```python
from sklearn.discriminant_analysis import ____
```

<details><summary>▶ 정답 보기</summary>

`LinearDiscriminantAnalysis`

</details>

### 연습 2 — 모델 객체 만들기

축을 2 개 만드는 LDA 객체를 생성한다.

```python
lda = LinearDiscriminantAnalysis(____=2)
```

<details><summary>▶ 정답 보기</summary>

`n_components`

</details>

### 연습 3 — 학습과 변환을 한 번에 (라벨 필수)

```python
scores = lda.____(Z, ____)        # ① 메서드, ② 라벨
```

<details><summary>▶ 정답 보기</summary>

① `fit_transform`  ② `y`

</details>

### 연습 4 — 표준화 먼저

LDA 적용 전 변수 스케일을 맞춘다.

```python
from sklearn.preprocessing import ____
Z = StandardScaler().____(X)       # ① 클래스, ② 학습+변환 메서드
```

<details><summary>▶ 정답 보기</summary>

① `StandardScaler`  ② `fit_transform`

</details>

### 연습 5 — 학습과 예측을 나눠 쓰기

새 데이터 `X_new` 의 클래스를 맞힌다.

```python
lda.fit(X_train, y_train)
pred = lda.____(X_new)             # 클래스 예측
```

<details><summary>▶ 정답 보기</summary>

`predict`

</details>

### 연습 6 — 각 축이 설명하는 분리 비율

LD 축들이 품종 분리를 각각 얼마나 담당하는지 본다.

```python
lda.fit(Z, y)
print(lda.____)                    # 예: [0.99, 0.01]
```

<details><summary>▶ 정답 보기</summary>

`explained_variance_ratio_`

LD1 이 품종 분리의 약 99% 를 담당한다.

</details>

### 연습 7 — 새 축의 최대 개수 (클래스 3개)

iris 는 품종이 3 개이므로 LDA 축의 최대 개수를 식으로 쓴다.

```python
n_classes = len(set(y))            # 3
max_axes = n_classes ____ 1        # 연산자
print(max_axes)                    # 2
```

<details><summary>▶ 정답 보기</summary>

`-`  (클래스 개수 − 1)

</details>

### 연습 8 — PCA 객체와 비교

라벨 없이 동작하는 PCA 를 만든다.

```python
from sklearn.decomposition import ____
pca = PCA(n_components=2)
pc = pca.fit_transform(____)       # ① 클래스, ② 라벨 없이 Z 만
```

<details><summary>▶ 정답 보기</summary>

① `PCA`  ② `Z`

PCA 는 라벨을 넣지 않는다. `fit_transform(Z)` 처럼 데이터만 넣는다.

</details>

### 연습 9 — 첫 번째 축만 뽑기

변환 결과에서 LD1 열만 가져온다.

```python
ld1 = lda.fit_transform(Z, y)[:, ____]   # 첫 번째 열
```

<details><summary>▶ 정답 보기</summary>

`0`

</details>

### 연습 10 — 산점도에서 한 품종만 고르기

품종 인덱스 `k` 인 점만 불리언으로 고른다.

```python
sel = (y ____ k)                   # 비교 연산자
plt.scatter(scores[sel, 0], scores[sel, 1])
```

<details><summary>▶ 정답 보기</summary>

`==`

</details>

### 연습 11 — 분류 정확도 확인

학습한 LDA 의 정확도를 잰다.

```python
lda.fit(X_train, y_train)
acc = lda.____(X_test, y_test)     # 정확도 반환 메서드
print(acc)
```

<details><summary>▶ 정답 보기</summary>

`score`

</details>

### 연습 12 — 한 줄 파이프라인 (표준화 + LDA)

표준화와 LDA 를 하나의 파이프라인으로 묶는다.

```python
from sklearn.pipeline import make_pipeline
pipe = make_pipeline(StandardScaler(),
                     LinearDiscriminantAnalysis(n_components=2))
out = pipe.____(X, y)              # 학습+변환을 한 번에
```

<details><summary>▶ 정답 보기</summary>

`fit_transform`

표준화 단계를 포함해도 라벨 `y` 는 그대로 함께 넣는다.

</details>

---

## 마무리 한 줄 정리

빈칸을 모두 채웠다면 다음 한 문장을 스스로 말로 설명할 수 있어야 한다. "LDA 는 클래스 ____ 흩어짐은 크게, 클래스 ____ 흩어짐은 작게 만드는 ____ 을 찾아 점을 비추는 방법이다."

<details><summary>▶ 정답 보기</summary>

클래스 **간** 흩어짐은 크게, 클래스 **내** 흩어짐은 작게 만드는 **방향(판별 방향, LD1)** 을 찾아 점을 비추는 방법이다.

</details>
