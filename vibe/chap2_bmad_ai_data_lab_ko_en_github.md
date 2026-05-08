# 2차시 수업교안: BMAD로 Python-first AI/Data Lab 프로젝트 체계 만들기

> 대상: 데이터분석, 머신러닝, 딥러닝 프로젝트를 만들고 싶은 학습자  
> 핵심 흐름: `context → product brief → PRD`  
> 최종 산출물: `project-context.md`, `product-brief.md`, `PRD.md`, `README.md`

---

## 0. 오늘 수업의 목적

2차시의 목표는 코드를 많이 작성하는 것이 아니다. 2차시의 목표는 **AI가 앞으로 어떤 기준으로 코드를 작성해야 하는지 정하는 것**이다.

AI에게 바로 이렇게 말하면 프로젝트는 금방 흔들린다.

```text
데이터분석 프로젝트 만들어줘.
```

이 말에는 중요한 결정이 빠져 있다.

```text
이 프로젝트는 웹앱인가, 데이터분석 프로젝트인가?
노트북 중심인가, src 코드 중심인가?
원본 데이터는 어디에 둘 것인가?
전처리된 데이터는 어디에 저장할 것인가?
분석 결과는 어떻게 다시 만들 것인가?
머신러닝은 언제 시작할 것인가?
딥러닝은 어디까지 할 것인가?
AI API는 어디에 쓸 것인가?
```

그래서 2차시에서는 코드를 작성하기 전에 세 가지 문서를 만든다.

```text
1. project-context.md
2. product-brief.md
3. PRD.md
```

이 세 문서가 있어야 3차시에서 `architecture`, `epic`, `story`, `repo 구조`를 안정적으로 만들 수 있다.

---

## 1. 오늘 끝나면 있어야 하는 파일

프로젝트 폴더 안에 다음 파일들이 있어야 한다.

```text
_bmad-output/
├── brainstorming-report.md     # 1차시 산출물
├── project-context.md          # 2차시 산출물 1
├── product-brief.md            # 2차시 산출물 2
└── PRD.md                      # 2차시 산출물 3

README.md                       # 과제로 보완할 파일
```

일부 BMAD 환경에서는 브레인스토밍 결과가 다음처럼 다른 위치에 저장될 수 있다.

```text
docs/brainstorming/brainstorming-session-YYYY-MM-DD.md
```

이 경우 실패가 아니다. 수업 자료와 맞추기 위해 AI 코딩 도구에게 다음처럼 요청하면 된다.

```text
현재 브레인스토밍 결과가 docs/brainstorming/ 폴더에 저장되어 있습니다.
수업 산출물 구조와 맞추기 위해 _bmad-output 폴더를 만들고,
기존 브레인스토밍 내용을 바탕으로 _bmad-output/brainstorming-report.md를 만들어 주세요.
```

---

## 2. 입력 위치를 먼저 구분한다

처음 배우는 사람이 가장 많이 헷갈리는 부분은 **이 명령을 어디에 입력해야 하는가**이다.

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | PowerShell, Mac Terminal | `cd ai-data-lab` |
| `[AI 코딩 도구]` | Claude Code 또는 Gemini CLI 안 | `bmad-help` |
| `[파일 내용]` | Markdown 파일 안에 들어갈 글 | `# Project Context` |

앞으로 이 자료에서는 명령 앞에 입력 위치를 붙인다.

예를 들어 다음은 터미널에 입력한다.

```powershell
cd ai-data-lab
```

다음은 Claude Code 또는 Gemini CLI 안에 입력한다.

```text
bmad-help
```

---

# Part A. 수업 시작 준비

## 3. 터미널 열기

### Windows: PowerShell 열기

```text
1. Windows 키를 누른다.
2. PowerShell이라고 입력한다.
3. Windows PowerShell을 클릭한다.
```

PowerShell이 열리면 보통 이런 모양이다.

```powershell
PS C:\Users\내이름>
```

### Mac: Terminal 열기

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

Mac 터미널은 보통 이런 모양이다.

```bash
내이름@MacBook ~ %
```

---

## 4. 프로젝트 폴더로 이동하기

이 자료에서는 프로젝트 폴더 이름을 `ai-data-lab`이라고 가정한다. 본인의 폴더 이름이 다르면 실제 폴더 이름을 사용한다.

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

```text
C:\Users\내이름\ai-data-lab
```

또는:

```text
/Users/내이름/ai-data-lab
```

프로젝트 폴더가 아직 없다면 새로 만든다.

```bash
cd ~
mkdir ai-data-lab
cd ai-data-lab
```

---

## 5. 1차시 산출물 확인하기

터미널에서 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 파일이 보이면 정상이다.

```text
brainstorming-report.md
```

만약 `_bmad-output` 폴더가 없다고 나오면, 먼저 폴더를 만든다.

### Windows PowerShell

```powershell
mkdir _bmad-output
```

### Mac Terminal

```bash
mkdir -p _bmad-output
```

브레인스토밍 파일이 없다면 AI 코딩 도구 안에서 먼저 실행한다.

```text
/clear
bmad-brainstorming
```

---

## 6. BMAD 설치와 연결 확인

프로젝트 폴더 안에서 BMAD가 설치되어 있는지 확인한다.

```bash
pwd
```

`pwd` 결과가 프로젝트 폴더인지 확인한 뒤, 필요하면 BMAD를 설치한다.

```bash
npx bmad-method install
```

설치 마법사가 질문하면 다음 기준으로 답한다.

| 마법사 질문 | 답변 | 이유 |
|---|---|---|
| Where should BMad files be installed? | Current directory | 지금 프로젝트 폴더에 설치 |
| Select modules to install | BMad Method | 핵심 BMAD workflow 사용 |
| Select tools to configure | Claude Code 또는 Gemini | 사용하는 AI 코딩 도구와 연결 |
| Shard PRD and Architecture? | Yes | 긴 문서를 AI가 다루기 쉽게 분리 |
| 나머지 질문 | Enter | 기본값 사용 |

선택 화면에서는 보통 다음 키를 사용한다.

```text
위/아래 화살표: 이동
Space: 선택 또는 선택 해제
Enter: 확정
```

---

## 7. AI 코딩 도구 실행

Gemini CLI를 사용하는 경우:

```bash
gemini
```

Claude Code를 사용하는 경우:

```bash
claude
```

AI 코딩 도구가 열리면 다음을 입력한다.

```text
bmad-help
```

정상이라면 BMAD가 현재 프로젝트 상태와 다음 단계를 안내한다.

---

# Part B. 오늘 만드는 세 문서

## 8. 세 문서의 역할

| 문서 | 쉬운 비유 | 핵심 질문 | 작성 방식 |
|---|---|---|---|
| `project-context.md` | 프로젝트의 헌법 | 모든 AI가 따라야 할 규칙은? | 직접 작성하고 AI가 다듬음 |
| `product-brief.md` | 기획서 | 무엇을 왜 만드는가? | Mary와 대화하며 작성 |
| `PRD.md` | 계약서 | 구체적으로 무엇을 어떻게 만들 것인가? | John과 대화하며 작성 |

`project-context.md`는 AI가 마음대로 바꾸면 안 되는 기준 문서다.  
`product-brief.md`는 프로젝트의 목적과 배경을 설명하는 문서다.  
`PRD.md`는 구현할 요구사항과 성공 기준을 정하는 문서다.

---

## 9. Quick Flow를 쓰지 않는 이유

Quick Flow는 작고 명확한 작업에 적합하다.

```text
작은 버그 수정
간단한 기능 추가
이미 요구사항이 매우 명확한 짧은 작업
```

하지만 이 수업의 AI/Data Lab은 8주 동안 다음을 다룬다.

```text
데이터 수집
EDA
전처리
scikit-learn baseline 모델
PyTorch 딥러닝
AI API 기반 자동 해석
보고서 작성
재현 가능한 파이프라인
```

따라서 바로 코드를 만들지 않고 전체 BMAD 흐름을 따른다.

```text
Analysis → Planning → Solutioning → Implementation
```

2차시는 이 중 앞부분을 다룬다.

```text
Analysis + Planning
```

---

# Part C. 실습 1: project-context.md 만들기

## 10. project-context.md에 들어가야 하는 항목

Python-first AI/Data Lab의 `project-context.md`에는 최소한 다음 항목이 들어간다.

```text
1. Project Type
2. Core Stack
3. Notebook Policy
4. Data Policy
5. Reproducibility Policy
6. AI Collaboration Policy
```

각 항목의 의미는 다음과 같다.

| 항목 | 의미 |
|---|---|
| Project Type | 이 프로젝트가 어떤 종류의 프로젝트인지 정의 |
| Core Stack | 사용할 핵심 도구와 라이브러리 |
| Notebook Policy | 노트북과 src 코드의 역할 구분 |
| Data Policy | 원본 데이터와 정제 데이터 저장 규칙 |
| Reproducibility Policy | 결과를 다시 만들 수 있게 하는 규칙 |
| AI Collaboration Policy | AI가 협업할 때 지켜야 할 규칙 |

---

## 11. project-context.md 한국어 예시

아래 예시는 **한국어 버전**이다. 한국어로 작성해도 AI는 이해할 수 있다. 다만 코드, 폴더명, 파일명은 영어를 유지하는 것이 좋다.

```md
# AI 에이전트를 위한 프로젝트 맥락

## 1. 프로젝트 유형

이 프로젝트는 Python-first AI/Data Lab이다.
웹 애플리케이션이 아니다.
목표는 재현 가능한 데이터분석과 AI 알고리즘 구현이다.

## 2. 핵심 도구

- Claude Code 또는 Gemini CLI를 주요 AI 코딩 도구로 사용한다.
- BMAD를 프로젝트 workflow 계층으로 사용한다.
- ChatGPT Projects를 분석 보조 공간으로 사용한다.
- Claude API 또는 Gemini API는 분석 결과 자동 해석 기능에 사용할 수 있다.
- Python 3.11, uv, pandas, matplotlib, scikit-learn, PyTorch, pytest, ruff를 사용한다.

## 3. 노트북 사용 규칙

- notebooks/는 탐색과 수업용으로 사용한다.
- 반복해서 사용할 로직은 src/에 작성한다.
- notebooks/는 src/에 있는 함수를 불러와 사용하는 방식으로 작성한다.

## 4. 데이터 관리 규칙

- data/raw/ 안의 원본 데이터는 절대 수정하지 않는다.
- 정제된 데이터는 data/processed/에 저장한다.
- 임시 데이터는 data/interim/에 저장한다.
- 보고서는 reports/에 저장한다.
- 모델, 차트, 평가 지표는 artifacts/에 저장한다.

## 5. 재현성 규칙

- 중요한 결과물은 스크립트를 실행해서 다시 만들 수 있어야 한다.
- scripts/run_pipeline.py는 전체 분석 실행 진입점이다.
- scripts/train_baseline.py는 scikit-learn 모델 학습 진입점이다.
- scripts/train_deep_learning.py는 PyTorch 딥러닝 모델 학습 진입점이다.
- 절대 경로를 사용하지 않는다.
- 문서화되지 않은 수작업 단계를 만들지 않는다.

## 6. AI 협업 규칙

AI 에이전트는 다음 규칙을 지켜야 한다.

- 데이터 구조가 불명확하면 먼저 질문한다.
- 데이터 품질 위험을 문서화한다.
- 탐색용 코드와 재사용 가능한 코드를 구분한다.
- 재사용 가능한 함수에는 테스트를 작성한다.
- 큰 변경을 하기 전에는 장단점을 설명한다.
```

---

## 12. project-context.md English example

아래 예시는 같은 내용을 영어로 쓴 버전이다. 실제 프로젝트에서는 한국어 또는 영어 중 하나를 선택해도 된다. 팀원이 영어 문서에 익숙하거나 AI 도구가 영어 지시를 더 안정적으로 처리하길 원한다면 영어 버전을 사용한다.

```md
# Project Context for AI Agents

## 1. Project Type

This is a Python-first AI/Data Lab.
It is not a web application.
The goal is reproducible data analysis and AI algorithm implementation.

## 2. Core Stack

- Claude Code or Gemini CLI as the main AI coding tool
- BMAD as the project workflow layer
- ChatGPT Projects as the analysis support layer
- Claude API or Gemini API for automated interpretation within the pipeline
- Python 3.11, uv, pandas, matplotlib, scikit-learn, PyTorch, pytest, ruff

## 3. Notebook Policy

- notebooks/ is for exploration and teaching only.
- Reusable logic must live in src/.
- Notebooks should call functions from src/.

## 4. Data Policy

- Never modify files in data/raw/.
- Cleaned data goes to data/processed/.
- Temporary data goes to data/interim/.
- Reports go to reports/.
- Models, charts, metrics go to artifacts/.

## 5. Reproducibility Policy

- All key outputs must be regenerated by scripts.
- scripts/run_pipeline.py is the main analysis entry point.
- scripts/train_baseline.py is the scikit-learn entry point.
- scripts/train_deep_learning.py is the PyTorch entry point.
- No absolute paths.
- No undocumented manual steps.

## 6. AI Collaboration Policy

AI agents must:

- ask for assumptions when the data schema is unclear,
- document data quality risks,
- separate exploratory and production-like code,
- generate tests for reusable functions,
- explain tradeoffs before large changes.
```

---

## 13. 실제 파일 만들기

먼저 `_bmad-output` 폴더가 있는지 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

없으면 만든다.

```powershell
mkdir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

없으면 만든다.

```bash
mkdir -p _bmad-output
```

그다음 AI 코딩 도구 안에서 입력한다.

```text
Create _bmad-output/project-context.md.
Use the Korean version below as the main content.
Also include the English version as a reference section at the bottom.
Do not change the intent.
This project is a Python-first AI/Data Lab, not a web application.

[여기에 한국어 예시와 영어 예시를 붙여넣기]
```

AI가 파일을 만들었다고 하면 확인한다.

```text
Show me _bmad-output/project-context.md.
Check whether it clearly says this is not a web application.
```

AI가 파일을 못 만들면 직접 만든다.

### Windows PowerShell

```powershell
notepad _bmad-output\project-context.md
```

### Mac Terminal

```bash
nano _bmad-output/project-context.md
```

---

## 14. project-context.md 품질 체크

다음에 모두 “예”라고 답할 수 있어야 한다.

```text
[ ] 이 프로젝트가 웹앱이 아니라고 명확히 적혀 있는가?
[ ] Python-first 데이터분석 프로젝트라고 적혀 있는가?
[ ] notebooks/와 src/의 역할이 분리되어 있는가?
[ ] data/raw/를 수정하지 말라는 규칙이 있는가?
[ ] scripts/를 통한 재현성 규칙이 있는가?
[ ] AI가 모르는 것을 임의로 가정하지 말라는 규칙이 있는가?
```

부족한 부분이 있으면 AI 코딩 도구 안에서 입력한다.

```text
Revise _bmad-output/project-context.md.
Make the following points clearer:
- This is not a web application.
- notebooks/ is for exploration only.
- reusable logic must live in src/.
- data/raw/ must never be modified.
- AI agents must ask when assumptions are unclear.
```

---

# Part D. 실습 2: product-brief.md 만들기

## 15. Product Brief란 무엇인가

Product Brief는 프로젝트의 기획서다. 아직 세부 구현 문서가 아니다.

Product Brief는 다음 질문에 답한다.

```text
무엇을 만들 것인가?
왜 만들 것인가?
누가 사용할 것인가?
어떤 문제를 해결할 것인가?
성공하면 무엇이 달라지는가?
이번 버전에서 하지 않을 것은 무엇인가?
```

---

## 16. product brief 실행

새로운 BMAD workflow를 시작할 때는 새 세션을 여는 것이 좋다.

AI 코딩 도구 안에서 입력한다.

```text
/clear
```

그다음 입력한다.

```text
bmad-product-brief
```

또는 slash command가 보이는 환경이면 다음처럼 입력할 수 있다.

```text
/bmad-product-brief
```

---

## 17. Mary에게 답할 때 사용할 한국어 답변 예시

Mary가 프로젝트 배경을 물으면 이렇게 답할 수 있다.

```text
이 프로젝트는 데이터를 분석하고, 머신러닝과 딥러닝으로 확장하는 Python-first AI/Data Lab입니다.
초기 버전에서는 CSV 데이터를 사용하여 pandas 기반 EDA를 수행하고,
scikit-learn으로 baseline 모델을 만들고,
후반 단계에서 PyTorch 딥러닝 구현으로 확장합니다.
웹앱, SQL 연결, 실시간 대시보드, 클라우드 배포는 초기 범위에서 제외합니다.
```

Mary가 성공 기준을 물으면 이렇게 답할 수 있다.

```text
성공 기준은 다음과 같습니다.
1. EDA 질문 10개 중 최소 5개에 대해 표나 그래프로 답합니다.
2. scikit-learn baseline 모델을 학습합니다.
3. 모델 평가는 F1-score, precision, recall 또는 RMSE 등 문제 유형에 맞는 지표를 사용합니다.
4. 주요 결과는 reports/summary.md에 정리합니다.
5. 전체 분석은 scripts/run_pipeline.py로 재실행 가능해야 합니다.
```

Mary가 범위를 물으면 이렇게 답할 수 있다.

```text
In Scope:
- CSV 기반 데이터 로딩
- pandas 기반 EDA
- 데이터 품질 확인
- scikit-learn baseline 모델
- PyTorch 기초 모델
- 분석 결과 보고서 작성

Out of Scope:
- 웹 애플리케이션 개발
- 실시간 대시보드
- SQL 데이터베이스 연결
- 클라우드 배포
- 대규모 MLOps
```

---

## 18. Mary에게 답할 때 사용할 English answer example

```text
This project is a Python-first AI/Data Lab for reproducible data analysis and AI algorithm implementation.
The initial version will use CSV-based data, pandas-based EDA, and scikit-learn baseline modeling.
Later phases will extend the project to PyTorch-based deep learning implementation.
The initial version will not include a web application, SQL database connection, real-time dashboard, cloud deployment, or large-scale MLOps.
```

```text
Success criteria:
1. Answer at least 5 out of 10 EDA questions using tables or visualizations.
2. Train a scikit-learn baseline model.
3. Evaluate the model with metrics appropriate for the task, such as F1-score, precision, recall, or RMSE.
4. Document the key findings in reports/summary.md.
5. Make the main analysis reproducible through scripts/run_pipeline.py.
```

---

## 19. product-brief.md 확인

대화가 끝나면 다음 파일이 있어야 한다.

```text
_bmad-output/product-brief.md
```

AI 코딩 도구 안에서 확인한다.

```text
Show me _bmad-output/product-brief.md.
Check whether it follows _bmad-output/project-context.md.
```

확인할 항목:

```text
[ ] 프로젝트 배경이 있는가?
[ ] 해결하려는 문제가 명확한가?
[ ] 누가 이 결과를 사용할지 적혀 있는가?
[ ] 성공 기준이 있는가?
[ ] 하지 않는 범위가 있는가?
[ ] 웹앱 프로젝트로 오해될 만한 문장이 없는가?
```

---

# Part E. 실습 3: PRD.md 만들기

## 20. PRD란 무엇인가

PRD는 Product Requirements Document의 약자다. 이 수업에서는 “분석 프로젝트 요구사항 문서”라고 이해하면 된다.

PRD에는 다음이 들어가야 한다.

```text
분석 목적
문제 정의
기능 요구사항
비기능 요구사항
데이터 요구사항
모델 요구사항
성공 기준
범위
리스크
과제
```

---

## 21. PRD 실행

AI 코딩 도구 안에서 입력한다.

```text
/clear
```

그다음 입력한다.

```text
bmad-create-prd
```

또는:

```text
/bmad-create-prd
```

---

## 22. John에게 줄 한국어 기준 문장

```text
이 PRD는 Python-first AI/Data Lab을 위한 문서입니다.
웹 애플리케이션이 아니라 재현 가능한 데이터분석 repo를 만드는 것이 목표입니다.

PRD에는 반드시 다음 항목을 포함해 주세요.

1. Executive Summary
2. Problem Statement
3. Functional Requirements
4. Non-functional Requirements
5. Data Requirements
6. Model Requirements
7. Success Criteria
8. In Scope
9. Out of Scope
10. Risks
11. Tasks

중요한 기준:
- data/raw/는 수정하지 않습니다.
- notebooks/는 탐색용입니다.
- 재사용 가능한 로직은 src/에 둡니다.
- 주요 결과는 scripts/run_pipeline.py로 재현 가능해야 합니다.
- 초기 모델은 scikit-learn baseline입니다.
- PyTorch deep learning은 후반 단계에서 다룹니다.
- 웹앱, SQL 연결, 실시간 대시보드, 클라우드 배포는 초기 범위에서 제외합니다.
```

---

## 23. English instruction for John

```text
This PRD is for a Python-first AI/Data Lab.
The goal is not to build a web application, but to build a reproducible data analysis repository.

The PRD must include:

1. Executive Summary
2. Problem Statement
3. Functional Requirements
4. Non-functional Requirements
5. Data Requirements
6. Model Requirements
7. Success Criteria
8. In Scope
9. Out of Scope
10. Risks
11. Tasks

Important constraints:
- Do not modify data/raw/.
- notebooks/ is for exploration only.
- Reusable logic must live in src/.
- Key outputs must be reproducible through scripts/run_pipeline.py.
- The first model should be a scikit-learn baseline.
- PyTorch deep learning will be handled in later phases.
- Web applications, SQL connections, real-time dashboards, and cloud deployment are out of scope for the initial version.
```

---

## 24. PRD 요구사항 예시

### Functional Requirements 예시

```text
FR1. CSV 데이터를 data/raw/에서 로딩할 수 있어야 한다.
FR2. 결측값, 중복 행, 이상값을 탐지할 수 있어야 한다.
FR3. EDA 차트 5종 이상을 생성해야 한다.
FR4. scikit-learn baseline 모델을 학습해야 한다.
FR5. 모델 평가 지표를 artifacts/metrics/에 저장해야 한다.
FR6. 주요 분석 결과를 reports/summary.md에 정리해야 한다.
```

### Non-functional Requirements 예시

```text
NFR1. 모든 주요 결과는 스크립트로 재생성 가능해야 한다.
NFR2. data/raw/의 원본 데이터는 수정하지 않는다.
NFR3. 재사용 가능한 로직은 src/에 작성한다.
NFR4. 주요 함수는 pytest 테스트를 포함한다.
NFR5. 절대 경로를 사용하지 않는다.
```

### Data Requirements 예시

```text
데이터 형식: CSV
원본 데이터 위치: data/raw/sample.csv
전처리 데이터 위치: data/processed/

필수 변수:
- id
- date
- category
- target
- numeric_feature_1
- numeric_feature_2
- categorical_feature_1
```

### Model Requirements 예시

```text
초기 모델: scikit-learn baseline model
타겟 변수: target
평가 지표: 문제 유형에 따라 F1-score, precision, recall, RMSE, MAE 중 선택
초기 성공 기준: baseline 대비 의미 있는 개선 또는 사전에 정한 최소 지표 달성
```

---

## 25. PRD 확인

AI 코딩 도구 안에서 입력한다.

```text
Show me _bmad-output/PRD.md.
Check whether it includes:
- Executive Summary
- Problem Statement
- Functional Requirements
- Non-functional Requirements
- Data Requirements
- Model Requirements
- Success Criteria
- In Scope / Out of Scope
- Risks
- Tasks
```

---

# Part F. PRD 자기 점검

## 26. PRD 품질 체크리스트

```text
[ ] 분석 목적이 한 문장으로 명확한가?
[ ] 기능 요구사항에 구체적인 작업 목록이 있는가?
[ ] 성공 기준에 측정 가능한 숫자가 있는가?
[ ] 범위에서 하지 않는 것이 명시되어 있는가?
[ ] 데이터 요구사항에 형식과 변수 목록이 있는가?
[ ] 리스크가 1개 이상 적혀 있는가?
[ ] 비전공자가 읽어도 이해할 수 있는가?
```

---

## 27. PRD가 모호할 때 수정 요청

```text
PRD.md가 아직 너무 모호합니다.
다음 기준으로 다시 보완해 주세요.

1. 측정 불가능한 형용사를 측정 가능한 기준으로 바꿔 주세요.
2. 모호한 동사를 구체적인 작업 동사로 바꿔 주세요.
3. 성공 기준에 숫자를 넣어 주세요.
4. 출력 파일 경로를 명시해 주세요.
5. In Scope와 Out of Scope를 분리해 주세요.
6. 데이터 품질, 모델 과적합, AI 해석 오류, 재현성 문제와 관련된 리스크를 추가해 주세요.
7. project-context.md와 충돌하지 않게 수정해 주세요.

수정 전에 내가 추가로 답해야 하는 질문이 있으면 먼저 물어봐 주세요.
```

---

# Part G. ChatGPT Projects 보조 공간 세팅

## 28. ChatGPT Projects의 역할

ChatGPT Projects는 코드 작성의 중심 도구가 아니다. 코드 작성과 파일 수정은 Gemini CLI 또는 Claude Code에서 한다.

ChatGPT Projects는 분석 보조 공간이다.

여기서 하는 일:

```text
분석 아이디어 정리
EDA 질문 목록 만들기
모델 평가 결과 해석
보고서 초안 작성
BMAD 문서 논리 검토
```

여기서 하지 않는 일:

```text
repo 파일 직접 수정
테스트 실행
BMAD workflow 실행
실제 파이프라인 실행
```

---

## 29. ChatGPT Projects 사용자 지정 지시

```text
이 프로젝트는 Python-first AI/Data Lab 구축을 위한 분석 보조 프로젝트이다.

역할:
- 데이터분석 아이디어 제안
- EDA 질문 정리
- 분석 리포트 초안 작성
- 모델 평가 결과 해석
- BMAD 문서의 논리 검토

원칙:
- AI 코딩 도구로 관리하는 repo가 source of truth이다.
- ChatGPT는 보조 분석가 역할이다.
- ChatGPT는 코드 파일을 직접 수정하지 않는다.
- ChatGPT는 분석 질문, 해석, 보고서 초안, 문서 검토를 돕는다.
- 모든 분석 해석은 데이터와 근거를 기준으로 해야 한다.
- 상관관계를 인과관계처럼 말하지 않는다.
- 불확실한 부분은 가정과 한계로 분리해서 설명한다.
```

---

# Part H. 과제: README.md 작성

## 30. README.md 생성 요청

AI 코딩 도구에 입력한다.

```text
Create or update README.md for this AI Data Lab project.
Use these files as the source of truth:
- _bmad-output/project-context.md
- _bmad-output/product-brief.md
- _bmad-output/PRD.md

README.md must include:
- Purpose
- Tools
- Project Structure
- How to Run
- Rules

Keep it beginner-friendly.
Do not invent tools or folders that are not in the project plan.
If something is planned but not implemented yet, mark it as planned.
```

---

## 31. README.md 기본 구조

````md
# AI Data Lab

## Purpose

이 프로젝트의 목적을 한 문단으로 설명한다.

## Tools

- BMAD
- Gemini CLI or Claude Code
- ChatGPT Projects
- Python 3.11
- uv
- pandas
- scikit-learn
- PyTorch

## Project Structure

- data/raw/: 원본 데이터
- data/processed/: 정제 데이터
- notebooks/: 탐색용 노트북
- src/: 재사용 가능한 코드
- scripts/: 실행 스크립트
- reports/: 보고서
- artifacts/: 차트, 모델, 메트릭

## How to Run

아직 전체 파이프라인이 없으면 다음처럼 적는다.

```bash
# planned
uv run python scripts/run_pipeline.py
```

## Rules

- data/raw/는 수정하지 않는다.
- 노트북은 탐색용이다.
- 재사용 가능한 코드는 src/에 둔다.
- 주요 결과는 스크립트로 재현 가능해야 한다.
- 가정과 한계를 문서화한다.
````

---

# Part I. 최종 확인

## 32. 파일 확인

터미널에서 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 파일이 보여야 한다.

```text
brainstorming-report.md
project-context.md
product-brief.md
PRD.md
```

AI 코딩 도구에서도 확인한다.

```text
Check whether the following files exist:

_bmad-output/brainstorming-report.md
_bmad-output/project-context.md
_bmad-output/product-brief.md
_bmad-output/PRD.md
README.md

If any file is missing, tell me exactly what command or workflow I should run next.
```

---

## 33. 2차시 품질 게이트

```text
[ ] project-context.md를 보고 이 프로젝트가 웹앱이 아니라는 점을 알 수 있다.
[ ] product-brief.md를 보고 무엇을 왜 만드는지 알 수 있다.
[ ] PRD.md를 보고 첫 번째 구현 작업을 시작할 수 있다.
[ ] PRD에 측정 가능한 성공 기준이 있다.
[ ] PRD에 하지 않는 범위가 있다.
[ ] data/raw/ 수정 금지 규칙이 있다.
[ ] README.md에 프로젝트 목적과 규칙이 적혀 있다.
```

---

# 부록. 한 장 요약

```text
1. 터미널 열기
2. 프로젝트 폴더로 이동
3. claude 또는 gemini 실행
4. bmad-help 실행
5. project-context.md 작성
6. /clear → bmad-product-brief
7. /clear → bmad-create-prd
8. PRD 품질 점검
9. ChatGPT Projects 보조 공간 세팅
10. README.md 작성
```
