# 5.2 Lean 4 코드 설명 자료 — 학생용

> 본 자료는 짝꿍 문서 **`ch5_2_lean4.lean`**(통합 코드 파일)에 등장한 모든 Lean 4 코드를, 한 줄씩 누를 때마다 화면 오른쪽 **InfoView**가 어떻게 변하는지 정밀하게 기록한 해설서이다.

---

## 표기 약속

- `⊢` 목표.
- `-- BEFORE:` / `-- AFTER:` 실행 전후.
- `-- WHY:` 이유.
- `-- USES:` 사용한 정리·정의.

---

## 코드 1. `postage_4_5`

**완성 코드 전체**

```lean
def postage_4_5 :
    (n : Nat) → 12 ≤ n → ∃ a b : Nat, n = 4 * a + 5 * b
  | 12, _ => ⟨3, 0, by decide⟩
  | 13, _ => ⟨2, 1, by decide⟩
  | 14, _ => ⟨1, 2, by decide⟩
  | 15, _ => ⟨0, 3, by decide⟩
  | (n + 16), _ =>
      let ⟨a, b, _⟩ := postage_4_5 (n + 12) (by omega)
      ⟨a + 1, b, by omega⟩
```

**한 줄씩 분석**

```lean
def postage_4_5 :
    (n : Nat) → 12 ≤ n → ∃ a b : Nat, n = 4 * a + 5 * b
```

- WHY: 함수 정의의 시그니처(signature). `theorem`이 아니라 `def`를 쓴 이유는 *재귀 호출이 본질*이기 때문이다.
- 입력: 자연수 `n`과 `12 ≤ n`의 증거.
- 출력: `n = 4 * a + 5 * b`인 `a, b`가 존재한다는 명제(구체적 증인 포함).

```
-- AFTER (시그니처 확정):
--   postage_4_5 : (n : Nat) → 12 ≤ n → ∃ a b, n = 4 * a + 5 * b
```

---

```lean
  | 12, _ => ⟨3, 0, by decide⟩
```

- WHY: 기저 케이스 1. `n = 12`일 때 `a = 3, b = 0`이 증인.
- USES: 꺽쇠 패턴 `⟨a, b, 등식 증명⟩`. `by decide`가 `12 = 4 * 3 + 5 * 0`을 계산으로 검증.
- 두 번째 인수 `_`은 `12 ≤ 12` 가설을 받지 않고 무시한다는 표시.

```
-- 패턴 매칭 후 목표:
--   ⊢ ∃ a b, 12 = 4 * a + 5 * b
-- 꺽쇠 안의 ⟨3, 0, ...⟩이 a = 3, b = 0을 제공하고
-- 남은 목표 12 = 4 * 3 + 5 * 0 을 by decide가 닫음
```

---

```lean
  | 13, _ => ⟨2, 1, by decide⟩
  | 14, _ => ⟨1, 2, by decide⟩
  | 15, _ => ⟨0, 3, by decide⟩
```

- WHY: 기저 케이스 2, 3, 4. 같은 패턴.
- 네 개의 기저가 필요한 이유는 재귀 호출이 `n + 16 → n + 12`로 *4칸 점프*하기 때문. 출발점이 4개여야 16 이상의 모든 자연수가 어딘가에서 시작된다.

---

```lean
  | (n + 16), _ =>
      let ⟨a, b, _⟩ := postage_4_5 (n + 12) (by omega)
      ⟨a + 1, b, by omega⟩
```

- WHY: 귀납 단계. `n + 16` 이상의 모든 자연수를 한 번에 처리.
- USES:
  - **재귀 호출** `postage_4_5 (n + 12) (...)`: 자기 자신을 더 작은 입력으로 호출. 강한 귀납법의 형식화.
  - `(by omega)`: 호출에 필요한 가설 `12 ≤ n + 12`를 즉석에서 증명.
  - `let ⟨a, b, _⟩ := ...`: 재귀 호출 결과를 분해. 세 번째 성분(등식 증명)은 사용하지 않으므로 `_`.
  - `⟨a + 1, b, by omega⟩`: 새 증인 `a + 1, b`와 함께 등식 `n + 16 = 4 * (a + 1) + 5 * b`를 `omega`로 검증.

```
-- 흐름:
--   재귀 호출이 ⟨a, b, h⟩를 반환 (단, h : n + 12 = 4 * a + 5 * b)
--   (사용하지 않으므로 _로 받음)
--   새 증인: a' = a + 1, b' = b
--   목표: n + 16 = 4 * (a + 1) + 5 * b
--   omega가 위 사실로부터 자동 처리
```

**왜 종결하는가?** `n + 16 → n + 12`로 입력이 *엄격히 감소*. 자연수 위의 엄격 감소 수열은 유한하므로 Lean의 종결성 검사가 자동으로 통과한다. 이 종결성 보장이 *정렬 원리*의 직접 응용이다.

---

## 코드 2. `postage_4_7`

**완성 코드 전체**

```lean
def postage_4_7 :
    (n : Nat) → 18 ≤ n → ∃ a b : Nat, n = 4 * a + 7 * b
  | 18, _ => ⟨1, 2, by decide⟩
  | 19, _ => ⟨3, 1, by decide⟩
  | 20, _ => ⟨5, 0, by decide⟩
  | 21, _ => ⟨0, 3, by decide⟩
  | (n + 22), _ =>
      let ⟨a, b, _⟩ := postage_4_7 (n + 18) (by omega)
      ⟨a + 1, b, by omega⟩
```

코드 1과 골격이 똑같다. 차이는 다음 두 가지.

- 기저가 `18, 19, 20, 21`. 출발점이 18이고 점프 거리가 4이므로 *4개의 연속된 출발점*이 필요.
- 재귀 호출이 `n + 22 → n + 18`로 4칸 점프.

**일반 관찰**. 서로소인 양의 정수 `p, q`에 대해 점프 거리는 항상 `p`(또는 `q`)이고, 출발점 개수도 `p`(또는 `q`)개이다. 표현 불가능한 최대 자연수는 `pq - p - q`(프로베니우스 수). 코드 1의 경우 `4 * 5 - 4 - 5 = 11`, 코드 2의 경우 `4 * 7 - 4 - 7 = 17`. 두 정리가 각각 12 이상, 18 이상에서 시작하는 이유.

---

## 코드 3. `exists_prime_factor`

**완성 코드 전체**

```lean
theorem exists_prime_factor (n : Nat) (h : 2 ≤ n) :
    ∃ p : Nat, p.Prime ∧ p ∣ n :=
  Nat.exists_prime_and_dvd (by omega)
```

**한 줄씩 분석**

```lean
theorem exists_prime_factor (n : Nat) (h : 2 ≤ n) :
    ∃ p : Nat, p.Prime ∧ p ∣ n :=
```

- WHY: `n ≥ 2`인 모든 자연수가 적어도 하나의 소수 약수를 가진다는 정리.
- 가정: `n : Nat`, `h : 2 ≤ n`.
- 결론: `∃ p, Prime p ∧ p ∣ n`.

```
-- 시그니처 확정 직후:
--   n : Nat
--   h : 2 ≤ n
--   ⊢ ∃ p, p.Prime ∧ p ∣ n
```

---

```lean
  Nat.exists_prime_and_dvd (by omega)
```

- WHY: 정리 본문이 단 한 줄. Mathlib의 기존 정리를 *직접 호출*하여 결론을 즉시 제공.
- USES: `Nat.exists_prime_and_dvd : n ≠ 1 → ∃ p, p.Prime ∧ p ∣ n`.
- `(by omega)`: 정리의 가설 `n ≠ 1`을 `h : 2 ≤ n`으로부터 `omega`가 즉시 도출.

```
-- AFTER:
--   (No goals)
```

**관찰**. 본 정리의 *진짜 증명*은 Mathlib 내부 깊은 곳에 강한 귀납법으로 박제되어 있다. 우리는 이를 *한 줄로 호출*해 사용한다. Mathlib 활용의 전형적 패턴.

---

## 코드 4. `prime_factorization`

**완성 코드 전체**

```lean
theorem prime_factorization (n : Nat) (h : 2 ≤ n) :
    ∃ l : List Nat, (∀ p ∈ l, p.Prime) ∧ l.prod = n :=
  ⟨n.primeFactorsList,
   fun _ hp => Nat.prime_of_mem_primeFactorsList hp,
   Nat.prod_primeFactorsList (by omega)⟩
```

**한 줄씩 분석**

```lean
theorem prime_factorization (n : Nat) (h : 2 ≤ n) :
    ∃ l : List Nat, (∀ p ∈ l, p.Prime) ∧ l.prod = n :=
```

- WHY: 산술의 기본정리 — 존재성. 모든 `n ≥ 2`가 소수들의 *리스트의 곱*으로 표현됨.
- 결론의 형식:
  - `∃ l : List Nat`: 자연수 리스트가 존재.
  - `(∀ p ∈ l, p.Prime)`: 리스트의 모든 원소가 소수.
  - `l.prod = n`: 리스트의 모든 원소의 곱이 `n`.
- `:= by` 대신 `:=` 한 번만 사용하여 *term 모드*로 즉시 증명을 제시.

```
-- 시그니처 확정 직후:
--   n : Nat
--   h : 2 ≤ n
--   ⊢ ∃ l, (∀ p ∈ l, p.Prime) ∧ l.prod = n
```

---

```lean
  ⟨n.primeFactorsList,
   fun _ hp => Nat.prime_of_mem_primeFactorsList hp,
   Nat.prod_primeFactorsList (by omega)⟩
```

- WHY: 한 줄짜리 꺽쇠 — 결론의 세 성분을 한 번에 제시.
- 꺽쇠 안의 세 성분:

  1. `n.primeFactorsList`: 존재 명제의 *증인*. Mathlib이 제공하는 *`n`의 소수 인수 리스트*. 예: `Nat.primeFactorsList 12 = [2, 2, 3]`.
  2. `fun _ hp => Nat.prime_of_mem_primeFactorsList hp`: 첫째 합접 성분 — 리스트의 모든 원소가 소수임을 *람다 함수*로 제공. 입력 `_`(이름 무시할 임의 원소 `p`)와 `hp : p ∈ n.primeFactorsList`, 출력은 `p.Prime`.
  3. `Nat.prod_primeFactorsList (by omega)`: 둘째 합접 성분 — 리스트의 곱이 `n`임. Mathlib 정리에 가설 `0 < n`을 `by omega`로 즉석 제공.

- USES:
  - `Nat.prime_of_mem_primeFactorsList : p ∈ n.primeFactorsList → p.Prime`.
  - `Nat.prod_primeFactorsList : 0 < n → n.primeFactorsList.prod = n`.
  - `omega`: `h : 2 ≤ n`에서 `0 < n` 도출.

```
-- AFTER:
--   (No goals)
```

**관찰**. 본 정리는 `theorem ... := ⟨..., ..., ...⟩` 형식 — *term 모드*의 표본. `by`를 한 번도 쓰지 않고 *증명 항(term)을 직접 제시*. 함수형 증명의 가장 순수한 형태.



---

## 코드 5. `well_ordering` — 결정 가능 술어의 정렬 원리

**완성 코드 전체**

```lean
theorem well_ordering (p : Nat → Prop) [DecidablePred p] (h : ∃ n, p n) :
    ∃ m, p m ∧ ∀ k, p k → m ≤ k :=
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩
```

**한 줄씩 분석**

```lean
theorem well_ordering (p : Nat → Prop) [DecidablePred p] (h : ∃ n, p n) :
    ∃ m, p m ∧ ∀ k, p k → m ≤ k :=
```

- WHY: 정렬 원리의 결정 가능 술어 버전. 술어 `p`를 만족하는 자연수가 적어도 하나 있으면 *최소*의 그런 자연수가 있다.
- 매개변수:
  - `p : Nat → Prop`: 자연수 위의 술어.
  - `[DecidablePred p]`: 임의의 `n`에 대해 `p n`의 참·거짓을 *계산으로* 판정 가능.
  - `h : ∃ n, p n`: `p`를 만족하는 자연수가 적어도 하나 존재.

```
-- 시그니처 확정 직후:
--   p : Nat → Prop
--   instDec : DecidablePred p   (인스턴스 자동 추론)
--   h : ∃ n, p n
--   ⊢ ∃ m, p m ∧ ∀ k, p k → m ≤ k
```

---

```lean
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩
```

- WHY: 결론을 *한 항(term)으로* 직접 제시. 증명 모드 `by`를 사용하지 않음.
- 꺽쇠 안의 세 성분:

  1. `Nat.find h`: 가장 작은 자연수 `m`을 *계산으로* 반환. 술어 `p`를 만족하는 최소값.
  2. `Nat.find_spec h`: 반환된 `m`이 실제로 `p m`을 만족한다는 증거.
  3. `fun _ hk => Nat.find_min' h hk`: 람다 함수. 임의의 `k`(이름 무시 `_`)와 가설 `hk : p k`를 받아 `Nat.find h ≤ k`를 반환.

- USES:
  - `Nat.find : (∃ n, p n) → Nat`. 계산적 최소값 탐색.
  - `Nat.find_spec : ∀ (h : ∃ n, p n), p (Nat.find h)`.
  - `Nat.find_min' : ∀ (h : ∃ n, p n), p k → Nat.find h ≤ k`.

```
-- AFTER:
--   (No goals)
```

**핵심 관찰**. 정렬 원리의 *추상적 진술*("최소 원소가 존재한다")이 Lean에서는 *실제 값을 반환하는 함수* `Nat.find`로 *구성적으로* 실현된다. `#eval Nat.find h`를 실행하면 그 최소값의 *수치*가 출력된다.

---

## 코드 5의 인스턴스 — `n ≥ 5 이고 n^2 > 30`인 최소 자연수

**완성 코드 전체**

```lean
example :
    ∃ m, (m ≥ 5 ∧ m ^ 2 > 30) ∧ ∀ k, (k ≥ 5 ∧ k ^ 2 > 30) → m ≤ k :=
  let h : ∃ n, n ≥ 5 ∧ n ^ 2 > 30 := ⟨6, by decide, by decide⟩
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩
```

**행별 해설**

```lean
  let h : ∃ n, n ≥ 5 ∧ n ^ 2 > 30 := ⟨6, by decide, by decide⟩
```

- WHY: `Nat.find`를 사용하려면 *존재성 가설 `h`*가 먼저 필요. `n = 6`이 두 조건(`6 ≥ 5`, `6^2 = 36 > 30`)을 모두 만족하는 증인.
- USES: 꺽쇠 패턴. `⟨6, ...⟩`의 첫 성분이 증인, 나머지가 두 조건의 증명. `by decide`가 둘 다 계산으로 닫음.

```lean
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩
```

- 코드 5와 똑같은 꺽쇠. 술어가 `(· ≥ 5 ∧ · ^ 2 > 30)` 형태인 점만 다름.

**실행 확인**.

```lean
#eval Nat.find (show ∃ n, n ≥ 5 ∧ n ^ 2 > 30 from ⟨6, by decide, by decide⟩)
-- 결과: 6
```

InfoView 또는 출력 창에 `6`이 표시된다. 우리는 *정리*를 증명했고, 동시에 *계산*도 가능하다. Lean의 강력함이 드러나는 지점.

---

## 코드 6. `strong_to_weak` — 강한 귀납법 ↔ 단순 귀납법

**완성 코드 전체**

```lean
theorem strong_to_weak {P : Nat → Prop}
    (h0 : P 0)
    (hS : ∀ k, (∀ j, j ≤ k → P j) → P (k + 1)) :
    ∀ n, P n := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    match n with
    | 0 => exact h0
    | k + 1 =>
      apply hS
      intro j hj
      exact ih j (by omega)
```

**한 줄씩 분석**

```lean
theorem strong_to_weak {P : Nat → Prop}
    (h0 : P 0)
    (hS : ∀ k, (∀ j, j ≤ k → P j) → P (k + 1)) :
    ∀ n, P n := by
```

- WHY: 강한 귀납법의 두 조건(`h0`: 기저, `hS`: 강한 귀납 단계)으로부터 *모든 `n`에 대한 `P n`*을 도출.
- `{P : Nat → Prop}`: 술어 `P`는 *암묵 매개변수*. 호출 시 자동 추론.

```
-- AFTER `:= by`:
--   P : Nat → Prop
--   h0 : P 0
--   hS : ∀ k, (∀ j, j ≤ k → P j) → P (k + 1)
--   ⊢ ∀ n, P n
```

---

```lean
  intro n
```

- WHY: `∀ n` 형태의 결론에서 `n`을 가정으로 끌어옴.

```
-- AFTER:
--   ..., n : Nat
--   ⊢ P n
```

---

```lean
  induction n using Nat.strong_induction_on with
  | _ n ih =>
```

- WHY: 강한 귀납법 적용. 단순 귀납법 `induction n with`와 달리 `Nat.strong_induction_on`을 명시.
- USES: `Nat.strong_induction_on`의 귀납 가설은 `ih : ∀ m, m < n → P m`. 즉 "모든 *더 작은* 자연수에 대해 `P`가 성립한다."
- `| _ n ih =>`: 단일 케이스(강한 귀납법은 케이스 분기가 없음). 변수명 `n`이 새로 도입되어 *그 안*에서 사용됨.

```
-- AFTER:
--   ..., n : Nat
--   ih : ∀ m, m < n → P m
--   ⊢ P n
```

---

```lean
    match n with
    | 0 => exact h0
```

- WHY: 자연수 `n`을 `0`과 `k + 1`로 *명시적* 케이스 분석. `n = 0`이면 기저 `h0`를 직접 제공.

```
-- 0 케이스 진입 시:
--   ⊢ P 0
-- exact h0로 닫힘.
```

---

```lean
    | k + 1 =>
      apply hS
      intro j hj
      exact ih j (by omega)
```

- WHY: `n = k + 1` 케이스. 강한 귀납 단계 가설 `hS`를 사용.
- USES:
  - `apply hS`: `hS`의 결론 `P (k + 1)`이 현재 목표와 일치. 따라서 `apply` 후 목표가 `hS`의 가설로 바뀜.
  - `intro j hj`: 새 목표 `∀ j, j ≤ k → P j`에서 `j`와 `hj : j ≤ k`를 가정으로 끌어옴.
  - `exact ih j (by omega)`: 귀납 가설 `ih`를 `j`에 적용. `ih`가 요구하는 가설 `j < k + 1`을 `hj : j ≤ k`로부터 `omega`가 도출.

```
-- k + 1 케이스 진입 시:
--   ⊢ P (k + 1)
-- apply hS 후:
--   ⊢ ∀ j, j ≤ k → P j
-- intro j hj 후:
--   j : Nat
--   hj : j ≤ k
--   ⊢ P j
-- exact ih j (by omega) 후:
--   (No goals)
```

**핵심 관찰**. 강한 귀납법이 단순 귀납법(`Nat.strong_induction_on`은 내부적으로 단순 귀납법 위에 구축됨)으로부터 *기계적으로 구성*된다. 이론적 동치성이 Lean 코드 위에 그대로 드러난다.

---

## 코드 7. `secondWins` — 픽업 스틱 게임

**완성 코드 전체**

```lean
def secondWins (n : Nat) : Prop := n % 3 = 0

theorem second_wins_iff (n : Nat) :
    secondWins n ↔ n % 3 = 0 := Iff.rfl

example : secondWins 9 := by decide
example : ¬ secondWins 10 := by decide
example : secondWins 99 := by decide
example : ¬ secondWins 100 := by decide
```

**행별 해설**

```lean
def secondWins (n : Nat) : Prop := n % 3 = 0
```

- WHY: 픽업 스틱 게임에서 *후공이 이기는* 상태를 술어로 정의. 정의 자체는 `n % 3 = 0`이라는 간단한 산술 조건.
- USES: `def ... : Prop := ...`. 명제 타입(`Prop`)으로 정의.

---

```lean
theorem second_wins_iff (n : Nat) :
    secondWins n ↔ n % 3 = 0 := Iff.rfl
```

- WHY: 정의의 *언팩(unfolding)*. `secondWins n`이 정의에 의해 `n % 3 = 0`과 *문자 그대로 같음*을 명시.
- USES: `Iff.rfl` — 동치의 반사성. 양변이 *정의상 같으면* 즉시 닫힘.

```
-- 증명 한 줄로 종료. by 모드 불필요.
```

---

```lean
example : secondWins 9 := by decide
```

- WHY: 수치 인스턴스. `secondWins 9 = (9 % 3 = 0)`. `9 % 3 = 0`은 참.
- USES: `decide` — 결정 가능한 명제를 계산으로 판정. 정의를 펼친 후 `9 % 3 = 0`을 계산하여 참 확인.

```
-- 풀이 흐름:
-- secondWins 9
--   ≡ (정의에 의해) 9 % 3 = 0
--   ≡ (계산에 의해) 0 = 0
--   ≡ True
```

---

```lean
example : ¬ secondWins 10 := by decide
```

- WHY: `¬ secondWins 10 = ¬ (10 % 3 = 0) = ¬ (1 = 0)`. `1 = 0`은 거짓이므로 부정은 참.

---

```lean
example : secondWins 99 := by decide
example : ¬ secondWins 100 := by decide
```

- 같은 패턴의 인스턴스. `99 % 3 = 0`, `100 % 3 = 1`. 각각 참/거짓.

**관찰**. 게임 이론의 *전략 결정*이 자연수 산술의 *모듈로 연산*으로 환원되었다. `decide`가 그 환원을 *기계적으로* 수행. AlphaZero가 강화 학습으로 발견하는 게임 패턴 중 가장 단순한 형태.

---

## 코드 8. `FullBinTree` — 완전 이진 트리 정의

**완성 코드 전체**

```lean
inductive FullBinTree : Type where
  | leaf : FullBinTree
  | node : FullBinTree → FullBinTree → FullBinTree
```

**행별 해설**

```lean
inductive FullBinTree : Type where
```

- WHY: 새로운 *재귀적 데이터 타입*을 선언. `inductive`는 Lean 4의 핵심 키워드.
- 타입 이름: `FullBinTree`. 우주(universe): `Type`(0레벨).

---

```lean
  | leaf : FullBinTree
```

- WHY: 첫 번째 생성자. *잎 노드*. 입력 없이 즉시 `FullBinTree` 값을 만든다.
- 생성된 객체: `FullBinTree.leaf` (또는 줄여서 `.leaf`).

---

```lean
  | node : FullBinTree → FullBinTree → FullBinTree
```

- WHY: 두 번째 생성자. *내부 노드*. 두 자식 트리를 입력으로 받아 새 트리를 반환.
- 생성된 객체: `FullBinTree.node t1 t2` (또는 `.node t1 t2`).

**중요 사실**. `inductive` 선언은 *세 가지를 자동 생성*한다.

1. 타입 자체 (`FullBinTree`).
2. 두 생성자 (`leaf`, `node`).
3. *귀납 원리* (`FullBinTree.rec`, `FullBinTree.recOn`, `FullBinTree.induction`). 이로 인해 `induction t with | leaf => ... | node l r ihl ihr => ...` 패턴이 동작한다.

---

## 코드 9. `internals`, `leaves`

**완성 코드 전체**

```lean
def internals : FullBinTree → Nat
  | .leaf => 0
  | .node l r => 1 + internals l + internals r

def leaves : FullBinTree → Nat
  | .leaf => 1
  | .node l r => leaves l + leaves r
```

**행별 해설**

```lean
def internals : FullBinTree → Nat
  | .leaf => 0
  | .node l r => 1 + internals l + internals r
```

- WHY: 트리의 *내부 노드 수*를 재귀로 계산.
- 두 케이스:
  - `.leaf`: 내부 노드 없음 → `0`.
  - `.node l r`: 자기 자신(1개) + 왼쪽 자식의 내부 노드 수 + 오른쪽 자식의 내부 노드 수.
- 재귀 호출 `internals l`, `internals r`이 *엄격히 작은* 입력에 대해 일어나므로 자동 종결.

---

```lean
def leaves : FullBinTree → Nat
  | .leaf => 1
  | .node l r => leaves l + leaves r
```

- WHY: 트리의 *잎 수*를 재귀로 계산.
- 두 케이스:
  - `.leaf`: 자기 자신이 잎 하나 → `1`.
  - `.node l r`: 왼쪽 잎 수 + 오른쪽 잎 수. 내부 노드는 잎이 아니므로 더하지 않음.

---

## 코드 10. `leaves_eq_internals_succ`

**완성 코드 전체**

```lean
theorem leaves_eq_internals_succ (t : FullBinTree) :
    leaves t = internals t + 1 := by
  induction t with
  | leaf =>
    rfl
  | node l r ihl ihr =>
    show leaves l + leaves r = (1 + internals l + internals r) + 1
    rw [ihl, ihr]
    ring
```

**한 줄씩 분석**

```lean
theorem leaves_eq_internals_succ (t : FullBinTree) :
    leaves t = internals t + 1 := by
```

- WHY: 완전 이진 트리의 핵심 정리 — 잎 수 = 내부 노드 수 + 1.

```
-- AFTER `:= by`:
--   t : FullBinTree
--   ⊢ leaves t = internals t + 1
```

---

```lean
  induction t with
```

- WHY: `t`의 구조에 대한 귀납법. `FullBinTree`의 `inductive` 선언이 자동 생성한 귀납 원리를 사용.
- 두 케이스가 자동으로 분기됨: `leaf`, `node`.

---

```lean
  | leaf =>
    rfl
```

- WHY: `leaf` 케이스.
- 목표 변환: `leaves .leaf = internals .leaf + 1` → `1 = 0 + 1` → `1 = 1`.
- USES: `rfl` — 양변이 *계산상 같으면* 즉시 닫힘. 두 `def`의 정의가 펼쳐지며 계산.

```
-- leaf 케이스 진입 시:
--   ⊢ leaves FullBinTree.leaf = internals FullBinTree.leaf + 1
-- def 의 첫 케이스에 의해:
--   leaves .leaf = 1, internals .leaf = 0
-- 목표가 1 = 0 + 1, 즉 1 = 1로 단순화.
-- rfl 로 즉결.
```

---

```lean
  | node l r ihl ihr =>
```

- WHY: `node` 케이스. *두 자식 트리 각각의 귀납 가설*이 자동 주입.
- 새 변수:
  - `l, r : FullBinTree` — 왼쪽·오른쪽 자식 트리.
  - `ihl : leaves l = internals l + 1` — 왼쪽 자식에 대한 귀납 가설.
  - `ihr : leaves r = internals r + 1` — 오른쪽 자식에 대한 귀납 가설.

```
-- node 케이스 진입 시:
--   l r : FullBinTree
--   ihl : leaves l = internals l + 1
--   ihr : leaves r = internals r + 1
--   ⊢ leaves (.node l r) = internals (.node l r) + 1
```

---

```lean
    show leaves l + leaves r = (1 + internals l + internals r) + 1
```

- WHY: 목표를 *동치인 더 다루기 쉬운 형태*로 변환. `def`의 정의를 명시적으로 펼침.
- USES: `show` — 현재 목표가 *제시한 형태와 정의상 같음*을 명시. 같지 않으면 오류.
- 두 `def`의 두 번째 케이스를 펼치면:
  - `leaves (.node l r) = leaves l + leaves r`
  - `internals (.node l r) = 1 + internals l + internals r`

```
-- AFTER:
--   ⊢ leaves l + leaves r = (1 + internals l + internals r) + 1
```

---

```lean
    rw [ihl, ihr]
```

- WHY: 두 귀납 가설을 *왼쪽으로* 적용. `leaves l → internals l + 1`, `leaves r → internals r + 1`.
- USES: `rw` — 동치를 사용한 다시 쓰기.

```
-- AFTER:
--   ⊢ (internals l + 1) + (internals r + 1) = (1 + internals l + internals r) + 1
```

---

```lean
    ring
```

- WHY: 가환환 항등식 자동 검증. 양변을 전개·정리하여 동일함을 확인.
- 산술 확인: `(internals l + 1) + (internals r + 1) = internals l + internals r + 2 = 1 + internals l + internals r + 1`.

```
-- AFTER:
--   (No goals)
```

---

## 코드 11. `postage_stamp_value` — 우표 함수 호출

**완성 코드 전체**

```lean
example : ∃ a b : Nat, 100 = 4 * a + 5 * b := postage_4_5 100 (by decide)
example : ∃ a b : Nat, 23 = 4 * a + 5 * b := postage_4_5 23 (by decide)
example : ∃ a b : Nat, 40 = 4 * a + 7 * b := postage_4_7 40 (by decide)
```

**행별 해설**

```lean
example : ∃ a b : Nat, 100 = 4 * a + 5 * b := postage_4_5 100 (by decide)
```

- WHY: `postage_4_5`를 `n = 100`, 가설 `12 ≤ 100`(`by decide`로 즉시)으로 호출. 반환값이 정확히 결론을 만족하는 증인.
- USES: 함수 호출의 표준 형태. *정리의 본문은 함수의 반환값*이라는 Lean 4의 원리(Curry-Howard).

```
-- 함수 호출이 다음을 반환한다:
--   ⟨a*, b*, h*⟩  where 100 = 4 * a* + 5 * b*
-- (정확한 a*, b* 값은 재귀 호출의 결과로 결정)
```

`#eval`로 실제 값을 추출할 수도 있다.

```lean
#eval (postage_4_5 100 (by decide)).fst        -- a*
#eval (postage_4_5 100 (by decide)).snd.fst    -- b*
```

(실제로는 `Exists`의 내부 구조 때문에 `.fst`/`.snd`로 직접 추출이 까다롭다. 단지 함수가 *어떤* 증인을 *반환할 수 있는 능력*을 지녔다는 사실이 핵심이다.)

---

```lean
example : ∃ a b : Nat, 23 = 4 * a + 5 * b := postage_4_5 23 (by decide)
example : ∃ a b : Nat, 40 = 4 * a + 7 * b := postage_4_7 40 (by decide)
```

- 같은 패턴의 추가 인스턴스. 임의의 입력에 대해 *증명을 새로 작성할 필요 없이* 함수 호출로 즉결.

**관찰**. 한 번 잘 만든 *구성적 증명*(우표 함수 같은 `def`)은 *수많은 인스턴스의 증명*을 자동 생성한다. 이것이 *함수형 증명 보조기*의 핵심 가치.

---

## 부속 example A. 트리 계산  

**완성 코드 전체**

```lean
def example_tree : FullBinTree := .node .leaf (.node .leaf .leaf)

#eval internals example_tree   -- 2
#eval leaves example_tree      -- 3

example : leaves example_tree = internals example_tree + 1 :=
  leaves_eq_internals_succ example_tree
```

**행별 해설**

```lean
def example_tree : FullBinTree := .node .leaf (.node .leaf .leaf)
```

- WHY: 구체적인 트리를 하나 만들어 본다.
- 구조: 루트의 왼쪽 자식이 잎, 오른쪽 자식이 *서브트리*(두 잎의 부모).
- 그림으로:

```
      node
      /  \
   leaf  node
         /  \
       leaf  leaf
```

- 내부 노드: 루트와 오른쪽 자식의 부모 = 2개.
- 잎: 세 개 (`leaf`가 세 번 등장).

---

```lean
#eval internals example_tree   -- 2
#eval leaves example_tree      -- 3
```

- WHY: `def`의 *실행 가능성*을 확인. InfoView 또는 출력 창에 결과 표시.
- 계산:
  - `internals example_tree = 1 + internals .leaf + internals (.node .leaf .leaf) = 1 + 0 + (1 + 0 + 0) = 2`.
  - `leaves example_tree = leaves .leaf + leaves (.node .leaf .leaf) = 1 + (1 + 1) = 3`.

---

```lean
example : leaves example_tree = internals example_tree + 1 :=
  leaves_eq_internals_succ example_tree
```

- WHY: 정리를 *구체적 트리에 직접 적용*. `3 = 2 + 1`이 성립함을 정리의 한 인스턴스로 즉결.
- USES: 정리 적용의 표준 형태. 본문이 `theorem`이므로 *함수처럼 호출* 가능.

---

## 부속 example B. `Nat.find` 추가  

**완성 코드 전체**

```lean
example : ∃ m, (m % 2 = 0) ∧ ∀ k, (k % 2 = 0) → m ≤ k :=
  let h : ∃ n, n % 2 = 0 := ⟨0, by decide⟩
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩

example : ∃ m, (m ≥ 10 ∧ m.Prime) ∧ ∀ k, (k ≥ 10 ∧ k.Prime) → m ≤ k :=
  let h : ∃ n, n ≥ 10 ∧ n.Prime := ⟨11, by decide, by decide⟩
  ⟨Nat.find h, Nat.find_spec h, fun _ hk => Nat.find_min' h hk⟩
```

코드 5의 패턴을 두 가지 새 술어로 반복.

- 첫째: 가장 작은 짝수. 답은 `0`. (`0 % 2 = 0`이 참.)
- 둘째: 10 이상의 가장 작은 소수. 답은 `11`. (`11`이 소수이고 `10`은 합성수.)

각각 *존재성 증인*을 `⟨...⟩`로 제시한 뒤 `Nat.find`의 세 보조 정리를 꺽쇠로 결합. 정렬 원리의 *재사용 가능한 패턴*.

---

## 부속 example C. 강한 귀납법의 매우 작은  

```lean
example (n : Nat) (h : 2 ≤ n) : ∃ d, 2 ≤ d ∧ d ∣ n :=
  ⟨n, h, dvd_refl n⟩
```

- WHY: "`n ≥ 2`인 모든 `n`이 2 이상의 약수를 가진다." 자기 자신(`n`)이 그런 약수이므로 강한 귀납법이 *필요하지 않다*.
- USES: 꺽쇠로 직접 닫음. 증인 `d = n`, 가설 `h : 2 ≤ n` 그대로 재사용, `dvd_refl n : n ∣ n`.

이 example의 메시지: *항상 강한 귀납법이 필요한 것은 아니다*. 문제 구조를 먼저 보고 적절한 도구를 선택한다.

본격적인 강한 귀납법은 코드 6(`strong_to_weak`)이 담당.

---

## 마무리

본 코드 설명 자료에서 다룬 코드들을 직접 입력하고 InfoView가 일치하는지 확인한다.

- 코드 1, 2 (우표 함수): 재귀 `def` + 패턴 매칭 + `omega`. 강한 귀납법의 *함수형 형식화*.
- 코드 3, 4 (소수 분해): Mathlib 정리의 직접 호출.
- 코드 5 (정렬 원리): `Nat.find` + 두 보조 정리의 꺽쇠 결합.
- 코드 6 (강한 → 단순): `Nat.strong_induction_on` + `match` 패턴.
- 코드 7 (게임 이론): 정의 + `Iff.rfl` + `decide`.
- 코드 8~10 (이진 트리): `inductive` + 재귀 `def` + 구조적 귀납법.

다음 자료(§6.1 또는 5.3)에서 다시 만난다.
