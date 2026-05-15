"""워크북 해답 확인용 코드."""
import numpy as np

A = np.arange(20).reshape(4, 5)
assert A[1:4, 0:5:2].tolist() == [[5, 7, 9], [10, 12, 14], [15, 17, 19]]

A = np.array([[0, 0, 0], [10, 10, 10], [20, 20, 20], [30, 30, 30]])
b = np.array([1, 2, 3])
assert (A + b)[1, 2] == 13

B = np.array([[7, 8], [9, 10], [11, 12]])
M = np.array([[1, 2, 3], [4, 5, 6]])
assert (M @ B)[0, 1] == 64

x = np.array([[1.0, 2.0]])
W = np.array([[0.8, -0.4, 1.2], [0.5, 1.0, -0.7]])
bias = np.array([0.1, -0.3, 0.2])
z = x @ W + bias
assert z.shape == (1, 3)
print("workbook solution checks passed")
