# 2회차 학습자 실습 매뉴얼

# BMAD로 프로젝트 체계 만들기
## context → brief → PRD

---

## 이 자료의 목적

2회차의 목표는 코드를 많이 작성하는 것이 아니다. 2회차의 목표는 **AI가 앞으로 어떤 기준으로 코드를 작성해야 하는지 정하는 것**이다.

AI에게 바로 다음처럼 말하면 프로젝트는 금방 흔들린다.

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

따라서 2회차에서는 코드를 쓰기 전에 세 개의 문서를 만든다.

```text
1. _bmad-output/project-context.md
2. _bmad-output/product-brief.md
3. _bmad-output/PRD.md
```

이 세 문서가 있어야 3회차에서 architecture, epic, story, repo 구조를 안정적으로 만들 수 있다.

---

## 오늘 끝나면 있어야 하는 것

2회차가 끝나면 프로젝트 폴더 안에 다음 파일들이 있어야 한다.

```text
_bmad-output/
├── brainstorming-report.md     # 1회차 산출물
├── project-context.md          # 2회차 산출물 1
├── product-brief.md            # 2회차 산출물 2
└── PRD.md                      # 2회차 산출물 3

README.md                       # 과제로 보완할 파일
```

오늘의 핵심은 다음 한 문장이다.

> AI에게 코드를 시키기 전에, AI가 따라야 할 기준 문서를 먼저 만든다.

---

## 오늘 사용할 입력 위치를 구분하자

처음 배우는 사람이 가장 많이 헷갈리는 부분은 “이 명령을 어디에 입력해야 하는가”이다. 오늘은 입력 위치가 세 가지다.

| 표시 | 입력 위치 | 예시 |
|---|---|---|
| `[터미널]` | PowerShell, Mac Terminal | `cd ai-data-lab` |
| `[AI 코딩 도구]` | Gemini CLI 또는 Claude Code 안 | `bmad-help` |
| `[파일 내용]` | Markdown 파일 안에 들어갈 글 | `# Project Context for AI Agents` |

앞으로 이 자료에서는 모든 명령 앞에 입력 위치를 붙인다.

예를 들어 다음은 터미널에 입력하는 명령이다.

```powershell
cd ai-data-lab
```

다음은 Gemini CLI 또는 Claude Code 안에서 입력하는 말이다.

```text
bmad-help
```

---

# 0. 수업 시작 전 준비

## 0.1 터미널을 연다

Windows를 사용한다면 PowerShell을 연다.

```text
1. Windows 키를 누른다.
2. PowerShell이라고 입력한다.
3. Windows PowerShell을 클릭한다.
```

PowerShell이 열리면 보통 이런 모양이다.

```powershell
PS C:\Users\내이름>
```

Mac을 사용한다면 Terminal을 연다.

```text
1. Cmd + Space를 누른다.
2. Terminal 또는 터미널이라고 입력한다.
3. Enter를 누른다.
```

Mac 터미널이 열리면 보통 이런 모양이다.

```bash
내이름@MacBook ~ %
```

지금부터 터미널이라는 말은 Windows에서는 PowerShell, Mac에서는 Terminal을 뜻한다.

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

프로젝트 폴더가 없으면 아래처럼 만든다. 단, 1회차에서 이미 만들었다면 이 단계는 건너뛴다.

### Windows 또는 Mac 공통

```bash
cd ~
mkdir ai-data-lab
cd ai-data-lab
```

---

## 0.3 1회차 산출물이 있는지 확인한다

터미널에서 다음을 입력한다.

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

만약 `_bmad-output` 폴더나 `brainstorming-report.md`가 없다면 1회차 brainstorming이 끝나지 않은 것이다. 이 경우 AI 코딩 도구에서 1회차 workflow를 먼저 실행한다.

```text
/clear
bmad-brainstorming
```

---

# 1. BMAD 설치와 연결 확인

## 1.1 BMAD 설치가 되어 있는지 확인한다

터미널에서 다음을 입력한다.

### Windows PowerShell

```powershell
dir
```

### Mac Terminal

```bash
ls
```

폴더나 파일 목록 중에 BMAD 관련 폴더가 보이면 이미 설치되었을 가능성이 높다. 설치가 확실하지 않으면 다시 설치해도 된다.

BMAD 설치 명령은 다음과 같다.

```bash
npx bmad-method install
```

이 명령은 반드시 **프로젝트 폴더 안에서** 실행한다. 즉, `pwd` 결과가 `ai-data-lab`이어야 한다.

---

## 1.2 BMAD 설치 마법사 답변 가이드

설치 마법사가 질문을 하면 아래 기준으로 답한다.

| 마법사 질문 | 답변 | 이유 |
|---|---|---|
| Where should BMad files be installed? | Current directory | 지금 들어와 있는 프로젝트 폴더에 설치하기 위해 |
| Select modules to install | BMad Method 선택 | 핵심 BMAD workflow 사용 |
| Select tools to configure | Claude Code 또는 Gemini 선택 | 본인이 쓰는 AI 코딩 도구와 연결하기 위해 |
| Shard PRD and Architecture? | Yes | 긴 문서를 AI가 다루기 쉽게 나누기 위해 |
| 나머지 질문 | Enter | 기본값 사용 |

선택 화면에서는 보통 다음 키를 사용한다.

```text
위/아래 화살표: 이동
Space: 선택 또는 선택 해제
Enter: 확정
```

처음이라면 깊게 고민하지 말고 다음 기준을 사용한다.

```text
BMad Method 선택
본인이 쓰는 AI 도구 선택
Shard는 Yes
나머지는 Enter
```

---

## 1.3 AI 코딩 도구를 실행한다

Gemini CLI를 사용하는 경우 터미널에서 다음을 입력한다.

```bash
gemini
```

Claude Code를 사용하는 경우 다음을 입력한다.

```bash
claude
```

AI 코딩 도구가 열리면 이제 터미널 명령이 아니라 AI에게 말을 입력하는 상태다.

---

## 1.4 bmad-help를 실행한다

AI 코딩 도구 안에서 다음을 입력한다.

```text
bmad-help
```

정상이라면 AI가 현재 프로젝트 상태를 읽고 다음에 무엇을 해야 하는지 안내한다.

정상 반응 예시:

```text
현재 프로젝트는 신규 프로젝트입니다.
brainstorming-report.md가 확인되었습니다.
다음 단계로 product brief 또는 PRD 생성을 진행할 수 있습니다.
```

만약 반응이 이상하다면 대개 세 가지 이유다.

```text
1. 프로젝트 폴더 밖에서 AI 도구를 실행했다.
2. BMAD 설치 때 Gemini 또는 Claude를 선택하지 않았다.
3. BMAD가 설치되지 않았다.
```

이때는 AI 코딩 도구를 종료하고, 터미널에서 프로젝트 폴더로 다시 이동한 뒤 설치를 다시 확인한다.

```bash
cd ~/ai-data-lab
npx bmad-method install
```

---

# 2. 오늘 만드는 세 문서의 관계

오늘 만드는 세 문서는 역할이 다르다.

| 문서 | 쉬운 비유 | 핵심 질문 | 작성 방식 |
|---|---|---|---|
| `project-context.md` | 프로젝트의 헌법 | 모든 AI가 따라야 할 규칙은? | 직접 만들고 AI가 다듬음 |
| `product-brief.md` | 기획서 | 무엇을 왜 만드는가? | Mary와 대화하며 작성 |
| `PRD.md` | 계약서 | 구체적으로 무엇을 어떻게 만들 것인가? | John과 대화하며 작성 |

`project-context.md`는 AI가 마음대로 바꾸면 안 되는 기준 문서다. 이 프로젝트가 웹앱이 아니라 Python-first 데이터분석 프로젝트라는 점을 고정한다.

`product-brief.md`는 프로젝트의 목적을 설명한다. 왜 이 프로젝트가 필요한지, 누가 결과를 사용할지, 무엇이 성공인지 정리한다.

`PRD.md`는 구현할 요구사항을 구체화한다. 어떤 기능을 만들고, 어떤 데이터가 필요하고, 모델은 어떤 기준으로 평가할지 정리한다.

---

# 3. Quick Flow를 쓰지 않는 이유

BMAD에는 빠른 경로인 Quick Flow가 있다. Quick Flow는 작고 명확한 작업에 적합하다.

예를 들어 이런 경우에는 Quick Flow가 맞다.

```text
작은 버그 수정
간단한 기능 추가
이미 요구사항이 매우 명확한 짧은 작업
```

하지만 이 수업에서 만드는 AI/Data Lab은 작지 않다. 8주 동안 다음을 다룬다.

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

따라서 바로 코드를 만들면 안 된다. 전체 BMAD 흐름을 따른다.

```text
Analysis → Planning → Solutioning → Implementation
```

2회차는 이 중 앞부분을 다룬다.

```text
Analysis + Planning
```

---

# 4. 실습 1: project-context.md 만들기

## 4.1 이 파일이 중요한 이유

`project-context.md`는 프로젝트의 헌법이다. 이후 AI가 무엇을 하든 이 파일을 기준으로 삼아야 한다.

이 파일에는 다음이 들어간다.

```text
이 프로젝트는 웹앱이 아니다.
Python-first 데이터분석 프로젝트다.
노트북은 탐색과 수업용이다.
재사용 코드는 src/에 둔다.
data/raw/는 절대 수정하지 않는다.
결과는 스크립트로 재현 가능해야 한다.
AI는 모르는 것을 임의로 가정하지 말고 질문해야 한다.
```

---

## 4.2 먼저 폴더가 있는지 확인한다

터미널에서 다음을 입력한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

`_bmad-output` 폴더가 없으면 만든다.

### Windows PowerShell

```powershell
mkdir _bmad-output
```

### Mac Terminal

```bash
mkdir -p _bmad-output
```

---

## 4.3 AI에게 project-context.md 생성을 요청한다

AI 코딩 도구 안에서 다음을 입력한다.

```text
Create _bmad-output/project-context.md with the following content.
Do not change the intent.
This project is a Python-first AI/Data Lab, not a web application.
```

그다음 아래 내용을 그대로 붙여넣는다.

```md
# Project Context for AI Agents

## Project Type

This is a Python-first AI/Data Lab.
It is not a web application.
The goal is reproducible data analysis and AI algorithm implementation.

## Core Stack

- Claude Code or Gemini CLI as the main AI coding tool
- BMAD as the project workflow layer
- ChatGPT Projects as the analysis support layer
- Claude API or Gemini API for automated interpretation within the pipeline
- Python 3.11, uv, pandas, matplotlib, scikit-learn, PyTorch, pytest, ruff

## Notebook Policy

- notebooks/ is for exploration and teaching only.
- Reusable logic must live in src/.
- Notebooks should call functions from src/.

## Data Policy

- Never modify files in data/raw/.
- Cleaned data goes to data/processed/.
- Temporary data goes to data/interim/.
- Reports go to reports/.
- Models, charts, metrics go to artifacts/.

## Reproducibility Policy

- All key outputs must be regenerated by scripts.
- scripts/run_pipeline.py = analysis entry point.
- scripts/train_baseline.py = scikit-learn entry point.
- scripts/train_deep_learning.py = PyTorch entry point.
- No absolute paths.
- No undocumented manual steps.

## AI Collaboration Policy

AI agents must:

- ask for assumptions when data schema is unclear,
- document data quality risks,
- separate exploratory and production-like code,
- generate tests for reusable functions,
- explain tradeoffs before large changes.
```

AI가 파일을 만들었다고 하면 바로 믿지 말고 확인한다.

```text
Show me _bmad-output/project-context.md.
Check whether it clearly says this is not a web application.
```

---

## 4.4 AI가 파일을 못 만들 때: 직접 만드는 방법

가끔 AI 코딩 도구가 파일을 실제로 만들지 않고 내용만 보여줄 수 있다. 그때는 직접 파일을 만든다.

### Windows PowerShell에서 직접 만들기

터미널로 돌아와서 다음을 입력한다.

```powershell
notepad _bmad-output\project-context.md
```

메모장이 열리면 위의 Markdown 내용을 붙여넣고 저장한다.

### Mac Terminal에서 직접 만들기

터미널에서 다음을 입력한다.

```bash
nano _bmad-output/project-context.md
```

내용을 붙여넣고 저장한다.

```text
Ctrl + O  → 저장
Enter     → 파일명 확정
Ctrl + X  → nano 종료
```

저장 후 AI 코딩 도구에서 다시 확인한다.

```text
Read _bmad-output/project-context.md and summarize the rules in Korean.
```

---

## 4.5 project-context.md 품질 체크

다음 질문에 모두 “예”라고 답할 수 있어야 한다.

```text
[ ] 이 프로젝트가 웹앱이 아니라고 명확히 적혀 있는가?
[ ] Python-first 데이터분석 프로젝트라고 적혀 있는가?
[ ] notebooks/와 src/의 역할이 분리되어 있는가?
[ ] data/raw/를 수정하지 말라는 규칙이 있는가?
[ ] scripts/를 통한 재현성 규칙이 있는가?
[ ] AI가 모르는 것을 임의로 가정하지 말라는 규칙이 있는가?
```

하나라도 부족하면 AI에게 이렇게 요청한다.

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

# 5. 실습 2: product-brief.md 만들기

## 5.1 Product Brief는 무엇인가

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

BMAD에서는 Mary라는 Analyst 에이전트가 이 문서를 만드는 과정을 돕는다.

---

## 5.2 새 세션을 연다

AI 코딩 도구 안에서 다음을 입력한다.

```text
/clear
```

그다음 다음을 입력한다.

```text
bmad-product-brief
```

정상이라면 Mary가 질문을 시작한다.

---

## 5.3 Mary와 대화할 때의 원칙

Mary에게 답할 때는 완벽한 문장을 만들려고 하지 않아도 된다. 다만 너무 추상적으로 답하면 안 된다.

나쁜 답변:

```text
데이터분석을 잘하고 싶다.
```

좋은 답변:

```text
온라인 쇼핑몰 주문 데이터를 분석하여 반품률이 높은 제품군, 채널, 고객 특성을 찾고 싶다.
이후 반품 여부를 예측하는 baseline 모델을 만들고 싶다.
```

Mary가 질문하면 다음 기준으로 답한다.

| Mary의 질문 | 답변에 포함할 내용 |
|---|---|
| 프로젝트 배경은? | 왜 이 프로젝트가 필요한가 |
| 해결하려는 문제는? | 데이터로 확인할 수 있는 문제인가 |
| 최종 사용자는? | 누가 결과를 읽고 판단하는가 |
| 성공 기준은? | 가능하면 숫자나 산출물 포함 |
| 하지 않을 것은? | 웹앱, SQL, 배포 등 제외 범위 |

---

## 5.4 답변 예시: 반품 분석 프로젝트

Mary가 프로젝트 배경을 묻는다면 이렇게 답할 수 있다.

```text
온라인 쇼핑몰에서 반품이 늘고 있다.
어떤 제품군, 판매 채널, 고객 특성이 반품과 관련되는지 분석하고 싶다.
초기 버전에서는 CSV 데이터를 사용하여 pandas 기반 EDA를 수행하고,
scikit-learn으로 반품 여부를 예측하는 baseline 모델을 만들고 싶다.
웹앱, SQL 연결, 실시간 대시보드는 이번 범위에서 제외한다.
```

Mary가 성공 기준을 묻는다면 이렇게 답할 수 있다.

```text
성공 기준은 다음과 같다.
1. 반품 관련 EDA 질문 10개 중 5개 이상에 대해 표나 그래프로 답한다.
2. 반품 여부를 예측하는 scikit-learn baseline 모델을 만든다.
3. 모델 평가는 F1-score, precision, recall을 사용한다.
4. 주요 결과는 reports/summary.md에 정리한다.
5. 전체 분석은 scripts/run_pipeline.py로 재실행할 수 있어야 한다.
```

Mary가 범위를 묻는다면 이렇게 답할 수 있다.

```text
In Scope:
- CSV 기반 데이터 로딩
- pandas 기반 EDA
- 데이터 품질 확인
- scikit-learn baseline 모델
- 결과 보고서 작성

Out of Scope:
- 웹 애플리케이션
- 실시간 대시보드
- SQL 데이터베이스 연결
- 클라우드 배포
- 대규모 MLOps
```

---

## 5.5 product-brief.md 저장 확인

대화가 끝나면 다음 파일이 있어야 한다.

```text
_bmad-output/product-brief.md
```

AI 코딩 도구에 입력한다.

```text
Show me _bmad-output/product-brief.md.
Check whether it follows _bmad-output/project-context.md.
```

확인할 항목은 다음이다.

```text
[ ] 프로젝트 배경이 있는가?
[ ] 해결하려는 문제가 명확한가?
[ ] 누가 이 결과를 사용할지 적혀 있는가?
[ ] 성공 기준이 있는가?
[ ] 하지 않는 범위가 있는가?
[ ] 웹앱 프로젝트로 오해될 만한 문장이 없는가?
```

product brief가 웹앱처럼 쓰였으면 즉시 고친다.

```text
Revise _bmad-output/product-brief.md.
This project is not a web application.
Keep it focused on a Python-first reproducible AI/Data Lab.
```

---

# 6. 실습 3: PRD.md 만들기

## 6.1 PRD는 무엇인가

PRD는 Product Requirements Document의 약자다. 이 수업에서는 “분석 프로젝트 요구사항 문서”라고 이해하면 된다.

Product Brief가 방향을 정하는 문서라면, PRD는 구현 기준을 정하는 문서다.

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

PRD가 모호하면 3회차 Architecture도 모호해진다. 따라서 John에게 답할 때는 구체적인 숫자, 파일 경로, 출력물을 포함한다.

---

## 6.2 새 세션을 연다

AI 코딩 도구 안에서 다음을 입력한다.

```text
/clear
```

그다음 입력한다.

```text
bmad-create-prd
```

정상이라면 John이라는 PM 에이전트가 질문을 시작한다.

---

## 6.3 John에게 답할 때의 원칙

John에게는 Mary보다 더 구체적으로 답한다.

나쁜 답변:

```text
좋은 모델을 만들고 싶다.
```

좋은 답변:

```text
반품 여부를 예측하는 scikit-learn baseline classifier를 만든다.
타겟 변수는 returned이다.
평가 지표는 F1-score, precision, recall을 사용한다.
초기 목표는 F1-score 0.75 이상 또는 majority baseline 대비 20% 개선이다.
```

나쁜 답변:

```text
데이터를 잘 분석한다.
```

좋은 답변:

```text
CSV 데이터를 로딩하고, 결측값, 중복, 이상값을 점검한다.
EDA 차트 5종 이상을 생성한다.
주요 결과는 reports/eda_summary.md에 저장한다.
```

---

## 6.4 John에게 줄 기준 문장

John이 요구사항을 묻거나 PRD 초안을 만들려고 할 때 아래 내용을 기준으로 답한다. 본인의 프로젝트 주제에 맞게 바꿔도 된다.

```text
이 PRD는 Python-first AI/Data Lab을 위한 문서다.
웹 애플리케이션이 아니라 재현 가능한 데이터분석 repo를 만드는 것이 목표다.

PRD에는 반드시 다음 항목을 포함해줘.

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
- data/raw/는 수정하지 않는다.
- notebooks/는 탐색용이다.
- 재사용 가능한 로직은 src/에 둔다.
- 주요 결과는 scripts/run_pipeline.py로 재현 가능해야 한다.
- 초기 모델은 scikit-learn baseline이다.
- PyTorch deep learning은 후반 단계에서 다룬다.
- 웹앱, SQL 연결, 실시간 대시보드, 클라우드 배포는 초기 범위에서 제외한다.
```

---

## 6.5 PRD 요구사항 예시

아래 예시는 반품 분석 프로젝트 기준이다. 자신의 프로젝트에 맞게 바꾼다.

### Functional Requirements 예시

```text
FR1. CSV 데이터를 data/raw/에서 로딩할 수 있어야 한다.
FR2. 결측값, 중복 행, 이상값을 탐지할 수 있어야 한다.
FR3. EDA 차트 5종 이상을 생성해야 한다.
FR4. 반품 여부를 예측하는 scikit-learn baseline 모델을 학습해야 한다.
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
원본 데이터 위치: data/raw/sales_sample.csv
전처리 데이터 위치: data/processed/

필수 변수:
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
```

### Model Requirements 예시

```text
초기 모델: scikit-learn baseline classifier
타겟 변수: returned
평가 지표: F1-score, precision, recall, confusion matrix
초기 성공 기준: F1-score 0.75 이상 또는 baseline 대비 20% 개선
```

### Out of Scope 예시

```text
이번 버전에서는 다음을 하지 않는다.

- 웹 애플리케이션 개발
- 실시간 대시보드
- SQL 데이터베이스 연결
- 클라우드 배포
- 사용자 로그인 기능
- 대규모 MLOps
```

---

## 6.6 PRD.md 저장 확인

대화가 끝나면 다음 파일이 있어야 한다.

```text
_bmad-output/PRD.md
```

AI 코딩 도구에 입력한다.

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

# 7. 실습 4: PRD 자기 점검

PRD는 한 번에 완벽하지 않다. 생성된 직후 반드시 점검한다.

## 7.1 PRD 품질 체크리스트

다음 7개 질문에 답한다.

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

## 7.2 PRD가 모호할 때 수정 요청

PRD에 이런 표현이 있으면 모호하다.

```text
좋은 분석
좋은 모델
데이터를 잘 처리
결과를 잘 정리
필요하면 다 한다
```

AI에게 다음처럼 요청한다.

```text
PRD.md가 아직 너무 모호하다.
다음 기준으로 다시 보완해줘.

1. 측정 불가능한 형용사를 측정 가능한 기준으로 바꿔줘.
2. 모호한 동사를 구체적인 작업 동사로 바꿔줘.
3. 성공 기준에 숫자를 넣어줘.
4. 출력 파일 경로를 명시해줘.
5. In Scope와 Out of Scope를 분리해줘.
6. 데이터 품질, 모델 과적합, AI 해석 오류, 재현성 문제와 관련된 리스크를 추가해줘.
7. project-context.md와 충돌하지 않게 수정해줘.

수정 전에 내가 추가로 답해야 하는 질문이 있으면 먼저 물어봐.
```

---

## 7.3 세 문서 충돌 점검

project-context, product brief, PRD가 서로 충돌할 수 있다. 예를 들어 project-context에는 SQL을 쓰지 않는다고 했는데 PRD에는 SQL 연결이 들어갈 수 있다.

AI에게 다음을 입력한다.

```text
Compare these three files:
1. _bmad-output/project-context.md
2. _bmad-output/product-brief.md
3. _bmad-output/PRD.md

Find contradictions.
Use project-context.md as the source of truth.
If PRD.md conflicts with project-context.md, propose revisions.
Do not change files until you show me the proposed changes.
```

제안이 마음에 들면 이렇게 말한다.

```text
Apply the proposed revisions to _bmad-output/PRD.md.
```

---

# 8. ChatGPT Projects 보조 공간 세팅

## 8.1 ChatGPT Projects의 역할

이 수업에서 ChatGPT Projects는 코드 작성의 중심 도구가 아니다. 코드 작성과 파일 수정은 Gemini CLI 또는 Claude Code에서 한다.

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

## 8.2 ChatGPT Projects 만들기

브라우저에서 ChatGPT에 접속한다.

```text
1. chatgpt.com에 접속한다.
2. 왼쪽 메뉴에서 프로젝트를 선택한다.
3. 새 프로젝트를 만든다.
4. 프로젝트 이름을 입력한다.
```

프로젝트 이름 예시:

```text
AI Data Lab 분석 보조
```

---

## 8.3 사용자 지정 지시 입력

프로젝트의 사용자 지정 지시에 다음 내용을 넣는다.

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

# 9. 과제: README.md 작성

2회차 과제는 README.md를 보완하는 것이다.

README.md는 프로젝트의 첫 페이지다. 이 파일은 나중에 프로젝트를 다시 열었을 때 “이 프로젝트가 무엇인지” 알려준다.

---

## 9.1 README.md 파일이 있는지 확인

터미널에서 확인한다.

### Windows PowerShell

```powershell
dir README.md
```

### Mac Terminal

```bash
ls README.md
```

없다면 만든다.

### Windows PowerShell

```powershell
notepad README.md
```

### Mac Terminal

```bash
nano README.md
```

하지만 추천 방식은 AI 코딩 도구에 README 생성을 요청하는 것이다.

---

## 9.2 AI에게 README.md 작성을 요청

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

## 9.3 README.md 기본 구조

README에는 다음 구조가 들어가면 된다.

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

# 10. 2회차 최종 확인

터미널에서 파일을 확인한다.

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 네 개 파일이 보여야 한다.

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

# 11. 자주 생기는 문제와 해결

## 문제 1. `bmad-help`가 작동하지 않는다

가장 흔한 원인은 프로젝트 폴더 밖에서 AI 도구를 실행한 것이다.

터미널에서 현재 위치를 확인한다.

```bash
pwd
```

프로젝트 폴더가 아니라면 이동한다.

```bash
cd ~/ai-data-lab
```

그다음 AI 도구를 다시 연다.

```bash
gemini
```

또는:

```bash
claude
```

그리고 다시 입력한다.

```text
bmad-help
```

---

## 문제 2. AI가 웹앱을 만들자고 한다

이 프로젝트는 웹앱이 아니다. 즉시 멈추고 다음을 입력한다.

```text
Stop. This project is not a web application.
Read _bmad-output/project-context.md again.
Revise your recommendation for a Python-first reproducible AI/Data Lab.
```

---

## 문제 3. AI가 파일을 만들었다고 했는데 실제 파일이 없다

AI에게 먼저 확인시킨다.

```text
List the files in _bmad-output.
```

없다면 다시 요청한다.

```text
Actually create the file _bmad-output/project-context.md.
Do not only show the content.
After creating it, list _bmad-output to confirm.
```

그래도 안 되면 직접 만든다.

Windows:

```powershell
notepad _bmad-output\project-context.md
```

Mac:

```bash
nano _bmad-output/project-context.md
```

---

## 문제 4. PRD가 너무 추상적이다

다음 프롬프트를 사용한다.

```text
The PRD is too vague.
Rewrite the requirements with measurable criteria.
Include:
- number of EDA charts
- target variable
- model evaluation metric
- minimum success target
- output files
- reproducibility command
- out-of-scope items

Ask me if you need missing information.
```

---

## 문제 5. Product Brief와 PRD가 서로 다르다

다음 프롬프트를 사용한다.

```text
Compare product-brief.md, PRD.md, and project-context.md.
Find contradictions.
Use project-context.md as the source of truth.
Revise PRD.md so it follows project-context.md.
```

---

# 12. 오늘 배운 것

2회차의 핵심은 명령어가 아니다.

핵심은 다음 순서다.

```text
터미널을 연다.
프로젝트 폴더로 이동한다.
AI 코딩 도구를 실행한다.
bmad-help로 상태를 확인한다.
project-context.md로 규칙을 고정한다.
Mary와 product brief를 만든다.
John과 PRD를 만든다.
PRD를 체크리스트로 점검한다.
ChatGPT Projects를 분석 보조 공간으로 세팅한다.
README.md를 보완한다.
```

오늘 만든 세 문서가 단단할수록 3회차가 쉬워진다.

3회차에서는 다음을 한다.

```text
bmad-create-architecture
bmad-create-epics-and-stories
bmad-check-implementation-readiness
repo 구조 생성
합성 데이터 생성
analysis_config.yaml 작성
```

---

# 부록 A. 한 장 요약

## 2회차 명령 순서

### 1. 프로젝트 폴더로 이동

```bash
cd ~/ai-data-lab
```

### 2. AI 도구 실행

```bash
gemini
```

또는:

```bash
claude
```

### 3. BMAD 상태 확인

```text
bmad-help
```

### 4. project-context.md 작성

```text
Create _bmad-output/project-context.md with the following content...
```

### 5. product brief 작성

```text
/clear
bmad-product-brief
```

### 6. PRD 작성

```text
/clear
bmad-create-prd
```

### 7. 산출물 확인

```text
Check whether these files exist:
_bmad-output/brainstorming-report.md
_bmad-output/project-context.md
_bmad-output/product-brief.md
_bmad-output/PRD.md
README.md
```

---

# 부록 B. 2회차 품질 게이트

다음에 모두 답할 수 있으면 2회차를 통과한 것이다.

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

# 부록 C. 참고 자료

- BMAD 설치 문서: https://docs.bmad-method.org/how-to/install-bmad/
- BMAD Getting Started: https://docs.bmad-method.org/tutorials/getting-started/
- Gemini CLI 문서: https://google-gemini.github.io/gemini-cli/docs/
- OpenAI ChatGPT Projects 도움말: https://help.openai.com/en/articles/10169521-projects-in-chatgpt

