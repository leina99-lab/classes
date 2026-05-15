# 4회차 학습자 실습 매뉴얼: 데이터분석 트랙

# pandas 기반 EDA와 데이터 품질검사
## 데이터 로딩 → 품질검사 → 기술통계 → 시각화 → EDA 보고서 → 재현 가능한 스크립트

---

## 이 자료의 목적

4회차의 목표는 모델을 만드는 것이 아니다. 4회차의 목표는 3회차에서 만든 합성 데이터를 사용하여 **데이터를 읽고, 의심하고, 요약하고, 시각화하고, 해석하는 기본 절차**를 익히는 것이다.

3회차에서는 다음 산출물을 만들었다.

```text
scripts/generate_sample_data.py
data/raw/sales_sample.csv
config/analysis_config.yaml
src/
scripts/
reports/
artifacts/
```

4회차에서는 다음 산출물을 만든다.

```text
1. src/data/loading.py
2. src/data/quality.py
3. src/analysis/kpis.py
4. src/visualization/charts.py
5. scripts/run_eda.py
6. artifacts/metrics/data_quality_summary.csv
7. artifacts/metrics/eda_kpis.csv
8. artifacts/charts/*.png
9. reports/eda_summary.md
10. reports/eda_questions_selected.md
```

오늘의 핵심 문장은 다음이다.

> EDA는 예쁜 그래프를 만드는 활동이 아니라, 데이터에 대해 검증 가능한 질문을 던지고 근거를 정리하는 과정이다.

4회차가 끝나면 학습자는 `data/raw/sales_sample.csv`를 바탕으로 데이터 품질 문제를 식별하고, pandas로 기본 분석표를 만들고, matplotlib으로 기초 시각화를 생성하고, 보고서 초안을 작성할 수 있어야 한다.

---

## 오늘 끝나면 있어야 하는 것

4회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
ai-data-lab/
├── config/
│   └── analysis_config.yaml
├── data/
│   └── raw/
│       └── sales_sample.csv
├── src/
│   ├── data/
│   │   ├── loading.py
│   │   └── quality.py
│   ├── analysis/
│   │   └── kpis.py
│   └── visualization/
│       └── charts.py
├── scripts/
│   └── run_eda.py
├── artifacts/
│   ├── charts/
│   │   ├── revenue_by_region.png
│   │   ├── return_rate_by_channel.png
│   │   ├── revenue_share_by_category.png
│   │   ├── monthly_revenue_trend.png
│   │   └── revenue_distribution.png
│   └── metrics/
│       ├── missing_summary.csv
│       ├── outlier_summary.csv
│       ├── overall_kpis.csv
│       ├── channel_return_rate.csv
│       ├── region_revenue.csv
│       ├── category_revenue_share.csv
│       └── monthly_revenue.csv
└── reports/
    ├── eda_summary.md
    └── eda_questions_selected.md
```

> [!NOTE]
> 4회차에서는 노트북을 사용할 수 있지만, 모든 핵심 결과는 `scripts/run_eda.py`로 다시 만들 수 있어야 한다. 노트북은 탐색용이고, 재사용 가능한 로직은 `src/`에 둔다.

---

## 오늘 사용할 입력 위치를 구분하자

4회차에서는 입력 위치가 세 가지다.

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `uv run python scripts/run_eda.py` |
| `[AI 코딩 도구]` | Gemini CLI 또는 Claude Code 안 | `Create src/data/quality.py` |
| `[파일 내용]` | Python 또는 Markdown 파일 안에 들어갈 내용 | `def missing_summary(df):` |

앞으로 모든 실습에는 입력 위치를 표시한다.

예를 들어 아래 명령은 터미널에 입력한다.

```bash
uv run python scripts/run_eda.py
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create src/data/quality.py
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

3회차에서 만든 데이터분석 프로젝트 폴더로 이동한다. 이 자료에서는 폴더 이름을 `ai-data-lab`이라고 가정한다.

### Windows PowerShell

```powershell
cd $HOME
cd ai-data-lab
```

### Mac Terminal

```bash
cd ~
cd ai-data-lab
```

현재 위치를 확인한다.

```bash
pwd
```

정상이라면 대략 이런 결과가 나온다.

Windows 예시:

```text
C:\Users\내이름\ai-data-lab
```

Mac 예시:

```text
/Users/내이름/ai-data-lab
```

> [!IMPORTANT]
> 오늘 모든 명령은 프로젝트 폴더 안에서 실행한다. `pwd` 결과가 `ai-data-lab`이 아니면 먼저 프로젝트 폴더로 이동한다.

---

## 0.3 3회차 산출물이 있는지 확인한다

4회차는 3회차 산출물이 있어야 진행할 수 있다.

### Windows PowerShell

```powershell
dir data\raw
dir config
dir scripts
```

### Mac Terminal

```bash
ls data/raw
ls config
ls scripts
```

다음 파일이 있어야 한다.

```text
data/raw/sales_sample.csv
config/analysis_config.yaml
scripts/generate_sample_data.py
```

파일이 없다면 먼저 3회차 산출물을 보완해야 한다.

AI 코딩 도구에서 다음과 같이 확인할 수도 있다.

[AI 코딩 도구]

```text
Check whether the following files exist:

- data/raw/sales_sample.csv
- config/analysis_config.yaml
- scripts/generate_sample_data.py
- src/data/
- src/analysis/
- src/visualization/
- artifacts/
- reports/

If any file or folder is missing, tell me the exact fix.
Do not change this project into a web application.
```

---

## 0.4 Python 패키지를 확인한다

4회차에서는 pandas, pyyaml, matplotlib이 필요하다.

[터미널]

```bash
uv run python -c "import pandas as pd; import yaml; import matplotlib; print('EDA packages OK')"
```

오류가 나오면 다음을 실행한다.

[터미널]

```bash
uv add pandas numpy pyyaml matplotlib
```

---

# 1. EDA의 사고방식

## 1.1 EDA란 무엇인가

EDA는 Exploratory Data Analysis의 약자다. 한국어로는 탐색적 데이터분석이라고 부른다.

EDA의 목적은 다음이다.

```text
데이터가 어떻게 생겼는지 확인한다.
결측값, 중복, 이상값을 찾는다.
변수의 분포를 확인한다.
집단 간 차이를 요약한다.
시간에 따른 변화를 확인한다.
모델링 전에 위험한 가정을 줄인다.
```

EDA는 정답을 확정하는 과정이 아니다. EDA는 다음 분석을 더 잘하기 위해 데이터를 관찰하는 과정이다.

---

## 1.2 상관관계와 인과관계를 구분한다

EDA에서 매우 중요한 규칙이 있다.

```text
상관관계나 집단 차이를 인과관계처럼 말하지 않는다.
```

나쁜 표현:

```text
모바일 채널이 반품을 증가시킨다.
```

좋은 표현:

```text
이 데이터에서는 모바일 채널의 반품률이 다른 채널보다 높게 관찰된다.
다만 이는 인과관계를 의미하지 않는다.
```

4회차 보고서에서는 반드시 “관찰된 패턴”과 “원인 주장”을 구분한다.

---

## 1.3 오늘 사용할 데이터

오늘 사용할 데이터는 3회차에서 만든 합성 온라인 쇼핑몰 매출 데이터다.

```text
data/raw/sales_sample.csv
```

주요 변수는 다음과 같다.

| 변수 | 의미 |
|---|---|
| order_id | 주문 식별자 |
| customer_id | 고객 식별자 |
| order_date | 주문 날짜 |
| region | 지역 |
| channel | 판매 채널 |
| product_category | 상품 카테고리 |
| quantity | 수량 |
| unit_price | 단가 |
| discount_rate | 할인율 |
| revenue | 매출 |
| returned | 반품 여부. 1이면 반품, 0이면 미반품 |
| customer_age | 고객 연령 |

이 데이터에는 일부러 결측값, 중복 행, 이상값이 들어 있다.

---

# 2. 실습 1 — 데이터 첫 확인

## 2.1 데이터 파일 크기를 확인한다

[터미널]

```bash
uv run python -c "import pandas as pd; df = pd.read_csv('data/raw/sales_sample.csv'); print(df.shape); print(df.head())"
```

정상이라면 대략 다음처럼 출력된다.

```text
(6050, 12)
   order_id  customer_id  order_date  ... returned customer_age
0         1         1234  2025-...    ...        0         41.0
```

행 수가 5,000개 이상이면 정상이다.

---

## 2.2 데이터 첫인상 질문

처음 데이터를 볼 때는 다음 질문을 던진다.

```text
1. 행과 열은 몇 개인가?
2. 날짜 변수는 있는가?
3. 범주형 변수는 무엇인가?
4. 수치형 변수는 무엇인가?
5. target 변수는 무엇인가?
6. 결측값이 있을 것 같은 변수는 무엇인가?
7. 이상값이 있을 것 같은 변수는 무엇인가?
8. 이 데이터로 어떤 집단 비교를 할 수 있는가?
9. 이 데이터로 어떤 시간 추세를 볼 수 있는가?
10. 이 데이터로 인과관계를 주장할 수 있는가?
```

마지막 질문의 답은 보통 “아니다”이다. EDA는 원인을 확정하는 단계가 아니다.

---

# 3. 실습 2 — 4회차 EDA 질문 정하기

## 3.1 오늘 사용할 기본 EDA 질문 10개

오늘은 다음 10개 질문을 기준으로 EDA를 진행한다.

```text
1. 전체 데이터의 행 수, 열 수, 중복 행 수는 얼마인가?
2. 변수별 결측값 개수와 비율은 얼마인가?
3. 매출 revenue의 분포는 어떻게 생겼는가?
4. 지역별 평균 매출은 어떻게 다른가?
5. 채널별 반품률은 어떻게 다른가?
6. 상품 카테고리별 매출 비중은 어떻게 다른가?
7. 할인율 구간별 반품률은 어떻게 다른가?
8. 월별 총매출은 어떻게 변화하는가?
9. 고객 연령대별 평균 구매 금액은 어떻게 다른가?
10. 수량, 단가, 매출에서 이상값 후보는 무엇인가?
```

---

## 3.2 EDA 질문을 변수와 연결한다

좋은 EDA 질문은 필요한 변수를 명시해야 한다.

| 질문 | 필요한 변수 | 분석 방법 |
|---|---|---|
| 채널별 반품률은 어떻게 다른가? | channel, returned | channel별 returned 평균 |
| 지역별 평균 매출은 어떻게 다른가? | region, revenue | region별 revenue 평균 |
| 월별 총매출은 어떻게 변화하는가? | order_date, revenue | 월별 revenue 합계 |
| 상품 카테고리별 매출 비중은 어떻게 다른가? | product_category, revenue | 카테고리별 revenue 합계 비율 |
| 매출 이상값은 무엇인가? | revenue | IQR 기준 이상값 탐지 |

---

## 3.3 reports/eda_questions_selected.md 만들기

오늘 수업에서 집중할 질문 3개를 고른다.

### Windows PowerShell

[터미널]

```powershell
notepad reports\eda_questions_selected.md
```

### Mac Terminal

[터미널]

```bash
nano reports/eda_questions_selected.md
```

아래 양식을 붙여넣고 채운다.

[파일 내용: `reports/eda_questions_selected.md`]

```md
# Selected EDA Questions

## Question 1

질문:

필요 변수:

분석 방법:

주의할 해석:

## Question 2

질문:

필요 변수:

분석 방법:

주의할 해석:

## Question 3

질문:

필요 변수:

분석 방법:

주의할 해석:
```

---

# 4. 실습 3 — 재사용 가능한 코드 작성

## 4.1 왜 src/에 코드를 작성하는가

초보자는 노트북 하나에 모든 코드를 넣기 쉽다. 그러나 노트북 하나에 모든 코드가 들어가면 다음 문제가 생긴다.

```text
코드를 재사용하기 어렵다.
테스트하기 어렵다.
어떤 코드가 탐색용이고 어떤 코드가 실제 로직인지 구분하기 어렵다.
같은 계산을 여러 번 복사하게 된다.
```

따라서 4회차에서는 다음 원칙을 따른다.

```text
src/data/         데이터 로딩과 품질검사
src/analysis/     KPI와 분석표 계산
src/visualization/ 그래프 생성
scripts/          전체 실행 진입점
reports/          해석과 보고서
artifacts/        생성된 표, 지표, 그래프
```

---

## 4.2 AI에게 코드 생성을 요청한다

[AI 코딩 도구]

```text
Create reusable EDA modules for this Python-first AI/Data Lab.

Use these files:

- src/data/loading.py
- src/data/quality.py
- src/analysis/kpis.py
- src/visualization/charts.py
- scripts/run_eda.py

Requirements:

- Read config/analysis_config.yaml
- Load data/raw/sales_sample.csv
- Compute missing value summary
- Compute duplicate row count
- Compute numeric outlier summary using the IQR rule
- Compute overall KPIs
- Compute region revenue summary
- Compute channel return rate
- Compute category revenue share
- Compute monthly revenue trend
- Save metric tables to artifacts/metrics/
- Save charts to artifacts/charts/
- Write reports/eda_summary.md
- Use matplotlib only, not seaborn
- Do not modify data/raw/sales_sample.csv
- Do not make causal claims in the report
```

AI가 파일을 만들면 6장으로 넘어간다. AI가 파일을 만들지 못하면 아래 코드를 직접 붙여넣는다.

---

# 5. 직접 붙여넣을 코드

## 5.1 src/data/loading.py

### Windows PowerShell

[터미널]

```powershell
notepad src\data\loading.py
```

### Mac Terminal

[터미널]

```bash
nano src/data/loading.py
```

[파일 내용: `src/data/loading.py`]

```python
"""Data loading utilities for the AI/Data Lab."""

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

## 5.2 src/data/quality.py

[파일 내용: `src/data/quality.py`]

```python
"""Data quality checks for tabular datasets."""

from __future__ import annotations

import pandas as pd


def missing_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Return missing value counts and percentages by column."""
    total_rows = len(df)
    summary = pd.DataFrame(
        {
            "column": df.columns,
            "missing_count": [df[col].isna().sum() for col in df.columns],
            "missing_pct": [df[col].isna().mean() for col in df.columns],
            "dtype": [str(df[col].dtype) for col in df.columns],
        }
    )
    if total_rows == 0:
        summary["missing_pct"] = 0.0
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
            "duplicate_pct": [duplicate_pct],
        }
    )


def numeric_outlier_summary(df: pd.DataFrame, columns: list[str]) -> pd.DataFrame:
    """Detect outlier candidates using the IQR rule for selected numeric columns."""
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

        q1 = series.quantile(0.25)
        q3 = series.quantile(0.75)
        iqr = q3 - q1
        lower_bound = q1 - 1.5 * iqr
        upper_bound = q3 + 1.5 * iqr
        outlier_mask = (series < lower_bound) | (series > upper_bound)
        outlier_count = int(outlier_mask.sum())
        rows.append(
            {
                "column": col,
                "q1": float(q1),
                "q3": float(q3),
                "iqr": float(iqr),
                "lower_bound": float(lower_bound),
                "upper_bound": float(upper_bound),
                "outlier_count": outlier_count,
                "outlier_pct": outlier_count / len(series) if len(series) else 0.0,
            }
        )

    return pd.DataFrame(rows)
```

---

## 5.3 src/analysis/kpis.py

[파일 내용: `src/analysis/kpis.py`]

```python
"""KPI and EDA table calculations."""

from __future__ import annotations

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
                "return_rate",
            ],
            "value": [
                len(df),
                df["order_id"].nunique() if "order_id" in df else pd.NA,
                df["customer_id"].nunique() if "customer_id" in df else pd.NA,
                df["revenue"].sum() if "revenue" in df else pd.NA,
                df["revenue"].mean() if "revenue" in df else pd.NA,
                df["returned"].mean() if "returned" in df else pd.NA,
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
    total = summary["total_revenue"].sum()
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


def discount_return_rate(df: pd.DataFrame) -> pd.DataFrame:
    """Compute return rate by discount-rate band."""
    data = df.copy()
    bins = [-0.001, 0.0, 0.10, 0.20, 1.0]
    labels = ["0%", "1-10%", "11-20%", "21%+"]
    data["discount_band"] = pd.cut(data["discount_rate"], bins=bins, labels=labels)
    return (
        data.groupby("discount_band", dropna=False, observed=False)
        .agg(order_count=("order_id", "count"), return_rate=("returned", "mean"))
        .reset_index()
    )
```

---

## 5.4 src/visualization/charts.py

[파일 내용: `src/visualization/charts.py`]

```python
"""Matplotlib chart utilities for EDA outputs."""

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
```

---

## 5.5 scripts/run_eda.py

[파일 내용: `scripts/run_eda.py`]

```python
"""Run reproducible EDA for the synthetic sales dataset."""

from __future__ import annotations

from pathlib import Path
import sys

# Allow running this script from the project root without installing the package.
PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))

from src.analysis.kpis import (  # noqa: E402
    category_revenue_share,
    channel_return_rate,
    discount_return_rate,
    monthly_revenue,
    overall_kpis,
    region_revenue_summary,
)
from src.data.loading import load_config, load_raw_data  # noqa: E402
from src.data.quality import duplicate_summary, missing_summary, numeric_outlier_summary  # noqa: E402
from src.visualization.charts import save_bar_chart, save_histogram, save_line_chart  # noqa: E402


def write_markdown_report(
    output_path: Path,
    row_count: int,
    column_count: int,
    duplicate_count: int,
    top_missing_column: str,
    highest_return_channel: str,
    highest_revenue_region: str,
) -> None:
    """Write a short EDA summary report."""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        f"""# EDA Summary

## 1. Dataset Overview

- Row count: {row_count}
- Column count: {column_count}
- Duplicate rows: {duplicate_count}

## 2. Data Quality Observations

- The column with the largest number of missing values is `{top_missing_column}`.
- Duplicate rows are present and should be reviewed before modeling.
- Numeric outlier candidates were checked using the IQR rule.

## 3. Key EDA Observations

- The channel with the highest observed return rate is `{highest_return_channel}`.
- The region with the highest observed average revenue is `{highest_revenue_region}`.

## 4. Interpretation Caution

These observations describe patterns in the dataset. They do not prove causal relationships.
For example, a higher return rate in one channel does not necessarily mean that the channel causes returns.

## 5. Generated Outputs

Metric tables were saved to `artifacts/metrics/`.
Charts were saved to `artifacts/charts/`.
""",
        encoding="utf-8",
    )


def main() -> None:
    """Run all EDA steps and save outputs."""
    config = load_config()
    df = load_raw_data(config)

    charts_dir = Path(config["paths"]["charts_dir"])
    metrics_dir = Path(config["paths"]["metrics_dir"])
    reports_dir = Path(config["paths"]["reports_dir"])
    charts_dir.mkdir(parents=True, exist_ok=True)
    metrics_dir.mkdir(parents=True, exist_ok=True)
    reports_dir.mkdir(parents=True, exist_ok=True)

    missing = missing_summary(df)
    duplicates = duplicate_summary(df)
    outliers = numeric_outlier_summary(df, config["eda"]["outlier_check_columns"])

    overall = overall_kpis(df)
    region_revenue = region_revenue_summary(df)
    channel_returns = channel_return_rate(df)
    category_share = category_revenue_share(df)
    monthly = monthly_revenue(df)
    discount_returns = discount_return_rate(df)

    missing.to_csv(metrics_dir / "missing_summary.csv", index=False)
    duplicates.to_csv(metrics_dir / "duplicate_summary.csv", index=False)
    outliers.to_csv(metrics_dir / "outlier_summary.csv", index=False)
    overall.to_csv(metrics_dir / "overall_kpis.csv", index=False)
    region_revenue.to_csv(metrics_dir / "region_revenue.csv", index=False)
    channel_returns.to_csv(metrics_dir / "channel_return_rate.csv", index=False)
    category_share.to_csv(metrics_dir / "category_revenue_share.csv", index=False)
    monthly.to_csv(metrics_dir / "monthly_revenue.csv", index=False)
    discount_returns.to_csv(metrics_dir / "discount_return_rate.csv", index=False)

    save_bar_chart(
        region_revenue,
        x="region",
        y="average_revenue",
        title="Average Revenue by Region",
        output_path=charts_dir / "revenue_by_region.png",
        rotation=30,
    )
    save_bar_chart(
        channel_returns,
        x="channel",
        y="return_rate",
        title="Return Rate by Channel",
        output_path=charts_dir / "return_rate_by_channel.png",
    )
    save_bar_chart(
        category_share,
        x="product_category",
        y="revenue_share",
        title="Revenue Share by Product Category",
        output_path=charts_dir / "revenue_share_by_category.png",
        rotation=30,
    )
    save_line_chart(
        monthly,
        x="order_month",
        y="total_revenue",
        title="Monthly Revenue Trend",
        output_path=charts_dir / "monthly_revenue_trend.png",
    )
    save_histogram(
        df,
        column="revenue",
        title="Revenue Distribution",
        output_path=charts_dir / "revenue_distribution.png",
    )

    top_missing_column = str(missing.iloc[0]["column"])
    duplicate_count = int(duplicates.iloc[0]["duplicate_count"])
    highest_return_channel = str(channel_returns.iloc[0]["channel"])
    highest_revenue_region = str(region_revenue.iloc[0]["region"])

    write_markdown_report(
        output_path=reports_dir / "eda_summary.md",
        row_count=len(df),
        column_count=df.shape[1],
        duplicate_count=duplicate_count,
        top_missing_column=top_missing_column,
        highest_return_channel=highest_return_channel,
        highest_revenue_region=highest_revenue_region,
    )

    print("EDA completed.")
    print(f"Rows and columns: {df.shape}")
    print(f"Metric tables saved to: {metrics_dir}")
    print(f"Charts saved to: {charts_dir}")
    print(f"Report saved to: {reports_dir / 'eda_summary.md'}")


if __name__ == "__main__":
    main()
```

---

# 6. 실습 4 — EDA 실행하기

## 6.1 전체 EDA 스크립트를 실행한다

[터미널]

```bash
uv run python scripts/run_eda.py
```

정상이라면 다음과 비슷한 결과가 나온다.

```text
EDA completed.
Rows and columns: (6050, 12)
Metric tables saved to: artifacts/metrics
Charts saved to: artifacts/charts
Report saved to: reports/eda_summary.md
```

---

## 6.2 생성된 metric 파일 확인

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

다음 파일들이 보여야 한다.

```text
missing_summary.csv
duplicate_summary.csv
outlier_summary.csv
overall_kpis.csv
region_revenue.csv
channel_return_rate.csv
category_revenue_share.csv
monthly_revenue.csv
discount_return_rate.csv
```

---

## 6.3 생성된 chart 파일 확인

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

다음 파일들이 보여야 한다.

```text
revenue_by_region.png
return_rate_by_channel.png
revenue_share_by_category.png
monthly_revenue_trend.png
revenue_distribution.png
```

---

## 6.4 보고서 확인

[터미널]

```bash
cat reports/eda_summary.md
```

Windows PowerShell에서는 다음을 사용할 수 있다.

[터미널]

```powershell
Get-Content reports\eda_summary.md
```

보고서에는 데이터 크기, 결측값, 중복, 주요 관찰, 인과관계 주의 문장이 포함되어 있어야 한다.

---

# 7. 실습 5 — 결과를 해석하는 방법

## 7.1 좋은 해석과 나쁜 해석

나쁜 해석:

```text
모바일 채널 때문에 반품이 많다.
```

이 문장은 원인을 주장하고 있으므로 EDA 단계에서는 부적절하다.

좋은 해석:

```text
이 데이터에서는 모바일 채널의 반품률이 다른 채널보다 높게 관찰된다.
다만 채널이 반품의 원인이라고 단정할 수는 없다.
추가 분석을 위해 상품 카테고리, 할인율, 고객 연령대와 함께 비교할 필요가 있다.
```

---

## 7.2 EDA 보고서 문장 공식

초보자는 다음 형식을 사용하면 안전하다.

```text
이 데이터에서는 [집단 A]와 [집단 B] 사이에 [지표] 차이가 관찰된다.
이 차이는 [가능한 설명]과 관련될 수 있으나, 현재 분석만으로 인과관계를 판단할 수는 없다.
추가 확인을 위해 [추가 분석]이 필요하다.
```

예시:

```text
이 데이터에서는 할인율이 높은 주문의 반품률이 상대적으로 높게 관찰된다.
이 차이는 할인 상품의 특성, 상품 카테고리 구성, 구매 채널과 관련될 수 있으나,
현재 분석만으로 할인율이 반품을 유발한다고 판단할 수는 없다.
추가 확인을 위해 상품 카테고리별 할인율과 반품률을 함께 비교할 필요가 있다.
```

---

# 8. 실습 6 — ChatGPT Projects에서 보고서 문장 다듬기

## 8.1 ChatGPT Projects의 역할

ChatGPT Projects는 repo 파일을 직접 수정하는 공간이 아니다. 이 수업에서는 분석 해석과 보고서 문장 검토를 돕는 보조 공간이다.

여기서 할 수 있는 일:

```text
EDA 결과 해석
보고서 문장 다듬기
상관관계와 인과관계 구분
추가 분석 질문 제안
한계와 가정 정리
```

여기서 하지 않는 일:

```text
repo 파일 직접 수정
data/raw/ 수정
실제 모델 성능 주장
근거 없는 원인 주장
```

---

## 8.2 ChatGPT Projects에 넣을 프롬프트

`artifacts/metrics/channel_return_rate.csv`와 `reports/eda_summary.md`의 내용을 복사해서 ChatGPT Projects에 붙여넣고 다음을 입력한다.

```text
다음 EDA 결과를 보고 보고서 문장을 다듬어 주세요.

규칙:
- 상관관계를 인과관계처럼 표현하지 마세요.
- 관찰된 패턴과 가능한 해석을 분리해 주세요.
- 데이터 품질 한계를 명시해 주세요.
- 비전공자도 이해할 수 있는 학술문어체로 작성해 주세요.
- 과도한 단정 표현을 피하세요.

[여기에 EDA 결과 붙여넣기]
```

---

# 9. 선택 실습 — 노트북 만들기

## 9.1 노트북의 역할

노트북은 탐색과 수업용이다. 노트북에서 발견한 반복 가능한 로직은 `src/`로 옮겨야 한다.

노트북의 좋은 사용 방식:

```text
데이터를 눈으로 확인한다.
그래프를 빠르게 실험한다.
EDA 질문을 검토한다.
src/에 있는 함수를 불러와 사용한다.
```

나쁜 사용 방식:

```text
모든 분석 로직을 노트북에만 둔다.
스크립트로 재현할 수 없는 수작업을 한다.
노트북에서 data/raw/를 수정한다.
```

---

## 9.2 Jupyter가 필요한 경우

Jupyter가 설치되어 있지 않다면 다음을 실행한다.

[터미널]

```bash
uv add notebook ipykernel
```

노트북을 실행한다.

[터미널]

```bash
uv run jupyter notebook
```

`notebooks/04_eda_sales_sample.ipynb`를 만들고 다음 순서로 작성한다.

```text
1. 목적: 4회차 EDA
2. config 로딩
3. 데이터 로딩
4. 결측값 확인
5. 중복 확인
6. 기초 통계량 확인
7. EDA 질문 3개 분석
8. 그래프 확인
9. 해석과 한계
```

---

# 10. 오늘의 최종 품질 게이트

4회차가 끝나기 전에 다음을 모두 확인한다.

## 10.1 코드 게이트

```text
[ ] src/data/loading.py가 있다.
[ ] src/data/quality.py가 있다.
[ ] src/analysis/kpis.py가 있다.
[ ] src/visualization/charts.py가 있다.
[ ] scripts/run_eda.py가 있다.
[ ] uv run python scripts/run_eda.py가 실행된다.
```

## 10.2 데이터 품질 게이트

```text
[ ] missing_summary.csv가 생성되었다.
[ ] duplicate_summary.csv가 생성되었다.
[ ] outlier_summary.csv가 생성되었다.
[ ] 결측값, 중복, 이상값 후보를 설명할 수 있다.
```

## 10.3 EDA 산출물 게이트

```text
[ ] overall_kpis.csv가 생성되었다.
[ ] region_revenue.csv가 생성되었다.
[ ] channel_return_rate.csv가 생성되었다.
[ ] category_revenue_share.csv가 생성되었다.
[ ] monthly_revenue.csv가 생성되었다.
[ ] artifacts/charts/에 5개 이상의 그래프가 있다.
```

## 10.4 해석 게이트

```text
[ ] reports/eda_summary.md가 있다.
[ ] 해석 문장에서 인과관계를 단정하지 않았다.
[ ] 데이터 품질 문제를 언급했다.
[ ] 추가 분석이 필요한 지점을 적었다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Check the current project against the Session 4 data analysis quality gates:

1. src/data/loading.py exists
2. src/data/quality.py exists
3. src/analysis/kpis.py exists
4. src/visualization/charts.py exists
5. scripts/run_eda.py exists
6. scripts/run_eda.py runs successfully
7. artifacts/metrics contains missing, duplicate, outlier, and EDA KPI tables
8. artifacts/charts contains at least five charts
9. reports/eda_summary.md exists
10. the report avoids causal claims

Return PASS, CONCERNS, or FAIL.
For any concern, tell me the exact fix.
```

---

# 11. GitHub에 커밋하기

## 11.1 현재 변경 사항 확인

[터미널]

```bash
git status
```

---

## 11.2 파일 추가와 커밋

[터미널]

```bash
git add .
git commit -m "Add session 4 EDA pipeline and summary report"
```

커밋이 성공하면 4회차 작업이 저장된 것이다.

> [!IMPORTANT]
> 실제 개인정보나 민감정보가 있는 데이터는 커밋하지 않는다. 오늘 사용한 `sales_sample.csv`는 3회차에서 만든 합성 데이터이므로 수업용으로 사용할 수 있다.

---

# 12. 과제 안내

## 과제 1. EDA 질문 3개에 대한 짧은 해석 작성

`reports/eda_questions_selected.md`에 고른 질문 3개에 대해 다음 양식으로 해석을 추가한다.

```md
## 해석 1

질문:

관찰된 결과:

가능한 해석:

인과관계 주의:

추가로 확인할 분석:
```

---

## 과제 2. 그래프 1개를 선택해 설명하기

`artifacts/charts/`에서 그래프 하나를 선택한다. 다음 질문에 답한다.

```text
1. 이 그래프는 어떤 질문에 답하는가?
2. x축과 y축은 무엇인가?
3. 가장 눈에 띄는 패턴은 무엇인가?
4. 데이터 품질 문제 때문에 주의해야 할 점은 무엇인가?
5. 이 그래프만으로 원인을 말할 수 있는가?
```

---

## 과제 3. 다음 회차 모델링 준비 질문 작성

5회차에서는 baseline 모델링을 준비한다. 다음 질문에 답한다.

```text
1. target 변수는 무엇인가?
2. 이 문제는 분류 문제인가, 회귀 문제인가?
3. 모델 입력으로 사용할 수 있는 변수는 무엇인가?
4. 모델 입력에서 제외해야 할 변수는 무엇인가?
5. 결측값은 어떻게 처리해야 하는가?
6. 범주형 변수는 어떻게 처리해야 하는가?
7. 모델 성능은 어떤 지표로 평가할 것인가?
```

예시:

```text
target은 returned이다. returned는 0 또는 1이므로 분류 문제다.
평가 지표는 F1-score, precision, recall을 함께 확인할 수 있다.
다만 현재 EDA 단계에서는 모델 성능을 주장하지 않는다.
```

---

# 13. 자주 생기는 문제와 해결법

## 13.1 `uv run python scripts/run_eda.py`가 실패한다

먼저 현재 폴더를 확인한다.

[터미널]

```bash
pwd
```

프로젝트 폴더가 아니면 이동한다.

[터미널]

```bash
cd ~/ai-data-lab
```

패키지를 확인한다.

[터미널]

```bash
uv run python -c "import pandas; import yaml; import matplotlib; print('ok')"
```

오류가 나오면 설치한다.

[터미널]

```bash
uv add pandas numpy pyyaml matplotlib
```

---

## 13.2 `sales_sample.csv`가 없다고 나온다

3회차 합성 데이터 생성 스크립트를 다시 실행한다.

[터미널]

```bash
uv run python scripts/generate_sample_data.py
```

그다음 확인한다.

[터미널]

```bash
ls data/raw
```

Windows PowerShell에서는 다음을 사용할 수 있다.

[터미널]

```powershell
dir data\raw
```

---

## 13.3 `config/analysis_config.yaml`을 읽을 때 오류가 난다

YAML은 들여쓰기가 중요하다. 탭 대신 공백 2칸을 사용한다.

pyyaml이 설치되어 있는지 확인한다.

[터미널]

```bash
uv run python -c "import yaml; print('yaml ok')"
```

오류가 나오면 설치한다.

[터미널]

```bash
uv add pyyaml
```

---

## 13.4 그래프 한글이 깨진다

현재 그래프 제목과 축 이름은 영어로 작성되어 있으므로 한글 폰트 문제를 피할 수 있다. 한글 그래프를 사용하려면 운영체제별 폰트 설정이 필요하다. 초보자 수업에서는 우선 영어 제목을 사용한다.

---

## 13.5 AI가 data/raw를 수정하려고 한다

원본 데이터는 수정하지 않는다. 즉시 멈추고 다음을 입력한다.

[AI 코딩 도구]

```text
Stop. Do not modify data/raw/sales_sample.csv.
Read _bmad-output/project-context.md again.
All cleaning or derived outputs must go to data/interim, data/processed, artifacts, or reports.
```

---

## 13.6 AI가 인과관계를 단정하는 보고서를 쓴다

다음 프롬프트로 수정한다.

[AI 코딩 도구]

```text
Revise reports/eda_summary.md.
Do not express correlation or group differences as causation.
Use cautious language such as:
- observed pattern
- may be related to
- requires further analysis
- does not prove causality
```

---

# 14. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> EDA는 데이터를 신뢰하기 전에 의심하고, 질문을 계산 가능한 형태로 바꾸며, 관찰된 패턴을 근거와 한계와 함께 설명하는 과정이다.

4회차의 흐름은 다음과 같다.

```text
데이터 확인
→ EDA 질문 선정
→ 결측값·중복·이상값 검사
→ KPI 표 생성
→ 그래프 생성
→ 보고서 작성
→ 인과관계 단정 방지
```

5회차부터는 오늘 만든 품질검사 결과와 EDA 산출물을 바탕으로 baseline 모델링을 준비한다.

---

# 15. 4회차 최종 체크리스트

수업이 끝나기 전에 스스로 확인한다.

```text
[ ] data/raw/sales_sample.csv가 존재한다.
[ ] config/analysis_config.yaml이 존재한다.
[ ] EDA 질문 10개의 의미를 이해한다.
[ ] 선택한 EDA 질문 3개를 reports/eda_questions_selected.md에 적었다.
[ ] src/data/loading.py를 만들었다.
[ ] src/data/quality.py를 만들었다.
[ ] src/analysis/kpis.py를 만들었다.
[ ] src/visualization/charts.py를 만들었다.
[ ] scripts/run_eda.py를 만들었다.
[ ] uv run python scripts/run_eda.py가 성공적으로 실행되었다.
[ ] artifacts/metrics/에 분석표가 생성되었다.
[ ] artifacts/charts/에 그래프가 생성되었다.
[ ] reports/eda_summary.md가 생성되었다.
[ ] 상관관계와 인과관계의 차이를 설명할 수 있다.
[ ] data/raw/를 수정하지 않는 이유를 설명할 수 있다.
```

---

## 부록 A. 오늘 사용하는 핵심 명령 모음

### 터미널 명령

```bash
pwd
ls data/raw
ls config
uv run python -c "import pandas as pd; df = pd.read_csv('data/raw/sales_sample.csv'); print(df.shape); print(df.head())"
uv run python scripts/run_eda.py
ls artifacts/metrics
ls artifacts/charts
cat reports/eda_summary.md
git status
git add .
git commit -m "Add session 4 EDA pipeline and summary report"
```

### AI 코딩 도구 명령

```text
Create reusable EDA modules for this Python-first AI/Data Lab.
Check the current project against the Session 4 data analysis quality gates.
Revise reports/eda_summary.md to avoid causal claims.
```

---

## 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| EDA | 탐색적 데이터분석. 데이터의 구조와 패턴을 탐색하는 과정 |
| missing value | 결측값. 값이 비어 있는 데이터 |
| duplicate row | 중복 행. 동일한 내용이 반복된 행 |
| outlier | 이상값. 일반적 범위에서 크게 벗어난 값 |
| KPI | 핵심 지표. 분석에서 중요하게 보는 요약값 |
| return rate | 반품률. returned의 평균으로 계산 가능 |
| distribution | 분포. 값들이 어떤 범위와 빈도로 나타나는지 보여주는 형태 |
| IQR | 사분위 범위. Q3 - Q1로 계산하며 이상값 탐지에 사용 가능 |
| correlation | 상관관계. 두 변수가 함께 변하는 경향 |
| causation | 인과관계. 한 변수가 다른 변수의 원인이라는 관계 |
| reproducibility | 재현성. 같은 명령으로 같은 결과를 다시 만들 수 있는 성질 |
| source of truth | 여러 문서가 충돌할 때 기준이 되는 문서. 이 수업에서는 project-context.md와 config 파일 |
