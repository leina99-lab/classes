# NumPy 학생 워크북

이 워크북은 학생 참고용 MD의 순서를 그대로 따른다. 빈칸 `___`을 채우며 개념을 확인한다.

## 0. 이 수업의 중심

NumPy 수업의 목표는 함수 이름을 많이 외우는 것이 아니라, 배열의 `___`, `___`, 그리고 어떤 `___`끼리 계산되는지를 보는 능력을 기르는 것이다.

<details><summary>정답 보기</summary>

`shape`, `axis`, `칸`

</details>

NumPy의 핵심 객체는 같은 종류의 값을 모아 둔 다차원 배열인 `___`이다.

<details><summary>정답 보기</summary>

`ndarray`

</details>

## 1. 배열과 reshape

`np.arange(12)`는 `___`부터 `___`까지 총 `___`개의 값을 만든다.

<details><summary>정답 보기</summary>

`0`, `11`, `12`

</details>

`reshape(3, 4)`가 가능한 이유는 `3 × 4 = ___`이고 원래 값의 개수도 `___`개이기 때문이다.

<details><summary>정답 보기</summary>

`12`, `12`

</details>

다음 코드의 결과 shape를 쓰시오.

```python
a = np.arange(12)
b = a.reshape(2, 6)
print(b.shape)
```

정답: `___`

<details><summary>정답 보기</summary>

```text
(2, 6)
```

</details>

## 2. indexing과 slicing

NumPy의 index는 `___`부터 시작한다.

<details><summary>정답 보기</summary>

`0`

</details>

다음 slicing에서 선택되는 행 index와 열 index를 쓰시오.

```python
A[1:4, 0:5:2]
```

행 index: `___`  
열 index: `___`

<details><summary>정답 보기</summary>

행 index: `[1, 2, 3]`  
열 index: `[0, 2, 4]`

</details>

## 3. broadcasting

broadcasting에서는 두 배열의 shape를 `___`쪽 차원부터 비교한다.

<details><summary>정답 보기</summary>

`오른쪽`

</details>

두 차원이 호환되는 경우는 두 차원이 `___`거나, 둘 중 하나가 `___`일 때이다.

<details><summary>정답 보기</summary>

`같`, `1`

</details>

다음 계산에서 결과 shape를 쓰시오.

```python
A.shape == (4, 3)
b.shape == (3,)
A + b
```

결과 shape: `___`

<details><summary>정답 보기</summary>

`(4, 3)`

</details>

다음 칸별 계산을 완성하시오.

```text
A = [[0, 0, 0],
     [10, 10, 10],
     [20, 20, 20],
     [30, 30, 30]]

b = [1, 2, 3]
```

```text
결과[1, 2] = A[___, ___] + b[___] = ___ + ___ = ___
```

<details><summary>정답 보기</summary>

```text
결과[1, 2] = A[1, 2] + b[2] = 10 + 3 = 13
```

</details>

다음 broadcasting이 실패하는 이유를 쓰시오.

```text
A.shape = (4, 3)
b.shape = (4,)
```

이유: 마지막 차원에서 `___`과 `___`가 만나는데, 두 값은 같지도 않고 어느 쪽도 `___`이 아니기 때문이다.

<details><summary>정답 보기</summary>

`3`, `4`, `1`

</details>

## 4. axis 집계

`axis=0`은 행 방향으로 내려가며 계산하므로 결과는 각 `___`마다 하나씩 남는다.

<details><summary>정답 보기</summary>

`열`

</details>

`axis=1`은 열 방향으로 가로로 계산하므로 결과는 각 `___`마다 하나씩 남는다.

<details><summary>정답 보기</summary>

`행`

</details>

다음 계산을 완성하시오.

```python
A = np.array([[1, 2, 3, 4],
              [10, 20, 30, 40],
              [100, 200, 300, 400]])
A.sum(axis=0)
```

```text
결과[0] = 1 + 10 + 100 = ___
결과[1] = 2 + 20 + 200 = ___
```

<details><summary>정답 보기</summary>

```text
결과[0] = 111
결과[1] = 222
```

</details>

## 5. 행렬곱

행렬곱 `A @ B`에서 `A.shape = (2, 3)`, `B.shape = (3, 2)`이면 안쪽 차원 `___`과 `___`이 같으므로 곱할 수 있다. 결과 shape는 `___`이다.

<details><summary>정답 보기</summary>

`3`, `3`, `(2, 2)`

</details>

다음 행렬곱의 한 칸 계산을 완성하시오.

```text
A = [[1, 2, 3],
     [4, 5, 6]]

B = [[7, 8],
     [9, 10],
     [11, 12]]
```

```text
C[0, 1] = 1×___ + 2×___ + 3×___ = ___
```

<details><summary>정답 보기</summary>

```text
C[0, 1] = 1×8 + 2×10 + 3×12 = 64
```

</details>

행렬곱에서 `C[i, j]`는 `A`의 `___`번 행과 `B`의 `___`번 열을 곱해서 더한 값이다.

<details><summary>정답 보기</summary>

`i`, `j`

</details>

## 6. view와 copy

view는 원본 data buffer를 복사하지 않고, 같은 데이터를 다르게 보는 `___`이다.

<details><summary>정답 보기</summary>

`창`

</details>

copy는 새 data buffer를 만드는 것이므로 copy를 바꾸어도 원본은 `___`.

<details><summary>정답 보기</summary>

`바뀌지 않는다`

</details>

## 7. 응용: 한 층 계산

한 층 계산의 기본식은 다음과 같다.

$$
z = xW + ___
$$

<details><summary>정답 보기</summary>

`b`

</details>

입력이 2개이고 은닉 노드가 3개이면 `x.shape = (1, 2)`, `W.shape = (2, 3)`이고, `x @ W`의 결과 shape는 `___`이다.

<details><summary>정답 보기</summary>

`(1, 3)`

</details>

다음 계산식을 완성하시오.

```text
z[2] = x[0]×W[0, ___] + x[1]×W[1, ___] + b[___]
```

<details><summary>정답 보기</summary>

```text
z[2] = x[0]×W[0, 2] + x[1]×W[1, 2] + b[2]
```

</details>
