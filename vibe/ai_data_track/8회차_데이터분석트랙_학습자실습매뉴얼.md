# 8회차 학습자 실습 매뉴얼: 데이터분석 트랙

# BMAD 리뷰와 최종 프로젝트 발표
## 산출물 재현 → 모델 비교 → 문서 정합성 검토 → 최종 보고서 → 발표 자료 → 개선 로드맵

---

## 이 자료의 목적

8회차의 목표는 새로운 모델을 하나 더 만드는 것이 아니다. 8회차의 목표는 1회차부터 7회차까지 만든 데이터분석 프로젝트를 **재현 가능하고 설명 가능한 최종 프로젝트**로 정리하는 것이다.

7회차까지 다음 산출물을 만들었다.

```text
1. BMAD 문서: project-context.md, product-brief.md, PRD.md, architecture.md, epics/stories
2. 데이터분석 repo 구조
3. 합성 데이터: data/raw/sales_sample.csv
4. EDA와 데이터 품질검사 결과
5. 재현 가능한 분석 파이프라인
6. scikit-learn baseline 모델
7. PyTorch 딥러닝 모델
8. 모델 평가 지표와 차트
9. 분석 보고서와 딥러닝 보고서
```

8회차에서는 이 산출물을 바탕으로 다음을 만든다.

```text
1. reports/reproducibility_audit.md
2. reports/model_comparison.md
3. reports/final_project_report.md
4. reports/limitations_and_risks.md
5. reports/roadmap.md
6. artifacts/metrics/final_scorecard.json
7. presentation/final_presentation.md
8. presentation/presenter_script.md
9. README.md 최종 보완
10. 최종 GitHub 제출 상태
```

오늘의 핵심 문장은 다음이다.

> 좋은 데이터분석 프로젝트는 높은 점수 하나가 아니라, 문제 정의·데이터·분석·모델·한계·재현성이 함께 설명되는 프로젝트이다.

8회차가 끝나면 학습자는 다음 질문에 답할 수 있어야 한다.

```text
이 프로젝트는 어떤 문제를 다루는가?
데이터는 어디서 만들어졌고 어떤 한계가 있는가?
EDA에서 무엇을 발견했는가?
scikit-learn baseline과 PyTorch 모델 중 무엇이 더 나은가?
그 성능 차이는 어떻게 해석해야 하는가?
전체 결과를 다시 만들 수 있는가?
상관관계를 인과관계처럼 말하지 않았는가?
이 프로젝트를 다음 단계로 발전시키려면 무엇을 해야 하는가?
```

> [!IMPORTANT]
> 이 자료는 초보 학습자가 그대로 따라 할 수 있도록 작성되어 있다. 그러나 내부 기준은 전문 데이터분석 프로젝트의 평가 기준을 따른다. 즉, 단순 발표가 아니라 **문서 정합성, 재현성, 모델 비교, 오류 가능성, 한계, 윤리적 해석, 개선 로드맵**을 모두 다룬다.

---

## 오늘 끝나면 있어야 하는 것

8회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
ai-data-lab/
├── _bmad-output/
│   ├── project-context.md
│   ├── product-brief.md
│   ├── PRD.md
│   ├── architecture.md
│   └── epics-and-stories.md
├── artifacts/
│   ├── charts/
│   │   ├── *.png
│   │   ├── pytorch_loss_curve.png
│   │   └── pytorch_confusion_matrix.png
│   ├── metrics/
│   │   ├── dummy_metrics.json
│   │   ├── baseline_metrics.json
│   │   ├── pytorch_metrics.json
│   │   └── final_scorecard.json
│   └── models/
│       ├── baseline_logistic_regression.joblib
│       └── pytorch_mlp.pt
├── reports/
│   ├── data_quality.md
│   ├── eda_summary.md
│   ├── analysis_summary.md
│   ├── model_baseline_report.md
│   ├── deep_learning_report.md
│   ├── reproducibility_audit.md
│   ├── model_comparison.md
│   ├── final_project_report.md
│   ├── limitations_and_risks.md
│   └── roadmap.md
├── presentation/
│   ├── final_presentation.md
│   └── presenter_script.md
├── scripts/
│   ├── run_pipeline.py
│   ├── train_baseline.py
│   ├── train_deep_learning.py
│   └── run_final_audit.py
├── README.md
└── pyproject.toml
```

> [!NOTE]
> 파일 이름은 이전 회차에서 사용한 이름과 약간 다를 수 있다. 중요한 것은 “재현성 검토, 모델 비교, 최종 보고서, 발표 자료, 개선 로드맵”이 모두 존재하는가이다.

---

## 오늘 사용할 입력 위치를 구분하자

8회차에서는 입력 위치가 세 가지다.

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `uv run python scripts/run_final_audit.py` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `Create final project report` |
| `[파일 내용]` | Markdown, Python, JSON 파일 안에 들어갈 내용 | `# Final Project Report` |

아래 명령은 터미널에 입력한다.

```bash
uv run python scripts/run_pipeline.py
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
Create a final project report based on the generated artifacts.
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

정상이라면 다음과 비슷한 결과가 나온다.

```text
C:\Users\내이름\ai-data-lab
```

또는:

```text
/Users/내이름/ai-data-lab
```

> [!IMPORTANT]
> 오늘 모든 명령은 프로젝트 폴더 안에서 실행한다. `pwd` 결과가 프로젝트 폴더가 아니면 먼저 이동한다.

---

## 0.3 7회차 산출물을 확인한다

8회차는 7회차까지의 산출물을 종합하는 수업이다. 먼저 다음 명령을 실행한다.

[터미널]

```bash
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run python scripts/train_deep_learning.py
```

정상이라면 다음 파일들이 있어야 한다.

```text
data/processed/sales_clean.csv
artifacts/metrics/dummy_metrics.json
artifacts/metrics/baseline_metrics.json
artifacts/metrics/pytorch_metrics.json
reports/analysis_summary.md
reports/model_baseline_report.md
reports/deep_learning_report.md
```

파일 존재 여부를 확인한다.

### Windows PowerShell

[터미널]

```powershell
dir artifacts\metrics
dir reports
```

### Mac Terminal

[터미널]

```bash
ls artifacts/metrics
ls reports
```

만약 오류가 나면 8회차를 진행하기 전에 5~7회차 산출물을 먼저 보완한다.

AI 코딩 도구에 다음을 입력해 점검할 수 있다.

[AI 코딩 도구 - English prompt]

```text
Review the current project as the starting point for Session 8.

Check whether the following outputs exist:

1. cleaned data,
2. EDA report,
3. analysis pipeline,
4. baseline model metrics,
5. dummy model metrics,
6. PyTorch model metrics,
7. baseline model report,
8. deep learning report,
9. charts and artifacts,
10. README.

Return PASS, CONCERNS, or FAIL.
For each missing or weak item, give the exact command or file to fix.
Do not invent results that are not present.
```

[한국어 번역]

```text
현재 프로젝트를 8회차 시작 상태로 검토해 주세요.

다음 산출물이 있는지 확인해 주세요.

1. 정제 데이터
2. EDA 보고서
3. 분석 파이프라인
4. baseline 모델 지표
5. dummy 모델 지표
6. PyTorch 모델 지표
7. baseline 모델 보고서
8. 딥러닝 보고서
9. 차트와 artifacts
10. README

PASS, CONCERNS, FAIL 중 하나로 판정해 주세요.
누락되었거나 약한 항목이 있으면 정확한 수정 명령 또는 파일을 알려 주세요.
존재하지 않는 결과를 임의로 만들어내지 마세요.
```

---

# 1. 최종 프로젝트 리뷰의 큰 그림

## 1.1 최종 리뷰는 무엇을 보는가

최종 리뷰는 “모델 점수가 높은가”만 보는 것이 아니다. 다음 전체를 본다.

```text
문제 정의가 명확한가?
데이터 구조와 한계가 설명되어 있는가?
EDA가 질문에 답하고 있는가?
파이프라인을 다시 실행할 수 있는가?
모델 성능을 baseline과 비교했는가?
PyTorch 모델을 과장하지 않고 해석했는가?
결과의 한계와 위험을 적었는가?
다음 개선 방향이 현실적인가?
```

---

## 1.2 BMAD 관점의 최종 평가 기준

BMAD 기반 프로젝트에서는 문서와 구현의 정합성이 중요하다.

| BMAD 문서 | 최종 리뷰 질문 |
|---|---|
| project-context.md | 프로젝트 원칙을 실제 repo가 따르고 있는가? |
| product-brief.md | 무엇을 왜 만드는지 최종 보고서에 드러나는가? |
| PRD.md | 요구사항이 구현되었거나 합리적으로 제외되었는가? |
| architecture.md | 실제 폴더 구조와 코드가 architecture를 따르는가? |
| epics/stories | Story의 수용 기준이 완료되었는가? |

---

## 1.3 전문적인 최종 프로젝트의 조건

좋은 최종 프로젝트는 다음 특징을 가진다.

```text
1. 실행 명령이 명확하다.
2. 데이터 출처와 한계를 설명한다.
3. 분석 질문과 결과가 연결된다.
4. 모델 지표가 baseline과 비교된다.
5. 재현성 검증 결과가 있다.
6. 해석에서 과장을 피한다.
7. 실패와 한계를 숨기지 않는다.
8. 다음 개선 방향이 구체적이다.
```

---

# 2. 실습 1 — 최종 재현성 검증

## 2.1 재현성이란 무엇인가

재현성이란 같은 명령을 다시 실행했을 때 같은 종류의 결과를 다시 만들 수 있다는 뜻이다.

나쁜 프로젝트:

```text
노트북에서 이것저것 실행해서 결과는 나왔지만, 어떤 순서로 했는지 모른다.
```

좋은 프로젝트:

```text
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run python scripts/train_deep_learning.py
```

위 명령으로 주요 결과를 다시 만들 수 있다.

---

## 2.2 전체 재실행

[터미널]

```bash
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run python scripts/train_deep_learning.py
```

정상이라면 다음 산출물이 갱신된다.

```text
data/processed/sales_clean.csv
reports/data_quality.md
reports/analysis_summary.md
artifacts/charts/*.png
artifacts/metrics/baseline_metrics.json
artifacts/metrics/pytorch_metrics.json
reports/model_baseline_report.md
reports/deep_learning_report.md
```

---

## 2.3 재현성 검토 문서 만들기

[AI 코딩 도구 - English prompt]

```text
Create reports/reproducibility_audit.md.

The document must include:

1. commands used to reproduce the project,
2. expected outputs,
3. actual outputs found in the repo,
4. missing outputs if any,
5. random seed policy,
6. config file policy,
7. raw data policy,
8. environment and dependency notes,
9. reproducibility verdict: PASS, CONCERNS, or FAIL.

Do not claim that something is reproducible unless the command and output exist.
```

[한국어 번역]

```text
reports/reproducibility_audit.md 파일을 만들어 주세요.

문서에는 다음 항목을 포함해 주세요.

1. 프로젝트를 재현하는 데 사용한 명령
2. 기대 산출물
3. repo에서 실제로 발견된 산출물
4. 누락된 산출물
5. random seed 정책
6. config 파일 정책
7. 원본 데이터 정책
8. 환경과 의존성 관련 메모
9. 재현성 판정: PASS, CONCERNS, FAIL

명령과 산출물이 실제로 존재하지 않는 경우 재현 가능하다고 주장하지 마세요.
```

---

## 2.4 직접 작성할 때 사용할 양식

[파일 내용: `reports/reproducibility_audit.md`]

````md
# Reproducibility Audit

## 1. Reproduction Commands

```bash
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run python scripts/train_deep_learning.py
```

## 2. Expected Outputs

| Output | Expected Path | Found |
|---|---|---|
| Cleaned data | `data/processed/sales_clean.csv` |  |
| Data quality report | `reports/data_quality.md` |  |
| Analysis summary | `reports/analysis_summary.md` |  |
| Baseline metrics | `artifacts/metrics/baseline_metrics.json` |  |
| Dummy metrics | `artifacts/metrics/dummy_metrics.json` |  |
| PyTorch metrics | `artifacts/metrics/pytorch_metrics.json` |  |
| Baseline report | `reports/model_baseline_report.md` |  |
| Deep learning report | `reports/deep_learning_report.md` |  |

## 3. Random Seed Policy

- Data generation seed:
- Train/test split seed:
- PyTorch seed:

## 4. Config Policy

- Main config file:
- Target variable:
- Numeric features:
- Categorical features:

## 5. Raw Data Policy

- Raw data path:
- Raw data modified? Yes / No
- Evidence:

## 6. Verdict

- PASS / CONCERNS / FAIL
- Main concerns:
- Required fixes:
````

---

# 3. 실습 2 — 최종 감사 스크립트 만들기

## 3.1 왜 감사 스크립트를 만드는가

최종 제출 직전에 파일이 있는지 일일이 확인하는 것은 실수하기 쉽다. 따라서 필수 산출물이 있는지 자동으로 확인하는 간단한 스크립트를 만든다.

---

## 3.2 AI에게 감사 스크립트 생성 요청

[AI 코딩 도구 - English prompt]

```text
Create scripts/run_final_audit.py.

The script should check whether required final project outputs exist.

Requirements:

- Check BMAD outputs.
- Check processed data.
- Check EDA reports.
- Check baseline metrics.
- Check PyTorch metrics.
- Check model artifacts.
- Check final reports.
- Write artifacts/metrics/final_scorecard.json.
- Print PASS, CONCERNS, or FAIL.
- Do not fabricate missing metrics.
- If a file is missing, record it as missing.
```

[한국어 번역]

```text
scripts/run_final_audit.py 파일을 만들어 주세요.

이 스크립트는 최종 프로젝트 필수 산출물이 존재하는지 확인해야 합니다.

요구사항은 다음과 같습니다.

- BMAD 산출물 확인
- 정제 데이터 확인
- EDA 보고서 확인
- baseline metrics 확인
- PyTorch metrics 확인
- model artifacts 확인
- 최종 보고서 확인
- artifacts/metrics/final_scorecard.json 작성
- PASS, CONCERNS, FAIL 출력
- 누락된 지표를 임의로 만들지 않기
- 파일이 없으면 missing으로 기록하기
```

---

## 3.3 직접 붙여넣을 코드

[파일 내용: `scripts/run_final_audit.py`]

```python
"""Run a final audit for the AI/Data Lab project."""

from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path

REQUIRED_PATHS = {
    "bmad_project_context": Path("_bmad-output/project-context.md"),
    "bmad_prd": Path("_bmad-output/PRD.md"),
    "bmad_architecture": Path("_bmad-output/architecture.md"),
    "raw_data": Path("data/raw/sales_sample.csv"),
    "processed_data": Path("data/processed/sales_clean.csv"),
    "data_quality_report": Path("reports/data_quality.md"),
    "analysis_summary": Path("reports/analysis_summary.md"),
    "baseline_metrics": Path("artifacts/metrics/baseline_metrics.json"),
    "dummy_metrics": Path("artifacts/metrics/dummy_metrics.json"),
    "pytorch_metrics": Path("artifacts/metrics/pytorch_metrics.json"),
    "baseline_report": Path("reports/model_baseline_report.md"),
    "deep_learning_report": Path("reports/deep_learning_report.md"),
    "final_project_report": Path("reports/final_project_report.md"),
    "model_comparison": Path("reports/model_comparison.md"),
    "reproducibility_audit": Path("reports/reproducibility_audit.md"),
    "readme": Path("README.md"),
}

OUTPUT_PATH = Path("artifacts/metrics/final_scorecard.json")


def load_json_if_exists(path: Path) -> dict:
    """Load a JSON file if it exists and is valid."""
    if not path.exists():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {"_error": "invalid_json"}


def main() -> None:
    """Check required outputs and write a final scorecard."""
    checks = {}
    missing = []

    for name, path in REQUIRED_PATHS.items():
        exists = path.exists()
        checks[name] = {
            "path": str(path),
            "exists": exists,
        }
        if not exists:
            missing.append(name)

    metrics = {
        "dummy": load_json_if_exists(Path("artifacts/metrics/dummy_metrics.json")),
        "baseline": load_json_if_exists(Path("artifacts/metrics/baseline_metrics.json")),
        "pytorch": load_json_if_exists(Path("artifacts/metrics/pytorch_metrics.json")),
    }

    if not missing:
        verdict = "PASS"
    elif len(missing) <= 3:
        verdict = "CONCERNS"
    else:
        verdict = "FAIL"

    scorecard = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "verdict": verdict,
        "missing": missing,
        "checks": checks,
        "metrics": metrics,
    }

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(
        json.dumps(scorecard, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )

    print(f"Final audit verdict: {verdict}")
    print(f"Missing outputs: {missing if missing else 'None'}")
    print(f"Saved: {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
```

---

## 3.4 감사 스크립트 실행

[터미널]

```bash
uv run python scripts/run_final_audit.py
```

정상이라면 다음과 비슷한 결과가 나온다.

```text
Final audit verdict: PASS
Missing outputs: None
Saved: artifacts/metrics/final_scorecard.json
```

`CONCERNS`가 나오면 누락된 파일을 확인하고 보완한다.

---

# 4. 실습 3 — 모델 비교 보고서 작성

## 4.1 왜 모델 비교가 필요한가

모델 하나의 성능만 보면 해석이 어렵다. 반드시 기준선과 비교해야 한다.

이번 프로젝트에서는 최소 세 가지를 비교한다.

```text
1. Dummy baseline
2. scikit-learn Logistic Regression baseline
3. PyTorch MLP
```

비교할 때 중요한 질문은 다음이다.

```text
PyTorch 모델이 dummy baseline보다 나은가?
PyTorch 모델이 scikit-learn baseline보다 나은가?
성능 차이가 크다고 말할 수 있는가?
데이터 규모와 문제 난이도를 고려하면 딥러닝이 적절한가?
precision과 recall 중 무엇이 더 중요한가?
```

---

## 4.2 AI에게 모델 비교 보고서 작성 요청

[AI 코딩 도구 - English prompt]

```text
Create reports/model_comparison.md.

Use these metric files if they exist:

- artifacts/metrics/dummy_metrics.json
- artifacts/metrics/baseline_metrics.json
- artifacts/metrics/pytorch_metrics.json
- artifacts/metrics/pytorch_training_history.csv

The report must include:

1. comparison table,
2. metric definitions in beginner-friendly language,
3. dummy vs baseline comparison,
4. baseline vs PyTorch comparison,
5. overfitting discussion based on training history if available,
6. practical interpretation,
7. limitations,
8. final model recommendation.

Do not claim improvement unless the metric files support it.
```

[한국어 번역]

```text
reports/model_comparison.md 파일을 만들어 주세요.

다음 metric 파일이 있으면 사용해 주세요.

- artifacts/metrics/dummy_metrics.json
- artifacts/metrics/baseline_metrics.json
- artifacts/metrics/pytorch_metrics.json
- artifacts/metrics/pytorch_training_history.csv

보고서에는 다음 항목을 포함해 주세요.

1. 비교 표
2. 초보자도 이해할 수 있는 지표 설명
3. dummy와 baseline 비교
4. baseline과 PyTorch 비교
5. training history가 있으면 과적합 논의
6. 실무적 해석
7. 한계
8. 최종 모델 추천

metric 파일이 뒷받침하지 않는 개선 주장은 하지 마세요.
```

---

## 4.3 직접 작성할 때 사용할 구조

[파일 내용: `reports/model_comparison.md`]

```md
# Model Comparison Report

## 1. Models Compared

| Model | Description | Purpose |
|---|---|---|
| Dummy baseline | 가장 단순한 기준 모델 | 비교 기준 |
| scikit-learn baseline | Logistic Regression 기반 기준 모델 | 해석 가능한 기본 모델 |
| PyTorch MLP | 신경망 기반 모델 | 딥러닝 확장 가능성 확인 |

## 2. Metrics

| Metric | Meaning |
|---|---|
| Accuracy | 전체 예측 중 맞춘 비율 |
| Precision | 반품이라고 예측한 것 중 실제 반품인 비율 |
| Recall | 실제 반품 중 모델이 찾아낸 비율 |
| F1-score | Precision과 Recall의 균형 지표 |

## 3. Comparison Table

| Model | Accuracy | Precision | Recall | F1-score |
|---|---:|---:|---:|---:|
| Dummy |  |  |  |  |
| scikit-learn baseline |  |  |  |  |
| PyTorch MLP |  |  |  |  |

## 4. Interpretation

- Dummy baseline 대비:
- scikit-learn baseline 대비:
- PyTorch MLP의 장점:
- PyTorch MLP의 한계:

## 5. Overfitting Check

- Training loss pattern:
- Validation loss pattern:
- Overfitting signs:

## 6. Final Recommendation

현재 프로젝트에서는 최종 추천 모델을 다음과 같이 판단한다.

- Recommended model:
- Reason:
- Caution:
```

---

# 5. 실습 4 — 한계와 위험 문서 작성

## 5.1 왜 한계를 써야 하는가

좋은 분석가는 결과를 과장하지 않는다. 특히 수업용 합성 데이터를 사용했다면, 결과를 실제 시장이나 실제 고객 행동으로 바로 일반화하면 안 된다.

이번 프로젝트에서 반드시 언급해야 할 한계는 다음과 같다.

```text
합성 데이터이므로 실제 고객 행동을 대표하지 않을 수 있다.
상관관계를 인과관계처럼 해석하면 안 된다.
반품 여부 target은 생성 규칙에 의해 만들어진 값이다.
데이터 규모가 제한적이다.
모델 성능은 실제 운영 성능을 보장하지 않는다.
딥러닝 모델은 작은 tabular data에서 항상 우월하지 않다.
```

---

## 5.2 AI에게 한계와 위험 문서 작성 요청

[AI 코딩 도구 - English prompt]

```text
Create reports/limitations_and_risks.md.

The document must include:

1. data limitations,
2. modeling limitations,
3. evaluation limitations,
4. interpretation risks,
5. ethical and privacy considerations,
6. reproducibility risks,
7. deployment or operational risks if this project were extended,
8. mitigation strategies.

Important:
- Do not overstate results.
- Do not describe correlations as causal effects.
- Clearly state that the sample data is synthetic if applicable.
```

[한국어 번역]

```text
reports/limitations_and_risks.md 파일을 만들어 주세요.

문서에는 다음 항목을 포함해 주세요.

1. 데이터 한계
2. 모델링 한계
3. 평가 한계
4. 해석 위험
5. 윤리와 개인정보 고려사항
6. 재현성 위험
7. 이 프로젝트를 확장할 때의 배포 또는 운영 위험
8. 완화 전략

중요:
- 결과를 과장하지 마세요.
- 상관관계를 인과효과처럼 설명하지 마세요.
- 해당하는 경우 sample data가 합성 데이터라는 점을 명확히 밝히세요.
```

---

# 6. 실습 5 — 최종 보고서 작성

## 6.1 최종 보고서의 역할

최종 보고서는 프로젝트의 전체 논리를 하나로 묶는 문서다.

다음 독자를 상상하고 작성한다.

```text
이 프로젝트를 처음 보는 교수자
협업할 동료 연구자
프로젝트를 이어받을 후배
포트폴리오를 평가하는 사람
```

최종 보고서는 코드 설명서가 아니라 “문제, 방법, 결과, 한계, 개선 방향”을 설명하는 문서다.

---

## 6.2 최종 보고서 구조

최종 보고서에는 최소한 다음 항목이 있어야 한다.

```text
1. Executive Summary
2. Project Goal
3. BMAD Workflow Summary
4. Data Description
5. Repository Architecture
6. EDA Findings
7. Data Quality Findings
8. Pipeline and Reproducibility
9. Model Comparison
10. Final Recommendation
11. Limitations and Risks
12. Future Roadmap
13. How to Reproduce
```

---

## 6.3 AI에게 최종 보고서 작성 요청

[AI 코딩 도구 - English prompt]

```text
Create reports/final_project_report.md.

Use the following sources:

- _bmad-output/project-context.md
- _bmad-output/product-brief.md
- _bmad-output/PRD.md
- _bmad-output/architecture.md
- reports/data_quality.md
- reports/eda_summary.md
- reports/analysis_summary.md
- reports/model_baseline_report.md
- reports/deep_learning_report.md
- reports/reproducibility_audit.md
- reports/model_comparison.md
- reports/limitations_and_risks.md

The final report must include:

1. Executive Summary,
2. Project Goal,
3. BMAD Workflow Summary,
4. Data Description,
5. Repository Architecture,
6. EDA Findings,
7. Data Quality Findings,
8. Pipeline and Reproducibility,
9. Model Comparison,
10. Final Recommendation,
11. Limitations and Risks,
12. Future Roadmap,
13. How to Reproduce.

Rules:
- Do not invent results.
- Cite local file paths as evidence.
- Do not claim causal relationships.
- Clearly distinguish findings, assumptions, and limitations.
- Keep the language suitable for a graduate-level final project.
```

[한국어 번역]

```text
reports/final_project_report.md 파일을 만들어 주세요.

다음 자료를 기준으로 사용해 주세요.

- _bmad-output/project-context.md
- _bmad-output/product-brief.md
- _bmad-output/PRD.md
- _bmad-output/architecture.md
- reports/data_quality.md
- reports/eda_summary.md
- reports/analysis_summary.md
- reports/model_baseline_report.md
- reports/deep_learning_report.md
- reports/reproducibility_audit.md
- reports/model_comparison.md
- reports/limitations_and_risks.md

최종 보고서에는 다음 항목을 포함해 주세요.

1. Executive Summary
2. Project Goal
3. BMAD Workflow Summary
4. Data Description
5. Repository Architecture
6. EDA Findings
7. Data Quality Findings
8. Pipeline and Reproducibility
9. Model Comparison
10. Final Recommendation
11. Limitations and Risks
12. Future Roadmap
13. How to Reproduce

규칙:
- 존재하지 않는 결과를 만들어내지 마세요.
- 근거로 로컬 파일 경로를 인용해 주세요.
- 인과관계를 주장하지 마세요.
- 발견, 가정, 한계를 명확히 구분해 주세요.
- 대학원 수준의 최종 프로젝트에 적합한 문체로 작성해 주세요.
```

---

## 6.4 최종 보고서 양식

[파일 내용: `reports/final_project_report.md`]

````md
# Final Project Report

## 1. Executive Summary

이 프로젝트는 Python-first AI/Data Lab으로, 합성 온라인 쇼핑몰 매출 데이터를 사용하여 데이터 품질검사, EDA, 재현 가능한 분석 파이프라인, scikit-learn baseline 모델, PyTorch 딥러닝 모델을 구현했다.

## 2. Project Goal

- 분석 목적:
- 예측 대상:
- 주요 사용자:
- 최종 산출물:

## 3. BMAD Workflow Summary

| Phase | Output | Evidence |
|---|---|---|
| Context | project-context.md | `_bmad-output/project-context.md` |
| Planning | PRD.md | `_bmad-output/PRD.md` |
| Solutioning | architecture.md | `_bmad-output/architecture.md` |
| Implementation | scripts and reports | `scripts/`, `reports/`, `artifacts/` |

## 4. Data Description

- Raw data:
- Processed data:
- Number of rows:
- Number of columns:
- Target variable:
- Key features:

## 5. Repository Architecture

- `data/`:
- `src/`:
- `scripts/`:
- `reports/`:
- `artifacts/`:
- `config/`:

## 6. EDA Findings

1.
2.
3.

## 7. Data Quality Findings

- Missing values:
- Duplicates:
- Outliers:
- Cleaning decisions:

## 8. Pipeline and Reproducibility

Main commands:

```bash
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run python scripts/train_deep_learning.py
```

Reproducibility verdict:

## 9. Model Comparison

| Model | Main Metric | Interpretation |
|---|---:|---|
| Dummy baseline |  |  |
| scikit-learn baseline |  |  |
| PyTorch MLP |  |  |

## 10. Final Recommendation

- Recommended model:
- Reason:
- Caution:

## 11. Limitations and Risks

- Data limitations:
- Modeling limitations:
- Interpretation risks:
- Reproducibility risks:

## 12. Future Roadmap

1.
2.
3.

## 13. How to Reproduce

```bash
uv sync
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run python scripts/train_deep_learning.py
uv run python scripts/run_final_audit.py
```
````

---

# 7. 실습 6 — 개선 로드맵 작성

## 7.1 로드맵이 필요한 이유

프로젝트는 8회차에서 끝나지만, 좋은 최종 발표는 “앞으로 어떻게 발전시킬 수 있는가”를 보여준다.

로드맵은 단순 희망 목록이 아니라 우선순위가 있는 개선 계획이어야 한다.

---

## 7.2 AI에게 로드맵 작성 요청

[AI 코딩 도구 - English prompt]

```text
Create reports/roadmap.md.

Organize the roadmap into:

1. short-term improvements,
2. mid-term improvements,
3. long-term improvements.

Each roadmap item must include:

- goal,
- reason,
- expected benefit,
- required data or code change,
- risk,
- priority.

Include both data-analysis improvements and engineering improvements.
```

[한국어 번역]

```text
reports/roadmap.md 파일을 만들어 주세요.

로드맵을 다음 세 범주로 나누어 주세요.

1. 단기 개선
2. 중기 개선
3. 장기 개선

각 개선 항목에는 다음을 포함해 주세요.

- 목표
- 이유
- 기대 효과
- 필요한 데이터 또는 코드 변경
- 위험
- 우선순위

데이터분석 개선과 엔지니어링 개선을 모두 포함해 주세요.
```

---

## 7.3 로드맵 예시

[파일 내용: `reports/roadmap.md`]

```md
# Future Roadmap

## 1. Short-Term Improvements

| Item | Goal | Benefit | Risk | Priority |
|---|---|---|---|---|
| Feature preprocessing review | 전처리 방식 재검토 | 모델 안정성 향상 | 시간 소요 | High |
| More EDA charts | 주요 패턴 시각화 보완 | 해석력 향상 | 과도한 차트 생성 | Medium |

## 2. Mid-Term Improvements

| Item | Goal | Benefit | Risk | Priority |
|---|---|---|---|---|
| Hyperparameter tuning | baseline과 PyTorch 모델 개선 | 성능 향상 가능 | 과적합 위험 | Medium |
| Cross-validation | 평가 안정성 확인 | 일반화 성능 판단 개선 | 실행 시간 증가 | High |

## 3. Long-Term Improvements

| Item | Goal | Benefit | Risk | Priority |
|---|---|---|---|---|
| Real-world dataset integration | 실제 데이터 적용 | 실무 적합성 향상 | 개인정보와 품질 문제 | High |
| Monitoring pipeline | 운영 환경 성능 추적 | 모델 드리프트 감지 | 운영 복잡도 증가 | Medium |
```

---

# 8. 실습 7 — 발표 자료 만들기

## 8.1 발표 자료의 목적

발표 자료는 보고서 전체를 그대로 읽는 문서가 아니다. 발표 자료는 청중이 프로젝트의 핵심 논리를 10분 안에 이해하도록 돕는 구조다.

좋은 발표는 다음 순서를 따른다.

```text
문제
→ 방법
→ 데이터
→ 분석
→ 모델
→ 결과
→ 한계
→ 개선 방향
```

---

## 8.2 발표 자료 구성

이번 수업에서는 PowerPoint 파일을 직접 만들지 않고, Markdown 기반 발표 자료와 발표자 스크립트를 만든다.

최소 슬라이드 구성은 다음과 같다.

```text
Slide 1. Title and Project Goal
Slide 2. Problem and BMAD Workflow
Slide 3. Repository Architecture
Slide 4. Data and EDA Findings
Slide 5. Reproducible Pipeline
Slide 6. Model Comparison
Slide 7. Limitations and Risks
Slide 8. Roadmap and Closing
```

---

## 8.3 AI에게 발표 자료 작성 요청

[AI 코딩 도구 - English prompt]

```text
Create presentation/final_presentation.md and presentation/presenter_script.md.

The presentation must have 8 slides:

1. Title and Project Goal
2. Problem and BMAD Workflow
3. Repository Architecture
4. Data and EDA Findings
5. Reproducible Pipeline
6. Model Comparison
7. Limitations and Risks
8. Roadmap and Closing

For each slide, include:

- slide title,
- 3 to 5 bullet points,
- evidence file path,
- presenter script in Korean.

Rules:
- Do not overstate model performance.
- Do not claim causality.
- Keep it appropriate for graduate-level presentation.
- Make it understandable for people who are new to AI.
```

[한국어 번역]

```text
presentation/final_presentation.md와 presentation/presenter_script.md 파일을 만들어 주세요.

발표 자료는 8개 슬라이드로 구성해 주세요.

1. 제목과 프로젝트 목표
2. 문제와 BMAD workflow
3. Repository Architecture
4. 데이터와 EDA 발견
5. 재현 가능한 파이프라인
6. 모델 비교
7. 한계와 위험
8. 개선 로드맵과 마무리

각 슬라이드에는 다음을 포함해 주세요.

- 슬라이드 제목
- 3~5개의 bullet point
- 근거 파일 경로
- 한국어 발표자 스크립트

규칙:
- 모델 성능을 과장하지 마세요.
- 인과관계를 주장하지 마세요.
- 대학원 수준 발표에 적합하게 작성해 주세요.
- 인공지능을 처음 접하는 사람도 이해할 수 있게 설명해 주세요.
```

---

## 8.4 직접 작성할 때 사용할 발표 자료 양식

[파일 내용: `presentation/final_presentation.md`]

```md
# Final Presentation

## Slide 1. Title and Project Goal

- Project: AI Data Lab
- Goal: 재현 가능한 데이터분석과 AI 모델링 프로젝트 구축
- Scope: EDA, data quality, pipeline, baseline ML, PyTorch DL
- Evidence: `reports/final_project_report.md`

## Slide 2. Problem and BMAD Workflow

- BMAD를 사용해 아이디어를 구현 가능한 구조로 전환
- PRD는 무엇을 만들지 정의
- Architecture는 어떤 구조로 만들지 정의
- Epic/Story는 구현 단위로 분해
- Evidence: `_bmad-output/`

## Slide 3. Repository Architecture

- `data/`: raw, interim, processed data
- `src/`: reusable analysis and modeling code
- `scripts/`: executable entry points
- `reports/`: written findings
- `artifacts/`: charts, models, metrics
- Evidence: `_bmad-output/architecture.md`

## Slide 4. Data and EDA Findings

- Synthetic sales dataset 사용
- Missing values, duplicates, outliers 포함
- 주요 EDA 질문에 대한 표와 차트 생성
- 해석은 상관·차이·패턴 중심으로 제한
- Evidence: `reports/eda_summary.md`

## Slide 5. Reproducible Pipeline

- `scripts/run_pipeline.py`로 분석 재실행
- config 기반 경로와 변수 관리
- 품질검사, KPI, 차트, 보고서 자동 생성
- Evidence: `reports/reproducibility_audit.md`

## Slide 6. Model Comparison

- Dummy baseline과 비교
- scikit-learn baseline과 비교
- PyTorch MLP의 성능과 한계 검토
- 최종 추천 모델 제시
- Evidence: `reports/model_comparison.md`

## Slide 7. Limitations and Risks

- 합성 데이터 기반 결과
- 인과관계 주장 불가
- 실제 운영 성능 보장 불가
- 모델 과적합과 일반화 한계 존재
- Evidence: `reports/limitations_and_risks.md`

## Slide 8. Roadmap and Closing

- 단기: 분석과 전처리 보완
- 중기: 교차검증과 튜닝
- 장기: 실제 데이터와 운영 모니터링
- Final message: 재현성과 한계 인식이 핵심 성과
- Evidence: `reports/roadmap.md`
```

---

## 8.5 발표자 스크립트 양식

[파일 내용: `presentation/presenter_script.md`]

```md
# Presenter Script

## Slide 1. Title and Project Goal

안녕하세요. 이번 발표에서는 BMAD 기반으로 구축한 Python-first AI/Data Lab 프로젝트를 소개하겠습니다. 이 프로젝트의 핵심 목표는 단순히 모델을 한 번 학습하는 것이 아니라, 데이터분석과 AI 모델링 과정을 문서화하고, 재현 가능한 구조로 만드는 것입니다.

## Slide 2. Problem and BMAD Workflow

이 프로젝트는 처음부터 코드를 작성하지 않고 BMAD workflow를 사용했습니다. project-context는 프로젝트의 원칙을 정했고, PRD는 무엇을 만들지 정의했으며, architecture는 실제 코드 구조를 설계했습니다. 이후 Epic과 Story를 통해 구현 작업을 작은 단위로 나누었습니다.

## Slide 3. Repository Architecture

프로젝트는 데이터, 코드, 실행 스크립트, 보고서, 결과물을 분리하는 구조로 설계했습니다. 이 구조는 노트북 중심의 일회성 분석이 아니라, 반복 실행 가능한 분석 프로젝트를 만들기 위한 것입니다.

## Slide 4. Data and EDA Findings

분석 데이터는 온라인 쇼핑몰 매출을 모사한 합성 데이터입니다. 데이터에는 결측값, 중복, 이상값이 포함되어 있어 데이터 품질검사와 EDA를 연습할 수 있습니다. EDA 결과는 원인 설명이 아니라 패턴과 차이를 확인하는 수준에서 해석했습니다.

## Slide 5. Reproducible Pipeline

5회차에서는 EDA 과정을 pipeline으로 전환했습니다. 이제 주요 결과는 명령어 한 줄로 다시 생성할 수 있습니다. 이는 분석 결과를 재검증하고 수정하기 쉽게 만드는 중요한 구조입니다.

## Slide 6. Model Comparison

모델링에서는 dummy baseline, scikit-learn baseline, PyTorch MLP를 비교했습니다. 최종 모델 선택은 단순히 가장 복잡한 모델을 고르는 방식이 아니라, 성능, 해석 가능성, 과적합 가능성, 데이터 규모를 함께 고려했습니다.

## Slide 7. Limitations and Risks

이 프로젝트의 가장 중요한 한계는 합성 데이터를 사용했다는 점입니다. 따라서 결과를 실제 고객 행동으로 일반화할 수 없습니다. 또한 분석 결과는 상관관계와 패턴에 대한 설명이지 인과관계의 증거가 아닙니다.

## Slide 8. Roadmap and Closing

향후에는 실제 데이터 적용, 교차검증, 하이퍼파라미터 튜닝, 운영 모니터링으로 확장할 수 있습니다. 이 프로젝트의 핵심 성과는 높은 모델 점수 하나가 아니라, 데이터분석 프로젝트를 구조화하고 재현 가능하게 만든 것입니다. 감사합니다.
```

---

# 9. 실습 8 — README 최종 보완

## 9.1 최종 README에 있어야 하는 것

README는 프로젝트를 처음 보는 사람이 가장 먼저 읽는 문서다. 최종 제출 전에는 README가 다음 질문에 답해야 한다.

```text
이 프로젝트는 무엇인가?
어떤 데이터를 사용하는가?
어떻게 실행하는가?
어떤 결과가 나오는가?
어떤 모델을 비교했는가?
한계는 무엇인가?
어디에서 보고서를 볼 수 있는가?
```

---

## 9.2 AI에게 README 최종 보완 요청

[AI 코딩 도구 - English prompt]

```text
Update README.md for final submission.

The README must include:

1. project overview,
2. repository structure,
3. data description,
4. setup instructions,
5. reproduction commands,
6. outputs and reports,
7. model comparison summary,
8. limitations,
9. final presentation files,
10. safety and data policy.

Rules:
- Keep it beginner-friendly.
- Do not invent metrics.
- Link to local report paths.
- Mention that the sample dataset is synthetic if applicable.
```

[한국어 번역]

```text
최종 제출을 위해 README.md를 보완해 주세요.

README에는 다음 항목이 있어야 합니다.

1. 프로젝트 개요
2. repository 구조
3. 데이터 설명
4. 설정 방법
5. 재현 명령
6. 산출물과 보고서
7. 모델 비교 요약
8. 한계
9. 최종 발표 자료 위치
10. 안전과 데이터 정책

규칙:
- 초보자도 이해할 수 있게 작성해 주세요.
- 존재하지 않는 metric을 만들어내지 마세요.
- 로컬 보고서 경로를 연결해 주세요.
- 해당하는 경우 sample dataset이 합성 데이터라는 점을 명시해 주세요.
```

---

# 10. 실습 9 — BMAD 최종 정합성 검토

## 10.1 정합성이란 무엇인가

정합성이란 문서와 구현이 서로 맞는다는 뜻이다.

예를 들어 PRD에는 PyTorch 모델을 만들겠다고 했는데 실제 repo에 `scripts/train_deep_learning.py`가 없다면 정합성이 낮다.

반대로 architecture에는 웹앱이 아니라고 되어 있는데 갑자기 `app/`, `pages/`, `login/` 같은 웹서비스 구조가 생겼다면 정합성 문제가 있다.

---

## 10.2 AI에게 BMAD 최종 검토 요청

[AI 코딩 도구 - English prompt]

```text
Perform a final BMAD consistency review.

Compare:

- _bmad-output/project-context.md
- _bmad-output/product-brief.md
- _bmad-output/PRD.md
- _bmad-output/architecture.md
- epics/stories output
- actual repository structure
- reports and artifacts

Check whether:

1. the project remains Python-first and data-analysis focused,
2. implementation follows the architecture,
3. PRD requirements are implemented or clearly marked as out of scope,
4. notebooks are not the only source of logic,
5. reusable code lives in src/,
6. scripts provide reproducible entry points,
7. model results are supported by metric files,
8. limitations are documented,
9. no web application structure was introduced.

Return PASS, CONCERNS, or FAIL with exact fixes.
```

[한국어 번역]

```text
최종 BMAD 정합성 검토를 수행해 주세요.

다음 항목을 비교해 주세요.

- _bmad-output/project-context.md
- _bmad-output/product-brief.md
- _bmad-output/PRD.md
- _bmad-output/architecture.md
- epics/stories 산출물
- 실제 repository 구조
- reports와 artifacts

다음 항목을 확인해 주세요.

1. 프로젝트가 여전히 Python-first 데이터분석 프로젝트인가
2. 구현이 architecture를 따르는가
3. PRD 요구사항이 구현되었거나 명확히 out of scope로 표시되었는가
4. 노트북이 유일한 로직 저장소가 아닌가
5. 재사용 가능한 코드가 src/에 있는가
6. scripts가 재현 가능한 실행 진입점을 제공하는가
7. 모델 결과가 metric 파일로 뒷받침되는가
8. 한계가 문서화되어 있는가
9. 웹 애플리케이션 구조가 도입되지 않았는가

PASS, CONCERNS, FAIL 중 하나로 판정하고 정확한 수정 방법을 제시해 주세요.
```

---

# 11. 최종 발표 연습

## 11.1 발표 시간 구조

10분 발표라면 다음 시간 배분을 권장한다.

| 구간 | 시간 | 내용 |
|---|---:|---|
| 도입 | 1분 | 프로젝트 목표와 문제 |
| BMAD workflow | 1분 | 문서화와 설계 구조 |
| 데이터와 EDA | 2분 | 데이터 구조와 주요 발견 |
| 파이프라인 | 1분 | 재현성 구조 |
| 모델 비교 | 2분 | baseline과 PyTorch 비교 |
| 한계 | 1분 | 데이터·모델·해석 한계 |
| 로드맵 | 1분 | 개선 방향 |

---

## 11.2 발표할 때 피해야 할 표현

피해야 할 표현:

```text
이 모델이 반품의 원인을 찾았습니다.
딥러닝이 항상 더 좋습니다.
이 결과는 실제 쇼핑몰에도 그대로 적용됩니다.
정확도가 높으므로 문제가 없습니다.
```

더 좋은 표현:

```text
이 분석에서는 변수 간 차이와 패턴을 확인했습니다.
현재 데이터에서는 baseline과 PyTorch 모델을 비교했습니다.
합성 데이터이므로 실제 환경 적용 전 추가 검증이 필요합니다.
F1-score, precision, recall을 함께 보고 해석해야 합니다.
```

---

# 12. 최종 품질 게이트

8회차가 끝나기 전에 다음을 모두 확인한다.

## 12.1 산출물 게이트

```text
[ ] reports/reproducibility_audit.md가 있다.
[ ] reports/model_comparison.md가 있다.
[ ] reports/limitations_and_risks.md가 있다.
[ ] reports/final_project_report.md가 있다.
[ ] reports/roadmap.md가 있다.
[ ] presentation/final_presentation.md가 있다.
[ ] presentation/presenter_script.md가 있다.
[ ] artifacts/metrics/final_scorecard.json이 있다.
[ ] README.md가 최종 보완되었다.
```

## 12.2 재현성 게이트

```text
[ ] uv run python scripts/run_pipeline.py가 실행된다.
[ ] uv run python scripts/train_baseline.py가 실행된다.
[ ] uv run python scripts/train_deep_learning.py가 실행된다.
[ ] uv run python scripts/run_final_audit.py가 실행된다.
[ ] 주요 output이 reports/와 artifacts/에 저장된다.
```

## 12.3 해석 게이트

```text
[ ] EDA 결과가 분석 질문과 연결된다.
[ ] 모델 성능이 dummy baseline과 비교된다.
[ ] 모델 성능이 scikit-learn baseline과 비교된다.
[ ] PyTorch 모델을 과장하지 않는다.
[ ] 상관관계를 인과관계처럼 말하지 않는다.
[ ] 합성 데이터의 한계를 명시한다.
[ ] 개인정보와 실제 데이터 사용 시 주의사항을 명시한다.
```

## 12.4 BMAD 게이트

```text
[ ] project-context.md와 실제 repo가 충돌하지 않는다.
[ ] PRD 요구사항이 최종 보고서에서 추적 가능하다.
[ ] architecture.md의 구조를 실제 repo가 따른다.
[ ] Epic/Story 산출물과 구현 결과가 연결된다.
[ ] source of truth가 무엇인지 명확하다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구 - English prompt]

```text
Check the final project against the Session 8 quality gates.

Evaluate:

1. required final reports,
2. final presentation files,
3. reproducibility commands,
4. model comparison evidence,
5. limitations and risks,
6. README completeness,
7. BMAD consistency,
8. final scorecard.

Return PASS, CONCERNS, or FAIL.
For every concern, give the exact fix.
Do not invent missing results.
```

[한국어 번역]

```text
현재 프로젝트를 8회차 최종 품질 게이트 기준으로 점검해 주세요.

다음 항목을 평가해 주세요.

1. 필수 최종 보고서
2. 최종 발표 자료
3. 재현성 명령
4. 모델 비교 근거
5. 한계와 위험
6. README 완성도
7. BMAD 정합성
8. 최종 scorecard

PASS, CONCERNS, FAIL 중 하나로 판정해 주세요.
문제가 있으면 정확한 수정 방법을 제시해 주세요.
누락된 결과를 임의로 만들어내지 마세요.
```

---

# 13. GitHub 최종 제출

## 13.1 변경 사항 확인

[터미널]

```bash
git status
```

불필요한 캐시나 대용량 파일이 포함되어 있으면 `.gitignore`를 확인한다.

---

## 13.2 최종 커밋

[터미널]

```bash
git add .
git commit -m "Finalize AI Data Lab project report and presentation"
```

원격 저장소가 설정되어 있다면 push한다.

[터미널]

```bash
git push
```

---

## 13.3 제출 전에 확인할 것

```text
[ ] GitHub에서 README가 잘 보인다.
[ ] reports/ 폴더가 있다.
[ ] presentation/ 폴더가 있다.
[ ] artifacts/metrics/에 최종 지표가 있다.
[ ] 실제 개인정보 데이터가 올라가지 않았다.
[ ] 불필요한 대용량 모델 파일이 올라가지 않았다.
[ ] 실행 명령이 README에 있다.
```

---

# 14. 과제 안내

## 과제 1. 최종 발표 5분 리허설

`presentation/presenter_script.md`를 보면서 5분 발표를 연습한다.

연습 후 다음을 기록한다.

```text
가장 설명하기 어려웠던 슬라이드:
시간이 오래 걸린 부분:
청중이 질문할 것 같은 부분:
수정할 문장:
```

---

## 과제 2. 최종 자기평가 작성

`reports/final_self_review.md` 파일을 만든다.

[파일 내용: `reports/final_self_review.md`]

```md
# Final Self Review

## 1. 내가 가장 잘한 점


## 2. 가장 어려웠던 점


## 3. BMAD를 사용하면서 달라진 점


## 4. 데이터분석에 대해 새롭게 이해한 점


## 5. 모델링 결과를 해석할 때 조심해야 할 점


## 6. 이 프로젝트를 포트폴리오로 발전시키기 위해 필요한 것


```

---

## 과제 3. 다음 버전의 PRD 초안 작성

이 프로젝트를 v0.2로 발전시킨다고 가정하고 다음을 적는다.

```text
1. v0.2에서 해결할 문제
2. 새로 추가할 데이터
3. 개선할 분석 질문
4. 개선할 모델링 방법
5. 새로 필요한 테스트
6. 예상 위험
```

---

# 15. 자주 생기는 문제와 해결법

## 15.1 최종 보고서가 너무 추상적이다

증상:

```text
좋은 결과를 얻었다.
모델 성능이 우수하다.
의미 있는 인사이트가 있었다.
```

해결:

```text
숫자, 파일 경로, 차트, 지표를 근거로 적는다.
```

AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구 - English prompt]

```text
Revise reports/final_project_report.md to make it more evidence-based.

For each major claim, add:
- metric value,
- chart path,
- report path,
- or explicit limitation.

Do not add unsupported claims.
```

[한국어 번역]

```text
reports/final_project_report.md를 근거 중심으로 수정해 주세요.

주요 주장마다 다음 중 하나를 추가해 주세요.
- metric 값
- chart 경로
- report 경로
- 명시적인 한계

근거 없는 주장은 추가하지 마세요.
```

---

## 15.2 PyTorch 모델이 baseline보다 낮다

이것은 실패가 아니다. 다음처럼 해석한다.

```text
현재 tabular synthetic dataset에서는 더 단순한 모델이 더 적절할 수 있다.
PyTorch 모델은 데이터 규모, feature engineering, hyperparameter 설정에 민감하다.
따라서 최종 추천 모델은 반드시 가장 복잡한 모델일 필요가 없다.
```

---

## 15.3 발표 시간이 초과된다

해결:

```text
1. BMAD 설명을 1분 이내로 줄인다.
2. EDA 발견은 3개만 말한다.
3. 모델 비교는 최종 표 하나로 설명한다.
4. 한계는 3개만 말한다.
5. 로드맵은 우선순위 높은 2개만 말한다.
```

---

## 15.4 final audit가 FAIL을 낸다

먼저 누락된 파일 목록을 확인한다.

[터미널]

```bash
uv run python scripts/run_final_audit.py
```

누락 파일이 많으면 순서대로 보완한다.

```text
1. pipeline 실행
2. baseline 학습 실행
3. PyTorch 학습 실행
4. final report 생성
5. final audit 재실행
```

---

# 16. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> 최종 프로젝트의 완성도는 모델 점수 하나가 아니라, 문제 정의·재현성·근거 있는 해석·한계 인식·개선 가능성이 함께 갖추어질 때 높아진다.

8회차의 흐름은 다음과 같다.

```text
산출물 재실행
→ 재현성 검토
→ 최종 감사 스크립트
→ 모델 비교 보고서
→ 한계와 위험 문서
→ 최종 보고서
→ 개선 로드맵
→ 발표 자료와 스크립트
→ README 최종 보완
→ BMAD 정합성 검토
→ GitHub 최종 제출
```

---

# 17. 8회차 최종 체크리스트

수업이 끝나기 전에 스스로 확인한다.

```text
[ ] 전체 분석 파이프라인을 다시 실행했다.
[ ] baseline 모델을 다시 학습했다.
[ ] PyTorch 모델을 다시 학습했다.
[ ] 재현성 검토 문서를 만들었다.
[ ] 최종 감사 스크립트를 실행했다.
[ ] final_scorecard.json을 만들었다.
[ ] 모델 비교 보고서를 작성했다.
[ ] 한계와 위험 문서를 작성했다.
[ ] 최종 보고서를 작성했다.
[ ] 개선 로드맵을 작성했다.
[ ] 발표 자료를 작성했다.
[ ] 발표자 스크립트를 작성했다.
[ ] README를 최종 보완했다.
[ ] BMAD 정합성 검토를 수행했다.
[ ] GitHub 최종 커밋을 만들었다.
[ ] 상관관계를 인과관계처럼 말하지 않을 수 있다.
[ ] 최종 프로젝트의 한계를 설명할 수 있다.
```

---

## 부록 A. 오늘 사용하는 핵심 명령 모음

### 터미널 명령

```bash
pwd
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
uv run python scripts/train_deep_learning.py
uv run python scripts/run_final_audit.py
ls reports
ls artifacts/metrics
git status
git add .
git commit -m "Finalize AI Data Lab project report and presentation"
git push
```

### AI 코딩 도구 명령

```text
Review the current project as the starting point for Session 8.
Create reports/reproducibility_audit.md.
Create scripts/run_final_audit.py.
Create reports/model_comparison.md.
Create reports/limitations_and_risks.md.
Create reports/final_project_report.md.
Create reports/roadmap.md.
Create presentation/final_presentation.md and presentation/presenter_script.md.
Update README.md for final submission.
Perform a final BMAD consistency review.
```

---

## 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| Final Audit | 최종 제출 전 산출물이 존재하고 재현 가능한지 확인하는 절차 |
| Reproducibility | 같은 명령을 다시 실행해 주요 결과를 다시 만들 수 있는 성질 |
| Model Comparison | 여러 모델을 같은 기준으로 비교하는 절차 |
| Baseline | 더 복잡한 모델의 가치를 판단하기 위한 기준 모델 |
| Limitation | 분석 결과를 해석할 때 반드시 고려해야 하는 한계 |
| Risk | 프로젝트가 실패하거나 오해될 가능성이 있는 요소 |
| Roadmap | 다음 버전에서 개선할 항목의 우선순위 계획 |
| Presenter Script | 발표자가 슬라이드별로 말할 내용을 정리한 원고 |
| BMAD Consistency | BMAD 문서와 실제 구현 결과가 서로 일치하는 정도 |
| Final Scorecard | 최종 프로젝트 상태를 요약한 점검 결과 |
