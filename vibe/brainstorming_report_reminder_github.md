# 보강 안내서: `brainstorming-report.md` 만들기

## 2회차로 넘어가기 전, 반드시 확인해야 할 1회차 산출물

2회차에서는 `project-context.md`, `product-brief.md`, `PRD.md`를 만든다.  
그런데 이 세 문서는 아무것도 없는 상태에서 시작하면 품질이 떨어진다.

2회차의 출발점은 1회차에서 만든 다음 파일이다.

```text
_bmad-output/brainstorming-report.md
```

이 파일은 단순한 메모가 아니다.  
이 파일은 앞으로 만들 프로젝트 문서들의 첫 재료다.

```text
brainstorming-report.md
→ project-context.md
→ product-brief.md
→ PRD.md
→ architecture.md
→ epic/story
→ implementation
```

따라서 2회차를 시작하기 전에 반드시 `brainstorming-report.md`가 있어야 한다.

---

## 0. 오늘 이 안내서로 해야 할 일

이 안내서를 보며 다음 네 가지를 완료한다.

```text
1. 프로젝트 폴더로 이동한다.
2. BMAD와 AI 코딩 도구를 실행한다.
3. bmad-brainstorming으로 brainstorming-report.md를 만든다.
4. 파일이 실제로 생성되었는지 확인한다.
```

---

## 1. 먼저 용어를 구분한다

이 수업에서는 입력하는 위치가 중요하다.  
아래 세 가지를 구분해야 한다.

| 구분 | 의미 | 예시 |
|---|---|---|
| 터미널 | 컴퓨터에 명령을 입력하는 창 | PowerShell, Mac Terminal |
| AI 코딩 도구 | AI와 대화하며 파일을 만들거나 수정하는 도구 | Gemini CLI, Claude Code |
| Markdown 파일 | 프로젝트 문서를 저장하는 `.md` 파일 | `brainstorming-report.md` |

이 안내서에서는 입력 위치를 다음처럼 표시한다.

```text
[터미널]에 입력
```

```text
[AI 코딩 도구]에 입력
```

```text
[파일 내용]
```

---

## 2. 터미널 열기

### Windows

1. 키보드에서 `Windows 키`를 누른다.
2. `PowerShell`이라고 입력한다.
3. `Windows PowerShell`을 클릭한다.

열리면 보통 다음과 비슷하게 보인다.

```powershell
PS C:\Users\내이름>
```

### Mac

1. `Cmd + Space`를 누른다.
2. `Terminal` 또는 `터미널`이라고 입력한다.
3. Enter를 누른다.

열리면 보통 다음과 비슷하게 보인다.

```bash
내이름@MacBook ~ %
```

---

## 3. 프로젝트 폴더로 이동하기

먼저 현재 위치를 확인한다.

### [터미널]에 입력

```bash
pwd
```

`pwd`는 현재 내가 어느 폴더에 있는지 보여 주는 명령이다.

예를 들어 프로젝트 폴더 이름이 `ai-data-lab`이라면 다음처럼 이동한다.

### [터미널]에 입력

```bash
cd ai-data-lab
```

다시 현재 위치를 확인한다.

### [터미널]에 입력

```bash
pwd
```

현재 위치가 프로젝트 폴더라면 다음 단계로 넘어간다.

> 프로젝트 폴더가 어디 있는지 모르겠다면, 파일 탐색기나 Finder에서 프로젝트 폴더를 먼저 찾은 뒤 그 경로를 확인한다.

---

## 4. `_bmad-output` 폴더가 있는지 확인하기

`brainstorming-report.md`는 `_bmad-output` 폴더 안에 만들어진다.

### Windows PowerShell에서 확인

```powershell
dir
```

### Mac Terminal에서 확인

```bash
ls
```

목록에 다음 폴더가 있으면 좋다.

```text
_bmad-output
```

없어도 괜찮다. 나중에 만들 수 있다.

---

## 5. 이미 `brainstorming-report.md`가 있는지 확인하기

### Windows PowerShell

```powershell
dir _bmad-output
```

### Mac Terminal

```bash
ls _bmad-output
```

다음 파일이 보이면 이미 생성된 것이다.

```text
brainstorming-report.md
```

보이지 않으면 지금부터 만든다.

---

## 6. BMAD 설치가 되어 있는지 확인하기

프로젝트 폴더에서 BMAD를 사용하려면 BMAD가 설치되어 있어야 한다.

먼저 아래 명령을 실행한다.

### [터미널]에 입력

```bash
npx bmad-method install
```

설치 마법사가 뜨면 다음 기준으로 답한다.

| 질문 | 답변 | 이유 |
|---|---|---|
| Where should BMad files be installed? | Current directory | 지금 프로젝트 폴더에 설치 |
| Select modules to install | BMad Method 선택 | 핵심 BMAD workflow 사용 |
| Select tools to configure | Gemini 또는 Claude Code 선택 | 사용 중인 AI 도구 연결 |
| Shard PRD and Architecture? | Yes | 긴 문서를 나누어 AI가 다루기 쉽게 함 |
| 나머지 질문 | Enter | 기본값 사용 |

설치가 끝나면 다시 프로젝트 폴더에 있는지 확인한다.

### [터미널]에 입력

```bash
pwd
```

---

## 7. AI 코딩 도구 실행하기

이제 AI 코딩 도구를 실행한다.

Gemini CLI를 사용하는 경우:

### [터미널]에 입력

```bash
gemini
```

Claude Code를 사용하는 경우:

### [터미널]에 입력

```bash
claude
```

정상적으로 실행되면 터미널 안에서 AI와 대화할 수 있는 화면이 열린다.

---

## 8. BMAD가 연결되어 있는지 확인하기

AI 코딩 도구 안에서 다음을 입력한다.

### [AI 코딩 도구]에 입력

```text
bmad-help
```

정상이라면 BMAD가 현재 프로젝트 상태를 보고 다음에 무엇을 해야 할지 안내한다.

예상되는 응답은 다음과 비슷하다.

```text
This appears to be a new project.
Recommended next steps: brainstorming, product brief, PRD...
```

또는 한국어로 다음처럼 나올 수 있다.

```text
현재 프로젝트는 신규 프로젝트입니다.
다음 단계로 brainstorming을 실행할 수 있습니다.
```

---

## 9. 새 세션으로 시작하기

BMAD workflow는 가능한 한 새 세션에서 시작하는 것이 좋다.  
이전 대화 내용이 남아 있으면 AI가 중요한 지시를 혼동할 수 있다.

### [AI 코딩 도구]에 입력

```text
/clear
```

그다음 brainstorming을 시작한다.

### [AI 코딩 도구]에 입력

```text
bmad-brainstorming
```

---

## 10. `bmad-brainstorming`에서 무엇을 대답해야 하는가

BMAD가 질문을 시작하면, 완벽한 답을 하려고 하지 않아도 된다.  
처음에는 거칠게 답하고, AI의 되묻기를 통해 다듬으면 된다.

가장 중요한 것은 다음 네 가지다.

```text
1. 내가 어떤 주제를 다루고 싶은가
2. 왜 이 주제가 중요한가
3. 어떤 데이터를 사용할 수 있을 것 같은가
4. 이 프로젝트로 무엇을 알고 싶은가
```

---

## 11. 처음 답변이 막힐 때 사용하는 시작 문장

아래 중 하나를 골라 자신의 상황에 맞게 고쳐 말한다.

### 예시 1: 데이터분석 주제가 아직 흐릿한 경우

```text
저는 아직 주제가 완전히 정해지지 않았습니다.
하지만 데이터분석과 머신러닝을 배울 수 있는 프로젝트를 만들고 싶습니다.
가능하면 실제 데이터 또는 합성 데이터를 사용해서 EDA, baseline 모델, 딥러닝까지 확장하고 싶습니다.
저에게 적합한 프로젝트 주제를 함께 좁혀 주세요.
```

### 예시 2: 온라인 쇼핑몰 데이터를 생각하는 경우

```text
저는 온라인 쇼핑몰 데이터를 분석하는 프로젝트를 하고 싶습니다.
주문, 매출, 반품, 고객 특성을 분석하고 싶습니다.
특히 어떤 제품이나 채널에서 반품이 많이 발생하는지 알고 싶습니다.
나중에는 반품 여부를 예측하는 baseline 모델까지 만들고 싶습니다.
```

### 예시 3: 교육 데이터를 생각하는 경우

```text
저는 학습자 데이터를 분석하는 프로젝트를 하고 싶습니다.
공부시간, 수면시간, 과제 제출, 시험점수 같은 변수를 보고 싶습니다.
처음에는 공부시간과 시험점수의 관계를 분석하고,
나중에는 시험점수를 예측하는 모델로 확장하고 싶습니다.
```

### 예시 4: 건강 데이터를 생각하는 경우

```text
저는 건강 또는 생활습관 데이터를 분석하는 프로젝트를 하고 싶습니다.
수면시간, 운동시간, 스트레스, 건강점수 같은 변수를 다루고 싶습니다.
처음에는 변수 간 관계를 살펴보고,
나중에는 건강점수나 위험 여부를 예측하는 모델로 확장하고 싶습니다.
```

---

## 12. AI가 물어볼 가능성이 높은 질문

AI는 보통 다음과 같은 질문을 한다.

```text
이 프로젝트의 대상 사용자는 누구인가?
이 프로젝트가 해결하려는 문제는 무엇인가?
사용할 수 있는 데이터는 있는가?
데이터가 없다면 합성 데이터를 만들어도 되는가?
이 프로젝트의 성공 기준은 무엇인가?
이번 버전에서 하지 않을 것은 무엇인가?
```

답변이 완벽하지 않아도 된다.  
대신 다음 원칙을 지킨다.

```text
모르면 모른다고 말한다.
추측은 추측이라고 말한다.
데이터가 없으면 데이터가 없다고 말한다.
하고 싶은 것과 하지 않을 것을 구분한다.
```

---

## 13. brainstorming 대화가 끝났을 때 요청할 것

대화가 어느 정도 정리되면 AI에게 다음을 요청한다.

### [AI 코딩 도구]에 입력

```text
지금까지의 brainstorming 결과를 정리해서
_bmad-output/brainstorming-report.md 파일로 저장해줘.

반드시 다음 항목을 포함해줘.

1. 프로젝트 주제 후보
2. 최종 선택한 프로젝트 주제
3. 이 주제를 선택한 이유
4. 해결하려는 문제
5. 예상 사용자 또는 활용자
6. 사용할 수 있는 데이터 또는 만들 수 있는 합성 데이터
7. 주요 분석 질문
8. 머신러닝으로 확장 가능한 질문
9. 프로젝트 범위
10. 이번 버전에서 하지 않을 것
11. 위험 요소와 불확실한 점
12. 다음 단계에서 project-context.md에 반영해야 할 핵심 규칙
```

---

## 14. AI가 파일을 실제로 만들었는지 확인하기

AI가 “저장했습니다”라고 말해도 반드시 직접 확인한다.

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
```

---

## 15. 파일 내용 확인하기

### Windows PowerShell

```powershell
Get-Content _bmad-output\brainstorming-report.md
```

### Mac Terminal

```bash
cat _bmad-output/brainstorming-report.md
```

내용이 너무 길면 파일 탐색기, Finder, VS Code 등으로 열어도 된다.

---

## 16. AI가 파일을 만들지 못하는 경우

AI 코딩 도구가 환경에 따라 파일을 직접 만들지 못할 수 있다.  
그럴 때는 직접 파일을 만들고, AI가 준 내용을 붙여넣으면 된다.

### Windows PowerShell

```powershell
mkdir _bmad-output
notepad _bmad-output\brainstorming-report.md
```

메모장이 열리면 AI가 정리해 준 내용을 붙여넣고 저장한다.

### Mac Terminal

```bash
mkdir -p _bmad-output
nano _bmad-output/brainstorming-report.md
```

`nano`가 열리면 AI가 정리해 준 내용을 붙여넣는다.

저장 방법:

```text
Ctrl + O
Enter
Ctrl + X
```

---

## 17. `brainstorming-report.md` 품질 체크리스트

파일이 존재하는 것만으로는 충분하지 않다.  
내용이 다음 단계로 넘어갈 만큼 정리되어 있어야 한다.

아래 항목을 확인한다.

```text
[ ] 프로젝트 주제가 한 문장으로 정리되어 있다.
[ ] 왜 이 주제를 선택했는지 이유가 적혀 있다.
[ ] 해결하려는 문제가 데이터로 확인 가능한 형태로 적혀 있다.
[ ] 사용할 데이터 또는 합성 데이터 아이디어가 있다.
[ ] 주요 분석 질문이 3개 이상 있다.
[ ] 머신러닝으로 확장 가능한 질문이 1개 이상 있다.
[ ] 이번 버전에서 하지 않을 것이 적혀 있다.
[ ] 불확실한 점이나 위험 요소가 적혀 있다.
[ ] 다음 단계인 project-context.md에 반영할 규칙이 적혀 있다.
```

체크가 6개 미만이면 brainstorming이 아직 부족하다.  
AI 코딩 도구에 다음을 입력해서 보강한다.

### [AI 코딩 도구]에 입력

```text
brainstorming-report.md가 아직 부족하다.
다음 항목을 보강하기 위해 나에게 하나씩 질문해줘.

1. 프로젝트 주제
2. 주제를 선택한 이유
3. 사용할 데이터
4. 주요 분석 질문
5. 머신러닝 확장 가능성
6. 이번 버전에서 하지 않을 것
7. 위험 요소

한 번에 여러 질문을 하지 말고, 하나씩 물어봐줘.
```

---

## 18. `brainstorming-report.md` 기본 템플릿

AI가 만든 결과가 너무 산만하다면 아래 구조로 정리한다.

### [파일 내용 예시]

```md
# Brainstorming Report

## 1. Project Topic Candidates

- 후보 1:
- 후보 2:
- 후보 3:

## 2. Selected Project Topic

최종 선택한 주제:

## 3. Why This Topic Matters

이 주제를 선택한 이유:

## 4. Problem to Explore

데이터로 확인하고 싶은 문제:

## 5. Expected Users or Stakeholders

이 분석 결과를 사용할 사람 또는 상황:

## 6. Data Ideas

사용 가능한 데이터:

합성 데이터가 필요한 경우:

예상 변수:

- 변수 1:
- 변수 2:
- 변수 3:

## 7. Initial Analysis Questions

1.
2.
3.

## 8. Possible Machine Learning Extension

예측하고 싶은 값:

가능한 target:

가능한 feature:

## 9. In Scope

이번 버전에서 할 것:

- 
- 
- 

## 10. Out of Scope

이번 버전에서 하지 않을 것:

- 
- 
- 

## 11. Risks and Unknowns

불확실한 점:

- 
- 
- 

## 12. Notes for project-context.md

다음 단계에서 프로젝트 규칙으로 반영할 것:

- 
- 
- 
```

---

## 19. 완성 후 다음 단계

`brainstorming-report.md`가 준비되면 2회차로 넘어갈 수 있다.

2회차에서는 다음 세 문서를 만든다.

```text
_bmad-output/project-context.md
_bmad-output/product-brief.md
_bmad-output/PRD.md
```

2회차 시작 전 AI 코딩 도구에서 다음을 입력한다.

### [AI 코딩 도구]에 입력

```text
bmad-help
```

그다음 현재 상태를 확인한다.

```text
_bmad-output/brainstorming-report.md 파일이 있는지 확인해줘.
있다면 이 파일을 바탕으로 2회차에서 project-context.md, product-brief.md, PRD.md를 만들 준비가 되었는지 점검해줘.
```

---

## 20. 자주 생기는 문제와 해결법

### 문제 1. `bmad-brainstorming`이 인식되지 않는다

먼저 `bmad-help`를 실행한다.

### [AI 코딩 도구]에 입력

```text
bmad-help
```

명령 이름이 다르게 표시되면 BMAD가 안내하는 정확한 명령을 따른다.

---

### 문제 2. AI가 웹앱 아이디어를 제안한다

이 수업의 프로젝트는 웹앱이 아니라 Python-first AI/Data Lab이다.  
다음처럼 바로 교정한다.

### [AI 코딩 도구]에 입력

```text
잠시 멈춰줘.
이 프로젝트는 웹 애플리케이션이 아니라 Python-first AI/Data Lab이다.
데이터분석, EDA, baseline modeling, PyTorch 확장을 염두에 둔 프로젝트로 다시 brainstorming을 진행해줘.
```

---

### 문제 3. 데이터가 아직 없다

데이터가 없어도 brainstorming은 가능하다.  
다만 보고서에 “합성 데이터로 시작한다”는 점을 명확히 적어야 한다.

### [AI 코딩 도구]에 입력

```text
현재 실제 데이터가 없다.
초기 버전은 합성 데이터로 시작하려 한다.
나중에 실제 데이터로 바꿀 수 있도록 변수와 데이터 구조를 먼저 설계하는 방향으로 brainstorming을 도와줘.
```

---

### 문제 4. 주제가 너무 크다

예를 들어 “건강 데이터를 분석한다”는 너무 크다.  
다음처럼 좁힌다.

```text
큰 주제: 건강 데이터 분석
좁힌 주제: 수면시간, 운동시간, 스트레스 점수로 건강점수와의 관계를 분석한다.
더 좁힌 주제: 수면시간과 운동시간이 건강점수와 어떤 관계를 가지는지 EDA로 확인하고, 건강점수를 예측하는 baseline 모델을 만든다.
```

AI에게는 다음처럼 요청한다.

### [AI 코딩 도구]에 입력

```text
내 주제가 너무 넓다.
8주 수업 안에서 완성 가능한 데이터분석 프로젝트로 범위를 줄여줘.
단, EDA, scikit-learn baseline, PyTorch 확장 가능성은 남겨줘.
```

---

## 21. 최종 확인

아래 네 가지가 완료되면 `brainstorming-report.md` 준비가 끝난 것이다.

```text
[ ] _bmad-output/brainstorming-report.md 파일이 있다.
[ ] 프로젝트 주제가 한 문장으로 정리되어 있다.
[ ] 데이터 아이디어와 분석 질문이 있다.
[ ] 2회차에서 project-context.md를 만들 수 있을 만큼 방향이 잡혀 있다.
```

이제 2회차로 넘어갈 준비가 되었다.
