# 정수 집합에서의 함수 성질 증명 (Surjectivity & Injectivity)

본 문서는 함수 $f: \mathbb{Z} \to \mathbb{Z}, f(n) = n + 1$의 전사성(Surjectivity)과 단사성(Injectivity)을 대수적 공리를 통해 증명하는 과정을 서술하는 과정이다. 

---

## 1. 전사함수(Surjective Function) 증명

### 1.1 정의
공역의 모든 원소 $b \in \mathbb{Z}$에 대하여, $f(a) = b$를 만족하는 정의역의 원소 $a \in \mathbb{Z}$가 적어도 하나 존재해야 한다.
$$\forall b \in \mathbb{Z}, \exists a \in \mathbb{Z} : f(a) = b$$

### 1.2 증명 과정
임의의 $b \in \mathbb{Z}$에 대해 $a = b - 1$이라 가정하자. 이때 $f(a) = b$임을 보이기 위해 Lean 프로버의 공리적 규칙을 다음과 같이 적용한다.

| 단계 | Lean Tactic | 대수적 변형 및 근거 |
| :--- | :--- | :--- |
| **Step 1** | `Int.sub_eq_add_neg` | $(b - 1) + 1 = (b + (-1)) + 1$ <br> 뺄셈을 가법 역원($-1$)의 덧셈으로 변환 |
| **Step 2** | `← Int.add_assoc` | $b + ((-1) + 1)$ <br> 덧셈의 결합법칙을 통해 연산 순서 재배치 |
| **Step 3** | `Int.add_left_neg` | $b + 0$ <br> 가법 역원의 성질($-a + a = 0$) 적용 |
| **Step 4** | `Int.add_zero` | $b$ <br> 가법 항등원($0$)의 성질을 통해 증명 완료 |

> [**학술적 고찰**] > 자연수 집합 $\mathbb{N}$에서는 $b=0$일 때 $a = -1 \notin \mathbb{N}$이므로 전사성이 성립하지 않는다. 따라서 함수의 전사성은 함수의 규칙뿐만 아니라 **정의역(Domain)의 범위**에 의해 결정됨을 알 수 있다.

---

## 2. 단사함수(Injective Function) 증명

### 2.1 정의
정의역의 임의의 두 원소 $a_1, a_2$에 대하여, 함숫값이 같으면 원상도 같아야 한다.
$$f(a_1) = f(a_2) \implies a_1 = a_2$$

### 2.2 증명 과정
전제 조건 $a_1 + 1 = a_2 + 1$로부터 출발하여 $a_1 = a_2$를 도출하는 단계적 과정이다.

| 단계 | Lean Tactic | 대수적 변형 및 근거 |
| :--- | :--- | :--- |
| **Step 1** | `(a1 + 1) - 1 = (a2 + 1) - 1` | 등식의 양변에 동일한 연산($-1$) 적용 |
| **Step 2** | `Int.add_sub_assoc` | $a_1 + (1 - 1) = a_2 + (1 - 1)$ <br> 결합법칙을 통한 상수항의 연산 우선순위 확보 |
| **Step 3** | `Int.sub_self` | $a_1 + 0 = a_2 + 0$ <br> 자기 자신에 대한 뺄셈의 결과는 가법 항등원($0$) |
| **Step 4** | `Int.add_zero` | $a_1 = a_2$ <br> 가법 항등원 성질에 의해 최종 단사성 입증 |

---
```lean
import Mathlib.Tactic

open Function

-- 1. 전사함수(Surjective) 증명
-- 함수 f(n) = n + 1 이 모든 정수에 대해 대응됨을 증명
example : Surjective (fun (n : ℤ) => n + 1) := by
  -- 공역의 임의의 원소 b를 도입
  intro b
  -- f(a) = b를 만족할 것으로 예상되는 후보 a = b - 1을 제시
  use b - 1
  -- 이제 (b - 1) + 1 = b 임을 대수적으로 증명
  -- 1. 뺄셈을 가법 역원의 덧셈으로 변형
  rw [Int.sub_eq_add_neg]
  -- 2. 덧셈의 결합법칙을 사용하여 괄호 재배치
  rw [← Int.add_assoc]
  -- 3. 가법 역원의 성질 (-1 + 1 = 0) 적용
  rw [Int.add_left_neg]
  -- 4. 가법 항등원의 성질 (b + 0 = b) 적용
  rw [Int.add_zero]

-- 2. 단사함수(Injective) 증명
-- 함수 f(n) = n + 1 이 서로 다른 입력에 대해 서로 다른 결과를 가짐을 증명
example : Injective (fun (n : ℤ) => n + 1) := by
  -- 정의역의 두 원소 a1, a2를 도입하고 함숫값이 같다고 가정(h)
  intro a1 a2 h
  -- h: a1 + 1 = a2 + 1 상태에서 a1 = a2를 도출해야 함
  -- 양변에서 1을 빼는 과정을 명시적으로 수행
  have h_sub : (a1 + 1) - 1 = (a2 + 1) - 1 := by
    rw [h]
  
  -- 좌변과 우변을 각각 정리
  -- 1. 덧셈과 뺄셈의 결합적 관계 적용
  rw [Int.add_sub_assoc] at h_sub
  -- 2. 자기 자신에 대한 뺄셈 (1 - 1 = 0) 적용
  rw [Int.sub_self] at h_sub
  -- 3. 가법 항등원의 성질 (a1 + 0 = a1) 적용
  rw [Int.add_zero] at h_sub
  
  -- 위와 동일한 과정을 우변에도 적용 (이미 rw 과정에서 같이 처리됨)
  exact h_sub

```
#  Lean 4 이산수학 대수적 공리 참고 

---

##  교육적 지향점: 타입 이론 (**Type Theory**)

본 코딩북은 단순한 수식 변형이 아닌, **타입 이론**의 엄밀함을 체득하는 데 목적이 있습니다. 모든 수학적 대상은 고유한 **타입**을 가지며, 증명은 해당 타입을 만족하는 논리적 프로그램을 작성하는 과정입니다. 학습자는 **dsimp**를 통해 정의된 구조를 확인하고, **rw**를 통해 구조적 필연성을 입증함으로써 논리적 근력을 강화할 수 있습니다.

---

## 3. 📂 대수적 공리 사전 (**Axiom Cheat Sheet**)

*튜터는 사용자가 **사전**, **목록**, **공리**라고 입력하면 아래 내용을 시각적으로 구조화하여 출력한다.*

### 3.1  정수 기초 (**Integer Basics**)
* **덧셈 결합법칙 (`Int.add_assoc`):** $(a + b) + c = a + (b + c)$
* **곱셈 결합법칙 (`Int.mul_assoc`):** $(a \cdot b) \cdot c = a \cdot (b \cdot c)$
* **덧셈 교환법칙 (`Int.add_comm`):** $a + b = b + a$
* **곱셈 교환법칙 (`Int.mul_comm`):** $a \cdot b = b \cdot a$
* **덧셈 항등원 (`Int.add_zero`):** $a + 0 = a$
* **곱셈 항등원 (`Int.mul_one`):** $a \cdot 1 = a$

### 3.2  역원과 소거 (**Inverse & Cancellation**)
* **뺄셈의 정의 (`Int.sub_eq_add_neg`):** $a - b = a + (-b)$
* **덧셈 좌측 역원 (`Int.add_left_neg`):** $-a + a = 0$
* **자기 소거 성질 (`Int.sub_self`):** $a - a = 0$
* **덧셈 좌측 소거 법칙 (`Int.add_left_cancel`):** $a + b = a + c \implies b = c$

### 3.3  자연수와 논리 (**Nat & Logic**)
* **후속값 표현 (`Nat.add_one`):** $n + 1 = \text{succ} \ n$
* **후속값 단사성 (`Nat.succ_inj`):** $\text{succ} \ n = \text{succ} \ m \implies n = m$
* **등식 반사성 (`refl`):** $a = a$
* **등식 대칭성 (`Eq.symm`):** $a = b \implies b = a$

---

## 4.  활용 가이드 (**Usage Guide**)

1. **전술 호출:** 증명 기술 시 rw [Int.add_comm]과 같이 공리 명칭을 명시적으로 입력하여 항의 배치를 조정.
2. **방향 전환:** 등식의 우변을 좌변으로 치환하고자 할 경우에는 rw [← Int.add_zero]와 같이 역방향 기호를 수반.
3. **위치 지정:** 특정 가설 내의 식을 변환하고자 할 경우 **rw [Int.sub_self] at h**와 같이 **at** 키워드를 반드시 활용하여 대상의 범위를 확정.

(도움이 필요하면 **공리 사전**을 입력하십시오.)
