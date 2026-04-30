# 바이브코딩 기반 Python-first AI/Data Lab 구축
> **과정명**: 바이브코딩으로 만드는 데이터분석·AI 알고리즘 구현 시스템

---

## 1. 과정 개요

### 1.1 수업 목표

- **AI 코딩 도구**(Claude Code 또는 Gemini CLI)를 사용하여 터미널에서 데이터분석 repo를 구축한다.
- BMAD를 설치하고, 6종 AI 에이전트를 활용하여 문제 정의·요구사항·아키텍처·구현 Story를 체계적으로 관리한다.
- ChatGPT Projects를 분석 보조 공간으로 사용하여 데이터 이해·분석 아이디어·보고서 초안을 정리한다.
- pandas 중심의 데이터분석 파이프라인을 구축한다 (SQL 미사용).
- scikit-learn으로 기본 머신러닝 baseline 모델을 구현한다.
- PyTorch로 딥러닝 알고리즘의 기본 구조를 구현한다.
- LLM API(Claude API 또는 Gemini API)를 파이프라인 내부에 통합하여 EDA 해석·모델 제안·보고서 생성을 자동화한다.
- notebook에 갇힌 분석이 아니라, src/, tests/, reports/, artifacts/가 있는 재현 가능한 프로젝트 구조를 구축한다.

> **도구 선택 안내**: 이 교안은 **Claude Code**(유료, Anthropic Pro $20/월)와 **Gemini CLI**(무료, Google 계정)를 모두 지원한다. 두 도구 모두 터미널 기반 AI 코딩 도구이며, BMAD와 호환된다. 수강생은 환경에 맞는 도구를 선택하면 된다.

### 1.2 핵심 철학

이 수업의 핵심은 다음 한 문장이다.

> **ChatGPT로 분석을 빠르게 탐색하고, AI 코딩 도구(Claude Code/Gemini CLI)로 repo를 구현하며, BMAD로 작업 체계를 고정한다.**

| 도구 | 역할 | 비유 |
|------|------|------|
| Claude Code / Gemini CLI | 메인 AI 코딩 환경 — 터미널에서 코드 생성, 파일 관리, 테스트 실행 | 작업실 |
| BMAD | 설계·문서화·구현 체계 — 요구사항, 아키텍처, Story, Review를 단계화 | 공정 관리 시스템 |
| ChatGPT Projects | 분석 보조 — 데이터 해석, 아이디어, 보고서 초안, 리서치 | 분석 보조원 |
| Claude API / Gemini API | 파이프라인 내 AI 통합 — EDA 해석, 모델 제안, 보고서 자동 생성 | 자동화된 해석기 |

### 두 AI 코딩 도구 비교

| 항목 | Claude Code | Gemini CLI |
|------|------------|------------|
| 비용 | Anthropic Pro $20/월 필요 | **완전 무료** (Google 계정만 필요) |
| 일일 한도 | Pro 기준 무제한에 가까움 | 1,000 요청/일, 60 요청/분 |
| 모델 | Claude Opus 4.6 | Gemini 3.1 Pro |
| 컨텍스트 창 | ~200K 토큰 | 1M 토큰 |
| 설치 | `npm install -g @anthropic-ai/claude-code` | `npm install -g @google/gemini-cli` |
| 실행 | `claude` | `gemini` |
| 새 세션 | `/clear` | `/clear` |
| BMAD 호환 | 공식 지원 | 호환 (AGENTS.md 지원) |
| 코딩 품질 | 더 정확 (SWE-bench 77.1%) | 약간 낮음 (SWE-bench 63.8%) |
| 특장점 | 자율적 멀티파일 편집에 강함 | 내장 Google Search, 무료 |

> **수업 권장**: 비용 부담이 없다면 Claude Code, 무료를 원한다면 Gemini CLI를 사용한다. 교안의 모든 실습은 두 도구 모두에서 동작한다.

### 1.3 수업 대상

| 대상 | 설명 |
|------|------|
| 데이터분석 입문자 | Excel/CSV 분석을 Python 프로젝트로 확장하고 싶은 사람 |
| 바이브코딩 사용자 | 웹사이트가 아니라 데이터분석·AI 알고리즘을 바이브코딩하고 싶은 사람 |
| Python 초중급자 | pandas, scikit-learn, PyTorch를 체계적으로 묶고 싶은 사람 |
| 비전공 실무자 | AI 도구를 이용해 분석 체계를 만들고 싶은 사람 |

### 1.4 선수 지식

- Python 기초 문법
- 파일/폴더 개념
- CSV 또는 Excel 데이터에 대한 기본 이해
- Git은 몰라도 수업 중 필요한 수준만 익힌다
- SQL은 사용하지 않는다. 이 수업은 Python-first 흐름이다.

---

## 2. 전체 커리큘럼 (8회차)

| 회차 | 주제 | 핵심 산출물 | 시간 |
|------|------|-----------|------|
| 1 | BMAD의 이해와 도구 세팅 | 빈 repo, uv 환경, AI 코딩 도구 + BMAD 설치 완료 | 3시간 |
| 2 | BMAD로 프로젝트 체계 만들기 | project-context.md, product brief, PRD 초안 | 3시간 |
| 3 | 데이터분석 repo 구조와 아키텍처 | 표준 폴더 구조, architecture.md, Epic/Story | 3시간 |
| 4 | pandas 기반 EDA와 데이터 품질검사 | EDA notebook, quality report, AI 해석 모듈 | 3시간 |
| 5 | 재현 가능한 분석 파이프라인 | run_pipeline.py, config.yaml, 품질 게이트 | 3시간 |
| 6 | scikit-learn 머신러닝 baseline | 모델 학습, 평가 리포트, artifacts 저장 | 3시간 |
| 7 | PyTorch 딥러닝 기본 구현 | Dataset, DataLoader, MLP, training loop | 3시간 |
| 8 | BMAD 리뷰와 최종 프로젝트 발표 | 최종 repo, 보고서, 개선 roadmap | 3시간 |

---

## 3. 수업 전 설치 목록

수강생에게 사전 안내할 설치 항목이다.

| 소프트웨어 | 용도 | 설치 방법 |
|-----------|------|----------|
| Node.js 20+ | AI 도구 + BMAD 설치 기반 | https://nodejs.org 에서 LTS 버전 다운로드 |
| **Claude Code** (유료) | AI 코딩 도구 (Anthropic) | `npm install -g @anthropic-ai/claude-code` |
| **Gemini CLI** (무료) | AI 코딩 도구 (Google) | `npm install -g @google/gemini-cli` |
| Git | 버전 관리 | https://git-scm.com 에서 다운로드 |
| Python 3.11+ | 분석·AI 런타임 | https://www.python.org 에서 다운로드 |
| uv | Python 환경·패키지 관리 | 터미널: `curl -LsSf https://astral.sh/uv/install.sh \| sh` (Mac/Linux) 또는 `powershell -c "irm https://astral.sh/uv/install.ps1 \| iex"` (Windows) |
| VS Code (선택) | 코드 편집기 (AI 도구와 병행 가능) | https://code.visualstudio.com |

> **둘 중 하나만 설치하면 된다.** Claude Code는 Anthropic Pro 구독($20/월)이 필요하고, Gemini CLI는 Google 계정만 있으면 무료이다. 수업에서는 Gemini CLI를 기본으로 안내하되, Claude Code 사용자도 동일하게 따라올 수 있다.

---

## 4. 표준 repo 구조

수업 전체에서 사용할 최종 디렉터리 구조이다.

```
ai-data-lab/
  README.md
  pyproject.toml
  config/
    analysis_config.yaml          ← 재사용 가능한 설정 파일
  _bmad/                          ← BMAD 엔진 (수정 금지)
  _bmad-output/                   ← BMAD 아티팩트
    project-context.md
    product-brief.md
    PRD.md
    architecture.md
  data/
    raw/                          ← 원본 데이터 (수정 금지)
    interim/                      ← 중간 변환 데이터
    processed/                    ← 전처리 완료 데이터
  notebooks/
    01_eda.ipynb
    02_modeling_baseline.ipynb
    03_pytorch_experiment.ipynb
  src/
    config.py                     ← 설정 로더
    data/
      loaders.py                  ← 데이터 로딩
      schema.py                   ← 스키마 검증
      cleaning.py                 ← 전처리
      quality_checks.py           ← 품질 검사
    analysis/
      eda.py                      ← EDA 함수
      kpis.py                     ← KPI 계산
    features/
      build_features.py           ← 피처 엔지니어링
    models/
      train_sklearn.py            ← scikit-learn 학습
      evaluate.py                 ← 모델 평가
      train_pytorch.py            ← PyTorch 학습
      torch_models.py             ← PyTorch 모델 정의
    ai/
      interpreter.py              ← Claude API 해석 모듈
    visualization/
      charts.py                   ← 시각화 함수
    pipelines/
      run_analysis_pipeline.py
      run_ml_pipeline.py
  scripts/
    generate_sample_data.py       ← 합성 데이터 생성
    run_pipeline.py               ← 분석 파이프라인 진입점
    train_baseline.py             ← sklearn 실행 진입점
    train_deep_learning.py        ← PyTorch 실행 진입점
  tests/
    test_schema.py
    test_cleaning.py
    test_features.py
    test_metrics.py
  reports/
    data_quality.md
    analysis_summary.md
    model_report.md
    pytorch_report.md
  artifacts/
    models/
    metrics/
    charts/
```

이 구조의 핵심 원칙은 다음과 같다.
- **notebook은 탐색용**이다. 재사용 로직을 notebook 안에 숨기지 않는다.
- **src/는 재사용 로직**이다. 함수는 모두 여기에 둔다.
- **scripts/는 실행 진입점**이다. `uv run python scripts/run_pipeline.py`로 재실행한다.
- **reports/는 설명 문서**이다. 사람이 읽는 보고서가 들어간다.
- **artifacts/는 생성물**이다. 모델, 메트릭, 차트가 저장된다.

---

## 5. 차시별 상세 교안

---

### 1회차: BMAD의 이해와 도구 세팅 (3시간)

#### 수업 목표
수강생이 BMAD가 무엇이며 왜 필요한지 이해하고, AI 코딩 도구·BMAD·ChatGPT Projects 환경을 세팅하여 `bmad-help`까지 실행한다.

#### 시간 배분

| 시간 | 내용 | 형태 |
|------|------|------|
| 0:00~0:30 | BMAD란 무엇인가: 정의, 6종 에이전트, 4단계 워크플로 | 강의 |
| 0:30~0:50 | 데이터분석에서 BMAD가 필요한 이유: 네 가지 문제와 해결 메커니즘 | 강의 |
| 0:50~1:00 | 웹앱 바이브코딩 vs 데이터분석 바이브코딩의 차이 | 강의 |
| 1:00~1:10 | 휴식 | — |
| 1:10~1:40 | Node.js → AI 코딩 도구(Claude Code 또는 Gemini CLI) → uv 설치 → Python 환경 세팅 | 실습 |
| 1:40~2:00 | BMAD 설치: npx bmad-method install (마법사 질문별 가이드) | 실습 |
| 2:00~2:10 | 휴식 | — |
| 2:10~2:30 | bmad-help 첫 실행 및 폴더 구조 확인 | 실습 |
| 2:30~2:50 | BMAD 황금률 + 공식 마스터클래스 영상 소개 | 강의 |
| 2:50~3:00 | 과제 안내 및 Q&A | — |

#### 핵심 개념

**BMAD(Breakthrough Method for Agile AI-Driven Development)**는 AI 에이전트들에게 각각 역할을 부여하고, 정해진 워크플로에 따라 협업시키는 오픈소스 프레임워크이다.

**6종 기본 에이전트:**

| 에이전트 | 이름 | 호출 명령어 | 역할 |
|----------|------|-----------|------|
| Analyst | Mary | `bmad-analyst` | 브레인스토밍, 리서치, 제품 브리프 |
| Product Manager | John | `bmad-pm` | PRD 작성, Epic/Story 분해 |
| Architect | Winston | `bmad-architect` | 기술 아키텍처 설계 |
| Developer | Amelia | `bmad-agent-dev` | 코드 작성, Quick Dev, 코드 리뷰 |
| UX Designer | Sally | `bmad-ux-designer` | 대시보드 UI 설계 |
| Technical Writer | Paige | `bmad-tech-writer` | 문서·다이어그램 생성 |

**4단계 워크플로:**
```
Phase 1: Analysis (선택)     → 아이디어 탐색·검증
Phase 2: Planning (필수)     → 요구사항 정의 (PRD)
Phase 3: Solutioning (권장)  → 기술 설계 (Architecture)
Phase 4: Implementation      → Story 단위 코드 작성
```

**BMAD 황금률**: 모든 워크플로는 새 채팅 세션에서 시작한다.

> Claude Code에서 새 세션을 여는 방법: `/clear` 입력 또는 터미널에서 `claude`를 새로 실행한다.

**데이터분석에서 BMAD가 해결하는 네 가지 문제:**

| 문제 | BMAD 해결 방법 |
|------|---------------|
| 맥락 소실 | 모든 의사 결정이 .md 아티팩트에 기록 |
| AI 환각 | PRD가 AI에 대한 계약서 역할 |
| 파이프라인 파편화 | Architecture에서 전체 구조를 먼저 설계 |
| 일회성 분석 | config.yaml 파라미터화로 재실행 가능 |

#### 실습 1: 환경 세팅

```bash
# 1. AI 코딩 도구 설치 (둘 중 하나 선택)

# [옵션 A] Gemini CLI (무료 — Google 계정 필요)
npm install -g @google/gemini-cli
gemini          # 첫 실행 시 Google 로그인 → 완료

# [옵션 B] Claude Code (유료 — Anthropic Pro $20/월)
npm install -g @anthropic-ai/claude-code
claude --version  # 버전 출력 확인

# 2. 프로젝트 폴더 생성
mkdir ai-data-lab
cd ai-data-lab

# 3. Git 초기화
git init

# 4. Python 환경 세팅
uv init
uv python pin 3.11
uv add jupyterlab pandas matplotlib scikit-learn pytest ruff

# 5. BMAD 설치
npx bmad-method install

# 6. AI 코딩 도구 실행 (프로젝트 폴더 안에서)
gemini    # Gemini CLI 사용자
# 또는
claude    # Claude Code 사용자
```

> **이후 교안에서 `claude`로 표기된 명령어는 Gemini CLI 사용자의 경우 `gemini`로 대체하면 된다.** 두 도구 모두 터미널에서 자연어로 대화하며 코드를 생성·편집하는 동일한 워크플로를 따른다.

#### BMAD 설치 마법사 답변 가이드

| 마법사 질문 | 답변 | 이유 |
|------------|------|------|
| Where should BMad files be installed? | Current directory | 방금 만든 폴더에 설치 |
| Select modules to install | BMad Method (스페이스바) | 핵심 모듈 |
| Select tools to configure | Claude Code 또는 Gemini (스페이스바) | 사용 중인 AI 도구 선택 |
| Shard PRD and Architecture? | Yes (Enter) | AI 컨텍스트 효율화 |

나머지 질문은 모두 Enter(기본값)로 넘어간다.

#### 실습 2: bmad-help 첫 실행

터미널에서 프로젝트 폴더로 이동한 뒤, AI 코딩 도구(`claude` 또는 `gemini`)를 실행하고 다음을 입력한다.

```
bmad-help
```

프로젝트 상태가 "신규 프로젝트"로 표시되고, 권장 다음 단계가 나오면 설치에 성공한 것이다.

#### 필수 시청 영상

- The Official BMad-Method Masterclass: https://www.youtube.com/watch?v=LorEJPrALcg

#### 과제

README.md에 다음 내용을 작성한다.

```markdown
# AI Data Lab
## Purpose
## Tools
## Project Structure
## How to Run
## Rules
```

---

### 2회차: BMAD로 프로젝트 체계 만들기 (3시간)

#### 수업 목표
수강생이 BMAD의 Phase 1~2를 실행하여 project-context.md, product brief, PRD를 작성한다.

#### 시간 배분

| 시간 | 내용 | 형태 |
|------|------|------|
| 0:00~0:20 | Quick Flow를 쓰지 않는 이유, 전체 흐름 복습 | 강의 |
| 0:20~0:50 | project-context.md 작성 | 실습 |
| 0:50~1:00 | 휴식 | — |
| 1:00~1:30 | Phase 1: bmad-product-brief 실행 | 실습 |
| 1:30~2:00 | Phase 2: bmad-create-prd 실행 | 실습 |
| 2:00~2:10 | 휴식 | — |
| 2:10~2:40 | PRD 검토 및 수정 | 실습 |
| 2:40~2:50 | ChatGPT Projects 보조 공간 세팅 | 실습 |
| 2:50~3:00 | 과제 안내 | — |

#### 핵심 개념

**Quick Flow를 쓰지 않는 이유**: Quick Flow(`bmad-quick-dev`)는 소규모 작업(Story 15개 이하)에 적합한 빠른 경로이다. 그러나 이 수업에서 구축하는 AI/Data Lab은 8주에 걸쳐 데이터 수집, EDA, ML, 딥러닝까지 포괄하는 중규모 프로젝트이므로, 전체 BMAD 흐름(Analysis → Planning → Solutioning → Implementation)을 따르는 것이 적절하다.

**project-context.md의 역할**: 이 파일은 프로젝트의 "헌법"이다. 모든 AI 에이전트가 이 파일을 참조하여 일관된 기준을 따른다.

#### 실습 1: project-context.md 작성

AI 코딩 도구(`claude` 또는 `gemini`)에서 다음을 입력한다.

```
bmad-help
I am building a Python-first AI/Data Lab, not a website.
Goals:
- reproducible data analysis
- notebook + src separation
- pandas-based analysis first
- scikit-learn baseline modeling second
- PyTorch deep learning implementation third
- no SQL for the initial version
- ChatGPT Projects will be used for analysis support
- Claude API will be integrated into the pipeline for automated interpretation
- Claude Code or Gemini CLI as the AI coding tool
Please recommend the best full BMAD starting path.
Do not use Quick Flow unless the scope is tiny.
```

그 다음, `_bmad-output/project-context.md`를 다음 내용으로 작성한다.

```markdown
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
- No absolute paths. No undocumented manual steps.

## AI Collaboration Policy
AI agents must:
- ask for assumptions when data schema is unclear,
- document data quality risks,
- separate exploratory and production-like code,
- generate tests for reusable functions,
- explain tradeoffs before large changes.
```

#### 실습 2: Product Brief 작성

Claude Code에서 새 세션을 열고(`/clear` 또는 `claude` 재실행) 다음을 입력한다.

```
bmad-product-brief
```

Mary(Analyst)의 질문에 답하며 product brief를 작성한다.

#### 실습 3: PRD 작성

Claude Code에서 새 세션을 열고(`/clear` 또는 `claude` 재실행) 다음을 입력한다.

```
bmad-create-prd
```

John(PM)의 질문에 답하며 PRD를 작성한다. PRD에 포함되어야 하는 핵심 항목은 다음과 같다.

- 분석 목적 (Executive Summary)
- 문제 정의 (Problem Statement)
- 기능 요구사항 (Functional Requirements)
- 비기능 요구사항 (Non-functional Requirements)
- 데이터 요구사항
- 모델 요구사항
- 성공 기준
- 범위 (In Scope / Out of Scope)
- 리스크

#### 과제

ChatGPT Projects에 새 프로젝트를 만들고 다음 custom instruction을 설정한다.

```
이 프로젝트는 Python-first AI/Data Lab 구축을 위한 분석 보조 프로젝트이다.
역할: 데이터분석 아이디어 제안, EDA 질문 정리, 분석 리포트 초안, 모델 평가 해석
원칙: AI 코딩 도구(claude/gemini)로 관리하는 repo가 source of truth이다. ChatGPT는 보조 분석가 역할이다.
```

---

### 3회차: 데이터분석 repo 구조와 아키텍처 (3시간)

#### 수업 목표
BMAD Phase 3(Solutioning)을 실행하여 기술 아키텍처를 설계하고, 표준 repo 구조를 생성하며, Epic/Story를 분해한다.

#### 시간 배분

| 시간 | 내용 | 형태 |
|------|------|------|
| 0:00~0:30 | Phase 3: bmad-create-architecture 실행 | 실습 |
| 0:30~1:00 | architecture.md 검토 및 디렉터리 구조 확인 | 실습 |
| 1:00~1:10 | 휴식 | — |
| 1:10~1:40 | bmad-create-epics-and-stories 실행 | 실습 |
| 1:40~2:00 | bmad-check-implementation-readiness 실행 | 실습 |
| 2:00~2:10 | 휴식 | — |
| 2:10~2:40 | repo 구조 생성 (AI 코딩 도구 프롬프트 활용) | 실습 |
| 2:40~2:55 | 합성 데이터 생성 | 실습 |
| 2:55~3:00 | 과제 안내 | — |

#### 실습 1: Architecture 설계

Claude Code에서 새 세션을 열고(`/clear` 또는 `claude` 재실행) 다음을 입력한다.

```
bmad-create-architecture
```

Winston(Architect)이 PRD를 자동으로 읽고 기술 질문을 던진다. 답변 시 다음 사항을 명시한다.

- Python 3.11, uv 사용
- pandas 중심 분석, scikit-learn baseline, PyTorch 확장
- Claude API를 파이프라인에 통합 (EDA 해석, 모델 제안, 보고서 생성)
- config/analysis_config.yaml로 모든 변동 요소를 외부화
- notebook은 탐색 전용, 재사용 로직은 src/

#### 실습 2: Epic/Story 분해

Claude Code에서 새 세션을 열고(`/clear` 또는 `claude` 재실행) 다음을 입력한다.

```
bmad-create-epics-and-stories
```

예상 Epic 구조는 다음과 같다.

```
Epic 1: Repository Foundation (repo 구조, README, 설정)
Epic 2: Data Loading and Validation (로더, 스키마 검증)
Epic 3: Data Quality and Cleaning (결측값, 이상치, 전처리)
Epic 4: EDA and Reporting (시각화, KPI, AI 해석)
Epic 5: Reproducible Pipeline (scripts, config, 품질 게이트)
Epic 6: scikit-learn Baseline Modeling (피처, 학습, 평가)
Epic 7: PyTorch Experimentation (Dataset, MLP, training loop)
Epic 8: Final Documentation and Review (보고서, BMAD 리뷰)
```

#### 실습 3: repo 구조 생성

AI 코딩 도구(`claude` 또는 `gemini`)에서 다음을 입력한다.

```
Using the project-context.md and architecture.md rules,
create the initial repository structure.
Create all folders and placeholder files with docstrings.
Do not add complex logic yet.
```

#### 실습 4: 합성 데이터 생성

AI 코딩 도구(`claude` 또는 `gemini`)에서 다음을 입력한다.

```
Create scripts/generate_sample_data.py.
Generate a realistic synthetic sales dataset with:
order_id, customer_id, order_date, region, channel,
product_category, quantity, unit_price, discount_rate,
revenue, returned, customer_age, acquisition_source.
Add some missing values, duplicates, and outliers intentionally.
Save to data/raw/sales_sample.csv. Use random seed 42.
```

실행한다.

```bash
uv run python scripts/generate_sample_data.py
```

#### 실습 5: analysis_config.yaml 작성

```yaml
# config/analysis_config.yaml
meta:
  project_name: "AI Data Lab — Sales Analysis"
  version: "1.0.0"

data:
  raw_path: "data/raw/sales_sample.csv"
  processed_path: "data/processed/sales_clean.csv"
  encoding: "utf-8"

variables:
  target: "returned"
  numeric_features:
    - "quantity"
    - "unit_price"
    - "discount_rate"
    - "revenue"
    - "customer_age"
  categorical_features:
    - "region"
    - "channel"
    - "product_category"
    - "acquisition_source"

modeling:
  test_ratio: 0.2
  random_seed: 42
  models:
    - name: "logistic_regression"
    - name: "random_forest"
      params: {n_estimators: 200, max_depth: 10}

ai_integration:
  enabled: true
  model: "auto"  # claude-sonnet-4 또는 gemini-2.5-pro (자동 감지)

output:
  charts_dir: "artifacts/charts/"
  models_dir: "artifacts/models/"
  metrics_dir: "artifacts/metrics/"
  reports_dir: "reports/"
```

#### 과제

README.md에 다음 규칙을 추가한다.

```markdown
## Analysis Rules
1. raw data is immutable.
2. notebooks are exploratory.
3. reusable code belongs in src/.
4. every major result must be reproducible by script.
5. assumptions and limitations must be documented.
```

---

### 4회차: pandas 기반 EDA와 데이터 품질검사 (3시간)

#### 수업 목표
pandas로 데이터를 읽고, 결측치·중복·이상치·스키마를 점검하고, Claude API로 EDA 결과를 자동 해석하는 모듈을 구현한다.

#### 시간 배분

| 시간 | 내용 | 형태 |
|------|------|------|
| 0:00~0:20 | BMAD Phase 4 시작: bmad-sprint-planning | 실습 |
| 0:20~0:50 | Story 구현: data loaders, schema validation | 실습 |
| 0:50~1:00 | 휴식 | — |
| 1:00~1:30 | Story 구현: quality_checks.py (결측, 중복, 이상치) | 실습 |
| 1:30~2:00 | Story 구현: 01_eda.ipynb + eda.py | 실습 |
| 2:00~2:10 | 휴식 | — |
| 2:10~2:40 | AI 해석 모듈 구현: src/ai/interpreter.py | 실습 |
| 2:40~2:55 | ChatGPT Projects에 EDA 질문 10개 의뢰 | 실습 |
| 2:55~3:00 | 과제 안내 | — |

#### 실습 1: 스프린트 시작

AI 코딩 도구에서 새 세션(`/clear`)을 열고 다음을 입력한다.

```
bmad-sprint-planning
```

#### BMAD 빌드 사이클 (이후 모든 Story에 적용)

각 Story마다 다음 3단계를 반복한다. **매번 새 채팅 세션을 연다.**

```
① bmad-create-story   → Story 파일 생성
② bmad-dev-story      → 코드 작성
③ bmad-code-review    → 코드 리뷰 (권장)
```

#### 핵심 코드: src/data/loaders.py

```python
# src/data/loaders.py
import pandas as pd
import yaml
from pathlib import Path

def load_config(path: str = "config/analysis_config.yaml") -> dict:
    """분석 설정 파일을 로딩하는 함수이다."""
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def load_raw_data(config: dict = None) -> pd.DataFrame:
    """원본 데이터를 로딩하는 함수이다."""
    if config is None:
        config = load_config()
    path = Path(config["data"]["raw_path"])
    if not path.exists():
        raise FileNotFoundError(f"데이터 파일을 찾을 수 없다: {path}")
    df = pd.read_csv(path)
    print(f"로딩 완료: {df.shape[0]:,}행 x {df.shape[1]}열")
    return df
```

#### 핵심 코드: src/data/quality_checks.py

```python
# src/data/quality_checks.py
import pandas as pd

def check_missing(df: pd.DataFrame) -> pd.Series:
    """컬럼별 결측률을 반환하는 함수이다."""
    return (df.isnull().sum() / len(df) * 100).round(2)

def check_duplicates(df: pd.DataFrame) -> int:
    """중복 행 수를 반환하는 함수이다."""
    return df.duplicated().sum()

def check_outliers(df: pd.DataFrame, columns: list, factor: float = 1.5) -> dict:
    """IQR 기반 이상치 수를 반환하는 함수이다."""
    result = {}
    for col in columns:
        if col not in df.columns:
            continue
        q1 = df[col].quantile(0.25)
        q3 = df[col].quantile(0.75)
        iqr = q3 - q1
        mask = (df[col] < q1 - factor * iqr) | (df[col] > q3 + factor * iqr)
        result[col] = int(mask.sum())
    return result

def run_all_checks(df: pd.DataFrame, config: dict) -> dict:
    """모든 품질 검사를 실행하고 결과를 반환하는 함수이다."""
    return {
        "row_count": len(df),
        "column_count": len(df.columns),
        "missing": check_missing(df).to_dict(),
        "duplicates": check_duplicates(df),
        "outliers": check_outliers(df, config["variables"]["numeric_features"]),
    }
```

#### 핵심 코드: src/ai/interpreter.py

```python
# src/ai/interpreter.py
"""AI 해석 모듈이다. Claude API 또는 Gemini API를 자동 감지하여 사용한다."""
import os

def _get_client():
    """사용 가능한 API 클라이언트를 자동 감지한다."""
    # 1순위: Claude API
    if os.environ.get("ANTHROPIC_API_KEY"):
        from anthropic import Anthropic
        return "claude", Anthropic()
    # 2순위: Gemini API
    if os.environ.get("GOOGLE_API_KEY"):
        import google.generativeai as genai
        genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
        return "gemini", genai.GenerativeModel("gemini-2.5-pro")
    raise RuntimeError("ANTHROPIC_API_KEY 또는 GOOGLE_API_KEY를 환경 변수에 설정하라.")

def _ask(prompt: str, max_tokens: int = 2000) -> str:
    """통합 API 호출 함수이다."""
    provider, client = _get_client()
    if provider == "claude":
        resp = client.messages.create(
            model="claude-sonnet-4-20250514", max_tokens=max_tokens,
            messages=[{"role": "user", "content": prompt}])
        return resp.content[0].text
    else:  # gemini
        resp = client.generate_content(prompt)
        return resp.text

def interpret_eda(summary_stats: str, chart_desc: str, hypotheses: list = None) -> str:
    """EDA 결과에 대한 AI 해석을 생성하는 함수이다."""
    h_text = ""
    if hypotheses:
        h_text = "\n\n검증 대상 가설:\n" + "\n".join(f"- {h}" for h in hypotheses)
    prompt = (f"기술통계:\n{summary_stats}\n\n시각화:\n{chart_desc}"
              f"{h_text}\n\n주요 발견(3~5개)과 다음 단계를 제안하라.")
    return _ask(prompt)

def suggest_model_improvements(model_name: str, metrics: dict) -> str:
    """모델 성능에 대한 개선 제안을 생성하는 함수이다."""
    import json
    prompt = (f"모델: {model_name}\n성능:\n{json.dumps(metrics, indent=2)}\n\n"
              f"진단, 하이퍼파라미터 조정, 대안 모델을 제안하라.")
    return _ask(prompt, 1500)
```

API 패키지를 설치한다 (사용하는 API에 맞춰 선택).

```bash
# Claude API 사용 시
uv add anthropic

# Gemini API 사용 시 (무료 API 키: https://aistudio.google.com/apikey)
uv add google-generativeai
```

#### 산출물
- notebooks/01_eda.ipynb
- src/data/quality_checks.py
- src/ai/interpreter.py
- reports/data_quality.md

#### 과제
reports/analysis_summary.md에 다음 질문에 답한다.
1. 매출은 어떤 채널에서 가장 높은가?
2. 지역별 매출 차이가 있는가?
3. 할인율이 높은 주문은 반품률도 높은가?
4. 이상치가 평균 매출을 왜곡하는가?
5. 현재 데이터로 결론 내리기 어려운 점은 무엇인가?

---

### 5회차: 재현 가능한 분석 파이프라인 (3시간)

#### 수업 목표
노트북에서 하던 분석을 `uv run python scripts/run_pipeline.py` 한 줄로 재실행 가능한 파이프라인으로 전환한다.

#### 시간 배분

| 시간 | 내용 | 형태 |
|------|------|------|
| 0:00~0:30 | 파이프라인 개념: 왜 노트북만으로는 부족한가 | 강의 |
| 0:30~1:00 | Story 구현: src/data/cleaning.py, src/analysis/kpis.py | 실습 |
| 1:00~1:10 | 휴식 | — |
| 1:10~1:50 | Story 구현: scripts/run_pipeline.py 통합 | 실습 |
| 1:50~2:10 | 품질 게이트 구현: quality_gate.py | 실습 |
| 2:10~2:20 | 휴식 | — |
| 2:20~2:50 | config.yaml 기반 재사용 테스트 | 실습 |
| 2:50~3:00 | BMAD 코드 리뷰 실행 및 과제 안내 | 실습 |

#### 핵심 코드: scripts/run_pipeline.py

```python
# scripts/run_pipeline.py
"""분석 파이프라인 메인 진입점이다."""
import sys
sys.path.insert(0, ".")

from src.data.loaders import load_config, load_raw_data
from src.data.schema import validate_schema
from src.data.cleaning import clean_data
from src.data.quality_checks import run_all_checks
from src.analysis.eda import generate_eda_report
from src.analysis.kpis import compute_kpis
from src.visualization.charts import save_all_charts

def main():
    config = load_config()
    print("=" * 50)
    print(f"파이프라인 시작: {config['meta']['project_name']}")
    print("=" * 50)

    # 1. 데이터 로딩
    df = load_raw_data(config)

    # 2. 스키마 검증
    validate_schema(df, config)

    # 3. 품질 검사
    quality = run_all_checks(df, config)
    print(f"결측값: {sum(v > 0 for v in quality['missing'].values())}개 컬럼")
    print(f"중복: {quality['duplicates']}행")

    # 4. 전처리
    df_clean = clean_data(df, config)
    df_clean.to_csv(config["data"]["processed_path"], index=False)
    print(f"전처리 완료: {config['data']['processed_path']}")

    # 5. KPI 계산
    kpis = compute_kpis(df_clean, config)

    # 6. 시각화
    save_all_charts(df_clean, config)

    # 7. 보고서 생성
    generate_eda_report(df_clean, quality, kpis, config)

    print("=" * 50)
    print("파이프라인 완료")

if __name__ == "__main__":
    main()
```

#### 핵심 코드: 품질 게이트

```python
# src/quality_gate.py
def check_pipeline_output(config: dict) -> bool:
    """파이프라인 산출물을 검증하는 함수이다."""
    from pathlib import Path
    checks = {
        "processed_data": Path(config["data"]["processed_path"]).exists(),
        "quality_report": Path("reports/data_quality.md").exists(),
        "analysis_summary": Path("reports/analysis_summary.md").exists(),
        "charts": len(list(Path(config["output"]["charts_dir"]).glob("*.png"))) > 0,
    }
    print("\n품질 게이트 결과:")
    all_pass = True
    for name, passed in checks.items():
        status = "PASS" if passed else "FAIL"
        if not passed:
            all_pass = False
        print(f"  [{status}] {name}")
    return all_pass
```

#### BMAD 코드 리뷰

```
bmad-code-review
Review the current data analysis pipeline.
Focus on: reproducibility, notebook/src separation, data quality coverage,
hardcoded paths, missing tests, misleading analysis risks.
```

#### 산출물
- data/processed/sales_clean.csv
- artifacts/charts/*.png
- reports/data_quality.md
- reports/analysis_summary.md
- scripts/run_pipeline.py

#### 과제
`uv run python scripts/run_pipeline.py`를 실행하여 모든 산출물이 재생성되는지 확인한다.

---

### 6회차: scikit-learn 머신러닝 baseline (3시간)

#### 수업 목표
정제된 데이터를 이용해 `returned` 컬럼을 예측하는 binary classification baseline 모델을 구축한다.

#### 시간 배분

| 시간 | 내용 | 형태 |
|------|------|------|
| 0:00~0:20 | ML 개념: target, feature, leakage, train/test split | 강의 |
| 0:20~0:50 | Story 구현: build_features.py | 실습 |
| 0:50~1:00 | 휴식 | — |
| 1:00~1:40 | Story 구현: train_sklearn.py, evaluate.py | 실습 |
| 1:40~2:00 | scripts/train_baseline.py 실행 | 실습 |
| 2:00~2:10 | 휴식 | — |
| 2:10~2:30 | AI 모델 어드바이저로 개선 제안 받기 | 실습 |
| 2:30~2:50 | reports/model_report.md 작성 | 실습 |
| 2:50~3:00 | 과제 안내 | — |

#### 핵심 코드: src/models/train_sklearn.py

```python
# src/models/train_sklearn.py
import pandas as pd
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.pipeline import Pipeline
import joblib

def prepare_features(df: pd.DataFrame, config: dict):
    """피처와 타겟을 분리하는 함수이다."""
    target = config["variables"]["target"]
    num_cols = config["variables"]["numeric_features"]
    cat_cols = config["variables"]["categorical_features"]

    X = df[num_cols + cat_cols].copy()
    y = df[target].copy()

    # 범주형 인코딩
    for col in cat_cols:
        le = LabelEncoder()
        X[col] = le.fit_transform(X[col].astype(str))

    return X, y

def train_and_evaluate(X, y, config: dict) -> dict:
    """모델을 학습하고 평가하는 함수이다."""
    seed = config["modeling"]["random_seed"]
    test_ratio = config["modeling"]["test_ratio"]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=test_ratio, random_state=seed, stratify=y
    )

    models = {
        "logistic_regression": Pipeline([
            ("scaler", StandardScaler()),
            ("clf", LogisticRegression(random_state=seed, max_iter=1000))
        ]),
        "random_forest": RandomForestClassifier(
            n_estimators=200, max_depth=10, random_state=seed
        ),
    }

    results = {}
    for name, model in models.items():
        scores = cross_val_score(model, X_train, y_train, cv=5, scoring="f1")
        model.fit(X_train, y_train)
        results[name] = {
            "cv_f1_mean": round(scores.mean(), 4),
            "cv_f1_std": round(scores.std(), 4),
            "model": model,
        }
        print(f"{name}: CV F1 = {scores.mean():.4f} (+/- {scores.std():.4f})")

    return results, X_test, y_test
```

#### AI 모델 어드바이저 사용

```python
from src.ai.interpreter import suggest_model_improvements

metrics = {"cv_f1_mean": 0.72, "cv_f1_std": 0.03, "accuracy": 0.85}
advice = suggest_model_improvements("random_forest", metrics)
print(advice)
```

#### 설치 추가

```bash
uv add joblib
```

#### 실행

```bash
uv run python scripts/train_baseline.py
```

#### 산출물
- artifacts/models/baseline_model.joblib
- artifacts/metrics/baseline_metrics.json
- reports/model_report.md

#### 과제
reports/model_report.md에 다음 섹션을 작성한다.
- Model Objective
- Target Definition
- Features Used
- Leakage Risks
- Metrics
- Interpretation
- Limitations
- Next Experiments

---

### 7회차: PyTorch 딥러닝 기본 구현 (3시간)

#### 수업 목표
scikit-learn 이후 PyTorch로 넘어가는 이유를 이해하고, 동일한 tabular 데이터로 간단한 MLP를 구현한다.

#### 시간 배분

| 시간 | 내용 | 형태 |
|------|------|------|
| 0:00~0:20 | PyTorch 개념: tensor, Dataset, DataLoader, Module | 강의 |
| 0:20~0:30 | PyTorch가 꼭 필요한 상황과 불필요한 상황 | 강의 |
| 0:30~1:00 | Story 구현: torch_models.py (MLP 정의) | 실습 |
| 1:00~1:10 | 휴식 | — |
| 1:10~1:50 | Story 구현: train_pytorch.py (training loop) | 실습 |
| 1:50~2:00 | 휴식 | — |
| 2:00~2:30 | scripts/train_deep_learning.py 실행 | 실습 |
| 2:30~2:50 | scikit-learn baseline과 비교, pytorch_report.md 작성 | 실습 |
| 2:50~3:00 | 과제 안내 | — |

#### 강의 포인트

PyTorch는 "무조건 더 좋은 모델"이 아니다. tabular 데이터에서는 scikit-learn baseline이 더 빠르고 해석하기 쉬운 경우가 많다. PyTorch는 다음 상황에서 의미가 있다.
- 이미지, 텍스트, 음성 데이터
- 시계열 딥러닝
- 대규모 representation learning
- custom loss function
- complex neural architecture

#### 설치

```bash
uv add torch torchvision
```

#### 핵심 코드: src/models/torch_models.py

```python
# src/models/torch_models.py
import torch
import torch.nn as nn

class SimpleMLP(nn.Module):
    """tabular 데이터용 간단한 MLP 모델이다."""
    def __init__(self, input_dim: int, hidden_dim: int = 64):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(input_dim, hidden_dim),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(hidden_dim, hidden_dim // 2),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(hidden_dim // 2, 1),
        )

    def forward(self, x):
        return self.net(x)
```

#### 실행

```bash
uv run python scripts/train_deep_learning.py
```

#### 산출물
- scripts/train_deep_learning.py
- src/models/torch_models.py
- artifacts/models/pytorch_checkpoint.pt
- reports/pytorch_report.md (sklearn baseline과 비교표 포함)

#### 과제

다음 질문에 답하는 reflection을 작성한다.
1. 이 문제에서 PyTorch가 꼭 필요한가?
2. scikit-learn baseline보다 나아진 점이 있는가?
3. 구현 복잡도는 얼마나 증가하였는가?
4. 실제 프로젝트라면 어떤 조건에서 PyTorch를 선택할 것인가?

---

### 8회차: BMAD 리뷰와 최종 프로젝트 발표 (3시간)

#### 수업 목표
지금까지 만든 repo를 하나의 **"AI/Data Lab 템플릿"** 으로 정리하고, BMAD 최종 리뷰를 수행하며 발표한다.

#### 시간 배분

| 시간 | 내용 | 형태 |
|------|------|------|
| 0:00~0:30 | 최종 점검 10항목 확인 | 실습 |
| 0:30~1:00 | BMAD 최종 코드 리뷰 실행 | 실습 |
| 1:00~1:10 | 휴식 | — |
| 1:10~1:30 | README.md 최종 정리 | 실습 |
| 1:30~2:00 | 발표 준비 | 자습 |
| 2:00~2:10 | 휴식 | — |
| 2:10~2:50 | 최종 발표 (팀별 또는 개인별) | 발표 |
| 2:50~3:00 | 수업 정리 및 다음 학습 경로 안내 | 강의 |

#### 최종 점검 10항목

```
1. repo 구조가 명확한가?
2. raw data를 수정하지 않는가?
3. uv run python scripts/run_pipeline.py로 분석 결과가 재생성되는가?
4. notebook과 src 코드가 분리되어 있는가?
5. 데이터 품질검사가 있는가?
6. ML baseline이 있는가?
7. PyTorch 실험이 있는가?
8. 보고서가 비전문가에게도 읽히는가?
9. BMAD 문서(_bmad-output/)가 남아 있는가?
10. 다음 프로젝트에 재사용 가능한가?
```

#### BMAD 최종 리뷰 프롬프트

```
bmad-code-review
Perform a final review of this Python-first AI/Data Lab.
Review against: project-context.md, README.md, PRD.md, architecture.md,
current source code, reports, scripts, tests.
Focus on: reproducibility, data quality, notebook/src separation,
ML evaluation correctness, PyTorch implementation clarity,
documentation quality, risks for future reuse.
Return: PASS / CONCERNS / FAIL, top 10 issues,
recommended next 5 stories, what should become a reusable template.
```

#### 최종 발표 구성

```
1. Project Goal
2. Repo Architecture
3. Data Pipeline
4. Data Quality Findings
5. EDA Insights
6. scikit-learn Baseline 결과
7. PyTorch Experiment 결과
8. BMAD가 도와준 것
9. ChatGPT Projects가 도와준 것
10. Next Roadmap
```

#### 최소 실행 명령 3줄

수업 종료 시 수강생의 repo는 최소한 다음 3줄로 모든 핵심 결과물이 재생성되어야 한다.

```bash
uv run python scripts/generate_sample_data.py
uv run python scripts/run_pipeline.py
uv run python scripts/train_baseline.py
```

PyTorch 포함 시:

```bash
uv run python scripts/train_deep_learning.py
```

---

## 6. 수업용 BMAD 프롬프트 세트

아래 프롬프트는 수업 중 그대로 복사-붙여넣기하여 사용할 수 있다.

### A. bmad-help 시작 프롬프트

```
bmad-help
I am building a Python-first AI/Data Lab, not a website.
The goal is to create a reusable, reproducible system for:
- data analysis, data quality checks,
- machine learning baselines, PyTorch experiments,
- reports, artifacts, AI-assisted workflow management.
Main tools: Claude Code or Gemini CLI, BMAD, ChatGPT Projects, Claude API.
Stack: Python 3.11, uv, pandas, matplotlib, scikit-learn, PyTorch, pytest, ruff.
No SQL in the initial version.
Please recommend the correct full BMAD path.
Do not use Quick Flow unless the task is small.
```

### B. bmad-product-brief

```
bmad-product-brief
Project name: Python-first AI/Data Lab
Problem: Data analysis often stays inside notebooks and becomes
hard to reproduce. AI-generated code can become messy without structure.
Goal: Create a reusable repo structure and workflow for loading raw data,
validating quality, cleaning, EDA, sklearn baselines, PyTorch experiments,
saving artifacts, documenting assumptions.
Non-goals: SQL warehouse, dashboard-first BI, web application, complex MLOps.
```

### C. bmad-create-prd

```
bmad-create-prd
Create a PRD for the Python-first AI/Data Lab.
Functional requirements: standard repo structure, CSV loading, schema validation,
missing/duplicate/outlier detection, cleaning, EDA, charts, reports, artifacts,
sklearn baselines, PyTorch training, Claude API interpretation.
Non-functional: reproducibility, clear folders, testable functions, beginner-friendly.
Out of scope: SQL, dbt, production API, dashboard, distributed training.
```

### D. bmad-create-architecture

```
bmad-create-architecture
Stack: Python 3.11, uv, pandas, matplotlib, scikit-learn, PyTorch, pytest, ruff,
Claude Code/Gemini CLI, BMAD, ChatGPT Projects, Claude/Gemini API.
Principles: raw data immutable, notebooks exploratory, reusable logic in src/,
scripts as entry points, config.yaml for all variable parameters,
Claude API integrated at EDA, modeling, reporting stages.
```

### E. bmad-create-epics-and-stories

```
bmad-create-epics-and-stories
Expected epics:
1. Repository Foundation
2. Data Loading and Validation
3. Data Quality and Cleaning
4. EDA and Reporting (including Claude API interpretation)
5. Reproducible Pipeline
6. scikit-learn Baseline Modeling
7. PyTorch Experimentation
8. Final Documentation and Review
```

### F. bmad-dev-story

```
bmad-dev-story
Rules: Follow project-context.md. Keep notebooks separate from reusable code.
Add tests when reusable logic changes. Do not introduce SQL. Do not over-engineer.
Prefer clear, beginner-readable code. Use config.yaml for variable parameters.
```

---

## 7. 수업 평가 기준

총점 100점

| 평가 항목 | 배점 | 기준 |
|----------|------|------|
| repo 구조 | 15 | 폴더 책임이 명확하고 재사용 가능 |
| 데이터 품질검사 | 15 | 결측치, 중복, 이상치, 스키마 검증 포함 |
| 재현성 | 15 | 단일 명령으로 주요 결과 재생성 가능 |
| pandas 분석 | 10 | EDA와 KPI가 명확함 |
| scikit-learn baseline | 15 | target, feature, metrics, leakage 설명 가능 |
| PyTorch 구현 | 10 | Dataset, DataLoader, model, training loop 구현 |
| 문서화 | 10 | README, reports, assumptions, limitations 포함 |
| BMAD 활용 | 10 | PRD, architecture, story, review 흐름 사용 |

---

## 8. 강사용 운영 가이드

### 수업에서 계속 강조할 원칙

1. ChatGPT는 분석 보조이다. repo의 source of truth는 AI 코딩 도구(Claude Code/Gemini CLI)에서 관리한다.
2. notebook은 실험실이다. 재사용 로직은 src/로 옮긴다.
3. BMAD는 속도를 늦추는 도구가 아니라, 나중에 망가질 프로젝트를 막는 도구이다.
4. 모든 BMAD 워크플로는 새 세션에서 시작한다 (`/clear` 입력).
5. PyTorch는 마지막에 붙인다. pandas와 scikit-learn baseline이 먼저이다.
6. AI가 생성한 코드는 반드시 실행하여 검증한다.

### 수강생이 자주 하는 실수

| 실수 | 교정 |
|------|------|
| notebook에 모든 코드를 몰아넣음 | 재사용 로직은 src/로 이동 |
| ChatGPT 답변을 그대로 붙여넣음 | AI 코딩 도구(claude 또는 gemini)에서 실행, 테스트, 수정 |
| 데이터 품질검사 없이 모델 학습 | schema, missing, duplicate, outlier 먼저 |
| PyTorch부터 시작 | pandas → scikit-learn → PyTorch 순서 유지 |
| BMAD Quick Flow 남발 | 새 프로젝트는 product brief, PRD, architecture 먼저 |
| 리포트 없이 차트만 생성 | 분석 결과, 가정, 한계를 문서화 |
| 이전 채팅에서 새 워크플로 실행 | 반드시 새 세션(`/clear`)에서 시작 |

---

## 9. 압축형 2일 워크숍 버전

8회차가 길다면 아래처럼 2일(각 6시간) 과정으로 축약할 수 있다.

### Day 1: 분석 repo와 BMAD 체계 (6시간)

| 시간 | 내용 |
|------|------|
| 1교시 | BMAD 개념, AI 코딩 도구(Claude Code/Gemini CLI)·ChatGPT Projects 역할 구분 |
| 2교시 | uv, repo, BMAD 설치, 폴더 구조 세팅 |
| 3교시 | BMAD product brief, PRD, architecture |
| 4교시 | 합성 데이터 생성, analysis_config.yaml |
| 5교시 | pandas EDA와 data quality report |
| 6교시 | 재현 가능한 run_pipeline.py + AI 해석 모듈 |

### Day 2: ML과 PyTorch 확장 (6시간)

| 시간 | 내용 |
|------|------|
| 1교시 | feature engineering |
| 2교시 | scikit-learn baseline |
| 3교시 | model evaluation과 leakage 점검 |
| 4교시 | PyTorch Dataset/DataLoader |
| 5교시 | training loop 구현 |
| 6교시 | BMAD code review와 최종 발표 |

---

## 10. 필수 학습 자료

### 영상

| 제목 | URL |
|------|-----|
| The Official BMad-Method Masterclass | https://www.youtube.com/watch?v=LorEJPrALcg |

### 공식 문서

| 자료 | URL |
|------|-----|
| BMAD 공식 문서 | https://docs.bmad-method.org/ |
| BMAD Getting Started | https://docs.bmad-method.org/tutorials/getting-started/ |
| BMAD Workflow Map | https://docs.bmad-method.org/reference/workflow-map/ |
| BMAD Agents Reference | https://docs.bmad-method.org/reference/agents/ |
| BMAD GitHub | https://github.com/bmad-code-org/BMAD-METHOD |
| BMAD Discord | https://discord.gg/gk8jAdXWmj |

### 도구 문서

| 도구 | URL |
|------|-----|
| Claude Code | https://docs.anthropic.com/en/docs/claude-code |
| Gemini CLI | https://github.com/google-gemini/gemini-cli |
| Gemini CLI 공식 문서 | https://developers.google.com/gemini-code-assist/docs/gemini-cli |
| Gemini API 키 발급 (무료) | https://aistudio.google.com/apikey |
| pandas | https://pandas.pydata.org/docs/ |
| scikit-learn | https://scikit-learn.org/stable/ |
| PyTorch | https://pytorch.org/tutorials/ |
| uv | https://docs.astral.sh/uv/ |

---

> **최종 결론**: 이 수업이 끝나면 수강생은 단순한 notebook 하나가 아니라, 다음 데이터분석·AI 프로젝트에도 재사용할 수 있는 **Python-first AI/Data Lab 템플릿**을 갖추게 된다. Claude Code 또는 Gemini CLI가 작업 공간이고, BMAD가 프로젝트 체계이며, ChatGPT가 분석 보조이고, Claude API 또는 Gemini API가 자동 해석기이다.
