# 7회차 학습자 실습 매뉴얼: 데이터분석 트랙

# PyTorch 딥러닝 기본 구현
## scikit-learn baseline → Tensor Dataset → DataLoader → MLP → 학습 루프 → 평가 → baseline 비교

---

## 이 자료의 목적

7회차의 목표는 “딥러닝이라는 이름이 붙은 복잡한 모델”을 무작정 만드는 것이 아니다. 7회차의 목표는 6회차에서 만든 scikit-learn baseline 모델을 기준선으로 삼아, 같은 데이터 문제를 **PyTorch 기반 신경망 모델**로 구현하고 평가하는 것이다.

6회차에서는 다음 산출물을 만들었다.

```text
1. data/processed/sales_clean.csv
2. src/models/features.py
3. src/models/training.py
4. src/models/evaluation.py
5. scripts/train_baseline.py
6. artifacts/models/baseline_logistic_regression.joblib
7. artifacts/metrics/baseline_metrics.json
8. artifacts/metrics/dummy_metrics.json
9. reports/model_baseline_report.md
```

7회차에서는 이 산출물을 바탕으로 다음을 만든다.

```text
1. config/analysis_config.yaml의 deep_learning 설정
2. src/deep_learning/dataset.py
3. src/deep_learning/model.py
4. src/deep_learning/training.py
5. src/deep_learning/evaluation.py
6. scripts/train_deep_learning.py
7. artifacts/models/pytorch_mlp.pt
8. artifacts/models/pytorch_preprocessor.joblib
9. artifacts/metrics/pytorch_metrics.json
10. artifacts/metrics/pytorch_training_history.csv
11. artifacts/charts/pytorch_loss_curve.png
12. artifacts/charts/pytorch_confusion_matrix.png
13. reports/deep_learning_report.md
```

오늘의 핵심 문장은 다음이다.

> 딥러닝 모델은 마법이 아니라, 데이터 전처리·모델 구조·손실 함수·최적화·평가 기준이 결합된 재현 가능한 실험이다.

7회차가 끝나면 학습자는 다음 명령 한 줄로 PyTorch 모델을 학습하고 평가할 수 있어야 한다.

```bash
uv run python scripts/train_deep_learning.py
```

그리고 다음 질문에 답할 수 있어야 한다.

```text
PyTorch 모델이 dummy baseline보다 나은가?
PyTorch 모델이 scikit-learn baseline보다 나은가?
loss curve가 과적합 징후를 보이는가?
precision, recall, f1_score 중 어떤 지표를 우선 해석해야 하는가?
딥러닝을 적용할 만큼 데이터 규모와 문제 구조가 적절한가?
```

> [!IMPORTANT]
> 7회차는 초보자가 실행할 수 있도록 CPU 기반으로 설계한다. 그러나 내부 구조는 실제 머신러닝 프로젝트의 기본 원칙을 따른다. 즉, train/validation/test 분리, Dataset/DataLoader, model class, training loop, early stopping, metric 저장, baseline 비교를 모두 포함한다.

---

## 오늘 끝나면 있어야 하는 것

7회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
ai-data-lab/
├── config/
│   └── analysis_config.yaml
├── data/
│   └── processed/
│       └── sales_clean.csv
├── src/
│   ├── deep_learning/
│   │   ├── __init__.py
│   │   ├── dataset.py
│   │   ├── model.py
│   │   ├── training.py
│   │   └── evaluation.py
│   └── models/
│       └── ...
├── scripts/
│   └── train_deep_learning.py
├── artifacts/
│   ├── models/
│   │   ├── pytorch_mlp.pt
│   │   └── pytorch_preprocessor.joblib
│   ├── metrics/
│   │   ├── pytorch_metrics.json
│   │   └── pytorch_training_history.csv
│   └── charts/
│       ├── pytorch_loss_curve.png
│       └── pytorch_confusion_matrix.png
└── reports/
    └── deep_learning_report.md
```

---

## 오늘 사용할 입력 위치를 구분하자

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `uv run python scripts/train_deep_learning.py` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `Create src/deep_learning/model.py` |
| `[파일 내용]` | Python, YAML, Markdown 파일 안에 들어갈 내용 | `class TabularMLP(nn.Module):` |

아래 명령은 터미널에 입력한다.

```bash
uv run python scripts/train_deep_learning.py
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create a PyTorch training pipeline for tabular binary classification.
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

Mac에서는 Terminal을 연다.

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

앞으로 “터미널”이라고 하면 Windows에서는 PowerShell, Mac에서는 Terminal을 뜻한다.

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

정상이라면 대략 다음과 비슷한 결과가 나온다.

```text
C:\Users\내이름\ai-data-lab
```

또는:

```text
/Users/내이름/ai-data-lab
```

---

## 0.3 6회차 산출물을 확인한다

7회차는 6회차의 baseline 모델 산출물을 기준으로 진행한다.

[터미널]

```bash
uv run python scripts/train_baseline.py
```

정상이라면 다음 파일들이 있어야 한다.

```text
data/processed/sales_clean.csv
artifacts/metrics/baseline_metrics.json
artifacts/metrics/dummy_metrics.json
reports/model_baseline_report.md
```

확인 명령:

[터미널]

```bash
uv run python -c "from pathlib import Path; files=['data/processed/sales_clean.csv','artifacts/metrics/baseline_metrics.json','artifacts/metrics/dummy_metrics.json','reports/model_baseline_report.md']; print('\n'.join(f'{f}: {Path(f).exists()}' for f in files))"
```

모두 `True`이면 정상이다.

> [!IMPORTANT]
> `sales_clean.csv`가 없다면 먼저 5회차 파이프라인을 실행한다.

[터미널]

```bash
uv run python scripts/run_pipeline.py
```

---

# 1. 오늘 배우는 핵심 개념

## 1.1 PyTorch란 무엇인가

PyTorch는 딥러닝 모델을 만들고 학습하기 위한 Python 라이브러리다. pandas가 표 데이터를 다루는 도구라면, PyTorch는 숫자 배열인 tensor를 사용하여 신경망 모델을 학습하는 도구다.

---

## 1.2 핵심 용어

| 용어 | 뜻 |
|---|---|
| Tensor | PyTorch에서 사용하는 숫자 배열. numpy array와 비슷하지만 학습 계산에 적합함 |
| Dataset | 하나의 데이터 샘플과 정답을 꺼내는 객체 |
| DataLoader | Dataset을 batch 단위로 묶어 학습 루프에 공급하는 객체 |
| Batch | 한 번에 모델에 넣는 데이터 묶음 |
| Model | 입력을 받아 예측값을 출력하는 신경망 구조 |
| Forward pass | 입력 데이터를 모델에 통과시켜 예측값을 계산하는 과정 |
| Loss function | 예측과 정답의 차이를 숫자로 계산하는 함수 |
| Optimizer | loss를 줄이기 위해 모델 파라미터를 갱신하는 알고리즘 |
| Epoch | 전체 학습 데이터를 한 번 모두 사용하는 단위 |
| Validation set | 학습 중 모델 상태를 점검하는 데이터 |
| Test set | 최종 성능을 평가하는 데이터 |
| Early stopping | validation 성능이 나빠지면 학습을 일찍 멈추는 방법 |

---

## 1.3 오늘 사용할 문제 유형

오늘 데이터의 target은 `returned`이다.

```text
returned = 0  → 반품하지 않음
returned = 1  → 반품함
```

따라서 오늘 문제는 이진분류(binary classification)다. 모델은 각 주문이 반품될 확률을 예측한다.

---

# 2. PyTorch 설치와 확인

## 2.1 기본 설치

대부분의 학습자는 CPU 환경에서 진행한다. 먼저 다음을 실행한다.

[터미널]

```bash
uv add torch joblib
```

이미 `joblib`이 설치되어 있어도 문제 없다.

설치 확인:

[터미널]

```bash
uv run python -c "import torch; print('torch', torch.__version__); print('cuda available:', torch.cuda.is_available())"
```

정상이라면 다음과 비슷하게 출력된다.

```text
torch 2.x.x
cuda available: False
```

`cuda available: False`는 실패가 아니다. CPU로 학습하겠다는 뜻이다.

> [!NOTE]
> GPU, CUDA, 운영체제별 설치 방식은 환경마다 다르다. 수업에서는 CPU 기준으로 진행한다. GPU를 사용할 학습자는 PyTorch 공식 설치 안내와 uv의 PyTorch 연동 안내를 참고하여 별도 설정한다.

---

## 2.2 설치 오류가 날 때

`uv add torch`가 실패하면 다음을 시도한다.

[터미널]

```bash
uv pip install torch
```

그래도 실패하면 AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구 - English prompt]

```text
I am trying to install PyTorch in a uv-managed Python project.
My operating system is [Windows/Mac/Linux].
I want a CPU-only installation for this class.
Please suggest the safest installation command and explain how to verify it.
Do not suggest CUDA unless I explicitly ask for GPU support.
```

[한국어 번역]

```text
uv로 관리하는 Python 프로젝트에서 PyTorch를 설치하려고 합니다.
운영체제는 [Windows/Mac/Linux]입니다.
수업에서는 CPU 전용 설치를 원합니다.
가장 안전한 설치 명령과 설치 확인 방법을 제안해 주세요.
제가 GPU 지원을 명시적으로 요청하지 않는 한 CUDA 설치는 제안하지 마세요.
```

---

# 3. config에 deep_learning 설정 추가

## 3.1 왜 config에 설정을 넣는가

딥러닝에는 많은 설정값이 있다.

```text
batch_size
learning_rate
epochs
hidden_dims
dropout
validation_ratio
early_stopping_patience
```

이 값을 코드 곳곳에 직접 쓰면 나중에 실험을 비교하기 어렵다. 따라서 `config/analysis_config.yaml`에 모아 둔다.

---

## 3.2 config 파일을 연다

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

파일 아래쪽에 다음을 추가한다.

[파일 내용: `config/analysis_config.yaml`에 추가]

```yaml
deep_learning:
  enabled: true
  model_name: "pytorch_mlp"
  batch_size: 64
  learning_rate: 0.001
  epochs: 50
  hidden_dims:
    - 64
    - 32
  dropout: 0.2
  validation_ratio: 0.2
  early_stopping_patience: 7
  decision_threshold: 0.5
  device: "auto"
  output_model_path: "artifacts/models/pytorch_mlp.pt"
  output_preprocessor_path: "artifacts/models/pytorch_preprocessor.joblib"
  output_metrics_path: "artifacts/metrics/pytorch_metrics.json"
  output_history_path: "artifacts/metrics/pytorch_training_history.csv"
  output_loss_curve_path: "artifacts/charts/pytorch_loss_curve.png"
  output_confusion_matrix_path: "artifacts/charts/pytorch_confusion_matrix.png"
  output_report_path: "reports/deep_learning_report.md"
```

---

## 3.3 config가 읽히는지 확인한다

[터미널]

```bash
uv run python -c "import yaml; from pathlib import Path; cfg=yaml.safe_load(Path('config/analysis_config.yaml').read_text(encoding='utf-8')); print(cfg['deep_learning']['model_name']); print(cfg['deep_learning']['batch_size'])"
```

정상 출력 예:

```text
pytorch_mlp
64
```

---

# 4. deep_learning 패키지 구조 만들기

## 4.1 폴더와 파일을 만든다

[터미널]

```bash
mkdir -p src/deep_learning
```

Windows PowerShell에서 `mkdir -p`가 안 되면 다음을 사용한다.

[터미널]

```powershell
New-Item -ItemType Directory -Force src\deep_learning
```

파일을 만든다.

### Windows PowerShell

[터미널]

```powershell
New-Item -ItemType File -Force src\deep_learning\__init__.py
New-Item -ItemType File -Force src\deep_learning\dataset.py
New-Item -ItemType File -Force src\deep_learning\model.py
New-Item -ItemType File -Force src\deep_learning\training.py
New-Item -ItemType File -Force src\deep_learning\evaluation.py
New-Item -ItemType File -Force scripts\train_deep_learning.py
```

### Mac Terminal

[터미널]

```bash
touch src/deep_learning/__init__.py
touch src/deep_learning/dataset.py
touch src/deep_learning/model.py
touch src/deep_learning/training.py
touch src/deep_learning/evaluation.py
touch scripts/train_deep_learning.py
```

---

# 5. Dataset과 전처리 구현

## 5.1 Dataset의 역할

PyTorch에서는 pandas DataFrame을 모델에 바로 넣지 않는다. 먼저 다음 과정을 거친다.

```text
pandas DataFrame
→ 결측값 처리
→ 수치형 변수 scaling
→ 범주형 변수 one-hot encoding
→ numpy array
→ torch Tensor
→ Dataset
→ DataLoader
```

---

## 5.2 AI 코딩 도구에 요청하기

[AI 코딩 도구 - English prompt]

```text
Create src/deep_learning/dataset.py for tabular binary classification.

Requirements:
- Use pandas, numpy, torch, scikit-learn.
- Read numeric_features, categorical_features, target, test_ratio, and random_seed from config.
- Split the data into train, validation, and test sets.
- Fit preprocessing only on the training set.
- Fill numeric missing values with training medians.
- Fill categorical missing values with "Unknown".
- Standardize numeric features with StandardScaler.
- One-hot encode categorical features with OneHotEncoder(handle_unknown="ignore").
- Convert features to float32 tensors and target to float32 tensors.
- Create a TabularDataset class.
- Return feature_names and preprocessing objects so they can be saved for later inference.
```

[한국어 번역]

```text
표 형식 이진분류를 위한 src/deep_learning/dataset.py를 만들어 주세요.

요구사항:
- pandas, numpy, torch, scikit-learn을 사용합니다.
- config에서 numeric_features, categorical_features, target, test_ratio, random_seed를 읽습니다.
- 데이터를 train, validation, test로 나눕니다.
- 전처리는 training set에만 fit합니다.
- 수치형 결측값은 training median으로 채웁니다.
- 범주형 결측값은 "Unknown"으로 채웁니다.
- 수치형 변수는 StandardScaler로 표준화합니다.
- 범주형 변수는 OneHotEncoder(handle_unknown="ignore")로 one-hot encoding합니다.
- feature는 float32 tensor, target도 float32 tensor로 변환합니다.
- TabularDataset class를 만듭니다.
- 나중에 추론에 사용할 수 있도록 feature_names와 preprocessing objects를 반환합니다.
```

---

## 5.3 직접 붙여넣을 코드

[파일 내용: `src/deep_learning/dataset.py`]

```python
from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import numpy as np
import pandas as pd
import torch
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from torch.utils.data import Dataset


@dataclass
class TabularDataBundle:
    X_train: torch.Tensor
    y_train: torch.Tensor
    X_val: torch.Tensor
    y_val: torch.Tensor
    X_test: torch.Tensor
    y_test: torch.Tensor
    feature_names: list[str]
    input_dim: int
    preprocessor: dict[str, Any]


class TabularDataset(Dataset):
    def __init__(self, features: torch.Tensor, targets: torch.Tensor) -> None:
        self.features = features
        self.targets = targets

    def __len__(self) -> int:
        return len(self.targets)

    def __getitem__(self, index: int) -> tuple[torch.Tensor, torch.Tensor]:
        return self.features[index], self.targets[index]


def _make_one_hot_encoder() -> OneHotEncoder:
    try:
        return OneHotEncoder(handle_unknown="ignore", sparse_output=False)
    except TypeError:
        return OneHotEncoder(handle_unknown="ignore", sparse=False)


def _safe_stratify(y: pd.Series) -> pd.Series | None:
    if y.nunique(dropna=True) < 2:
        return None
    value_counts = y.value_counts()
    if value_counts.min() < 2:
        return None
    return y


def _transform_features(
    df: pd.DataFrame,
    numeric_features: list[str],
    categorical_features: list[str],
    numeric_medians: pd.Series,
    scaler: StandardScaler,
    encoder: OneHotEncoder,
) -> np.ndarray:
    numeric_part = df[numeric_features].apply(pd.to_numeric, errors="coerce")
    numeric_part = numeric_part.fillna(numeric_medians)
    numeric_array = scaler.transform(numeric_part)

    categorical_part = df[categorical_features].fillna("Unknown").astype(str)
    categorical_array = encoder.transform(categorical_part)

    return np.concatenate([numeric_array, categorical_array], axis=1).astype(np.float32)


def prepare_tabular_data(df: pd.DataFrame, config: dict[str, Any]) -> TabularDataBundle:
    data_cfg = config["data"]
    modeling_cfg = config["modeling"]
    dl_cfg = config["deep_learning"]

    target = data_cfg["target"]
    numeric_features = [col for col in data_cfg["numeric_features"] if col in df.columns]
    categorical_features = [col for col in data_cfg["categorical_features"] if col in df.columns]

    required_columns = numeric_features + categorical_features + [target]
    missing_columns = [col for col in required_columns if col not in df.columns]
    if missing_columns:
        raise ValueError(f"Missing columns for deep learning: {missing_columns}")

    working_df = df[required_columns].copy()
    working_df = working_df.dropna(subset=[target])
    working_df[target] = working_df[target].astype(int)

    test_ratio = float(modeling_cfg.get("test_ratio", 0.2))
    validation_ratio = float(dl_cfg.get("validation_ratio", 0.2))
    seed = int(modeling_cfg.get("random_seed", 42))

    train_val_df, test_df = train_test_split(
        working_df,
        test_size=test_ratio,
        random_state=seed,
        stratify=_safe_stratify(working_df[target]),
    )

    train_df, val_df = train_test_split(
        train_val_df,
        test_size=validation_ratio,
        random_state=seed,
        stratify=_safe_stratify(train_val_df[target]),
    )

    numeric_train = train_df[numeric_features].apply(pd.to_numeric, errors="coerce")
    numeric_medians = numeric_train.median()
    numeric_train = numeric_train.fillna(numeric_medians)

    scaler = StandardScaler()
    scaler.fit(numeric_train)

    categorical_train = train_df[categorical_features].fillna("Unknown").astype(str)
    encoder = _make_one_hot_encoder()
    encoder.fit(categorical_train)

    X_train_np = _transform_features(
        train_df,
        numeric_features,
        categorical_features,
        numeric_medians,
        scaler,
        encoder,
    )
    X_val_np = _transform_features(
        val_df,
        numeric_features,
        categorical_features,
        numeric_medians,
        scaler,
        encoder,
    )
    X_test_np = _transform_features(
        test_df,
        numeric_features,
        categorical_features,
        numeric_medians,
        scaler,
        encoder,
    )

    y_train_np = train_df[target].to_numpy(dtype=np.float32).reshape(-1, 1)
    y_val_np = val_df[target].to_numpy(dtype=np.float32).reshape(-1, 1)
    y_test_np = test_df[target].to_numpy(dtype=np.float32).reshape(-1, 1)

    encoded_feature_names = encoder.get_feature_names_out(categorical_features).tolist()
    feature_names = numeric_features + encoded_feature_names

    preprocessor = {
        "numeric_features": numeric_features,
        "categorical_features": categorical_features,
        "target": target,
        "numeric_medians": numeric_medians,
        "scaler": scaler,
        "encoder": encoder,
        "feature_names": feature_names,
    }

    return TabularDataBundle(
        X_train=torch.tensor(X_train_np, dtype=torch.float32),
        y_train=torch.tensor(y_train_np, dtype=torch.float32),
        X_val=torch.tensor(X_val_np, dtype=torch.float32),
        y_val=torch.tensor(y_val_np, dtype=torch.float32),
        X_test=torch.tensor(X_test_np, dtype=torch.float32),
        y_test=torch.tensor(y_test_np, dtype=torch.float32),
        feature_names=feature_names,
        input_dim=len(feature_names),
        preprocessor=preprocessor,
    )
```

---

# 6. MLP 모델 구현

## 6.1 MLP란 무엇인가

MLP는 Multi-Layer Perceptron의 약자다. 표 형식 데이터에서 가장 기본적으로 사용할 수 있는 신경망 구조 중 하나다.

오늘 모델은 다음 구조를 사용한다.

```text
입력층: 전처리된 feature 개수
은닉층 1: 64 units
은닉층 2: 32 units
출력층: 1 logit
```

출력층이 1개인 이유는 이진분류이기 때문이다. 모델은 최종적으로 `returned = 1`일 확률을 예측한다.

---

## 6.2 AI 코딩 도구에 요청하기

[AI 코딩 도구 - English prompt]

```text
Create src/deep_learning/model.py.

Requirements:
- Use torch and torch.nn.
- Implement a TabularMLP class.
- Accept input_dim, hidden_dims, and dropout.
- Use Linear, ReLU, and Dropout layers.
- Return one logit for binary classification.
- Do not apply sigmoid inside the model, because BCEWithLogitsLoss will be used during training.
```

[한국어 번역]

```text
src/deep_learning/model.py를 만들어 주세요.

요구사항:
- torch와 torch.nn을 사용합니다.
- TabularMLP class를 구현합니다.
- input_dim, hidden_dims, dropout을 인자로 받습니다.
- Linear, ReLU, Dropout layer를 사용합니다.
- 이진분류를 위해 하나의 logit을 반환합니다.
- 학습 시 BCEWithLogitsLoss를 사용할 것이므로 model 내부에서는 sigmoid를 적용하지 않습니다.
```

---

## 6.3 직접 붙여넣을 코드

[파일 내용: `src/deep_learning/model.py`]

```python
from __future__ import annotations

import torch
from torch import nn


class TabularMLP(nn.Module):
    def __init__(self, input_dim: int, hidden_dims: list[int], dropout: float = 0.2) -> None:
        super().__init__()

        layers: list[nn.Module] = []
        previous_dim = input_dim

        for hidden_dim in hidden_dims:
            layers.append(nn.Linear(previous_dim, hidden_dim))
            layers.append(nn.ReLU())
            layers.append(nn.Dropout(dropout))
            previous_dim = hidden_dim

        layers.append(nn.Linear(previous_dim, 1))
        self.network = nn.Sequential(*layers)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.network(x)
```

---

# 7. 학습 루프 구현

## 7.1 학습 루프란 무엇인가

PyTorch에서는 학습 과정을 직접 작성한다. 학습 루프는 다음 과정을 반복한다.

```text
1. batch를 가져온다.
2. model이 예측값을 계산한다.
3. loss를 계산한다.
4. gradient를 초기화한다.
5. 역전파를 수행한다.
6. optimizer가 파라미터를 갱신한다.
7. validation loss를 확인한다.
8. 필요하면 early stopping으로 멈춘다.
```

---

## 7.2 AI 코딩 도구에 요청하기

[AI 코딩 도구 - English prompt]

```text
Create src/deep_learning/training.py.

Requirements:
- Use PyTorch.
- Implement set_seed(seed).
- Implement train_one_epoch(model, loader, criterion, optimizer, device).
- Implement evaluate_loss(model, loader, criterion, device).
- Implement fit_model with early stopping.
- Track train_loss and val_loss for each epoch.
- Save the best model state based on validation loss.
- Return the trained model and training history.
```

[한국어 번역]

```text
src/deep_learning/training.py를 만들어 주세요.

요구사항:
- PyTorch를 사용합니다.
- set_seed(seed)를 구현합니다.
- train_one_epoch(model, loader, criterion, optimizer, device)를 구현합니다.
- evaluate_loss(model, loader, criterion, device)를 구현합니다.
- early stopping을 포함한 fit_model을 구현합니다.
- 각 epoch의 train_loss와 val_loss를 기록합니다.
- validation loss 기준으로 가장 좋은 model state를 저장합니다.
- 학습된 모델과 training history를 반환합니다.
```

---

## 7.3 직접 붙여넣을 코드

[파일 내용: `src/deep_learning/training.py`]

```python
from __future__ import annotations

import copy
import random
from dataclasses import dataclass

import numpy as np
import torch
from torch import nn
from torch.utils.data import DataLoader


@dataclass
class TrainingResult:
    model: nn.Module
    history: list[dict[str, float | int]]
    best_epoch: int
    best_val_loss: float


def set_seed(seed: int) -> None:
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed_all(seed)


def train_one_epoch(
    model: nn.Module,
    loader: DataLoader,
    criterion: nn.Module,
    optimizer: torch.optim.Optimizer,
    device: torch.device,
) -> float:
    model.train()
    total_loss = 0.0
    total_samples = 0

    for features, targets in loader:
        features = features.to(device)
        targets = targets.to(device)

        optimizer.zero_grad()
        logits = model(features)
        loss = criterion(logits, targets)
        loss.backward()
        optimizer.step()

        batch_size = len(targets)
        total_loss += loss.item() * batch_size
        total_samples += batch_size

    return total_loss / max(total_samples, 1)


@torch.no_grad()
def evaluate_loss(
    model: nn.Module,
    loader: DataLoader,
    criterion: nn.Module,
    device: torch.device,
) -> float:
    model.eval()
    total_loss = 0.0
    total_samples = 0

    for features, targets in loader:
        features = features.to(device)
        targets = targets.to(device)

        logits = model(features)
        loss = criterion(logits, targets)

        batch_size = len(targets)
        total_loss += loss.item() * batch_size
        total_samples += batch_size

    return total_loss / max(total_samples, 1)


def fit_model(
    model: nn.Module,
    train_loader: DataLoader,
    val_loader: DataLoader,
    learning_rate: float,
    epochs: int,
    patience: int,
    device: torch.device,
) -> TrainingResult:
    model = model.to(device)
    criterion = nn.BCEWithLogitsLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)

    best_state = copy.deepcopy(model.state_dict())
    best_val_loss = float("inf")
    best_epoch = 0
    epochs_without_improvement = 0
    history: list[dict[str, float | int]] = []

    for epoch in range(1, epochs + 1):
        train_loss = train_one_epoch(model, train_loader, criterion, optimizer, device)
        val_loss = evaluate_loss(model, val_loader, criterion, device)

        history.append(
            {
                "epoch": epoch,
                "train_loss": train_loss,
                "val_loss": val_loss,
            }
        )

        print(f"epoch={epoch:03d} train_loss={train_loss:.4f} val_loss={val_loss:.4f}")

        if val_loss < best_val_loss:
            best_val_loss = val_loss
            best_epoch = epoch
            best_state = copy.deepcopy(model.state_dict())
            epochs_without_improvement = 0
        else:
            epochs_without_improvement += 1

        if epochs_without_improvement >= patience:
            print(f"Early stopping at epoch {epoch}. Best epoch: {best_epoch}")
            break

    model.load_state_dict(best_state)

    return TrainingResult(
        model=model,
        history=history,
        best_epoch=best_epoch,
        best_val_loss=best_val_loss,
    )
```

---

# 8. 평가 함수 구현

## 8.1 평가에서 확인할 것

딥러닝 모델도 scikit-learn baseline과 같은 기준으로 평가해야 한다.

```text
accuracy
precision
recall
f1_score
roc_auc
confusion matrix
```

특히 `returned = 1`이 상대적으로 드문 클래스라면 accuracy만 보면 안 된다. 반품 예측에서는 precision, recall, f1_score가 더 중요할 수 있다.

---

## 8.2 AI 코딩 도구에 요청하기

[AI 코딩 도구 - English prompt]

```text
Create src/deep_learning/evaluation.py.

Requirements:
- Implement predict_probabilities(model, loader, device).
- Apply sigmoid to logits during prediction.
- Implement evaluate_binary_classifier(y_true, y_prob, threshold).
- Return accuracy, precision, recall, f1_score, roc_auc when available, and confusion_matrix.
- Implement functions to save a loss curve and confusion matrix chart using matplotlib.
- Do not use seaborn.
```

[한국어 번역]

```text
src/deep_learning/evaluation.py를 만들어 주세요.

요구사항:
- predict_probabilities(model, loader, device)를 구현합니다.
- 예측 시 logits에 sigmoid를 적용합니다.
- evaluate_binary_classifier(y_true, y_prob, threshold)를 구현합니다.
- accuracy, precision, recall, f1_score, 가능한 경우 roc_auc, confusion_matrix를 반환합니다.
- matplotlib을 사용하여 loss curve와 confusion matrix chart를 저장하는 함수를 구현합니다.
- seaborn은 사용하지 않습니다.
```

---

## 8.3 직접 붙여넣을 코드

[파일 내용: `src/deep_learning/evaluation.py`]

```python
from __future__ import annotations

from pathlib import Path
from typing import Any

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import torch
from sklearn.metrics import (
    accuracy_score,
    confusion_matrix,
    f1_score,
    precision_score,
    recall_score,
    roc_auc_score,
)
from torch import nn
from torch.utils.data import DataLoader


@torch.no_grad()
def predict_probabilities(
    model: nn.Module,
    loader: DataLoader,
    device: torch.device,
) -> tuple[np.ndarray, np.ndarray]:
    model.eval()
    probabilities: list[np.ndarray] = []
    targets: list[np.ndarray] = []

    for features, y_batch in loader:
        features = features.to(device)
        logits = model(features)
        probs = torch.sigmoid(logits).cpu().numpy().reshape(-1)

        probabilities.append(probs)
        targets.append(y_batch.cpu().numpy().reshape(-1))

    y_prob = np.concatenate(probabilities)
    y_true = np.concatenate(targets).astype(int)

    return y_true, y_prob


def evaluate_binary_classifier(
    y_true: np.ndarray,
    y_prob: np.ndarray,
    threshold: float = 0.5,
) -> dict[str, Any]:
    y_pred = (y_prob >= threshold).astype(int)

    metrics: dict[str, Any] = {
        "threshold": threshold,
        "accuracy": float(accuracy_score(y_true, y_pred)),
        "precision": float(precision_score(y_true, y_pred, zero_division=0)),
        "recall": float(recall_score(y_true, y_pred, zero_division=0)),
        "f1_score": float(f1_score(y_true, y_pred, zero_division=0)),
        "confusion_matrix": confusion_matrix(y_true, y_pred).tolist(),
    }

    if len(np.unique(y_true)) == 2:
        metrics["roc_auc"] = float(roc_auc_score(y_true, y_prob))
    else:
        metrics["roc_auc"] = None

    return metrics


def save_loss_curve(history: list[dict[str, float | int]], output_path: str | Path) -> None:
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    history_df = pd.DataFrame(history)

    plt.figure(figsize=(8, 5))
    plt.plot(history_df["epoch"], history_df["train_loss"], label="train_loss")
    plt.plot(history_df["epoch"], history_df["val_loss"], label="val_loss")
    plt.xlabel("Epoch")
    plt.ylabel("Loss")
    plt.title("PyTorch Training Loss Curve")
    plt.legend()
    plt.tight_layout()
    plt.savefig(output_path, dpi=150)
    plt.close()


def save_confusion_matrix_chart(
    matrix: list[list[int]],
    output_path: str | Path,
) -> None:
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    cm = np.array(matrix)

    plt.figure(figsize=(5, 4))
    plt.imshow(cm)
    plt.title("PyTorch Confusion Matrix")
    plt.xlabel("Predicted label")
    plt.ylabel("True label")
    plt.xticks([0, 1], ["not returned", "returned"])
    plt.yticks([0, 1], ["not returned", "returned"])

    for row in range(cm.shape[0]):
        for col in range(cm.shape[1]):
            plt.text(col, row, str(cm[row, col]), ha="center", va="center")

    plt.tight_layout()
    plt.savefig(output_path, dpi=150)
    plt.close()
```

---

# 9. train_deep_learning.py 작성

## 9.1 실행 스크립트의 역할

`scripts/train_deep_learning.py`는 전체 딥러닝 학습의 실행 진입점이다. 이 파일은 다음 일을 한다.

```text
1. config 읽기
2. 데이터 읽기
3. Dataset/DataLoader 생성
4. 모델 생성
5. 학습 실행
6. 테스트 데이터 평가
7. 모델 저장
8. 전처리기 저장
9. metrics 저장
10. chart 저장
11. report 저장
```

---

## 9.2 AI 코딩 도구에 요청하기

[AI 코딩 도구 - English prompt]

```text
Create scripts/train_deep_learning.py.

Requirements:
- Load config/analysis_config.yaml.
- Load data/processed/sales_clean.csv.
- Use src/deep_learning/dataset.py to prepare train, validation, and test tensors.
- Use DataLoader for train, validation, and test.
- Use TabularMLP from src/deep_learning/model.py.
- Use fit_model from src/deep_learning/training.py.
- Evaluate on the test set.
- Save model checkpoint to artifacts/models/pytorch_mlp.pt.
- Save preprocessing object to artifacts/models/pytorch_preprocessor.joblib.
- Save metrics to artifacts/metrics/pytorch_metrics.json.
- Save training history to artifacts/metrics/pytorch_training_history.csv.
- Save loss curve and confusion matrix chart.
- Write reports/deep_learning_report.md.
- Compare PyTorch metrics with baseline_metrics.json when available.
- Use CPU by default unless CUDA is available and config device is auto.
```

[한국어 번역]

```text
scripts/train_deep_learning.py를 만들어 주세요.

요구사항:
- config/analysis_config.yaml을 읽습니다.
- data/processed/sales_clean.csv를 읽습니다.
- src/deep_learning/dataset.py를 사용하여 train, validation, test tensor를 준비합니다.
- train, validation, test에 DataLoader를 사용합니다.
- src/deep_learning/model.py의 TabularMLP를 사용합니다.
- src/deep_learning/training.py의 fit_model을 사용합니다.
- test set에서 평가합니다.
- 모델 checkpoint를 artifacts/models/pytorch_mlp.pt에 저장합니다.
- 전처리 객체를 artifacts/models/pytorch_preprocessor.joblib에 저장합니다.
- metrics를 artifacts/metrics/pytorch_metrics.json에 저장합니다.
- training history를 artifacts/metrics/pytorch_training_history.csv에 저장합니다.
- loss curve와 confusion matrix chart를 저장합니다.
- reports/deep_learning_report.md를 작성합니다.
- baseline_metrics.json이 있으면 PyTorch metrics와 비교합니다.
- config device가 auto이면 CUDA가 있을 때만 CUDA를 사용하고, 기본은 CPU로 사용합니다.
```

---

## 9.3 직접 붙여넣을 코드

[파일 내용: `scripts/train_deep_learning.py`]

```python
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import joblib
import pandas as pd
import torch
import yaml
from torch.utils.data import DataLoader

from src.deep_learning.dataset import TabularDataset, prepare_tabular_data
from src.deep_learning.evaluation import (
    evaluate_binary_classifier,
    predict_probabilities,
    save_confusion_matrix_chart,
    save_loss_curve,
)
from src.deep_learning.model import TabularMLP
from src.deep_learning.training import fit_model, set_seed

CONFIG_PATH = Path("config/analysis_config.yaml")


def load_config(path: Path = CONFIG_PATH) -> dict[str, Any]:
    if not path.exists():
        raise FileNotFoundError(f"Config file not found: {path}")
    return yaml.safe_load(path.read_text(encoding="utf-8"))


def choose_device(config: dict[str, Any]) -> torch.device:
    requested_device = str(config["deep_learning"].get("device", "auto"))

    if requested_device == "auto":
        return torch.device("cuda" if torch.cuda.is_available() else "cpu")

    if requested_device == "cuda" and not torch.cuda.is_available():
        print("CUDA was requested, but CUDA is not available. Falling back to CPU.")
        return torch.device("cpu")

    return torch.device(requested_device)


def read_baseline_metrics(path: Path) -> dict[str, Any] | None:
    if not path.exists():
        return None
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(data: dict[str, Any], output_path: str | Path) -> None:
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


def write_report(
    output_path: str | Path,
    metrics: dict[str, Any],
    baseline_metrics: dict[str, Any] | None,
    best_epoch: int,
    best_val_loss: float,
    device: torch.device,
) -> None:
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    baseline_section = "baseline_metrics.json을 찾지 못했습니다. 6회차 baseline 학습 결과를 먼저 확인하세요."

    if baseline_metrics is not None:
        baseline_f1 = baseline_metrics.get("f1_score")
        pytorch_f1 = metrics.get("f1_score")
        if baseline_f1 is not None and pytorch_f1 is not None:
            diff = float(pytorch_f1) - float(baseline_f1)
            baseline_section = (
                f"- scikit-learn baseline f1_score: {baseline_f1}\n"
                f"- PyTorch MLP f1_score: {pytorch_f1}\n"
                f"- difference: {diff:.4f}\n"
            )
        else:
            baseline_section = "baseline metrics에 f1_score가 없어 직접 비교하지 못했습니다."

    report = f"""# Deep Learning Report

## 1. 실험 개요

이 보고서는 PyTorch MLP 모델을 사용하여 `returned` 이진분류 문제를 학습한 결과를 정리한다.

## 2. 학습 설정

- device: {device}
- best_epoch: {best_epoch}
- best_val_loss: {best_val_loss:.6f}

## 3. Test Metrics

- accuracy: {metrics.get('accuracy')}
- precision: {metrics.get('precision')}
- recall: {metrics.get('recall')}
- f1_score: {metrics.get('f1_score')}
- roc_auc: {metrics.get('roc_auc')}
- threshold: {metrics.get('threshold')}

## 4. Baseline Comparison

{baseline_section}

## 5. 해석 주의사항

- PyTorch 모델이 항상 scikit-learn baseline보다 좋은 것은 아니다.
- 데이터 크기가 작거나 tabular 구조가 단순하면 선형 모델 또는 tree 기반 모델이 더 강할 수 있다.
- accuracy만으로 모델을 평가하지 않는다.
- 반품 예측 문제에서는 precision, recall, f1_score를 함께 확인한다.
- validation loss가 올라가는데 train loss만 내려가면 과적합 가능성이 있다.

## 6. 생성된 산출물

- artifacts/models/pytorch_mlp.pt
- artifacts/models/pytorch_preprocessor.joblib
- artifacts/metrics/pytorch_metrics.json
- artifacts/metrics/pytorch_training_history.csv
- artifacts/charts/pytorch_loss_curve.png
- artifacts/charts/pytorch_confusion_matrix.png
"""

    output_path.write_text(report, encoding="utf-8")


def main() -> None:
    config = load_config()
    dl_cfg = config["deep_learning"]
    paths_cfg = config["paths"]

    set_seed(int(config["modeling"].get("random_seed", 42)))

    processed_path = Path(paths_cfg.get("processed_data", "data/processed/sales_clean.csv"))
    if not processed_path.exists():
        processed_path = Path("data/processed/sales_clean.csv")

    if not processed_path.exists():
        raise FileNotFoundError(
            "Processed data was not found. Run `uv run python scripts/run_pipeline.py` first."
        )

    df = pd.read_csv(processed_path)
    bundle = prepare_tabular_data(df, config)

    batch_size = int(dl_cfg.get("batch_size", 64))

    train_loader = DataLoader(
        TabularDataset(bundle.X_train, bundle.y_train),
        batch_size=batch_size,
        shuffle=True,
    )
    val_loader = DataLoader(
        TabularDataset(bundle.X_val, bundle.y_val),
        batch_size=batch_size,
        shuffle=False,
    )
    test_loader = DataLoader(
        TabularDataset(bundle.X_test, bundle.y_test),
        batch_size=batch_size,
        shuffle=False,
    )

    device = choose_device(config)
    print(f"Using device: {device}")
    print(f"Input dimension: {bundle.input_dim}")

    model = TabularMLP(
        input_dim=bundle.input_dim,
        hidden_dims=[int(x) for x in dl_cfg.get("hidden_dims", [64, 32])],
        dropout=float(dl_cfg.get("dropout", 0.2)),
    )

    result = fit_model(
        model=model,
        train_loader=train_loader,
        val_loader=val_loader,
        learning_rate=float(dl_cfg.get("learning_rate", 0.001)),
        epochs=int(dl_cfg.get("epochs", 50)),
        patience=int(dl_cfg.get("early_stopping_patience", 7)),
        device=device,
    )

    y_true, y_prob = predict_probabilities(result.model, test_loader, device)
    metrics = evaluate_binary_classifier(
        y_true=y_true,
        y_prob=y_prob,
        threshold=float(dl_cfg.get("decision_threshold", 0.5)),
    )
    metrics["best_epoch"] = result.best_epoch
    metrics["best_val_loss"] = result.best_val_loss
    metrics["input_dim"] = bundle.input_dim
    metrics["n_test_samples"] = int(len(y_true))

    model_path = Path(dl_cfg["output_model_path"])
    model_path.parent.mkdir(parents=True, exist_ok=True)
    torch.save(
        {
            "model_state_dict": result.model.state_dict(),
            "input_dim": bundle.input_dim,
            "hidden_dims": [int(x) for x in dl_cfg.get("hidden_dims", [64, 32])],
            "dropout": float(dl_cfg.get("dropout", 0.2)),
            "feature_names": bundle.feature_names,
            "metrics": metrics,
        },
        model_path,
    )

    preprocessor_path = Path(dl_cfg["output_preprocessor_path"])
    preprocessor_path.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(bundle.preprocessor, preprocessor_path)

    write_json(metrics, dl_cfg["output_metrics_path"])

    history_df = pd.DataFrame(result.history)
    history_path = Path(dl_cfg["output_history_path"])
    history_path.parent.mkdir(parents=True, exist_ok=True)
    history_df.to_csv(history_path, index=False)

    save_loss_curve(result.history, dl_cfg["output_loss_curve_path"])
    save_confusion_matrix_chart(metrics["confusion_matrix"], dl_cfg["output_confusion_matrix_path"])

    baseline_metrics = read_baseline_metrics(Path("artifacts/metrics/baseline_metrics.json"))
    write_report(
        output_path=dl_cfg["output_report_path"],
        metrics=metrics,
        baseline_metrics=baseline_metrics,
        best_epoch=result.best_epoch,
        best_val_loss=result.best_val_loss,
        device=device,
    )

    print("Saved model:", model_path)
    print("Saved metrics:", dl_cfg["output_metrics_path"])
    print("Saved report:", dl_cfg["output_report_path"])
    print("Test metrics:")
    print(json.dumps(metrics, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
```

---

# 10. 실행하기

## 10.1 딥러닝 학습 실행

[터미널]

```bash
uv run python scripts/train_deep_learning.py
```

정상이라면 다음과 비슷한 로그가 나온다.

```text
Using device: cpu
Input dimension: 24
epoch=001 train_loss=0.6890 val_loss=0.6721
epoch=002 train_loss=0.6510 val_loss=0.6234
...
Early stopping at epoch 18. Best epoch: 11
Saved model: artifacts/models/pytorch_mlp.pt
Saved metrics: artifacts/metrics/pytorch_metrics.json
Saved report: reports/deep_learning_report.md
```

> [!NOTE]
> epoch 수와 loss 값은 환경과 데이터 상태에 따라 달라질 수 있다. 중요한 것은 파일이 생성되고, metrics가 저장되고, report가 작성되는 것이다.

---

## 10.2 산출물 확인

[터미널]

```bash
uv run python -c "from pathlib import Path; files=['artifacts/models/pytorch_mlp.pt','artifacts/models/pytorch_preprocessor.joblib','artifacts/metrics/pytorch_metrics.json','artifacts/metrics/pytorch_training_history.csv','artifacts/charts/pytorch_loss_curve.png','artifacts/charts/pytorch_confusion_matrix.png','reports/deep_learning_report.md']; print('\n'.join(f'{f}: {Path(f).exists()}' for f in files))"
```

모두 `True`이면 정상이다.

---

## 10.3 metrics 확인

[터미널]

```bash
uv run python -c "import json; from pathlib import Path; m=json.loads(Path('artifacts/metrics/pytorch_metrics.json').read_text(encoding='utf-8')); print(json.dumps(m, ensure_ascii=False, indent=2))"
```

확인할 항목:

```text
accuracy
precision
recall
f1_score
roc_auc
confusion_matrix
best_epoch
best_val_loss
```

---

# 11. baseline과 비교하기

## 11.1 왜 비교가 필요한가

딥러닝 모델을 만들었다고 해서 자동으로 좋은 모델이 되는 것은 아니다. 반드시 6회차 baseline과 비교해야 한다.

비교 기준은 다음이다.

```text
1. dummy baseline보다 좋은가?
2. scikit-learn logistic regression baseline보다 좋은가?
3. 성능 차이가 의미 있게 큰가?
4. 딥러닝 모델의 복잡도가 정당화되는가?
5. 과적합 징후가 있는가?
```

---

## 11.2 비교 명령

[터미널]

```bash
uv run python -c "import json; from pathlib import Path; b=json.loads(Path('artifacts/metrics/baseline_metrics.json').read_text(encoding='utf-8')); p=json.loads(Path('artifacts/metrics/pytorch_metrics.json').read_text(encoding='utf-8')); print('baseline f1:', b.get('f1_score')); print('pytorch f1:', p.get('f1_score')); print('difference:', p.get('f1_score',0)-b.get('f1_score',0))"
```

해석 예시:

```text
PyTorch f1_score가 baseline보다 높으면 개선 가능성이 있다.
PyTorch f1_score가 baseline보다 낮으면 모델 구조, 학습률, feature, 데이터 크기를 재검토해야 한다.
차이가 매우 작으면 더 복잡한 딥러닝 모델을 사용할 실익이 낮을 수 있다.
```

---

# 12. loss curve 해석하기

## 12.1 loss curve 위치

다음 파일을 연다.

```text
artifacts/charts/pytorch_loss_curve.png
```

확인할 패턴은 다음이다.

| 패턴 | 해석 |
|---|---|
| train loss와 val loss가 함께 감소 | 학습이 비교적 안정적 |
| train loss는 감소하지만 val loss는 증가 | 과적합 가능성 |
| train loss와 val loss가 모두 거의 감소하지 않음 | 학습률, 모델 구조, feature 문제 가능성 |
| loss가 갑자기 매우 커짐 | learning_rate가 너무 크거나 데이터 문제가 있을 수 있음 |

---

## 12.2 AI에게 해석을 요청할 때

[AI 코딩 도구 - English prompt]

```text
Review artifacts/metrics/pytorch_training_history.csv and reports/deep_learning_report.md.
Explain whether the PyTorch model appears to be underfitting, overfitting, or learning reasonably.
Compare it with artifacts/metrics/baseline_metrics.json.
Do not claim causality.
Use cautious language and mention limitations.
```

[한국어 번역]

```text
artifacts/metrics/pytorch_training_history.csv와 reports/deep_learning_report.md를 검토해 주세요.
PyTorch 모델이 과소적합, 과적합, 또는 비교적 안정적인 학습 중 어디에 가까운지 설명해 주세요.
artifacts/metrics/baseline_metrics.json과 비교해 주세요.
인과관계를 주장하지 마세요.
신중한 표현을 사용하고 한계를 언급해 주세요.
```

---

# 13. 전문적 확장: 실험 관리 관점

7회차의 기본 구현은 초보자용이지만, 구조는 전문적인 실험 관리로 확장할 수 있어야 한다.

## 13.1 실험 기록에 포함해야 할 항목

```text
데이터 버전
config 설정
random seed
train/validation/test split 비율
모델 구조
학습률
batch size
epoch 수
early stopping 기준
최종 metrics
baseline 대비 차이
```

## 13.2 추가로 만들 수 있는 파일

고급 과제로 다음 파일을 만들 수 있다.

```text
artifacts/metrics/experiment_summary.json
reports/model_comparison.md
config/experiments/pytorch_mlp_small.yaml
config/experiments/pytorch_mlp_large.yaml
```

AI 코딩 도구에 요청하려면 다음을 사용한다.

[AI 코딩 도구 - English prompt]

```text
Create an experiment summary for the PyTorch model.

Include:
- data path
- target variable
- numeric features
- categorical features
- random seed
- train/validation/test split ratios
- model architecture
- learning rate
- batch size
- epochs actually trained
- best validation loss
- test metrics
- baseline comparison

Save it to artifacts/metrics/experiment_summary.json and summarize it in reports/model_comparison.md.
```

[한국어 번역]

```text
PyTorch 모델의 experiment summary를 만들어 주세요.

포함할 항목:
- 데이터 경로
- target 변수
- numeric features
- categorical features
- random seed
- train/validation/test split 비율
- 모델 구조
- learning rate
- batch size
- 실제 학습된 epoch 수
- best validation loss
- test metrics
- baseline 비교

artifacts/metrics/experiment_summary.json에 저장하고 reports/model_comparison.md에 요약해 주세요.
```

---

# 14. 오늘의 품질 게이트

7회차가 끝나기 전에 다음을 모두 확인한다.

## 14.1 환경 게이트

```text
[ ] torch가 설치되어 있다.
[ ] uv run python -c "import torch"가 성공한다.
[ ] config/analysis_config.yaml에 deep_learning 설정이 있다.
```

## 14.2 코드 구조 게이트

```text
[ ] src/deep_learning/dataset.py가 있다.
[ ] src/deep_learning/model.py가 있다.
[ ] src/deep_learning/training.py가 있다.
[ ] src/deep_learning/evaluation.py가 있다.
[ ] scripts/train_deep_learning.py가 있다.
```

## 14.3 실행 게이트

```text
[ ] uv run python scripts/train_deep_learning.py가 실행된다.
[ ] artifacts/models/pytorch_mlp.pt가 생성된다.
[ ] artifacts/models/pytorch_preprocessor.joblib이 생성된다.
[ ] artifacts/metrics/pytorch_metrics.json이 생성된다.
[ ] artifacts/metrics/pytorch_training_history.csv가 생성된다.
[ ] artifacts/charts/pytorch_loss_curve.png가 생성된다.
[ ] artifacts/charts/pytorch_confusion_matrix.png가 생성된다.
[ ] reports/deep_learning_report.md가 생성된다.
```

## 14.4 해석 게이트

```text
[ ] PyTorch 모델의 f1_score를 확인했다.
[ ] scikit-learn baseline의 f1_score와 비교했다.
[ ] loss curve를 확인했다.
[ ] 과적합 가능성을 점검했다.
[ ] 딥러닝 모델이 baseline보다 나은지 신중하게 해석했다.
```

AI 코딩 도구에 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구 - English prompt]

```text
Review the project against the Session 7 deep learning quality gates.

Check:
1. torch is installed,
2. deep_learning config exists,
3. src/deep_learning files exist,
4. scripts/train_deep_learning.py exists,
5. the training script runs,
6. model, preprocessor, metrics, history, charts, and report are generated,
7. PyTorch metrics are compared against the scikit-learn baseline,
8. the report discusses overfitting or underfitting cautiously.

Return PASS, CONCERNS, or FAIL.
For each concern, provide the exact fix.
```

[한국어 번역]

```text
이 프로젝트를 7회차 딥러닝 품질 게이트 기준으로 검토해 주세요.

확인 항목:
1. torch가 설치되어 있는가,
2. deep_learning config가 있는가,
3. src/deep_learning 파일들이 있는가,
4. scripts/train_deep_learning.py가 있는가,
5. 학습 스크립트가 실행되는가,
6. 모델, 전처리기, metrics, history, charts, report가 생성되는가,
7. PyTorch metrics가 scikit-learn baseline과 비교되는가,
8. 보고서가 과적합 또는 과소적합을 신중하게 논의하는가.

PASS, CONCERNS, FAIL 중 하나로 판정해 주세요.
각 우려 사항에 대해 정확한 수정 방법을 제시해 주세요.
```

---

# 15. GitHub에 커밋하기

## 15.1 변경 사항 확인

[터미널]

```bash
git status
```

모델 파일은 크기가 클 수 있다. 이번 수업에서는 작은 `.pt` 파일이므로 커밋할 수 있지만, 실제 프로젝트에서는 큰 모델 파일을 Git에 올리지 않는 것이 일반적이다. 큰 모델은 별도 artifact storage를 사용한다.

---

## 15.2 커밋

[터미널]

```bash
git add .
git commit -m "Add PyTorch deep learning baseline"
```

---

# 16. 과제 안내

## 과제 1. deep_learning_report.md 보완

`reports/deep_learning_report.md`에 다음 섹션을 추가한다.

```md
## 7. Baseline 대비 해석

- dummy baseline보다 나은가:
- scikit-learn baseline보다 나은가:
- 차이가 의미 있게 보이는가:
- 딥러닝 모델을 사용할 실익이 있는가:

## 8. Loss Curve 해석

- train loss 변화:
- validation loss 변화:
- 과적합 가능성:
- 과소적합 가능성:

## 9. 다음 실험 제안

1.
2.
3.
```

---

## 과제 2. hyperparameter 하나만 바꾸기

한 번에 많은 설정을 바꾸면 무엇 때문에 성능이 달라졌는지 알 수 없다. 따라서 하나만 바꾼다.

선택지:

```text
learning_rate: 0.001 → 0.0005
batch_size: 64 → 128
hidden_dims: [64, 32] → [128, 64]
dropout: 0.2 → 0.3
```

실행 후 다음을 기록한다.

```text
변경한 설정:
변경 전 f1_score:
변경 후 f1_score:
변경 전 best_val_loss:
변경 후 best_val_loss:
해석:
```

---

# 17. 자주 생기는 문제와 해결법

## 17.1 torch 설치가 실패한다

해결 순서:

```text
1. Python 버전을 확인한다.
2. uv add torch를 다시 실행한다.
3. 실패하면 uv pip install torch를 실행한다.
4. 그래도 실패하면 운영체제와 오류 메시지를 AI 코딩 도구에 전달한다.
```

확인 명령:

[터미널]

```bash
uv run python --version
uv run python -c "import torch; print(torch.__version__)"
```

---

## 17.2 data/processed/sales_clean.csv가 없다고 나온다

해결:

[터미널]

```bash
uv run python scripts/run_pipeline.py
```

그 다음 다시 실행한다.

[터미널]

```bash
uv run python scripts/train_deep_learning.py
```

---

## 17.3 config에 deep_learning이 없다고 나온다

오류 예시:

```text
KeyError: 'deep_learning'
```

해결:

```text
config/analysis_config.yaml에 deep_learning 섹션을 추가한다.
YAML 들여쓰기가 올바른지 확인한다.
탭 대신 공백 2칸을 사용한다.
```

---

## 17.4 OneHotEncoder 오류가 난다

scikit-learn 버전에 따라 `sparse_output` 인자 지원 여부가 다를 수 있다. 이 자료의 코드는 두 경우를 모두 처리하도록 작성되어 있다. 그래도 오류가 나면 AI 코딩 도구에 오류 메시지를 그대로 붙여넣는다.

[AI 코딩 도구 - English prompt]

```text
The OneHotEncoder code failed in src/deep_learning/dataset.py.
Here is the error message:
[paste error]
Please revise the code so it works with my installed scikit-learn version.
Do not change the project structure.
```

[한국어 번역]

```text
src/deep_learning/dataset.py의 OneHotEncoder 코드가 실패했습니다.
오류 메시지는 다음과 같습니다.
[오류 붙여넣기]
현재 설치된 scikit-learn 버전에서 작동하도록 코드를 수정해 주세요.
프로젝트 구조는 바꾸지 마세요.
```

---

## 17.5 loss가 nan이 된다

가능한 원인:

```text
입력 데이터에 무한대 값이 있다.
learning_rate가 너무 크다.
target 값이 0/1이 아니다.
전처리 과정에서 이상한 값이 생겼다.
```

해결:

```text
1. learning_rate를 0.001에서 0.0005로 낮춘다.
2. target이 0/1인지 확인한다.
3. processed data에 inf 또는 nan이 있는지 확인한다.
```

확인 명령:

[터미널]

```bash
uv run python -c "import pandas as pd, numpy as np; df=pd.read_csv('data/processed/sales_clean.csv'); print(df.isna().sum()); print(np.isinf(df.select_dtypes(include='number')).sum())"
```

---

## 17.6 PyTorch 모델이 baseline보다 나쁘다

이는 실패가 아니다. 중요한 것은 신중하게 해석하는 것이다.

가능한 이유:

```text
데이터가 작다.
문제가 단순하다.
scikit-learn baseline이 이미 충분히 강하다.
딥러닝 모델 구조가 적절하지 않다.
학습률이나 batch size가 적절하지 않다.
범주형 변수 처리 방식이 충분하지 않다.
```

보고서에는 다음처럼 쓴다.

```text
PyTorch MLP 모델은 scikit-learn baseline보다 낮은 f1_score를 보였다.
이는 딥러닝 모델이 항상 tabular 데이터에서 우수하다는 가정을 지지하지 않는다.
현재 데이터 규모와 feature 구조에서는 단순 baseline 모델이 더 효율적일 수 있다.
추가 실험에서는 learning_rate, hidden_dims, dropout, class imbalance 처리를 검토할 필요가 있다.
```

---

# 18. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> PyTorch 딥러닝 모델은 baseline을 대체하는 것이 아니라, baseline과 비교되어야 하는 하나의 실험이다.

7회차의 흐름은 다음과 같다.

```text
PyTorch 설치
→ config에 deep_learning 설정 추가
→ Dataset/DataLoader 구현
→ MLP 모델 구현
→ 학습 루프 구현
→ 평가 함수 구현
→ train_deep_learning.py 작성
→ 모델 학습
→ metrics 저장
→ loss curve 확인
→ scikit-learn baseline과 비교
```

다음 차시에서는 다음으로 나아간다.

```text
8회차 데이터분석 트랙:
BMAD 리뷰와 최종 프로젝트 발표
```

---

# 부록 A. 오늘 사용하는 핵심 명령 모음

## 터미널 명령

```bash
pwd
uv add torch joblib
uv run python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run python scripts/train_deep_learning.py
uv run python -c "import json; from pathlib import Path; m=json.loads(Path('artifacts/metrics/pytorch_metrics.json').read_text(encoding='utf-8')); print(json.dumps(m, ensure_ascii=False, indent=2))"
git status
git add .
git commit -m "Add PyTorch deep learning baseline"
```

## AI 코딩 도구 핵심 프롬프트

```text
Create a PyTorch deep learning training pipeline for tabular binary classification.
Use Dataset, DataLoader, MLP, BCEWithLogitsLoss, Adam, early stopping, and baseline comparison.
Save model, preprocessor, metrics, history, charts, and report.
Keep the project Python-first and reproducible.
```

[한국어 번역]

```text
표 형식 이진분류를 위한 PyTorch 딥러닝 학습 파이프라인을 만들어 주세요.
Dataset, DataLoader, MLP, BCEWithLogitsLoss, Adam, early stopping, baseline comparison을 사용합니다.
모델, 전처리기, metrics, history, charts, report를 저장합니다.
프로젝트를 Python-first이고 재현 가능하게 유지합니다.
```

---

# 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| Tensor | PyTorch의 숫자 배열 |
| Dataset | 개별 샘플과 정답을 반환하는 객체 |
| DataLoader | Dataset을 batch 단위로 공급하는 객체 |
| MLP | 여러 개의 Linear layer로 구성된 기본 신경망 |
| Logit | sigmoid 적용 전의 모델 출력값 |
| BCEWithLogitsLoss | 이진분류에서 logit을 입력으로 받는 손실 함수 |
| Optimizer | 모델 파라미터를 갱신하는 알고리즘 |
| Adam | 자주 사용되는 최적화 알고리즘 |
| Early stopping | validation 성능 악화를 기준으로 학습을 조기 종료하는 방법 |
| Baseline comparison | 새 모델이 기존 기준선보다 나은지 비교하는 절차 |
| Overfitting | 학습 데이터에는 잘 맞지만 새 데이터에는 약한 상태 |
| Underfitting | 학습 데이터조차 충분히 학습하지 못한 상태 |

