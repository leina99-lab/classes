# AI/Data Lab 수업 사전 준비 가이드 


> **준비물**: 인터넷이 연결된 컴퓨터 (Windows 10/11 또는 Mac)

---

## 0단계: "터미널" 이해하기

컴퓨터에 명령을 내리는 방법은 두 가지이다.

1. **마우스로 클릭하기** — 우리가 평소에 쓰는 방식이다. 폴더를 더블클릭하고, 프로그램 아이콘을 누른다.
2. **글자를 타이핑하기** — 검은 화면에 명령어를 입력하는 방식이다. 이것이 "**터미널**"이다.

터미널은 프로그래머들이 쓰는 특별한 도구가 아니다. 모든 컴퓨터에 이미 설치되어 있다. 이름만 운영체제마다 다르다:

| 운영체제 | 터미널 이름 | 이 수업에서 사용하는 것 |
|---------|-----------|---------------------|
| Windows | PowerShell, 명령 프롬프트(cmd), Windows Terminal | **PowerShell** (권장) |
| Mac | 터미널(Terminal) | **터미널** |

---

## 1단계: 터미널 열기

### Windows에서 PowerShell 여는 법

**방법 1 (가장 쉬움):**
1. 키보드에서 **Windows 키**를 누른다 (키보드 왼쪽 아래, Ctrl과 Alt 사이에 있는 윈도우 로고 키이다)
2. "PowerShell"이라고 타이핑한다
3. "**Windows PowerShell**"이 검색 결과에 나타난다
4. 클릭한다

**방법 2:**
1. 바탕화면이나 아무 폴더에서 **빈 공간을 오른쪽 클릭**한다
2. "**터미널에서 열기**" 또는 "**PowerShell 창 여기서 열기**"를 클릭한다

**열리면 이렇게 생겼다:**
```
PS C:\Users\내이름>
```
이 화면이 보이면 성공이다. `PS`는 PowerShell이라는 뜻이고, `C:\Users\내이름`은 현재 위치이다.

### Mac에서 터미널 여는 법

**방법 1 (가장 쉬움):**
1. 키보드에서 **Cmd + Space**를 동시에 누른다 (Spotlight 검색이 뜬다)
2. "터미널" 또는 "Terminal"이라고 타이핑한다
3. "**터미널**"이 검색 결과에 나타난다
4. Enter를 누른다

**방법 2:**
1. Finder → 응용 프로그램 → 유틸리티 → **터미널**을 더블클릭한다

**열리면 이렇게 생겼다:**
```
내이름@MacBook ~ %
```
이 화면이 보이면 성공이다.

### 확인: 터미널이 정상 작동하는가?

터미널에 다음을 **그대로** 타이핑하고 Enter를 누른다:

```
echo "Hello"
```

화면에 `Hello`가 출력되면 터미널이 정상 작동하는 것이다.

> **중요**: 이후 모든 설치 명령어는 이 터미널(PowerShell 또는 Mac 터미널)에서 실행한다. Jupyter Notebook이나 VS Code가 아니다. 브라우저도 아니다. **터미널**이다.

---

## 2단계: Node.js 설치

Node.js는 Claude Code와 Gemini CLI, 그리고 BMAD를 설치하기 위해 필요한 기반 소프트웨어이다. Node.js를 설치한다고 해서 JavaScript를 배워야 하는 것은 아니다. 설치 도구를 실행하기 위한 기반일 뿐이다.

### 설치 방법

1. 브라우저에서 **https://nodejs.org** 에 접속한다
2. 초록색 버튼 두 개가 보인다. **왼쪽 "LTS**" 버튼을 누른다
   - LTS = Long Term Support (안정 버전)이라는 뜻이다
   - 2026년 기준 v22.x 또는 v24.x가 표시된다. 숫자가 20 이상이면 된다
3. 다운로드된 파일을 **더블클릭**하여 설치한다
4. 설치 화면에서 모든 것을 "**Next**" 또는 "**다음**"으로 넘긴다. 아무것도 바꾸지 않아도 된다
5. 설치가 끝나면 **터미널을 닫았다가 다시 연다** (이것이 중요하다!)

### 설치 확인

터미널을 **새로 열고** 다음을 입력한다:

```
node --version
```

결과 예시:
```
v22.12.0
```

숫자가 **20 이상**이면 성공이다.

다음도 확인한다:

```
npm --version
```

결과 예시:
```
10.9.0
```

숫자가 나오면 성공이다. npm은 Node.js와 함께 자동으로 설치되는 패키지 관리 도구이다.

> "**command not found" 또는 "'node'은(는) 내부 또는 외부 명령..." 오류가 나오면**: 터미널을 닫았다가 다시 열어본다. 그래도 안 되면 컴퓨터를 재시작한다.

---

## 3단계: AI 코딩 도구 설치 (둘 중 하나 선택)

### 옵션 A: Gemini CLI (무료 — 권장)

**비용**: 완전 무료 (Google 계정만 필요)
**한도**: 하루 1,000 요청 (3시간 수업에 충분)
**필요한 것**: Gmail 계정 (구글 계정)

**설치: 터미널에서 다음 한 줄을 입력한다:**

```
npm install -g @google/gemini-cli
```

- `npm`은 Node.js의 패키지 설치 도구이다 (2단계에서 함께 설치되었다)
- `install`은 "설치하라"는 명령이다
- `-g`는 "이 컴퓨터 전체에서 사용할 수 있게"라는 옵션이다
- `@google/gemini-cli`는 설치할 프로그램의 이름이다

설치가 진행되면서 여러 줄의 텍스트가 나온다. 마지막에 오류 없이 끝나면 성공이다.

**첫 실행 및 Google 로그인:**

```
gemini
```

1. 처음 실행하면 Google 로그인 화면이 브라우저에 뜬다
2. Gmail 계정으로 로그인한다
3. "허용"을 누른다
4. 터미널로 돌아오면 Gemini CLI가 준비된 것이다

**설치 확인:**

```
gemini --version
```

버전 번호가 출력되면 설치 완료이다.

### 옵션 B: Claude Code (유료)

**비용**: Anthropic Max 구독 필요 ($100/월) 또는 API 키 사용 (종량제)
**장점**: 코딩 품질이 현재 최고 수준
**필요한 것**: Anthropic 계정 + 구독 또는 API 키

**설치: 터미널에서 다음 한 줄을 입력한다:**

```
npm install -g @anthropic-ai/claude-code
```

**설치 확인:**

```
claude --version
```

버전 번호가 출력되면 설치 완료이다.

**첫 실행:**

```
claude
```

처음 실행하면 Anthropic 계정 인증을 요구한다. 브라우저가 열리면 로그인한다.

> **수업에서의 권장**: 비용이 부담된다면 Gemini CLI를 사용한다. 이 수업의 모든 실습은 두 도구 모두에서 동일하게 작동한다.

---

## 4단계: Git 설치

Git은 프로젝트의 변경 이력을 관리하는 도구이다. 코드를 "저장"하는 것과 비슷하지만, 모든 변경 기록이 남는다.

### Windows

1. **https://git-scm.com** 에 접속한다
2. "**Download for Windows**" 버튼을 누른다
3. 다운로드된 파일을 더블클릭하여 설치한다
4. 설치 화면에서 모든 것을 "**Next**"로 넘긴다 (기본 설정 그대로)
5. 터미널을 **닫았다가 다시 연다**

### Mac

Mac에는 Git이 이미 설치되어 있는 경우가 많다. 터미널에서 확인한다:

```
git --version
```

`git version 2.x.x`가 나오면 이미 설치되어 있다. 아무것도 할 필요 없다.

만약 "Xcode Command Line Tools를 설치하시겠습니까?" 팝업이 뜨면 "**설치**"를 누른다.

### 설치 확인

```
git --version
```

```
git version 2.43.0
```

버전 번호가 나오면 성공이다.

---

## 5단계: Python 설치

Python은 데이터분석과 AI의 핵심 프로그래밍 언어이다.

### Windows

1. **https://www.python.org** 에 접속한다
2. "**Download Python 3.x.x**" 버튼을 누른다 (3.11 이상이면 된다)
3. 다운로드된 파일을 더블클릭한다
4. **반드시** 설치 화면 맨 아래의 "**Add python.exe to PATH**" 체크박스에 체크한다
   - 이것을 빠뜨리면 터미널에서 Python을 찾지 못한다. 매우 중요하다!
5. "**Install Now**"를 클릭한다
6. 터미널을 **닫았다가 다시 연다**

### Mac

Mac에는 Python이 이미 설치되어 있지만, 버전이 낮을 수 있다:

```
python3 --version
```

3.11 이상이면 그대로 사용한다. 그렇지 않으면 https://www.python.org 에서 다운로드한다.

### 설치 확인

**Windows:**
```
python --version
```

**Mac:**
```
python3 --version
```

```
Python 3.12.4
```

3.11 이상이면 성공이다.

> **Windows에서 "python"을 쳤는데 Microsoft Store가 열리는 경우**: Python을 설치할 때 "Add to PATH"를 빠뜨린 것이다. Python을 제거하고 다시 설치하되, 이번에는 PATH 체크박스를 반드시 체크한다.

---

## 6단계: uv 설치

uv는 Python 프로젝트의 패키지(라이브러리)를 관리하는 도구이다. pip보다 빠르고 안정적이다.

### Windows (PowerShell에서)

```
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

이 명령어가 길어 보이지만, 그대로 복사-붙여넣기하면 된다.

### Mac (터미널에서)

```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 설치 확인

터미널을 **닫았다가 다시 열고**:

```
uv --version
```

```
uv 0.6.12
```

버전 번호가 나오면 성공이다.

---

## 7단계: VS Code 설치 (선택 사항)

VS Code는 코드 편집기이다. AI 코딩 도구(Claude Code/Gemini CLI)가 코드를 만들어 주면, VS Code에서 그 코드를 편하게 **보고 편집**할 수 있다. 필수는 아니지만 권장한다.

1. **https://code.visualstudio.com** 에 접속한다
2. 운영체제에 맞는 버전을 다운로드한다
3. 설치한다 (기본 설정 그대로)

---

## 8단계: 전체 설치 확인

모든 설치가 끝났으면, 터미널을 **새로 열고** 다음을 하나씩 입력하여 확인한다:

```
node --version
```
→ v20 이상이면 통과

```
npm --version
```
→ 숫자가 나오면 통과

```
git --version
```
→ 숫자가 나오면 통과

```
python --version
```
→ 3.11 이상이면 통과 (Mac에서는 `python3 --version`)

```
uv --version
```
→ 숫자가 나오면 통과

**AI 코딩 도구 (선택한 것만):**

```
gemini --version
```
→ 숫자가 나오면 통과 (Gemini CLI 선택 시)

```
claude --version
```
→ 숫자가 나오면 통과 (Claude Code 선택 시)

### 전체 확인 스크립트

아래 명령어를 터미널에 복사-붙여넣기하면 한 번에 확인할 수 있다:

**Windows (PowerShell):**
```powershell
Write-Host "=== 설치 확인 ===" -ForegroundColor Green
Write-Host "Node.js: $(node --version 2>$null)" 
Write-Host "npm:     $(npm --version 2>$null)"
Write-Host "Git:     $(git --version 2>$null)"
Write-Host "Python:  $(python --version 2>$null)"
Write-Host "uv:      $(uv --version 2>$null)"
Write-Host "Gemini:  $(gemini --version 2>$null)"
Write-Host "Claude:  $(claude --version 2>$null)"
Write-Host "=== 확인 완료 ===" -ForegroundColor Green
```

**Mac (터미널):**
```bash
echo "=== 설치 확인 ==="
echo "Node.js: $(node --version 2>/dev/null || echo '미설치')"
echo "npm:     $(npm --version 2>/dev/null || echo '미설치')"
echo "Git:     $(git --version 2>/dev/null || echo '미설치')"
echo "Python:  $(python3 --version 2>/dev/null || echo '미설치')"
echo "uv:      $(uv --version 2>/dev/null || echo '미설치')"
echo "Gemini:  $(gemini --version 2>/dev/null || echo '미설치')"
echo "Claude:  $(claude --version 2>/dev/null || echo '미설치')"
echo "=== 확인 완료 ==="
```

---
