# 유클리드의 무한 소수 정리 — Lean 4 형식화 설명

이 문서는 유클리드의 소수 무한성 정리를 Lean 4에서 형식화한 코드의 각 단계를 손증명과 연결하여 설명한 것이다. 핵심 아이디어는 다음과 같다.

> 임의의 자연수 `N`에 대하여 `Q = N! + 1`을 잡고, `Q`의 최소 소인수 `p`를 선택한다.  
> 만약 `p ≤ N`이라면 `p`는 `N!`을 나누고, 동시에 `N! + 1`도 나눈다.  
> 따라서 `p`는 두 수의 차이인 `1`을 나누어야 하는데, 이는 `p`가 소수라는 사실과 모순이다.  
> 그러므로 `p > N`이며, 특히 `N ≤ p`인 소수가 존재한다.

---
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
  
  -- p < N 이 아니라 N ≤ p 임을 증명 (귀류법)
  -- Nat.lt_of_not_le (fun h : p ≤ N => ...) 를 사용하여 p ≤ N 이면 False임을 보임
  exact (Nat.lt_of_not_le (fun h : p ≤ N => 
    -- p ≤ N 이면 p는 N!의 약수이다
    have h_p_div_fact : p ∣ Nat.factorial N := Nat.dvd_factorial (Nat.Prime.pos hp_prime) h
    
    -- p는 Q의 소인수이므로 Q를 나눈다
    have h_p_div_Q : p ∣ Q := by
      rw [hp]
      exact Nat.minFac_dvd Q
    
    -- p가 N!과 N! + 1을 모두 나누면 1도 나누어야 함 (모순의 핵심)
    have h_p_div_one : p ∣ 1 := by
      rw [hQ] at h_p_div_Q
      exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
      
    -- 소수가 1을 나누는 것은 불가능함
    show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
  )).le
```
---
## 0. 정리의 의미

Lean 코드의 정리문은 다음과 같다.

```lean
theorem my_infinite_primes (N : Nat) : ∃ p, N ≤ p ∧ Nat.Prime p := by
```

이 명제는 다음 수학적 진술을 의미한다.

> 임의의 자연수 `N`에 대하여, `N` 이상인 소수 `p`가 존재한다.

이는 소수가 무한히 많다는 명제와 본질적으로 동치이다. 임의의 자연수 `N`보다 크거나 같은 소수가 항상 존재한다면, 소수의 개수는 유한할 수 없기 때문이다.

---

## 1. `Q = N! + 1`을 정의하는 단계

Lean 코드는 다음과 같다.

```lean
set Q := Nat.factorial N + 1 with hQ
```

이는 손증명에서 다음과 같은 정의에 해당한다.

> `Q = N! + 1`이라고 두자.

여기서 `Nat.factorial N`은 수학적 표기 `N!`에 해당한다. `set Q := ... with hQ`는 새로운 기호 `Q`를 도입하면서, 동시에 다음 등식을 `hQ`라는 이름으로 저장한다.

```lean
hQ : Q = Nat.factorial N + 1
```

따라서 이후 증명에서 `Q`를 다시 `N! + 1`로 전개해야 할 경우 `rw [hQ]`를 사용할 수 있다.

---

## 2. `Q ≥ 2`임을 보이는 단계

Lean 코드는 다음과 같다.

```lean
have hQ_ge : 2 ≤ Q := by
  rw [hQ]
  have := Nat.factorial_pos N
  omega
```

이는 손증명에서 다음 논증에 해당한다.

> 모든 자연수 `N`에 대하여 `N! > 0`이다.  
> 따라서 `N! ≥ 1`이고, `Q = N! + 1 ≥ 2`이다.

이 단계의 목적은 `Q`가 소인수를 가질 수 있는 자연수임을 확보하는 것이다. 자연수 `1`은 소인수를 갖지 않으므로, 최소 소인수를 사용하기 위해서는 `Q ≠ 1`, 더 강하게는 `Q ≥ 2`임을 보여야 한다.

각 줄의 의미는 다음과 같다.

```lean
rw [hQ]
```

이 줄은 목표식에 등장하는 `Q`를 `Nat.factorial N + 1`로 치환한다. 즉, 목표는 다음과 같은 형태로 바뀐다.

```lean
2 ≤ Nat.factorial N + 1
```

다음 줄은 다음과 같다.

```lean
have := Nat.factorial_pos N
```

이는 `N! > 0`이라는 표준 정리를 가져오는 부분이다.

마지막 줄은 다음과 같다.

```lean
omega
```

`omega`는 자연수 및 정수의 선형 산술 명제를 자동으로 처리하는 tactic이다. 여기서는 `N! > 0`으로부터 `2 ≤ N! + 1`을 도출한다.

---

## 3. `Q`의 최소 소인수 `p`를 선택하는 단계

Lean 코드는 다음과 같다.

```lean
set p := Nat.minFac Q with hp
have hp_prime : Nat.Prime p := Nat.minFac_prime (by omega)
```

이는 손증명에서 다음 논증에 해당한다.

> `p`를 `Q`의 최소 소인수라고 두자.  
> 그러면 `p`는 소수이다.

`Nat.minFac Q`는 자연수 `Q`의 최소 인수를 나타내며, `Q ≥ 2`인 경우에는 `Q`의 최소 소인수로 작동한다.

```lean
set p := Nat.minFac Q with hp
```

이 줄은 `p`를 `Nat.minFac Q`로 정의하고, 다음 등식을 `hp`라는 이름으로 저장한다.

```lean
hp : p = Nat.minFac Q
```

다음 줄은 `p`가 소수임을 보이는 부분이다.

```lean
have hp_prime : Nat.Prime p := Nat.minFac_prime (by omega)
```

`Nat.minFac_prime`은 적절한 조건하에서 `Nat.minFac Q`가 소수임을 보장하는 정리이다. 여기서 `(by omega)`는 앞서 얻은 `Q ≥ 2`로부터 필요한 부등식 조건을 자동으로 해결한다.

---

## 4. 존재 명제의 결론을 구성하는 단계

Lean 코드는 다음과 같다.

```lean
refine ⟨p, ?_, hp_prime⟩
```

정리의 결론은 다음과 같은 존재 명제이다.

```lean
∃ p, N ≤ p ∧ Nat.Prime p
```

즉, 어떤 자연수 `p`를 제시하고, 그 `p`에 대해 다음 두 조건을 보여야 한다.

```lean
N ≤ p
Nat.Prime p
```

위 코드에서 `p`는 이미 `Q`의 최소 소인수로 정의한 수이다. 또한 `hp_prime`을 통해 `p`가 소수임은 이미 증명되어 있다. 따라서 남은 목표는 다음 하나이다.

```lean
N ≤ p
```

`refine ⟨p, ?_, hp_prime⟩`에서 `?_`는 아직 증명되지 않은 부분, 즉 `N ≤ p`를 의미한다.

손증명으로는 다음 단계에 해당한다.

> 이제 `p`가 `N` 이상임을 보이면 된다.  
> 이를 위해 반대로 `p ≤ N`이라고 가정하고 모순을 이끌어낸다.

---

## 5. `p ≤ N`이라고 가정하고 모순을 유도하는 단계

Lean 코드는 다음과 같다.

```lean
exact (Nat.lt_of_not_le (fun h : p ≤ N =>
```

이는 손증명에서 다음 논증에 해당한다.

> 반대로 `p ≤ N`이라고 가정하자.  
> 이 가정으로부터 모순을 이끌어내면, `p ≤ N`은 불가능하다.  
> 따라서 `N < p`이다.

여기서 다음 코드는 `h : p ≤ N`을 가정하고 `False`를 도출하겠다는 의미이다.

```lean
fun h : p ≤ N => ...
```

즉, 이는 `¬ p ≤ N`의 증명이다.

`Nat.lt_of_not_le`는 자연수 순서에 관한 다음 논리를 사용한다.

```lean
¬ p ≤ N → N < p
```

따라서 이 부분은 `p ≤ N`이 불가능함을 보임으로써 `N < p`를 얻는 과정이다. 이후 코드 끝의 `.le`를 통해 `N < p`에서 `N ≤ p`를 얻는다.

---

## 6. `p ≤ N`이면 `p ∣ N!`임을 보이는 단계

Lean 코드는 다음과 같다.

```lean
have h_p_div_fact : p ∣ Nat.factorial N :=
  Nat.dvd_factorial (Nat.Prime.pos hp_prime) h
```

이는 손증명에서 다음 논증에 해당한다.

> `p`는 소수이므로 `p > 0`이다.  
> 또한 가정에 의해 `p ≤ N`이다.  
> 따라서 `p`는 `N!`의 인수 중 하나이므로 `p ∣ N!`이다.

여기서 `h`는 앞에서 가정한 명제이다.

```lean
h : p ≤ N
```

또한 다음 코드는 소수 `p`가 양수임을 나타낸다.

```lean
Nat.Prime.pos hp_prime
```

다음 정리는 `0 < p`이고 `p ≤ N`이면 `p ∣ N!`임을 말한다.

```lean
Nat.dvd_factorial
```

따라서 이 줄은 `p ≤ N`이라는 가정 아래에서 `p`가 `N!`을 나눈다는 사실을 Lean으로 형식화한 것이다.

---

## 7. `p ∣ Q`임을 보이는 단계

Lean 코드는 다음과 같다.

```lean
have h_p_div_Q : p ∣ Q := by
  rw [hp]
  exact Nat.minFac_dvd Q
```

이는 손증명에서 다음 논증에 해당한다.

> `p`는 `Q`의 최소 소인수로 정의되었으므로, `p`는 `Q`를 나눈다.

`hp`는 다음 등식이다.

```lean
hp : p = Nat.minFac Q
```

따라서 다음 코드를 적용하면 목표 `p ∣ Q`는 `Nat.minFac Q ∣ Q`로 바뀐다.

```lean
rw [hp]
```

이제 다음 표준 정리를 적용한다.

```lean
Nat.minFac_dvd Q
```

이 정리는 `Nat.minFac Q`가 `Q`를 나눈다는 사실을 말한다. 따라서 `p ∣ Q`가 증명된다.

---

## 8. `p ∣ 1`을 도출하는 단계

Lean 코드는 다음과 같다.

```lean
have h_p_div_one : p ∣ 1 := by
  rw [hQ] at h_p_div_Q
  exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
```

이 단계가 유클리드식 모순 논증의 핵심이다.

앞 단계에서 다음 두 사실을 얻었다.

```lean
h_p_div_fact : p ∣ Nat.factorial N
h_p_div_Q    : p ∣ Q
```

또한 `Q = N! + 1`이다. 따라서 손증명에서는 다음과 같이 논증한다.

> `p ∣ N!`이고 `p ∣ Q`이다.  
> 그런데 `Q = N! + 1`이므로 `p ∣ N! + 1`이다.  
> 따라서 `p`는 `N!`과 `N! + 1`을 모두 나눈다.  
> 그러므로 `p`는 두 수의 차이인 `1`도 나눈다.  
> 즉, `p ∣ 1`이다.

각 줄의 의미는 다음과 같다.

```lean
rw [hQ] at h_p_div_Q
```

이 줄은 기존의 다음 명제에서 `Q`를 `Nat.factorial N + 1`로 치환한다.

```lean
h_p_div_Q : p ∣ Q
```

따라서 `h_p_div_Q`는 다음과 같은 형태가 된다.

```lean
h_p_div_Q : p ∣ Nat.factorial N + 1
```

다음 줄은 다음과 같다.

```lean
exact (Nat.dvd_add_right h_p_div_fact).mp h_p_div_Q
```

여기서 이미 알고 있는 사실은 다음이다.

```lean
h_p_div_fact : p ∣ Nat.factorial N
```

즉, `p ∣ N!`이다. 또한 위에서 변환한 `h_p_div_Q`는 다음 사실이다.

```lean
h_p_div_Q : p ∣ Nat.factorial N + 1
```

즉, `p ∣ N! + 1`이다.

수학적으로는 다음 논리를 사용한다.

```text
p ∣ N!
p ∣ N! + 1
----------------
p ∣ (N! + 1) - N! = 1
```

Lean에서는 자연수 뺄셈을 직접 사용하기보다, 나눗셈에 관한 덧셈 정리를 사용한다.

```lean
Nat.dvd_add_right h_p_div_fact
```

이는 대략 다음과 같은 동치를 제공한다.

```lean
p ∣ Nat.factorial N + 1 ↔ p ∣ 1
```

여기서 `.mp`는 동치의 왼쪽에서 오른쪽 방향을 적용한다는 뜻이다. 따라서 `p ∣ Nat.factorial N + 1`로부터 `p ∣ 1`을 얻는다.

---

## 9. 소수가 `1`을 나누는 것은 불가능하다는 모순

Lean 코드는 다음과 같다.

```lean
show False from Nat.Prime.not_dvd_one hp_prime h_p_div_one
```

이는 손증명에서 다음 논증에 해당한다.

> `p`는 소수이다.  
> 소수는 `1`을 나눌 수 없다.  
> 그런데 앞에서 `p ∣ 1`을 얻었다.  
> 이는 모순이다.

Lean에서 다음 코드는 소수 `p`가 `1`을 나누지 않는다는 명제를 의미한다.

```lean
Nat.Prime.not_dvd_one hp_prime
```

즉, 다음을 뜻한다.

```lean
p ∤ 1
```

그런데 앞 단계에서 다음을 얻었다.

```lean
h_p_div_one : p ∣ 1
```

따라서 `p ∤ 1`과 `p ∣ 1`이 동시에 성립하게 되어 모순이 발생한다. 이 모순으로부터 `False`가 도출된다.

결국 처음의 가정은 불가능하다.

```lean
h : p ≤ N
```

---

## 10. `N ≤ p`를 얻는 마지막 단계

앞 단계에서 `p ≤ N`이라고 가정하면 모순이 발생함을 보였다. 따라서 다음이 성립한다.

```lean
¬ p ≤ N
```

자연수의 선형 순서에서는 `p ≤ N`이 아니면 `N < p`이다. Lean에서는 이를 다음 정리로 표현한다.

```lean
Nat.lt_of_not_le
```

따라서 다음을 얻는다.

```lean
N < p
```

하지만 원래 목표는 다음이었다.

```lean
N ≤ p
```

`N < p`는 `N ≤ p`보다 강한 명제이므로, `.le`를 사용하여 다음 결론을 얻는다.

```lean
(N < p).le : N ≤ p
```

따라서 `p`는 `N` 이상인 소수임이 증명된다.

---

## 전체 손증명

위 Lean 증명은 다음 손증명과 대응한다.

> 임의의 자연수 `N`을 잡는다.  
> `Q = N! + 1`이라고 둔다.  
> `N! > 0`이므로 `Q ≥ 2`이다.  
> 따라서 `Q`는 최소 소인수 `p`를 갖는다.  
> 이때 `p`는 소수이고, `p ∣ Q`이다.  
>
> 이제 `N ≤ p`임을 보인다.  
> 반대로 `p ≤ N`이라고 가정한다.  
> `p`는 소수이므로 `p > 0`이다.  
> 또한 `p ≤ N`이므로 `p ∣ N!`이다.  
> 한편 `p`는 `Q`의 최소 소인수이므로 `p ∣ Q`이다.  
> 그런데 `Q = N! + 1`이므로 `p ∣ N! + 1`이다.  
> 따라서 `p`는 `N!`과 `N! + 1`을 모두 나눈다.  
> 그러므로 `p`는 두 수의 차이인 `1`도 나눈다.  
> 즉, `p ∣ 1`이다.  
> 하지만 소수는 `1`을 나눌 수 없다.  
> 이는 모순이다.  
>
> 따라서 `p ≤ N`이라는 가정은 거짓이다.  
> 그러므로 `N < p`이고, 특히 `N ≤ p`이다.  
> 따라서 `N` 이상인 소수 `p`가 존재한다.

---

## Lean 코드와 손증명의 대응

| Lean 코드 | 손증명에서의 의미 |
|---|---|
| `set Q := Nat.factorial N + 1 with hQ` | `Q = N! + 1`이라고 둔다. |
| `have hQ_ge : 2 ≤ Q` | `Q ≥ 2`임을 보인다. |
| `Nat.factorial_pos N` | `N! > 0`이라는 사실을 사용한다. |
| `set p := Nat.minFac Q with hp` | `p`를 `Q`의 최소 소인수로 정의한다. |
| `Nat.minFac_prime` | 최소 소인수가 소수임을 사용한다. |
| `refine ⟨p, ?_, hp_prime⟩` | 존재 명제의 증인으로 `p`를 제시한다. |
| `fun h : p ≤ N => ...` | 반대로 `p ≤ N`이라고 가정한다. |
| `Nat.dvd_factorial ... h` | `p > 0`이고 `p ≤ N`이면 `p ∣ N!`임을 사용한다. |
| `Nat.minFac_dvd Q` | `p`가 `Q`의 최소 소인수이므로 `p ∣ Q`임을 사용한다. |
| `rw [hQ] at h_p_div_Q` | `Q`를 `N! + 1`로 치환한다. |
| `Nat.dvd_add_right h_p_div_fact` | `p ∣ N!`이고 `p ∣ N! + 1`이면 `p ∣ 1`임을 도출한다. |
| `Nat.Prime.not_dvd_one` | 소수는 `1`을 나누지 않는다는 사실을 사용한다. |
| `Nat.lt_of_not_le ...` | `p ≤ N`이 아님으로부터 `N < p`를 얻는다. |
| `.le` | `N < p`로부터 `N ≤ p`를 얻는다. |

---

## 핵심 구조 요약

이 증명의 핵심은 다음 논리 구조이다.

```text
Q = N! + 1
p = Q의 최소 소인수
p ∣ Q
p가 소수

만약 p ≤ N이라면,
p ∣ N!

그런데 p ∣ Q이고 Q = N! + 1이므로
p ∣ N! + 1

따라서 p ∣ 1

그러나 소수는 1을 나눌 수 없으므로 모순

따라서 p ≤ N은 거짓이고,
N < p, 특히 N ≤ p이다.
```

결론적으로, 임의의 자연수 `N`에 대하여 `N` 이상인 소수 `p`가 존재한다. 이는 소수가 무한히 많다는 유클리드의 고전적 정리를 Lean 4에서 형식화한 결과이다.
