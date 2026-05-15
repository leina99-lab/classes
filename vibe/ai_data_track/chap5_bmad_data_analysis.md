# 5회차 학습자 실습 매뉴얼: 데이터분석 트랙

# 재현 가능한 분석 파이프라인
## EDA 코드 정리 → config 표준화 → schema 검증 → cleaning → KPI·chart·report 자동 생성 → 품질 게이트

---

## 이 자료의 목적

5회차의 목표는 새로운 분석 기법을 많이 배우는 것이 아니다. 5회차의 목표는 4회차에서 수행한 EDA와 데이터 품질검사를 **한 줄 명령으로 다시 실행 가능한 분석 파이프라인**으로 전환하는 것이다.

4회차에서는 다음 산출물을 만들었다.

```text
src/data/loading.py
src/data/quality.py
src/analysis/kpis.py
src/visualization/charts.py
scripts/run_eda.py
artifacts/metrics/*.csv
artifacts/charts/*.png
reports/eda_summary.md
reports/eda_questions_selected.md
```

5회차에서는 이 산출물을 다음 구조로 확장한다.

```text
1. config/analysis_config.yaml 표준화
2. src/data/schema.py
3. src/data/cleaning.py
4. src/data/quality.py 보완
5. src/analysis/kpis.py 보완
6. src/visualization/charts.py 보완
7. src/analysis/reporting.py
8. src/quality_gate.py
9. scripts/run_pipeline.py
10. data/processed/sales_clean.csv
11. reports/data_quality.md
12. reports/analysis_summary.md
13. artifacts/metrics/*.csv
14. artifacts/charts/*.png
```

오늘의 핵심 문장은 다음이다.

> 분석 파이프라인은 “내가 한 분석”을 “누구나 다시 실행할 수 있는 절차”로 바꾸는 장치이다.

5회차가 끝나면 학습자는 다음 명령 한 줄로 주요 산출물을 다시 만들 수 있어야 한다.

```bash
uv run python scripts/run_pipeline.py
```

---

## 오늘 끝나면 있어야 하는 것

5회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
ai-data-lab/
├── config/
│   └── analysis_config.yaml
├── data/
│   ├── raw/
│   │   └── sales_sample.csv
│   └── processed/
│       └── sales_clean.csv
├── src/
│   ├── data/
│   │   ├── loading.py
│   │   ├── schema.py
│   │   ├── cleaning.py
│   │   └── quality.py
│   ├── analysis/
│   │   ├── kpis.py
│   │   └── reporting.py
│   ├── visualization/
│   │   └── charts.py
│   └── quality_gate.py
├── scripts/
│   └── run_pipeline.py
├── artifacts/
│   ├── charts/
│   │   ├── revenue_by_region.png
│   │   ├── return_rate_by_channel.png
│   │   ├── revenue_share_by_category.png
│   │   ├── monthly_revenue_trend.png
│   │   └── revenue_distribution.png
│   └── metrics/
│       ├── raw_missing_summary.csv
│       ├── raw_duplicate_summary.csv
│       ├── raw_outlier_summary.csv
│       ├── clean_missing_summary.csv
│       ├── overall_kpis.csv
│       ├── channel_return_rate.csv
│       ├── region_revenue.csv
│       ├── category_revenue_share.csv
│       └── monthly_revenue.csv
└── reports/
    ├── data_quality.md
    └── analysis_summary.md
```

> [!NOTE]
> 5회차는 6회차 머신러닝을 위한 준비 단계이다. 오늘은 모델을 학습하지 않는다. 오늘의 목표는 정제 데이터와 분석 산출물을 안정적으로 재생성하는 것이다.

---

## 오늘 사용할 입력 위치를 구분하자

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `uv run python scripts/run_pipeline.py` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `Create scripts/run_pipeline.py` |
| `[파일 내용]` | Python, YAML, Markdown 파일 안에 들어갈 내용 | `def clean_data(df, config):` |

아래 명령은 터미널에 입력한다.

```bash
uv run python scripts/run_pipeline.py
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create src/data/schema.py
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

## 0.3 4회차 산출물이 있는지 확인한다

### Windows PowerShell

[터미널]

```powershell
dir data\raw
dir config
dir src\data
dir src\analysis
dir src\visualization
dir scripts
```

### Mac Terminal

[터미널]

```bash
ls data/raw
ls config
ls src/data
ls src/analysis
ls src/visualization
ls scripts
```

다음 파일이 있어야 한다.

```text
data/raw/sales_sample.csv
config/analysis_config.yaml
src/data/loading.py
src/data/quality.py
src/analysis/kpis.py
src/visualization/charts.py
scripts/run_eda.py
```

파일이 없다면 먼저 4회차 산출물을 보완한다.

[AI 코딩 도구]

```text
Check whether the Session 4 data analysis outputs exist:

- data/raw/sales_sample.csv
- config/analysis_config.yaml
- src/data/loading.py
- src/data/quality.py
- src/analysis/kpis.py
- src/visualization/charts.py
- scripts/run_eda.py

If any file is missing, tell me the exact file to recreate and the shortest safe prompt to recreate it.
Do not start Session 5 pipeline implementation until the missing file is identified.
```

---

## 0.4 필요한 패키지를 확인한다

[터미널]

```bash
uv run python -c "import pandas, yaml, matplotlib; print('packages ok')"
```

정상이라면 다음과 같이 출력된다.

```text
packages ok
```

오류가 나오면 필요한 패키지를 설치한다.

[터미널]

```bash
uv add pandas pyyaml matplotlib pytest ruff
```

---

# 1. 오늘의 개념 이해

## 1.1 EDA 스크립트와 파이프라인의 차이

4회차의 `scripts/run_eda.py`는 EDA 결과를 생성하는 데 초점을 둔다. 5회차의 `scripts/run_pipeline.py`는 분석 절차 전체를 더 명확한 순서로 고정한다.

| 구분 | 4회차 EDA 스크립트 | 5회차 파이프라인 |
|---|---|---|
| 목적 | 데이터를 탐색하고 요약한다 | 분석 절차 전체를 재현 가능하게 만든다 |
| 중심 질문 | 데이터에서 무엇이 보이는가 | 같은 결과를 다시 만들 수 있는가 |
| 산출물 | EDA 표, 그래프, 요약 | 정제 데이터, 품질 보고서, 분석 보고서, 품질 게이트 |
| 다음 차시 연결 | EDA 이해 | 머신러닝 baseline 준비 |

---

## 1.2 파이프라인의 표준 순서

오늘 만들 파이프라인은 다음 순서로 실행된다.

```text
1. config 읽기
2. raw data 읽기
3. schema 검증
4. raw data 품질검사
5. cleaning 수행
6. processed data 저장
7. cleaned data 품질검사
8. KPI 계산
9. chart 생성
10. data_quality.md 생성
11. analysis_summary.md 생성
12. quality gate 실행
```

이 순서가 중요한 이유는 다음과 같다.

```text
schema 검증 없이 cleaning하면 잘못된 컬럼명 오류를 늦게 발견한다.
품질검사 없이 모델을 학습하면 결측값과 중복이 결과를 왜곡할 수 있다.
정제 데이터 없이 6회차 머신러닝을 시작하면 실험이 반복될 때 결과가 달라질 수 있다.
quality gate 없이 끝내면 산출물이 실제로 생성되었는지 모른다.
```

---

# 2. 실습 1 — AI에게 파이프라인 구현 계획을 확인시키기

## 2.1 AI 코딩 도구 실행

Gemini CLI를 사용하는 경우:

[터미널]

```bash
gemini
```

Claude Code를 사용하는 경우:

[터미널]

```bash
claude
```

AI 코딩 도구가 열리면 다음을 입력한다.

[AI 코딩 도구]

```text
bmad-help
```

---

## 2.2 Session 5 구현 범위 고정

[AI 코딩 도구]

```text
We are starting Session 5 of the data analysis track.

Goal:
Convert the EDA work from Session 4 into a reproducible analysis pipeline.

Use these files as the source of truth:
- _bmad-output/project-context.md
- _bmad-output/PRD.md
- _bmad-output/architecture.md
- config/analysis_config.yaml
- data/raw/sales_sample.csv
- src/data/loading.py
- src/data/quality.py
- src/analysis/kpis.py
- src/visualization/charts.py

Implementation scope for today:
- Standardize config/analysis_config.yaml.
- Create src/data/schema.py.
- Create src/data/cleaning.py.
- Update src/data/quality.py if needed.
- Update src/analysis/kpis.py if needed.
- Update src/visualization/charts.py if needed.
- Create src/analysis/reporting.py.
- Create src/quality_gate.py.
- Create scripts/run_pipeline.py.
- Save cleaned data to data/processed/sales_clean.csv.
- Save metric tables to artifacts/metrics/.
- Save charts to artifacts/charts/.
- Save reports/data_quality.md and reports/analysis_summary.md.

Rules:
- Do not modify data/raw/sales_sample.csv.
- Do not train a machine learning model today.
- Do not introduce SQL.
- Do not make causal claims in reports.
- Keep the code beginner-readable.

Before editing files, summarize the implementation plan and list the files you will create or modify.
```

AI가 계획을 제시하면 다음 기준으로 확인한다.

```text
[ ] raw data를 수정하지 않는다고 되어 있는가?
[ ] 머신러닝 모델 학습을 하지 않는다고 되어 있는가?
[ ] SQL을 도입하지 않는다고 되어 있는가?
[ ] run_pipeline.py가 전체 실행 진입점으로 되어 있는가?
[ ] 품질 게이트가 포함되어 있는가?
```

계획이 맞으면 다음을 입력한다.

[AI 코딩 도구]

```text
Proceed with the Session 5 reproducible pipeline implementation.
After creating files, tell me the exact command to run the pipeline and the expected output files.
```

AI가 파일을 잘 만들면 10장으로 이동한다. AI가 파일을 만들지 못하거나, 학습자가 직접 작성해야 한다면 3장부터 그대로 따라간다.

---

# 3. 실습 2 — config 표준화

## 3.1 config 파일이 왜 중요한가

파이프라인에서 config는 “변경 가능한 설정을 모아 둔 문서”이다. 경로, target 변수, feature 목록, random seed를 코드 곳곳에 직접 쓰면 나중에 수정하기 어렵다.

나쁜 방식:

```python
df = pd.read_csv("data/raw/sales_sample.csv")
target = "returned"
```

좋은 방식:

```python
config = load_config()
raw_path = config["paths"]["raw_data"]
target = config["data"]["target"]
```

즉, config의 원칙은 다음이다.

```text
코드는 일반화한다.
프로젝트별 설정은 config에 둔다.
```

---

## 3.2 config/analysis_config.yaml 작성

기존 config가 있더라도, 5회차에서는 아래 구조로 표준화한다.

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

[파일 내용: `config/analysis_config.yaml`]

```yaml
project:
  name: "AI Data Lab"
  description: "Python-first reproducible data analysis pipeline"

paths:
  raw_data: "data/raw/sales_sample.csv"
  processed_data: "data/processed/sales_clean.csv"
  interim_data_dir: "data/interim"
  processed_data_dir: "data/processed"
  reports_dir: "reports"
  charts_dir: "artifacts/charts"
  models_dir: "artifacts/models"
  metrics_dir: "artifacts/metrics"

data:
  id_columns:
    - order_id
    - customer_id
  date_column: order_date
  target: returned
  numeric_features:
    - quantity
    - unit_price
    - discount_rate
    - revenue
    - customer_age
  categorical_features:
    - region
    - channel
    - product_category

modeling:
  task_type: classification
  test_ratio: 0.2
  random_seed: 42
  baseline_metric: f1_score

eda:
  max_category_levels_to_display: 20
  outlier_check_columns:
    - quantity
    - unit_price
    - revenue
    - customer_age

cleaning:
  drop_duplicate_rows: true
  fill_numeric_with: "median"
  fill_categorical_with: "unknown"
  remove_outliers: false

ai_interpretation:
  enabled: false
  provider: null
  model: null
  output_file: "reports/ai_interpretation.md"
```

저장 후 config가 읽히는지 확인한다.

[터미널]

```bash
uv run python -c "import yaml; from pathlib import Path; cfg=yaml.safe_load(Path('config/analysis_config.yaml').read_text(encoding='utf-8')); print(cfg['project']['name']); print(cfg['paths']['processed_data'])"
```

정상이라면 다음과 비슷하게 출력된다.

```text
AI Data Lab
data/processed/sales_clean.csv
```

---

# 4. 실습 3 — 폴더 준비

파이프라인은 산출물을 여러 폴더에 저장한다. 폴더가 없으면 파일 저장 단계에서 오류가 날 수 있다.

### Windows PowerShell

[터미널]

```powershell
$dirs = @(
  "data/processed",
  "data/interim",
  "artifacts/charts",
  "artifacts/metrics",
  "artifacts/models",
  "reports",
  "src/data",
  "src/analysis",
  "src/visualization",
  "scripts"
)

foreach ($d in $dirs) {
  New-Item -ItemType Directory -Force $d | Out-Null
}
```

### Mac Terminal

[터미널]

```bash
mkdir -p data/processed data/interim
mkdir -p artifacts/charts artifacts/metrics artifacts/models
mkdir -p reports src/data src/analysis src/visualization scripts
```

---

# 5. 실습 4 — 직접 붙여넣을 코드

## 5.1 src/data/loading.py

[파일 내용: `src/data/loading.py`]

```python
"""Data loading utilities for the reproducible analysis pipeline."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import pandas as pd
import yaml


def load_config(config_path: str | Path = "config/analysis_config.yaml") -> dict[str, Any]:
    """Load the YAML configuration file."""
    path = Path(config_path)
    if not path.exists():
        raise FileNotFoundError(f"Config file not found: {path}")
    return yaml.safe_load(path.read_text(encoding="utf-8"))


def load_raw_data(config: dict[str, Any]) -> pd.DataFrame:
    """Load the raw dataset defined in the config file."""
    raw_path = Path(config["paths"]["raw_data"])
    if not raw_path.exists():
        raise FileNotFoundError(f"Raw data file not found: {raw_path}")

    date_column = config["data"].get("date_column")
    parse_dates = [date_column] if date_column else None
    return pd.read_csv(raw_path, parse_dates=parse_dates)
```

---

## 5.2 src/data/schema.py

[파일 내용: `src/data/schema.py`]

```python
"""Schema validation utilities for tabular data."""

from __future__ import annotations

from typing import Any

import pandas as pd


def get_required_columns(config: dict[str, Any]) -> list[str]:
    """Return the required columns defined by the project config."""
    data_cfg = config["data"]
    columns: list[str] = []
    columns.extend(data_cfg.get("id_columns", []))
    columns.append(data_cfg["date_column"])
    columns.append(data_cfg["target"])
    columns.extend(data_cfg.get("numeric_features", []))
    columns.extend(data_cfg.get("categorical_features", []))
    return list(dict.fromkeys(columns))


def validate_schema(df: pd.DataFrame, config: dict[str, Any]) -> dict[str, Any]:
    """Validate whether all required columns are present in the DataFrame."""
    required_columns = get_required_columns(config)
    missing_columns = [col for col in required_columns if col not in df.columns]

    if missing_columns:
        raise ValueError(
            "Required columns are missing from the raw data: "
            + ", ".join(missing_columns)
        )

    return {
        "required_column_count": len(required_columns),
        "actual_column_count": len(df.columns),
        "missing_columns": missing_columns,
        "passed": True,
    }
```

---

## 5.3 src/data/cleaning.py

[파일 내용: `src/data/cleaning.py`]

```python
"""Data cleaning utilities for the analysis pipeline."""

from __future__ import annotations

from typing import Any

import pandas as pd


def clean_data(df: pd.DataFrame, config: dict[str, Any]) -> pd.DataFrame:
    """Clean the raw dataset without modifying the original DataFrame."""
    data = df.copy()
    data_cfg = config["data"]
    cleaning_cfg = config.get("cleaning", {})

    date_column = data_cfg["date_column"]
    if date_column in data.columns:
        data[date_column] = pd.to_datetime(data[date_column], errors="coerce")

    numeric_fill_method = cleaning_cfg.get("fill_numeric_with", "median")
    for col in data_cfg.get("numeric_features", []):
        if col not in data.columns:
            continue
        data[col] = pd.to_numeric(data[col], errors="coerce")
        if numeric_fill_method == "median":
            fill_value = data[col].median()
        else:
            fill_value = 0
        data[col] = data[col].fillna(fill_value)

    categorical_fill_value = cleaning_cfg.get("fill_categorical_with", "unknown")
    for col in data_cfg.get("categorical_features", []):
        if col not in data.columns:
            continue
        data[col] = data[col].fillna(categorical_fill_value).astype(str)

    target = data_cfg["target"]
    if target in data.columns:
        data[target] = pd.to_numeric(data[target], errors="coerce").fillna(0).astype(int)

    if cleaning_cfg.get("drop_duplicate_rows", True):
        data = data.drop_duplicates().reset_index(drop=True)

    # Outliers are not removed by default. They are documented and reviewed.
    return data
```

---

## 5.4 src/data/quality.py

[파일 내용: `src/data/quality.py`]

```python
"""Data quality checks for raw and cleaned datasets."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import pandas as pd


def missing_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Return missing value counts and percentages by column."""
    summary = pd.DataFrame(
        {
            "column": df.columns,
            "missing_count": [int(df[col].isna().sum()) for col in df.columns],
            "missing_pct": [round(float(df[col].isna().mean()), 4) for col in df.columns],
            "dtype": [str(df[col].dtype) for col in df.columns],
        }
    )
    return summary.sort_values("missing_count", ascending=False).reset_index(drop=True)


def duplicate_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Return a one-row summary of duplicate rows."""
    duplicate_count = int(df.duplicated().sum())
    duplicate_pct = duplicate_count / len(df) if len(df) else 0.0
    return pd.DataFrame(
        {
            "row_count": [len(df)],
            "column_count": [df.shape[1]],
            "duplicate_count": [duplicate_count],
            "duplicate_pct": [round(duplicate_pct, 4)],
        }
    )


def numeric_outlier_summary(df: pd.DataFrame, columns: list[str]) -> pd.DataFrame:
    """Detect numeric outlier candidates using the IQR rule."""
    rows: list[dict[str, float | int | str]] = []

    for col in columns:
        if col not in df.columns:
            continue

        series = pd.to_numeric(df[col], errors="coerce").dropna()
        if series.empty:
            rows.append(
                {
                    "column": col,
                    "q1": 0.0,
                    "q3": 0.0,
                    "iqr": 0.0,
                    "lower_bound": 0.0,
                    "upper_bound": 0.0,
                    "outlier_count": 0,
                    "outlier_pct": 0.0,
                }
            )
            continue

        q1 = float(series.quantile(0.25))
        q3 = float(series.quantile(0.75))
        iqr = q3 - q1
        lower_bound = q1 - 1.5 * iqr
        upper_bound = q3 + 1.5 * iqr
        outlier_count = int(((series < lower_bound) | (series > upper_bound)).sum())

        rows.append(
            {
                "column": col,
                "q1": q1,
                "q3": q3,
                "iqr": iqr,
                "lower_bound": lower_bound,
                "upper_bound": upper_bound,
                "outlier_count": outlier_count,
                "outlier_pct": round(outlier_count / len(series), 4),
            }
        )

    return pd.DataFrame(rows)


def run_quality_checks(df: pd.DataFrame, config: dict[str, Any]) -> dict[str, pd.DataFrame]:
    """Run all quality checks and return quality tables."""
    return {
        "missing": missing_summary(df),
        "duplicates": duplicate_summary(df),
        "outliers": numeric_outlier_summary(df, config["eda"]["outlier_check_columns"]),
    }


def save_quality_tables(
    quality: dict[str, pd.DataFrame],
    metrics_dir: str | Path,
    prefix: str,
) -> None:
    """Save quality tables to CSV files."""
    output_dir = Path(metrics_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    quality["missing"].to_csv(output_dir / f"{prefix}_missing_summary.csv", index=False)
    quality["duplicates"].to_csv(output_dir / f"{prefix}_duplicate_summary.csv", index=False)
    quality["outliers"].to_csv(output_dir / f"{prefix}_outlier_summary.csv", index=False)
```

---

## 5.5 src/analysis/kpis.py

[파일 내용: `src/analysis/kpis.py`]

```python
"""KPI and EDA table calculations."""

from __future__ import annotations

from pathlib import Path

import pandas as pd


def overall_kpis(df: pd.DataFrame) -> pd.DataFrame:
    """Compute overall dataset-level KPIs."""
    return pd.DataFrame(
        {
            "metric": [
                "row_count",
                "order_count",
                "customer_count",
                "total_revenue",
                "average_revenue",
                "median_revenue",
                "return_rate",
            ],
            "value": [
                len(df),
                df["order_id"].nunique(),
                df["customer_id"].nunique(),
                round(float(df["revenue"].sum()), 2),
                round(float(df["revenue"].mean()), 2),
                round(float(df["revenue"].median()), 2),
                round(float(df["returned"].mean()), 4),
            ],
        }
    )


def region_revenue_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Compute revenue summary by region."""
    return (
        df.groupby("region", dropna=False)
        .agg(
            order_count=("order_id", "count"),
            total_revenue=("revenue", "sum"),
            average_revenue=("revenue", "mean"),
            median_revenue=("revenue", "median"),
        )
        .reset_index()
        .sort_values("average_revenue", ascending=False)
    )


def channel_return_rate(df: pd.DataFrame) -> pd.DataFrame:
    """Compute return rate by sales channel."""
    return (
        df.groupby("channel", dropna=False)
        .agg(
            order_count=("order_id", "count"),
            return_count=("returned", "sum"),
            return_rate=("returned", "mean"),
        )
        .reset_index()
        .sort_values("return_rate", ascending=False)
    )


def category_revenue_share(df: pd.DataFrame) -> pd.DataFrame:
    """Compute revenue share by product category."""
    summary = (
        df.groupby("product_category", dropna=False)
        .agg(total_revenue=("revenue", "sum"), order_count=("order_id", "count"))
        .reset_index()
        .sort_values("total_revenue", ascending=False)
    )
    total = float(summary["total_revenue"].sum())
    summary["revenue_share"] = summary["total_revenue"] / total if total else 0.0
    return summary


def monthly_revenue(df: pd.DataFrame) -> pd.DataFrame:
    """Compute monthly revenue trend."""
    data = df.copy()
    data["order_month"] = pd.to_datetime(data["order_date"]).dt.to_period("M").astype(str)
    return (
        data.groupby("order_month")
        .agg(order_count=("order_id", "count"), total_revenue=("revenue", "sum"))
        .reset_index()
        .sort_values("order_month")
    )


def compute_all_kpis(df: pd.DataFrame) -> dict[str, pd.DataFrame]:
    """Compute all KPI tables used by the pipeline."""
    return {
        "overall_kpis": overall_kpis(df),
        "region_revenue": region_revenue_summary(df),
        "channel_return_rate": channel_return_rate(df),
        "category_revenue_share": category_revenue_share(df),
        "monthly_revenue": monthly_revenue(df),
    }


def save_kpi_tables(kpis: dict[str, pd.DataFrame], metrics_dir: str | Path) -> None:
    """Save KPI tables to CSV files."""
    output_dir = Path(metrics_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    for name, table in kpis.items():
        table.to_csv(output_dir / f"{name}.csv", index=False)
```

---

## 5.6 src/visualization/charts.py

[파일 내용: `src/visualization/charts.py`]

```python
"""Matplotlib chart utilities for reproducible EDA outputs."""

from __future__ import annotations

from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd


def _prepare_output(path: str | Path) -> Path:
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    return output_path


def save_bar_chart(
    data: pd.DataFrame,
    x: str,
    y: str,
    title: str,
    output_path: str | Path,
    rotation: int = 0,
) -> None:
    """Save a simple bar chart."""
    output = _prepare_output(output_path)
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.bar(data[x].astype(str), data[y])
    ax.set_title(title)
    ax.set_xlabel(x)
    ax.set_ylabel(y)
    ax.tick_params(axis="x", rotation=rotation)
    fig.tight_layout()
    fig.savefig(output, dpi=150)
    plt.close(fig)


def save_line_chart(
    data: pd.DataFrame,
    x: str,
    y: str,
    title: str,
    output_path: str | Path,
    rotation: int = 45,
) -> None:
    """Save a simple line chart."""
    output = _prepare_output(output_path)
    fig, ax = plt.subplots(figsize=(9, 5))
    ax.plot(data[x].astype(str), data[y], marker="o")
    ax.set_title(title)
    ax.set_xlabel(x)
    ax.set_ylabel(y)
    ax.tick_params(axis="x", rotation=rotation)
    fig.tight_layout()
    fig.savefig(output, dpi=150)
    plt.close(fig)


def save_histogram(
    data: pd.DataFrame,
    column: str,
    title: str,
    output_path: str | Path,
    bins: int = 40,
) -> None:
    """Save a histogram for a numeric column."""
    output = _prepare_output(output_path)
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.hist(pd.to_numeric(data[column], errors="coerce").dropna(), bins=bins)
    ax.set_title(title)
    ax.set_xlabel(column)
    ax.set_ylabel("count")
    fig.tight_layout()
    fig.savefig(output, dpi=150)
    plt.close(fig)


def save_all_charts(kpis: dict[str, pd.DataFrame], df: pd.DataFrame, charts_dir: str | Path) -> None:
    """Save all standard EDA charts."""
    output_dir = Path(charts_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    save_bar_chart(
        kpis["region_revenue"],
        x="region",
        y="average_revenue",
        title="Average Revenue by Region",
        output_path=output_dir / "revenue_by_region.png",
        rotation=30,
    )
    save_bar_chart(
        kpis["channel_return_rate"],
        x="channel",
        y="return_rate",
        title="Return Rate by Channel",
        output_path=output_dir / "return_rate_by_channel.png",
    )
    save_bar_chart(
        kpis["category_revenue_share"],
        x="product_category",
        y="revenue_share",
        title="Revenue Share by Product Category",
        output_path=output_dir / "revenue_share_by_category.png",
        rotation=30,
    )
    save_line_chart(
        kpis["monthly_revenue"],
        x="order_month",
        y="total_revenue",
        title="Monthly Revenue Trend",
        output_path=output_dir / "monthly_revenue_trend.png",
    )
    save_histogram(
        df,
        column="revenue",
        title="Revenue Distribution",
        output_path=output_dir / "revenue_distribution.png",
    )
```

---

## 5.7 src/analysis/reporting.py

[파일 내용: `src/analysis/reporting.py`]

```python
"""Markdown report generation for the reproducible pipeline."""

from __future__ import annotations

from pathlib import Path

import pandas as pd


def _top_value(table: pd.DataFrame, column: str) -> str:
    if table.empty or column not in table.columns:
        return "unknown"
    return str(table.iloc[0][column])


def write_data_quality_report(
    output_path: str | Path,
    raw_quality: dict[str, pd.DataFrame],
    clean_quality: dict[str, pd.DataFrame],
) -> None:
    """Write a data quality report comparing raw and cleaned data."""
    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)

    raw_duplicates = int(raw_quality["duplicates"].iloc[0]["duplicate_count"])
    clean_duplicates = int(clean_quality["duplicates"].iloc[0]["duplicate_count"])
    top_missing = _top_value(raw_quality["missing"], "column")

    output.write_text(
        f"""# Data Quality Report

## 1. 목적

이 보고서는 원본 데이터와 정제 데이터의 품질 상태를 비교하기 위해 작성되었다.
원본 데이터는 수정하지 않으며, 정제 결과는 `data/processed/sales_clean.csv`에 저장한다.

## 2. Raw Data 품질 요약

- 중복 행 수: {raw_duplicates}
- 결측값이 가장 많이 관찰된 컬럼: `{top_missing}`
- 이상치 후보는 IQR 규칙으로 탐지하였다.

## 3. Cleaned Data 품질 요약

- 정제 후 중복 행 수: {clean_duplicates}
- 수치형 결측값은 config의 cleaning 정책에 따라 대체하였다.
- 범주형 결측값은 config의 cleaning 정책에 따라 `unknown`으로 대체하였다.
- 이상치는 기본적으로 제거하지 않았다. 이상치는 분석 해석에서 별도 주의 대상으로 남긴다.

## 4. 해석상 주의사항

- 결측값 대체는 편향을 줄 수도 있으므로 모델링 단계에서 다시 검토해야 한다.
- 중복 제거는 동일 주문이 실수로 반복 기록되었다는 가정에 기반한다.
- 이상치를 자동 삭제하지 않았기 때문에 평균과 총합 해석 시 주의해야 한다.
""",
        encoding="utf-8",
    )


def write_analysis_summary(
    output_path: str | Path,
    kpis: dict[str, pd.DataFrame],
) -> None:
    """Write a concise analysis summary without causal claims."""
    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)

    overall = kpis["overall_kpis"]
    region = kpis["region_revenue"]
    channel = kpis["channel_return_rate"]
    category = kpis["category_revenue_share"]

    total_revenue = overall.loc[overall["metric"] == "total_revenue", "value"].iloc[0]
    return_rate = overall.loc[overall["metric"] == "return_rate", "value"].iloc[0]
    top_region = str(region.iloc[0]["region"])
    top_channel = str(channel.iloc[0]["channel"])
    top_category = str(category.iloc[0]["product_category"])

    output.write_text(
        f"""# Analysis Summary

## 1. 전체 요약

- 총 매출: {total_revenue}
- 전체 반품률: {return_rate}
- 평균 매출이 가장 높은 지역: `{top_region}`
- 관찰된 반품률이 가장 높은 채널: `{top_channel}`
- 매출 비중이 가장 큰 상품 범주: `{top_category}`

## 2. 주요 발견

1. 지역별 평균 매출에는 차이가 관찰된다.
2. 채널별 반품률에는 차이가 관찰된다.
3. 상품 범주별 매출 비중은 동일하지 않다.
4. 월별 매출 추세는 차트로 확인할 수 있다.

## 3. 인과 해석 금지

현재 분석은 관찰 데이터에 대한 탐색적 분석이다.
따라서 “특정 채널이 반품을 유발한다” 또는 “특정 지역이 매출을 증가시킨다”라고 말할 수 없다.
현재 단계에서는 관계, 차이, 패턴만 기술한다.

## 4. 다음 단계

- 6회차에서 `data/processed/sales_clean.csv`를 사용하여 scikit-learn baseline 모델을 학습한다.
- 모델링 전 target leakage 가능성을 점검한다.
- 결측값 대체와 이상치 처리 정책이 모델 성능에 미치는 영향을 비교한다.
""",
        encoding="utf-8",
    )
```

---

## 5.8 src/quality_gate.py

[파일 내용: `src/quality_gate.py`]

```python
"""Quality gate for the reproducible analysis pipeline."""

from __future__ import annotations

from pathlib import Path
from typing import Any


def check_pipeline_output(config: dict[str, Any]) -> bool:
    """Check whether the expected pipeline outputs exist."""
    paths = config["paths"]
    charts_dir = Path(paths["charts_dir"])
    metrics_dir = Path(paths["metrics_dir"])

    checks = {
        "processed_data": Path(paths["processed_data"]).exists(),
        "data_quality_report": Path(paths["reports_dir"]) / "data_quality.md",
        "analysis_summary": Path(paths["reports_dir"]) / "analysis_summary.md",
        "overall_kpis": metrics_dir / "overall_kpis.csv",
        "raw_missing_summary": metrics_dir / "raw_missing_summary.csv",
        "clean_missing_summary": metrics_dir / "clean_missing_summary.csv",
        "charts_exist": len(list(charts_dir.glob("*.png"))) > 0,
    }

    print("\n품질 게이트 결과:")
    all_pass = True

    for name, target in checks.items():
        if isinstance(target, bool):
            passed = target
        else:
            passed = Path(target).exists()

        status = "PASS" if passed else "FAIL"
        if not passed:
            all_pass = False
        print(f"  [{status}] {name}")

    return all_pass
```

---

## 5.9 scripts/run_pipeline.py

[파일 내용: `scripts/run_pipeline.py`]

```python
"""Run the full reproducible analysis pipeline."""

from __future__ import annotations

from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))

from src.analysis.kpis import compute_all_kpis, save_kpi_tables  # noqa: E402
from src.analysis.reporting import write_analysis_summary, write_data_quality_report  # noqa: E402
from src.data.cleaning import clean_data  # noqa: E402
from src.data.loading import load_config, load_raw_data  # noqa: E402
from src.data.quality import run_quality_checks, save_quality_tables  # noqa: E402
from src.data.schema import validate_schema  # noqa: E402
from src.quality_gate import check_pipeline_output  # noqa: E402
from src.visualization.charts import save_all_charts  # noqa: E402


def ensure_output_dirs(config: dict) -> None:
    """Create output directories used by the pipeline."""
    paths = config["paths"]
    for key in ["processed_data_dir", "reports_dir", "charts_dir", "metrics_dir"]:
        Path(paths[key]).mkdir(parents=True, exist_ok=True)


def main() -> None:
    """Execute the full analysis pipeline."""
    config = load_config()
    ensure_output_dirs(config)

    print("=" * 60)
    print(f"파이프라인 시작: {config['project']['name']}")
    print("=" * 60)

    print("\n[1/8] raw data 로딩")
    raw_df = load_raw_data(config)
    print(f"raw shape: {raw_df.shape}")

    print("\n[2/8] schema 검증")
    schema_result = validate_schema(raw_df, config)
    print(f"schema passed: {schema_result['passed']}")

    print("\n[3/8] raw data 품질검사")
    raw_quality = run_quality_checks(raw_df, config)
    save_quality_tables(raw_quality, config["paths"]["metrics_dir"], prefix="raw")
    raw_duplicate_count = int(raw_quality["duplicates"].iloc[0]["duplicate_count"])
    print(f"raw duplicate rows: {raw_duplicate_count}")

    print("\n[4/8] cleaning 수행")
    clean_df = clean_data(raw_df, config)
    processed_path = Path(config["paths"]["processed_data"])
    processed_path.parent.mkdir(parents=True, exist_ok=True)
    clean_df.to_csv(processed_path, index=False)
    print(f"processed data saved: {processed_path}")
    print(f"clean shape: {clean_df.shape}")

    print("\n[5/8] cleaned data 품질검사")
    clean_quality = run_quality_checks(clean_df, config)
    save_quality_tables(clean_quality, config["paths"]["metrics_dir"], prefix="clean")

    print("\n[6/8] KPI 계산과 저장")
    kpis = compute_all_kpis(clean_df)
    save_kpi_tables(kpis, config["paths"]["metrics_dir"])

    print("\n[7/8] chart 생성")
    save_all_charts(kpis, clean_df, config["paths"]["charts_dir"])

    print("\n[8/8] report 생성")
    reports_dir = Path(config["paths"]["reports_dir"])
    write_data_quality_report(
        reports_dir / "data_quality.md",
        raw_quality=raw_quality,
        clean_quality=clean_quality,
    )
    write_analysis_summary(
        reports_dir / "analysis_summary.md",
        kpis=kpis,
    )

    passed = check_pipeline_output(config)

    print("=" * 60)
    print("파이프라인 완료")
    print("PASS" if passed else "CONCERNS")
    print("=" * 60)

    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
```

---

# 6. 실습 5 — 파이프라인 실행

## 6.1 실행 전 raw data 확인

[터미널]

```bash
uv run python -c "from pathlib import Path; print(Path('data/raw/sales_sample.csv').exists())"
```

정상이라면 다음이 출력된다.

```text
True
```

`False`가 나오면 3회차의 합성 데이터 생성 스크립트를 다시 실행한다.

[터미널]

```bash
uv run python scripts/generate_sample_data.py
```

---

## 6.2 전체 파이프라인 실행

[터미널]

```bash
uv run python scripts/run_pipeline.py
```

정상이라면 다음과 비슷한 결과가 나온다.

```text
============================================================
파이프라인 시작: AI Data Lab
============================================================

[1/8] raw data 로딩
raw shape: (6050, 12)

[2/8] schema 검증
schema passed: True

[3/8] raw data 품질검사
raw duplicate rows: 50

[4/8] cleaning 수행
processed data saved: data/processed/sales_clean.csv
clean shape: (6000, 12)

...
품질 게이트 결과:
  [PASS] processed_data
  [PASS] data_quality_report
  [PASS] analysis_summary
  [PASS] overall_kpis
  [PASS] raw_missing_summary
  [PASS] clean_missing_summary
  [PASS] charts_exist
============================================================
파이프라인 완료
PASS
============================================================
```

---

# 7. 실습 6 — 산출물 확인

## 7.1 정제 데이터 확인

### Windows PowerShell

[터미널]

```powershell
dir data\processed
```

### Mac Terminal

[터미널]

```bash
ls data/processed
```

다음 파일이 보여야 한다.

```text
sales_clean.csv
```

데이터 크기를 확인한다.

[터미널]

```bash
uv run python -c "import pandas as pd; df=pd.read_csv('data/processed/sales_clean.csv'); print(df.shape); print(df.head())"
```

---

## 7.2 metric 파일 확인

### Windows PowerShell

[터미널]

```powershell
dir artifacts\metrics
```

### Mac Terminal

[터미널]

```bash
ls artifacts/metrics
```

다음 파일이 있어야 한다.

```text
raw_missing_summary.csv
raw_duplicate_summary.csv
raw_outlier_summary.csv
clean_missing_summary.csv
clean_duplicate_summary.csv
clean_outlier_summary.csv
overall_kpis.csv
region_revenue.csv
channel_return_rate.csv
category_revenue_share.csv
monthly_revenue.csv
```

---

## 7.3 chart 파일 확인

### Windows PowerShell

[터미널]

```powershell
dir artifacts\charts
```

### Mac Terminal

[터미널]

```bash
ls artifacts/charts
```

다음 파일이 있어야 한다.

```text
revenue_by_region.png
return_rate_by_channel.png
revenue_share_by_category.png
monthly_revenue_trend.png
revenue_distribution.png
```

---

## 7.4 보고서 확인

### Windows PowerShell

[터미널]

```powershell
dir reports
```

### Mac Terminal

[터미널]

```bash
ls reports
```

다음 파일이 있어야 한다.

```text
data_quality.md
analysis_summary.md
```

보고서 내용을 터미널에서 바로 보려면 다음을 실행한다.

[터미널]

```bash
uv run python -c "from pathlib import Path; print(Path('reports/analysis_summary.md').read_text(encoding='utf-8')[:1000])"
```

---

# 8. 실습 7 — 재현성 검증

## 8.1 산출물을 일부 삭제하고 다시 실행하기

재현 가능하다는 것은 산출물을 삭제해도 같은 명령으로 다시 만들 수 있다는 뜻이다.

### Windows PowerShell

[터미널]

```powershell
Remove-Item data\processed\sales_clean.csv -ErrorAction SilentlyContinue
Remove-Item reports\data_quality.md -ErrorAction SilentlyContinue
Remove-Item reports\analysis_summary.md -ErrorAction SilentlyContinue
Remove-Item artifacts\charts\*.png -ErrorAction SilentlyContinue
```

### Mac Terminal

[터미널]

```bash
rm -f data/processed/sales_clean.csv
rm -f reports/data_quality.md reports/analysis_summary.md
rm -f artifacts/charts/*.png
```

다시 실행한다.

[터미널]

```bash
uv run python scripts/run_pipeline.py
```

삭제했던 파일이 다시 생성되면 재현성 검증에 성공한 것이다.

---

## 8.2 품질 게이트만 다시 확인하기

[터미널]

```bash
uv run python -c "from src.data.loading import load_config; from src.quality_gate import check_pipeline_output; cfg=load_config(); print(check_pipeline_output(cfg))"
```

정상이라면 마지막에 다음이 출력된다.

```text
True
```

---

# 9. 실습 8 — BMAD 코드 리뷰

파이프라인이 실행되었다고 해서 좋은 코드라는 뜻은 아니다. BMAD 코드 리뷰를 통해 구조를 점검한다.

[AI 코딩 도구]

```text
/clear
bmad-code-review

Review the current data analysis pipeline.

Focus on:
- reproducibility
- notebook/src separation
- raw data immutability
- config usage
- schema validation
- data quality coverage
- cleaning assumptions
- hardcoded paths
- misleading causal claims
- readiness for Session 6 scikit-learn baseline modeling

Return PASS, CONCERNS, or FAIL.
For each concern, provide:
- affected file
- why it matters
- exact fix
```

리뷰 결과가 `CONCERNS`여도 실패가 아니다. 수정할 항목이 있다는 뜻이다. `FAIL`이면 다음 차시로 넘어가기 전에 반드시 수정한다.

---

# 10. README.md 보완

## 10.1 How to Reproduce 섹션 추가

AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구]

```text
Update README.md by adding a "How to Reproduce the Analysis" section.

Include:
- how to install dependencies with uv
- how to generate sample data
- how to run the full pipeline
- what output files are generated
- the rule that data/raw/sales_sample.csv must not be manually modified
- the rule that reports must not make causal claims from EDA alone
```

직접 작성하려면 README.md에 다음 내용을 추가한다.

[파일 내용: `README.md`에 추가]

````md
## How to Reproduce the Analysis

Install dependencies:

```bash
uv add pandas pyyaml matplotlib pytest ruff
```

Generate sample data if needed:

```bash
uv run python scripts/generate_sample_data.py
```

Run the full analysis pipeline:

```bash
uv run python scripts/run_pipeline.py
```

Expected outputs:

- `data/processed/sales_clean.csv`
- `artifacts/metrics/*.csv`
- `artifacts/charts/*.png`
- `reports/data_quality.md`
- `reports/analysis_summary.md`

Rules:

- Do not manually modify `data/raw/sales_sample.csv`.
- Use `config/analysis_config.yaml` for paths and variable settings.
- Do not express correlation as causation.
- Model training starts in the next session, not in this pipeline session.
````

---

# 11. GitHub에 올리기 전 안전 규칙

## 11.1 .gitignore 확인

`.gitignore`에 다음 내용이 포함되어 있어야 한다.

[파일 내용: `.gitignore`]

```gitignore
# Python
__pycache__/
*.py[cod]
.pytest_cache/
.ruff_cache/

# Virtual environments
.venv/
.env

# OS files
.DS_Store
Thumbs.db

# Temporary files
*.tmp
*.log

# Large model artifacts
artifacts/models/*.pkl
artifacts/models/*.pt
artifacts/models/*.pth

# Private real-world data
# Keep synthetic class data, but do not commit private datasets.
data/raw/private_*
data/raw/*personal*
data/raw/*confidential*
```

> [!IMPORTANT]
> 오늘 사용하는 `data/raw/sales_sample.csv`는 합성 데이터이므로 수업용으로 커밋할 수 있다. 그러나 실제 개인정보가 포함된 데이터는 GitHub에 올리면 안 된다.

---

# 12. 오늘의 품질 게이트

## 12.1 실행 게이트

```text
[ ] uv run python scripts/run_pipeline.py가 실행된다.
[ ] 실행 결과가 PASS로 끝난다.
[ ] data/processed/sales_clean.csv가 생성된다.
[ ] reports/data_quality.md가 생성된다.
[ ] reports/analysis_summary.md가 생성된다.
```

## 12.2 config 게이트

```text
[ ] config/analysis_config.yaml이 있다.
[ ] paths.raw_data가 data/raw/sales_sample.csv를 가리킨다.
[ ] paths.processed_data가 data/processed/sales_clean.csv를 가리킨다.
[ ] data.target이 returned로 설정되어 있다.
[ ] numeric_features가 있다.
[ ] categorical_features가 있다.
[ ] cleaning 정책이 있다.
```

## 12.3 코드 구조 게이트

```text
[ ] src/data/loading.py가 있다.
[ ] src/data/schema.py가 있다.
[ ] src/data/cleaning.py가 있다.
[ ] src/data/quality.py가 있다.
[ ] src/analysis/kpis.py가 있다.
[ ] src/analysis/reporting.py가 있다.
[ ] src/visualization/charts.py가 있다.
[ ] src/quality_gate.py가 있다.
[ ] scripts/run_pipeline.py가 있다.
```

## 12.4 분석 윤리 게이트

```text
[ ] raw data를 수정하지 않았다.
[ ] 이상치를 무조건 삭제하지 않았다.
[ ] 결측값 처리 방식을 보고서에 기록했다.
[ ] EDA 결과를 인과관계처럼 표현하지 않았다.
[ ] 머신러닝 모델 학습을 오늘 파이프라인에 넣지 않았다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Check the current project against the Session 5 data analysis quality gates:

1. scripts/run_pipeline.py exists and runs.
2. config/analysis_config.yaml defines paths, target, features, cleaning policy, and random seed.
3. schema validation exists.
4. cleaning module exists.
5. data quality checks exist for raw and cleaned data.
6. data/processed/sales_clean.csv is generated.
7. artifacts/metrics/*.csv are generated.
8. artifacts/charts/*.png are generated.
9. reports/data_quality.md and reports/analysis_summary.md are generated.
10. raw data is not modified.
11. no machine learning model is trained in Session 5.
12. reports avoid causal claims.

Return PASS, CONCERNS, or FAIL.
For every concern, provide the exact file and exact fix.
```

---

# 13. GitHub에 커밋하기

## 13.1 현재 변경 사항 확인

[터미널]

```bash
git status
```

아직 Git 저장소가 아니라는 메시지가 나오면 다음을 실행한다.

[터미널]

```bash
git init
```

다시 확인한다.

[터미널]

```bash
git status
```

---

## 13.2 파일 추가와 커밋

[터미널]

```bash
git add .
git commit -m "Add session 5 reproducible analysis pipeline"
```

커밋이 성공하면 5회차 작업이 저장된 것이다.

---

# 14. 과제 안내

## 과제 1. 재현성 검증 기록 작성

`reports/reproducibility_check.md` 파일을 만든다.

[파일 내용: `reports/reproducibility_check.md`]

````md
# Reproducibility Check

## 1. 실행한 명령

```bash
uv run python scripts/run_pipeline.py
```

## 2. 생성된 주요 산출물

- `data/processed/sales_clean.csv`:
- `reports/data_quality.md`:
- `reports/analysis_summary.md`:
- `artifacts/metrics/*.csv`:
- `artifacts/charts/*.png`:

## 3. 삭제 후 재실행 여부

- 산출물을 일부 삭제한 뒤 다시 생성되었는가:

## 4. 발견한 문제

- 문제 1:
- 문제 2:

## 5. 다음 차시 전 보완할 점

- 보완 1:
- 보완 2:
````

---

## 과제 2. cleaning 정책 설명 작성

`reports/cleaning_policy.md` 파일을 만든다.

```md
# Cleaning Policy

## 1. 결측값 처리

- 수치형 변수:
- 범주형 변수:

## 2. 중복 처리

- 중복 행 처리 방식:
- 이 방식의 가정:

## 3. 이상치 처리

- 이상치 탐지 방식:
- 이상치를 자동 삭제하지 않은 이유:

## 4. 모델링 단계에서 다시 검토할 점

- 검토 1:
- 검토 2:
- 검토 3:
```

---

## 과제 3. 6회차 모델링 준비 질문 작성

`reports/modeling_readiness.md` 파일을 만든다.

```md
# Modeling Readiness

## 1. 예측하려는 target

- target:
- target의 의미:

## 2. 사용할 수 있는 feature

- 수치형 feature:
- 범주형 feature:

## 3. leakage 위험

- 모델이 예측 시점에 알 수 없는 정보가 feature에 포함되어 있는가:
- revenue가 returned 예측에 적절한 feature인지 검토가 필요한가:

## 4. 평가 지표 후보

- F1-score:
- precision:
- recall:
- accuracy:

## 5. 다음 차시에서 AI에게 물어볼 질문

1.
2.
3.
```

---

# 15. 자주 생기는 문제와 해결법

## 15.1 `ModuleNotFoundError: No module named 'src'`

가능한 원인:

```text
프로젝트 루트가 아닌 곳에서 스크립트를 실행했다.
scripts/run_pipeline.py에 sys.path 설정이 빠져 있다.
```

해결:

[터미널]

```bash
pwd
```

프로젝트 폴더가 아니면 이동한다.

```bash
cd ~/ai-data-lab
```

그다음 다시 실행한다.

```bash
uv run python scripts/run_pipeline.py
```

---

## 15.2 `KeyError: 'paths'`가 난다

가능한 원인:

```text
config/analysis_config.yaml 구조가 5회차 표준 구조와 다르다.
```

해결:

```text
3장에 있는 config/analysis_config.yaml 내용을 다시 붙여넣는다.
들여쓰기는 탭이 아니라 공백 2칸을 사용한다.
```

---

## 15.3 `FileNotFoundError: data/raw/sales_sample.csv`

가능한 원인:

```text
3회차 합성 데이터가 생성되지 않았다.
파일 위치가 config와 다르다.
```

해결:

[터미널]

```bash
uv run python scripts/generate_sample_data.py
uv run python scripts/run_pipeline.py
```

---

## 15.4 차트 파일이 생성되지 않는다

가능한 원인:

```text
matplotlib이 설치되지 않았다.
artifacts/charts 폴더가 없다.
```

해결:

[터미널]

```bash
uv add matplotlib
mkdir -p artifacts/charts
uv run python scripts/run_pipeline.py
```

Windows PowerShell에서 폴더를 만들려면 다음을 사용한다.

```powershell
New-Item -ItemType Directory -Force artifacts\charts | Out-Null
```

---

## 15.5 품질 게이트가 CONCERNS 또는 FAIL로 끝난다

먼저 어떤 항목이 FAIL인지 본다. 예를 들어 다음과 같이 나올 수 있다.

```text
[FAIL] analysis_summary
```

이 경우 해당 파일이 생성되지 않은 것이다. AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구]

```text
The Session 5 quality gate failed.
Find the missing or broken output and explain:
- which file is missing,
- which function should have created it,
- which script step failed,
- the exact fix.
Do not change the analysis scope.
```

---

## 15.6 AI가 머신러닝 코드를 넣으려고 한다

즉시 멈추고 다음을 입력한다.

[AI 코딩 도구]

```text
Stop. Session 5 is for reproducible analysis pipeline only.
Do not train a machine learning model today.
Prepare data and reports for Session 6, but keep model training out of scripts/run_pipeline.py.
```

---

# 16. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> 좋은 데이터분석 프로젝트는 분석 결과가 한 번만 나오는 프로젝트가 아니라, 같은 명령으로 같은 산출물을 다시 만들 수 있는 프로젝트이다.

5회차의 흐름은 다음과 같다.

```text
4회차 EDA 코드 확인
→ config 표준화
→ schema 검증 추가
→ cleaning 모듈 추가
→ 품질검사 저장
→ KPI와 chart 저장
→ 보고서 자동 생성
→ quality gate 실행
→ 재현성 검증
```

---

# 17. 5회차 최종 체크리스트

수업이 끝나기 전에 스스로 확인한다.

```text
[ ] 4회차 산출물이 존재한다.
[ ] config/analysis_config.yaml을 5회차 구조로 표준화했다.
[ ] src/data/schema.py를 만들었다.
[ ] src/data/cleaning.py를 만들었다.
[ ] src/analysis/reporting.py를 만들었다.
[ ] src/quality_gate.py를 만들었다.
[ ] scripts/run_pipeline.py를 만들었다.
[ ] uv run python scripts/run_pipeline.py가 실행된다.
[ ] data/processed/sales_clean.csv가 생성된다.
[ ] raw data를 수정하지 않았다.
[ ] reports/data_quality.md가 생성된다.
[ ] reports/analysis_summary.md가 생성된다.
[ ] artifacts/metrics/*.csv가 생성된다.
[ ] artifacts/charts/*.png가 생성된다.
[ ] 품질 게이트가 PASS 또는 수정 가능한 CONCERNS를 반환한다.
[ ] README.md에 재현 방법을 추가했다.
[ ] git commit을 완료했다.
```

---

## 부록 A. 오늘 사용하는 핵심 명령 모음

### 터미널 명령

```bash
pwd
uv run python -c "import pandas, yaml, matplotlib; print('packages ok')"
uv add pandas pyyaml matplotlib pytest ruff
uv run python scripts/generate_sample_data.py
uv run python scripts/run_pipeline.py
uv run python -c "from src.data.loading import load_config; from src.quality_gate import check_pipeline_output; cfg=load_config(); print(check_pipeline_output(cfg))"
git status
git add .
git commit -m "Add session 5 reproducible analysis pipeline"
```

### AI 코딩 도구 명령

```text
bmad-help
/clear
bmad-code-review
```

---

## 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| pipeline | 여러 분석 단계를 정해진 순서대로 실행하는 절차 |
| reproducibility | 같은 명령으로 같은 산출물을 다시 만들 수 있는 성질 |
| schema validation | 필요한 컬럼이 데이터에 있는지 확인하는 절차 |
| cleaning | 결측값, 중복, 타입 오류 등을 정리하는 절차 |
| processed data | raw data를 분석 가능하게 정리한 데이터 |
| quality gate | 산출물이 제대로 만들어졌는지 확인하는 검문소 |
| config | 경로와 변수 설정을 코드 밖에 모아 둔 설정 파일 |
| artifact | 분석 실행 결과로 생성된 표, 차트, 모델, 지표 파일 |
| leakage | 모델이 실제 예측 시점에는 알 수 없는 정보를 학습에 사용하는 문제 |
| source of truth | 여러 문서가 충돌할 때 기준이 되는 문서 |
