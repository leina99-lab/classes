# Rosen Chapter 3 — Lean 4 전체 코드 완전 해설

> **대상**: Lean 4를 처음 배우는 학습자
> **원칙**: 모든 기호와 키워드를 한 줄도 빠짐없이 설명한다.
> **표기**: **한글**(영문) 형식으로 용어를 표기한다.

---

## 파일 구조

| 섹션 | 내용 |
|------|------|
| 1 | 기본 함수 정의 |
| 2 | 패턴 매칭과 재귀 |
| 3 | 자연수 연산 |
| 4 | 리스트 함수 |
| 5 | 최댓값 찾기 |
| 6 | 선형 탐색 |
| 7 | 이진 탐색 |
| 8 | 버블 정렬 |
| 9 | 삽입 정렬 |
| 10 | 욕심쟁이 알고리즘 |
| 11 | 증명: **빅오**(Big-O) |

---

## 기호 사전

코드 전체에서 반복적으로 등장하는 기호이다. 먼저 외워두면 해설이 훨씬 빠르게 읽힌다.

| 기호 | 이름 | 의미 |
|------|------|------|
| **`:=`** | **정의 대입**(definition assignment) | "이렇게 정의한다" |
| **`=>`** | **매핑 화살표**(match arrow) | "이 패턴이면 이 결과를 내라" |
| **`→`** | **함의 화살표**(implication arrow) | "이면" (논리 또는 함수 타입) |
| **`←`** | **역방향 화살표**(reverse arrow) | `rw`에서 역방향 적용 |
| **`↔`** | **쌍방향 화살표**(iff arrow) | "필요충분조건" |
| **`≥`** | **크거나 같음**(greater or equal) | `a ≥ b`는 `b ≤ a` |
| **`≤`** | **작거나 같음**(less or equal) | `a ≤ b` |
| **`×`** | **곱 타입**(product type) | `Nat × Nat`은 자연수 쌍 |
| **`⟨ ⟩`** | **꺾쇠 괄호**(angle brackets) | 구조체/존재 목격자 묶음 |
| **`_`** | **와일드카드**(wildcard) | "어떤 것이든 상관없다" |
| **`[]`** | **빈 리스트**(empty list) | 원소가 없는 리스트 |
| **`::`** | **콘스**(cons) | `a :: as`는 첫 원소 `a`와 나머지 `as` |
| **`++`** | **이어붙이기**(append) | 두 리스트를 연결 |
| **`!`** | **강제 접근**(force access) | `arr[i]!`는 범위 검사 없이 접근 |
| **`∃`** | **존재 한정자**(existential) | "어떤 것이 존재한다" |
| **`∀`** | **전칭 한정자**(universal) | "모든 것에 대해" |
| **`⊢`** | **증명 목표**(turnstile) | 현재 증명해야 할 명제 |
| **`·`** | **점 불릿**(bullet) | `constructor` 등으로 나뉜 분기를 표시 |

---

---

# 섹션 1. 기본 함수 정의

---

## 1-1. 두 수 더하기

```lean4
def myAdd (a b : Nat) : Nat := a + b
#eval myAdd 3 5  -- 8
```

**`def`** — "함수를 정의한다"는 키워드이다.

**`myAdd`** — 함수 이름. 마음대로 지을 수 있다.

**`(a b : Nat)`** — 인자(parameter). `a`와 `b`는 둘 다 **자연수**(Nat) 타입이다. 괄호 안에 같은 타입의 인자를 나란히 쓸 수 있다.

**`: Nat`** — 반환 타입. 이 함수는 자연수를 반환한다.

**`:= a + b`** — 함수 몸통. `a + b`를 계산해서 반환한다.

**`#eval`** — "이 식을 계산해서 결과를 보여라"는 명령이다. Python의 `print()`와 같다.

---

## 1-2. 짝수 판별

```lean4
def isEven (n : Nat) : Bool := n % 2 == 0
#eval isEven 4   -- true
#eval isEven 7   -- false
```

**`Bool`** — 참/거짓 타입. `true` 또는 `false`만 가능하다.

**`%`** — **나머지 연산자**(modulo). `n % 2`는 n을 2로 나눈 나머지이다.

**`==`** — **등호 비교**(equality check). 값이 같은지 확인한다. 수학의 `=`과 달리 Bool을 반환한다.

**`= 0`** — 나머지가 0이면 `true`, 아니면 `false`.

---

## 1-3. 두 배

```lean4
def double (n : Nat) : Nat := n * 2
```

**`*`** — **곱하기**(multiplication). Lean 4에서 자연수 곱셈 기호이다.

---

---

# 섹션 2. 패턴 매칭과 재귀

---

## 2-1. 패턴 매칭

```lean4
def describe (n : Nat) : String :=
  match n with
  | 0 => "영"
  | 1 => "일"
  | _ => "기타"
```

**`String`** — 문자열 타입이다.

**`match n with`** — `n`의 값을 보고 경우를 나눈다. Python의 `match`/`switch`와 같다.

**`| 0 =>`** — `n`이 0인 경우. **`|`**(파이프)는 각 경우를 구분한다.

**`| _ =>`** — **와일드카드**(wildcard). 앞의 경우에 해당하지 않는 나머지 모든 경우이다.

---

## 2-2. 재귀 함수 — 팩토리얼

```lean4
def factorial : Nat → Nat
  | 0     => 1
  | n + 1 => (n + 1) * factorial n
```

**`Nat → Nat`** — 자연수를 받아 자연수를 반환하는 함수 타입이다. **`→`**(화살표)는 함수 타입을 나타낸다.

**`| 0 => 1`** — **기저 단계**(base case). n이 0이면 1을 반환한다.

**`| n + 1 =>`** — **귀납 단계**(inductive step). n+1 형태의 입력. 이때 `n`은 "한 단계 작은 값"을 뜻한다.

**`factorial n`** — **재귀 호출**(recursive call). 자기 자신을 더 작은 값으로 호출한다.

Lean 4에서 재귀는 반드시 종료되어야 한다. `n + 1` 패턴에서 `n`으로 줄어드는 것이 명확하므로 자동으로 종료가 인정된다.

---

---

# 섹션 3. 자연수 연산

---

## 3-1. 곱셈 (재귀)

```lean4
def myMul : Nat → Nat → Nat
  | _, 0     => 0
  | n, m + 1 => n + myMul n m
```

**`Nat → Nat → Nat`** — 자연수 두 개를 받아 자연수를 반환한다. **`→`**가 여러 개이면 인자가 여러 개이다.

**`| _, 0 =>`** — 두 번째 인자가 0인 경우. 첫 번째 인자는 **`_`**(와일드카드)로 무시한다. 곱셈에서 n × 0 = 0이다.

**`| n, m + 1 =>`** — 두 번째 인자가 m+1인 경우. n × (m+1) = n + n × m이다.

---

## 3-2. 거듭제곱 (재귀)

```lean4
def myPow : Nat → Nat → Nat
  | _, 0     => 1
  | b, e + 1 => b * myPow b e
```

`b`는 **밑수**(base), `e`는 **지수**(exponent)이다. b^0 = 1, b^(e+1) = b × b^e.

---

---

# 섹션 4. 리스트 함수

---

## 4-1. 합계

```lean4
def mySum : List Nat → Nat
  | []      => 0
  | a :: as => a + mySum as
```

**`List Nat`** — 자연수들의 리스트 타입이다.

**`| [] =>`** — 빈 리스트인 경우. 합계는 0이다.

**`| a :: as =>`** — **`a`**는 첫 번째 원소, **`as`**는 나머지 리스트이다. **`::`**(콘스)는 리스트를 머리와 꼬리로 분해한다.

**`a + mySum as`** — 첫 원소와 나머지 합계를 더한다.

---

## 4-2. 길이

```lean4
def myLen : List Nat → Nat
  | []      => 0
  | _ :: as => 1 + myLen as
```

**`_ :: as`** — 첫 원소는 값이 필요 없으므로 **`_`**로 무시하고, 나머지 `as`만 쓴다.

---

## 4-3. 멤버십 확인

```lean4
def myMem (x : Nat) : List Nat → Bool
  | []      => false
  | a :: as => if a == x then true else myMem x as
```

**`if ... then ... else ...`** — **조건식**(if expression). Lean 4에서 `if`는 문장이 아니라 값을 반환하는 표현식이다.

**`a == x`** — `a`와 `x`가 같으면 `true`, 다르면 재귀적으로 확인한다.

---

---

# 섹션 5. 최댓값 찾기

---

## 5-1. myMax 정의

```lean4
def myMax : List Nat → Nat
  | []      => 0
  | [a]     => a
  | a :: rest =>
    let m := myMax rest
    if a >= m then a else m
```

**`| [a] =>`** — 원소가 딱 하나인 리스트 패턴이다. `[a]`는 `a :: []`의 줄임이다.

**`| a :: rest =>`** — 원소가 둘 이상인 경우. 첫 원소 `a`와 나머지 `rest`로 분해한다.

**`let m := myMax rest`** — **지역 변수**(local variable) 선언. `rest`의 최댓값을 `m`에 저장한다.

**`if a >= m then a else m`** — `a`가 `m` 이상이면 `a`를 반환하고, 아니면 `m`을 반환한다.

---

## 5-2. 비교 횟수 포함 버전

```lean4
def maxWithCount : List Nat → Nat × Nat
  | []      => (0, 0)
  | [a]     => (a, 0)
  | a :: as =>
    let (m, c) := maxWithCount as
    if a >= m then (a, c + 1) else (m, c + 1)
```

**`Nat × Nat`** — 자연수 쌍 타입이다. **`×`**는 **곱 타입**(product type)이다.

**`(0, 0)`** — 쌍(pair) 리터럴이다. 첫 번째는 최댓값, 두 번째는 비교 횟수이다.

**`let (m, c) := maxWithCount as`** — **구조 분해 할당**(destructuring). 반환된 쌍을 `m`과 `c`로 분해한다.

**`(a, c + 1)`** — 최댓값과 비교 횟수+1을 쌍으로 반환한다.

---

---

# 섹션 6. 선형 탐색

---

## 6-1. 인덱스 반환 버전

```lean4
def linearSearch (x : Nat) : List Nat → Nat → Nat
  | [], _       => 0
  | a :: as, i  =>
    if a == x then i
    else linearSearch x as (i + 1)
```

**`List Nat → Nat → Nat`** — 리스트와 현재 인덱스를 받아 찾은 인덱스를 반환한다.

**`| [], _ =>`** — 빈 리스트. 못 찾았으므로 0을 반환한다.

**`| a :: as, i =>`** — 패턴에 인자가 두 개 있다. `a :: as`는 리스트, `i`는 현재 인덱스이다.

**`linearSearch x as (i + 1)`** — 못 찾았으면 나머지 리스트에서 인덱스를 하나 올려서 재귀한다.

---

## 6-2. Option 반환 버전

```lean4
def linearSearch [BEq a] (x : a)
    : List a → Option Nat
  | []      => none
  | a :: as =>
    if a == x then some 0
    else match linearSearch x as with
      | none   => none
      | some i => some (i + 1)
```

**`[BEq a]`** — **타입 클래스 인스턴스**(type class instance). `a` 타입이 **`==`** 비교를 지원해야 한다는 조건이다. 대괄호 `[ ]`는 암묵적 인자이다.

**`Option Nat`** — 찾으면 **`some 인덱스`**, 못 찾으면 **`none`**을 반환하는 타입이다. 실패 가능성을 타입으로 표현한다.

**`some 0`** — 현재 위치(0)에서 찾았다는 의미이다.

**`match linearSearch x as with`** — 재귀 결과를 다시 패턴 매칭한다.

**`| some i => some (i + 1)`** — 나머지에서 인덱스 `i`에서 찾았으면, 현재 위치를 고려해 `i + 1`로 반환한다.

---

---

# 섹션 7. 이진 탐색

---

## 7-1. fuel 방식

```lean4
def binarySearch (arr : Array Nat) (x : Nat) : Option Nat :=
  go (arr.size + 1) 0 (arr.size - 1)
where
  go (fuel lo hi : Nat) : Option Nat :=
    match fuel with
    | 0     => none
    | n + 1 =>
      if lo > hi then none
      else
        let mid := (lo + hi) / 2
        let v   := arr[mid]!
        if v == x       then some mid
        else if v < x   then go n (mid + 1) hi
        else if mid == 0 then none
        else                 go n lo (mid - 1)
```

**`Array Nat`** — **배열**(Array) 타입. 리스트와 달리 인덱스 접근이 빠르다 O(1).

**`arr.size`** — 배열의 원소 개수이다. `.size`는 **필드 접근**(field access) 문법이다.

**`go (arr.size + 1) 0 (arr.size - 1)`** — 내부 함수 `go`를 호출한다. `fuel`(연료), `lo`(왼쪽 끝), `hi`(오른쪽 끝)을 전달한다.

**`where`** — 함수 안에서만 쓰는 보조 함수를 정의하는 키워드이다.

**`match fuel with`** — **`fuel`**은 재귀 횟수를 제한하는 연료이다. 매 재귀마다 1씩 줄어서 종료를 보장한다.

**`| 0 => none`** — 연료가 다 떨어졌다는 것은 배열 크기를 초과했다는 뜻이다. 실제로는 발생하지 않지만 Lean 4의 종료 증명을 위해 필요하다.

**`let mid := (lo + hi) / 2`** — **중간 인덱스**(middle index). 왼쪽 끝과 오른쪽 끝의 평균이다.

**`arr[mid]!`** — 인덱스 `mid`의 값에 접근한다. **`!`**는 범위 검사를 건너뛰는 강제 접근이다.

**`go n (mid + 1) hi`** — v가 x보다 작으면 오른쪽 절반을 탐색한다. `fuel`은 `n`으로 1 감소한다.

**`go n lo (mid - 1)`** — v가 x보다 크면 왼쪽 절반을 탐색한다.

---

## 7-2. termination_by 방식

```lean4
def binarySearch (x : Nat) (arr : Array Nat)
    (lo hi : Nat) : Nat :=
  if h : lo < hi then
    let mid := (lo + hi) / 2
    if arr[mid]! == x then mid + 1
    else if arr[mid]! < x then
      binarySearch x arr (mid + 1) hi
    else
      binarySearch x arr lo mid
  else 0
termination_by hi - lo
```

**`if h : lo < hi then`** — **명명된 조건**(named condition). 조건 `lo < hi`에 이름 `h`를 붙인다. `h`는 then 블록 안에서 증명으로 쓸 수 있다.

**`termination_by hi - lo`** — 종료 측도를 명시한다. `hi - lo`가 매 재귀마다 감소함을 Lean에게 알린다.

---

---

# 섹션 8. 버블 정렬

---

## 8-1. arraySwap

```lean4
private def arraySwap (a : Array Nat) (i j : Nat) : Array Nat :=
  let vi := a[i]!
  let vj := a[j]!
  a.set! i vj |>.set! j vi
```

**`private`** — 이 파일 안에서만 사용 가능한 함수이다. 외부에서 직접 호출할 수 없다.

**`let vi := a[i]!`** — 교환 전에 두 값을 먼저 꺼내 저장한다. 먼저 저장하지 않으면 첫 번째 `set!` 이후 원래 값이 사라진다.

**`a.set! i vj`** — 인덱스 `i` 위치에 `vj`를 쓴다.

**`|>`** — **파이프 연산자**(pipe operator). 왼쪽 결과를 오른쪽 함수의 첫 인자로 넘긴다. `f(g(x))`를 `g(x) |> f`로 쓸 수 있다.

**`.set! j vi`** — 앞 결과 배열에서 인덱스 `j` 위치에 `vi`를 쓴다.

---

## 8-2. bubblePass

```lean4
private def bubblePass (a : Array Nat) (n : Nat) : Array Nat :=
  go a 0
where
  go (curr : Array Nat) (i : Nat) : Array Nat :=
    if i + 1 < n then
      let curr' := if curr[i]! > curr[i+1]!
                   then arraySwap curr i (i+1)
                   else curr
      go curr' (i + 1)
    else curr
  termination_by n - i
  decreasing_by omega
```

**`curr'`** — 변수 이름에 **`'`**(프라임)를 붙이는 것은 "이전 값의 업데이트된 버전"을 나타내는 관례이다.

**`termination_by n - i`** — `n - i`가 종료 측도이다. `i`가 커질수록 `n - i`는 작아진다.

**`decreasing_by omega`** — Lean이 감소를 자동으로 증명하지 못할 때, **`omega`** 전술로 직접 증명한다. `omega`는 선형 산술 부등식을 자동 처리한다.

---

## 8-3. bubbleSort

```lean4
def bubbleSort (arr : Array Nat) : Array Nat :=
  go arr arr.size
where
  go (a : Array Nat) : Nat → Array Nat
    | 0     => a
    | n + 1 => go (bubblePass a (n + 1)) n
```

**`| 0 => a`** — n이 0이면 정렬 완료. 배열을 그대로 반환한다.

**`| n + 1 => go (bubblePass a (n + 1)) n`** — 한 번의 패스를 수행하고, n을 1 줄여서 재귀한다. 패턴 매칭으로 감소가 구조적으로 명확하므로 **`termination_by`**가 불필요하다.

---

---

# 섹션 9. 삽입 정렬

---

```lean4
def myInsert (x : Nat) : List Nat → List Nat
  | []      => [x]
  | a :: as =>
    if x ≤ a then x :: a :: as
    else a :: myInsert x as

def insertionSort : List Nat → List Nat
  | []      => []
  | a :: as => myInsert a (insertionSort as)
```

**`myInsert`** — 이름이 `insert`이면 Lean 4 내장 **`Insert.insert`**와 충돌하므로 `myInsert`로 이름을 바꾼다.

**`[x]`** — 원소 하나짜리 리스트이다. `x :: []`의 줄임이다.

**`x :: a :: as`** — x를 맨 앞에 붙인 리스트이다. x가 a보다 작거나 같으면 이미 올바른 위치이다.

**`a :: myInsert x as`** — a를 앞에 두고, 나머지에 x를 재귀적으로 삽입한다.

**`myInsert a (insertionSort as)`** — 먼저 `as`를 정렬하고, 거기에 `a`를 삽입한다.

---

---

# 섹션 10. 욕심쟁이 알고리즘

---

```lean4
def greedyChange (coins : List Nat) (amount : Nat)
    : List (Nat × Nat) :=
  go coins amount []
where
  go : List Nat → Nat → List (Nat × Nat)
      → List (Nat × Nat)
  | [], _, acc        => acc
  | _, 0, acc         => acc
  | c :: cs, rem, acc =>
    let count := rem / c
    go cs (rem % c) (acc ++ [(c, count)])
```

**`List (Nat × Nat)`** — 자연수 쌍들의 리스트이다. 각 쌍은 `(동전 단위, 사용 개수)`이다.

**`go coins amount []`** — 내부 함수 `go`를 시작한다. 빈 리스트 `[]`는 결과를 쌓을 누적기이다.

**`go : List Nat → Nat → List (Nat × Nat) → List (Nat × Nat)`** — `go`의 타입 시그니처이다. 인자가 셋이고 리스트를 반환한다.

**`| [], _, acc =>`** — 동전 리스트가 비었다. 지금까지 쌓인 결과 `acc`를 반환한다.

**`| _, 0, acc =>`** — 남은 금액이 0이다. 결과를 반환한다.

**`| c :: cs, rem, acc =>`** — `c`는 현재 동전 단위, `cs`는 나머지 동전들, `rem`은 남은 금액이다.

**`let count := rem / c`** — 이 동전을 몇 개 쓸 수 있는지 계산한다.

**`go cs (rem % c) (acc ++ [(c, count)])`** — 나머지 금액과 업데이트된 결과로 재귀한다.

**`acc ++ [(c, count)]`** — 현재 결과에 새 쌍을 이어붙인다. **`++`**는 리스트 이어붙이기이다.

---

---

# 섹션 11. BigO 형식 정의와 증명

---

## 11-1. BigO 정의

```lean4
def BigO (f g : Nat → Nat) : Prop :=
  ∃ C : Nat, ∃ k : Nat, C > 0 ∧
    ∀ n : Nat, n > k → f n ≤ C * g n
```

**`(f g : Nat → Nat)`** — `f`와 `g`는 자연수를 받아 자연수를 반환하는 함수이다.

**`: Prop`** — 이 정의는 참/거짓이 있는 **명제**(Proposition)를 반환한다.

**`∃ C : Nat`** — "어떤 자연수 C가 존재하여"라는 뜻이다.

**`∃ k : Nat`** — "어떤 자연수 k가 존재하여"라는 뜻이다.

**`C > 0 ∧`** — C가 양수이고(이 조건과 다음 조건이 **`∧`**(and)로 연결된다).

**`∀ n : Nat, n > k →`** — "모든 자연수 n에 대해, n이 k보다 크면"이라는 뜻이다.

**`f n ≤ C * g n`** — `f(n) ≤ C × g(n)`이 성립한다.

---

## 11-2. 선형 BigO 증명

```lean4
theorem linear_bigO :
    BigO (fun n => 3 * n + 5) (fun n => n) := by
  use 4, 5
  constructor
  · exact Nat.succ_pos 3
  · intro n hn
    show 3 * n + 5 ≤ 4 * n
    have h5n : 5 ≤ n := Nat.le_of_lt hn
    calc 3 * n + 5
        ≤ 3 * n + n := Nat.add_le_add_left h5n (3 * n)
      _ = 4 * n     := (Nat.succ_mul 3 n).symm
```

**`theorem`** — 수학적 정리를 선언한다. **`def`**와 달리 명제의 증명이다.

**`fun n => 3 * n + 5`** — **익명 함수**(anonymous function). "n을 받아 3n+5를 반환하는 함수"이다. Python의 `lambda n: 3*n+5`와 같다.

**`:= by`** — **전술 모드**(tactic mode)로 증명을 시작한다.

**`use 4, 5`** — **`∃`** 명제의 목격자를 제시한다. C = 4, k = 5로 놓겠다는 뜻이다.

**`constructor`** — **`∧`**(and) 목표를 두 개로 분리한다. **`·`** 두 개로 각각 증명한다.

**`· exact Nat.succ_pos 3`** — 첫 번째 목표(4 > 0)를 증명한다. **`Nat.succ_pos 3`**은 "Nat.succ 3 = 4 > 0"이라는 사실이다. **`exact`**는 목표와 정확히 일치하는 항을 제시한다.

**`· intro n hn`** — 두 번째 목표에서 `n`과 가정 `hn : n > 5`를 도입한다.

**`show 3 * n + 5 ≤ 4 * n`** — 람다를 전개하여 목표를 명시적으로 나타낸다.

**`have h5n : 5 ≤ n := Nat.le_of_lt hn`** — **보조 사실**(have). `hn : n > 5`에서 `5 ≤ n`을 유도한다.

**`calc`** — **계산식 증명**(calculation proof). 여러 단계의 등식/부등식을 연결한다.

**`≤ 3 * n + n := Nat.add_le_add_left h5n (3 * n)`** — `3n + 5 ≤ 3n + n`. 왼쪽에 같은 것을 더하면 부등호 방향이 유지된다.

**`_ = 4 * n := (Nat.succ_mul 3 n).symm`** — `3n + n = 4n`. **`.symm`**은 등식의 양변을 뒤집는다.

---

## 11-3. 이차 BigO 증명

```lean4
theorem quad_bigO :
    BigO (fun n => 5*n^2 + 3*n + 7) (fun n => n^2) := by
  use 6, 7
  constructor
  · exact Nat.succ_pos 5
  · intro n hn
    show 5 * n^2 + 3 * n + 7 ≤ 6 * n^2
    nlinarith [sq_nonneg n, Nat.mul_le_mul_right n hn]
```

**`n^2`** — n의 제곱이다. **`^`**는 **거듭제곱 연산자**(exponentiation)이다.

**`nlinarith`** — **비선형 산술 전술**(nonlinear arithmetic tactic). `n^2`가 포함된 비선형 부등식을 자동으로 처리한다. `omega`는 선형만 처리하므로 이 경우에는 `nlinarith`가 필요하다.

**`[sq_nonneg n, Nat.mul_le_mul_right n hn]`** — `nlinarith`에게 힌트를 준다. `sq_nonneg n : 0 ≤ n^2`와 `Nat.mul_le_mul_right n hn`을 사용하라는 뜻이다.

---

## 11-4. BigOmega, BigTheta

```lean4
def BigOmega (f g : Nat → Nat) : Prop :=
  ∃ C : Nat, ∃ k : Nat, C > 0 ∧
    ∀ n : Nat, n > k → f n ≥ C * g n

def BigTheta (f g : Nat → Nat) : Prop :=
  BigO f g ∧ BigOmega f g
```

**`f n ≥ C * g n`** — **`≥`**(크거나 같음). BigOmega는 하한이므로 부등호 방향이 반대이다.

**`BigO f g ∧ BigOmega f g`** — BigTheta는 BigO와 BigOmega를 **동시에** 만족하는 것이다.

---

## 11-5. linear_theta 증명

```lean4
theorem linear_theta :
    BigTheta (fun n => 3*n+5) (fun n => n) := by
  constructor
  · use 4, 5; constructor; · nlinarith
    · intro n hn; nlinarith
  · use 3, 0; constructor; · nlinarith
    · intro n hn; nlinarith
```

**`constructor`** — `BigTheta = BigO ∧ BigOmega`이므로 두 방향으로 분리한다.

**`use 4, 5`** — BigO 방향: C = 4, k = 5.

**`use 3, 0`** — BigOmega 방향: C = 3, k = 0. 모든 n에서 3n+5 ≥ 3n이 성립한다.

**`;`** — 여러 전술을 한 줄에 쓸 때 **`;`**(세미콜론)으로 연결한다.

---

## 11-6. sum_rule 합산 규칙

```lean4
theorem sum_rule (h1 : BigO f1 g) (h2 : BigO f2 g) :
    BigO (fun n => f1 n + f2 n) g := by
  obtain ⟨C1, k1, hC1, h1⟩ := h1
  obtain ⟨C2, k2, hC2, h2⟩ := h2
  use C1 + C2, max k1 k2; constructor; · omega
  · intro n hn
    have := h1 n (by omega)
    have := h2 n (by omega)
    nlinarith
```

**`obtain ⟨C1, k1, hC1, h1⟩ := h1`** — **`∃`** 가정에서 목격자와 증명을 꺼낸다. `h1`이 `∃ C k, ...`이므로 C1, k1, hC1, h1로 분해한다.

**`use C1 + C2, max k1 k2`** — 두 함수의 상수를 합한 것이 새 C이고, 두 k 중 큰 것이 새 k이다.

**`max k1 k2`** — k1과 k2 중 큰 값이다.

**`have := h1 n (by omega)`** — `h1`에 `n`을 적용한다. `by omega`는 `n > k1` 조건을 자동으로 증명한다.

**`nlinarith`** — `f1 n + f2 n ≤ C1*g n + C2*g n = (C1+C2)*g n`을 자동으로 처리한다.

---

---

# 전술 완전 요약표

| 전술 | 언제 쓰는가 | 예시 |
|------|-----------|------|
| **`rfl`** | 양변이 정의상 같을 때 | `3 + 4 = 7` |
| **`omega`** | 선형 산술 부등식 | `n + 1 > n` |
| **`nlinarith`** | 비선형 부등식 (n² 포함) | `n² + 2n + 1 ≤ 4n²` |
| **`simp`** | 자동 간단화 | `0 + n = n` |
| **`exact`** | 목표와 정확히 일치하는 항 | `exact h` |
| **`intro`** | 가정을 도입 | `intro n hn` |
| **`apply`** | 결론이 목표와 일치하는 정리 | `apply Nat.le_trans` |
| **`rw`** | 등식으로 목표를 변환 | `rw [h]` |
| **`use`** | 존재 목격자 제시 | `use 4, 5` |
| **`constructor`** | ∧ 또는 ↔ 목표를 분리 | `constructor` |
| **`obtain`** | 존재 가정에서 목격자 추출 | `obtain ⟨C, k, hC, h⟩ := h1` |
| **`have`** | 보조 사실 추가 | `have h : 5 ≤ n := ...` |
| **`show`** | 목표를 동치 형태로 명시 | `show 3*n+5 ≤ 4*n` |
| **`calc`** | 단계별 계산 | `calc a ≤ b := ... _ = c := ...` |
| **`cases`** | 경우 분리 | `cases h with` |
| **`induction`** | 귀납법 시작 | `induction L with` |
| **`split`** | if-then-else 목표 분리 | `split` |
| **`rename_i`** | 자동 도입된 가정에 이름 붙이기 | `rename_i hge` |
| **`simp at h`** | 가정을 자동 간단화 | `simp at h` |
| **`rw [...] at h`** | 가정을 변환 | `rw [List.mem_cons] at h` |
