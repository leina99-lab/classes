# 4.4 Lean 4 코드 설명 자료

> 본 자료는 짝꿍 문서 **`ch4_4_lean4_student.md`**(학생 자료)에서 등장한 모든 Lean 4 코드를, 한 줄씩 누를 때마다 화면 오른쪽 **InfoView**가 어떻게 변하는지 정밀하게 기록한 해설서이다.

---

## 표기 약속

- `⊢` 목표.
- `-- BEFORE:` / `-- AFTER:` 실행 전후.
- `-- WHY:` 이유.
- `-- USES:` 사용한 정리·정의.

---

## 코드 1. `CongMod` 정의

**완성 코드**

```lean
def CongMod (m a b : Int) : Prop := ∃ k : Int, a - b = k * m

notation:50 a " ≡ " b " [Z" m "]" => CongMod m a b
```

본 코드는 정리가 아닌 **정의**이다. `Prop`이 결과 타입이므로 명제를 만드는 함수.

`notation`은 표기법 도입. `5 ≡ 12 [Z 7]`이라고 쓰면 Lean 4가 `CongMod 7 5 12`로 해석.

---

## 코드 2. 합동 → 가분성 (방식 1: 직접 구성)

**완성 코드**

```lean
example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
  obtain ⟨k, hk⟩ := h
  refine ⟨k, ?_⟩
  rw [hk, mul_comm]
```

**한 줄씩**

```lean
example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
```

```
-- AFTER `:= by`:
--   a b m : ℤ
--   h : ∃ k, a - b = k * m
--   ⊢ m ∣ (a - b)
```

---

```lean
  obtain ⟨k, hk⟩ := h
```

- WHY: 존재 가정을 증인 `k`와 등식 `hk`로 분해.
- USES: `obtain`.

```
-- AFTER:
--   ..., k : ℤ, hk : a - b = k * m
--   ⊢ m ∣ (a - b)
```

---

```lean
  refine ⟨k, ?_⟩
```

- WHY: `m ∣ (a - b)`의 정의 `∃ k', a - b = m * k'`에 같은 `k`를 증인으로 제시. 등식은 `?_`로 미룸.
- USES: `refine`.

```
-- AFTER:
--   ⊢ a - b = m * k
```

---

```lean
  rw [hk, mul_comm]
```

- WHY: `hk`로 좌변의 `a - b`를 `k * m`으로 다시 쓰고, `mul_comm`으로 `k * m → m * k`.
- USES: `hk`, `mul_comm`.

```
-- AFTER `rw [hk]`:
--   ⊢ k * m = m * k
-- AFTER `rw [mul_comm]`:
--   ⊢ m * k = m * k  →  자동 닫힘
--   (No goals)
```

---

## 코드 3. 합동 → 가분성 (방식 2: dvd_iff_exists_eq_mul_left)

**완성 코드**

```lean
example (a b m : ℤ) (h : ∃ k, a - b = k * m) : m ∣ (a - b) := by
  obtain ⟨k, hk⟩ := h
  rw [dvd_iff_exists_eq_mul_left]
  exact ⟨k, hk⟩
```

`dvd_iff_exists_eq_mul_left`의 진술:

```
dvd_iff_exists_eq_mul_left : a ∣ b ↔ ∃ k, b = k * a
```

`rw`로 목표 `m ∣ (a - b)`를 `∃ k, (a - b) = k * m` 형태로 다시 쓰면, 우리 가정 `hk`와 정확히 같은 모양이 된다. `exact ⟨k, hk⟩`로 즉결.

---

## 코드 4. `CongMod_refl` - 반사성

**완성 코드**

```lean
theorem CongMod_refl (m a : Int) :
    CongMod m a a := by
  unfold CongMod
  use 0
  ring
```

```
-- AFTER `:= by`:
--   m a : Int
--   ⊢ CongMod m a a
```

---

```lean
  unfold CongMod
```

- WHY: 정의를 펼쳐 `∃ k, ...` 형태로.
- USES: `unfold`.

```
-- AFTER:
--   ⊢ ∃ k : Int, a - a = k * m
```

---

```lean
  use 0
```

- WHY: 증인 `k = 0` 제시.

```
-- AFTER:
--   ⊢ a - a = 0 * m
```

---

```lean
  ring
```

`a - a = 0`이고 `0 * m = 0`이므로 등식. `ring`이 즉결.

```
-- AFTER:
--   (No goals)
```

---

## 코드 5. `CongMod_symm` - 대칭성

**완성 코드**

```lean
theorem CongMod_symm (m a b : Int)
    (h : CongMod m a b) :
    CongMod m b a := by
  unfold CongMod at h ⊢
  obtain ⟨k, hk⟩ := h
  use -k
  rw [neg_mul]
  rw [← hk]
  ring
```

**한 줄씩**

```lean
  unfold CongMod at h ⊢
```

- WHY: `h`와 목표 양쪽 모두에서 정의 펼치기.

```
-- AFTER:
--   h : ∃ k, a - b = k * m
--   ⊢ ∃ k, b - a = k * m
```

---

```lean
  obtain ⟨k, hk⟩ := h
```

```
-- AFTER:
--   k : Int, hk : a - b = k * m
--   ⊢ ∃ k, b - a = k * m
```

---

```lean
  use -k
```

```
-- AFTER:
--   ⊢ b - a = -k * m
```

---

```lean
  rw [neg_mul]
```

- USES: `neg_mul : -a * b = -(a * b)`.

```
-- AFTER:
--   ⊢ b - a = -(k * m)
```

---

```lean
  rw [← hk]
```

- WHY: `hk : a - b = k * m`을 **역방향**(`←`)으로 적용. `k * m` 패턴이 목표에 있으면 `a - b`로 치환.

```
-- AFTER:
--   ⊢ b - a = -(a - b)
```

---

```lean
  ring
```

`b - a = -(a - b)`는 자명한 산술 항등식.

```
-- AFTER:
--   (No goals)
```

---

## 코드 6. `CongMod_trans` - 추이성

**완성 코드**

```lean
theorem CongMod_trans (m a b c : Int)
    (h1 : CongMod m a b)
    (h2 : CongMod m b c) :
    CongMod m a c := by
  unfold CongMod at h1 h2 ⊢
  obtain ⟨k1, hk1⟩ := h1
  obtain ⟨k2, hk2⟩ := h2
  use k1 + k2
  rw [show a - c = (a - b) + (b - c) by ring]
  rw [hk1, hk2]
  ring
```

`unfold ... at h1 h2 ⊢`는 세 위치(두 가정 + 목표) 모두에서 정의 펼치기.

`use k1 + k2`로 증인 제시 후 목표는 `a - c = (k1 + k2) * m`.

**핵심 줄**: `rw [show a - c = (a - b) + (b - c) by ring]`. 인라인 증명으로 `a - c = (a - b) + (b - c)`를 만들어 적용. 이로써 목표가 `(a - b) + (b - c) = (k1 + k2) * m`이 된다.

`rw [hk1, hk2]`: 두 가설을 순서대로 적용. `a - b → k1 * m`, `b - c → k2 * m`. 결과: `k1 * m + k2 * m = (k1 + k2) * m`.

`ring`이 분배 법칙으로 닫음.

---

## 코드 7. `inverse_exists` - 모듈러 역원의 존재

**완성 코드** (학생 자료 §7 참조)

본 자료에서 가장 흥미로운 코드. 부분별로 분석.

### 부분 1. 베주 계수 도입

```lean
  set s := Int.gcdA a m
  set t := Int.gcdB a m
```

`Int.gcdA`, `Int.gcdB`는 Mathlib의 함수. `gcd(a, m) = a * gcdA + m * gcdB`를 만드는 정수 계수를 미리 계산해 둔 것.

### 부분 2. 베주 항등식 만들기

```lean
  have h_bezout : (1 : Int) = a * s + m * t := by
    have h := Int.gcd_eq_gcd_ab a m
    rw [h_cop] at h
    exact_mod_cast h
```

`Int.gcd_eq_gcd_ab`의 진술:
```
Int.gcd_eq_gcd_ab : ∀ (a b : ℤ), ↑(Int.gcd a b) = a * Int.gcdA a b + b * Int.gcdB a b
```

좌변이 `↑(Int.gcd a b)`(자연수의 정수 캐스팅)인 점에 주목.

- `have h := Int.gcd_eq_gcd_ab a m`: `h : ↑(Int.gcd a m) = a * s + m * t`.
- `rw [h_cop] at h`: `h_cop : Int.gcd a m = 1`을 `h`에 적용. 결과: `h : ↑(1 : ℕ) = a * s + m * t`.
- `exact_mod_cast h`: 캐스팅을 자동 처리. `↑(1 : ℕ) = (1 : Int)`이므로 목표 `(1 : Int) = a * s + m * t`와 일치.

### 부분 3. 두 단계의 증인 제시

```lean
  use s
  unfold CongMod
  use -t
```

외부 결론 `∃ ā, CongMod m (ā * a) 1`의 증인 `s` 제시 → 목표가 `CongMod m (s * a) 1`로 변환 → `unfold CongMod`로 내부 정의 풀기 → 내부 증인 `-t` 제시.

```
-- AFTER `use -t`:
--   ⊢ s * a - 1 = -t * m
```

### 부분 4. 마지막 등식

```lean
  have h1 : s * a - 1 = -(m * t) := by
    rw [h_bezout]
    ring
  rw [h1]
  ring
```

`have h1` 안: `h_bezout : 1 = a * s + m * t`를 적용해 `s * a - 1` 안의 `1`을 풀어쓰면 `s * a - (a * s + m * t)`, 정리하면 `-(m * t)`. `ring`이 자동 처리.

그 다음 `rw [h1]`로 목표를 `-(m * t) = -t * m`으로 다시 쓰고, `ring`으로 부호·곱셈 순서를 정리해 닫음.

---

## 코드 8. `inverse_unique` - 모듈러 역원의 유일성

**완성 코드**

```lean
theorem inverse_unique
    (a m a1 b1 : Int) (_hm : 1 < m)
    (_h_cop : Int.gcd a m = 1)
    (h1 : CongMod m (a1 * a) 1)
    (h2 : CongMod m (b1 * a) 1) :
    CongMod m a1 b1 := by
  obtain ⟨k1, hk1⟩ := h1
  obtain ⟨k2, hk2⟩ := h2
  refine ⟨b1 * k1 - a1 * k2, ?_⟩
  linear_combination b1 * hk1 - a1 * hk2
```

핵심 줄은 마지막 `linear_combination b1 * hk1 - a1 * hk2`.

이 전술이 검증하는 것:
- `hk1 : a1 * a - 1 = k1 * m`
- `hk2 : b1 * a - 1 = k2 * m`
- `b1 * hk1 - a1 * hk2`이 만드는 등식: `b1 * (a1 * a - 1) - a1 * (b1 * a - 1) = b1 * (k1 * m) - a1 * (k2 * m)`.
- 좌변 정리: `b1*a1*a - b1 - a1*b1*a + a1 = a1 - b1`.
- 우변 정리: `(b1 * k1 - a1 * k2) * m`.
- 결과: `a1 - b1 = (b1 * k1 - a1 * k2) * m`. 우리 목표 그 자체.

`linear_combination`은 이 모든 대수 결합을 자동 검증.

**`linear_combination`의 사용 직관**: 가설 등식들 `h_i : L_i = R_i`와 계수 `c_i`에 대해, `linear_combination ∑ c_i * h_i`라고 쓰면 "양변에 `∑ c_i * (L_i - R_i) = 0`을 더하면 목표가 되는가"를 검증한다.

---

## 코드 9. ZMod 7에서의 역원 검증

```lean
example : (3 : ZMod 7) * 5 = 1 := by decide
```

`ZMod 7`에서 `3 * 5 = 15 mod 7 = 1`. `decide`가 직접 계산.

---

## 코드 10. ZMod 7에서 선형 합동의 가해성

**완성 코드**

```lean
example (a b : ZMod 7) (ha : a ≠ 0) :
    ∃ x : ZMod 7, a * x = b := by
  haveI : Fact (Nat.Prime 7) := ⟨by decide⟩
  refine ⟨a⁻¹ * b, ?_⟩
  field_simp
```

**한 줄씩**

```lean
  haveI : Fact (Nat.Prime 7) := ⟨by decide⟩
```

- WHY: 후속 `field_simp`이 "`ZMod 7`이 체"라는 사실을 활용하려면 `Fact (Nat.Prime 7)` 인스턴스가 typeclass 시스템에 있어야 함.
- USES: `haveI`(`have` + 인스턴스 주입). `⟨by decide⟩`는 `Fact` 구조체의 `out` 필드에 `Nat.Prime 7`의 증명을 넣은 것.

```
-- AFTER:
--   ..., (인스턴스 추가)
```

---

```lean
  refine ⟨a⁻¹ * b, ?_⟩
```

- WHY: 증인 `x = a⁻¹ * b` 제시.

```
-- AFTER:
--   ⊢ a * (a⁻¹ * b) = b
```

---

```lean
  field_simp
```

- WHY: `a * a⁻¹ = 1`을 적용해 좌변 정리. `1 * b = b`. 양변 일치.
- USES: `field_simp`.

```
-- AFTER:
--   (No goals)
```

---

## 코드 11. 중국 잉여 정리 (CRT)

```lean
example (m n : ℕ) (hmn : Nat.Coprime m n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n :=
  ZMod.chineseRemainder hmn
```

`ZMod.chineseRemainder`를 한 줄로 호출. 인수는 서로소성 가정.

`≃+*`은 환 동형 사상의 기호. 환의 덧셈·곱셈 구조를 보존하는 양방향 일대일 대응.

---

## 코드 12. 손자의 정리 사례

```lean
example : (23 : ZMod 105).val % 3 = 2 ∧
          (23 : ZMod 105).val % 5 = 3 ∧
          (23 : ZMod 105).val % 7 = 2 := by
  refine ⟨?_, ?_, ?_⟩ <;> decide
```

`refine ⟨?_, ?_, ?_⟩`로 세 합접의 결론을 세 자리표시로 분해.

`<;> decide`는 "모든 부목표에 동시에 `decide` 적용". 세 단순 계산이 한 줄에 묶임.

`.val`은 `ZMod n`의 원소를 자연수로 변환하는 메서드. `(23 : ZMod 105).val`은 `ZMod 105`에서의 `23`을 자연수 `23`으로 표현.

---

## 코드 13. 페르마 소정리

```lean
example (p : ℕ) [Fact p.Prime] (a : ZMod p) (ha : a ≠ 0) :
    a ^ (p - 1) = 1 :=
  ZMod.pow_card_sub_one_eq_one ha
```

Mathlib에 정확한 형태로 들어 있어 호출만 한다. `[Fact p.Prime]`은 typeclass 인수로, 정리가 호출되는 문맥에서 자동으로 채워진다.

---

## 코드 14. 페르마 소정리의 따름정리 a^p = a

**완성 코드**

```lean
example (p : ℕ) [Fact p.Prime] (a : ZMod p) : a ^ p = a := by
  have hpPrime : Nat.Prime p := Fact.out
  by_cases ha : a = 0
  · rw [ha, zero_pow hpPrime.pos.ne']
  · have h : a ^ (p - 1) = 1 := ZMod.pow_card_sub_one_eq_one ha
    have hp : p = (p - 1) + 1 := (Nat.sub_add_cancel hpPrime.pos).symm
    calc
      a ^ p
          = a ^ ((p - 1) + 1) := by rw [← hp]
        _ = a ^ (p - 1) * a   := pow_succ a (p - 1)
        _ = 1 * a             := by rw [h]
        _ = a                 := one_mul a
```

**부분별 분석**

```lean
  have hpPrime : Nat.Prime p := Fact.out
```

- WHY: `[Fact p.Prime]` 인스턴스에서 내용물 `p.Prime`을 명시적 가정으로 추출.
- USES: `Fact.out`. 인스턴스 객체에서 안쪽 사실을 꺼내는 표준 메서드.

---

```lean
  by_cases ha : a = 0
```

- WHY: 명제 `a = 0`과 그 부정으로 분기.
- USES: `by_cases`. 모든 명제에 대해 LEM(law of excluded middle)으로 분기 처리.

두 가지가 만들어진다. 각각 `·`(점)으로 시작.

---

**경우 1: `a = 0`**

```lean
  · rw [ha, zero_pow hpPrime.pos.ne']
```

- `rw [ha]`: 목표 안의 `a`를 `0`으로 치환. 목표: `0 ^ p = 0`.
- `rw [zero_pow hpPrime.pos.ne']`: `zero_pow`의 진술은 `n ≠ 0 → (0 : α)^n = 0`. `hpPrime.pos`는 `0 < p`이고 `.ne'`은 그것을 `p ≠ 0`으로 변환. 적용 결과 목표가 `0 = 0`이 되어 자동 닫힘.

---

**경우 2: `a ≠ 0`**

```lean
  · have h : a ^ (p - 1) = 1 := ZMod.pow_card_sub_one_eq_one ha
```

페르마 소정리 적용.

---

```lean
    have hp : p = (p - 1) + 1 := (Nat.sub_add_cancel hpPrime.pos).symm
```

- `Nat.sub_add_cancel`의 진술: `k ≤ n → n - k + k = n`.
- 우리는 `Nat.sub_add_cancel hpPrime.pos`로 `p - 1 + 1 = p`를 얻고, `.symm`으로 좌우를 뒤집어 `p = (p - 1) + 1`.

---

```lean
    calc
      a ^ p
          = a ^ ((p - 1) + 1) := by rw [← hp]
        _ = a ^ (p - 1) * a   := pow_succ a (p - 1)
        _ = 1 * a             := by rw [h]
        _ = a                 := one_mul a
```

`calc` 블록의 네 단계.

1. `a^p = a^((p-1) + 1)`: `hp`를 역방향(`←`)으로 적용.
2. `= a^(p-1) * a`: `pow_succ`의 진술 `a^(n+1) = a^n * a` 직접 호출.
3. `= 1 * a`: `h : a^(p-1) = 1`을 적용.
4. `= a`: `one_mul a : 1 * a = a` 직접 호출.

**4단계 사슬의 패턴**: `calc`의 각 단계가 한 줄짜리 보조 정리 또는 인라인 `by rw [...]`로 구성된다. 학습자가 종이에 적는 "그래서 = 그래서 = 그래서 = 답"의 사슬을 그대로 옮긴 형태.

---

## 마무리

본 코드 설명 자료에서 다룬 14개 코드를 직접 입력하고 InfoView가 일치하는지 확인한다.

§4.4까지가 4장의 핵심이다. §4.5·§4.6의 응용 자료에서 다시 만난다.
