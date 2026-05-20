# 5.1 Lean 4 코드 설명 자료

> 본 자료는 짝꿍 문서 **`ch5_1_lean4_student.md`**(학생 자료)에서 등장한 모든 Lean 4 코드를, 한 줄씩 누를 때마다 화면 오른쪽 **InfoView**(인포뷰)가 어떻게 변하는지 정밀하게 기록한 해설서이다. 학생 자료가 "큰 그림"을 잡아 준다면, 본 문서는 "한 줄을 누르면 무엇이 변하는가"를 현미경처럼 관찰한다.
>
> 권장 사용법은 다음과 같다. 학생 자료에서 한 코드 블록을 만나면, 본 문서의 같은 코드 블록 항목을 옆에 펴고, 자신의 Lean 4 편집기에서 그 코드를 직접 입력해 가며 본 문서의 InfoView 기록과 자기 편집기의 InfoView를 한 줄씩 비교한다. 차이가 보이면 그 자리에서 멈추고 원인을 추적한다.

---

## 표기 약속

본 문서에서 사용하는 표기를 미리 정리한다.

`⊢` 기호는 **목표**(goal, 증명해야 할 명제)를 가리키는 표시이다. Lean 4 InfoView에서 그대로 사용한다.

`-- BEFORE:` 다음에 적힌 내용은 그 줄을 실행하기 **직전**의 InfoView 상태이다.

`-- AFTER:` 다음에 적힌 내용은 그 줄을 실행한 **직후**의 InfoView 상태이다.

`-- WHY:` 다음에 적힌 내용은 그 줄에서 그 전술 또는 표현을 고른 이유이다.

`-- USES:` 다음에 적힌 내용은 그 줄에서 사용한 보조 정리의 이름과 진술이다.

InfoView 상태 표기는 가독성을 위해 압축한다. 가정 한 줄에 모두 적되, `,`로 구분한다. 목표는 별도 줄에 `⊢`를 앞세워 쓴다.

---

## 코드 1. `zero_add_nat` - 모든 자연수 `n`에 대해 `0 + n = n`

**완성 코드 전체**

```lean
import Mathlib

theorem zero_add_nat (n : Nat) : 0 + n = n := by
  induction n with
  | zero =>
    rfl
  | succ k ih =>
    rw [Nat.add_succ]
    rw [ih]
```

**한 줄씩 분석**

먼저 정리 선언부.

```lean
theorem zero_add_nat (n : Nat) : 0 + n = n := by
```

이 한 줄은 다음을 한다.

- 새 정리의 이름을 `zero_add_nat`으로 지정한다.
- 인수로 자연수 한 개 `n : Nat`을 받는다.
- 진술은 `0 + n = n`이다.
- `:= by` 다음부터 증명을 적는다는 신호이다.

이 줄을 입력한 직후, 커서를 다음 줄로 옮기면 InfoView에 다음이 보인다.

```
-- AFTER `:= by`:
--   n : Nat
--   ⊢ 0 + n = n
```

`n : Nat`은 가정에 들어와 있는 유일한 변수이다. `⊢ 0 + n = n`이 현재 목표이다.

---

다음 줄.

```lean
  induction n with
```

이 한 줄은 다음을 한다.

- 변수 `n`에 대해 귀납법을 시작한다.
- 자연수 `Nat`은 `zero`와 `succ` 두 생성자로 정의되어 있으므로, 두 갈래가 만들어진다.

이 줄을 누르면 InfoView가 두 개의 목표로 갈라진다.

```
-- AFTER `induction n with`:
--   case zero
--     ⊢ 0 + 0 = 0
--   case succ
--     k : Nat
--     ih : 0 + k = k
--     ⊢ 0 + (k + 1) = k + 1
```

두 번째 목표(case succ)에서 우리에게 새 가정 `ih : 0 + k = k`가 자동으로 주어진 것에 주목한다. 이것이 **귀납 가설**이다. 우리는 이 `ih`를 손에 쥐고 두 번째 목표를 닫으러 갈 것이다.

---

`| zero =>` 갈래로 들어간다.

```lean
  | zero =>
```

이 한 줄은 "지금부터 `case zero` 갈래의 증명을 쓴다"는 신호이다. 커서가 이 줄에 있을 때 InfoView는 다음과 같다.

```
-- BEFORE the proof of zero case:
--   ⊢ 0 + 0 = 0
```

기저 단계의 목표가 분명히 보인다.

---

다음 줄.

```lean
    rfl
```

- WHY: 양변이 정의상 똑같기 때문이다. Lean 4의 자연수 덧셈 정의에 따라 `0 + 0`은 즉시 `0`과 같다.
- USES: `rfl`(반사성, reflexivity). 양변이 정의상 같을 때만 통과하는 가장 단순한 전술이다.

이 줄을 누르면 `case zero` 갈래가 닫힌다. InfoView의 `case zero`가 사라지고, `case succ`만 남는다.

```
-- AFTER `rfl`:
--   case succ
--     k : Nat
--     ih : 0 + k = k
--     ⊢ 0 + (k + 1) = k + 1
```

---

`| succ k ih =>` 갈래로 들어간다.

```lean
  | succ k ih =>
```

이 한 줄은 "지금부터 `case succ` 갈래의 증명을 쓴다"는 신호이다. `k`와 `ih`라는 이름이 가정으로 손에 들어온다.

```
-- BEFORE the proof of succ case:
--   k : Nat
--   ih : 0 + k = k
--   ⊢ 0 + (k + 1) = k + 1
```

---

다음 줄.

```lean
    rw [Nat.add_succ]
```

- WHY: 목표 안의 `0 + (k + 1)`을 정의적 형태인 `(0 + k) + 1`로 풀어 헤치기 위해서이다. 이 전개를 거쳐야 그 안의 `0 + k`에 `ih`를 적용할 수 있다.
- USES: `Nat.add_succ : ∀ (n m : Nat), n + (m + 1) = (n + m) + 1`. 두 번째 인수의 `+1`을 바깥으로 빼내는 정리이다.

`rw`는 등식을 **좌변 → 우변** 방향으로 적용한다. 즉 `Nat.add_succ`의 좌변 `n + (m + 1)` 패턴을 목표에서 찾아, 우변 `(n + m) + 1`로 바꾼다. 우리 목표 안에는 `0 + (k + 1)` 형태가 있으므로(`n = 0`, `m = k`로 맞아 떨어진다), 이것이 `(0 + k) + 1`로 바뀐다.

```
-- AFTER `rw [Nat.add_succ]`:
--   k : Nat
--   ih : 0 + k = k
--   ⊢ (0 + k) + 1 = k + 1
```

이제 목표 좌변에 `0 + k`라는 덩어리가 노출되어 있다. 이 덩어리가 다음 줄에서 `ih`의 활용 자리이다.

---

다음 줄.

```lean
    rw [ih]
```

- WHY: 목표 안의 `0 + k` 덩어리를 `k`로 치환하기 위해서이다. `ih`는 `0 + k = k`라는 등식이므로 이를 적용하면 정확히 그 치환이 일어난다.
- USES: `ih : 0 + k = k`. 가정 목록에서 우리가 직접 호명한다.

```
-- AFTER `rw [ih]`:
--   k : Nat
--   ih : 0 + k = k
--   ⊢ k + 1 = k + 1
```

양변이 글자 그대로 같다. `rw`는 자기 작업을 마친 후 목표가 `a = a` 꼴이 되면 자동으로 `rfl`을 시도해 닫는다. 따라서 `case succ` 갈래도 닫힌다. 모든 갈래가 닫혔으므로 정리 전체의 증명이 완성된다.

InfoView에는 다음이 보인다.

```
-- 모든 목표 닫힘 (No goals).
```

---

**전체 흐름 정리**

| 줄 | 액션 | 목표의 변화 |
|---|---|---|
| `induction n with` | 두 갈래 생성 | `⊢ 0 + n = n` → 두 갈래 |
| `\| zero => rfl` | 기저 즉결 | `⊢ 0 + 0 = 0` → 닫힘 |
| `\| succ k ih =>` | 귀납 진입 | `ih : 0 + k = k`가 가정에 추가 |
| `rw [Nat.add_succ]` | 정의 풀이 | `⊢ 0 + (k + 1) = k + 1` → `⊢ (0 + k) + 1 = k + 1` |
| `rw [ih]` | IH 사용 | `⊢ (0 + k) + 1 = k + 1` → `⊢ k + 1 = k + 1` → 닫힘 |

종이 증명에서 "여기서 IH를 사용했습니다"라고 손가락으로 짚는 그 단 한 줄이, Lean 4 코드에서는 `rw [ih]`이다. 손가락과 코드가 정확히 같은 일을 한다.

---

## 코드 2. `add_zero_nat` - 모든 자연수 `n`에 대해 `n + 0 = n`

**완성 코드 전체**

```lean
import Mathlib

theorem add_zero_nat (n : Nat) : n + 0 = n := by
  induction n with
  | zero =>
    rfl
  | succ k ih =>
    rw [Nat.succ_add]
    rw [ih]
```

**구조** 코드 1과 거울 쌍둥이이다. 유일한 차이는 `rw`의 인수가 `Nat.add_succ`에서 `Nat.succ_add`로 바뀐다는 점이다.

---

**한 줄씩 분석 (코드 1과 다른 부분만 강조)**

```lean
theorem add_zero_nat (n : Nat) : n + 0 = n := by
  induction n with
```

다음 갈래 분해와 `| zero =>` 갈래 처리는 코드 1과 같다.

```
-- AFTER `induction n with`, case succ:
--   k : Nat
--   ih : k + 0 = k
--   ⊢ (k + 1) + 0 = k + 1
```

`ih`의 진술이 코드 1과 다르다는 점에 주의한다. 이번에는 `ih : k + 0 = k`이다.

---

```lean
    rw [Nat.succ_add]
```

- WHY: 목표 안의 `(k + 1) + 0`을 `(k + 0) + 1`로 풀어 헤치기 위해서이다. 이번에는 **첫 번째 인수**의 `+1`을 바깥으로 빼야 하므로 `Nat.succ_add`를 쓴다.
- USES: `Nat.succ_add : ∀ (n m : Nat), (n + 1) + m = (n + m) + 1`. 첫 번째 인수의 `+1`을 바깥으로 빼내는 정리이다.

```
-- AFTER `rw [Nat.succ_add]`:
--   k : Nat
--   ih : k + 0 = k
--   ⊢ (k + 0) + 1 = k + 1
```

목표 안에 `k + 0` 덩어리가 노출되어, `ih`의 활용 자리가 만들어졌다.

---

```lean
    rw [ih]
```

`ih : k + 0 = k`로 좌변 안의 `k + 0`을 `k`로 치환한다.

```
-- AFTER `rw [ih]`:
--   ⊢ k + 1 = k + 1
-- 자동으로 닫힘 (No goals).
```

---

**`Nat.add_succ`와 `Nat.succ_add`의 짝짓기**

본 자료에서 자주 등장할 두 보조 정리이다. 두 이름의 의미를 한 번 더 짚어 둔다.

```
Nat.add_succ : ∀ (n m : Nat), n + (m + 1) = (n + m) + 1
                              ^^^^^^^^^^^^
                              두 번째 인수의 (m + 1)을 바깥으로 빼냄

Nat.succ_add : ∀ (n m : Nat), (n + 1) + m = (n + m) + 1
                              ^^^^^^^^^^^^^
                              첫 번째 인수의 (n + 1)을 바깥으로 빼냄
```

이름의 작명 규칙은 다음과 같다. `Nat.X_Y`라는 이름에서 `X`는 "수정되는 위치", `Y`는 "수정되는 형태"이다. `add_succ`는 "덧셈의 두 번째 자리(`add` 다음)에 `succ`이 있을 때"이고, `succ_add`는 "덧셈의 첫 번째 자리(`add` 앞)에 `succ`이 있을 때"이다. 이 규칙을 익혀 두면 비슷한 이름의 정리들을 검색 없이도 짐작할 수 있다.

---
## 코드 3. `sum_odd_eq_sq` - 홀수의 합

**완성 코드 전체**

```lean
import Mathlib

open Finset

theorem sum_odd_eq_sq (n : Nat) :
    (∑ k ∈ Finset.range n, (2 * k + 1)) = n ^ 2 := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [ih]
    ring
```

**한 줄씩 분석**

```lean
open Finset
```

이 한 줄은 `Finset` 네임스페이스를 연다. `Finset.range`, `Finset.sum_range_succ` 같은 이름을 `range`, `sum_range_succ`처럼 짧게 쓸 수 있게 된다. 본 자료의 코드에서는 가독성을 위해 정리 이름에 `Finset.` 접두어를 그대로 두지만, 짧게 쓰는 것도 허용된다.

---

```lean
theorem sum_odd_eq_sq (n : Nat) :
    (∑ k ∈ Finset.range n, (2 * k + 1)) = n ^ 2 := by
```

정리 선언. 진술이 두 줄에 걸쳐 있다. Lean 4는 들여쓰기와 괄호 균형이 맞으면 여러 줄에 걸친 진술을 허용한다.

```
-- AFTER `:= by`:
--   n : Nat
--   ⊢ (∑ k ∈ Finset.range n, (2 * k + 1)) = n ^ 2
```

---

```lean
  induction n with
```

```
-- AFTER:
--   case zero
--     ⊢ (∑ k ∈ Finset.range 0, (2 * k + 1)) = 0 ^ 2
--   case succ
--     k : Nat
--     ih : (∑ j ∈ Finset.range k, (2 * j + 1)) = k ^ 2
--     ⊢ (∑ j ∈ Finset.range (k + 1), (2 * j + 1)) = (k + 1) ^ 2
```

귀납 단계의 `ih`가 합 공식 형태로 깨끗이 들어와 있다. 합 안의 변수 이름은 본문의 `k`와 충돌하지 않도록 Lean 4가 자동으로 `j`로 바꾸어 표시한다.

---

```lean
  | zero =>
    simp
```

- WHY: `Finset.range 0`은 공집합이다. 공집합 위에서의 합은 0이다. 또한 `0 ^ 2 = 0`이다. 따라서 양변이 모두 0이 되어 등식이 성립한다.
- USES: `simp`이 자동으로 `Finset.sum_range_zero`(빈 합은 0), `pow_zero` 또는 `Nat.zero_pow` 같은 기본 정리들을 모아 닫는다.

`simp`을 한정적으로 허용하는 이유는 §2에서 적은 바와 같다. 빈 합 처리는 너무 빈번해서 `simp`이 자동 처리하도록 두는 것이 코드를 깔끔하게 한다.

```
-- AFTER `simp`:
--   (case zero 닫힘)
```

---

```lean
  | succ k ih =>
    rw [Finset.sum_range_succ]
```

- WHY: 합의 마지막 항을 분리하기 위해서이다. 종이 증명에서 "1+3+...+(2k+1) = (1+3+...+(2k-1)) + (2k+1)"이라고 적던 그 단계이다.
- USES: `Finset.sum_range_succ : ∀ (f : Nat → α) (n : Nat), (∑ k ∈ Finset.range (n + 1), f k) = (∑ k ∈ Finset.range n, f k) + f n`.

```
-- AFTER `rw [Finset.sum_range_succ]`:
--   k : Nat
--   ih : (∑ j ∈ Finset.range k, (2 * j + 1)) = k ^ 2
--   ⊢ (∑ j ∈ Finset.range k, (2 * j + 1)) + (2 * k + 1) = (k + 1) ^ 2
```

목표 좌변에 `(∑ j ∈ Finset.range k, (2 * j + 1))`라는 덩어리가 노출되었다. `ih`의 좌변과 정확히 일치한다.

---

```lean
    rw [ih]
```

- WHY: 좌변 안의 합 덩어리를 `ih`의 우변 `k ^ 2`로 치환한다.
- USES: `ih : (∑ j ∈ Finset.range k, (2 * j + 1)) = k ^ 2`.

```
-- AFTER `rw [ih]`:
--   k : Nat
--   ih : (∑ j ∈ Finset.range k, (2 * j + 1)) = k ^ 2
--   ⊢ k ^ 2 + (2 * k + 1) = (k + 1) ^ 2
```

남은 등식은 순수한 다항식 항등식이다. `k^2 + 2k + 1 = (k+1)^2`. 완전제곱 공식 그 자체이다.

---

```lean
    ring
```

- WHY: 다항식 항등식을 자동으로 검증하기 위해서이다.
- USES: `ring` 전술은 가환환 위에서의 다항식 항등식을 표준 형태로 정규화해서 비교한다. `(k+1)^2 = k^2 + 2k + 1`은 자명한 정규화 결과이다.

```
-- AFTER `ring`:
--   (case succ 닫힘)
--   (No goals)
```

---

**전체 흐름 정리**

| 줄 | 액션 | 목표의 변화 |
|---|---|---|
| `induction n with` | 두 갈래 생성 | 합 공식 → 두 갈래 |
| `\| zero => simp` | 빈 합 = 0 = 0² | 자동 닫힘 |
| `rw [Finset.sum_range_succ]` | 마지막 항 분리 | `⊢ (합) = (k+1)²` → `⊢ (합) + (2k+1) = (k+1)²` |
| `rw [ih]` | IH로 합을 k²로 치환 | `⊢ (합) + (2k+1) = (k+1)²` → `⊢ k² + (2k+1) = (k+1)²` |
| `ring` | 다항식 항등식 검증 | 닫힘 |

---

## 코드 4. `two_mul_sum_range` - 가우스의 합

**완성 코드 전체**

```lean
import Mathlib

open Finset

theorem two_mul_sum_range (n : Nat) :
    2 * (∑ k ∈ Finset.range (n + 1), k) = n * (n + 1) := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    have h := ih
    linarith [h]
```

**한 줄씩 분석 (코드 3과 다른 부분에 집중)**

```lean
theorem two_mul_sum_range (n : Nat) :
    2 * (∑ k ∈ Finset.range (n + 1), k) = n * (n + 1) := by
```

진술의 좌변이 `2 * (...)`로 시작한다. 양변에 2를 곱한 형태로 진술한 이유는 학생 자료 §8에서 적은 바와 같이 자연수 나눗셈을 피하기 위해서이다.

```
-- AFTER `:= by`:
--   n : Nat
--   ⊢ 2 * (∑ k ∈ Finset.range (n + 1), k) = n * (n + 1)
```

또 한 가지 다른 점은 합의 범위가 `Finset.range (n + 1)`이라는 것이다. 즉 합의 인덱스가 `0`부터 `n`까지(`n+1`개 항) 돈다. 종이의 "0+1+2+...+n"과 정확히 일치한다.

---

```lean
  induction n with
```

```
-- AFTER:
--   case zero
--     ⊢ 2 * (∑ k ∈ Finset.range 1, k) = 0 * (0 + 1)
--   case succ
--     k : Nat
--     ih : 2 * (∑ j ∈ Finset.range (k + 1), j) = k * (k + 1)
--     ⊢ 2 * (∑ j ∈ Finset.range (k + 2), j) = (k + 1) * (k + 1 + 1)
```

- `case zero`의 좌변: `2 * (∑ k ∈ Finset.range 1, k)`. `Finset.range 1 = {0}`이고 그 위에서 `k`의 합은 `0`이다. 따라서 좌변은 `2 * 0 = 0`. 우변은 `0 * 1 = 0`. 등식 성립.
- `case succ`의 목표: 범위가 `Finset.range (k + 2)`가 되어 있다는 점에 주의한다. 이는 학생 자료의 진술에서 `n`을 `k+1`로 치환했을 때 자동으로 생기는 변화이다.

---

```lean
  | zero =>
    simp
```

빈 합 또는 한 항짜리 합과 우변이 모두 0인 경우. `simp`이 자동 처리.

---

```lean
  | succ k ih =>
    rw [Finset.sum_range_succ]
```

목표 좌변의 `∑ j ∈ Finset.range (k + 2), j`에서 마지막 항을 분리한다. 분리되는 마지막 항은 `f (k + 1) = k + 1`이다(여기서 `f`는 항등 함수 `j ↦ j`이므로 `f n = n`).

`Finset.sum_range_succ`의 `n` 자리에 우리 경우의 `k + 1`이 들어간다. 즉 정리의 진술 `∑ k ∈ Finset.range (n + 1), f k = ∑ k ∈ Finset.range n, f k + f n`에서 `n = k + 1`, `f j = j`로 맞아 떨어진다.

```
-- AFTER `rw [Finset.sum_range_succ]`:
--   k : Nat
--   ih : 2 * (∑ j ∈ Finset.range (k + 1), j) = k * (k + 1)
--   ⊢ 2 * ((∑ j ∈ Finset.range (k + 1), j) + (k + 1)) = (k + 1) * (k + 1 + 1)
```

좌변에 `(∑ j ∈ Finset.range (k + 1), j) + (k + 1)`이라는 두 항의 합이 노출되었다. 이 안에는 `ih`의 좌변 `(∑ j ∈ Finset.range (k + 1), j)`가 그대로 들어 있다.

---

```lean
    have h := ih
```

- WHY: `ih`라는 가정을 `h`라는 새 이름으로 한 번 더 손에 꺼낸다. 다음 줄에서 `linarith [h]`에 명시적으로 넘기기 위해서이다.
- USES: 없음. `have`는 새 보조 사실을 도입하는 구문이다.

```
-- AFTER `have h := ih`:
--   k : Nat
--   ih : 2 * (∑ j ∈ Finset.range (k + 1), j) = k * (k + 1)
--   h  : 2 * (∑ j ∈ Finset.range (k + 1), j) = k * (k + 1)
--   ⊢ 2 * ((∑ j ∈ Finset.range (k + 1), j) + (k + 1)) = (k + 1) * (k + 1 + 1)
```

가정에 `h`가 추가되었다. 내용은 `ih`와 같다.

---

```lean
    linarith [h]
```

- WHY: 남은 등식 `2 * (S + (k+1)) = (k+1) * (k+2)`(여기서 `S`는 합 덩어리)을 보이려 한다. 분배 법칙으로 좌변을 펼치면 `2 * S + 2 * (k+1)`이고, `h`에 의해 `2 * S = k * (k+1)`이므로 좌변은 `k * (k+1) + 2 * (k+1)`. 인수 `(k+1)`을 묶으면 `(k+1) * (k+2)`. 이 모든 연립 등식을 선형 산술 자동화 `linarith`이 처리해 준다.
- USES: `linarith [h]`. `[h]`는 "추가로 이 가정을 더 살펴 달라"는 힌트이다.

`linarith`은 선형 산술 추론이지만, 우리의 경우 좌변과 우변에 등장하는 곱 `2 * S`, `2 * (k+1)`, `k * (k+1)`, `(k+1) * (k+2)`은 `S`, `k`라는 변수에 대해 일차이다(`k * (k+1)`은 `k^2 + k`로 펼치면 비선형이지만, `h`라는 등식을 통해 `2 * S`로 치환하면 선형 결합에 묶을 수 있다). 따라서 `linarith`이 작동한다.

```
-- AFTER `linarith [h]`:
--   (case succ 닫힘)
--   (No goals)
```

---

**대안 코드** 자동화를 더 줄여 손으로 펼치고 싶은 학습자를 위해 더 명시적인 형태를 제시한다.

```lean
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [Nat.mul_add]
    rw [ih]
    ring
```

이 형태에서는 `Nat.mul_add`를 명시적으로 사용해 분배 법칙을 한 줄에 보여 준 뒤, `rw [ih]`로 IH를 적용하고, 마지막의 다항식 정리는 `ring`이 처리한다. 단계가 하나씩 보이는 대신 줄이 늘어난다. 학습자의 취향에 따라 선택한다.

`Nat.mul_add`의 진술은 다음과 같다.

```
Nat.mul_add : ∀ (a b c : Nat), a * (b + c) = a * b + a * c
```

---

**전체 흐름 정리 (위쪽 `linarith` 버전 기준)**

| 줄 | 액션 | 목표의 변화 |
|---|---|---|
| `induction n with` | 두 갈래 생성 | — |
| `\| zero => simp` | 자동 닫힘 | — |
| `rw [Finset.sum_range_succ]` | 마지막 항 분리 | — |
| `have h := ih` | IH를 명시적으로 손에 꺼냄 | — |
| `linarith [h]` | 선형 결합으로 닫힘 | (No goals) |

---
## 코드 5. `n_lt_two_pow` - 부등식 `n < 2ⁿ` (`n ≥ 1`)

**완성 코드 전체**

```lean
import Mathlib

theorem n_lt_two_pow (n : Nat) (hn : 1 ≤ n) : n < 2 ^ n := by
  induction n, hn using Nat.le_induction with
  | base =>
    decide
  | succ k hk ih =>
    have h1 : k + 1 ≤ 2 * k := by omega
    have h2 : 2 * k < 2 * 2 ^ k := by linarith [ih]
    calc k + 1 ≤ 2 * k       := h1
      _        < 2 * 2 ^ k   := h2
      _        = 2 ^ (k + 1) := by rw [pow_succ]; ring
```

**한 줄씩 분석**

```lean
theorem n_lt_two_pow (n : Nat) (hn : 1 ≤ n) : n < 2 ^ n := by
```

이 정리는 인수가 두 개이다. 자연수 `n`과 가정 `hn : 1 ≤ n`. 두 번째 인수가 가정이라는 점이 새로운 형식이다. Lean 4는 가정을 함수 인수처럼 다루므로 정리 선언에 자연스럽게 들어간다.

```
-- AFTER `:= by`:
--   n : Nat
--   hn : 1 ≤ n
--   ⊢ n < 2 ^ n
```

---

```lean
  induction n, hn using Nat.le_induction with
```

- WHY: 시작점이 `0`이 아닌 `1`이기 때문이다. 기본 `induction`은 `Nat`의 `zero`에서 시작하지만, 우리는 `1`에서 시작해야 한다. `Nat.le_induction`이 이 역할을 한다.
- USES: `Nat.le_induction`. 진술은 다음과 같다.

```
Nat.le_induction : ∀ {n₀ : Nat} {motive : (n : Nat) → n₀ ≤ n → Prop},
  motive n₀ (Nat.le.refl) →                                          -- base
  (∀ (k : Nat) (hk : n₀ ≤ k), motive k hk → motive (k+1) (...)) →   -- inductive step
  ∀ (n : Nat) (hn : n₀ ≤ n), motive n hn
```

말로 풀면 "`n₀`에서 시작하는 술어가 (1) `n₀`에서 참이고, (2) `k`에서 참이면 `k+1`에서도 참이라면, `n₀` 이상의 모든 `n`에서 참이다"이다.

`induction n, hn using Nat.le_induction with`는 "변수 `n`과 가정 `hn`을 함께 넘기고, 귀납 도구로는 `Nat.le_induction`을 쓰겠다"는 선언이다.

```
-- AFTER:
--   case base
--     ⊢ 1 < 2 ^ 1
--   case succ
--     k : Nat
--     hk : 1 ≤ k
--     ih : k < 2 ^ k
--     ⊢ k + 1 < 2 ^ (k + 1)
```

두 갈래가 만들어졌다. `case base`는 시작점 `n₀ = 1`에 대한 목표이다. `case succ`은 `1 ≤ k`라는 새 가정 `hk`와 함께 `ih`가 주어진다.

여기서 `ih`의 의미를 짚어 둔다. 기본 `induction`의 `ih`가 "이전 단계의 술어"였다면, `Nat.le_induction`의 `ih`도 "이전 단계의 술어"이지만 추가로 `hk : 1 ≤ k`가 함께 따라온다. 우리는 `ih`(이전 술어)와 `hk`(범위 가정)를 둘 다 손에 쥐고 다음 단계로 간다.

---

```lean
  | base =>
    decide
```

- WHY: 목표 `1 < 2 ^ 1`은 작은 수의 부등식이다. `2 ^ 1 = 2`이므로 `1 < 2`. 직접 계산으로 즉결.
- USES: `decide`. 유한 시간 계산으로 판정 가능한 명제를 닫는다.

```
-- AFTER `decide`:
--   (case base 닫힘)
```

---

```lean
  | succ k hk ih =>
    have h1 : k + 1 ≤ 2 * k := by omega
```

- WHY: 부등식 사슬의 첫 단계 `k + 1 ≤ 2 * k`를 보조 사실로 손에 쥐려 한다. 이는 `hk : 1 ≤ k`라는 가정에서 직접 따라온다(`k ≥ 1`이므로 `2k = k + k ≥ k + 1`).
- USES: `omega`. 자연수·정수의 선형 산술 자동 결정 전술.

`omega`는 가정 목록에 있는 `hk : 1 ≤ k`를 자동으로 살펴 결론을 도출한다.

```
-- AFTER `have h1 ...`:
--   k : Nat
--   hk : 1 ≤ k
--   ih : k < 2 ^ k
--   h1 : k + 1 ≤ 2 * k
--   ⊢ k + 1 < 2 ^ (k + 1)
```

가정에 `h1`이 추가되었다.

---

```lean
    have h2 : 2 * k < 2 * 2 ^ k := by linarith [ih]
```

- WHY: 부등식 사슬의 둘째 단계 `2 * k < 2 * 2 ^ k`를 손에 쥐려 한다. `ih : k < 2 ^ k`의 양변에 `2`를 곱한 부등식이다.
- USES: `linarith [ih]`. `ih`를 명시적으로 넘겨주고 선형 산술 자동 추론.

`linarith`은 `ih`에서 `k < 2^k`를 받아 양변에 `2`(상수)를 곱하는 선형 변환을 수행한다. 이는 `linarith`이 다루는 표준적 변환이다.

```
-- AFTER `have h2 ...`:
--   k : Nat
--   hk : 1 ≤ k
--   ih : k < 2 ^ k
--   h1 : k + 1 ≤ 2 * k
--   h2 : 2 * k < 2 * 2 ^ k
--   ⊢ k + 1 < 2 ^ (k + 1)
```

---

```lean
    calc k + 1 ≤ 2 * k       := h1
      _        < 2 * 2 ^ k   := h2
      _        = 2 ^ (k + 1) := by rw [pow_succ]; ring
```

- WHY: 세 단계의 관계(`≤`, `<`, `=`)를 차례로 잇는 부등식 사슬을 `calc` 블록으로 명시한다. 결과는 `k + 1 < 2 ^ (k + 1)`이다.

`calc` 블록은 다음과 같이 작동한다.

- 첫 줄 `k + 1 ≤ 2 * k := h1`: "`k + 1 ≤ 2 * k`이다. 이유는 `h1`."
- 둘째 줄 `_ < 2 * 2 ^ k := h2`: "(앞 줄의 우변) `< 2 * 2 ^ k`이다. 이유는 `h2`." 언더스코어 `_`는 앞 줄의 우변을 자동으로 가져온다.
- 셋째 줄 `_ = 2 ^ (k + 1) := by rw [pow_succ]; ring`: "(앞 줄의 우변) `= 2 ^ (k + 1)`이다. 이유는 `rw [pow_succ]; ring`."

세 줄을 잇는 관계 기호는 `≤`, `<`, `=`이다. Lean 4의 `calc`은 이 세 가지 관계를 적절히 결합하여 "처음 식이 마지막 식보다 작다(`<`)"는 결론을 도출한다.

셋째 줄의 `by rw [pow_succ]; ring`을 한 단계씩 더 본다.

```
-- BEFORE `rw [pow_succ]`:
--   ⊢ 2 * 2 ^ k = 2 ^ (k + 1)
```

`pow_succ`의 진술은 `a ^ (n + 1) = a ^ n * a`이다. 좌변에서 우변 방향으로 적용하면, 목표의 **우변** `2 ^ (k + 1)`이 `2 ^ k * 2`로 바뀐다.

```
-- AFTER `rw [pow_succ]`:
--   ⊢ 2 * 2 ^ k = 2 ^ k * 2
```

이제 양변은 곱셈 순서만 다르다. `ring`이 곱셈의 교환 법칙으로 자동 닫힘.

```
-- AFTER `ring`:
--   (calc 블록의 셋째 줄 닫힘)
--   (case succ 닫힘)
--   (No goals)
```

---

**전체 흐름 정리**

| 줄 | 액션 |
|---|---|
| `induction n, hn using Nat.le_induction with` | 1부터 시작하는 귀납 |
| `\| base => decide` | `1 < 2` 직접 계산 |
| `have h1 : k + 1 ≤ 2 * k := by omega` | `hk : 1 ≤ k`로부터 |
| `have h2 : 2 * k < 2 * 2 ^ k := by linarith [ih]` | `ih`의 양변에 2 곱하기 |
| `calc k+1 ≤ 2k < 2·2^k = 2^(k+1)` | 세 단계 사슬로 결론 |

---

## 코드 6. `three_dvd_n3_add_2n` - `3 ∣ (n³ + 2n)` (자연수)

**완성 코드 전체**

```lean
import Mathlib

theorem three_dvd_n3_add_2n (n : Nat) : 3 ∣ (n ^ 3 + 2 * n) := by
  induction n with
  | zero =>
    decide
  | succ k ih =>
    have key : (k + 1) ^ 3 + 2 * (k + 1) = (k ^ 3 + 2 * k) + 3 * (k ^ 2 + k + 1) := by
      ring
    rw [key]
    exact Nat.dvd_add ih (Dvd.intro (k ^ 2 + k + 1) rfl)
```

**한 줄씩 분석**

```lean
theorem three_dvd_n3_add_2n (n : Nat) : 3 ∣ (n ^ 3 + 2 * n) := by
  induction n with
```

```
-- AFTER `induction n with`:
--   case zero
--     ⊢ 3 ∣ (0 ^ 3 + 2 * 0)
--   case succ
--     k : Nat
--     ih : 3 ∣ (k ^ 3 + 2 * k)
--     ⊢ 3 ∣ ((k + 1) ^ 3 + 2 * (k + 1))
```

---

```lean
  | zero =>
    decide
```

- WHY: `0 ^ 3 + 2 * 0 = 0`이고 `3 ∣ 0`은 참(모든 수가 `0`을 나눈다).
- USES: `decide`. 작은 수의 가분성은 직접 계산으로 판정 가능.

---

```lean
  | succ k ih =>
    have key : (k + 1) ^ 3 + 2 * (k + 1) = (k ^ 3 + 2 * k) + 3 * (k ^ 2 + k + 1) := by
      ring
```

- WHY: 핵심 다항식 분해를 보조 사실 `key`로 손에 쥔다. 좌변을 전개해서 정리하면 우변이 됨을 `ring`이 자동으로 검증한다.
- USES: `ring`. 다항식 항등식을 표준형으로 정규화해서 비교.

`ring`이 이 등식을 검증하는 과정을 손으로 펼쳐 보면 다음과 같다(실제로 `ring` 안에서 일어나는 일과 정확히 일치하지는 않지만, 결과는 같다).

```
(k + 1) ^ 3 + 2 * (k + 1)
  = k^3 + 3k^2 + 3k + 1 + 2k + 2     -- 전개
  = k^3 + 2k + 3k^2 + 3k + 3          -- 항 재배열
  = (k^3 + 2k) + 3(k^2 + k + 1)       -- 인수 묶기
```

`ring`은 이런 종류의 다항식 정규화를 자동으로 수행한다.

```
-- AFTER `have key ...`:
--   k : Nat
--   ih : 3 ∣ (k ^ 3 + 2 * k)
--   key : (k + 1) ^ 3 + 2 * (k + 1) = (k ^ 3 + 2 * k) + 3 * (k ^ 2 + k + 1)
--   ⊢ 3 ∣ ((k + 1) ^ 3 + 2 * (k + 1))
```

가정에 `key`가 추가되었다. 목표는 아직 그대로다.

---

```lean
    rw [key]
```

- WHY: 목표의 표현을 `key`의 좌변에서 우변 방향으로 다시 쓴다. 즉 `(k+1)^3 + 2(k+1)`을 `(k^3 + 2k) + 3(k^2 + k + 1)`로 치환한다.
- USES: `key`.

```
-- AFTER `rw [key]`:
--   k : Nat
--   ih : 3 ∣ (k ^ 3 + 2 * k)
--   key : ...
--   ⊢ 3 ∣ ((k ^ 3 + 2 * k) + 3 * (k ^ 2 + k + 1))
```

목표가 "두 덩어리의 합"으로 다시 쓰였다. 첫 덩어리 `k^3 + 2k`는 `ih`가 가분성을 보장하는 것이고, 둘째 덩어리 `3 * (k^2 + k + 1)`은 명백한 `3`의 배수이다.

---

```lean
    exact Nat.dvd_add ih (Dvd.intro (k ^ 2 + k + 1) rfl)
```

- WHY: 두 가분성을 결합해 최종 결론을 만든다.
- USES:
  - `Nat.dvd_add : ∀ {k m n : Nat}, k ∣ m → k ∣ n → k ∣ (m + n)`. 같은 약수로 나누어지는 두 수의 합도 같은 약수로 나누어진다.
  - `Dvd.intro : ∀ {α : Type*} [inst : Mul α] (a : α) {b : α}, b = c * a → c ∣ b`. 직접 곱셈 형태로 가분성을 구성한다.

`Nat.dvd_add`는 두 개의 가분성 증명을 인수로 받는 함수이다. 첫째 인수로는 `ih`를 그대로 넘긴다. `ih : 3 ∣ (k^3 + 2k)`가 첫 덩어리의 가분성을 책임진다.

둘째 인수 `Dvd.intro (k ^ 2 + k + 1) rfl`을 자세히 본다. `Dvd.intro`는 "`a ∣ b`를 보이고 싶을 때, `c`라는 증인을 제시하고 `b = a * c`임을 보이면 된다"는 구성자이다. 우리는 `3 ∣ 3 * (k^2 + k + 1)`을 보이고 싶고, 증인 `c = k^2 + k + 1`을 제시하고 `3 * (k^2 + k + 1) = 3 * (k^2 + k + 1)`이라는 자명한 등식을 `rfl`로 닫는다.

```
-- AFTER `exact ...`:
--   (case succ 닫힘)
--   (No goals)
```

---

**전체 흐름 정리**

| 줄 | 액션 |
|---|---|
| `\| zero => decide` | `3 ∣ 0` 직접 확인 |
| `have key : ... := by ring` | 핵심 다항식 분해를 ring이 검증 |
| `rw [key]` | 목표를 "두 덩어리의 합" 형태로 다시 씀 |
| `exact Nat.dvd_add ih (Dvd.intro _ rfl)` | IH가 첫 조각, 직접 구성이 둘째 조각, 두 가분성을 결합 |

---

## 코드 7. `seven_dvd_11n_sub_4n` - `7 ∣ (11ⁿ - 4ⁿ)` (정수)

**완성 코드 전체**

```lean
import Mathlib

theorem seven_dvd_11n_sub_4n (n : Nat) :
    (7 : Int) ∣ ((11 : Int) ^ n - 4 ^ n) := by
  induction n with
  | zero =>
    decide
  | succ k ih =>
    have key : (11 : Int) ^ (k + 1) - 4 ^ (k + 1)
             = 11 * (11 ^ k - 4 ^ k) + 7 * 4 ^ k := by
      ring
    rw [key]
    exact dvd_add (Dvd.dvd.mul_left ih 11) (Dvd.intro (4 ^ k) rfl)
```

**한 줄씩 분석 (코드 6과 다른 부분에 집중)**

```lean
theorem seven_dvd_11n_sub_4n (n : Nat) :
    (7 : Int) ∣ ((11 : Int) ^ n - 4 ^ n) := by
```

진술이 정수 `Int` 위에서 작성되었다. `(7 : Int)`, `(11 : Int)`는 "이 숫자를 정수로 해석하라"는 표시이다. 이 한 번의 표시로 식 전체가 정수 환경에서 평가된다.

자연수가 아닌 정수에서 작업하는 이유는 학생 자료 §12에서 적은 바와 같이 뺄셈이 안전하게 동작하도록 하기 위해서이다.

```
-- AFTER `:= by`:
--   n : Nat
--   ⊢ (7 : Int) ∣ (11 ^ n - 4 ^ n)
```

---

```lean
  induction n with
```

`n`이 자연수이므로 귀납은 자연수의 표준 형태(`zero`, `succ`)로 진행한다. 합·차의 식만 정수 환경에 있다.

```
-- AFTER:
--   case zero
--     ⊢ (7 : Int) ∣ (11 ^ 0 - 4 ^ 0)
--   case succ
--     k : Nat
--     ih : (7 : Int) ∣ (11 ^ k - 4 ^ k)
--     ⊢ (7 : Int) ∣ (11 ^ (k + 1) - 4 ^ (k + 1))
```

---

```lean
  | zero =>
    decide
```

- WHY: `11^0 = 4^0 = 1`이므로 차는 `0`. `7 ∣ 0`은 참.
- USES: `decide`. 작은 수의 직접 계산.

---

```lean
  | succ k ih =>
    have key : (11 : Int) ^ (k + 1) - 4 ^ (k + 1)
             = 11 * (11 ^ k - 4 ^ k) + 7 * 4 ^ k := by
      ring
```

- WHY: 학생 자료 §12와 §5.1 강의에서 강조한 **표준 트릭**의 한 줄. `a · aᵏ - b · bᵏ = a(aᵏ - bᵏ) + (a-b)bᵏ`이다. 우리 경우 `a = 11`, `b = 4`, `a-b = 7`.
- USES: `ring`. 정수환 위에서의 다항식 항등식. 자연수와 달리 뺄셈이 자유롭게 처리된다.

`ring`이 검증하는 등식을 손으로 펼치면 다음과 같다.

```
11 * (11^k - 4^k) + 7 * 4^k
  = 11 * 11^k - 11 * 4^k + 7 * 4^k       -- 분배
  = 11^(k+1) - 11 * 4^k + 7 * 4^k         -- 11 * 11^k = 11^(k+1)
  = 11^(k+1) - (11 - 7) * 4^k             -- 인수 묶기
  = 11^(k+1) - 4 * 4^k
  = 11^(k+1) - 4^(k+1)                    -- 4 * 4^k = 4^(k+1)
```

```
-- AFTER `have key ...`:
--   k : Nat
--   ih : (7 : Int) ∣ (11 ^ k - 4 ^ k)
--   key : (11 : Int) ^ (k+1) - 4 ^ (k+1) = 11 * (11^k - 4^k) + 7 * 4^k
--   ⊢ (7 : Int) ∣ (11 ^ (k + 1) - 4 ^ (k + 1))
```

---

```lean
    rw [key]
```

목표의 표현을 `key`로 다시 쓴다.

```
-- AFTER `rw [key]`:
--   ⊢ (7 : Int) ∣ (11 * (11 ^ k - 4 ^ k) + 7 * 4 ^ k)
```

목표가 "두 덩어리의 합" 형태이다. 첫 덩어리 `11 * (11^k - 4^k)`는 `ih`가 가분성을 보장하는 것의 `11`배. 둘째 덩어리 `7 * 4^k`는 명백한 `7`의 배수.

---

```lean
    exact dvd_add (Dvd.dvd.mul_left ih 11) (Dvd.intro (4 ^ k) rfl)
```

- WHY: 두 가분성을 `dvd_add`로 결합한다.
- USES:
  - `dvd_add`. 일반 환에서의 가분성 결합 정리. `Nat.dvd_add`의 정수 버전에 해당.
  - `Dvd.dvd.mul_left ih 11`. `ih`가 보장하는 가분성에 좌측에서 `11`을 곱한 형태의 가분성을 구성한다.
  - `Dvd.intro (4 ^ k) rfl`. 코드 6과 같은 패턴으로 직접 가분성을 구성한다.

`Dvd.dvd.mul_left`의 진술은 다음과 같다.

```
Dvd.dvd.mul_left : ∀ {α : Type*} [inst : Mul α] [inst_1 : Semigroup α]
                       {a b : α}, a ∣ b → ∀ (c : α), a ∣ (c * b)
```

말로 풀면 "`a ∣ b`이면 임의의 `c`에 대해 `a ∣ (c * b)`"이다. `ih`가 `7 ∣ (11^k - 4^k)`를 보장하고 있으므로, `Dvd.dvd.mul_left ih 11`은 `7 ∣ 11 * (11^k - 4^k)`를 구성한다.

```
-- AFTER `exact ...`:
--   (case succ 닫힘)
--   (No goals)
```

---

**전체 흐름 정리**

| 줄 | 액션 |
|---|---|
| `\| zero => decide` | `7 ∣ 0` 직접 확인 |
| `have key : ... := by ring` | 표준 트릭 분해, 정수환 위의 ring |
| `rw [key]` | 목표를 "두 덩어리의 합" 형태로 다시 씀 |
| `exact dvd_add (Dvd.dvd.mul_left ih 11) (Dvd.intro _ rfl)` | IH의 11배가 첫 조각, 7배 직접 구성이 둘째 조각 |

---

## 코드 8. `sum_sq` - 제곱의 합 (양변 6배 형태)

**완성 코드 전체**

```lean
import Mathlib

open Finset

theorem sum_sq (n : Nat) :
    6 * (∑ k ∈ Finset.range (n + 1), k ^ 2) = n * (n + 1) * (2 * n + 1) := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [mul_add]
    rw [ih]
    ring
```

**한 줄씩 분석**

```lean
theorem sum_sq (n : Nat) :
    6 * (∑ k ∈ Finset.range (n + 1), k ^ 2) = n * (n + 1) * (2 * n + 1) := by
```

진술의 좌변이 `6 * (...)`이다. 자연수 나눗셈을 피하기 위해 양변에 6을 곱한 형태로 진술되었다.

```
-- AFTER `:= by`:
--   n : Nat
--   ⊢ 6 * (∑ k ∈ Finset.range (n + 1), k^2) = n * (n + 1) * (2 * n + 1)
```

---

```lean
  induction n with
```

```
-- AFTER:
--   case zero
--     ⊢ 6 * (∑ k ∈ Finset.range 1, k^2) = 0 * (0 + 1) * (2 * 0 + 1)
--   case succ
--     k : Nat
--     ih : 6 * (∑ j ∈ Finset.range (k + 1), j^2) = k * (k + 1) * (2 * k + 1)
--     ⊢ 6 * (∑ j ∈ Finset.range (k + 2), j^2)
--         = (k + 1) * (k + 1 + 1) * (2 * (k + 1) + 1)
```

---

```lean
  | zero =>
    simp
```

기저: 좌변에서 `Finset.range 1 = {0}` 위의 `k^2` 합은 `0^2 = 0`. `6 * 0 = 0`. 우변은 `0 * 1 * 1 = 0`. 등식 성립. `simp`이 처리.

---

```lean
  | succ k ih =>
    rw [Finset.sum_range_succ]
```

- WHY: 합의 마지막 항을 분리한다.
- USES: `Finset.sum_range_succ`.

```
-- AFTER `rw [Finset.sum_range_succ]`:
--   ⊢ 6 * ((∑ j ∈ Finset.range (k + 1), j^2) + (k + 1)^2)
--       = (k + 1) * (k + 2) * (2 * (k + 1) + 1)
```

---

```lean
    rw [mul_add]
```

- WHY: 좌변의 `6 * (... + ...)`을 분배 법칙으로 펼쳐, `ih`의 좌변과 정확히 같은 모양인 `6 * (∑ j ∈ Finset.range (k + 1), j^2)`를 노출시킨다.
- USES: `mul_add : ∀ (a b c : α), a * (b + c) = a * b + a * c`.

```
-- AFTER `rw [mul_add]`:
--   ⊢ 6 * (∑ j ∈ Finset.range (k + 1), j^2) + 6 * (k + 1)^2
--       = (k + 1) * (k + 2) * (2 * (k + 1) + 1)
```

좌변 첫 항이 `ih`의 좌변과 완벽히 일치한다.

---

```lean
    rw [ih]
```

`ih : 6 * (∑ j ∈ Finset.range (k + 1), j^2) = k * (k + 1) * (2 * k + 1)`로 첫 항을 치환.

```
-- AFTER `rw [ih]`:
--   ⊢ k * (k + 1) * (2 * k + 1) + 6 * (k + 1)^2
--       = (k + 1) * (k + 2) * (2 * (k + 1) + 1)
```

남은 등식은 다항식 항등식. 양변을 손으로 펼쳐 보면:

```
좌변 = k(k+1)(2k+1) + 6(k+1)²
     = (k+1) [k(2k+1) + 6(k+1)]
     = (k+1) [2k² + k + 6k + 6]
     = (k+1) (2k² + 7k + 6)
     = (k+1) (k+2) (2k+3)
     = (k+1) (k+2) (2(k+1)+1)
     = 우변.
```

---

```lean
    ring
```

다항식 항등식 자동 검증.

```
-- AFTER `ring`:
--   (No goals)
```

---

**합 공식 표준 4·5줄 패턴**

본 코드는 §5.1 학생 자료의 합 공식 표준 절차를 정확히 따른다.

```
rw [Finset.sum_range_succ]   -- 마지막 항 분리
rw [mul_add]                 -- 좌변 상수 분배
rw [ih]                      -- IH로 첫 항 치환
ring                         -- 남은 다항식 항등식 검증
```

이 절차는 `sum_cube`(다음 코드 9), 그리고 등비급수를 제외한 모든 합 공식에 그대로 적용된다.

---

## 코드 9. `sum_cube` - 세제곱의 합 (양변 4배 형태)

**완성 코드 전체**

```lean
import Mathlib

open Finset

theorem sum_cube (n : Nat) :
    4 * (∑ k ∈ Finset.range (n + 1), k ^ 3) = (n * (n + 1)) ^ 2 := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [mul_add]
    rw [ih]
    ring
```

코드 8과 글자 단위로 비교하면 다음만 다르다.

| 항목 | 코드 8 | 코드 9 |
|---|---|---|
| 좌변 배수 | `6` | `4` |
| 합 안의 지수 | `^ 2` | `^ 3` |
| 우변 | `n * (n + 1) * (2 * n + 1)` | `(n * (n + 1)) ^ 2` |

다른 모든 줄은 동일하다. **합 공식 표준 4줄 패턴의 보편성**을 확인해 주는 대표 예이다.

남은 다항식 항등식의 손 펼치기는 학생 자료 §10에 있다.

```
좌변 = (k(k+1))² + 4(k+1)³
     = (k+1)² [k² + 4(k+1)]
     = (k+1)² (k+2)²
     = ((k+1)(k+2))²
     = 우변.
```

---

## 코드 10. `geom_sum` - 등비급수

**완성 코드 전체**

```lean
import Mathlib

open Finset

theorem geom_sum (r : Real) (hr : r ≠ 1) (n : Nat) :
    (∑ k ∈ Finset.range (n + 1), r ^ k) = (r ^ (n + 1) - 1) / (r - 1) := by
  have hrm1 : r - 1 ≠ 0 := sub_ne_zero.mpr hr
  induction n with
  | zero =>
    simp
    field_simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    rw [ih]
    field_simp
    ring
```

**한 줄씩 분석**

```lean
theorem geom_sum (r : Real) (hr : r ≠ 1) (n : Nat) :
    (∑ k ∈ Finset.range (n + 1), r ^ k) = (r ^ (n + 1) - 1) / (r - 1) := by
```

인수가 셋. 실수 `r`, 가정 `hr : r ≠ 1`, 자연수 `n`. 식이 실수 환경에서 작동한다.

```
-- AFTER `:= by`:
--   r : Real
--   hr : r ≠ 1
--   n : Nat
--   ⊢ (∑ k ∈ Finset.range (n + 1), r^k) = (r^(n+1) - 1) / (r - 1)
```

---

```lean
  have hrm1 : r - 1 ≠ 0 := sub_ne_zero.mpr hr
```

- WHY: 본문 안에서 `field_simp`이 분모가 0이 아니라는 사실을 가정 목록에서 찾을 수 있도록 미리 비축한다.
- USES: `sub_ne_zero.mpr : a ≠ b → a - b ≠ 0`. 학생 자료 §11 참조.

```
-- AFTER `have hrm1 ...`:
--   r : Real,  hr : r ≠ 1,  n : Nat,  hrm1 : r - 1 ≠ 0
--   ⊢ (∑ k ∈ Finset.range (n + 1), r^k) = (r^(n+1) - 1) / (r - 1)
```

---

```lean
  induction n with
```

```
-- AFTER:
--   case zero
--     ⊢ (∑ k ∈ Finset.range 1, r^k) = (r^1 - 1) / (r - 1)
--   case succ
--     k : Nat,
--     ih : (∑ j ∈ Finset.range (k + 1), r^j) = (r^(k+1) - 1) / (r - 1)
--     ⊢ (∑ j ∈ Finset.range (k + 2), r^j) = (r^(k+2) - 1) / (r - 1)
```

---

```lean
  | zero =>
    simp
    field_simp
```

- WHY: 기저는 `Finset.range 1`에서 `r^0 = 1`. 좌변은 1. 우변은 `(r - 1) / (r - 1) = 1`. 이 등식을 보이려면 두 단계가 필요하다. `simp`이 좌변의 합과 `r^0`을 1로 정리하고, `field_simp`이 우변의 분수를 처리한다.
- USES: `simp` (일반 정리화), `field_simp` (분수 처리).

```
-- AFTER `simp`:
--   ⊢ 1 = (r - 1) / (r - 1)
--      또는 비슷한 형태로 정리된 등식
-- AFTER `field_simp`:
--   (No goals 또는 자명한 등식이 닫힘)
```

---

```lean
  | succ k ih =>
    rw [Finset.sum_range_succ]
```

마지막 항 분리.

```
-- AFTER `rw [Finset.sum_range_succ]`:
--   ⊢ (∑ j ∈ Finset.range (k + 1), r^j) + r^(k+1) = (r^(k+2) - 1) / (r - 1)
```

---

```lean
    rw [ih]
```

`ih`의 좌변(합 덩어리)을 그 우변 `(r^(k+1) - 1) / (r - 1)`로 치환.

```
-- AFTER `rw [ih]`:
--   ⊢ (r^(k+1) - 1) / (r - 1) + r^(k+1) = (r^(k+2) - 1) / (r - 1)
```

양변에 분수가 있다.

---

```lean
    field_simp
```

- WHY: 양변에 분모 `(r - 1)`을 곱해 분수를 없앤다.
- USES: `field_simp`. 가정 목록의 `hrm1 : r - 1 ≠ 0`을 자동으로 활용.

```
-- AFTER `field_simp`:
--   ⊢ (r^(k+1) - 1) + r^(k+1) * (r - 1) = r^(k+2) - 1
```

분모가 사라지고 양변이 다항식 등식만 남았다.

---

```lean
    ring
```

다항식 항등식. 좌변 펼치기:

```
(r^(k+1) - 1) + r^(k+1) * (r - 1)
  = r^(k+1) - 1 + r^(k+1) * r - r^(k+1)
  = r^(k+1) * r - 1
  = r^(k+2) - 1
  = 우변.
```

```
-- AFTER `ring`:
--   (No goals)
```

---

**분수가 있는 합 공식의 표준 6줄 절차**

```
have h분모 : <분모> ≠ 0 := <증명>
induction n with
| zero => simp; field_simp
| succ k ih =>
    rw [Finset.sum_range_succ]
    rw [ih]
    field_simp
    ring
```

`field_simp`이 분수 처리를 자동화한다는 점만 다를 뿐, 큰 골격은 코드 8·9의 표준 패턴과 같다.

---

## 코드 11. `pow_two_lt_fac` - 2ⁿ < n! (n ≥ 4)

**완성 코드 전체**

```lean
import Mathlib

theorem pow_two_lt_fac (n : Nat) (hn : 4 ≤ n) : 2 ^ n < n.factorial := by
  induction n, hn using Nat.le_induction with
  | base =>
    decide
  | succ k hk ih =>
    have h1 : 2 ^ (k + 1) = 2 * 2 ^ k := by
      rw [pow_succ]
      ring
    have h2 : (2 : Nat) * 2 ^ k < 2 * k.factorial := by
      have := ih
      nlinarith
    have h3 : 2 * k.factorial ≤ (k + 1) * k.factorial := by
      have hk1 : 2 ≤ k + 1 := by omega
      exact Nat.mul_le_mul_right _ hk1
    have h4 : (k + 1) * k.factorial = (k + 1).factorial := by
      rw [Nat.factorial_succ]
    omega
```

**한 줄씩 분석**

```lean
theorem pow_two_lt_fac (n : Nat) (hn : 4 ≤ n) : 2 ^ n < n.factorial := by
  induction n, hn using Nat.le_induction with
```

`Nat.le_induction`으로 `4`부터 시작. 기저점이 4라는 것 외에 코드 5(`n_lt_two_pow`)와 같은 구조.

```
-- AFTER `induction ...`:
--   case base
--     ⊢ 2 ^ 4 < Nat.factorial 4
--   case succ
--     k : Nat
--     hk : 4 ≤ k
--     ih : 2 ^ k < k.factorial
--     ⊢ 2 ^ (k + 1) < (k + 1).factorial
```

---

```lean
  | base =>
    decide
```

`2 ^ 4 = 16 < 24 = 4!`. 직접 계산.

---

```lean
  | succ k hk ih =>
    have h1 : 2 ^ (k + 1) = 2 * 2 ^ k := by
      rw [pow_succ]
      ring
```

- WHY: 부등식 사슬의 첫 등호 단계 `2^(k+1) = 2 · 2^k`를 손에 쥔다.
- USES: `pow_succ : a^(n+1) = a^n * a`. `ring`으로 곱셈 순서 정리.

`pow_succ`을 그대로 적용하면 `2^(k+1) = 2^k * 2`가 되는데, 우리는 `2 * 2^k` 형태를 원한다. `ring`이 곱셈 교환으로 마무리.

```
-- AFTER `have h1 ...`:
--   k : Nat,  hk : 4 ≤ k,  ih : 2 ^ k < k.factorial,
--   h1 : 2 ^ (k + 1) = 2 * 2 ^ k
--   ⊢ 2 ^ (k + 1) < (k + 1).factorial
```

---

```lean
    have h2 : (2 : Nat) * 2 ^ k < 2 * k.factorial := by
      have := ih
      nlinarith
```

- WHY: 사슬의 둘째 단계 `2 · 2^k < 2 · k!`. `ih`의 양변에 양수 2를 곱한 부등식이다.
- USES: `nlinarith`. 곱셈을 포함한 비선형 결합 자동화.

`have := ih`는 `ih`를 무명 보조 사실로 가정 목록에 다시 한 번 노출시킨다(`nlinarith`이 자동으로 찾도록 돕는 보호 표현). 이때 이름은 `this`로 자동 부여된다.

`nlinarith`은 가정 목록의 `ih : 2^k < k.factorial`을 받아 양변에 양의 상수 `2`를 곱하는 비선형 변환을 처리한다.

```
-- AFTER `have h2 ...`:
--   h1 : ...,  h2 : (2 : Nat) * 2 ^ k < 2 * k.factorial
--   ⊢ 2 ^ (k + 1) < (k + 1).factorial
```

---

```lean
    have h3 : 2 * k.factorial ≤ (k + 1) * k.factorial := by
      have hk1 : 2 ≤ k + 1 := by omega
      exact Nat.mul_le_mul_right _ hk1
```

- WHY: 사슬의 셋째 단계 `2 · k! ≤ (k+1) · k!`. 양쪽이 `k.factorial`을 공통 인수로 가지고, 계수가 `2 ≤ k+1`이라는 사실로부터 따라온다.
- USES:
  - `omega`. `hk : 4 ≤ k`에서 `2 ≤ k + 1`을 도출.
  - `Nat.mul_le_mul_right`. 진술 `∀ (k : Nat) {m n : Nat}, m ≤ n → m * k ≤ n * k`.

`Nat.mul_le_mul_right _ hk1`의 `_`은 곱해지는 공통 인수 `k.factorial`을 Lean 4가 자동 추론하라는 표시이다. 일관성을 위해 명시한다면 `Nat.mul_le_mul_right k.factorial hk1`이다.

```
-- AFTER `have h3 ...`:
--   h1, h2, h3 모두 가정에
--   ⊢ 2 ^ (k + 1) < (k + 1).factorial
```

---

```lean
    have h4 : (k + 1) * k.factorial = (k + 1).factorial := by
      rw [Nat.factorial_succ]
```

- WHY: 사슬의 마지막 등호 `(k+1) · k! = (k+1)!`. 계승의 정의 그 자체.
- USES: `Nat.factorial_succ : (n + 1).factorial = (n + 1) * n.factorial`.

`rw [Nat.factorial_succ]`은 등식의 좌변에서 우변 방향으로 적용하므로, 목표 `(k+1) * k.factorial = (k+1).factorial`에서 우변 `(k+1).factorial`을 `(k+1) * k.factorial`로 바꾼다. 그러면 목표가 `(k+1) * k.factorial = (k+1) * k.factorial`이 되어 자동으로 닫힌다.

```
-- AFTER `have h4 ...`:
--   h1, h2, h3, h4 모두 가정에
--   ⊢ 2 ^ (k + 1) < (k + 1).factorial
```

---

```lean
    omega
```

- WHY: 네 보조 사실의 선형 결합.
- USES: `omega`.

가정에 다음 네 가지가 있다.
- `h1 : 2^(k+1) = 2 * 2^k`
- `h2 : 2 * 2^k < 2 * k.factorial`
- `h3 : 2 * k.factorial ≤ (k+1) * k.factorial`
- `h4 : (k+1) * k.factorial = (k+1).factorial`

`omega`이 이를 결합하면 `2^(k+1) = 2 * 2^k < 2 * k.factorial ≤ (k+1) * k.factorial = (k+1).factorial`이라는 사슬이 곧 결론.

```
-- AFTER `omega`:
--   (No goals)
```

---

**핵심 관찰** 이 정리는 `calc` 블록 대신 **네 개의 `have`를 비축한 뒤 `omega`가 결합**하는 형태를 보여 준다. `calc`이 사슬을 시각적으로 보여 주는 데 강하다면, 이 패턴은 보조 사실들을 한곳에 모아 두고 자동화에 맡기는 깔끔함이 강점이다. 같은 정리를 두 가지 형식으로 작성할 수 있다는 점이 Lean 4의 유연성이다.

---

## 코드 12. `bernoulli` - 베르누이 부등식

**완성 코드 전체**

```lean
import Mathlib

theorem bernoulli (x : Real) (hx : -1 ≤ x) (n : Nat) :
    (1 + x) ^ n ≥ 1 + n * x := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    have h1x : 0 ≤ 1 + x := by linarith
    have hkx_sq : 0 ≤ (k : Real) * x ^ 2 := by
      apply mul_nonneg
      · positivity
      · exact sq_nonneg x
    rw [pow_succ]
    push_cast
    calc (1 + x) ^ k * (1 + x)
        _ ≥ (1 + k * x) * (1 + x)     := by gcongr
        _ = 1 + (k + 1) * x + k * x ^ 2 := by ring
        _ ≥ 1 + (k + 1) * x             := by linarith
```

**한 줄씩 분석**

```lean
theorem bernoulli (x : Real) (hx : -1 ≤ x) (n : Nat) :
    (1 + x) ^ n ≥ 1 + n * x := by
```

`x`는 실수, `n`은 자연수. 자연수 `n`이 실수 식 `1 + n * x` 안에 등장하므로 Lean 4가 자동으로 `(n : Real)`로 캐스팅한다. 이 캐스팅이 후에 `push_cast`로 정리되는 핵심이다.

```
-- AFTER `:= by`:
--   x : Real,  hx : -1 ≤ x,  n : Nat
--   ⊢ (1 + x) ^ n ≥ 1 + ↑n * x
```

`↑n`이 캐스팅 표시이다.

---

```lean
  induction n with
  | zero =>
    simp
```

기저: `(1 + x)^0 = 1`, `1 + 0 * x = 1`. 양변 1. `simp`이 처리.

---

```lean
  | succ k ih =>
    have h1x : 0 ≤ 1 + x := by linarith
```

- WHY: `gcongr`이 부등식 변환을 안전하게 수행하려면 `1 + x`가 비음수이어야 한다. 비음수 곱셈으로 부등식이 보존되기 때문이다.
- USES: `linarith`. `hx : -1 ≤ x`에서 `0 ≤ 1 + x`를 직접 도출.

```
-- AFTER `have h1x ...`:
--   k : Nat,  ih : (1 + x)^k ≥ 1 + ↑k * x,  h1x : 0 ≤ 1 + x
--   ⊢ (1 + x)^(k+1) ≥ 1 + ↑(k+1) * x
```

---

```lean
    have hkx_sq : 0 ≤ (k : Real) * x ^ 2 := by
      apply mul_nonneg
      · positivity
      · exact sq_nonneg x
```

- WHY: `calc`의 마지막 `linarith` 단계에서 "`k · x² ≥ 0`이므로 항을 떼어낼 수 있다"는 사실을 사용한다. 미리 비축한다.
- USES:
  - `mul_nonneg : 0 ≤ a → 0 ≤ b → 0 ≤ a * b`. 두 비음수의 곱은 비음수.
  - `positivity`. 자동 양수성 판정.
  - `sq_nonneg : 0 ≤ a^2`. 모든 수의 제곱은 비음수.

`apply mul_nonneg`은 목표 `0 ≤ (k : Real) * x ^ 2`를 두 부목표 `0 ≤ (k : Real)`과 `0 ≤ x ^ 2`로 분리한다. 각각을 `·`(점)으로 시작하는 줄에서 처리한다.

```
-- AFTER `have hkx_sq ...`:
--   ..., hkx_sq : 0 ≤ ↑k * x ^ 2
--   ⊢ (1 + x)^(k+1) ≥ 1 + ↑(k+1) * x
```

---

```lean
    rw [pow_succ]
```

- WHY: 좌변 `(1+x)^(k+1)`을 `(1+x)^k * (1+x)` 형태로 분리한다.
- USES: `pow_succ`.

```
-- AFTER `rw [pow_succ]`:
--   ⊢ (1 + x)^k * (1 + x) ≥ 1 + ↑(k+1) * x
```

---

```lean
    push_cast
```

- WHY: 자연수 캐스팅 `↑(k+1)`을 `↑k + 1`로 풀어 식 전체를 실수 표현으로 정리한다.
- USES: `push_cast`.

```
-- AFTER `push_cast`:
--   ⊢ (1 + x)^k * (1 + x) ≥ 1 + (↑k + 1) * x
```

이제 식이 깔끔한 실수 형태이다. `↑`로 시작하는 부분이 풀려, `k`가 실수처럼 자연스럽게 쓰인다.

---

```lean
    calc (1 + x) ^ k * (1 + x)
        _ ≥ (1 + k * x) * (1 + x)     := by gcongr
```

- WHY: `calc` 시작. 첫 인수 `(1+x)^k`를 IH로 `1 + k * x`로 교체하되, 둘째 인수 `(1+x)`는 그대로. 비음수 곱셈으로 부등식 방향 보존.
- USES: `gcongr`. 학생 자료 §14 참조.

`gcongr`은 가정 목록에서 `ih`(부등식)와 `h1x`(비음수)를 자동으로 찾아 결합한다.

```
-- AFTER `_ ≥ ... := by gcongr`:
--   (calc 진행 중, 이 줄의 부등식 확정)
```

---

```lean
        _ = 1 + (k + 1) * x + k * x ^ 2 := by ring
```

- WHY: `(1 + k*x)(1 + x)`을 전개하면 `1 + k*x + x + k*x²`이고, 이를 묶으면 `1 + (k+1)*x + k*x²`이다.
- USES: `ring`.

`ring`이 다항식 등식을 자동 검증.

```
-- AFTER `_ = ... := by ring`:
--   (calc 진행 중, 이 줄의 등식 확정)
```

---

```lean
        _ ≥ 1 + (k + 1) * x             := by linarith
```

- WHY: `1 + (k+1)*x + k*x² ≥ 1 + (k+1)*x`는 `k*x² ≥ 0`이라는 비축 사실 `hkx_sq`로부터 직접 따라온다.
- USES: `linarith`. 가정 목록의 `hkx_sq`를 자동으로 찾는다.

```
-- AFTER `_ ≥ ... := by linarith`:
--   (calc 닫힘)
--   (No goals)
```

`calc` 블록의 세 단계가 모두 같은 좌변(`(1+x)^k * (1+x)`)에서 시작해서 마지막 식(`1 + (k+1)*x`)으로 이어지는 사슬을 구성한다. 첫 단계가 `≥`, 둘째 단계가 `=`, 셋째 단계가 `≥`이므로, 결과는 `≥` 부등식이다.

---

**전체 흐름 정리**

| 줄 | 액션 |
|---|---|
| `have h1x : 0 ≤ 1 + x := by linarith` | `gcongr`을 위한 비음수성 비축 |
| `have hkx_sq : 0 ≤ k * x^2 := ...` | `linarith` 마지막 단계 위한 비음수성 비축 |
| `rw [pow_succ]` | `(1+x)^(k+1) = (1+x)^k * (1+x)` |
| `push_cast` | 자연수 캐스팅 정리 |
| `calc ... gcongr ... ring ... linarith` | 세 단계 부등식 사슬 |

본 자료에서 가장 복잡한 코드이다. 모든 단계가 가시화되어, 종이의 베르누이 증명을 한 줄씩 그대로 따라간다.

---

## 코드 13. `div3_n3_sub_n_int` - 3 ∣ (n³ − n) 정수

**완성 코드 전체**

```lean
import Mathlib

theorem div3_n3_sub_n_int (n : Int) : (3 : Int) ∣ (n ^ 3 - n) := by
  induction n using Int.induction_on with
  | zero =>
    decide
  | succ k ih =>
    have key : ((k : Int) + 1) ^ 3 - ((k : Int) + 1)
             = ((k : Int) ^ 3 - (k : Int)) + 3 * ((k : Int) ^ 2 + (k : Int)) := by
      ring
    rw [key]
    exact dvd_add ih (Dvd.intro ((k : Int) ^ 2 + (k : Int)) rfl)
  | pred k ih =>
    have key : (-(k : Int) - 1) ^ 3 - (-(k : Int) - 1)
             = ((-(k : Int)) ^ 3 - (-(k : Int))) - 3 * ((k : Int) ^ 2 + (k : Int)) := by
      ring
    rw [key]
    exact dvd_sub ih (Dvd.intro ((k : Int) ^ 2 + (k : Int)) rfl)
```

**`Int.induction_on`의 세 갈래**

```lean
  induction n using Int.induction_on with
```

```
-- AFTER:
--   case zero                               -- 기저 (n = 0)
--     ⊢ (3 : Int) ∣ (0^3 - 0)
--   case succ                               -- 양의 방향 (n = k → n = k+1, k : Nat)
--     k : Nat
--     ih : (3 : Int) ∣ ((k : Int)^3 - k)
--     ⊢ (3 : Int) ∣ (((k : Int) + 1)^3 - ((k : Int) + 1))
--   case pred                               -- 음의 방향 (n = -k → n = -k-1, k : Nat)
--     k : Nat
--     ih : (3 : Int) ∣ ((-(k : Int))^3 - (-(k : Int)))
--     ⊢ (3 : Int) ∣ ((-(k : Int) - 1)^3 - (-(k : Int) - 1))
```

세 갈래의 이름은 각각 `zero` (n = 0), `succ` (양의 방향), `pred` (음의 방향)이다. `Nat`의 표준 귀납과 같은 이름 `zero`·`succ`을 공유하며, 정수만의 새 갈래가 `pred`이다.

각 갈래에서 `k`의 타입에 주의한다. `succ`와 `pred` 모두에서 `k : Nat`이다. 즉 자연수가 `Int.induction_on` 안에서 위·아래 두 방향으로 정수에 캐스팅되어 들어가는 구조이다.

---

**`zero` 갈래** `decide`로 즉결. `0^3 - 0 = 0`이고 `3 ∣ 0`은 참.

---

**`succ` 갈래** 코드 6(`three_dvd_n3_add_2n`)와 같은 구조. `key`로 다항식 분해를 `ring`이 검증, `rw [key]`로 목표 다시 쓰기, `dvd_add ih (Dvd.intro _ rfl)`로 두 가분성 결합.

분해 검증.

```
(k+1)^3 - (k+1)
  = k^3 + 3k^2 + 3k + 1 - k - 1
  = k^3 + 3k^2 + 2k
  = (k^3 - k) + (3k^2 + 3k)
  = (k^3 - k) + 3(k^2 + k).
```

---

**`pred` 갈래** 음의 방향의 분해. 학생 자료 §17의 손 펼치기 참조. 핵심은 `dvd_sub`을 쓴다는 것.

```
(-k-1)^3 - (-k-1)
  = -(k+1)^3 + (k+1)
  = -k^3 - 3k^2 - 3k - 1 + k + 1
  = -k^3 - 3k^2 - 2k
  = (-k^3 + k) + (-3k^2 - 3k)
  = ((-k)^3 - (-k)) - 3(k^2 + k).
```

마지막 항이 `+ 3(...)`이 아니라 `- 3(...)`인 점에 주의. 그래서 `dvd_add`가 아니라 `dvd_sub`을 쓴다.

`dvd_sub : a ∣ b → a ∣ c → a ∣ (b - c)`. 정수환에서 자유롭게 작동.

---

**전체 흐름 정리**

| 갈래 | 종이 | Lean 4 |
|---|---|---|
| `zero` | `n = 0`: 0³ − 0 = 0 | `decide` |
| `succ` | `(k+1)³ − (k+1) = (k³ − k) + 3(k² + k)` | `ring` + `dvd_add` |
| `pred` | `(−k−1)³ − (−k−1) = ((−k)³ − (−k)) − 3(k² + k)` | `ring` + `dvd_sub` |

세 갈래가 모두 같은 골격(다항식 분해 → 가분성 결합)을 따른다는 점이 본 정리의 아름다움이다.

---

## 코드 14. `add_comm_nat` - `revert` 기법

**완성 코드 전체**

```lean
import Mathlib

theorem add_comm_nat (n m : Nat) : n + m = m + n := by
  revert m
  induction n with
  | zero =>
    intro m
    simp
  | succ k ih =>
    intro m
    rw [Nat.succ_add]
    rw [ih m]
    rw [Nat.add_succ]
```

**한 줄씩 분석**

```lean
theorem add_comm_nat (n m : Nat) : n + m = m + n := by
```

```
-- AFTER `:= by`:
--   n m : Nat
--   ⊢ n + m = m + n
```

---

```lean
  revert m
```

- WHY: `induction n with` 직전에 `m`을 목표 안으로 밀어 넣어, 두 갈래에서 받는 `ih`가 `∀ m, ...` 형태가 되도록 한다.
- USES: `revert`.

```
-- AFTER `revert m`:
--   n : Nat
--   ⊢ ∀ m, n + m = m + n
```

`m`이 가정 목록에서 사라지고, 목표가 `∀ m, ...` 형태로 바뀌었다.

---

```lean
  induction n with
```

```
-- AFTER:
--   case zero
--     ⊢ ∀ m, 0 + m = m + 0
--   case succ
--     k : Nat
--     ih : ∀ m, k + m = m + k
--     ⊢ ∀ m, (k + 1) + m = m + (k + 1)
```

`ih`가 `∀ m, ...` 형태로 들어왔다. 이것이 강해진 IH이다. 어떤 `m`에 대해서도 작용할 수 있다.

---

```lean
  | zero =>
    intro m
    simp
```

- WHY: 임의의 `m`을 잡고, `0 + m = m + 0`을 닫는다.
- USES: `intro m` (보편 양화 해제). `simp`이 양변을 `m`으로 정리.

```
-- AFTER `intro m`:
--   m : Nat
--   ⊢ 0 + m = m + 0
-- AFTER `simp`:
--   (No goals)
```

---

```lean
  | succ k ih =>
    intro m
```

새 `m`을 잡는다. 그리고 `ih`가 손에 있다 (`∀ m', k + m' = m' + k` 형태로, 실제로는 같은 이름 `m`을 다시 쓰지만 양화 변수와 잡힌 변수의 구분이 자동으로 처리된다).

```
-- AFTER `intro m`:
--   k : Nat
--   ih : ∀ m, k + m = m + k
--   m : Nat
--   ⊢ (k + 1) + m = m + (k + 1)
```

---

```lean
    rw [Nat.succ_add]
```

- WHY: `(k + 1) + m`을 `(k + m) + 1`로 풀어, `ih`가 적용될 수 있는 `k + m` 덩어리를 노출시킨다.
- USES: `Nat.succ_add : (n + 1) + m = (n + m) + 1`.

```
-- AFTER `rw [Nat.succ_add]`:
--   ⊢ (k + m) + 1 = m + (k + 1)
```

---

```lean
    rw [ih m]
```

- WHY: `ih`에 현재의 `m`을 넘겨서 `k + m = m + k`라는 등식을 얻고, 이를 적용해 좌변의 `k + m`을 `m + k`로 치환한다.
- USES: `ih m`. 보편 양화 가정에 인수 넘기기.

```
-- AFTER `rw [ih m]`:
--   ⊢ (m + k) + 1 = m + (k + 1)
```

---

```lean
    rw [Nat.add_succ]
```

- WHY: 우변의 `m + (k + 1)`을 `(m + k) + 1`로 풀어, 양변이 같은 형태가 되도록 한다.
- USES: `Nat.add_succ : n + (m + 1) = (n + m) + 1`.

`rw`는 등식을 좌변 → 우변 방향으로 적용한다. 그러나 여기서는 우변에서 좌변 방향(`Nat.add_succ`의 우변 `(n + m) + 1`을 좌변 `n + (m + 1)`로 거꾸로 적용)을 원하는 것처럼 보일 수 있다. 실제로는 `Nat.add_succ`의 좌변 패턴 `n + (m + 1)` 자체를 목표의 우변에서 찾아 우변 `(n + m) + 1`로 치환한다(이때 `n = m`(목표의), `m`(정리 안의 변수) `= k`).

`rw`는 패턴이 어디에 있든 첫 번째 일치를 치환한다. 목표 `(m + k) + 1 = m + (k + 1)`에서 `Nat.add_succ`의 패턴 `n + (m + 1)`은 우변의 `m + (k + 1)`에서 정확히 일치한다(`n` 자리에 `m`이, `m` 자리에 `k`가 들어감). 이를 우변의 `(n + m) + 1` 형태인 `(m + k) + 1`로 치환한다.

```
-- AFTER `rw [Nat.add_succ]`:
--   ⊢ (m + k) + 1 = (m + k) + 1
--   (자동 닫힘, No goals)
```

---

**전체 흐름 정리**

| 줄 | 종이 | Lean 4 |
|---|---|---|
| `revert m` | "m에 의존하는 임의 명제로 강화" | — |
| `induction n with` | `n`에 대해 귀납 | — |
| `\| zero => intro m; simp` | "임의 m을 잡고 0 + m = m + 0 확인" | — |
| `\| succ k ih => intro m; ...` | "임의 m을 잡고, k에 대한 강한 IH를 디딤돌로" | — |
| `rw [Nat.succ_add]` | "(k+1)+m = (k+m)+1" | — |
| `rw [ih m]` | "IH로 k+m = m+k 치환" | — |
| `rw [Nat.add_succ]` | "m+(k+1) = (m+k)+1" | 양변이 같아져 닫힘 |

`revert`/`intro` 한 쌍이 IH의 강도를 결정한다는 것이 본 코드의 핵심 교훈이다.

---

## 부록. `Dvd.intro`와 `Dvd.dvd.mul_left` 사용법 정리

본 자료에서 두 번 등장한 가분성 구성·증대 표현을 한 곳에 정리한다.

**`Dvd.intro c h : a ∣ b`** "`b = a * c`라는 증인 `h : b = a * c`(또는 형태에 따라 약간 다른 형태)를 제시하면 `a ∣ b`가 구성된다." 우리 코드에서는 `Dvd.intro (k^2 + k + 1) rfl`처럼 사용했다. 증인은 `k^2 + k + 1`, 증인 등식은 `rfl`(양변이 정의상 같음).

**`Dvd.dvd.mul_left h c : a ∣ (c * b)`** "`h : a ∣ b`를 받아 `a ∣ (c * b)`로 확장한다." 코드 7에서 `Dvd.dvd.mul_left ih 11`로 `ih : 7 ∣ (11^k - 4^k)`를 `7 ∣ 11 * (11^k - 4^k)`로 확장했다.

비슷한 짝꿍 정리 `Dvd.dvd.mul_right h c : a ∣ (b * c)`도 있다. 곱의 어느 쪽에 가분성이 작동하느냐에 따라 둘 중 하나를 선택한다.

---
## 마무리

본 코드 설명 자료에서 다룬 열네 개 코드를 모두 정리하면 다음과 같다.

| 번호 | 정리 이름 | 한 줄 설명 |
|---|---|---|
| 1 | `zero_add_nat` | `0 + n = n` (기본 induction + `rw`) |
| 2 | `add_zero_nat` | `n + 0 = n` (거울 쌍둥이) |
| 3 | `sum_odd_eq_sq` | 처음 n개 홀수의 합 = n² |
| 4 | `two_mul_sum_range` | 가우스 합 (linarith 버전) |
| 5 | `n_lt_two_pow` | `n < 2ⁿ` (`Nat.le_induction` from 1) |
| 6 | `three_dvd_n3_add_2n` | `3 ∣ (n³ + 2n)` 자연수 |
| 7 | `seven_dvd_11n_sub_4n` | `7 ∣ (11ⁿ − 4ⁿ)` 정수 |
| 8 | `sum_sq` | 제곱합 (양변 6배, ring) |
| 9 | `sum_cube` | 세제곱합 (양변 4배, ring) |
| 10 | `geom_sum` | 등비급수 (field_simp + ring) |
| 11 | `pow_two_lt_fac` | `2ⁿ < n!` (`Nat.le_induction` from 4) |
| 12 | `bernoulli` | 베르누이 부등식 (push_cast + gcongr) |
| 13 | `div3_n3_sub_n_int` | `3 ∣ (n³ − n)` 정수, 세 갈래 |
| 14 | `add_comm_nat` | 자연수 덧셈 교환 법칙 (`revert` 기법) |

본 14개 코드를 모두 직접 자기 편집기에 입력해서 InfoView가 본 문서의 기록과 한 줄씩 같게 변하는지 확인한다. 차이가 있다면 그 자리에서 멈추고 원인을 추적한다.

§5.2의 강한 귀납법 자료에서 다시 만난다.
