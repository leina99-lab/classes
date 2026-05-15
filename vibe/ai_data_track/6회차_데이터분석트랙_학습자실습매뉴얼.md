# 6회차 학습자 실습 매뉴얼: 데이터분석 트랙

# scikit-learn 머신러닝 baseline
## 정제 데이터 확인 → feature/target 분리 → train/test split → baseline 모델 학습 → 평가 지표 → 모델 저장 → 모델 리포트

---

## 이 자료의 목적

6회차의 목표는 복잡한 인공지능 모델을 만드는 것이 아니다. 6회차의 목표는 5회차에서 만든 재현 가능한 분석 파이프라인의 산출물인 `data/processed/sales_clean.csv`를 사용하여, **가장 기본적인 머신러닝 baseline 모델**을 학습하고 평가하는 것이다.

5회차에서는 다음 산출물을 만들었다.

```text
config/analysis_config.yaml
scripts/run_pipeline.py
data/processed/sales_clean.csv
reports/data_quality.md
reports/analysis_summary.md
artifacts/metrics/*.csv
artifacts/charts/*.png
```

6회차에서는 이 산출물을 바탕으로 다음을 만든다.

```text
1. src/models/features.py
2. src/models/training.py
3. src/models/evaluation.py
4. src/models/persistence.py
5. scripts/train_baseline.py
6. artifacts/models/baseline_logistic_regression.joblib
7. artifacts/metrics/baseline_metrics.json
8. artifacts/metrics/dummy_metrics.json
9. artifacts/metrics/classification_report.csv
10. artifacts/metrics/confusion_matrix.csv
11. artifacts/metrics/feature_importance.csv
12. artifacts/charts/confusion_matrix.png
13. artifacts/charts/feature_importance.png
14. reports/model_baseline_report.md
```

오늘의 핵심 문장은 다음이다.

> baseline 모델은 “최고의 모델”이 아니라, 이후 모든 모델 개선을 비교하기 위한 최소 기준선이다.

6회차가 끝나면 학습자는 다음 명령 한 줄로 baseline 모델을 학습하고 평가할 수 있어야 한다.

```bash
uv run python scripts/train_baseline.py
```

---

## 오늘 끝나면 있어야 하는 것

6회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
ai-data-lab/
├── config/
│   └── analysis_config.yaml
├── data/
│   └── processed/
│       └── sales_clean.csv
├── src/
│   └── models/
│       ├── __init__.py
│       ├── features.py
│       ├── training.py
│       ├── evaluation.py
│       └── persistence.py
├── scripts/
│   └── train_baseline.py
├── artifacts/
│   ├── models/
│   │   └── baseline_logistic_regression.joblib
│   ├── metrics/
│   │   ├── baseline_metrics.json
│   │   ├── dummy_metrics.json
│   │   ├── classification_report.csv
│   │   ├── confusion_matrix.csv
│   │   └── feature_importance.csv
│   └── charts/
│       ├── confusion_matrix.png
│       └── feature_importance.png
└── reports/
    └── model_baseline_report.md
```

> [!NOTE]
> 6회차는 딥러닝 회차가 아니다. PyTorch는 7회차에서 다룬다. 오늘은 scikit-learn으로 안정적인 머신러닝 기준선을 만든다.

---

## 오늘 사용할 입력 위치를 구분하자

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `uv run python scripts/train_baseline.py` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `Create src/models/features.py` |
| `[파일 내용]` | Python, YAML, Markdown 파일 안에 들어갈 내용 | `def build_preprocessor(config):` |

아래 명령은 터미널에 입력한다.

```bash
uv run python scripts/train_baseline.py
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create src/models/features.py
```

---

# 0. 수업 시작 전 준비

## 0.1 터미널을 연다

Windows에서는 PowerShell을 연다.

```text
1. Windows 키를 누른다.
2. PowerShell이라고 입력한다.
3. Windows PowerShell을 클릭한다.
```

PowerShell이 열리면 보통 다음과 비슷하다.

```powershell
PS C:\Users\내이름>
```

Mac에서는 Terminal을 연다.

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

앞으로 “터미널”이라고 하면 Windows에서는 PowerShell, Mac에서는 Terminal을 의미한다.

---

## 0.2 프로젝트 폴더로 이동한다

이 자료에서는 프로젝트 폴더 이름을 `ai-data-lab`이라고 가정한다. 본인의 폴더 이름이 다르면 실제 폴더 이름을 사용한다.

### Windows PowerShell

[터미널]

```powershell
cd $HOME
cd ai-data-lab
```

### Mac Terminal

[터미널]

```bash
cd ~
cd ai-data-lab
```

현재 위치를 확인한다.

[터미널]

```bash
pwd
```

정상이라면 대략 다음과 비슷하게 나온다.

```text
C:\Users\내이름\ai-data-lab
```

또는:

```text
/Users/내이름/ai-data-lab
```

> [!IMPORTANT]
> 오늘 모든 명령은 프로젝트 폴더 안에서 실행한다. `pwd` 결과가 `ai-data-lab`이 아니면 먼저 프로젝트 폴더로 이동한다.

---

## 0.3 5회차 파이프라인 산출물을 확인한다

6회차는 5회차에서 만든 정제 데이터가 있어야 진행할 수 있다.

### Windows PowerShell

[터미널]

```powershell
dir data\processed
dir config\analysis_config.yaml
```

### Mac Terminal

[터미널]

```bash
ls data/processed
ls config/analysis_config.yaml
```

다음 파일이 있어야 한다.

```text
data/processed/sales_clean.csv
config/analysis_config.yaml
```

정제 데이터가 없다면 먼저 5회차 파이프라인을 실행한다.

[터미널]

```bash
uv run python scripts/run_pipeline.py
```

---

## 0.4 정제 데이터 크기를 확인한다

[터미널]

```bash
uv run python -c "import pandas as pd; df=pd.read_csv('data/processed/sales_clean.csv'); print(df.shape); print(df.head())"
```

정상이라면 행과 열의 크기, 그리고 상위 5개 행이 출력된다.

---

# 1. 머신러닝 baseline 이해

## 1.1 머신러닝 모델이 하는 일

오늘 모델의 목표는 다음 질문에 답하는 것이다.

```text
주문 정보가 주어졌을 때, 이 주문이 반품될 가능성을 예측할 수 있는가?
```

이 프로젝트에서 예측 대상은 `returned`이다.

```text
returned = 0  → 반품되지 않음
returned = 1  → 반품됨
```

따라서 오늘의 문제는 **이진 분류(binary classification)** 문제이다.

---

## 1.2 핵심 용어

| 용어 | 뜻 |
|---|---|
| target | 모델이 예측하려는 값. 오늘은 `returned` |
| feature | 예측에 사용하는 입력 변수 |
| train set | 모델을 학습하는 데 사용하는 데이터 |
| test set | 학습 후 모델 성능을 평가하는 데이터 |
| baseline | 이후 모델과 비교하기 위한 기준 모델 |
| metric | 모델 성능을 수치로 나타내는 지표 |
| precision | 반품이라고 예측한 것 중 실제 반품의 비율 |
| recall | 실제 반품 중 모델이 반품이라고 찾아낸 비율 |
| F1-score | precision과 recall의 균형 지표 |
| confusion matrix | 예측과 실제값의 조합을 표로 정리한 것 |
| data leakage | 학습 시점에 알면 안 되는 정보를 feature에 넣는 문제 |

---

## 1.3 왜 baseline부터 만드는가

AI에게 바로 “좋은 모델 만들어줘”라고 하면 다음 문제가 생긴다.

```text
무엇이 좋은 모델인지 기준이 없다.
모델이 실제로 개선되었는지 판단하기 어렵다.
복잡한 모델을 써도 단순 모델보다 나은지 알 수 없다.
```

따라서 먼저 baseline을 만든다.

오늘은 두 모델을 비교한다.

| 모델 | 의미 |
|---|---|
| DummyClassifier | 아무 학습을 거의 하지 않는 비교용 모델 |
| LogisticRegression | scikit-learn의 기본 분류 baseline 모델 |

Logistic Regression이 DummyClassifier보다 의미 있게 나아야 baseline으로 볼 수 있다.

---

# 2. 실습 1 — 패키지와 config 확인

## 2.1 필요한 패키지를 설치한다

5회차에서 이미 설치되어 있을 가능성이 높지만, 오늘 필요한 패키지를 다시 확인한다.

[터미널]

```bash
uv add pandas pyyaml scikit-learn joblib matplotlib pytest ruff
```

정상 설치를 확인한다.

[터미널]

```bash
uv run python -c "import pandas, sklearn, joblib; print('modeling packages ok')"
```

정상이라면 다음이 출력된다.

```text
modeling packages ok
```

---

## 2.2 config의 modeling 설정을 확인한다

`config/analysis_config.yaml`에 다음 항목이 있어야 한다.

```yaml
modeling:
  task_type: classification
  test_ratio: 0.2
  random_seed: 42
  baseline_metric: f1_score
```

파일을 열어서 확인한다.

### Windows PowerShell

[터미널]

```powershell
notepad config\analysis_config.yaml
```

### Mac Terminal

[터미널]

```bash
nano config/analysis_config.yaml
```

config가 읽히는지 확인한다.

[터미널]

```bash
uv run python -c "import yaml; from pathlib import Path; cfg=yaml.safe_load(Path('config/analysis_config.yaml').read_text(encoding='utf-8')); print(cfg['data']['target']); print(cfg['modeling']['test_ratio'])"
```

정상이라면 다음과 비슷하게 출력된다.

```text
returned
0.2
```

---

# 3. 실습 2 — 모델링 파일 구조 만들기

## 3.1 필요한 파일을 만든다

### Windows PowerShell

[터미널]

```powershell
$dirs = @("src/models", "scripts", "artifacts/models", "artifacts/metrics", "artifacts/charts", "reports", "tests")
foreach ($d in $dirs) {
  New-Item -ItemType Directory -Force $d | Out-Null
}

$files = @(
  "src/models/__init__.py",
  "src/models/features.py",
  "src/models/training.py",
  "src/models/evaluation.py",
  "src/models/persistence.py",
  "scripts/train_baseline.py"
)

foreach ($f in $files) {
  New-Item -ItemType File -Force $f | Out-Null
}
```

### Mac Terminal

[터미널]

```bash
mkdir -p src/models scripts artifacts/models artifacts/metrics artifacts/charts reports tests
touch src/models/__init__.py
touch src/models/features.py src/models/training.py src/models/evaluation.py src/models/persistence.py
touch scripts/train_baseline.py
```

---

## 3.2 AI 코딩 도구에게 전체 방향을 알려준다

Claude Code 또는 Gemini CLI를 실행한다.

[터미널]

```bash
claude
```

또는:

[터미널]

```bash
gemini
```

AI 코딩 도구 안에서 다음을 입력한다.

[AI 코딩 도구]

```text
/clear
```

그다음 다음 지시를 입력한다.

[AI 코딩 도구]

```text
We are working on Session 6 of the data analysis track.

Goal:
Train and evaluate a scikit-learn baseline model using data/processed/sales_clean.csv.

Rules:
- Use config/analysis_config.yaml as the source of truth.
- Target variable is returned.
- Use numeric_features and categorical_features from config.
- Use train/test split with test_ratio and random_seed from config.
- Build a baseline LogisticRegression pipeline with preprocessing.
- Also train a DummyClassifier for comparison.
- Save model, metrics, confusion matrix, feature importance, charts, and a markdown report.
- Do not introduce deep learning yet.
- Do not change this into a web application.
```

---

# 4. 실습 3 — feature와 target 분리

## 4.1 feature와 target의 차이

`target`은 모델이 맞히려는 값이다. 오늘은 `returned`이다.

`feature`는 target을 예측하기 위해 사용하는 입력 변수이다. 예를 들어 다음과 같다.

```text
quantity
unit_price
discount_rate
revenue
customer_age
region
channel
product_category
```

---

## 4.2 src/models/features.py 작성

[파일 내용: `src/models/features.py`]

```python
"""Feature preparation utilities for baseline modeling."""

from __future__ import annotations

from typing import Any

import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler


def get_feature_columns(config: dict[str, Any]) -> tuple[list[str], list[str]]:
    """Return numeric and categorical feature columns from config."""
    data_config = config["data"]
    numeric_features = list(data_config.get("numeric_features", []))
    categorical_features = list(data_config.get("categorical_features", []))
    return numeric_features, categorical_features


def split_features_target(
    df: pd.DataFrame,
    config: dict[str, Any],
) -> tuple[pd.DataFrame, pd.Series]:
    """Split a DataFrame into feature matrix X and target vector y."""
    numeric_features, categorical_features = get_feature_columns(config)
    feature_columns = numeric_features + categorical_features
    target_column = config["data"]["target"]

    missing_columns = [col for col in feature_columns + [target_column] if col not in df.columns]
    if missing_columns:
        raise ValueError(f"Missing required columns: {missing_columns}")

    X = df[feature_columns].copy()
    y = df[target_column].astype(int).copy()
    return X, y


def build_preprocessor(config: dict[str, Any]) -> ColumnTransformer:
    """Build preprocessing steps for numeric and categorical columns."""
    numeric_features, categorical_features = get_feature_columns(config)

    numeric_pipeline = Pipeline(
        steps=[
            ("imputer", SimpleImputer(strategy="median")),
            ("scaler", StandardScaler()),
        ]
    )

    categorical_pipeline = Pipeline(
        steps=[
            ("imputer", SimpleImputer(strategy="most_frequent")),
            ("onehot", OneHotEncoder(handle_unknown="ignore")),
        ]
    )

    return ColumnTransformer(
        transformers=[
            ("numeric", numeric_pipeline, numeric_features),
            ("categorical", categorical_pipeline, categorical_features),
        ]
    )
```

---

# 5. 실습 4 — training 코드 작성

## 5.1 train/test split이 필요한 이유

모델을 학습한 데이터로 다시 평가하면 성능이 과장될 수 있다. 그래서 데이터를 두 부분으로 나눈다.

```text
train set: 모델 학습용
 test set: 모델 평가용
```

오늘은 config에 있는 `test_ratio: 0.2`를 사용한다. 즉, 전체 데이터의 20%를 test set으로 남겨 둔다.

---

## 5.2 src/models/training.py 작성

[파일 내용: `src/models/training.py`]

```python
"""Training utilities for scikit-learn baseline models."""

from __future__ import annotations

from typing import Any

import pandas as pd
from sklearn.dummy import DummyClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline

from src.models.features import build_preprocessor


def split_train_test(
    X: pd.DataFrame,
    y: pd.Series,
    config: dict[str, Any],
) -> tuple[pd.DataFrame, pd.DataFrame, pd.Series, pd.Series]:
    """Split features and target into train and test sets."""
    modeling_config = config["modeling"]

    return train_test_split(
        X,
        y,
        test_size=float(modeling_config.get("test_ratio", 0.2)),
        random_state=int(modeling_config.get("random_seed", 42)),
        stratify=y,
    )


def build_logistic_regression_pipeline(config: dict[str, Any]) -> Pipeline:
    """Build a preprocessing + LogisticRegression baseline pipeline."""
    preprocessor = build_preprocessor(config)
    classifier = LogisticRegression(
        max_iter=1000,
        class_weight="balanced",
        random_state=int(config["modeling"].get("random_seed", 42)),
    )

    return Pipeline(
        steps=[
            ("preprocessor", preprocessor),
            ("classifier", classifier),
        ]
    )


def build_dummy_pipeline(config: dict[str, Any]) -> Pipeline:
    """Build a simple dummy model for baseline comparison."""
    preprocessor = build_preprocessor(config)
    classifier = DummyClassifier(strategy="most_frequent")

    return Pipeline(
        steps=[
            ("preprocessor", preprocessor),
            ("classifier", classifier),
        ]
    )


def train_model(model: Pipeline, X_train: pd.DataFrame, y_train: pd.Series) -> Pipeline:
    """Fit a model and return it."""
    model.fit(X_train, y_train)
    return model
```

---

# 6. 실습 5 — evaluation 코드 작성

## 6.1 평가 지표의 의미

오늘은 분류 모델을 평가하므로 다음 지표를 사용한다.

| 지표 | 의미 |
|---|---|
| accuracy | 전체 중 맞힌 비율 |
| precision | 반품이라고 예측한 것 중 실제 반품의 비율 |
| recall | 실제 반품 중 모델이 찾아낸 비율 |
| f1_score | precision과 recall의 균형 |
| roc_auc | 반품 가능성을 얼마나 잘 구분하는지 나타내는 지표 |

반품 예측처럼 관심 클래스가 상대적으로 적을 수 있는 문제에서는 accuracy만 보면 위험하다. 그래서 F1-score, precision, recall을 함께 본다.

---

## 6.2 src/models/evaluation.py 작성

[파일 내용: `src/models/evaluation.py`]

```python
"""Evaluation utilities for baseline classification models."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.metrics import (
    accuracy_score,
    classification_report,
    confusion_matrix,
    f1_score,
    precision_score,
    recall_score,
    roc_auc_score,
)
from sklearn.pipeline import Pipeline


def evaluate_classifier(
    model: Pipeline,
    X_test: pd.DataFrame,
    y_test: pd.Series,
) -> dict[str, float]:
    """Evaluate a binary classifier and return metrics."""
    y_pred = model.predict(X_test)

    metrics = {
        "accuracy": float(accuracy_score(y_test, y_pred)),
        "precision": float(precision_score(y_test, y_pred, zero_division=0)),
        "recall": float(recall_score(y_test, y_pred, zero_division=0)),
        "f1_score": float(f1_score(y_test, y_pred, zero_division=0)),
    }

    if hasattr(model, "predict_proba"):
        y_proba = model.predict_proba(X_test)[:, 1]
        metrics["roc_auc"] = float(roc_auc_score(y_test, y_proba))

    return metrics


def make_classification_report_df(
    model: Pipeline,
    X_test: pd.DataFrame,
    y_test: pd.Series,
) -> pd.DataFrame:
    """Create a classification report as a DataFrame."""
    y_pred = model.predict(X_test)
    report = classification_report(y_test, y_pred, output_dict=True, zero_division=0)
    return pd.DataFrame(report).transpose()


def make_confusion_matrix_df(
    model: Pipeline,
    X_test: pd.DataFrame,
    y_test: pd.Series,
) -> pd.DataFrame:
    """Create a 2x2 confusion matrix DataFrame."""
    y_pred = model.predict(X_test)
    matrix = confusion_matrix(y_test, y_pred, labels=[0, 1])
    return pd.DataFrame(
        matrix,
        index=["actual_0", "actual_1"],
        columns=["predicted_0", "predicted_1"],
    )


def extract_feature_importance(model: Pipeline, top_n: int = 20) -> pd.DataFrame:
    """Extract coefficient-based feature importance from LogisticRegression."""
    preprocessor = model.named_steps["preprocessor"]
    classifier = model.named_steps["classifier"]

    if not hasattr(classifier, "coef_"):
        return pd.DataFrame(columns=["feature", "coefficient", "abs_coefficient"])

    feature_names = preprocessor.get_feature_names_out()
    coefficients = classifier.coef_[0]

    importance = pd.DataFrame(
        {
            "feature": feature_names,
            "coefficient": coefficients,
        }
    )
    importance["abs_coefficient"] = importance["coefficient"].abs()
    importance = importance.sort_values("abs_coefficient", ascending=False).head(top_n)
    return importance


def save_metrics(metrics: dict[str, float], output_path: str | Path) -> None:
    """Save metrics as JSON."""
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(metrics, indent=2, ensure_ascii=False), encoding="utf-8")


def save_confusion_matrix_plot(matrix_df: pd.DataFrame, output_path: str | Path) -> None:
    """Save a confusion matrix chart."""
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    values = matrix_df.to_numpy()
    fig, ax = plt.subplots(figsize=(5, 4))
    image = ax.imshow(values)
    fig.colorbar(image, ax=ax)

    ax.set_xticks(np.arange(2), labels=["Pred 0", "Pred 1"])
    ax.set_yticks(np.arange(2), labels=["Actual 0", "Actual 1"])
    ax.set_title("Confusion Matrix")

    for i in range(2):
        for j in range(2):
            ax.text(j, i, int(values[i, j]), ha="center", va="center")

    fig.tight_layout()
    fig.savefig(output_path, dpi=150)
    plt.close(fig)


def save_feature_importance_plot(importance_df: pd.DataFrame, output_path: str | Path) -> None:
    """Save a feature importance chart."""
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    if importance_df.empty:
        return

    plot_df = importance_df.sort_values("abs_coefficient", ascending=True)

    fig, ax = plt.subplots(figsize=(8, 6))
    ax.barh(plot_df["feature"], plot_df["coefficient"])
    ax.set_title("Top Logistic Regression Coefficients")
    ax.set_xlabel("Coefficient")
    fig.tight_layout()
    fig.savefig(output_path, dpi=150)
    plt.close(fig)


def write_model_report(
    output_path: str | Path,
    baseline_metrics: dict[str, float],
    dummy_metrics: dict[str, float],
    model_path: str | Path,
) -> None:
    """Write a markdown model report."""
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    baseline_f1 = baseline_metrics.get("f1_score", 0.0)
    dummy_f1 = dummy_metrics.get("f1_score", 0.0)
    comparison = "높다" if baseline_f1 >= dummy_f1 else "낮다"

    lines = [
        "# Model Baseline Report",
        "",
        "## 1. 모델 목적",
        "",
        "이 모델은 주문 정보로부터 반품 여부(`returned`)를 예측하는 scikit-learn baseline 모델이다.",
        "",
        "## 2. 비교 모델",
        "",
        "- DummyClassifier: 단순 비교 기준",
        "- LogisticRegression: 전처리 pipeline을 포함한 baseline 모델",
        "",
        "## 3. 주요 평가 지표",
        "",
        "| metric | logistic regression | dummy classifier |",
        "|---|---:|---:|",
    ]

    for key in ["accuracy", "precision", "recall", "f1_score", "roc_auc"]:
        baseline_value = baseline_metrics.get(key)
        dummy_value = dummy_metrics.get(key)
        if baseline_value is not None and dummy_value is not None:
            lines.append(f"| {key} | {baseline_value:.4f} | {dummy_value:.4f} |")

    lines.extend(
        [
            "",
            "## 4. baseline 판단",
            "",
            f"LogisticRegression의 F1-score는 DummyClassifier보다 {comparison}.",
            "이 결과는 이후 모델 개선의 기준선으로 사용한다.",
            "",
            "## 5. 저장된 산출물",
            "",
            f"- 모델 파일: `{model_path}`",
            "- 성능 지표: `artifacts/metrics/baseline_metrics.json`",
            "- 분류 리포트: `artifacts/metrics/classification_report.csv`",
            "- 혼동행렬: `artifacts/metrics/confusion_matrix.csv`",
            "- feature importance: `artifacts/metrics/feature_importance.csv`",
            "",
            "## 6. 해석 시 주의사항",
            "",
            "- 이 모델은 인과관계를 증명하지 않는다.",
            "- feature importance는 예측에 대한 기여 신호이지 원인 설명이 아니다.",
            "- 실제 업무 적용 전에는 데이터 품질, 표본 편향, 비용 구조를 추가로 검토해야 한다.",
        ]
    )

    output_path.write_text("\n".join(lines), encoding="utf-8")
```

> [!IMPORTANT]
> 위 코드에서 `feature importance`는 Logistic Regression의 계수를 바탕으로 계산한다. 이것은 “어떤 변수가 예측에 영향을 주는 신호로 사용되었는가”를 보는 것이지, 원인을 증명하는 것이 아니다.

---

# 7. 실습 6 — 모델 저장 코드 작성

## 7.1 왜 모델을 저장하는가

모델을 학습만 하고 저장하지 않으면 다음 문제가 생긴다.

```text
다음에 같은 모델을 다시 사용할 수 없다.
모델 산출물이 남지 않는다.
보고서와 모델 파일을 연결하기 어렵다.
```

그래서 오늘은 `joblib`으로 모델을 저장한다.

---

## 7.2 src/models/persistence.py 작성

[파일 내용: `src/models/persistence.py`]

```python
"""Model persistence utilities."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import joblib


def save_model(model: Any, output_path: str | Path) -> None:
    """Save a trained model with joblib."""
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(model, output_path)


def load_model(model_path: str | Path) -> Any:
    """Load a trained model with joblib."""
    return joblib.load(model_path)
```

---

# 8. 실습 7 — train_baseline.py 작성

## 8.1 train_baseline.py의 역할

5회차의 `run_pipeline.py`는 데이터를 정제하고 분석 산출물을 생성했다.

6회차의 `train_baseline.py`는 모델 학습과 평가를 담당한다.

```text
load config
→ load processed data
→ split features and target
→ train/test split
→ train DummyClassifier
→ train LogisticRegression
→ evaluate models
→ save model, metrics, charts, report
```

---

## 8.2 scripts/train_baseline.py 작성

[파일 내용: `scripts/train_baseline.py`]

```python
"""Train and evaluate a scikit-learn baseline model."""

from __future__ import annotations

from pathlib import Path
import sys

import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))

from src.data.loading import load_config  # noqa: E402
from src.models.evaluation import (  # noqa: E402
    evaluate_classifier,
    extract_feature_importance,
    make_classification_report_df,
    make_confusion_matrix_df,
    save_confusion_matrix_plot,
    save_feature_importance_plot,
    save_metrics,
    write_model_report,
)
from src.models.features import split_features_target  # noqa: E402
from src.models.persistence import save_model  # noqa: E402
from src.models.training import (  # noqa: E402
    build_dummy_pipeline,
    build_logistic_regression_pipeline,
    split_train_test,
    train_model,
)


def ensure_output_dirs(config: dict) -> None:
    """Create directories for model outputs."""
    paths = config["paths"]
    for key in ["models_dir", "metrics_dir", "charts_dir", "reports_dir"]:
        Path(paths[key]).mkdir(parents=True, exist_ok=True)


def load_processed_data(config: dict) -> pd.DataFrame:
    """Load processed data generated by Session 5 pipeline."""
    processed_path = Path(config["paths"]["processed_data"])

    if not processed_path.exists():
        raise FileNotFoundError(
            f"Processed data not found: {processed_path}. "
            "Run `uv run python scripts/run_pipeline.py` first."
        )

    return pd.read_csv(processed_path)


def check_model_gate(baseline_metrics: dict[str, float], dummy_metrics: dict[str, float]) -> bool:
    """Check whether baseline model is at least as useful as dummy model."""
    baseline_f1 = baseline_metrics.get("f1_score", 0.0)
    dummy_f1 = dummy_metrics.get("f1_score", 0.0)
    return baseline_f1 >= dummy_f1


def main() -> None:
    """Train baseline model and save all outputs."""
    config = load_config()
    ensure_output_dirs(config)

    print("=" * 60)
    print("Session 6: scikit-learn baseline training")
    print("=" * 60)

    print("\n[1/9] processed data 로딩")
    df = load_processed_data(config)
    print(f"processed shape: {df.shape}")

    print("\n[2/9] feature와 target 분리")
    X, y = split_features_target(df, config)
    print(f"X shape: {X.shape}")
    print(f"target distribution:\n{y.value_counts(normalize=True)}")

    print("\n[3/9] train/test split")
    X_train, X_test, y_train, y_test = split_train_test(X, y, config)
    print(f"train shape: {X_train.shape}")
    print(f"test shape: {X_test.shape}")

    print("\n[4/9] DummyClassifier 학습")
    dummy_model = train_model(build_dummy_pipeline(config), X_train, y_train)
    dummy_metrics = evaluate_classifier(dummy_model, X_test, y_test)
    print(dummy_metrics)

    print("\n[5/9] LogisticRegression baseline 학습")
    baseline_model = train_model(build_logistic_regression_pipeline(config), X_train, y_train)
    baseline_metrics = evaluate_classifier(baseline_model, X_test, y_test)
    print(baseline_metrics)

    paths = config["paths"]
    models_dir = Path(paths["models_dir"])
    metrics_dir = Path(paths["metrics_dir"])
    charts_dir = Path(paths["charts_dir"])
    reports_dir = Path(paths["reports_dir"])

    print("\n[6/9] 모델과 metrics 저장")
    model_path = models_dir / "baseline_logistic_regression.joblib"
    save_model(baseline_model, model_path)
    save_metrics(baseline_metrics, metrics_dir / "baseline_metrics.json")
    save_metrics(dummy_metrics, metrics_dir / "dummy_metrics.json")

    print("\n[7/9] classification report와 confusion matrix 저장")
    report_df = make_classification_report_df(baseline_model, X_test, y_test)
    report_df.to_csv(metrics_dir / "classification_report.csv")

    matrix_df = make_confusion_matrix_df(baseline_model, X_test, y_test)
    matrix_df.to_csv(metrics_dir / "confusion_matrix.csv")
    save_confusion_matrix_plot(matrix_df, charts_dir / "confusion_matrix.png")

    print("\n[8/9] feature importance 저장")
    importance_df = extract_feature_importance(baseline_model, top_n=20)
    importance_df.to_csv(metrics_dir / "feature_importance.csv", index=False)
    save_feature_importance_plot(importance_df, charts_dir / "feature_importance.png")

    print("\n[9/9] model report 작성")
    write_model_report(
        reports_dir / "model_baseline_report.md",
        baseline_metrics=baseline_metrics,
        dummy_metrics=dummy_metrics,
        model_path=model_path,
    )

    passed = check_model_gate(baseline_metrics, dummy_metrics)

    print("=" * 60)
    print("baseline training 완료")
    print("PASS" if passed else "CONCERNS")
    print("=" * 60)

    if not passed:
        print("LogisticRegression F1-score가 DummyClassifier보다 낮다.")
        print("데이터, feature, target 분포를 다시 검토한다.")


if __name__ == "__main__":
    main()
```

---

# 9. 실습 8 — baseline 모델 실행

## 9.1 먼저 분석 파이프라인을 실행한다

정제 데이터가 최신인지 확인하기 위해 5회차 파이프라인을 먼저 실행한다.

[터미널]

```bash
uv run python scripts/run_pipeline.py
```

정상이라면 마지막에 `PASS` 또는 수정 가능한 `CONCERNS`가 나온다.

---

## 9.2 모델 학습 스크립트를 실행한다

[터미널]

```bash
uv run python scripts/train_baseline.py
```

정상이라면 다음과 비슷한 단계가 출력된다.

```text
Session 6: scikit-learn baseline training

[1/9] processed data 로딩
[2/9] feature와 target 분리
[3/9] train/test split
[4/9] DummyClassifier 학습
[5/9] LogisticRegression baseline 학습
[6/9] 모델과 metrics 저장
[7/9] classification report와 confusion matrix 저장
[8/9] feature importance 저장
[9/9] model report 작성
baseline training 완료
PASS
```

---

## 9.3 산출물 확인

### Windows PowerShell

[터미널]

```powershell
dir artifacts\models
dir artifacts\metrics
dir artifacts\charts
dir reports
```

### Mac Terminal

[터미널]

```bash
ls artifacts/models
ls artifacts/metrics
ls artifacts/charts
ls reports
```

다음 파일이 보이면 정상이다.

```text
artifacts/models/baseline_logistic_regression.joblib
artifacts/metrics/baseline_metrics.json
artifacts/metrics/dummy_metrics.json
artifacts/metrics/classification_report.csv
artifacts/metrics/confusion_matrix.csv
artifacts/metrics/feature_importance.csv
artifacts/charts/confusion_matrix.png
artifacts/charts/feature_importance.png
reports/model_baseline_report.md
```

---

# 10. 실습 9 — 결과 읽기

## 10.1 baseline_metrics.json 확인

[터미널]

```bash
uv run python -c "import json; from pathlib import Path; print(Path('artifacts/metrics/baseline_metrics.json').read_text(encoding='utf-8'))"
```

다음과 비슷한 값이 나온다.

```json
{
  "accuracy": 0.64,
  "precision": 0.24,
  "recall": 0.61,
  "f1_score": 0.34,
  "roc_auc": 0.68
}
```

숫자는 실행 환경과 데이터 처리 결과에 따라 조금 다를 수 있다.

---

## 10.2 DummyClassifier와 비교한다

[터미널]

```bash
uv run python -c "import json; from pathlib import Path; b=json.loads(Path('artifacts/metrics/baseline_metrics.json').read_text()); d=json.loads(Path('artifacts/metrics/dummy_metrics.json').read_text()); print('baseline f1:', b['f1_score']); print('dummy f1:', d['f1_score'])"
```

확인할 질문은 다음이다.

```text
LogisticRegression의 F1-score가 DummyClassifier보다 높은가?
precision과 recall 중 무엇이 더 낮은가?
accuracy만 보면 모델을 과대평가할 위험이 있는가?
```

---

## 10.3 confusion matrix 읽기

[터미널]

```bash
uv run python -c "import pandas as pd; print(pd.read_csv('artifacts/metrics/confusion_matrix.csv', index_col=0))"
```

혼동행렬은 다음 의미를 가진다.

| 위치 | 의미 |
|---|---|
| actual_0, predicted_0 | 실제 비반품을 비반품으로 맞힘 |
| actual_0, predicted_1 | 실제 비반품을 반품으로 잘못 예측 |
| actual_1, predicted_0 | 실제 반품을 비반품으로 놓침 |
| actual_1, predicted_1 | 실제 반품을 반품으로 맞힘 |

반품 예측에서는 `actual_1, predicted_0`이 중요할 수 있다. 실제 반품을 놓치는 것이 업무상 큰 비용이 될 수 있기 때문이다.

---

## 10.4 feature importance 읽기

[터미널]

```bash
uv run python -c "import pandas as pd; print(pd.read_csv('artifacts/metrics/feature_importance.csv').head(10))"
```

주의할 점은 다음이다.

```text
계수가 크다고 해서 그 변수가 반품의 원인이라는 뜻은 아니다.
모델이 예측에 사용한 신호가 강하다는 뜻이다.
해석은 데이터 품질, 변수 의미, 업무 맥락과 함께 해야 한다.
```

---

# 11. 실습 10 — 간단한 테스트 작성

테스트는 모든 코드를 완벽하게 보장하지 않는다. 그러나 최소한 중요한 함수가 예상한 구조로 작동하는지 확인할 수 있다.

## 11.1 tests/test_model_features.py 작성

[파일 내용: `tests/test_model_features.py`]

```python
import pandas as pd

from src.models.features import split_features_target


def test_split_features_target_returns_x_and_y():
    config = {
        "data": {
            "target": "returned",
            "numeric_features": ["quantity", "unit_price"],
            "categorical_features": ["region"],
        }
    }
    df = pd.DataFrame(
        {
            "quantity": [1, 2],
            "unit_price": [1000, 2000],
            "region": ["Seoul", "Busan"],
            "returned": [0, 1],
        }
    )

    X, y = split_features_target(df, config)

    assert list(X.columns) == ["quantity", "unit_price", "region"]
    assert list(y) == [0, 1]
```

---

## 11.2 tests/test_model_evaluation.py 작성

[파일 내용: `tests/test_model_evaluation.py`]

```python
from src.models.evaluation import save_metrics


def test_save_metrics_writes_json(tmp_path):
    output_path = tmp_path / "metrics.json"
    save_metrics({"f1_score": 0.5}, output_path)

    assert output_path.exists()
    assert "f1_score" in output_path.read_text(encoding="utf-8")
```

---

## 11.3 테스트 실행

[터미널]

```bash
uv run pytest
```

정상이라면 테스트가 통과한다.

---

# 12. 모델링 품질 게이트

6회차가 끝나기 전에 다음을 확인한다.

## 12.1 데이터 게이트

```text
[ ] data/processed/sales_clean.csv가 있다.
[ ] target column returned가 있다.
[ ] numeric_features가 config에 정의되어 있다.
[ ] categorical_features가 config에 정의되어 있다.
[ ] train/test split이 config의 test_ratio와 random_seed를 사용한다.
```

## 12.2 모델 게이트

```text
[ ] DummyClassifier를 학습했다.
[ ] LogisticRegression baseline을 학습했다.
[ ] preprocessing pipeline에 결측값 처리와 categorical encoding이 포함되어 있다.
[ ] baseline 모델 파일이 artifacts/models/에 저장되었다.
[ ] baseline_metrics.json이 저장되었다.
[ ] classification_report.csv가 저장되었다.
[ ] confusion_matrix.csv가 저장되었다.
```

## 12.3 해석 게이트

```text
[ ] LogisticRegression과 DummyClassifier를 비교했다.
[ ] accuracy만으로 성능을 판단하지 않았다.
[ ] precision, recall, f1_score를 함께 확인했다.
[ ] feature importance를 인과관계로 해석하지 않았다.
[ ] reports/model_baseline_report.md가 작성되었다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Check the current project against the Session 6 data analysis quality gates:

1. data/processed/sales_clean.csv exists.
2. config defines target, numeric_features, categorical_features, test_ratio, and random_seed.
3. src/models/features.py, training.py, evaluation.py, persistence.py exist.
4. scripts/train_baseline.py runs.
5. DummyClassifier and LogisticRegression baseline are both trained.
6. Model, metrics, confusion matrix, feature importance, charts, and report are saved.
7. The report does not claim causality from coefficients.

Return PASS, CONCERNS, or FAIL.
For any concern, give the exact file and fix.
```

---

# 13. GitHub에 커밋하기

## 13.1 현재 변경 사항 확인

[터미널]

```bash
git status
```

아직 Git 저장소가 아니라면 다음을 실행한다.

[터미널]

```bash
git init
```

---

## 13.2 파일 추가와 커밋

[터미널]

```bash
git add .
git commit -m "Add session 6 scikit-learn baseline model"
```

커밋이 성공하면 6회차 작업이 저장된 것이다.

---

# 14. 과제 안내

## 과제 1. 모델 결과 해석 메모 작성

`reports/model_interpretation_notes.md` 파일을 만든다.

[파일 내용: `reports/model_interpretation_notes.md`]

```md
# Model Interpretation Notes

## 1. 모델의 예측 목표

- target:
- 문제 유형:

## 2. 주요 성능 지표

- accuracy:
- precision:
- recall:
- f1_score:
- roc_auc:

## 3. DummyClassifier와 비교

- baseline f1_score:
- dummy f1_score:
- baseline이 dummy보다 나은가:

## 4. confusion matrix에서 주의할 점

- 실제 반품을 놓친 경우:
- 실제 비반품을 반품으로 잘못 예측한 경우:

## 5. feature importance 해석

- 상위 feature 3개:
- 이것을 원인으로 말하면 안 되는 이유:

## 6. 다음 모델 개선 아이디어

1.
2.
3.
```

---

## 과제 2. 모델 개선 후보 3개 작성

다음 중에서 3개를 골라 개선 아이디어를 작성한다.

```text
1. feature 추가 또는 제거
2. class imbalance 처리 방식 변경
3. 다른 모델 사용: RandomForest, GradientBoosting 등
4. threshold 조정
5. 평가 지표 변경
6. 데이터 품질 개선
```

예시:

```md
## 개선 아이디어 1

아이디어:
반품률이 높은 카테고리와 채널 조합을 feature로 추가한다.

이유:
현재는 category와 channel을 각각 따로 사용한다. 조합 feature가 더 많은 정보를 줄 수 있다.

주의:
이 조합이 반품의 원인이라고 단정하지 않는다.
```

---

## 과제 3. README.md에 Modeling 섹션 추가

AI 코딩 도구에 다음을 요청한다.

[AI 코딩 도구]

```text
Update README.md by adding a "Modeling" section.

Include:
- target variable: returned
- baseline model: LogisticRegression
- comparison model: DummyClassifier
- main metrics: precision, recall, f1_score, roc_auc
- model output path
- metrics output path
- caution: model coefficients do not prove causality
```

---

# 15. 자주 생기는 문제와 해결법

## 15.1 `data/processed/sales_clean.csv`가 없다고 나온다

원인:

```text
5회차 파이프라인을 실행하지 않았다.
config의 processed_data 경로가 다르다.
```

해결:

[터미널]

```bash
uv run python scripts/run_pipeline.py
```

그다음 다시 실행한다.

[터미널]

```bash
uv run python scripts/train_baseline.py
```

---

## 15.2 `No module named src` 오류

원인:

```text
scripts/train_baseline.py에서 프로젝트 루트를 Python 경로에 추가하지 않았다.
```

해결:

`scripts/train_baseline.py` 상단에 다음 코드가 있는지 확인한다.

```python
from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))
```

---

## 15.3 `Missing required columns` 오류

원인:

```text
config의 feature 이름과 sales_clean.csv의 실제 column 이름이 다르다.
```

해결:

[터미널]

```bash
uv run python -c "import pandas as pd; df=pd.read_csv('data/processed/sales_clean.csv'); print(df.columns.tolist())"
```

출력된 column 이름과 `config/analysis_config.yaml`의 feature 이름을 비교한다.

---

## 15.4 F1-score가 너무 낮다

가능한 원인:

```text
반품 클래스가 적다.
feature가 target을 충분히 설명하지 못한다.
train/test split이 불안정하다.
모델이 너무 단순하다.
```

해결 방향:

```text
1. DummyClassifier와 비교한다.
2. precision과 recall을 함께 본다.
3. feature importance를 확인한다.
4. threshold 조정이나 다른 모델은 다음 개선 단계로 남긴다.
```

오늘의 목표는 완벽한 성능이 아니라 기준선을 만드는 것이다.

---

## 15.5 `roc_auc_score` 오류

가능한 원인:

```text
test set에 한 클래스만 들어갔다.
y_test에 0 또는 1 중 하나만 존재한다.
```

해결:

```text
train_test_split에서 stratify=y를 사용했는지 확인한다.
전체 데이터의 returned 분포를 확인한다.
```

분포 확인 명령:

[터미널]

```bash
uv run python -c "import pandas as pd; df=pd.read_csv('data/processed/sales_clean.csv'); print(df['returned'].value_counts(normalize=True))"
```

---

# 16. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> 머신러닝 baseline은 복잡한 모델 경쟁의 출발점이 아니라, 데이터와 문제 정의가 모델링 가능한 상태인지 검증하는 첫 번째 기준선이다.

6회차의 흐름은 다음과 같다.

```text
정제 데이터 확인
→ target과 feature 분리
→ train/test split
→ DummyClassifier 학습
→ LogisticRegression baseline 학습
→ precision, recall, f1_score 평가
→ confusion matrix 확인
→ feature importance 확인
→ 모델과 리포트 저장
```

7회차에서는 scikit-learn baseline을 기준으로 PyTorch 딥러닝 모델의 기본 구조를 구현한다.

---

# 17. 6회차 최종 체크리스트

수업이 끝나기 전에 스스로 확인한다.

```text
[ ] 5회차 파이프라인을 실행했다.
[ ] data/processed/sales_clean.csv가 있다.
[ ] target이 returned임을 이해했다.
[ ] feature와 target의 차이를 설명할 수 있다.
[ ] train/test split의 목적을 설명할 수 있다.
[ ] DummyClassifier를 학습했다.
[ ] LogisticRegression baseline을 학습했다.
[ ] baseline_metrics.json이 생성되었다.
[ ] confusion_matrix.csv가 생성되었다.
[ ] feature_importance.csv가 생성되었다.
[ ] baseline_logistic_regression.joblib이 생성되었다.
[ ] model_baseline_report.md가 생성되었다.
[ ] feature importance를 인과관계로 해석하지 않는다.
[ ] README.md에 Modeling 섹션을 추가할 수 있다.
```

---

# 부록 A. 오늘 사용하는 핵심 명령 모음

## 터미널 명령

```bash
pwd
uv add pandas pyyaml scikit-learn joblib matplotlib pytest ruff
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run pytest
git status
git add .
git commit -m "Add session 6 scikit-learn baseline model"
```

## AI 코딩 도구 명령

```text
/clear
Check the current project against the Session 6 data analysis quality gates.
```

---

# 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| target | 모델이 예측하려는 값 |
| feature | 모델이 예측에 사용하는 입력 변수 |
| train set | 모델을 학습하는 데이터 |
| test set | 학습 후 성능을 확인하는 데이터 |
| baseline | 이후 모델과 비교하기 위한 기준 모델 |
| DummyClassifier | 단순 비교 기준 모델 |
| LogisticRegression | 선형 분류 모델. 오늘의 baseline |
| precision | 반품이라고 예측한 것 중 실제 반품의 비율 |
| recall | 실제 반품 중 모델이 찾아낸 비율 |
| F1-score | precision과 recall의 균형 지표 |
| confusion matrix | 실제값과 예측값의 조합표 |
| feature importance | 모델이 예측에 중요하게 사용한 feature 신호 |
| data leakage | 학습 시점에 알 수 없는 정보가 feature에 들어가는 문제 |
