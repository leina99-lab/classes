# 3회차 학습자 실습 매뉴얼

# 데이터분석 repo 구조와 아키텍처
## Architecture → Epic/Story → 구현 준비도 → repo 구조 → 합성 데이터

---

## 이 자료의 목적

3회차의 목표는 **코드를 많이 작성하는 것**이 아니라, 2회차에서 만든 문서를 바탕으로 **실제로 구현 가능한 프로젝트 구조를 만드는 것**이다.

2회차에서는 다음 문서를 만들었다.

```text
_bmad-output/project-context.md
_bmad-output/product-brief.md
_bmad-output/PRD.md
```

3회차에서는 이 문서들을 바탕으로 다음을 만든다.

```text
1. architecture.md
2. Epic / Story 문서
3. 구현 준비도 검증 결과
4. 표준 데이터분석 repo 구조
5. scripts/generate_sample_data.py
6. data/raw/sales_sample.csv
7. config/analysis_config.yaml
```

오늘의 핵심 문장은 다음이다.

> PRD가 “무엇을 만들 것인가”를 말한다면, Architecture는 “어떤 구조로 만들 것인가”를 말한다.

3회차가 끝나면 프로젝트는 더 이상 빈 폴더가 아니다. 4회차 EDA를 시작할 수 있는 실제 데이터분석 저장소가 된다.

---

## 오늘 끝나면 있어야 하는 것

3회차가 끝났을 때 프로젝트 폴더에는 다음 구조가 있어야 한다.

```text
ai-data-lab/
├── _bmad-output/
│   ├── brainstorming-report.md
│   ├── project-context.md
│   ├── product-brief.md
│   ├── PRD.md
│   ├── architecture.md
│   └── epics-and-stories.md        # 이름은 BMAD 버전에 따라 다를 수 있음
├── config/
│   └── analysis_config.yaml
├── data/
│   ├── raw/
│   │   └── sales_sample.csv
│   ├── interim/
│   └── processed/
├── notebooks/
├── src/
│   ├── data/
│   ├── analysis/
│   ├── models/
│   ├── visualization/
│   └── ai/
├── scripts/
│   ├── generate_sample_data.py
│   ├── run_pipeline.py
│   ├── train_baseline.py
│   └── train_deep_learning.py
├── tests/
├── reports/
├── artifacts/
│   ├── charts/
│   ├── models/
│   └── metrics/
├── README.md
└── pyproject.toml                  # uv 프로젝트 설정 파일
```

> [!NOTE]
> BMAD가 만드는 산출물 파일 이름은 설치 버전과 설정에 따라 조금 달라질 수 있다. 예를 들어 `architecture.md`가 `_bmad-output/architecture.md`로 만들어질 수도 있고, 여러 조각으로 나뉘어 저장될 수도 있다. 핵심은 **Architecture 문서와 Epic/Story 문서가 존재하는가**이다.

---

## 오늘 사용할 입력 위치를 구분하자

3회차에서는 입력 위치가 세 가지다.

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | Windows PowerShell 또는 Mac Terminal | `uv run python scripts/generate_sample_data.py` |
| `[AI 코딩 도구]` | Gemini CLI 또는 Claude Code 안 | `bmad-create-architecture` |
| `[파일 내용]` | Markdown, Python, YAML 파일 안에 들어갈 내용 | `project_name: AI Data Lab` |

앞으로 모든 실습에는 입력 위치를 표시한다.

예를 들어 아래 명령은 터미널에 입력한다.

```bash
uv run python scripts/generate_sample_data.py
```

아래 문장은 AI 코딩 도구 안에 입력한다.

```text
bmad-create-architecture
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

PowerShell이 열리면 보통 이런 모양이다.

```powershell
PS C:\Users\내이름>
```

Mac에서는 Terminal을 연다.

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

Mac 터미널이 열리면 보통 이런 모양이다.

```bash
내이름@MacBook ~ %
```

앞으로 “터미널”이라고 하면 Windows에서는 PowerShell, Mac에서는 Terminal을 뜻한다.

---

## 0.2 프로젝트 폴더로 이동한다

1회차에서 만든 프로젝트 폴더로 이동한다. 이 자료에서는 폴더 이름을 `ai-data-lab`이라고 가정한다. 본인의 폴더 이름이 다르면 그 이름을 사용한다.

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

## 0.3 2회차 산출물이 있는지 확인한다

3회차는 2회차 산출물이 있어야 진행할 수 있다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 네 개 파일이 있어야 한다.

```text
brainstorming-report.md
project-context.md
product-brief.md
PRD.md
```

파일이 없다면 3회차를 바로 진행하지 않는다. 먼저 2회차 산출물을 보완해야 한다.

AI 코딩 도구에서 다음과 같이 확인할 수도 있다.

```text
Check whether the following files exist:

_bmad-output/brainstorming-report.md
_bmad-output/project-context.md
_bmad-output/product-brief.md
_bmad-output/PRD.md

If any file is missing, tell me exactly which previous workflow I should run.
```

---

## 0.4 AI 코딩 도구를 실행한다

Gemini CLI를 사용하는 경우, 터미널에서 다음을 입력한다.

```bash
gemini
```

Claude Code를 사용하는 경우, 터미널에서 다음을 입력한다.

```bash
claude
```

AI 코딩 도구가 열리면 다음 명령으로 현재 프로젝트 상태를 확인한다.

```text
bmad-help
```

정상적인 상황에서는 BMAD가 현재 프로젝트 상태를 읽고 다음 단계로 Architecture 생성을 권장해야 한다.

---

# 1. 2회차 과제 확인

## 1.1 PRD를 다시 읽었는가

2회차 과제는 PRD를 하루 뒤 다시 읽고 모호한 부분을 수정하는 것이었다. 3회차 시작 전에 다음 질문을 스스로 확인한다.

```text
1. 분석 목적이 한 문장으로 명확한가?
2. 기능 요구사항에 구체적인 작업 목록이 있는가?
3. 성공 기준에 측정 가능한 숫자가 있는가?
4. 범위에서 하지 않는 것이 명시되어 있는가?
5. 데이터 요구사항에 형식과 변수 목록이 있는가?
6. 리스크가 1개 이상 적혀 있는가?
7. 비전공자가 읽어도 이해할 수 있는가?
```

아직 모호하다면 AI 코딩 도구에 다음을 입력한다.

```text
Open _bmad-output/PRD.md and review it using this checklist:

1. Is the analysis purpose clear in one sentence?
2. Are the functional requirements concrete?
3. Are success criteria measurable?
4. Are in-scope and out-of-scope items clearly separated?
5. Are data requirements specific enough?
6. Are model requirements realistic?
7. Are risks documented?

If any item is weak, suggest a revision.
Do not change the project into a web application.
Keep it Python-first and data-analysis focused.
```

---

## 1.2 EDA 질문 10개가 있는가

4회차에서는 EDA를 한다. 따라서 3회차에서 생성할 합성 데이터는 4회차 EDA 질문에 답할 수 있어야 한다.

EDA 질문 예시는 다음과 같다.

```text
1. 지역별 평균 매출은 어떻게 다른가?
2. 채널별 반품률은 어떻게 다른가?
3. 상품 카테고리별 매출 비중은 어떻게 다른가?
4. 할인율이 높은 주문과 낮은 주문의 반품률은 어떻게 다른가?
5. 고객 연령대별 평균 구매 금액은 어떻게 다른가?
```

EDA 질문이 아직 없다면 ChatGPT Projects 또는 AI 코딩 도구에서 다음을 입력한다.

```text
Based on _bmad-output/PRD.md, create 10 exploratory data analysis questions.

Rules:
- Each question must be answerable with tabular data.
- Each question must identify the required columns.
- Use counts, proportions, averages, medians, group comparisons, time trends, or relationships between two variables.
- Do not make causal claims.
- Keep the questions suitable for pandas-based EDA.
```

---

# 2. 실습 1 — Architecture 작성

## 2.1 Architecture는 무엇인가

PRD는 “무엇을 만들 것인가”를 정리한 문서다. Architecture는 “어떤 구조로 만들 것인가”를 정리한 문서다.

데이터분석 프로젝트에서 Architecture는 다음을 정한다.

```text
어떤 폴더를 만들 것인가?
데이터는 어떤 흐름으로 이동하는가?
노트북과 src 코드는 어떻게 분리하는가?
모델 학습 코드는 어디에 둘 것인가?
AI API 해석 기능은 어디에 둘 것인가?
설정값은 코드에 직접 쓸 것인가, config 파일로 분리할 것인가?
```

이 수업에서는 Architecture를 통해 다음 원칙을 고정한다.

```text
notebooks/는 탐색용
src/는 재사용 가능한 코드
scripts/는 실행 진입점
data/raw/는 원본 데이터
config/analysis_config.yaml은 설정값
artifacts/는 차트, 모델, 메트릭
reports/는 해석과 보고서
```

---

## 2.2 새 세션을 연다

BMAD workflow를 새로 시작할 때는 이전 대화 맥락을 지운다.

[AI 코딩 도구]

```text
/clear
```

그다음 Architecture workflow를 실행한다.

[AI 코딩 도구]

```text
bmad-create-architecture
```

BMAD의 Architect 역할은 보통 Winston이라고 불린다. Winston은 PRD와 project-context를 읽고 기술 구조를 설계한다.

---

## 2.3 Winston에게 답할 때의 기준

Winston이 질문하면 아래 기준으로 답한다.

| Winston의 질문 | 답변 기준 |
|---|---|
| 어떤 언어를 사용할 것인가? | Python 3.11 |
| 패키지 관리는 어떻게 할 것인가? | uv |
| 주요 분석 라이브러리는? | pandas, matplotlib |
| 머신러닝 라이브러리는? | scikit-learn |
| 딥러닝은 무엇으로 할 것인가? | PyTorch, 단 7회차 이후 본격 사용 |
| 노트북은 어디에 둘 것인가? | `notebooks/`, 탐색과 수업용 |
| 재사용 코드는 어디에 둘 것인가? | `src/` |
| 실행 스크립트는 어디에 둘 것인가? | `scripts/` |
| 원본 데이터는 어디에 둘 것인가? | `data/raw/`, 절대 수정 금지 |
| 정제 데이터는 어디에 둘 것인가? | `data/processed/` |
| 차트, 모델, 지표는 어디에 둘 것인가? | `artifacts/` |
| 보고서는 어디에 둘 것인가? | `reports/` |
| 설정은 어떻게 관리할 것인가? | `config/analysis_config.yaml` |
| AI API 해석 기능은 어디에 둘 것인가? | `src/ai/`, config에서 on/off 가능하게 |
| SQL을 사용할 것인가? | 초기 버전에서는 사용하지 않음 |
| 웹앱인가? | 아님. Python-first AI/Data Lab |

---

## 2.4 Winston에게 줄 수 있는 답변 예시

Winston이 전체 구조를 묻거나 기술 방향을 확인하면 다음 답변을 사용할 수 있다.

[AI 코딩 도구]

```text
This project is a Python-first AI/Data Lab, not a web application.

Use this architecture direction:

- Python 3.11
- uv for package and environment management
- pandas and matplotlib for EDA
- scikit-learn for baseline modeling
- PyTorch for later deep learning implementation
- pytest for tests
- ruff for linting
- notebooks/ for exploration and teaching only
- reusable logic must live in src/
- scripts/ must contain executable entry points
- data/raw/ must never be modified
- data/processed/ contains cleaned data
- reports/ contains written analysis
- artifacts/ contains charts, models, and metrics
- config/analysis_config.yaml stores paths, target variable, feature lists, modeling options, and output paths
- AI interpretation module should live in src/ai/ and be controlled by config
- no SQL for the initial version

Please create an architecture that follows _bmad-output/project-context.md and _bmad-output/PRD.md.
```

---

## 2.5 Architecture 성공 기준

Architecture 문서에는 최소한 다음이 있어야 한다.

```text
1. 프로젝트 폴더 구조
2. 데이터 흐름: raw → interim/processed → artifacts/reports
3. 주요 기술 스택
4. 각 모듈의 책임
5. 노트북과 src 코드 분리 원칙
6. config/analysis_config.yaml의 역할
7. AI 해석 모듈의 위치와 on/off 방식
8. 테스트와 재현성 원칙
```

AI 코딩 도구에 다음을 입력해 점검한다.

[AI 코딩 도구]

```text
Review the generated architecture.
Check whether it includes:

1. folder structure
2. data flow from raw to processed to artifacts
3. Python-first technology stack
4. module responsibilities
5. notebook/src separation
6. config/analysis_config.yaml
7. reproducibility rules
8. test strategy
9. confirmation that this is not a web application

If anything is missing, revise the architecture.
```

---

## 2.6 산출물 확인

터미널에서 `_bmad-output` 폴더를 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 중 하나가 보여야 한다.

```text
architecture.md
```

또는 BMAD 설정에 따라 architecture 관련 폴더나 조각 파일이 보일 수 있다.

AI 코딩 도구에서 이렇게 확인해도 된다.

[AI 코딩 도구]

```text
Find the architecture output file or files created by BMAD.
Show me their paths.
```

---

# 3. Epic과 Story 이해하기

## 3.1 Epic이란 무엇인가

Epic은 큰 작업 묶음이다. 책에 비유하면 “장”이다.

예를 들어 AI/Data Lab 프로젝트의 Epic은 다음과 같을 수 있다.

```text
Epic 1. 프로젝트 기본 구조 생성
Epic 2. 합성 데이터 생성
Epic 3. 데이터 로딩과 품질 검사
Epic 4. EDA 분석
Epic 5. 시각화 생성
Epic 6. baseline 모델 학습
Epic 7. AI 해석 모듈
Epic 8. 보고서 생성
```

Epic은 너무 작으면 안 된다. Epic 하나는 여러 개의 Story를 포함해야 한다.

---

## 3.2 Story란 무엇인가

Story는 Epic 안의 작은 작업 단위다. 책에 비유하면 “절”이다.

좋은 Story는 다음 질문에 답해야 한다.

```text
무엇을 만들 것인가?
어떤 파일을 만들거나 수정할 것인가?
완료 기준은 무엇인가?
어떤 테스트가 필요한가?
```

나쁜 Story 예시:

```text
데이터 전처리하기
```

좋은 Story 예시:

```text
Story: 결측값 요약 함수를 작성한다.

목표:
src/data/quality.py에 열별 결측값 개수와 비율을 반환하는 summarize_missing_values 함수를 작성한다.

파일:
- src/data/quality.py
- tests/test_quality.py

수용 기준:
- DataFrame을 입력하면 열별 missing_count와 missing_pct를 반환한다.
- 결측값이 없는 열도 결과에 포함된다.
- pytest 테스트가 통과한다.
```

---

## 3.3 좋은 Story의 구성 요소

| 항목 | 설명 |
|---|---|
| 목표 | 무엇을 만드는가 |
| 파일 목록 | 어떤 파일을 생성하거나 수정하는가 |
| 수용 기준 | 어떤 상태가 되면 완료인가 |
| 테스트 요구사항 | 어떤 테스트를 작성하는가 |
| 의존성 | 어떤 이전 Story가 먼저 완료되어야 하는가 |

Story가 명확해야 AI가 구현할 때 길을 잃지 않는다.

---

# 4. 실습 2 — Epic/Story 생성

## 4.1 새 세션을 연다

[AI 코딩 도구]

```text
/clear
```

Epic/Story workflow를 실행한다.

[AI 코딩 도구]

```text
bmad-create-epics-and-stories
```

John은 PRD와 Architecture를 읽고 구현 가능한 Epic과 Story로 나눈다.

---

## 4.2 John에게 줄 수 있는 추가 지시

John이 범위를 확인하거나 Story 작성 기준을 물으면 다음을 입력할 수 있다.

[AI 코딩 도구]

```text
Create epics and stories for a Python-first AI/Data Lab.

Use these rules:

- Minimum 8 epics
- Each epic should have 2 to 5 stories
- Each story must include goal, files to create or modify, acceptance criteria, and test requirements
- Stories must follow the architecture document
- Do not create web application stories
- Do not introduce SQL in the initial version
- Include stories for repo structure, sample data generation, data quality checks, EDA, visualization, baseline modeling, AI interpretation, and reporting
- Keep notebooks for exploration only
- Put reusable code in src/
```

---

## 4.3 Epic/Story 성공 기준

Epic/Story 문서는 다음 기준을 만족해야 한다.

```text
1. 최소 8개 Epic이 있다.
2. 각 Epic에는 2~5개 Story가 있다.
3. 각 Story에 목표가 있다.
4. 각 Story에 파일 경로가 있다.
5. 각 Story에 완료 기준이 있다.
6. 각 Story에 테스트 요구사항이 있다.
7. 웹앱 관련 Story가 없다.
8. SQL 관련 Story가 초기 버전에 들어가지 않는다.
```

AI 코딩 도구에 다음을 입력해 점검한다.

[AI 코딩 도구]

```text
Review the generated epics and stories.
Check whether:

1. there are at least 8 epics,
2. each epic has 2 to 5 stories,
3. each story has goal, files, acceptance criteria, and test requirements,
4. no web application stories are included,
5. no SQL dependency is introduced for the initial version.

If anything is missing, revise the epics and stories.
```

---

## 4.4 산출물 확인

AI 코딩 도구에서 다음을 입력한다.

[AI 코딩 도구]

```text
Find the epics and stories output created by BMAD.
Show me the file path or paths.
```

터미널에서도 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

보통 다음과 비슷한 파일 또는 폴더가 있어야 한다.

```text
epics-and-stories.md
stories/
```

BMAD 버전에 따라 이름은 다를 수 있다.

---

# 5. 실습 3 — 구현 준비도 검증

## 5.1 구현 준비도 검증이란 무엇인가

구현 준비도 검증은 다음 질문에 답한다.

> 지금 이 프로젝트는 실제 구현을 시작할 만큼 충분히 준비되었는가?

검증 결과는 보통 세 가지 중 하나다.

| 결과 | 의미 | 해야 할 일 |
|---|---|---|
| PASS | 문서가 일관적이고 구현을 시작할 수 있음 | 다음 단계로 진행 |
| CONCERNS | 일부 불일치나 누락이 있음 | 지적 사항 수정 후 재검증 |
| FAIL | 심각한 누락이 있음 | PRD 또는 Architecture로 돌아가 수정 |

---

## 5.2 새 세션을 열고 검증한다

[AI 코딩 도구]

```text
/clear
```

[AI 코딩 도구]

```text
bmad-check-implementation-readiness
```

AI가 문서를 읽고 PASS, CONCERNS, FAIL 중 하나를 제시한다.

---

## 5.3 CONCERNS가 나왔을 때

CONCERNS는 실패가 아니다. 수정해야 할 부분이 있다는 뜻이다.

AI 코딩 도구에 다음을 입력한다.

[AI 코딩 도구]

```text
The readiness check returned CONCERNS.
List each concern in a table with:

- concern
- affected document
- why it matters
- exact revision needed
- whether I should update PRD, architecture, or stories

Do not revise blindly. Ask me when a project decision is needed.
```

그다음 지적받은 문서를 수정하고 다시 검증한다.

[AI 코딩 도구]

```text
bmad-check-implementation-readiness
```

---

## 5.4 FAIL이 나왔을 때

FAIL은 구현을 시작하면 안 된다는 뜻이다. 보통 다음 문제가 있을 때 발생한다.

```text
PRD가 너무 모호함
Architecture가 PRD와 충돌함
Epic/Story가 구현 가능한 단위로 쪼개지지 않음
데이터 요구사항이 빠짐
성공 기준이 없음
```

FAIL이 나오면 다음 프롬프트를 사용한다.

[AI 코딩 도구]

```text
The readiness check returned FAIL.
Do not proceed to implementation.

Identify the blocking issues and tell me exactly which workflow I should return to:

- PRD revision
- architecture revision
- epics/stories revision

For each blocking issue, explain what decision is missing.
```

---

## 5.5 PASS가 나왔을 때

PASS가 나오면 Phase 4, 즉 구현 단계로 넘어갈 준비가 된 것이다.

하지만 오늘은 복잡한 구현을 바로 시작하지 않는다. 오늘은 4회차 EDA를 준비하기 위해 다음 두 가지를 만든다.

```text
1. 표준 repo 구조
2. 합성 데이터
```

---

# 6. 실습 4 — repo 구조 만들기

## 6.1 repo 구조가 중요한 이유

데이터분석 프로젝트는 처음에는 노트북 하나로 시작할 수 있다. 하지만 노트북 하나에 모든 코드가 들어가면 곧 문제가 생긴다.

```text
코드를 재사용하기 어렵다.
테스트하기 어렵다.
어떤 코드가 실험용이고 어떤 코드가 실제 로직인지 구분하기 어렵다.
결과를 다시 만들기 어렵다.
```

그래서 3회차에서는 표준 repo 구조를 만든다.

---

## 6.2 AI에게 repo 구조 생성을 요청한다

[AI 코딩 도구]

```text
Using _bmad-output/project-context.md and the architecture document as the source of truth, create the project folder structure for this Python-first AI/Data Lab.

Requirements:

- Create src/data/, src/analysis/, src/models/, src/visualization/, src/ai/
- Create scripts/, tests/, notebooks/
- Create data/raw/, data/interim/, data/processed/
- Create reports/
- Create artifacts/charts/, artifacts/models/, artifacts/metrics/
- Create config/
- Add simple __init__.py files where appropriate
- Add placeholder Python files with short docstrings only
- Do not implement complex logic yet
- Do not create a web application structure
- Do not introduce SQL
```

AI가 파일을 생성할 수 있는 환경이라면 이 요청만으로 구조가 만들어진다.

---

## 6.3 AI가 파일을 만들지 못할 때 — 직접 만드는 방법

AI 코딩 도구가 실제 파일을 만들지 못하면 터미널에서 직접 만든다.

### Windows PowerShell

[터미널]

```powershell
$dirs = @(
  "src/data",
  "src/analysis",
  "src/models",
  "src/visualization",
  "src/ai",
  "scripts",
  "tests",
  "notebooks",
  "data/raw",
  "data/interim",
  "data/processed",
  "reports",
  "artifacts/charts",
  "artifacts/models",
  "artifacts/metrics",
  "config"
)

foreach ($d in $dirs) {
  New-Item -ItemType Directory -Force $d | Out-Null
}

$files = @(
  "src/__init__.py",
  "src/data/__init__.py",
  "src/data/loading.py",
  "src/data/cleaning.py",
  "src/data/quality.py",
  "src/analysis/__init__.py",
  "src/analysis/kpis.py",
  "src/models/__init__.py",
  "src/models/baseline.py",
  "src/visualization/__init__.py",
  "src/visualization/charts.py",
  "src/ai/__init__.py",
  "src/ai/interpretation.py",
  "scripts/run_pipeline.py",
  "scripts/train_baseline.py",
  "scripts/train_deep_learning.py",
  "tests/__init__.py"
)

foreach ($f in $files) {
  New-Item -ItemType File -Force $f | Out-Null
}
```

### Mac Terminal

[터미널]

```bash
mkdir -p src/data src/analysis src/models src/visualization src/ai
mkdir -p scripts tests notebooks
mkdir -p data/raw data/interim data/processed
mkdir -p reports artifacts/charts artifacts/models artifacts/metrics
mkdir -p config

touch src/__init__.py
touch src/data/__init__.py src/data/loading.py src/data/cleaning.py src/data/quality.py
touch src/analysis/__init__.py src/analysis/kpis.py
touch src/models/__init__.py src/models/baseline.py
touch src/visualization/__init__.py src/visualization/charts.py
touch src/ai/__init__.py src/ai/interpretation.py
touch scripts/run_pipeline.py scripts/train_baseline.py scripts/train_deep_learning.py
touch tests/__init__.py
```

---

## 6.4 구조가 만들어졌는지 확인한다

### Windows PowerShell

[터미널]

```powershell
Get-ChildItem -Recurse -Depth 2 | Select-Object FullName
```

### Mac Terminal

[터미널]

```bash
find . -maxdepth 3 -type d | sort
```

다음 폴더가 보이면 정상이다.

```text
src/data
src/analysis
src/models
src/visualization
src/ai
scripts
tests
notebooks
data/raw
data/processed
reports
artifacts
config
```

---

# 7. 실습 4-2 — Python 환경과 의존성 확인

## 7.1 pyproject.toml이 있는지 확인한다

uv는 Python 프로젝트의 패키지와 실행 환경을 관리한다. 3회차에서는 pandas와 numpy가 필요하다.

터미널에서 확인한다.

### Windows PowerShell

[터미널]

```powershell
dir pyproject.toml
```

### Mac Terminal

[터미널]

```bash
ls pyproject.toml
```

파일이 없으면 다음을 실행한다.

[터미널]

```bash
uv init --bare
```

> [!NOTE]
> `pyproject.toml`이 이미 있다면 `uv init --bare`는 실행하지 않아도 된다.

---

## 7.2 필요한 패키지를 추가한다

[터미널]

```bash
uv add pandas numpy pyyaml matplotlib scikit-learn pytest ruff
```

3회차에서 PyTorch를 바로 쓰지는 않는다. PyTorch는 딥러닝 회차에서 본격적으로 다룬다.

패키지가 정상적으로 추가되었는지 확인한다.

[터미널]

```bash
uv run python -c "import pandas as pd; import numpy as np; print('pandas', pd.__version__); print('numpy', np.__version__)"
```

정상이라면 pandas와 numpy 버전이 출력된다.

---

# 8. 실습 5 — 합성 데이터 생성

## 8.1 왜 합성 데이터를 만드는가

4회차에서는 pandas 기반 EDA를 진행한다. 그러려면 분석할 데이터가 필요하다.

실제 업무 데이터는 다음 문제가 있을 수 있다.

```text
개인정보가 있을 수 있다.
수업 중 공유하기 어렵다.
컬럼 구조가 학생마다 다르다.
EDA 실습을 통일하기 어렵다.
```

그래서 3회차에서는 온라인 쇼핑몰 매출 데이터를 흉내 낸 합성 데이터를 만든다.

합성 데이터에는 일부러 다음 문제가 들어간다.

```text
결측값
중복 행
이상값
범주형 변수
수치형 변수
날짜 변수
반품 여부 target
```

이 문제들은 4회차에서 데이터 품질검사와 EDA를 연습하는 재료가 된다.

---

## 8.2 AI에게 합성 데이터 생성 스크립트를 요청한다

[AI 코딩 도구]

```text
Create scripts/generate_sample_data.py.

The script must simulate online shopping sales data.

Requirements:

- Save output to data/raw/sales_sample.csv
- Generate at least 5,000 rows
- Use random seed 42
- Include these columns:
  - order_id
  - customer_id
  - order_date
  - region
  - channel
  - product_category
  - quantity
  - unit_price
  - discount_rate
  - revenue
  - returned
  - customer_age
- Include intentional missing values
- Include intentional duplicate rows
- Include intentional outliers
- Print the output path and final shape
- Do not modify any existing raw data file except creating this sample CSV
```

AI가 파일을 만들면 8.4로 넘어간다.

AI가 파일을 만들지 못하면 8.3의 코드를 직접 붙여넣는다.

---

## 8.3 직접 붙여넣을 코드

`scripts/generate_sample_data.py` 파일을 열고 아래 코드를 붙여넣는다.

### Windows에서 파일 열기

[터미널]

```powershell
notepad scripts/generate_sample_data.py
```

### Mac에서 파일 열기

[터미널]

```bash
nano scripts/generate_sample_data.py
```

아래 내용을 붙여넣는다.

[파일 내용: `scripts/generate_sample_data.py`]

```python
"""Generate synthetic sales data for the AI/Data Lab.

The generated dataset is intentionally imperfect.
It includes missing values, duplicate rows, and outliers so that
students can practice data quality checks and EDA in later sessions.
"""

from __future__ import annotations

from pathlib import Path

import numpy as np
import pandas as pd

RANDOM_SEED = 42
N_ROWS = 6_000
OUTPUT_PATH = Path("data/raw/sales_sample.csv")


def main() -> None:
    """Create synthetic online shopping sales data."""
    rng = np.random.default_rng(RANDOM_SEED)

    order_id = np.arange(1, N_ROWS + 1)
    customer_id = rng.integers(1000, 3500, size=N_ROWS)

    date_range = pd.date_range("2025-01-01", "2025-12-31", freq="D")
    order_date = rng.choice(date_range, size=N_ROWS)

    regions = np.array(["Seoul", "Busan", "Daegu", "Incheon", "Gwangju", "Daejeon", "Jeju"])
    channels = np.array(["web", "mobile", "offline", "partner"])
    categories = np.array(["electronics", "fashion", "beauty", "home", "food", "sports"])

    region = rng.choice(regions, size=N_ROWS, p=[0.36, 0.15, 0.10, 0.14, 0.08, 0.10, 0.07])
    channel = rng.choice(channels, size=N_ROWS, p=[0.32, 0.44, 0.16, 0.08])
    product_category = rng.choice(categories, size=N_ROWS, p=[0.18, 0.22, 0.16, 0.18, 0.14, 0.12])

    quantity = rng.integers(1, 6, size=N_ROWS)

    price_means = {
        "electronics": 180_000,
        "fashion": 65_000,
        "beauty": 38_000,
        "home": 90_000,
        "food": 22_000,
        "sports": 75_000,
    }
    unit_price = np.array([
        max(5_000, rng.normal(price_means[cat], price_means[cat] * 0.25))
        for cat in product_category
    ]).round(0)

    discount_rate = rng.choice(
        np.array([0.0, 0.05, 0.10, 0.15, 0.20, 0.30]),
        size=N_ROWS,
        p=[0.30, 0.20, 0.22, 0.14, 0.10, 0.04],
    )

    revenue = (quantity * unit_price * (1 - discount_rate)).round(0)
    customer_age = np.clip(rng.normal(38, 12, size=N_ROWS).round(0), 15, 75)

    # Return probability is intentionally related to several columns.
    category_effect = np.select(
        [
            product_category == "fashion",
            product_category == "electronics",
            product_category == "food",
        ],
        [0.10, 0.06, -0.04],
        default=0.0,
    )
    channel_effect = np.select(
        [channel == "mobile", channel == "offline"],
        [0.03, -0.03],
        default=0.0,
    )
    discount_effect = np.where(discount_rate >= 0.20, 0.05, 0.0)
    base_prob = 0.12 + category_effect + channel_effect + discount_effect
    return_prob = np.clip(base_prob, 0.03, 0.45)
    returned = rng.binomial(1, return_prob)

    df = pd.DataFrame(
        {
            "order_id": order_id,
            "customer_id": customer_id,
            "order_date": pd.to_datetime(order_date).strftime("%Y-%m-%d"),
            "region": region,
            "channel": channel,
            "product_category": product_category,
            "quantity": quantity,
            "unit_price": unit_price,
            "discount_rate": discount_rate,
            "revenue": revenue,
            "returned": returned,
            "customer_age": customer_age,
        }
    )

    # Intentional missing values.
    for col, missing_rate in {
        "region": 0.02,
        "customer_age": 0.03,
        "discount_rate": 0.01,
    }.items():
        mask = rng.random(N_ROWS) < missing_rate
        df.loc[mask, col] = pd.NA

    # Intentional outliers.
    outlier_price_idx = rng.choice(df.index, size=15, replace=False)
    df.loc[outlier_price_idx, "unit_price"] = df.loc[outlier_price_idx, "unit_price"] * 8
    df.loc[outlier_price_idx, "revenue"] = (
        df.loc[outlier_price_idx, "quantity"]
        * df.loc[outlier_price_idx, "unit_price"]
        * (1 - df.loc[outlier_price_idx, "discount_rate"].fillna(0))
    ).round(0)

    outlier_quantity_idx = rng.choice(df.index, size=10, replace=False)
    df.loc[outlier_quantity_idx, "quantity"] = 100
    df.loc[outlier_quantity_idx, "revenue"] = (
        df.loc[outlier_quantity_idx, "quantity"]
        * df.loc[outlier_quantity_idx, "unit_price"]
        * (1 - df.loc[outlier_quantity_idx, "discount_rate"].fillna(0))
    ).round(0)

    # Intentional duplicate rows.
    duplicate_rows = df.sample(n=50, random_state=RANDOM_SEED)
    df = pd.concat([df, duplicate_rows], ignore_index=True)

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(OUTPUT_PATH, index=False)

    print(f"Saved: {OUTPUT_PATH}")
    print(f"Shape: {df.shape}")
    print("Missing values:")
    print(df.isna().sum())
    print(f"Duplicate rows: {df.duplicated().sum()}")


if __name__ == "__main__":
    main()
```

Mac에서 `nano`를 사용했다면 저장은 다음 순서로 한다.

```text
Ctrl + O
Enter
Ctrl + X
```

---

## 8.4 생성 스크립트를 실행한다

[터미널]

```bash
uv run python scripts/generate_sample_data.py
```

정상이라면 다음과 비슷한 결과가 나온다.

```text
Saved: data/raw/sales_sample.csv
Shape: (6050, 12)
Missing values:
...
Duplicate rows: 50
```

---

## 8.5 데이터 파일이 생겼는지 확인한다

### Windows PowerShell

[터미널]

```powershell
dir data\raw
```

### Mac Terminal

[터미널]

```bash
ls data/raw
```

다음 파일이 보여야 한다.

```text
sales_sample.csv
```

데이터의 크기를 바로 확인한다.

[터미널]

```bash
uv run python -c "import pandas as pd; df = pd.read_csv('data/raw/sales_sample.csv'); print(df.shape); print(df.head())"
```

행 수가 5,000개 이상이면 성공이다.

---

# 9. 실습 6 — analysis_config.yaml 작성

## 9.1 config 파일이 필요한 이유

코드 안에 경로, 변수 이름, 모델 설정을 직접 쓰면 프로젝트가 금방 지저분해진다.

나쁜 방식:

```python
df = pd.read_csv("data/raw/sales_sample.csv")
target = "returned"
test_ratio = 0.2
```

이런 값들이 여러 파일에 흩어지면 나중에 수정하기 어렵다.

좋은 방식:

```text
config/analysis_config.yaml에 경로와 설정을 모아 둔다.
코드는 config를 읽어서 사용한다.
```

즉, config의 역할은 다음과 같다.

```text
코드는 범용으로 유지한다.
프로젝트별 설정은 config에 모은다.
```

---

## 9.2 AI에게 config 파일 생성을 요청한다

[AI 코딩 도구]

```text
Create config/analysis_config.yaml for this AI/Data Lab.

It must include:

- project name
- raw data path
- processed data path
- target variable: returned
- numeric features
- categorical features
- date column
- modeling options: test_ratio 0.2, seed 42
- output paths for charts, models, metrics, and reports
- AI interpretation option with enabled false by default

Use the columns in data/raw/sales_sample.csv.
```

AI가 파일을 만들면 9.4로 넘어간다.

AI가 파일을 만들지 못하면 9.3의 내용을 직접 붙여넣는다.

---

## 9.3 직접 붙여넣을 config 파일

`config/analysis_config.yaml` 파일을 연다.

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

아래 내용을 붙여넣는다.

[파일 내용: `config/analysis_config.yaml`]

```yaml
project:
  name: "AI Data Lab"
  description: "Python-first data analysis and AI algorithm implementation project"

paths:
  raw_data: "data/raw/sales_sample.csv"
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

ai_interpretation:
  enabled: false
  provider: null
  model: null
  output_file: "reports/ai_interpretation.md"
```

---

## 9.4 config 파일이 읽히는지 확인한다

[터미널]

```bash
uv run python -c "import yaml; from pathlib import Path; cfg = yaml.safe_load(Path('config/analysis_config.yaml').read_text(encoding='utf-8')); print(cfg['project']['name']); print(cfg['data']['target'])"
```

정상이라면 다음과 비슷하게 나온다.

```text
AI Data Lab
returned
```

---

# 10. GitHub에 올리기 전 안전 규칙

## 10.1 실제 개인정보 데이터는 올리지 않는다

GitHub에 올리는 프로젝트에는 개인정보가 들어가면 안 된다.

올리면 안 되는 예:

```text
실명
전화번호
주소
이메일
주민번호
건강정보
실제 성적 데이터
실제 고객 식별 정보
```

오늘 만든 `data/raw/sales_sample.csv`는 합성 데이터이므로 수업용으로 사용할 수 있다. 하지만 실제 데이터를 사용할 때는 반드시 익명화하거나 업로드하지 않는다.

---

## 10.2 .gitignore를 확인한다

AI 코딩 도구에 다음을 요청한다.

[AI 코딩 도구]

```text
Create or update .gitignore for this Python data analysis project.

It should ignore:
- .venv/
- __pycache__/
- .pytest_cache/
- .ruff_cache/
- large model files
- temporary files
- real private data files

Do not ignore data/raw/sales_sample.csv because it is synthetic sample data for class.
```

직접 만들려면 `.gitignore` 파일에 아래 내용을 넣는다.

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

# Temporary data
*.tmp
*.log

# Large or generated artifacts
artifacts/models/*.pkl
artifacts/models/*.pt
artifacts/models/*.pth

# Private real-world data
# Keep synthetic class data, but do not commit private datasets.
data/raw/private_*
data/raw/*personal*
data/raw/*confidential*
```

---

# 11. 오늘의 최종 품질 게이트

3회차가 끝나기 전에 다음을 모두 확인한다.

## 11.1 문서 게이트

```text
[ ] _bmad-output/architecture.md 또는 architecture 관련 산출물이 있다.
[ ] Epic/Story 산출물이 있다.
[ ] 구현 준비도 검증을 실행했다.
[ ] PASS 또는 수정 가능한 CONCERNS 상태다.
```

## 11.2 repo 구조 게이트

```text
[ ] src/data/가 있다.
[ ] src/analysis/가 있다.
[ ] src/models/가 있다.
[ ] src/visualization/가 있다.
[ ] src/ai/가 있다.
[ ] scripts/가 있다.
[ ] tests/가 있다.
[ ] notebooks/가 있다.
[ ] data/raw/가 있다.
[ ] reports/가 있다.
[ ] artifacts/가 있다.
[ ] config/가 있다.
```

## 11.3 데이터 게이트

```text
[ ] scripts/generate_sample_data.py가 있다.
[ ] uv run python scripts/generate_sample_data.py가 실행된다.
[ ] data/raw/sales_sample.csv가 생성된다.
[ ] 데이터가 5,000행 이상이다.
[ ] 결측값, 중복, 이상값이 일부러 포함되어 있다.
```

## 11.4 config 게이트

```text
[ ] config/analysis_config.yaml이 있다.
[ ] target이 returned로 설정되어 있다.
[ ] numeric_features가 있다.
[ ] categorical_features가 있다.
[ ] test_ratio가 0.2로 설정되어 있다.
[ ] random_seed가 42로 설정되어 있다.
```

AI 코딩 도구에서 한 번에 점검하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Check the current project against the Session 3 quality gates:

1. architecture output exists
2. epics/stories output exists
3. readiness check was completed
4. standard repo folders exist
5. scripts/generate_sample_data.py exists
6. data/raw/sales_sample.csv exists and has at least 5,000 rows
7. config/analysis_config.yaml exists and defines target, features, paths, test_ratio, and random_seed

Return PASS, CONCERNS, or FAIL.
For any concern, tell me the exact fix.
```

---

# 12. GitHub에 커밋하기

## 12.1 현재 변경 사항 확인

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

## 12.2 파일 추가와 커밋

[터미널]

```bash
git add .
git commit -m "Add session 3 architecture, repo structure, sample data, and config"
```

커밋이 성공하면 3회차 작업이 저장된 것이다.

> [!IMPORTANT]
> 실제 개인정보나 민감정보가 있는 데이터는 커밋하지 않는다. 오늘 만든 `sales_sample.csv`는 합성 데이터이므로 수업용으로 사용할 수 있다.

---

# 13. 과제 안내

## 과제 1. README.md에 Analysis Rules 섹션 추가

README.md에 다음 섹션을 추가한다.

[파일 내용: `README.md`에 추가]

```md
## Analysis Rules

1. 원본 데이터는 수정하지 않는다.
2. 노트북은 탐색과 수업용으로만 사용한다.
3. 재사용 가능한 코드는 `src/`에 둔다.
4. 주요 결과는 스크립트로 재현 가능해야 한다.
5. 데이터 품질 문제, 가정, 한계를 문서화한다.
6. 상관관계를 인과관계처럼 표현하지 않는다.
7. 모델 성능은 baseline과 비교해서 해석한다.
```

AI 코딩 도구에 요청하려면 다음을 입력한다.

[AI 코딩 도구]

```text
Update README.md by adding an "Analysis Rules" section.

Include these rules:
1. Never modify raw data.
2. Use notebooks only for exploration and teaching.
3. Put reusable code in src/.
4. Make key outputs reproducible by scripts.
5. Document data quality issues, assumptions, and limitations.
6. Do not express correlation as causation.
7. Interpret model performance against a baseline.
```

---

## 과제 2. 데이터 첫인상 메모 작성

터미널에서 다음을 실행한다.

[터미널]

```bash
uv run python -c "import pandas as pd; df = pd.read_csv('data/raw/sales_sample.csv'); print(df.shape); print(df.describe(numeric_only=True))"
```

그다음 `reports/data_first_impression.md` 파일을 만든다.

### Windows PowerShell

[터미널]

```powershell
notepad reports\data_first_impression.md
```

### Mac Terminal

[터미널]

```bash
nano reports/data_first_impression.md
```

아래 양식을 채운다.

[파일 내용: `reports/data_first_impression.md`]

```md
# Data First Impression

## 1. 데이터 크기

- 행 수:
- 열 수:

## 2. 가장 먼저 눈에 띈 변수

- 변수 1:
- 변수 2:
- 변수 3:

## 3. 이상해 보이는 점

- 결측값:
- 중복:
- 이상값:

## 4. 4회차 EDA에서 확인하고 싶은 질문 3개

1.
2.
3.

## 5. 이 데이터로 답할 수 있을 것 같은가

- 답할 수 있을 것 같은 질문:
- 아직 어려워 보이는 질문:
- 추가로 필요한 데이터:
```

---

## 과제 3. EDA 질문 10개 중 3개 고르기

2회차에서 만든 EDA 질문 10개 중 3개를 고른다. 각 질문에 대해 다음을 적는다.

```text
1. 이 질문에 필요한 변수는 무엇인가?
2. sales_sample.csv에 그 변수가 있는가?
3. 어떤 계산이나 그래프가 필요한가?
4. 이 질문은 원인 질문인가, 관계/차이/패턴 질문인가?
```

예시:

```md
## EDA 질문 후보 1

질문:
채널별 반품률은 어떻게 다른가?

필요 변수:
channel, returned

데이터에 있는가:
있다.

필요한 분석:
channel별 returned 평균을 계산한다. returned가 0/1이면 평균은 반품률이 된다.

주의:
채널이 반품의 원인이라고 말하면 안 된다. 현재는 채널별 반품률 차이만 볼 수 있다.
```

---

# 14. 자주 생기는 문제와 해결법

## 14.1 `bmad-create-architecture`가 안 된다

가능한 원인:

```text
프로젝트 폴더 밖에서 AI 코딩 도구를 실행했다.
BMAD가 설치되지 않았다.
2회차 산출물이 없다.
```

해결:

[터미널]

```bash
pwd
```

프로젝트 폴더가 아니면 이동한다.

[터미널]

```bash
cd ~/ai-data-lab
```

다시 AI 코딩 도구를 실행한다.

[터미널]

```bash
gemini
```

또는:

```bash
claude
```

그다음:

[AI 코딩 도구]

```text
bmad-help
```

---

## 14.2 AI가 웹앱 구조를 만들려고 한다

이 프로젝트는 웹앱이 아니다. 즉시 멈추고 다음을 입력한다.

[AI 코딩 도구]

```text
Stop. This project is not a web application.
Read _bmad-output/project-context.md again.
Revise the recommendation for a Python-first reproducible AI/Data Lab.
Do not create frontend, backend server, routing, login, or web deployment structure.
```

---

## 14.3 `uv run python scripts/generate_sample_data.py`가 실패한다

먼저 pandas와 numpy가 설치되어 있는지 확인한다.

[터미널]

```bash
uv run python -c "import pandas; import numpy; print('ok')"
```

오류가 나오면 패키지를 설치한다.

[터미널]

```bash
uv add pandas numpy
```

다시 실행한다.

[터미널]

```bash
uv run python scripts/generate_sample_data.py
```

---

## 14.4 `config/analysis_config.yaml`을 읽을 때 오류가 난다

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

YAML은 들여쓰기가 중요하다. 탭 대신 공백 2칸을 사용한다.

---

## 14.5 readiness check가 계속 CONCERNS를 낸다

CONCERNS가 반복되면 문서가 서로 충돌하는 경우가 많다.

[AI 코딩 도구]

```text
Compare these documents:

- _bmad-output/project-context.md
- _bmad-output/PRD.md
- architecture output
- epics/stories output

Find contradictions.
Use project-context.md as the source of truth.
List exact revisions needed.
Do not revise anything that requires my decision without asking first.
```

---

# 15. 오늘 배운 것을 한 문장으로 정리하기

오늘의 핵심은 다음이다.

> Architecture는 PRD를 실제 코드 구조로 번역하는 설계도이고, Epic/Story는 그 설계도를 구현 가능한 작은 작업으로 나누는 장치다.

3회차의 흐름은 다음과 같다.

```text
PRD 확인
→ Architecture 작성
→ Epic/Story 생성
→ 구현 준비도 검증
→ repo 구조 생성
→ 합성 데이터 생성
→ config 작성
```

4회차부터는 오늘 만든 `data/raw/sales_sample.csv`를 사용해 pandas 기반 EDA와 데이터 품질검사를 시작한다.

---

# 16. 3회차 최종 체크리스트

수업이 끝나기 전에 스스로 확인한다.

```text
[ ] 2회차 산출물 4개가 존재한다.
[ ] bmad-create-architecture를 실행했다.
[ ] Architecture 문서가 생성되었다.
[ ] Epic과 Story의 차이를 설명할 수 있다.
[ ] bmad-create-epics-and-stories를 실행했다.
[ ] bmad-check-implementation-readiness를 실행했다.
[ ] PASS/CONCERNS/FAIL의 의미를 이해한다.
[ ] 표준 repo 구조가 생성되었다.
[ ] scripts/generate_sample_data.py가 생성되었다.
[ ] data/raw/sales_sample.csv가 생성되었다.
[ ] sales_sample.csv가 5,000행 이상이다.
[ ] config/analysis_config.yaml이 생성되었다.
[ ] README.md에 Analysis Rules를 추가할 수 있다.
[ ] reports/data_first_impression.md 과제를 이해했다.
```

---

## 부록 A. 오늘 사용하는 핵심 명령 모음

### 터미널 명령

```bash
pwd
ls _bmad-output
uv add pandas numpy pyyaml matplotlib scikit-learn pytest ruff
uv run python scripts/generate_sample_data.py
uv run python -c "import pandas as pd; df = pd.read_csv('data/raw/sales_sample.csv'); print(df.shape); print(df.head())"
git status
git add .
git commit -m "Add session 3 architecture, repo structure, sample data, and config"
```

### AI 코딩 도구 명령

```text
bmad-help
/clear
bmad-create-architecture
/clear
bmad-create-epics-and-stories
/clear
bmad-check-implementation-readiness
```

---

## 부록 B. 오늘의 핵심 용어

| 용어 | 뜻 |
|---|---|
| Architecture | PRD를 실제 코드 구조로 바꾸는 기술 설계도 |
| Epic | 큰 작업 묶음. 책의 장에 해당 |
| Story | Epic 안의 작은 구현 단위. 책의 절에 해당 |
| Acceptance Criteria | Story가 완료되었다고 판단하는 기준 |
| Implementation Readiness | 실제 구현을 시작해도 되는지 검증하는 단계 |
| repo structure | 프로젝트 폴더와 파일의 표준 구조 |
| synthetic data | 실제 데이터가 아니라 연습을 위해 만든 합성 데이터 |
| config | 경로, 변수, 모델 설정 등을 코드 밖에 모아 둔 설정 파일 |
| source of truth | 여러 문서가 충돌할 때 기준이 되는 문서. 이 수업에서는 project-context.md |

