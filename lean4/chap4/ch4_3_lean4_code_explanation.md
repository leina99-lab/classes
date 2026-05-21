# 4.3 Lean 4 코드 설명 자료

> 본 자료는 짝꿍 문서 **`ch4_3_lean4_student.md`**(학생 자료)에서 등장한 모든 Lean 4 코드를, 한 줄씩 누를 때마다 화면 오른쪽 **InfoView**가 어떻게 변하는지 정밀하게 기록한 해설서이다.

---

## 표기 약속

- `⊢` 목표.
- `-- BEFORE:` / `-- AFTER:` 실행 전후.
- `-- WHY:` 이유.
- `-- USES:` 사용한 정리·정의.

---

## 코드 1. `composite_has_small_prime_factor`

**완성 코드 전체**

```lean
theorem composite_has_small_prime_factor
    (n : Nat) (h_comp : 1 < n ∧ ¬ Nat.Prime n) :
    ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n := by
  obtain ⟨h1, h_not_prime⟩ := h_comp
  have hn_pos    : 0 < n := by omega
  have hn_ne_one : n ≠ 1 := by omega
  set p := Nat.minFac n with hp_def
  have hp_prime : Nat.Prime p := Nat.minFac_prime hn_ne_one
  have hp_dvd   : p ∣ n        := Nat.minFac_dvd n
  have hp_sq : p * p ≤ n := by
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rw [pow_two] at h
    exact h
  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩
```

**한 줄씩 분석**

```lean
theorem composite_has_small_prime_factor
    (n : Nat) (h_comp : 1 < n ∧ ¬ Nat.Prime n) :
    ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n := by
```

```
-- AFTER `:= by`:
--   n : Nat
--   h_comp : 1 < n ∧ ¬ Nat.Prime n
--   ⊢ ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n
```

가정에 `n`(자유 변수)과 `h_comp`(합접 명제 하나) 두 개. 목표는 존재 + 세 합접의 결론.

---

```lean
  obtain ⟨h1, h_not_prime⟩ := h_comp
```

- WHY: 합접 가정을 두 개의 따로따로의 가정으로 분해.
- USES: `obtain`. 꺽쇠 패턴으로 합접의 두 성분을 새 이름으로 받아냄.

```
-- AFTER:
--   n : Nat
--   h1 : 1 < n
--   h_not_prime : ¬ Nat.Prime n
--   ⊢ ∃ p, Nat.Prime p ∧ p * p ≤ n ∧ p ∣ n
```

가정에서 `h_comp`가 사라지고, 그 분해 결과인 `h1`과 `h_not_prime`이 추가됨.

---

```lean
  have hn_pos : 0 < n := by omega
```

- WHY: `h1 : 1 < n`에서 `0 < n`을 추출하기 위함. 후에 `Nat.minFac_sq_le_self`가 이 양수성을 요구함.
- USES: `omega`. 선형 산술 자동 결정.

```
-- AFTER:
--   ..., hn_pos : 0 < n
--   ⊢ ∃ p, ...
```

---

```lean
  have hn_ne_one : n ≠ 1 := by omega
```

- WHY: 후에 `Nat.minFac_prime`이 이 사실을 요구함.
- USES: `omega`. `h1 : 1 < n`에서 직접 도출.

---

```lean
  set p := Nat.minFac n with hp_def
```

- WHY: 새 정의 `p = Nat.minFac n`을 도입. 가독성과 후속 단계에서의 참조 편의를 위함.
- USES: `set`. `let`과 비슷하지만 정의 등식을 가정에 함께 넣어 줌.

```
-- AFTER `set p := ...`:
--   ..., 
--   p : Nat := Nat.minFac n   -- 새 정의
--   hp_def : p = Nat.minFac n
--   ⊢ ∃ p, ...     -- 주의: 결론의 p와 set의 p는 별개 이름
```

---

```lean
  have hp_prime : Nat.Prime p := Nat.minFac_prime hn_ne_one
```

- WHY: `Nat.minFac n`이 소수임을 손에 쥔다.
- USES: `Nat.minFac_prime : n ≠ 1 → Nat.Prime (Nat.minFac n)`.

`set`에 의해 `p = Nat.minFac n`이므로, Lean 4는 `Nat.Prime p`와 `Nat.Prime (Nat.minFac n)`을 같은 것으로 다룬다.

---

```lean
  have hp_dvd : p ∣ n := Nat.minFac_dvd n
```

- WHY: `Nat.minFac n ∣ n`을 손에 쥔다.
- USES: `Nat.minFac_dvd : ∀ (n : Nat), Nat.minFac n ∣ n`. 이 정리는 가정 없이 항상 성립.

---

```lean
  have hp_sq : p * p ≤ n := by
    have h := Nat.minFac_sq_le_self hn_pos h_not_prime
    rw [pow_two] at h
    exact h
```

- WHY: 핵심 부등식 `p * p ≤ n`을 손에 쥔다. 두 단계: (1) `Nat.minFac_sq_le_self`로 `(minFac n)^2 ≤ n` 얻기, (2) `^2`를 `* a`로 풀어 `* p` 형태로 변환.
- USES:
  - `Nat.minFac_sq_le_self : 0 < n → ¬ Nat.Prime n → (Nat.minFac n)^2 ≤ n`.
  - `pow_two : a^2 = a * a`.

`rw [pow_two] at h`의 동작:
- `h`의 초기 진술: `(Nat.minFac n)^2 ≤ n`, 즉 `p^2 ≤ n`.
- `pow_two`를 적용하면 `p^2`이 `p * p`로 바뀜.
- 결과 `h : p * p ≤ n`.

```
-- AFTER:
--   ..., hp_sq : p * p ≤ n
--   ⊢ ∃ p, ...
```

---

```lean
  exact ⟨p, hp_prime, hp_sq, hp_dvd⟩
```

- WHY: 결론 `∃ p, P1 ∧ P2 ∧ P3`을 네 정보로 한꺼번에 채움. 첫 성분은 증인, 나머지는 세 명제 증명.
- USES: 꺽쇠 패턴. 합접의 결합 구조는 Lean 4가 자동 해석.

```
-- AFTER:
--   (No goals)
```

---

## 코드 2. `composite_has_small_prime_factor1` - 대안 형태

`omega`를 쓰지 않고 같은 정리를 증명. 본 자료의 학습용보다는 "다른 길도 있다"를 보여 주는 시연.

차이점:
- `0 < n := Nat.zero_lt_of_lt h1` (omega 대신 명시적 정리)
- `n ≠ 1 := Nat.ne_of_gt h1` (omega 대신 명시적 정리)
- `rwa [← hp_def, pow_two] at h` (rw + assumption 한 줄로 압축; 또한 ← hp_def로 set의 등식을 뒤집어 활용)

학습 단계에서는 첫 형태(omega 활용)가 더 직관적이다. 둘째 형태는 "Mathlib 정리만으로 닫는" 보수적 스타일을 보여 준다.

---

## 코드 3. `my_infinite_primes` - 유클리드의 정리

**완성 코드 전체** (학생 자료 §4 참조)

본 자료에서 가장 큰 코드. 부분별로 분석한다.

### 부분 1. `Q` 정의와 양수성

```lean
  set Q := Nat.factorial N + 1 with hQ
  have hQ_ge : 2 ≤ Q := by
    rw [hQ]
    have := Nat.factorial_pos N
    omega
```

`set Q := ...`는 코드 1에서 본 패턴.

`have hQ_ge : 2 ≤ Q := by ...`의 내부:
- `rw [hQ]`: 목표 안의 `Q`를 `Nat.factorial N + 1`로 다시 씀.
- `have := Nat.factorial_pos N`: 무명 가정으로 `0 < N!`을 받아 옴. 이름이 `this`로 자동 부여됨.
- `omega`: `0 < N!`과 `Q = N! + 1`을 결합해 `2 ≤ Q`를 도출.

`have := ...`의 무명 형태는 `omega`나 다른 자동화 전술에 가정으로 활용시키기 위한 표현이다. Lean 4는 자동으로 `this`라는 이름을 부여.

### 부분 2. 최소 소인수와 소수성

```lean
  set p := Nat.minFac Q with hp
  have hp_prime : Nat.Prime p := Nat.minFac_prime (by omega)
```

`(by omega)`는 `Nat.minFac_prime`이 요구하는 `Q ≠ 1`을 즉석에서 증명. `hQ_ge : 2 ≤ Q`로부터 `omega`가 처리.

### 부분 3. 결론의 부분 채움

```lean
  refine ⟨p, ?_, hp_prime⟩
```

- `p`: 증인.
- `?_`: 아직 못 채운 부분. 다음 줄들의 목표가 됨.
- `hp_prime`: 소수성.

```
-- AFTER `refine ...`:
--   ..., ⊢ N ≤ p
```

목표가 `N ≤ p`로 좁혀짐.

### 부분 4. 람다 귀류법

```lean
  exact (Nat.lt_of_not_le (fun h : p ≤ N => 
    have h_p_div_fact : p ∣ Nat.factorial N := 
      Nat.dvd_factorial (Nat.Prime.pos hp_prime) h
    have h_p_div_Q : p ∣ Q := by
      rw [hp]
      exact Nat.minFac_dvd Q
    have h_p_div_one : p ∣ 1 := by
      rw [hQ] at h_p_div_Q
      exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
    show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
  )).le
```

이 한 표현이 다섯 단계를 결합한다.

**바깥 골격**: `(Nat.lt_of_not_le <증명>).le`. 즉 `N < p`를 만든 다음 `.le`로 약화시켜 `N ≤ p`를 결론. `.le`는 `LT.lt → LE.le`의 자동 변환.

**`Nat.lt_of_not_le`의 입력**: `¬ (p ≤ N)`. 이를 람다 `fun h : p ≤ N => <False 증명>`로 제공.

**람다 안의 세 `have`**:

(a) `h_p_div_fact : p ∣ Nat.factorial N`. 인수: `Nat.Prime.pos hp_prime`(p가 양수)과 `h`(p ≤ N). 정리: `Nat.dvd_factorial : 0 < a → a ≤ n → a ∣ n!`.

(b) `h_p_div_Q : p ∣ Q`. `set`의 정의에 따라 `p = Nat.minFac Q`이므로 `Nat.minFac_dvd Q`로 직접. `rw [hp]`는 목표 안의 `p`를 `Nat.minFac Q`로 다시 써서 정리 적용을 명확히 함.

(c) `h_p_div_one : p ∣ 1`. 핵심 단계. `rw [hQ] at h_p_div_Q`로 `h_p_div_Q`의 `Q`를 `N! + 1`로 다시 씀. 결과: `h_p_div_Q : p ∣ N! + 1`. 그리고 `Nat.dvd_add_right h_p_div_fact`의 `.mp`(좌→우)를 적용.

`Nat.dvd_add_right`의 진술:
```
Nat.dvd_add_right : a ∣ b → (a ∣ b + c ↔ a ∣ c)
```

우리의 경우 `a = p`, `b = N!`, `c = 1`. `h_p_div_fact : p ∣ N!`에서 `.mp`로 `(p ∣ N! + 1) → (p ∣ 1)`을 적용. 좌변은 `h_p_div_Q`로부터.

**`show False from ...`**: 마지막. `Nat.Prime.not_dvd_one hp_prime h_p_div_one`이 정확히 모순. `Nat.Prime.not_dvd_one : Nat.Prime p → ¬ p ∣ 1`. `hp_prime`과 `h_p_div_one`을 결합하면 `¬ p ∣ 1`과 `p ∣ 1`이 동시에 있어 `False`.

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

---

## 코드 4. gcd 시연

```lean
#eval Nat.gcd 24 36     -- 12
#eval Nat.gcd 120 500   -- 20
#eval Nat.gcd 17 13     -- 1
```

`#eval`은 명령(command)이다. 정리가 아니라 "이 값을 계산해서 출력하라"는 시연. InfoView가 결과 값을 표시.

---

## 코드 5. gcd 양수성

**완성 코드**

```lean
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
  rw [Nat.gcd_pos_iff]
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h
```

**한 줄씩 분석**

```lean
example (a b : Nat) (h : a ≠ 0 ∨ b ≠ 0) : 0 < Nat.gcd a b := by
```

```
-- AFTER `:= by`:
--   a b : Nat
--   h : a ≠ 0 ∨ b ≠ 0
--   ⊢ 0 < Nat.gcd a b
```

---

```lean
  rw [Nat.gcd_pos_iff]
```

- WHY: 목표를 동치인 더 다루기 쉬운 형태로 변환.
- USES: `Nat.gcd_pos_iff : 0 < Nat.gcd a b ↔ 0 < a ∨ 0 < b`.

```
-- AFTER:
--   ⊢ 0 < a ∨ 0 < b
```

---

```lean
  rwa [← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero] at h
```

- WHY: 가정 `h`의 두 부분(`a ≠ 0`, `b ≠ 0`)을 각각 `0 < a`, `0 < b`로 변환.
- USES:
  - `Nat.pos_iff_ne_zero : 0 < n ↔ n ≠ 0`.
  - `←` 화살표: 동치를 역방향으로(`n ≠ 0 → 0 < n`).

`[← Nat.pos_iff_ne_zero, ← Nat.pos_iff_ne_zero]`는 같은 동치를 두 번 적용. 첫 번째 적용은 `a ≠ 0`을 `0 < a`로, 두 번째는 `b ≠ 0`을 `0 < b`로.

`rwa` = `rw` + `assumption`. 다시 쓰기가 끝난 후 가정 목록에서 일치하는 것을 찾아 자동 닫기. 우리의 경우 `rw` 후 `h : 0 < a ∨ 0 < b`가 되고, 목표가 정확히 같으므로 `assumption`이 닫음.

```
-- AFTER:
--   (No goals)
```

---

## 코드 6. lcm 시연과 핵심 등식

```lean
#eval Nat.lcm 4 6        -- 12
#eval Nat.lcm 120 500    -- 3000

example (m n : Nat) :
    Nat.gcd m n * Nat.lcm m n = m * n :=
  Nat.gcd_mul_lcm m n
```

`Nat.gcd_mul_lcm`을 인수 둘만 넘기면 즉결. 본 자료에서 가장 짧은 정리.

```
-- AFTER:
--   (No goals)
```

---

## 마무리

본 코드 설명 자료에서 다룬 코드들을 직접 입력하고 InfoView가 일치하는지 확인한다.

§4.4의 합동 자료에서 다시 만난다.
