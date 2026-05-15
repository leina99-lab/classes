"""
================================================================================
  PCA 와 Deming 회귀 ─ 학생용 예제 코드
================================================================================

  과목 : 기계학습 / 다변량 통계 분석
  주제 : 주성분 분석(PCA) 과 Deming 회귀의 Python 실습
  필요 라이브러리 : numpy, pandas, matplotlib, scikit-learn, scipy, seaborn
                   (모두 표준 데이터 과학 스택에 포함)

  실행 방법
      python pca_deming_examples.py
      또는 각 함수를 Jupyter 셀에서 개별 실행

  이 파일은 다섯 개의 예제로 구성된다.
      예제 1 - 표준화의 중요성
      예제 2 - iris 자료의 PCA 와 시각화
      예제 3 - 주성분 회귀 (PCR) 로 다중공선성 해결
      예제 4 - Deming 회귀 ─ 두 측정기기 비교
      예제 5 - λ 값에 따른 회귀선의 변화 (OLS, Deming, Orthogonal)
================================================================================
"""

from __future__ import annotations

import warnings

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

warnings.filterwarnings("ignore", category=FutureWarning)
warnings.filterwarnings("ignore", category=UserWarning)

# 재현 가능성 확보
RNG = np.random.default_rng(seed=20260515)
plt.rcParams["axes.unicode_minus"] = False  # 한글 환경에서 음수 표시
plt.rcParams["figure.dpi"] = 110


# ──────────────────────────────────────────────────────────────────────────────
#  예제 1 ─ 표준화의 중요성
# ──────────────────────────────────────────────────────────────────────────────
def example_01_standardization() -> None:
    """
    PCA 는 분산을 기준으로 축을 잡기 때문에 단위가 큰 변수가 결과를 지배한다.
    같은 자료를 표준화 전 / 후로 PCA 하여 첫 주성분의 방향이 어떻게 달라지는지
    비교한다.
    """
    print("\n=== 예제 1. 표준화 전 / 후 PCA 비교 ===")

    # '키 (cm 단위, 분산 약 100)' 와 '몸무게 (10kg 단위, 분산 약 1)' 처럼
    # 단위 차이가 극단적인 자료를 만든다.
    n = 200
    height_cm = RNG.normal(loc=170, scale=10, size=n)
    weight_10kg = 0.07 * height_cm + RNG.normal(loc=0, scale=0.5, size=n)
    X = np.column_stack([height_cm, weight_10kg])

    from sklearn.decomposition import PCA
    from sklearn.preprocessing import StandardScaler

    # 표준화 없이
    pca_raw = PCA(n_components=2).fit(X)

    # 표준화 후
    Xs = StandardScaler().fit_transform(X)
    pca_std = PCA(n_components=2).fit(Xs)

    print("표준화 X  : 제1주성분 방향 =", np.round(pca_raw.components_[0], 4),
          "  설명력 =", np.round(pca_raw.explained_variance_ratio_[0], 4))
    print("표준화 O  : 제1주성분 방향 =", np.round(pca_std.components_[0], 4),
          "  설명력 =", np.round(pca_std.explained_variance_ratio_[0], 4))

    # 표준화 없이 PCA 를 하면 단위가 큰 변수 (키, cm) 가 거의 모든 분산을
    # 차지하므로 제1주성분이 사실상 '키'가 된다. 표준화 후에는 두 변수가
    # 균형 있게 결합된다.


# ──────────────────────────────────────────────────────────────────────────────
#  예제 2 ─ iris 자료의 PCA 와 2차원 시각화
# ──────────────────────────────────────────────────────────────────────────────
def example_02_iris_pca() -> None:
    """
    iris 의 4개 변수 (꽃받침/꽃잎 길이·너비) 를 2개의 주성분으로 축약하여
    품종이 어떻게 분포하는지 시각적으로 확인한다.
    """
    print("\n=== 예제 2. iris 자료의 PCA 와 시각화 ===")

    from sklearn.datasets import load_iris
    from sklearn.decomposition import PCA
    from sklearn.preprocessing import StandardScaler

    iris = load_iris()
    X, y = iris.data, iris.target
    feature_names = iris.feature_names

    Xs = StandardScaler().fit_transform(X)
    pca = PCA(n_components=4).fit(Xs)  # 전체를 다 봐서 누적 설명력을 확인

    print("고유값 (eigenvalues) :", np.round(pca.explained_variance_, 4))
    print("설명력 비율          :", np.round(pca.explained_variance_ratio_, 4))
    print("누적 설명력          :", np.round(np.cumsum(pca.explained_variance_ratio_), 4))

    # 처음 두 주성분으로 사영
    Z = PCA(n_components=2).fit_transform(Xs)
    df = pd.DataFrame(Z, columns=["PC1", "PC2"])
    df["species"] = [iris.target_names[i] for i in y]

    # 시각화
    fig, axes = plt.subplots(1, 2, figsize=(11, 4.5))

    # (a) Scree plot
    axes[0].plot(np.arange(1, 5), pca.explained_variance_,
                 marker="o", color="#1E2761", linewidth=2.5)
    axes[0].axhline(1.0, color="#E0A11B", linestyle="--", linewidth=1.2,
                    label="Kaiser 기준 (λ=1)")
    axes[0].set_xlabel("주성분 번호")
    axes[0].set_ylabel("고유값 λ")
    axes[0].set_title("Scree plot")
    axes[0].legend()
    axes[0].grid(alpha=0.3)

    # (b) 2차원 산점도
    palette = {"setosa": "#1E2761", "versicolor": "#E0A11B", "virginica": "#6D2E46"}
    for sp, sub in df.groupby("species"):
        axes[1].scatter(sub["PC1"], sub["PC2"], label=sp,
                        color=palette[sp], alpha=0.75, s=45,
                        edgecolor="white", linewidth=0.7)
    axes[1].set_xlabel(f"PC1 ({pca.explained_variance_ratio_[0]*100:.1f}%)")
    axes[1].set_ylabel(f"PC2 ({pca.explained_variance_ratio_[1]*100:.1f}%)")
    axes[1].set_title("iris : 처음 두 주성분으로 본 분포")
    axes[1].legend(title="품종")
    axes[1].grid(alpha=0.3)

    plt.tight_layout()
    plt.savefig("/home/claude/work/fig_iris_pca.png", dpi=120, bbox_inches="tight")
    plt.close()
    print("→ 그림 저장 : fig_iris_pca.png")

    # 로딩(loadings) : 각 주성분이 원래 변수와 얼마나 상관되어 있는가?
    loadings = pd.DataFrame(
        pca.components_[:2].T,
        columns=["PC1", "PC2"],
        index=feature_names,
    )
    print("\n로딩 (loadings) :")
    print(loadings.round(3))


# ──────────────────────────────────────────────────────────────────────────────
#  예제 3 ─ 주성분 회귀 (PCR) 로 다중공선성 해결
# ──────────────────────────────────────────────────────────────────────────────
def example_03_pcr_multicollinearity() -> None:
    """
    설명변수들이 서로 매우 강하게 상관되어 있을 때, 일반 OLS 회귀계수는
    분산이 매우 커진다 (불안정해진다). 주성분을 회귀변수로 쓰면 이 문제가
    해결됨을 보인다.
    """
    print("\n=== 예제 3. 주성분 회귀 (PCR) ===")

    from sklearn.decomposition import PCA
    from sklearn.linear_model import LinearRegression
    from sklearn.model_selection import KFold, cross_val_score
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import StandardScaler

    # 강한 다중공선성을 갖는 자료 생성
    # x1, x2, x3 이 거의 같은 정보를 담는다
    n = 200
    x1 = RNG.normal(0, 1, n)
    x2 = x1 + RNG.normal(0, 0.05, n)   # x1 과 매우 비슷
    x3 = x1 + RNG.normal(0, 0.05, n)   # x1 과 매우 비슷
    x4 = RNG.normal(0, 1, n)            # 독립적인 변수
    y = 2 * x1 + 1.5 * x4 + RNG.normal(0, 0.3, n)
    X = np.column_stack([x1, x2, x3, x4])

    # (a) OLS
    ols = LinearRegression().fit(X, y)
    print("OLS 계수 :", np.round(ols.coef_, 3),
          "  (참값은 x1 + x2 + x3 의 합이 2, x4 는 1.5)")

    # (b) PCR : PCA 후 회귀
    pcr = make_pipeline(StandardScaler(), PCA(n_components=2), LinearRegression())
    pcr.fit(X, y)

    # 교차검증으로 두 모형의 안정성 비교
    kf = KFold(n_splits=5, shuffle=True, random_state=42)
    ols_r2 = cross_val_score(LinearRegression(), X, y, cv=kf, scoring="r2")
    pcr_r2 = cross_val_score(pcr, X, y, cv=kf, scoring="r2")
    print(f"OLS  교차검증 R²  : {ols_r2.mean():.4f}  ± {ols_r2.std():.4f}")
    print(f"PCR  교차검증 R²  : {pcr_r2.mean():.4f}  ± {pcr_r2.std():.4f}")

    # OLS 계수가 (양수, 양수, 양수) 식으로 합쳐서 2 가 되어야 하지만 실제로는
    # 매우 큰 값과 음수가 섞여 나오기도 한다. PCR 은 직교한 주성분만 쓰므로
    # 이런 불안정성에서 자유롭다.


# ──────────────────────────────────────────────────────────────────────────────
#  예제 4 ─ Deming 회귀 (두 측정기기 비교)
# ──────────────────────────────────────────────────────────────────────────────
def example_04_deming_method_comparison() -> None:
    """
    같은 시료를 두 측정기기로 측정한 자료가 있다고 하자. 두 측정기기 모두
    오차를 가지므로 OLS 는 적절하지 않다. Deming 회귀를 적용해 비교한다.

    scipy.odr (Orthogonal Distance Regression) 패키지를 활용한다.
    """
    print("\n=== 예제 4. Deming 회귀 ─ 두 측정기기 비교 ===")

    from scipy import odr

    # 참값
    n = 80
    X_true = RNG.uniform(10, 100, n)
    # 참 모형 : Y = 1.05 * X + 1.2  (기기 B 가 기기 A 에 비해 약간 높게 측정)
    Y_true = 1.05 * X_true + 1.2

    # 두 기기 모두 측정 오차를 가짐
    sigma_x, sigma_y = 3.0, 4.0
    x_meas = X_true + RNG.normal(0, sigma_x, n)
    y_meas = Y_true + RNG.normal(0, sigma_y, n)

    # (a) OLS : X 에 오차가 있음을 무시
    from sklearn.linear_model import LinearRegression
    ols = LinearRegression().fit(x_meas.reshape(-1, 1), y_meas)
    print(f"OLS    : 기울기 = {ols.coef_[0]:.4f}  절편 = {ols.intercept_:.4f}"
          f"   (참값 기울기 = 1.05)")

    # (b) Deming 회귀 : sx, sy 를 둘 다 알려준다
    def linear(B, x):
        return B[0] * x + B[1]

    model = odr.Model(linear)
    data = odr.RealData(x_meas, y_meas, sx=sigma_x, sy=sigma_y)
    out = odr.ODR(data, model, beta0=[1.0, 0.0]).run()
    print(f"Deming : 기울기 = {out.beta[0]:.4f}  절편 = {out.beta[1]:.4f}"
          f"   (λ = (sx/sy)² = {(sigma_x/sigma_y)**2:.3f})")

    # 신뢰구간 (정규근사)
    print(f"   기울기 표준오차 = {out.sd_beta[0]:.4f}")
    print(f"   95% CI         = ({out.beta[0]-1.96*out.sd_beta[0]:.3f},"
          f" {out.beta[0]+1.96*out.sd_beta[0]:.3f})")

    # 시각화
    fig, ax = plt.subplots(figsize=(7, 5))
    ax.scatter(x_meas, y_meas, alpha=0.6, color="#5B6477", s=35,
               edgecolor="white", label="측정값")
    xs = np.linspace(x_meas.min(), x_meas.max(), 100)
    ax.plot(xs, ols.coef_[0] * xs + ols.intercept_,
            color="#6D2E46", linewidth=2, linestyle="--", label="OLS")
    ax.plot(xs, out.beta[0] * xs + out.beta[1],
            color="#1E2761", linewidth=2.5, label="Deming")
    ax.plot(xs, 1.05 * xs + 1.2,
            color="#E0A11B", linewidth=2, linestyle=":", label="참값")
    ax.set_xlabel("기기 A 측정값 (x)")
    ax.set_ylabel("기기 B 측정값 (y)")
    ax.set_title("두 기기 비교 : OLS vs Deming")
    ax.legend()
    ax.grid(alpha=0.3)
    plt.tight_layout()
    plt.savefig("/home/claude/work/fig_deming.png", dpi=120, bbox_inches="tight")
    plt.close()
    print("→ 그림 저장 : fig_deming.png")


# ──────────────────────────────────────────────────────────────────────────────
#  예제 5 ─ λ 값에 따른 회귀선의 변화
# ──────────────────────────────────────────────────────────────────────────────
def example_05_lambda_sensitivity() -> None:
    """
    λ = Var(εx)/Var(εy) 의 값에 따라 회귀선이 어떻게 회전하는지 본다.
    - λ → ∞  : Y 에 오차가 없다고 보는 셈 → 'X on Y' 회귀
    - λ → 0  : X 에 오차가 없다고 보는 셈 → OLS (Y on X)
    - λ = 1  : 직교 회귀 (orthogonal regression)
    """
    print("\n=== 예제 5. λ 값에 따른 회귀선의 변화 ===")

    from scipy import odr

    # 자료
    n = 100
    X_true = RNG.uniform(-3, 3, n)
    Y_true = 0.8 * X_true   # 참 기울기 = 0.8
    sx_true, sy_true = 0.6, 0.6
    x = X_true + RNG.normal(0, sx_true, n)
    y = Y_true + RNG.normal(0, sy_true, n)

    def linear(B, x):
        return B[0] * x + B[1]

    # 다양한 λ 로 적합
    lambdas = [0.01, 0.25, 1.0, 4.0, 100.0]
    results = []
    for lam in lambdas:
        # λ = (sx/sy)² 이므로 sx, sy 를 적절히 정하면 된다.
        # 여기서는 sy=1 로 고정, sx = sqrt(lam)
        sx, sy = np.sqrt(lam), 1.0
        model = odr.Model(linear)
        data = odr.RealData(x, y, sx=sx, sy=sy)
        out = odr.ODR(data, model, beta0=[1.0, 0.0]).run()
        results.append((lam, out.beta[0], out.beta[1]))
        print(f"  λ = {lam:7.2f}  →  기울기 = {out.beta[0]:.4f}")

    # 시각화
    fig, ax = plt.subplots(figsize=(7.5, 5.5))
    ax.scatter(x, y, color="#5B6477", alpha=0.55, s=30,
               edgecolor="white", label="자료")
    xs = np.linspace(x.min() - 0.5, x.max() + 0.5, 100)

    colors = ["#6D2E46", "#B85042", "#E0A11B", "#2E3D7F", "#1E2761"]
    for (lam, b1, b0), color in zip(results, colors):
        label = f"λ = {lam:g}"
        if lam == 1.0:
            label += " (직교 회귀)"
        elif lam <= 0.01:
            label += " (≈ OLS Y on X)"
        elif lam >= 100:
            label += " (≈ OLS X on Y)"
        ax.plot(xs, b1 * xs + b0, color=color, linewidth=2, label=label)

    ax.plot(xs, 0.8 * xs, color="black", linewidth=1.2, linestyle=":",
            label="참값 (기울기 = 0.8)")
    ax.set_xlabel("x  (관측값)")
    ax.set_ylabel("y  (관측값)")
    ax.set_title("λ 값이 변할 때 회귀선의 회전")
    ax.legend(loc="lower right", fontsize=9)
    ax.grid(alpha=0.3)
    plt.tight_layout()
    plt.savefig("/home/claude/work/fig_lambda.png", dpi=120, bbox_inches="tight")
    plt.close()
    print("→ 그림 저장 : fig_lambda.png")


# ──────────────────────────────────────────────────────────────────────────────
#  실행 진입점
# ──────────────────────────────────────────────────────────────────────────────
def main() -> None:
    print("=" * 72)
    print("  PCA 와 Deming 회귀 ─ 학생용 예제 코드")
    print("=" * 72)

    example_01_standardization()
    example_02_iris_pca()
    example_03_pcr_multicollinearity()
    example_04_deming_method_comparison()
    example_05_lambda_sensitivity()

    print("\n" + "=" * 72)
    print("  모든 예제 실행 완료")
    print("=" * 72)


if __name__ == "__main__":
    main()
