# 4.3 Lean 4 교수자 자료 - 소수와 최대공약수

> 본 자료는 강의실에서 교수자가 한 손에 들고 사용할 수 있는 **교수자 통합본**이다. 학생용 두 자료를 한 문서로 합치고, 교수자만의 추가 요소를 곳곳에 삽입했다.
>
> 추가 요소: **[Q]** 학생 질문, **[JOKE]** 농담, **[ANALOGY]** 비유, **[DEMO]** 시범 시점, **[STUDENT TRY]** 학생 활동, **[WATCH]** 오개념 주의, **[AI]** AI 응용 연결.

---

## 강의 전체 개요와 시간 배분

본 강의는 **3시간 분량**이다. 다음과 같이 배분한다.

| 시간 | 단원 | 핵심 |
|---|---|---|
| 0~25분 | §1 도입 + §2 최소 소인수 `Nat.minFac` | 합성수 정리의 디딤돌 |
| 25~70분 | §3 합성수의 작은 소인수 정리 | 본 자료에서 첫 큰 정리 |
| 70~90분 | (휴식 10분) + §4 유클리드의 소수 무한성 (도입) | 람다 귀류법 |
| 90~135분 | §4 유클리드 정리 (완성) | 본 자료의 클라이맥스 |
| 135~150분 | (휴식 10분) + §5 `Nat.gcd` + §6 양수성 | 유클리드 호제법 |
| 150~165분 | §7 `Nat.lcm` + §8 핵심 등식 | 마무리 정리 |
| 165~180분 | §9 패턴 정리 + 질의응답 | 정착 |

---

## 강의 시작 - 개강 멘트

> **교수자 멘트 시작.**

여러분 안녕하세요. 오늘은 §4.3 소수와 최대공약수입니다. 정수론의 가장 고전적이고 또 가장 강력한 주제예요.

[Q] 시작 전에 한 가지 묻겠습니다. 소수가 왜 중요한지 한 문장으로 답해 보세요. (5초)

다양한 답이 가능합니다. "더 이상 쪼갤 수 없는 수다", "정수의 원자다", "암호학의 토대다" — 모두 정답입니다.

[JOKE] 사실 저는 학부 1학년 때 "소수가 그렇게 중요해? 그냥 신기한 수일 뿐 아닌가?"라고 생각했어요. 그런데 4학년 때 RSA 암호를 배우고 나서, 인터넷 뱅킹이 모두 큰 소수에 의존한다는 걸 알게 됐죠. 그때부터 소수가 다르게 보였습니다.

[AI] 흥미로운 점: 최근 AI 연구에서 소수 분해 문제가 주목받고 있어요. 양자 컴퓨터의 발전으로 큰 소수 분해가 빨라지면, 현재 인터넷 보안의 토대가 흔들립니다. 그래서 "양자 후 암호학"(post-quantum cryptography)이라는 새 분야가 떠오르고 있죠. 우리가 오늘 배우는 게 그 분야의 출발선입니다.

자, 본격적으로 시작합니다.

---

## §1. 들어가며

§4.3 강의에서는 **소수**(prime numbers)와 **최대공약수**(GCD), 그리고 **최소공배수**(LCM)를 다룹니다. 정수론의 가장 고전적이고도 가장 강력한 주제들이에요.

본 강의는 다음 다섯 주제를 다뤄요.

1. 합성수에는 √n 이하의 소인수가 존재한다는 정리(`composite_has_small_prime_factor`)
2. 유클리드의 소수 무한성 정리(`my_infinite_primes`)
3. 최대공약수 `Nat.gcd`의 사용법과 양수성 정리
4. 최소공배수 `Nat.lcm`의 사용법
5. 핵심 등식 `gcd(m, n) · lcm(m, n) = m · n`

§4.1·§4.2에서 다룬 도구가 본 절에서 활용됩니다. 특히 가분성의 결합 정리들(`Nat.dvd_add`, `Nat.dvd_factorial` 등)이 본 절의 두 핵심 정리에서 결정적인 역할을 해요.

---

## §2. 최소 소인수 `Nat.minFac`

§4.3의 첫 핵심 도구는 **최소 소인수**예요.

**정의** 1보다 큰 자연수 `n`에 대해, `n`을 나누는 가장 작은 소수를 `n`의 **최소 소인수**라 하고 `Nat.minFac n`으로 표시합니다.

[Q] 예를 들어 `Nat.minFac 12`는 무엇일까요? (3초) 답: 2. 12의 약수는 1, 2, 3, 4, 6, 12인데 그 중 소수는 2와 3이고 가장 작은 게 2.

[Q] `Nat.minFac 15`는? (3초) 3. 15 = 3 × 5의 가장 작은 소인수.

[Q] `Nat.minFac 7`은? (3초) 7. 소수 자체는 자기 자신이 유일한 소인수.

Mathlib에는 이 함수가 직접 정의되어 있어요. 그리고 그에 관한 세 가지 핵심 성질이 보조 정리로 제공됩니다.

| 정리 이름 | 진술 |
|---|---|
| `Nat.minFac_prime` | `n ≠ 1 → (Nat.minFac n).Prime` |
| `Nat.minFac_dvd` | `Nat.minFac n ∣ n` |
| `Nat.minFac_sq_le_self` | `0 < n → ¬ Nat.Prime n → (Nat.minFac n)^2 ≤ n` |

세 정리를 말로 풀면:

- 첫째: `n`이 1이 아니면, `minFac n`은 소수.
- 둘째: `minFac n`은 `n`의 약수.
- 셋째: `n`이 양수이고 합성수이면, `minFac n`의 제곱이 `n` 이하.

[ANALOGY] 세 정리는 마치 자물쇠를 푸는 세 열쇠 같아요. 합성수 정리를 풀려면 세 열쇠가 모두 있어야 합니다.

세 번째 정리가 §4.3 강의의 핵심 부등식이에요. 종이로 풀어 쓰면 "최소 소인수의 제곱은 원래 수보다 크지 않다"입니다. 이는 곧 합성수에 대해 "√n 이하의 소인수가 존재한다"는 강력한 사실로 이어져요.

[Q] 왜 그럴까요? (10초 정도 학생에게 생각할 시간)

답: 합성수 n이 1 < a < n과 1 < b < n으로 n = ab로 쓰일 때, 둘 중 작은 게 a라면 a ≤ b이고 a·a ≤ a·b = n. 즉 a² ≤ n. a를 더 잘게 쪼개도 그 소인수는 여전히 a 이하이고 그것의 제곱도 a² 이하. 따라서 √n 이하의 소인수가 존재합니다.

[WATCH] 학생들이 "왜 굳이 √n까지만 확인해도 충분한가요?"라고 묻습니다. 이게 합성수 판정 알고리즘의 핵심이에요. 100이 합성수임을 확인하려면 1부터 99까지 다 시도할 필요 없이, 1부터 10(=√100)까지만 확인하면 됩니다. 시간 복잡도가 어마어마하게 줄어들죠. 본 정리가 그걸 보장합니다.

---

## §3. 합성수의 작은 소인수 정리

**정리** `n`이 1보다 크고 소수가 아니면(즉 합성수이면), `p * p ≤ n`이고 `p ∣ n`인 소수 `p`가 존재합니다.

이는 종이의 "√n 이하의 소인수"를 정확히 옮긴 진술이에요. `p ≤ √n`은 `p² ≤ n`과 같고, 자연수 환경에서는 후자가 다루기 쉬우므로 그쪽을 씁니다.

```lean
import Mathlib
import Mathlib.Data.Nat.Prime.Basic

theorem composite_has_small_prime_factor
    (n : Nat) (h_comp : 1 < n ∧ ¬ Nat.Prime n) :
    ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n := by
  obtain ⟨h1, h_not_prime⟩ := h_comp
  -- (1) 0 < n 과 n ≠ 1 을 도출
  have hn_pos    : 0 < n := by omega
  have hn_ne_one : n ≠ 1 := by omega
  -- (2) 최소 소인수 p := Nat.minFac n 도입
  set p := Nat.minFac n with hp_def
  have hp_prime : Nat.Prime p := Nat.minFac_prime hn_ne_one
  have hp_dvd   : p ∣ n        := Nat.minFac_dvd n
  -- (3) Nat.minFac_sq_le_self : (minFac n)^2 ≤ n
  --     pow_two 로 ^2 = * 변환
  have hp_sq : p * p ≤ n := by
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rw [pow_two] at h
    exact h
  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩
```

[DEMO] 자, 시범 보입니다. 본 자료에서 첫 큰 정리예요. 여섯 가지 새 요소를 차근차근 봅시다.

**`obtain ⟨h1, h_not_prime⟩ := h_comp`** 가정 `h_comp : 1 < n ∧ ¬ Nat.Prime n`은 두 사실의 **합접**(conjunction, AND)이에요. 합접을 두 개의 따로따로의 가정으로 분해하는 게 `obtain`. 분해 결과 `h1 : 1 < n`과 `h_not_prime : ¬ Nat.Prime n`이 새 이름으로 가정에 들어가요.

[Q] `obtain`과 §4.1에서 본 `⟨...⟩`이 어떤 관계일까요? (5초) 답: 같은 꺽쇠 기호로 다른 일을 합니다. 가분성 증명에서 `⟨k, by ring⟩`은 두 정보를 **묶어 내는** 작업이었고, `obtain ⟨h1, h2⟩`는 두 정보를 **풀어내는** 작업이에요. 꺽쇠는 묶음/풀음 양쪽에서 다 쓰입니다.

[ANALOGY] 선물 상자를 다루는 두 방향 같아요. 선물을 포장(`⟨..., ...⟩`)하거나 풀어보거나(`obtain ⟨..., ...⟩`).

**`have hn_pos : 0 < n := by omega`** `h1 : 1 < n`에서 `0 < n`을 도출. `omega`가 선형 산술로 자동 처리.

**`set p := Nat.minFac n with hp_def`** 새 정의 `p`를 도입. `set`은 `let`과 비슷하지만 더 강해요. `Nat.minFac n`이라는 표현을 `p`라는 새 이름으로 묶고, 동시에 그 정의 등식을 `hp_def : p = Nat.minFac n`이라는 가정으로 함께 넣어 줍니다. 본문에서 `p`를 마치 보통의 변수처럼 쓸 수 있게 돼요.

[WATCH] 학생들이 `set`과 `let`의 차이를 묻습니다. 정확한 차이: `let`은 정의를 도입하지만 정의 등식이 자동으로 가정에 들어오지 않아요. `set`은 정의 등식도 함께 가정에 들어옵니다. 본 자료에서 `set`을 선호하는 이유예요.

**Mathlib 정리 직접 호출** `Nat.minFac_prime hn_ne_one`은 "n ≠ 1이라는 가정에서 minFac n이 소수임"을 즉시 도출. `Nat.minFac_dvd n`은 인수 한 개만 받아 가분성을 돌려줍니다.

**`Nat.minFac_sq_le_self`의 등장** 이 정리는 `(minFac n)^2 ≤ n`을 돌려줘요. 그러나 우리는 `p * p ≤ n` 형태를 원합니다. 둘은 같은 사실이지만 표현이 달라요. `pow_two`라는 보조 정리가 다리를 놓습니다.

```
pow_two : a^2 = a * a
```

`rw [pow_two] at h`는 가정 `h` 안의 `^2`를 `* a`로 다시 써요. 결과: `h : p * p ≤ n`.

[Q] 왜 `^2`와 `* a`이 같은데 굳이 변환해야 할까요? (5초) 답: Lean 4는 표현의 차이까지 구분하기 때문이에요. 정확히 같은 형태가 아니면 매칭이 안 됩니다. `rw [pow_two]`가 두 형태 사이의 다리.

**`exact ⟨p, hp_prime, hp_sq, hp_dvd⟩`** 마지막 줄. 결론이 `∃ p, P1 ∧ P2 ∧ P3`이라는 존재 + 합접의 결합이므로, 네 정보를 꺽쇠로 묶어 한꺼번에 제공합니다. 첫째는 증인 `p`, 나머지는 세 명제의 증명. Lean 4가 합접의 결합 구조를 자동으로 해석해요.

[AI] 본 정리의 형식 증명은 사실 합성수 판정 알고리즘의 정확성 증명이에요. AI 시스템이 큰 수를 다룰 때 "이 수가 소수인지 확인"이 결정적입니다. RSA 키 생성, 디지털 서명 검증 — 모두 소수성 판정에 의존해요. 우리가 본 정리는 그 효율적 알고리즘의 수학적 토대입니다.

---

### 전체 흐름 정리

| 종이 | Lean 4 |
|---|---|
| "n이 1보다 큰 합성수라 하자" | `obtain ⟨h1, h_not_prime⟩ := h_comp` |
| "최소 소인수 p = minFac n을 잡자" | `set p := Nat.minFac n with hp_def` |
| "p는 소수이다" | `have hp_prime := Nat.minFac_prime hn_ne_one` |
| "p ∣ n" | `have hp_dvd := Nat.minFac_dvd n` |
| "p² ≤ n" | `have hp_sq : p * p ≤ n := by ...` |
| "따라서 그런 p가 존재" | `exact ⟨p, hp_prime, hp_sq, hp_dvd⟩` |

종이의 다섯 단계가 코드의 다섯 줄과 정확히 한 줄씩 짝을 이뤄요.

[STUDENT TRY] 4분 활동. 위 정리에서 `h_comp`를 분해할 때 `obtain ⟨h1, h_not_prime⟩` 형태로 했죠. 만약 `h_comp` 가 `a ∨ b` 형태(합접이 아닌 분리)였다면 어떻게 분해할까요? Mathlib 문서에서 한번 찾아보세요. (4분 대기)

답: `obtain h_left | h_right := h_disj`. 또는 `cases h_disj with | inl h => ... | inr h => ...`. 분리는 두 경우를 따로 처리해야 하므로 갈래가 갈라집니다.

---

## §4. 유클리드의 소수 무한성

[교수자 멘트] 10분 휴식 후 본 자료의 클라이맥스로 들어갑니다. ... (휴식)

§4.3 강의의 가장 유명한 정리. 기원전 300년경 유클리드의 원론(Elements)에서 처음 증명됐어요.

**정리(유클리드)** 임의의 자연수 `N`에 대해, `N` 이상의 소수가 존재합니다.

[JOKE] 이 정리는 2300년 전 정리예요. 우리가 지금 Lean 4로 검증하는 게 어쩌면 유클리드가 봤다면 깜짝 놀랐을 일이죠. "내 증명을 컴퓨터가 한 줄씩 검사한다고?"

**종이의 고전적 증명:**

1. `Q = N! + 1`을 잡는다.
2. `Q ≥ 2`이므로 `Q`의 최소 소인수 `p`가 존재.
3. 만약 `p ≤ N`이면 `p ∣ N!`이고 동시에 `p ∣ Q = N! + 1`이므로 `p ∣ 1`. 이는 `p`가 소수임에 모순.
4. 따라서 `p > N`, 즉 `N < p`. 그리고 `p`는 소수.

[Q] 종이 증명의 절묘함을 다시 짚어 봅시다. `N! + 1`이라는 수를 왜 만들까요? (10초)

답: 이 수의 어떤 소인수든 N보다 커야 하기 때문이에요. 왜냐? N 이하의 어떤 수도 N!을 나누지만, N! + 1은 N!보다 정확히 1만큼 크니까. 그러니까 N 이하의 어떤 수로도 나누어떨어지지 않아요. 그래서 그 소인수는 N보다 큰 수일 수밖에 없습니다.

[ANALOGY] 마치 다음과 같아요. 어떤 자물쇠가 있는데, 이 자물쇠는 1부터 N까지의 어떤 열쇠로도 열리지 않습니다. 그러면 이 자물쇠를 여는 열쇠는 N보다 큰 어딘가에 있어야 해요. 그 자물쇠가 N! + 1이고, 그 열쇠가 우리가 찾는 소수 p예요.

[AI] 유클리드의 증명은 형식 증명 문헌에서 가장 자주 검증되는 정리 중 하나입니다. Lean, Coq, Isabelle 모든 정리 증명기에서 시범 정리로 다뤄져요. AI가 자동으로 증명을 찾을 수 있을지 시험할 때도 자주 쓰이는 벤치마크입니다. 본 강의에서 우리가 만드는 게 정확히 그 벤치마크와 같은 형태예요.

---

(계속)
### 유클리드 정리의 Lean 4 코드

```lean
theorem my_infinite_primes (N : Nat) : ∃ p, N ≤ p ∧ Nat.Prime p := by
  -- 1) Q := N! + 1
  set Q := Nat.factorial N + 1 with hQ
  
  -- 2) Q ≥ 2
  have hQ_ge : 2 ≤ Q := by
    rw [hQ]
    have := Nat.factorial_pos N
    omega

  -- 3) Q의 최소 소인수 p
  set p := Nat.minFac Q with hp
  have hp_prime : Nat.Prime p := Nat.minFac_prime (by omega)
  
  -- 4) 결론 도출
  refine ⟨p, ?_, hp_prime⟩
  
  -- N ≤ p 임을 증명 (귀류법)
  exact (Nat.lt_of_not_le (fun h : p ≤ N => 
    -- p ≤ N 이면 p는 N!의 약수
    have h_p_div_fact : p ∣ Nat.factorial N := 
      Nat.dvd_factorial (Nat.Prime.pos hp_prime) h
    -- p는 Q의 소인수이므로 Q를 나눈다
    have h_p_div_Q : p ∣ Q := by
      rw [hp]
      exact Nat.minFac_dvd Q
    -- p가 N!과 N!+1을 모두 나누면 1도 나누어야 함
    have h_p_div_one : p ∣ 1 := by
      rw [hQ] at h_p_div_Q
      exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
    -- 소수가 1을 나누는 것은 불가능
    show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
  )).le
```

[DEMO] 본 자료에서 가장 큰 코드입니다. 부분별로 차근차근 봅시다.

**부분 1. Q 정의와 양수성**

```lean
  set Q := Nat.factorial N + 1 with hQ
  have hQ_ge : 2 ≤ Q := by
    rw [hQ]
    have := Nat.factorial_pos N
    omega
```

`set Q := ...`는 §3에서 본 패턴. `with hQ`로 정의 등식을 가정에 두는 것이 핵심.

`have hQ_ge` 내부:
- `rw [hQ]`: 목표 안의 `Q`를 `Nat.factorial N + 1`로 다시 씀.
- `have := Nat.factorial_pos N`: 무명 가정으로 `0 < N!`을 받아 옴. 이름이 `this`로 자동 부여돼요.
- `omega`: `0 < N!`과 `Q = N! + 1`을 결합해 `2 ≤ Q`를 도출.

[Q] `have := ...`의 무명 형태가 뭐죠? (3초) 답: `omega`나 다른 자동화 전술이 가정으로 활용시키기 위한 표현이에요. Lean 4는 자동으로 `this`라는 이름을 부여합니다.

[WATCH] 학생들이 `have := ...`(이름 없는 형태)와 `have h := ...`(이름 있는 형태)를 헷갈려요. 둘 다 가정을 추가하는데, 후자는 명시적 이름을, 전자는 `this`를 자동 부여. 후자가 더 깔끔하지만 전자가 더 간결하죠. 본 자료에서는 둘 다 적절히 섞어 쓰고 있어요.

**부분 2. 최소 소인수와 소수성**

```lean
  set p := Nat.minFac Q with hp
  have hp_prime : Nat.Prime p := Nat.minFac_prime (by omega)
```

`(by omega)`는 `Nat.minFac_prime`이 요구하는 `Q ≠ 1`을 즉석에서 증명. `hQ_ge : 2 ≤ Q`로부터 `omega`가 처리.

[Q] 왜 `(by omega)`처럼 즉석 증명을 쓸까요? `have h_Q_ne_1 : Q ≠ 1 := ...` 같은 식으로 미리 만들어 둘 수도 있는데요. (5초)

답: 한 번만 쓰이는 보조 사실은 즉석 증명이 코드를 짧게 합니다. 여러 번 쓰일 거라면 `have`로 이름을 두는 게 낫고요. 본 코드에서 `Q ≠ 1`은 여기 한 번만 쓰이므로 즉석.

**부분 3. 결론의 부분 채움**

```lean
  refine ⟨p, ?_, hp_prime⟩
```

새 요소.

**`refine`** `exact`와 비슷하지만 부분적으로 채울 수 있어요. `?_` 자리가 다음 줄들의 새 목표가 됩니다.

[ANALOGY] 양식을 채워 넣을 때, 어떤 칸은 다 알아서 채우고 어떤 칸은 "여기는 나중에"라고 비워 두는 것 같아요. `refine`이 정확히 그런 일을 합니다.

`refine ⟨p, ?_, hp_prime⟩`의 세 위치:
- `p`: 증인.
- `?_`: 아직 못 채운 부분 (다음 줄들의 목표).
- `hp_prime`: 소수성.

```
-- AFTER refine:
--   ⊢ N ≤ p
```

목표가 `N ≤ p`로 좁혀졌어요.

**부분 4. 람다 귀류법**

여기가 본 정리의 핵심입니다.

```lean
  exact (Nat.lt_of_not_le (fun h : p ≤ N => 
    ...
  )).le
```

[Q] 이 표현이 좀 복잡해 보이죠? 천천히 분해해 봅시다. 바깥 골격이 뭘까요? (5초)

답: `(Nat.lt_of_not_le <증명>).le`. 즉:
1. `Nat.lt_of_not_le`로 `N < p`를 만든다.
2. 거기서 `.le`로 `N ≤ p`를 약화시킨다.

**`Nat.lt_of_not_le`의 진술**: `¬ (a ≤ b) → b < a`. 우리는 `N < p`를 보이고 싶으니까, `¬ (p ≤ N)`을 제공해야 해요.

**`(fun h : p ≤ N => <False 증명>)`라는 람다 표현** "만약 `p ≤ N`이라는 가정 `h`를 받았다고 치자. 그러면 모순(False)이 따라온다"는 의미예요. 이것이 정확히 **귀류법의 형태**입니다. "p ≤ N을 가정하면 False"라는 함수는 곧 `¬ (p ≤ N)`의 증명이에요.

[ANALOGY] 람다 함수로 귀류법을 표현하는 게 처음에는 어려워요. 비유하자면 — 가게에서 "혹시 이 영수증을 받으셨나요?"라고 묻는 직원이 있어요. 손님이 "네 받았어요"라고 답하면, 그 답이 모순으로 이어진다는 걸 보이는 거예요. 그러니까 사실 영수증을 안 받았다는 결론.

람다의 본문은 세 단계의 `have`로 모순을 끌어내요.

```lean
    have h_p_div_fact : p ∣ Nat.factorial N := 
      Nat.dvd_factorial (Nat.Prime.pos hp_prime) h
```

**`Nat.dvd_factorial`의 진술**: `0 < a → a ≤ n → a ∣ n!`. 즉 "양수이고 `n` 이하인 수는 `n!`을 나눈다". 우리는 `p`가 양수(소수이므로)이고 `p ≤ N`(가정 `h`)이므로 `p ∣ N!`을 즉시 얻어요.

[Q] 왜 `Nat.Prime.pos hp_prime`이 `0 < p`를 주는 거죠? (3초) 답: `Nat.Prime.pos`의 진술은 `p.Prime → 0 < p`. 점 표기법 `hp_prime.pos`로 줄여 쓰는 것도 가능해요.

```lean
    have h_p_div_Q : p ∣ Q := by
      rw [hp]
      exact Nat.minFac_dvd Q
```

`set`의 정의 `hp : p = Nat.minFac Q`이므로 `Nat.minFac_dvd Q`로 직접. `rw [hp]`는 목표 안의 `p`를 `Nat.minFac Q`로 다시 써서 정리 적용을 명확히 해요.

```lean
    have h_p_div_one : p ∣ 1 := by
      rw [hQ] at h_p_div_Q
      exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
```

**핵심 단계**. 이게 유클리드 증명의 마법이에요.

[Q] `Nat.dvd_add_right`의 진술이 뭐였죠? (5초) 답:
```
Nat.dvd_add_right : a ∣ b → (a ∣ b + c ↔ a ∣ c)
```

즉 "이미 `b`의 가분성이 있을 때, `b + c`의 가분성과 `c`의 가분성이 동치"라는 정리예요.

우리의 경우 `a = p`, `b = N!`, `c = 1`. `h_p_div_fact : p ∣ N!`에서 `.mp`로 `(p ∣ N! + 1) → (p ∣ 1)`을 적용. 좌변은 `h_p_div_Q`로부터.

[WATCH] `.mp`(modus ponens)와 `.mpr`(reverse) 이름을 헷갈리지 마세요. `iff` 정리에서 정방향(좌→우)이 `.mp`, 역방향(우→좌)이 `.mpr`. 우리는 정방향을 쓰니까 `.mp`.

```lean
    show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
```

**`show False from ...`** 람다의 마지막 줄. "지금 우리가 보이려는 것은 False이다. 그 증명은 다음과 같다"고 명시. 형식은 `show <명제> from <증명>`.

[Q] `Nat.Prime.not_dvd_one`의 진술은 뭘까요? (3초) 답: `Nat.Prime p → ¬ p ∣ 1`. "소수는 1을 나눌 수 없다"는 정수론의 기본 사실.

`hp_prime`(p가 소수)과 `h_p_div_one`(p가 1을 나눈다)이 동시에 있으니 `¬ p ∣ 1`과 `p ∣ 1`이 충돌. False.

### 전체 흐름 시각화

```
N < p를 보이는 길:
  └── ¬ (p ≤ N)을 보이는 길:
        └── p ≤ N을 가정하면 False:
              ├── p ∣ N!  (Nat.dvd_factorial)
              ├── p ∣ Q   (Nat.minFac_dvd)
              ├── p ∣ Q = N!+1 + 위로부터 → p ∣ 1   (Nat.dvd_add_right.mp)
              └── 소수는 1을 못 나눔, False  (Nat.Prime.not_dvd_one)
```

[STUDENT TRY] 5분 활동. 본 정리의 종이 증명을 손으로 다시 한 번 적어 보고, 어느 단계가 코드의 어느 줄에 대응하는지 색깔별로 표시해 보세요. (5분 대기)

[AI] 본 정리는 정형 증명의 역사에서 정말 중요한 정리예요. 1992년 Avigad과 Hales가 Lean의 전신 시스템에서 이를 처음 자동 검증했고, 이후 AI 시스템들의 벤치마크가 되었습니다. ChatGPT, Claude, Gemini 등도 본 정리를 어떻게 잘 다루는지가 수학 능력 평가에 자주 쓰여요.

---

## §5. 최대공약수 `Nat.gcd`

[교수자 멘트] 10분 휴식 후 마지막 단계로 갑니다. ... (휴식)

§4.3의 또 다른 기둥은 최대공약수입니다.

**정의** Mathlib의 `Nat.gcd`는 유클리드 호제법으로 정의되어 있어요.

```
Nat.gcd 0     y = y
Nat.gcd (x+1) y = Nat.gcd (y % (x+1)) (x+1)
```

말로 풀면 "큰 수를 작은 수로 나누고, 나머지로 다시 시작"이라는 유클리드 알고리즘 그 자체예요.

[ANALOGY] 두 막대기의 공통 측정 단위를 찾는 것 같아요. 긴 막대기와 짧은 막대기가 있을 때, 긴 것을 짧은 것으로 자르고 남는 부분으로 다시 측정. 이걸 반복하면 결국 두 막대기를 모두 정확히 나눌 수 있는 최대 길이가 나옵니다.

**시연**

```lean
#eval Nat.gcd 24 36     -- 12
#eval Nat.gcd 120 500   -- 20
#eval Nat.gcd 17 13     -- 1
```

[Q] 17과 13의 gcd가 1인 게 무엇을 의미할까요? (3초) 답: 서로소(coprime)예요. 두 수가 공통의 소인수를 갖지 않는다는 뜻.

[STUDENT TRY] 손계산 활동. `Nat.gcd 48 36`을 유클리드 호제법으로 손계산해 보세요. (3분 대기) 답:
- 48 = 36 · 1 + 12
- 36 = 12 · 3 + 0

따라서 gcd(48, 36) = 12.

---

## §6. gcd의 양수성

**정리** 두 자연수 `a`, `b` 중 적어도 하나가 0이 아니면, `gcd(a, b) > 0`입니다.

```lean
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  -- 1. gcd가 0보다 클 조건(iff)을 적용.
  -- 0 < gcd a b ↔ 0 < a ∨ 0 < b
  rw [Nat.gcd_pos_iff]
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h
```

[DEMO] 세 가지 새 요소.

**`Nat.gcd_pos_iff`** Mathlib의 정리.
```
Nat.gcd_pos_iff : 0 < Nat.gcd a b ↔ 0 < a ∨ 0 < b
```

이 동치를 적용하면 목표 `0 < Nat.gcd a b`가 `0 < a ∨ 0 < b`로 바뀝니다.

**`Nat.pos_iff_ne_zero`** 또 다른 동치.
```
Nat.pos_iff_ne_zero : 0 < n ↔ n ≠ 0
```

자연수 환경에서 "양수다"와 "0이 아니다"는 같은 사실이에요.

**`rwa`와 `←` 화살표** `rwa`는 `rw` + `assumption`의 결합. 다시 쓰기 후 가정 목록에서 일치하는 것을 찾아 즉결.

`←`는 등식·동치를 **역방향**으로 적용한다는 표시. 우리는 가정 `h : a ≠ 0 ∨ b ≠ 0`을 `0 < a ∨ 0 < b`로 바꿔야 하므로, `Nat.pos_iff_ne_zero`의 `0 < n ↔ n ≠ 0`을 역방향(`n ≠ 0 → 0 < n`)으로 적용. 그래서 `← Nat.pos_iff_ne_zero`예요. 두 번 적용(양변 각각)하므로 `← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero`로 두 번 씁니다.

[WATCH] 학생들이 `rwa`를 처음 보면 당황해요. 그냥 `rw` 후에 `exact`를 따로 쓰는 게 더 명료해 보이거든요. 두 형태 모두 가능합니다. 본 자료에서는 `rwa`를 보여 주지만, 학생이 명시적인 형태를 선호한다면 그쪽도 OK.

**대안 형태**

```lean
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  rw [Nat.gcd_pos_iff]
  have h_new : 0 < a ∨ 0 < b := by
    rwa [Nat.pos_iff_ne_zero, Nat.pos_iff_ne_zero]
  exact h_new
```

`have h_new`로 중간 사실을 명시적으로 손에 쥐고, `exact`로 마무리. 두 형태는 같은 일을 합니다.

[Q] 두 형태 중 어느 게 더 좋을까요? (3초) 답: 학습 단계에서는 명시적인 후자가 더 읽기 쉽고, 익숙해지면 간결한 전자가 더 깔끔. 본 자료에서 둘 다 보여주는 이유예요.

---

## §7. 최소공배수 `Nat.lcm`

**정의** Mathlib의 `Nat.lcm`은 다음과 같이 정의됩니다.

```
Nat.lcm m n := m * n / Nat.gcd m n
```

즉 "두 수의 곱을 그 gcd로 나눈 것"이에요. 종이에서 자주 외우는 공식 `lcm(m, n) = m·n / gcd(m, n)`을 정의 자체로 채택한 것입니다.

**시연**

```lean
#eval Nat.lcm 4 6        -- 12
#eval Nat.lcm 120 500    -- 3000
```

4와 6의 lcm은 12. 검산: gcd(4, 6) = 2, 4·6/2 = 12. (일치함)

[Q] 4와 6의 lcm이 12인 게 무엇을 의미할까요? (3초) 답: 4의 배수이면서 동시에 6의 배수인 가장 작은 양의 정수가 12. 12 = 4·3 = 6·2.

[ANALOGY] 두 시계가 다르게 가는 상황이에요. 한 시계가 4분마다 종을 치고, 다른 시계가 6분마다 종을 치면, 두 시계가 동시에 종을 치는 가장 빠른 순간이 12분 후예요. 그게 lcm입니다.

---

## §8. 핵심 등식 - `gcd · lcm = m · n`

§4.3의 클라이맥스 정리.

**정리** 자연수 `m`, `n`에 대해 `gcd(m, n) · lcm(m, n) = m · n`이에요.

```lean
example (m n : Nat) :
    Nat.gcd m n * Nat.lcm m n = m * n :=
  Nat.gcd_mul_lcm m n
```

Mathlib에 `Nat.gcd_mul_lcm`이라는 정확한 형태로 정리가 들어 있어 인수 두 개만 넘기면 끝.

**의미** 이 정리는 lcm의 정의 `Nat.lcm m n := m * n / Nat.gcd m n`을 양변에 gcd를 곱해 정리한 것이에요. 정의에서 정수 나눗셈을 자유롭게 다루려면 gcd가 0이 아니어야 하는데, Mathlib의 진술은 그 까다로움까지 자동 처리해 일반적으로 성립함을 보장합니다.

[Q] 종이로 이 정리를 보이는 가장 직관적인 길이 뭘까요? (10초) 답: 소인수 분해를 활용. m과 n을 같은 소수들의 곱으로 표현하면, gcd는 각 소수의 최소 차수, lcm은 최대 차수예요. 두 차수의 합이 원래 m·n의 차수이므로 등식 성립.

[ANALOGY] 두 사람이 가진 카드 모음 같아요. 둘이 공통으로 가진 카드(gcd)와 둘이 합쳐서 가진 모든 카드의 종류(lcm). 이 둘을 합치면 각자가 가진 카드 총합(m·n)이 됩니다.

[STUDENT TRY] 2분 활동. `gcd(12, 18) · lcm(12, 18) = 12 · 18`을 직접 계산해 보세요.
- gcd(12, 18) = 6
- lcm(12, 18) = 36
- 6 · 36 = 216 = 12 · 18 (일치함)

[AI] 이 등식은 사실 분산 시스템에서 자원 할당, 작업 스케줄링, 신호 처리의 주파수 동기화 등에서 응용돼요. AI 시스템의 자원 관리에서도 등장합니다.

---

## §9. 마무리 - 본 자료의 패턴 정리

본 강의에서 익힌 핵심 패턴 다섯 가지.

**패턴 1. 합접의 분해 (`obtain`)**

```lean
obtain ⟨h1, h2⟩ := h_conj
-- h_conj : P ∧ Q를 분해하여 h1 : P, h2 : Q를 얻음
```

**패턴 2. 정의 이름 짓기 (`set`)**

```lean
set p := <긴 표현> with hp_def
-- p가 새 이름이 되고, hp_def : p = <긴 표현>가 가정에 추가됨
```

**패턴 3. 존재+합접 결론 (`exact ⟨..., ..., ...⟩`)**

```lean
example : ∃ p, P1 ∧ P2 ∧ P3 := ⟨<증인>, <증명1>, <증명2>, <증명3>⟩
```

**패턴 4. 부분 채움 (`refine`)**

```lean
refine ⟨<채울 것>, ?_, <채울 것>⟩
-- ?_ 자리가 다음 줄들의 목표가 됨
```

**패턴 5. 람다 귀류법**

```lean
exact (Nat.lt_of_not_le (fun h : <가정> => <False 유도>))
```

본 자료를 따라치면, `Nat.minFac`, `Nat.factorial`, `Nat.gcd`, `Nat.lcm`, `Nat.dvd_factorial`, `Nat.dvd_add_right`, `Nat.gcd_pos_iff`, `Nat.gcd_mul_lcm` 등 §4.3의 핵심 Mathlib API에 자연스럽게 익숙해져요.

다음 단계는 §4.4의 **합동**(congruence)입니다. 합동은 가분성의 일반화이고, §4.1·§4.3의 모든 도구가 활용돼요.

---

## 강의 마무리 멘트

[교수자 멘트] 오늘은 정수론의 가장 고전적인 정리들을 다뤘어요. 합성수의 작은 소인수, 유클리드의 무한성, gcd, lcm — 모두 2300년 전부터 알려진 사실들을 컴퓨터가 한 줄씩 검증하는 형태로 옮겼습니다.

[Q] 오늘 가장 어려웠던 부분이 뭐였나요? (학생 응답 1~2분)

[JOKE] 학생들이 자주 "람다 귀류법이 정말 어렵다"고 말해요. 사실 그게 가장 시적인 부분이에요. "이게 참이라고 치자. 그러면 모순이 따라온다. 그러니까 이게 거짓이다." 이 짧은 형식 안에 인간의 가장 깊은 추론 방식 하나가 담겨 있어요.

다음 시간에는 §4.4 합동입니다. 우리만의 합동 관계 `CongMod`을 직접 정의하고, 그 위에서 모듈러 역원, 중국 잉여 정리, 페르마 소정리까지 — 정수론의 가장 빛나는 정리들을 다뤄요. 미리 §4.1과 §4.3을 한 번 더 복습해 두세요.

수고하셨습니다.

> **교수자 멘트 끝.**

---

## 부록 A. 자주 나오는 학생 질문

**Q1. `Nat.minFac n`이 정확히 어떻게 정의되어 있나요?**  
A: Mathlib의 정의는 효율적인 알고리즘으로 구현되어 있어요. 2부터 √n까지 차례로 시험. n 자체가 소수면 n을 돌려줌. `#print Nat.minFac`으로 자세히 볼 수 있습니다.

**Q2. `refine`과 `exact`의 차이는요?**  
A: `exact`는 목표를 완전히 채워야 합니다. `refine`은 `?_`로 자리표시를 두고 부분적으로 채울 수 있어요. 후속 줄에서 그 자리를 채웁니다.

**Q3. 람다 귀류법이 왜 그렇게 복잡한가요?**  
A: 사실 단순한 사고를 형식적으로 표현하면 그렇게 보입니다. 종이의 "p ≤ N이라 가정하자 → 모순 → 따라서 p > N"이 세 줄을 람다 함수로 묶은 것이에요. 익숙해지면 자연스럽습니다.

**Q4. `.le`, `.mp`, `.symm` 같은 점 표기법은요?**  
A: 객체에서 메서드를 부르는 형태예요. `(N < p).le`는 `LT.lt.le (N < p)`와 같고, `N ≤ p`를 줍니다. `h.symm`은 `Eq.symm h`. 점 표기법이 더 간결해요.

**Q5. `Nat.gcd_pos_iff`처럼 `_iff`로 끝나는 정리들의 이름 패턴은요?**  
A: `X_iff_Y`는 `X ↔ Y` 형태의 동치 정리예요. Mathlib에서 매우 흔한 명명 규칙. `rw`로 양방향 변환에 활용합니다.

---

## 부록 B. 다음 강의 예고

다음 시간 §4.4에서는 다음을 다룹니다:
1. 사용자 정의 합동 관계 `CongMod` (`def`로 명제 정의)
2. 합동의 세 성질 직접 증명 (반사·대칭·추이)
3. 모듈러 역원의 존재와 유일성 (베주 항등식, `Int.gcdA`/`gcdB`)
4. `ZMod n` 환경 (모듈러 산술의 자연스러운 표현)
5. 중국 잉여 정리(CRT)와 페르마 소정리

미리 복습할 사항:
- 본 자료의 람다 귀류법 형태
- §4.1의 가분성 결합 정리들
- `set`, `obtain`, `refine` 사용법
