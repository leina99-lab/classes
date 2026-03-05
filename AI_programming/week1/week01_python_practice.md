# 1주차 — 파이썬(Python) 기초 ① 실습 자료

# 변수(Variable), 자료형(Data Type), 숫자형(Numeric), 문자열(String)

**활용 데이터:** 코로나19(COVID-19) 확진자 수

> **데이터 출처:** Our World in Data (https://github.com/owid/covid-19-data)
> 1주차는 `pandas`를 아직 배우지 않았으므로, 리스트(list)와 딕셔너리(dict)로 직접 입력한 데이터를 사용한다.
> 상세한 다운로드 방법은 별도 배포 자료 "**데이터셋 확보 가이드**(Dataset Acquisition Guide)"를 참고하라.

---

## 수업 흐름 안내(Class Flow)

| 순서 | 시간 | 내용 |
|---|---|---|
| A | 25분 | AI 윤리 토론 (별도 자료) |
| B | 20분 | 개념 브리핑: 변수, 자료형, 숫자형, 문자열 |
| C | 30분 | **핑퐁 코딩**(Ping-Pong Coding) — 본 자료의 핵심 |
| D | 50분 | **도전 실습**(Challenge Lab) — 빈칸 채우기 + 자기주도 |
| E | 30분 | 심화 + 연습문제 |

---

# PART A. 개념 브리핑 (20분)

> 이 부분은 교수자가 슬라이드로 진행한다.
> 아래는 학생이 참고할 수 있는 핵심 요약이다.

## A1. 변수(Variable)란?

데이터를 저장하고 재사용하기 위한 **이름이 붙은 저장 공간**이다.

```python
# 변수 만들기: 변수이름 = 값
today_cases = 621328
```

- `=`는 "같다"가 아니라 **"저장하라"**라는 뜻이다.
- "같다"는 `==`를 사용한다.

## A2. 자료형(Data Type) 4가지

| 자료형(Type) | 설명(Description) | 예시(Example) |
|---|---|---|
| `int` | 정수(Integer) | `42`, `-7`, `0` |
| `float` | 실수(Floating Point) | `3.14`, `-0.5`, `1e3` |
| `str` | 문자열(String) | `"Hello"`, `'Python'` |
| `bool` | 불리언(Boolean) | `True`, `False` |

```python
type(42)        # <class 'int'>
type(3.14)      # <class 'float'>
type("Hello")   # <class 'str'>
type(True)      # <class 'bool'>
```

## A3. 숫자형 연산자(Numeric Operators)

| 연산자 | 이름 | 예시 | 결과 |
|---|---|---|---|
| `+` | 더하기(Addition) | `10 + 3` | `13` |
| `-` | 빼기(Subtraction) | `10 - 3` | `7` |
| `*` | 곱하기(Multiplication) | `10 * 3` | `30` |
| `/` | 나누기(Division) | `10 / 3` | `3.333...` |
| `//` | 몫(Floor Division) | `10 // 3` | `3` |
| `%` | 나머지(Modulo) | `10 % 3` | `1` |
| `**` | 거듭제곱(Power) | `10 ** 3` | `1000` |

## A4. 문자열(String) 핵심

```python
# 인덱싱(Indexing): 0부터 시작
s = "Python"
s[0]   # 'P'
s[-1]  # 'n'

# 슬라이싱(Slicing): [시작:끝:간격]
s[0:3]  # 'Pyt'
s[::-1] # 'nohtyP' (뒤집기)

# f-string 포맷팅
name = "Python"
version = 3.12
f"{name} {version}"  # 'Python 3.12'
```

---

# PART B. 핑퐁 코딩 (30분)

> **규칙:** 교수자가 Ping(시연)을 보여주면, 학생은 즉시 Pong(변형)을 작성한다.
> Pong을 다 풀면 손을 들거나 채팅에 "완료"를 입력한다.

---

## Ping-Pong 1: 변수와 자료형

### Ping 1 (교수자 시연)

```python
# 오늘 서울의 기온을 변수에 저장하자
city = "서울"
temperature = 3.5
print(f"오늘 {city}의 기온은 {temperature}도이다.")
print(f"city의 자료형: {type(city)}")
print(f"temperature의 자료형: {type(temperature)}")
```

### Pong 1 (학생 작성)

> **과제:** 2022년 3월 17일 한국의 코로나19 신규 확진자 수를 변수에 저장하고 출력하라.

```python
# Pong 1 — 아래를 완성하라
date = "2022-03-17"
country = ___                  # "한국"을 저장
new_cases = ___                # 621328을 저장
print(f"{date} {country}의 신규 확진자 수: {new_cases}명")
print(f"new_cases의 자료형: {type(_____)}")
```

<details>
<summary>정답 확인</summary>

```python
date = "2022-03-17"
country = "한국"
new_cases = 621328
print(f"{date} {country}의 신규 확진자 수: {new_cases}명")
print(f"new_cases의 자료형: {type(new_cases)}")
```

출력:
```
2022-03-17 한국의 신규 확진자 수: 621328명
new_cases의 자료형: <class 'int'>
```

</details>

---

## Ping-Pong 2: 숫자형 연산

### Ping 2 (교수자 시연)

```python
# 과일 가게 매출 계산
apple_price = 500
apple_sold = 10
total = apple_price * apple_sold
print(f"사과 매출: {total}원")
print(f"천 단위 표시: {total:,}원")
```

### Pong 2 (학생 작성)

> **과제:** 한국의 어제와 오늘 확진자 수로 **증감**(Change)**과 증감률**(Change Rate, %)**을** 계산하라.

```python
# Pong 2 — 아래를 완성하라
yesterday = 580123       # 어제 확진자 수
today = 621328           # 오늘 확진자 수

change = ___             # 오늘 - 어제
change_rate = ___        # (오늘 - 어제) / 어제 * 100

print(f"전일 대비 증감: {change:,}명")
print(f"전일 대비 증감률: {change_rate:.1f}%")
```

<details>
<summary>정답 확인</summary>

```python
yesterday = 580123
today = 621328

change = today - yesterday                      # 41205
change_rate = (today - yesterday) / yesterday * 100  # 약 7.1%

print(f"전일 대비 증감: {change:,}명")       # 전일 대비 증감: 41,205명
print(f"전일 대비 증감률: {change_rate:.1f}%")  # 전일 대비 증감률: 7.1%
```

</details>

---

## Ping-Pong 3: 몫과 나머지

### Ping 3 (교수자 시연)

```python
# 150분 수업 = 몇 시간 몇 분?
total_minutes = 150
hours = total_minutes // 60
minutes = total_minutes % 60
print(f"{total_minutes}분 = {hours}시간 {minutes}분")
```

### Pong 3 (학생 작성)

> **과제:** 코로나 누적 확진자 수 24,591,073명을 **만 명 단위**로 환산하라. (몫과 나머지 사용)

```python
# Pong 3 — 아래를 완성하라
total_cases = 24591073

man_unit = total_cases // ___    # 만 명 단위 (2459)
remainder = total_cases % ___    # 나머지 (1073)

print(f"누적 확진자: 약 {man_unit}만 {remainder}명")
print(f"누적 확진자: {total_cases:,}명")
```

<details>
<summary>정답 확인</summary>

```python
total_cases = 24591073

man_unit = total_cases // 10000    # 2459
remainder = total_cases % 10000    # 1073

print(f"누적 확진자: 약 {man_unit}만 {remainder}명")   # 약 2459만 1073명
print(f"누적 확진자: {total_cases:,}명")                # 24,591,073명
```

</details>

---

## Ping-Pong 4: 문자열 인덱싱과 슬라이싱

### Ping 4 (교수자 시연)

```python
# 파일명에서 날짜 추출
filename = "data_20220317.csv"
date_part = filename[5:13]
year = filename[5:9]
month = filename[9:11]
day = filename[11:13]
ext = filename[-3:]
print(f"날짜: {year}년 {month}월 {day}일")
print(f"확장자: {ext}")
```

### Pong 4 (학생 작성)

> **과제:** 아래 문자열에서 국가 코드, 날짜, 확장자를 각각 추출하라.

```python
# Pong 4 — 아래를 완성하라
report = "covid_KR_20220317_daily.csv"

country_code = report[___:___]    # "KR" 추출
date_str = report[___:___]        # "20220317" 추출
file_ext = report[___:]           # "csv" 추출

print(f"국가: {country_code}")
print(f"날짜: {date_str}")
print(f"확장자: {file_ext}")
```

<details>
<summary>정답 확인</summary>

```python
report = "covid_KR_20220317_daily.csv"

country_code = report[6:8]      # "KR"
date_str = report[9:17]         # "20220317"
file_ext = report[-3:]          # "csv"

print(f"국가: {country_code}")    # 국가: KR
print(f"날짜: {date_str}")       # 날짜: 20220317
print(f"확장자: {file_ext}")     # 확장자: csv
```

힌트: `report`의 각 문자 위치를 세어 보자.
```
c o v i d _ K R _ 2 0 2 2 0 3 1 7 _ d a i l y . c s v
0 1 2 3 4 5 6 7 8 9 ...                          -3-2-1
```

</details>

---

## Ping-Pong 5: 문자열 메서드와 f-string

### Ping 5 (교수자 시연)

```python
# 이메일 주소 분석
email = "  Student01@University.ac.kr  "
email_clean = email.strip()
name, domain = email_clean.split("@")
print(f"이름: {name}")
print(f"도메인: {domain.lower()}")
print(f"대학 메일인가? {domain.endswith('.ac.kr')}")
```

### Pong 5 (학생 작성)

> **과제:** 코로나19 데이터 파일명 문자열을 분석하라.

```python
# Pong 5 — 아래를 완성하라
filename = "  COVID-19_South-Korea_2022-03-17.CSV  "

# 1) 양쪽 공백 제거
clean = filename.___()

# 2) 확장자를 소문자로 변환하여 확인
ext = clean[-3:]
ext_lower = ext.___()
print(f"확장자: {ext_lower}")

# 3) "South-Korea"를 "Republic-of-Korea"로 교체
new_name = clean.___("South-Korea", "Republic-of-Korea")
print(f"변경된 파일명: {new_name}")

# 4) 파일명이 "COVID"로 시작하는지 확인
is_covid = clean.___("COVID")
print(f"코로나 데이터인가? {is_covid}")

# 5) 파일명에서 날짜 부분만 추출 (밑줄 '_'로 split)
parts = clean.split("_")
date_part = parts[___]
print(f"날짜: {date_part}")
```

<details>
<summary>정답 확인</summary>

```python
filename = "  COVID-19_South-Korea_2022-03-17.CSV  "

clean = filename.strip()
ext = clean[-3:]
ext_lower = ext.lower()
print(f"확장자: {ext_lower}")                    # csv

new_name = clean.replace("South-Korea", "Republic-of-Korea")
print(f"변경된 파일명: {new_name}")

is_covid = clean.startswith("COVID")
print(f"코로나 데이터인가? {is_covid}")          # True

parts = clean.split("_")
# parts = ['COVID-19', 'South-Korea', '2022-03-17.CSV']
date_part = parts[2]            # 또는 parts[-1]
print(f"날짜: {date_part}")     # 2022-03-17.CSV
```

추가 도전: `date_part`에서 `.CSV`를 제거하려면?
→ `date_part.split(".")[0]` 또는 `date_part[:10]`

</details>

---

## Ping-Pong 6: f-string 고급 포맷팅

### Ping 6 (교수자 시연)

```python
price = 29900
tax_rate = 0.1
tax = price * tax_rate
total = price + tax

print(f"가격: {price:>10,}원")
print(f"세금: {tax:>10,.0f}원")
print(f"합계: {total:>10,.0f}원")
print(f"세율: {tax_rate:.0%}")
```

### Pong 6 (학생 작성)

> **과제:** 한국과 일본의 코로나 데이터를 f-string 포맷팅으로 보고서 형식 출력을 완성하라.

```python
# Pong 6 — 아래를 완성하라
kr_cases = 621328
jp_cases = 261029
kr_pop = 51740000
jp_pop = 125800000

# 10만 명당 확진률 계산
kr_rate = kr_cases / kr_pop * 100000
jp_rate = ___ / ___ * ___

print("=" * 45)
print(f"{'국가':<10}{'확진자':>12}{'10만명당':>12}")
print("-" * 45)
print(f"{'한국':<10}{kr_cases:>12,}{kr_rate:>12.1f}")
print(f"{'일본':<10}{___:>12,}{___:>12.1f}")
print("=" * 45)
print(f"한국은 일본 대비 {kr_cases / jp_cases:___}배")  # 소수점 2자리
```

<details>
<summary>정답 확인</summary>

```python
kr_cases = 621328
jp_cases = 261029
kr_pop = 51740000
jp_pop = 125800000

kr_rate = kr_cases / kr_pop * 100000
jp_rate = jp_cases / jp_pop * 100000

print("=" * 45)
print(f"{'국가':<10}{'확진자':>12}{'10만명당':>12}")
print("-" * 45)
print(f"{'한국':<10}{kr_cases:>12,}{kr_rate:>12.1f}")
print(f"{'일본':<10}{jp_cases:>12,}{jp_rate:>12.1f}")
print("=" * 45)
print(f"한국은 일본 대비 {kr_cases / jp_cases:.2f}배")
```

출력:
```
=============================================
국가              확진자       10만명당
---------------------------------------------
한국           621,328     1,201.2
일본           261,029       207.5
=============================================
한국은 일본 대비 2.38배
```

</details>

---

# PART C. 도전 실습 (50분)

> 여기서부터는 학생이 **스스로** 문제를 해결한다.
> 각 문제에는 **빈칸 채우기**, **예측 후 실행**, **오류 수정**(Debug) 등 다양한 유형이 섞여 있다.

---

## 도전 1: 빈칸 채우기 — 코로나 확진자 일간 보고서

다음 코드의 빈칸 `___`을 채워서 완성하라.

```python
# ===== 코로나19 일간 보고서 =====
date = "2022-03-17"
country = "대한민국"
new_cases = 621328
new_deaths = 429
total_cases = 7629228
total_deaths = 12774
population = 51740000

# 1) 치명률(Case Fatality Rate) 계산: (총 사망 / 총 확진) * 100
cfr = ___ / ___ * 100

# 2) 인구 대비 확진 비율: (총 확진 / 인구) * 100
infection_rate = ___ / ___ * 100

# 3) 보고서 출력
print("=" * 50)
print(f"  코로나19 일간 보고서 — {___}")
print(f"  국가: {___}")
print("=" * 50)
print(f"  신규 확진: {new_cases:>___}명")     # 천 단위 쉼표, 오른쪽 정렬 12칸
print(f"  신규 사망: {new_deaths:>___}명")     # 천 단위 쉼표, 오른쪽 정렬 12칸
print(f"  누적 확진: {total_cases:>___}명")    # 천 단위 쉼표, 오른쪽 정렬 12칸
print(f"  누적 사망: {total_deaths:>___}명")   # 천 단위 쉼표, 오른쪽 정렬 12칸
print("-" * 50)
print(f"  치명률(CFR): {cfr:___}%")           # 소수점 2자리
print(f"  인구 대비 확진: {infection_rate:___}%") # 소수점 2자리
print("=" * 50)
```

목표 출력:
```
==================================================
  코로나19 일간 보고서 — 2022-03-17
  국가: 대한민국
==================================================
  신규 확진:      621,328명
  신규 사망:          429명
  누적 확진:    7,629,228명
  누적 사망:       12,774명
--------------------------------------------------
  치명률(CFR): 0.17%
  인구 대비 확진: 14.75%
==================================================
```

<details>
<summary>정답 확인</summary>

```python
cfr = total_deaths / total_cases * 100
infection_rate = total_cases / population * 100

print("=" * 50)
print(f"  코로나19 일간 보고서 — {date}")
print(f"  국가: {country}")
print("=" * 50)
print(f"  신규 확진: {new_cases:>12,}명")
print(f"  신규 사망: {new_deaths:>12,}명")
print(f"  누적 확진: {total_cases:>12,}명")
print(f"  누적 사망: {total_deaths:>12,}명")
print("-" * 50)
print(f"  치명률(CFR): {cfr:.2f}%")
print(f"  인구 대비 확진: {infection_rate:.2f}%")
print("=" * 50)
```

</details>

---

## 도전 2: 예측 후 실행 (Predict-Then-Run)

> 아래 각 코드의 출력 결과를 **먼저 손으로 예측**한 뒤, 실행하여 검증하라.
> 예측이 틀렸다면 **왜 틀렸는지** 주석으로 적어라.

### 2-1. 자료형 변환

```python
a = "100"
b = "200"
print(a + b)          # 나의 예측: ___________
print(int(a) + int(b))  # 나의 예측: ___________
print(type(a + b))    # 나의 예측: ___________
```

### 2-2. 나눗셈 자료형

```python
x = 10
y = 5
print(x / y)          # 나의 예측: ___________
print(type(x / y))    # 나의 예측: ___________
print(x // y)         # 나의 예측: ___________
print(type(x // y))   # 나의 예측: ___________
```

### 2-3. 문자열 곱하기와 인덱싱

```python
s = "COVID" * 3
print(s)              # 나의 예측: ___________
print(len(s))         # 나의 예측: ___________
print(s[5:10])        # 나의 예측: ___________
print(s[-5:])         # 나의 예측: ___________
```

### 2-4. 할당 연산자

```python
cases = 1000
cases += 500
cases *= 2
cases -= 200
cases //= 3
print(cases)          # 나의 예측: ___________
```

### 2-5. f-string 포맷

```python
value = 0.07123
print(f"{value:.1%}")   # 나의 예측: ___________
print(f"{value:.2f}")   # 나의 예측: ___________

big = 1234567890
print(f"{big:,}")       # 나의 예측: ___________
print(f"{big:.2e}")     # 나의 예측: ___________
```

<details>
<summary>전체 정답 확인</summary>

**2-1:**
```
100200           # 문자열 + 문자열 = 연결(Concatenation)
300              # 정수 + 정수 = 덧셈
<class 'str'>    # 결과도 문자열
```

**2-2:**
```
2.0              # / 연산은 항상 float를 반환한다!
<class 'float'>  # 정수끼리 나눠도 float
2                # // 연산은 정수를 반환한다
<class 'int'>
```
핵심: 파이썬에서 `/`는 항상 `float`를 반환한다. 이것은 많은 초보자가 놓치는 부분이다.

**2-3:**
```
COVIDCOVIDCOVID  # 문자열 * 3 = 세 번 반복
15               # 5글자 * 3 = 15글자
COVID            # 인덱스 5~9 = 두 번째 "COVID"
COVID            # 마지막 5글자
```

**2-4:**
```
cases = 1000
cases += 500   → 1500
cases *= 2     → 3000
cases -= 200   → 2800
cases //= 3   → 933    (2800 // 3 = 933, 나머지 1 버림)
```
정답: `933`

**2-5:**
```
7.1%              # .1% = 소수점 1자리 퍼센트 (0.07123 × 100 = 7.123 → 7.1%)
0.07              # .2f = 소수점 2자리
1,234,567,890     # 천 단위 쉼표
1.23e+09          # 과학적 표기법
```

</details>

---

## 도전 3: 오류 수정(Debug) — AI가 만든 코드의 버그 찾기

> 아래 코드는 "AI에게 요청하여 받은 코드"라고 가정하자.
> 각 코드에는 **1~2개의 버그**가 숨어 있다. 찾아서 고쳐라.

### 3-1. 변수 이름 오류

```python
# 코로나 확진자 증감 계산
2022_cases = 621328
2021_cases = 7848
change = 2022_cases - 2021_cases
print(f"전년 대비 증감: {change:,}명")
```

> 오류 원인: ______________________________________________
> 수정 코드:

<details>
<summary>정답 확인</summary>

**오류:** 변수 이름이 숫자로 시작한다. 파이썬에서 변수 이름은 숫자로 시작할 수 없다.

```python
cases_2022 = 621328
cases_2021 = 7848
change = cases_2022 - cases_2021
print(f"전년 대비 증감: {change:,}명")
```

</details>

### 3-2. 자료형 오류

```python
# 사용자 입력으로 확진자 수 합계 구하기
day1 = input("1일차 확진자 수: ")  # 사용자가 100을 입력
day2 = input("2일차 확진자 수: ")  # 사용자가 200을 입력
total = day1 + day2
print(f"2일간 총 확진자: {total}명")
```

> 오류 원인: ______________________________________________
> 수정 코드:

<details>
<summary>정답 확인</summary>

**오류:** `input()`은 항상 문자열(`str`)을 반환한다. `"100" + "200"` = `"100200"` (문자열 연결)이 된다.

```python
day1 = int(input("1일차 확진자 수: "))
day2 = int(input("2일차 확진자 수: "))
total = day1 + day2
print(f"2일간 총 확진자: {total}명")
```

</details>

### 3-3. 연산 순서 오류

```python
# 증감률 계산: (오늘 - 어제) / 어제 * 100
today = 621328
yesterday = 580123

rate = today - yesterday / yesterday * 100
print(f"증감률: {rate:.1f}%")
```

> 오류 원인: ______________________________________________
> 수정 코드:

<details>
<summary>정답 확인</summary>

**오류:** 연산자 우선순위 문제. `/`와 `*`가 `-`보다 먼저 계산된다.
`today - yesterday / yesterday * 100` = `621328 - (580123 / 580123 * 100)` = `621328 - 100` = `621228`

```python
rate = (today - yesterday) / yesterday * 100
print(f"증감률: {rate:.1f}%")   # 7.1%
```

</details>

### 3-4. 문자열 메서드 오류

```python
# 파일명에서 확장자 확인
filename = "covid_data.CSV"
if filename.endswith("csv"):
    print("CSV 파일이다.")
else:
    print("CSV 파일이 아니다.")
```

> 오류 원인: ______________________________________________
> 수정 코드:

<details>
<summary>정답 확인</summary>

**오류:** 파일명의 확장자가 대문자 `"CSV"`인데, `endswith("csv")`는 소문자만 비교한다. 대소문자가 다르므로 `False`가 반환된다.

```python
filename = "covid_data.CSV"
if filename.lower().endswith("csv"):
    print("CSV 파일이다.")
else:
    print("CSV 파일이 아니다.")
```

</details>

### 3-5. f-string 오류

```python
population = 51740000
cases = 7629228
rate = cases / population
print(f"확진률: {rate}%")
```

> 실행은 되지만 출력이 `확진률: 0.14749131%`처럼 읽기 어렵다. 어떻게 고쳐야 하는가?

<details>
<summary>정답 확인</summary>

**문제:** 포맷 지정 없이 그대로 출력하면 소수점이 너무 길다. 또한 `rate`는 비율(0.147...)인데 `%`를 직접 붙였으므로 14.75%가 아니라 0.147%로 표시된다.

**방법 1:** 직접 100을 곱하고 소수점 지정
```python
print(f"확진률: {rate * 100:.2f}%")   # 14.75%
```

**방법 2:** f-string의 `%` 포맷 사용 (자동으로 100을 곱해준다)
```python
print(f"확진률: {rate:.2%}")          # 14.75%
```

</details>

---

## 도전 4: 자유 도전 — 코로나19 국가 비교 보고서

아래 데이터를 사용하여 **자신만의 보고서**를 출력하라.
어떤 형식이든 상관없다. 단, 최소 다음 요소를 포함해야 한다.

1. 변수에 데이터 저장
2. 최소 2가지 산술 연산 (증감, 비율, 비교 등)
3. f-string으로 보기 좋은 출력
4. **검증:** 본인이 계산한 결과가 맞는지 확인하는 코드 1줄 이상

```python
# ===== 사용할 데이터 =====
# 2022년 3월 17일 기준

# 한국
kr_new_cases = 621328
kr_total_cases = 7629228
kr_total_deaths = 12774
kr_population = 51740000

# 일본
jp_new_cases = 261029
jp_total_cases = 5765782
jp_total_deaths = 26109
jp_population = 125800000

# 미국
us_new_cases = 31647
us_total_cases = 79467042
us_total_deaths = 968916
us_population = 331900000
```

**힌트:** 계산할 수 있는 것들
- 치명률(CFR) = 총 사망 / 총 확진 * 100
- 인구 대비 확진률 = 총 확진 / 인구 * 100
- 10만 명당 일일 확진자 수 = 신규 확진 / 인구 * 100000
- 국가 간 비교: 한국은 미국의 몇 배? 등

---

## 도전 5: 문자열 종합 — 날짜 데이터 파싱

다음 문자열에서 필요한 정보를 추출하고 변환하라.

```python
raw_data = "2022/03/17, South Korea, 621328, 429, 7629228"
```

(1) 쉼표(`,`)로 `split`하여 각 항목을 변수에 저장하라.
(2) 날짜에서 `/`를 `-`로 `replace`하라.
(3) 국가명의 앞뒤 공백을 `strip`으로 제거하라.
(4) 확진자 수 문자열(`"621328"`)을 정수(`int`)로 변환하라.
(5) 변환한 데이터로 한 줄 요약을 출력하라:
    `"2022-03-17 | South Korea | 신규 621,328명 | 사망 429명"`

```python
# 도전 5 — 아래를 완성하라
raw_data = "2022/03/17, South Korea, 621328, 429, 7629228"

# 1) split
parts = raw_data.split(___)
print(parts)    # 확인용

# 2) 날짜 변환
date = parts[0].replace(___, ___)

# 3) 국가명 정리
country = parts[1].___()

# 4) 숫자 변환
new_cases = ___(parts[2].strip())
new_deaths = ___(parts[3].strip())

# 5) 출력
print(f"{date} | {country} | 신규 {new_cases:,}명 | 사망 {new_deaths:,}명")
```

<details>
<summary>정답 확인</summary>

```python
raw_data = "2022/03/17, South Korea, 621328, 429, 7629228"

parts = raw_data.split(",")
date = parts[0].replace("/", "-")
country = parts[1].strip()
new_cases = int(parts[2].strip())
new_deaths = int(parts[3].strip())

print(f"{date} | {country} | 신규 {new_cases:,}명 | 사망 {new_deaths:,}명")
# 출력: 2022-03-17 | South Korea | 신규 621,328명 | 사망 429명
```

</details>

---

# PART D. 심화 + 연습문제 (30분)

---

## 연습문제 10문항

### 문제 1. 변수 교환(Swap)

두 변수의 값을 **제3의 변수 없이** 교환하라.

```python
a = "한국"
b = "일본"
# 이 아래에 한 줄로 교환하라
_______________
print(f"a = {a}, b = {b}")  # a = 일본, b = 한국
```

<details>
<summary>정답</summary>

```python
a, b = b, a
```

파이썬은 동시 할당(Simultaneous Assignment)을 지원한다.

</details>

---

### 문제 2. 자료형 판별

다음 각 값의 `type()`을 예측하라. 실행하여 검증하라.

```python
values = [42, 42.0, "42", True, 0, 0.0, "", None]
for v in values:
    print(f"값: {str(v):>6}  →  타입: {type(v).__name__}")
```

<details>
<summary>정답</summary>

```
값:     42  →  타입: int
값:   42.0  →  타입: float
값:     42  →  타입: str
값:   True  →  타입: bool
값:      0  →  타입: int
값:    0.0  →  타입: float
값:         →  타입: str
값:   None  →  타입: NoneType
```

주목할 점:
- `42`(int)와 `42.0`(float)는 값은 같지만 타입이 다르다.
- `True`는 `bool` 타입이지만, 사실 `int`의 하위 클래스이다 (`True == 1`).
- 빈 문자열 `""`도 `str` 타입이다.

</details>

---

### 문제 3. 온도 변환기

섭씨(Celsius) 온도를 화씨(Fahrenheit)로 변환하는 코드를 작성하라.
변환 공식: `F = C * 9/5 + 32`

```python
celsius = 36.5    # 체온
fahrenheit = ___
print(f"{celsius}°C = {fahrenheit:.1f}°F")
# 검증: 36.5°C = 97.7°F 이어야 한다
```

<details>
<summary>정답</summary>

```python
celsius = 36.5
fahrenheit = celsius * 9/5 + 32
print(f"{celsius}°C = {fahrenheit:.1f}°F")   # 36.5°C = 97.7°F
```

</details>

---

### 문제 4. 문자열 뒤집기(Reverse)

`"DIVOC"` 문자열을 뒤집어서 `"COVID"`로 만들어라. 3가지 방법으로 해결하라.

<details>
<summary>정답</summary>

```python
s = "DIVOC"

# 방법 1: 슬라이싱
print(s[::-1])

# 방법 2: reversed() + join
print("".join(reversed(s)))

# 방법 3: 인덱싱으로 하나씩
result = s[4] + s[3] + s[2] + s[1] + s[0]
print(result)
```

</details>

---

### 문제 5. 할당 연산 추적

아래 코드의 최종 결과를 **손으로 계산**한 뒤, 실행하여 검증하라.

```python
x = 100
x += 50     # x = ___
x *= 2      # x = ___
x -= 100    # x = ___
x //= 7     # x = ___
x %= 5      # x = ___
x **= 3     # x = ___
print(x)    # 최종 답: ___
```

<details>
<summary>정답</summary>

```
x = 100
x += 50     # x = 150
x *= 2      # x = 300
x -= 100    # x = 200
x //= 7     # x = 28  (200 // 7 = 28)
x %= 5      # x = 3   (28 % 5 = 3)
x **= 3     # x = 27  (3 ** 3 = 27)
```

최종 답: **27**

</details>

---

### 문제 6. 천 단위 문자열을 숫자로 변환

```python
# 뉴스 기사에서 복사한 확진자 수 (쉼표가 포함된 문자열)
cases_str = "7,629,228"

# 이 문자열을 정수(int)로 변환하라
cases_int = ___
print(f"정수 변환 결과: {cases_int}")
print(f"타입: {type(cases_int)}")
```

<details>
<summary>정답</summary>

```python
cases_str = "7,629,228"
cases_int = int(cases_str.replace(",", ""))
print(f"정수 변환 결과: {cases_int}")    # 7629228
print(f"타입: {type(cases_int)}")        # <class 'int'>
```

핵심: `int("7,629,228")`은 **에러가 발생**한다. 쉼표를 먼저 제거(`replace`)해야 한다.

</details>

---

### 문제 7. 문자열 반복과 포맷팅 조합

다음과 같은 출력을 만들어라. (`print`를 3줄만 사용하라.)

```
****************************
*   COVID-19 Daily Report  *
****************************
```

<details>
<summary>정답</summary>

```python
print("*" * 28)
print(f"*{'COVID-19 Daily Report':^26}*")
print("*" * 28)
```

`^26`은 26칸 안에서 가운데 정렬(Center Align)을 의미한다.

</details>

---

### 문제 8. 다중 변수 할당과 활용

한 줄에 여러 변수를 할당하는 방식을 사용하여, 코로나 주간 확진자 데이터를 저장하고 통계를 구하라.

```python
# 한 줄 할당 (월~일)
mon, tue, wed, thu, fri, sat, sun = 490421, 389423, 327790, 621328, 580123, 392316, 275941

# 주간 합계
weekly_total = ___

# 일 평균 (소수점 이하 반올림은 하지 않아도 됨)
daily_avg = ___

# 최고/최저 (내장 함수 max, min 사용 가능)
max_day = ___
min_day = ___

print(f"주간 합계: {weekly_total:,}명")
print(f"일 평균: {daily_avg:,.0f}명")
print(f"최고: {max_day:,}명")
print(f"최소: {min_day:,}명")
```

<details>
<summary>정답</summary>

```python
mon, tue, wed, thu, fri, sat, sun = 490421, 389423, 327790, 621328, 580123, 392316, 275941

weekly_total = mon + tue + wed + thu + fri + sat + sun
daily_avg = weekly_total / 7
max_day = max(mon, tue, wed, thu, fri, sat, sun)
min_day = min(mon, tue, wed, thu, fri, sat, sun)

print(f"주간 합계: {weekly_total:,}명")    # 3,077,342명
print(f"일 평균: {daily_avg:,.0f}명")      # 439,620명
print(f"최고: {max_day:,}명")              # 621,328명
print(f"최소: {min_day:,}명")              # 275,941명
```

</details>

---

### 문제 9. 문자열 분석

주어진 문자열에서 다음 정보를 추출하라.

```python
headline = "Breaking: South Korea reports 621,328 new COVID-19 cases on 2022-03-17"

# 1) 전체 글자 수 (공백 포함)
length = ___

# 2) "COVID" 문자열이 몇 번째 위치에서 시작하는지
covid_pos = headline.___(_____)

# 3) 대문자로 변환한 결과
upper_headline = headline.___()

# 4) "South Korea"를 "Republic of Korea"로 변경
new_headline = headline.___(_____, _____)

# 5) 단어 개수 (공백으로 split)
word_count = len(headline.___())

print(f"글자 수: {length}")
print(f"COVID 위치: {covid_pos}")
print(f"대문자: {upper_headline}")
print(f"변경: {new_headline}")
print(f"단어 수: {word_count}")
```

<details>
<summary>정답</summary>

```python
headline = "Breaking: South Korea reports 621,328 new COVID-19 cases on 2022-03-17"

length = len(headline)                              # 70
covid_pos = headline.find("COVID")                  # 41
upper_headline = headline.upper()
new_headline = headline.replace("South Korea", "Republic of Korea")
word_count = len(headline.split())                  # 10

print(f"글자 수: {length}")
print(f"COVID 위치: {covid_pos}")
print(f"대문자: {upper_headline}")
print(f"변경: {new_headline}")
print(f"단어 수: {word_count}")
```

</details>

---

### 문제 10. 종합 — 나만의 프롬프트 작성

> 이 문제는 AI 윤리 원칙을 직접 실습하는 문제이다.

**과제:** AI에게 "코로나19 한국·일본·미국 3개국의 치명률(CFR)을 계산하고, 막대그래프처럼 `#` 문자로 시각화하는 코드"를 요청하려고 한다.

(1) **Level 0 프롬프트(나쁜 예)**를 작성하라.
(2) **Level 2 프롬프트(좋은 예)**를 작성하라.
(3) Level 2 프롬프트로 AI에게 코드를 받았다고 가정하고, **검증 코드**를 직접 작성하라.
    - 미국 치명률이 약 1.22%인지 확인하는 `print`문

<details>
<summary>정답 예시</summary>

**(1) Level 0 (나쁜 예):**
```
코로나 치명률 계산하고 그래프 그려줘
```

**(2) Level 2 (좋은 예):**
```
아래 3개국의 2022-03-17 기준 코로나19 데이터이다.
- 한국: 총 확진 7,629,228명, 총 사망 12,774명
- 일본: 총 확진 5,765,782명, 총 사망 26,109명
- 미국: 총 확진 79,467,042명, 총 사망 968,916명

각 국가의 치명률(CFR = 총 사망 / 총 확진 * 100)을 계산하고,
치명률을 '#' 문자로 막대그래프처럼 시각화하는 코드를 작성해줘.
'#' 1개 = 0.1%로 설정해줘.
변수명은 kr_cfr, jp_cfr, us_cfr로 해줘.
```

**(3) 검증 코드:**
```python
# 미국 치명률 수동 검증
us_cfr_manual = 968916 / 79467042 * 100
print(f"미국 CFR 수동 계산: {us_cfr_manual:.2f}%")
# 1.22% 근처이면 정상

# 3개국 CFR 합산 검증 (순서: 한국 < 일본 < 미국이어야 논리적)
print(f"한국 < 일본 < 미국? {kr_cfr < jp_cfr < us_cfr}")
```

</details>

---

# 부록(Appendix): f-string 포맷 치트시트(Cheat Sheet)

| 포맷(Format) | 설명(Description) | 입력(Input) | 출력(Output) |
|---|---|---|---|
| `{x:,}` | 천 단위 쉼표 | `1234567` | `1,234,567` |
| `{x:.2f}` | 소수점 2자리 | `3.14159` | `3.14` |
| `{x:.1%}` | 퍼센트 (소수점 1자리) | `0.0712` | `7.1%` |
| `{x:.2e}` | 과학적 표기법 | `1234567` | `1.23e+06` |
| `{x:>10}` | 오른쪽 정렬 10칸 | `"Hi"` | `"        Hi"` |
| `{x:<10}` | 왼쪽 정렬 10칸 | `"Hi"` | `"Hi        "` |
| `{x:^10}` | 가운데 정렬 10칸 | `"Hi"` | `"    Hi    "` |
| `{x:>10,}` | 오른쪽 정렬 + 쉼표 | `1234` | `"     1,234"` |
| `{x:0>5}` | 0으로 채우기 5칸 | `42` | `"00042"` |

---

*본 자료의 모든 코드는 Google Colab에서 실행 가능하다.*

*1주차 수업 후, 연습문제 10문항의 코드 + 출력 + 검증을 제출하라.*
