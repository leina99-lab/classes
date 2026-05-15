import numpy as np


def section_01_reshape():
    a = np.arange(12)
    b = a.reshape(3, 4)
    assert b.shape == (3, 4)
    assert b[2, 3] == 11
    return b


def section_02_slicing():
    A = np.arange(20).reshape(4, 5)
    out = A[1:4, 0:5:2]
    assert out.tolist() == [[5, 7, 9], [10, 12, 14], [15, 17, 19]]
    return out


def section_03_broadcasting():
    A = np.array([[0, 0, 0], [10, 10, 10], [20, 20, 20], [30, 30, 30]])
    b = np.array([1, 2, 3])
    row_result = A + b
    assert row_result[1, 2] == 13

    c = np.array([[1], [2], [3], [4]])
    col_result = A + c
    assert col_result[3, 0] == 34

    outer = np.array([[0], [10], [20], [30]]) + np.array([1, 2, 3])
    assert outer.shape == (4, 3)
    return row_result, col_result, outer


def section_04_axis():
    A = np.array([[1, 2, 3, 4], [10, 20, 30, 40], [100, 200, 300, 400]])
    assert A.sum(axis=0).tolist() == [111, 222, 333, 444]
    assert A.sum(axis=1).tolist() == [10, 100, 1000]
    return A.sum(axis=0), A.sum(axis=1)


def section_05_matmul():
    A = np.array([[1, 2, 3], [4, 5, 6]])
    B = np.array([[7, 8], [9, 10], [11, 12]])
    C = A @ B
    assert C.tolist() == [[58, 64], [139, 154]]
    assert C[0, 1] == 1 * 8 + 2 * 10 + 3 * 12
    return C


def section_06_view_copy():
    x = np.arange(10)
    view = x[2:6]
    copy = x[2:6].copy()
    view[1] = 99
    assert x[3] == 99
    copy[1] = 77
    assert x[3] == 99
    return x, view, copy


def relu(z):
    return np.maximum(0, z)


def section_07_one_layer_application():
    x = np.array([[1.0, 2.0]])
    W1 = np.array([[0.8, -0.4, 1.2], [0.5, 1.0, -0.7]])
    b1 = np.array([0.1, -0.3, 0.2])
    z1 = x @ W1 + b1
    a1 = relu(z1)
    assert z1.shape == (1, 3)
    assert a1.shape == (1, 3)
    return z1, a1


def main():
    section_01_reshape()
    section_02_slicing()
    section_03_broadcasting()
    section_04_axis()
    section_05_matmul()
    section_06_view_copy()
    section_07_one_layer_application()
    print("all NumPy visual-first checks passed")


if __name__ == "__main__":
    main()
