# 수업용 데이터셋 확보 가이드(Dataset Acquisition Guide)

# Google Colab에서 바로 실행 가능한 코드 포함

---

## 사용법(How to Use)

아래 각 주차별 코드 블록을 Google Colab 셀에 복사·붙여넣기하여 실행하면,
해당 데이터셋이 Colab 환경에 자동으로 다운로드된다.

---

## 1~3주차: 코로나19(COVID-19) 확진자 데이터

### 출처(Source)

| 항목 | 내용 |
|---|---|
| 제공 기관 | Our World in Data (OWID) |
| GitHub | https://github.com/owid/covid-19-data |
| 라이선스(License) | Creative Commons BY 4.0 (자유 사용, 출처 표기) |
| 파일 형식 | CSV (1행 = 1국가 × 1날짜) |
| 주요 열(Columns) | `date`, `location`, `new_cases`, `total_cases`, `new_deaths`, `total_deaths`, `population` 등 |

### Colab 실행 코드

```python
# ===== 1~3주차: 코로나19 데이터 다운로드 =====
import pandas as pd

# 방법 1: OWID GitHub에서 직접 다운로드 (권장)
url = "https://catalog.ourworldindata.org/garden/covid/latest/compact/compact.csv"
df_covid = pd.read_csv(url)

print(f"전체 데이터 크기: {df_covid.shape}")
print(f"열 목록: {list(df_covid.columns)}")
print(f"국가 수: {df_covid['country'].nunique()}")
print(f"기간: {df_covid['date'].min()} ~ {df_covid['date'].max()}")
df_covid.head()
```

```python
# 한국 데이터만 추출하여 별도 저장
df_kr = df_covid[df_covid['country'] == 'South Korea'].copy()
df_kr.to_csv('covid_korea.csv', index=False)
print(f"한국 데이터: {len(df_kr)}행")
df_kr.head()
```

```python
# 한국 + 일본 + 미국 3개국 비교용
countries = ['South Korea', 'Japan', 'United States']
df_3 = df_covid[df_covid['country'].isin(countries)].copy()
df_3.to_csv('covid_3countries.csv', index=False)
print(f"3개국 데이터: {len(df_3)}행")
df_3.groupby('country').size()
```

### 만약 URL 접속이 안 될 경우 (백업)

```python
# 백업: GitHub raw 파일 직접 다운로드
url_backup = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
df_covid = pd.read_csv(url_backup)
```

### 1주차 파이썬 기초용 — 판다스(Pandas) 없이 사용하는 간이 데이터

1주차에는 아직 `pandas`를 배우지 않았으므로, **리스트**(list)**와 딕셔너리**(dict)**로 직접 데이터를 입력**하는 방식을 사용한다. 아래 코드를 그대로 복사하여 사용하면 된다.

```python
# ===== 1주차용: 판다스 없이 사용하는 코로나 데이터 =====
# 2022년 3월 14일 ~ 3월 20일 한국 일별 신규 확진자 수 (실제 데이터)

dates = [
    "2022-03-14", "2022-03-15", "2022-03-16",
    "2022-03-17", "2022-03-18", "2022-03-19", "2022-03-20"
]

daily_cases = [490421, 389423, 327790, 621328, 580123, 392316, 275941]

# 국가별 2022-03-17 기준 데이터 (딕셔너리)
covid_by_country = {
    "한국":  {"new_cases": 621328, "total_cases": 7629228,
              "total_deaths": 12774, "population": 51740000},
    "일본":  {"new_cases": 261029, "total_cases": 5765782,
              "total_deaths": 26109, "population": 125800000},
    "미국":  {"new_cases": 31647,  "total_cases": 79467042,
              "total_deaths": 968916, "population": 331900000},
}

# 검증 출력
print(f"날짜 수: {len(dates)}")
print(f"확진자 수: {len(daily_cases)}")
print(f"3/17 확진자: {daily_cases[3]:,}명")
print(f"국가 수: {len(covid_by_country)}")
```

---

## 4~5주차: 뉴욕 에어비앤비(Airbnb NYC 2019)

### 출처(Source)

| 항목 | 내용 |
|---|---|
| 제공 기관 | Inside Airbnb / Kaggle |
| Kaggle 페이지 | https://www.kaggle.com/datasets/dgomonov/new-york-city-airbnb-open-data |
| 라이선스 | CC0: Public Domain |
| 파일명 | `AB_NYC_2019.csv` |
| 행 수 | 약 48,895행 |
| 주요 열 | `name`, `neighbourhood_group`, `neighbourhood`, `latitude`, `longitude`, `room_type`, `price`, `minimum_nights`, `number_of_reviews` 등 |

### Colab 실행 코드

```python
# ===== 4~5주차: 에어비앤비 NYC 데이터 다운로드 =====
# 방법 1: Kaggle API 사용 (Kaggle 계정 필요)
# Colab에서 Kaggle API 키 업로드 후 실행

# !pip install kaggle
# from google.colab import files
# files.upload()  # kaggle.json 업로드
# !mkdir -p ~/.kaggle && mv kaggle.json ~/.kaggle/ && chmod 600 ~/.kaggle/kaggle.json
# !kaggle datasets download -d dgomonov/new-york-city-airbnb-open-data
# !unzip new-york-city-airbnb-open-data.zip
```

```python
# 방법 2: 교수자가 Google Drive에 미리 업로드한 경우
from google.colab import drive
drive.mount('/content/drive')

import pandas as pd
# 경로는 실제 Drive 폴더에 맞게 수정
df_airbnb = pd.read_csv('/content/drive/MyDrive/datasets/AB_NYC_2019.csv')
print(f"데이터 크기: {df_airbnb.shape}")
df_airbnb.head()
```

### 교수자 사전 준비(Instructor Preparation)

Kaggle에서 데이터를 다운로드하여 **수업 전용 Google Drive 공유 폴더**에 업로드해 두면,
학생들이 Kaggle 계정 없이도 바로 사용할 수 있다.

1. https://www.kaggle.com/datasets/dgomonov/new-york-city-airbnb-open-data 접속
2. "Download" 버튼 클릭 → `AB_NYC_2019.csv` 다운로드
3. Google Drive 수업 폴더에 업로드
4. 학생에게 공유 링크 제공

---

## 6주차: 심부전증(Heart Failure) 예측

### 출처(Source)

| 항목 | 내용 |
|---|---|
| 제공 기관 | Kaggle |
| Kaggle 페이지 | https://www.kaggle.com/datasets/fedesoriano/heart-failure-prediction |
| 라이선스 | Open Database License (ODbL) |
| 파일명 | `heart.csv` |
| 행 수 | 918행 |
| 주요 열 | `Age`, `Sex`, `ChestPainType`, `RestingBP`, `Cholesterol`, `FastingBS`, `RestingECG`, `MaxHR`, `ExerciseAngina`, `Oldpeak`, `ST_Slope`, `HeartDisease` |

### Colab 실행 코드

```python
# ===== 6주차: 심부전증 데이터 =====
# Kaggle에서 다운로드하여 Drive에 업로드해 둔 경우:
import pandas as pd
df_heart = pd.read_csv('/content/drive/MyDrive/datasets/heart.csv')
print(f"데이터 크기: {df_heart.shape}")
print(f"타겟 분포:\n{df_heart['HeartDisease'].value_counts()}")
df_heart.head()
```

---

## 7주차: LoL(League of Legends) 랭크 게임 데이터

### 출처(Source)

| 항목 | 내용 |
|---|---|
| 제공 기관 | Kaggle |
| Kaggle 페이지 | https://www.kaggle.com/datasets/datasnaek/league-of-legends |
| 라이선스 | CC BY-SA 4.0 |
| 파일명 | `games.csv` |
| 행 수 | 약 51,490행 |
| 주요 열 | `winner`, `firstBlood`, `firstTower`, `firstDragon`, `firstBaron`, `firstRiftHerald` 등 |

### Colab 실행 코드

```python
# ===== 7주차: LoL 데이터 =====
import pandas as pd
df_lol = pd.read_csv('/content/drive/MyDrive/datasets/games.csv')
print(f"데이터 크기: {df_lol.shape}")
print(f"블루팀 승률: {(df_lol['winner']==1).mean():.1%}")
df_lol.head()
```

---

## 9주차: 중고 자동차(Used Car) 가격 예측

### 출처(Source)

| 항목 | 내용 |
|---|---|
| 제공 기관 | Kaggle |
| Kaggle 페이지 | https://www.kaggle.com/datasets/austinreese/craigslist-carstrucks-data |
| 대안(Alternative) | https://www.kaggle.com/datasets/nehalbirla/vehicle-dataset-from-cardekho |
| 라이선스 | CC0 / ODbL |
| 파일명 | `vehicles.csv` 또는 `car data.csv` |
| 주요 열 | `year`, `manufacturer`, `model`, `condition`, `odometer`, `price`, `fuel`, `transmission` 등 |

### Colab 실행 코드

```python
# ===== 9주차: 중고 자동차 데이터 =====
import pandas as pd
df_cars = pd.read_csv('/content/drive/MyDrive/datasets/vehicles.csv')
print(f"데이터 크기: {df_cars.shape}")
print(f"가격 범위: ${df_cars['price'].min():,} ~ ${df_cars['price'].max():,}")
df_cars.head()
```

---

## 10주차: 고객 세그먼테이션(Mall Customer Segmentation)

### 출처(Source)

| 항목 | 내용 |
|---|---|
| 제공 기관 | Kaggle |
| Kaggle 페이지 | https://www.kaggle.com/datasets/vjchoudhary7/customer-segmentation-tutorial-in-python |
| 라이선스 | CC0: Public Domain |
| 파일명 | `Mall_Customers.csv` |
| 행 수 | 200행 |
| 주요 열 | `CustomerID`, `Gender`, `Age`, `Annual Income (k$)`, `Spending Score (1-100)` |

### Colab 실행 코드

```python
# ===== 10주차: 고객 세그먼테이션 데이터 =====
import pandas as pd
df_mall = pd.read_csv('/content/drive/MyDrive/datasets/Mall_Customers.csv')
print(f"데이터 크기: {df_mall.shape}")
print(f"열 목록: {list(df_mall.columns)}")
df_mall.describe()
```

---

## 11~12주차: MNIST, CIFAR-10 (PyTorch 내장)

이 데이터셋들은 별도 다운로드가 필요 없다. PyTorch의 `torchvision`에 내장되어 있다.

### Colab 실행 코드

```python
# ===== 11주차: MNIST =====
import torch
import torchvision
import torchvision.transforms as transforms

transform = transforms.ToTensor()

train_mnist = torchvision.datasets.MNIST(
    root='./data', train=True, download=True, transform=transform
)
test_mnist = torchvision.datasets.MNIST(
    root='./data', train=False, download=True, transform=transform
)
print(f"MNIST 학습 데이터: {len(train_mnist)}장")
print(f"MNIST 테스트 데이터: {len(test_mnist)}장")
print(f"이미지 크기: {train_mnist[0][0].shape}")  # (1, 28, 28)
```

```python
# ===== 12주차: CIFAR-10 =====
train_cifar = torchvision.datasets.CIFAR10(
    root='./data', train=True, download=True, transform=transform
)
test_cifar = torchvision.datasets.CIFAR10(
    root='./data', train=False, download=True, transform=transform
)
print(f"CIFAR-10 학습 데이터: {len(train_cifar)}장")
print(f"클래스: {train_cifar.classes}")
print(f"이미지 크기: {train_cifar[0][0].shape}")  # (3, 32, 32)
```

---

## 13주차: IMDB 영화 리뷰 감성 분석

### 방법 1: HuggingFace `datasets` 사용 (권장)

```python
# ===== 13주차: IMDB 감성 분석 =====
!pip install datasets -q
from datasets import load_dataset

dataset = load_dataset("imdb")
print(f"학습 데이터: {len(dataset['train'])}개")
print(f"테스트 데이터: {len(dataset['test'])}개")
print(f"라벨: 0=부정(Negative), 1=긍정(Positive)")
print(f"\n예시:\n{dataset['train'][0]['text'][:200]}...")
print(f"라벨: {dataset['train'][0]['label']}")
```

### 방법 2: PyTorch 내장

```python
from torchtext.datasets import IMDB
train_iter, test_iter = IMDB(split=('train', 'test'))
```

---

## 14주차: GAN용 MNIST (11주차와 동일) + LLM API

MNIST는 11주차에서 이미 다운로드한 것을 재사용한다.
LLM API는 별도의 데이터셋이 아니라 API 키가 필요하다.

```python
# OpenAI API 사용 시
# !pip install openai
# import openai
# openai.api_key = "sk-..."  # 교수자가 수업용 키를 제공하거나, 학생 개인 키 사용

# Anthropic Claude API 사용 시
# !pip install anthropic
# import anthropic
# client = anthropic.Anthropic(api_key="sk-...")
```

---

## 교수자용 사전 준비 체크리스트(Instructor Checklist)

### 학기 시작 전 1회 수행

- [ ] Kaggle 계정 생성 (https://www.kaggle.com)
- [ ] 아래 5개 데이터셋 다운로드:
  - [ ] `AB_NYC_2019.csv` (에어비앤비)
  - [ ] `heart.csv` (심부전증)
  - [ ] `games.csv` (LoL)
  - [ ] `vehicles.csv` 또는 `car data.csv` (중고차)
  - [ ] `Mall_Customers.csv` (고객 세그먼테이션)
- [ ] Google Drive에 `수업자료/datasets/` 폴더 생성
- [ ] 5개 CSV 파일을 해당 폴더에 업로드
- [ ] 학생들에게 폴더 공유 (보기 권한)

### 수업별 확인 사항

- [ ] Colab에서 데이터 불러오기 코드가 정상 작동하는지 사전 테스트
- [ ] OWID 코로나 데이터 URL이 아직 유효한지 확인 (학기 초 1회)
- [ ] PyTorch / HuggingFace 라이브러리 버전 호환성 확인

---

## Google Drive 연동 기본 코드(Drive Mount Template)

매 주차 실습 시작 시 아래 코드를 먼저 실행한다.

```python
# ===== 수업 시작 시 항상 실행 =====
from google.colab import drive
drive.mount('/content/drive')

# 데이터 경로 설정 (교수자가 안내한 경로로 수정)
DATA_DIR = '/content/drive/MyDrive/수업자료/datasets/'

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 한글 폰트 설정 (그래프에 한글 표시)
!apt-get install -y fonts-nanum > /dev/null 2>&1
plt.rcParams['font.family'] = 'NanumGothic'
plt.rcParams['axes.unicode_minus'] = False

print("환경 설정 완료")
```

---

*본 가이드는 2026학년도 기준으로 작성되었다. URL이 변경되거나 데이터가 삭제될 수 있으므로, 학기 시작 전에 반드시 확인해야 한다.*
