# 워크북 보강: 행렬곱과 브로드캐스팅 계산 경로

## 1. 행렬곱 기본

`A.shape = (m, r)`, `B.shape = (r, n)`이면 `A @ B`의 결과 shape는 `___`이다.

<details>
<summary>정답 보기</summary>

`(m, n)`

가운데 차원 `r`은 계산 과정에서 사라지고, 바깥쪽 차원 `m`, `n`이 결과 shape가 된다.

</details>

---

## 2. 결과 한 칸의 계산식

다음 두 행렬이 있다.

```python
A = np.array([[1, 2, 3],
              [4, 5, 6]])

B = np.array([[7, 8],
              [9, 10],
              [11, 12]])
```

`C = A @ B`일 때 다음 빈칸을 채우시오.

```text
C[0, 1] = 1×___ + 2×___ + 3×___ = ___
```

<details>
<summary>정답 보기</summary>

```text
C[0, 1] = 1×8 + 2×10 + 3×12 = 64
```

`C[0,1]`은 `A`의 0번 행과 `B`의 1번 열의 내적이다.

</details>

---

## 3. 원소별 곱셈과 행렬곱

`A * B`는 같은 위치끼리 곱하는 ___ 연산이고, `A @ B`는 행과 열의 ___을 계산하는 행렬곱이다.

<details>
<summary>정답 보기</summary>

`원소별`, `내적`

</details>

---

## 4. 브로드캐스팅 규칙

브로드캐스팅에서는 두 배열의 shape를 ___쪽 끝 차원부터 비교한다.

<details>
<summary>정답 보기</summary>

`오른쪽`

</details>

---

## 5. 브로드캐스팅 가능 조건

두 차원이 호환되려면 두 크기가 서로 ___거나, 둘 중 하나가 ___이어야 한다.

<details>
<summary>정답 보기</summary>

`같`, `1`

더 자연스럽게 쓰면 “서로 같거나, 둘 중 하나가 1이어야 한다”이다.

</details>

---

## 6. 행 벡터 브로드캐스팅

```python
A = np.array([[1, 2, 3],
              [4, 5, 6]])

b = np.array([10, 20, 30])
C = A + b
```

다음 빈칸을 채우시오.

```text
A.shape = (2, 3)
b.shape = ___
앞에 1을 붙이면 b.shape = ___
C.shape = ___
```

<details>
<summary>정답 보기</summary>

```text
A.shape = (2, 3)
b.shape = (3,)
앞에 1을 붙이면 b.shape = (1, 3)
C.shape = (2, 3)
```

</details>

---

## 7. 행 벡터의 결과 칸 계산

위 예제에서 다음을 완성하시오.

```text
C[1, 2] = A[___, ___] + b[___]
        = ___ + ___
        = ___
```

<details>
<summary>정답 보기</summary>

```text
C[1, 2] = A[1, 2] + b[2]
        = 6 + 30
        = 36
```

</details>

---

## 8. 열 벡터 브로드캐스팅

```python
A = np.array([[1, 2, 3],
              [4, 5, 6]])

col = np.array([[100],
                [200]])
C = A + col
```

다음 빈칸을 채우시오.

```text
A.shape   = ___
col.shape = ___
C.shape   = ___
```

<details>
<summary>정답 보기</summary>

```text
A.shape   = (2, 3)
col.shape = (2, 1)
C.shape   = (2, 3)
```

</details>

---

## 9. 바깥합

```python
A = np.array([[0],
              [10],
              [20],
              [30]])

b = np.array([1, 2, 3])
C = A + b
```

다음 빈칸을 채우시오.

```text
A.shape = ___
b.shape = ___
앞에 1을 붙이면 b.shape = ___
C.shape = ___
```

<details>
<summary>정답 보기</summary>

```text
A.shape = (4, 1)
b.shape = (3,)
앞에 1을 붙이면 b.shape = (1, 3)
C.shape = (4, 3)
```

</details>

---

## 10. 바깥합의 결과 칸

위 예제에서 `C[2, 1]`을 계산하시오.

```text
C[2, 1] = A[___, ___] + b[___]
        = ___ + ___
        = ___
```

<details>
<summary>정답 보기</summary>

```text
C[2, 1] = A[2, 0] + b[1]
        = 20 + 2
        = 22
```

</details>

---

## 11. 실패 예제

```python
A = np.zeros((4, 3))
b = np.array([100, 200, 300, 400])
A + b
```

이 계산은 실패한다. 이유를 채우시오.

```text
A.shape = (4, 3)
b.shape = ___
앞에 1을 붙이면 b.shape = ___
오른쪽 끝 차원에서 ___와 ___가 만난다.
두 값은 같지 않고 어느 쪽도 ___이 아니므로 실패한다.
```

<details>
<summary>정답 보기</summary>

```text
A.shape = (4, 3)
b.shape = (4,)
앞에 1을 붙이면 b.shape = (1, 4)
오른쪽 끝 차원에서 3와 4가 만난다.
두 값은 같지 않고 어느 쪽도 1이 아니므로 실패한다.
```

</details>

---

## 12. 실패 예제 수정

위 실패 예제를 성공시키려면 `b`를 열 벡터로 바꿔야 한다. 빈칸을 채우시오.

```python
b_col = b.reshape(___, ___)
A + b_col
```

<details>
<summary>정답 보기</summary>

```python
b_col = b.reshape(4, 1)
A + b_col
```

이제 `b_col.shape = (4, 1)`이고, 두 번째 차원의 `1`이 A의 3개 열에 반복된다.

</details>

---

## 13. 신경망 편향 덧셈

신경망의 한 층은 보통 다음처럼 계산된다.

```text
Z = X @ W + b
```

다음 빈칸을 채우시오.

```text
X.shape = (32, 784)
W.shape = (784, 128)
X @ W의 shape = ___
b.shape = (128,)
X @ W + b의 shape = ___
```

<details>
<summary>정답 보기</summary>

```text
X @ W의 shape = (32, 128)
X @ W + b의 shape = (32, 128)
```

`b.shape = (128,)`은 `(1, 128)`처럼 해석되어 32개 샘플 행에 반복된다.

</details>
