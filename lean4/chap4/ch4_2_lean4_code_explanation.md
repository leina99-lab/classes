# 4.2 Lean 4 코드 설명 자료

> 본 자료는 짝꿍 문서 **`ch4_2_lean4_student.md`**(학생 자료)에서 등장한 모든 Lean 4 코드를, 한 줄씩 누를 때마다 화면 오른쪽 **InfoView**가 어떻게 변하는지 정밀하게 기록한 해설서이다.

---

## 표기 약속

- `⊢` 목표.
- `-- BEFORE:` / `-- AFTER:` 실행 전후.
- `-- WHY:` 그 줄의 이유.
- `-- USES:` 사용한 정리·정의.

---

## 코드 1. `Nat.digits 10 1234 = [4, 3, 2, 1]`

**완성 코드**

```lean
example : Nat.digits 10 1234 = [4, 3, 2, 1] := by decide
```

- WHY: 작은 수의 자릿수 분해. `Nat.digits 10 1234`의 정의를 풀어 가면 `[4, 3, 2, 1]`로 환원된다.
- USES: `decide`. 정의의 직접 계산으로 판정.

**`Nat.digits`의 정의** Mathlib에는 다음 골격으로 정의되어 있다.

```
Nat.digits b n :=
  if n = 0 then []
  else (n % b) :: Nat.digits b (n / b)
```

(실제 정의는 종료성 보장을 위해 조금 더 복잡하지만 본질은 위와 같다.)

따라서 1234의 분해는 다음과 같이 진행된다.

```
Nat.digits 10 1234
  = (1234 % 10) :: Nat.digits 10 (1234 / 10)
  = 4 :: Nat.digits 10 123
  = 4 :: 3 :: Nat.digits 10 12
  = 4 :: 3 :: 2 :: Nat.digits 10 1
  = 4 :: 3 :: 2 :: 1 :: Nat.digits 10 0
  = 4 :: 3 :: 2 :: 1 :: []
  = [4, 3, 2, 1]
```

`decide`가 이 사슬을 자동으로 따라간다.

---

## 코드 2~5. 다른 진법 시연들

```lean
example : Nat.digits 2 13     = [1, 0, 1, 1]    := by decide
example : Nat.digits 16 255   = [15, 15]        := by decide
example : Nat.digits 8 64     = [0, 0, 1]       := by decide
```

`Nat.digits 2 13`의 펼치기:

```
13 % 2 = 1, 13 / 2 = 6   →  1 :: ...
 6 % 2 = 0,  6 / 2 = 3   →  1 :: 0 :: ...
 3 % 2 = 1,  3 / 2 = 1   →  1 :: 0 :: 1 :: ...
 1 % 2 = 1,  1 / 2 = 0   →  1 :: 0 :: 1 :: 1 :: ...
 0이 되면 []             →  [1, 0, 1, 1]
```

---

## 코드 6. `digits_round_trip` - 분해 후 복원

**완성 코드**

```lean
theorem digits_round_trip (n : Nat) :
    Nat.ofDigits 10 (Nat.digits 10 n) = n :=
  Nat.ofDigits_digits 10 n
```

```
-- BEFORE the proof body:
--   n : Nat
--   ⊢ Nat.ofDigits 10 (Nat.digits 10 n) = n
```

- WHY: Mathlib에 정확히 이 형태의 정리 `Nat.ofDigits_digits`가 있다.
- USES: `Nat.ofDigits_digits : ∀ (b n : Nat), Nat.ofDigits b (Nat.digits b n) = n`.

본 정리는 인수 두 개(`10`, `n`)만 넘기면 끝난다. 표현 모드(`:= 답`)로 한 줄.

```
-- AFTER:
--   (No goals)
```

---

## 코드 7. `Nat.ofDigits` 시연

```lean
example : Nat.ofDigits 10 [4, 3, 2, 1] = 1234 := by decide
```

**`Nat.ofDigits`의 정의**

```
Nat.ofDigits b [] := 0
Nat.ofDigits b (d :: ds) := d + b * Nat.ofDigits b ds
```

펼치기:

```
Nat.ofDigits 10 [4, 3, 2, 1]
  = 4 + 10 * Nat.ofDigits 10 [3, 2, 1]
  = 4 + 10 * (3 + 10 * Nat.ofDigits 10 [2, 1])
  = 4 + 10 * (3 + 10 * (2 + 10 * Nat.ofDigits 10 [1]))
  = 4 + 10 * (3 + 10 * (2 + 10 * (1 + 10 * 0)))
  = 4 + 10 * (3 + 10 * (2 + 10 * 1))
  = 4 + 10 * (3 + 10 * 12)
  = 4 + 10 * 123
  = 1234.
```

---

## 코드 8. 자릿수의 개수

```lean
example : (Nat.digits 10 1234).length = 4 := by decide
```

`.length`는 리스트 길이를 돌려주는 메서드. `Nat.digits 10 1234 = [4, 3, 2, 1]`이고 원소가 4개이므로 길이가 4. `decide`가 모두 자동 계산.

---

## 코드 9. 16진수 합성 시연

```lean
example : Nat.ofDigits 16 [10, 11, 12] = 10 + 11 * 16 + 12 * 256 := by
  decide
```

좌변 펼치기:

```
Nat.ofDigits 16 [10, 11, 12]
  = 10 + 16 * Nat.ofDigits 16 [11, 12]
  = 10 + 16 * (11 + 16 * Nat.ofDigits 16 [12])
  = 10 + 16 * (11 + 16 * (12 + 16 * 0))
  = 10 + 16 * (11 + 16 * 12)
  = 10 + 16 * (11 + 192)
  = 10 + 16 * 203
  = 10 + 3248
  = 3258.
```

우변: `10 + 11 * 16 + 12 * 256 = 10 + 176 + 3072 = 3258`. 두 값이 일치하므로 등식 성립. `decide`가 양변 계산 후 비교.

---

## 코드 10. `Int.ModEq`로 합동 시연

(§4.1 자료에서도 도입했음. 본 자료에서는 모듈러 멱승의 연결을 위해 다시 언급.)

작은 수 합동 판정은 `decide`로 충분.

---

## 코드 11. 모듈러 멱승 시연

```lean
example : 3 ^ 13 % 7 = 3 := by decide
example : 2 ^ 10 % 11 = 1 := by decide
example : 7 ^ 222 % 11 = 5 := by decide
```

- `3 ^ 13`은 Lean 4가 정의를 펼쳐 1594323을 얻고, `% 7`로 나머지 3을 계산.
- 큰 지수도 `decide`가 작동하지만, 매우 클 경우 시간 폭주 위험. `native_decide`가 안전.

`decide`와 `native_decide`의 차이:
- `decide`: Lean 4 커널이 정의를 한 단계씩 환원해 계산. 정합성 보장 강함. 큰 수에서 느릴 수 있음.
- `native_decide`: 컴파일된 네이티브 코드로 평가. 빠름. 컴파일러 신뢰가 추가됨.

---

## 코드 12. `fastModPow` 함수 정의

**완성 코드 전체**

```lean
def fastModPow : Nat → Nat → Nat → Nat
  | _,    0,        _ => 1
  | base, exp + 1,  m =>
      if (exp + 1) % 2 = 0 then
        let half := fastModPow base ((exp + 1) / 2) m
        (half * half) % m
      else
        (base * fastModPow base exp m) % m
termination_by _ exp _ => exp
```

**한 줄씩 분석**

```lean
def fastModPow : Nat → Nat → Nat → Nat
```

함수 선언. 세 자연수 인수를 받아 자연수를 돌려준다. `→`는 우결합이므로 `Nat → (Nat → (Nat → Nat))`로 읽힌다(커링).

---

```lean
  | _,    0,        _ => 1
```

**첫 패턴 매칭 가지**. 둘째 인수가 정확히 `0`인 경우, 어떤 `base`와 어떤 `m`이든 결과는 `1`. 종이의 `a^0 = 1`을 옮긴 것이다. 첫째와 셋째 인수가 `_`이라는 것은 "이 자리 값은 신경 쓰지 않는다"는 표시.

---

```lean
  | base, exp + 1,  m =>
```

**둘째 패턴 매칭 가지**. 둘째 인수가 `exp + 1` 형태인 경우. 즉 둘째 인수가 양수인 경우.

여기서 `exp + 1`이라는 패턴이 핵심이다. 이는 "Lean 4야, 둘째 인수가 어떤 자연수 `exp`에 1을 더한 형태임을 받아들이고, 그 `exp`라는 새 변수를 다음 줄들에서 사용할 수 있게 해 줘"라는 선언이다. 이 패턴 덕에 다음 두 가지 이점이 따라온다.

- 첫 가지에서 `0`이 잡혔으므로, 둘째 가지에 도달했다는 것은 둘째 인수가 0이 아니라는 의미. 이를 타입 수준에서 명시.
- 재귀 호출에서 둘째 인수가 항상 `exp + 1`보다 작은 값(예: `(exp + 1) / 2`나 `exp`)이 되어, **종료성 자동 검증**이 가능해진다.

---

```lean
      if (exp + 1) % 2 = 0 then
        let half := fastModPow base ((exp + 1) / 2) m
        (half * half) % m
```

**짝수 가지**. 지수가 짝수면 반복 제곱.

`a^(2k) = (a^k)^2`. 모듈러 환경에서는 `a^(2k) mod m = ((a^k mod m)^2) mod m`.

`let half := ...` 구문은 임시 변수에 값을 묶는다. 같은 값을 두 번 계산하지 않도록 캐시하는 것이다(`half * half`에서 두 번 쓰임).

---

```lean
      else
        (base * fastModPow base exp m) % m
```

**홀수 가지**. 지수가 홀수면 `a · a^(exp)`. 즉 한 번 base를 곱하고 지수를 1 줄인다.

여기서 둘째 인수가 `exp` (즉 `(exp + 1) - 1`)인 점에 주목한다. 이전 인수 `exp + 1`보다 작다. 종료성이 보장된다.

---

```lean
termination_by _ exp _ => exp
```

**종료성 명시**. `fastModPow base (exp + 1) m`이라는 호출에서 어느 인수가 "측도"(measure)인지를 알려 준다. `_ exp _ => exp`는 "세 인수 중 둘째 인수 `exp`(여기서는 `exp + 1`이지만 변수 이름은 같게 쓸 수 있음)가 매 재귀 호출마다 줄어든다는 것을 검증하라"는 명령.

Lean 4는 이 정보를 받아 두 재귀 호출 모두에서 측도가 줄어듦을 자동 확인한다.

- 짝수 가지: `(exp + 1) / 2 < exp + 1` (참, 자연수 정수 나눗셈)
- 홀수 가지: `exp < exp + 1` (자명히 참)

따라서 별도의 `decreasing_by` 블록이 필요하지 않다. (이전 버전에서는 `decreasing_by ... omega`를 명시했지만, `exp + 1` 패턴 덕에 자동 처리됨.)

---

## 코드 13. `fastModPow` 시연

```lean
example : fastModPow 3 13 7 = 3 := by native_decide
example : fastModPow 2 10 11 = 1 := by native_decide
example : fastModPow 7 222 11 = 5 := by native_decide
```

- WHY: 사용자 정의 재귀 함수의 값을 검증할 때, `decide`는 환원 과정에서 막힐 수 있다. `native_decide`가 안전.
- USES: `native_decide`. 컴파일된 네이티브 코드로 평가.

세 등식 모두 직접 계산으로 검증된다. 종이로 추적하면 다음과 같다.

`fastModPow 3 13 7`:
```
13 = 12 + 1 (홀수)  →  3 * fastModPow 3 12 7 % 7
12 = 6 + 6 (짝수)   →  let half = fastModPow 3 6 7; half * half % 7
 6 = 3 + 3 (짝수)   →  let half = fastModPow 3 3 7; half * half % 7
 3 = 2 + 1 (홀수)   →  3 * fastModPow 3 2 7 % 7
 2 = 1 + 1 (짝수)   →  let half = fastModPow 3 1 7; half * half % 7
 1 = 0 + 1 (홀수)   →  3 * fastModPow 3 0 7 % 7 = 3 * 1 % 7 = 3
역추적: 1단계: 3. 2단계: 3*3%7 = 2. 3단계: 3*2%7 = 6. 4단계: 6*6%7 = 1.
       5단계: 1*1%7 = 1. 6단계: 3*1%7 = 3.
결과: 3. (일치)
```

(이 추적은 사람을 위한 것이고, `native_decide`가 자동으로 같은 일을 한다.)

---

## 마무리

본 코드 설명 자료에서 다룬 13개 코드를 직접 입력하고 InfoView가 일치하는지 확인한다.

§4.3의 소수와 최대공약수 자료에서 다시 만난다.
