# 손 증명과 Lean 4 코드 1:1 대비 자료

> 이 문서에는 두 가지 증명의 다이어그램과 상세 풀이가 포함되어 있다.
> - 제1부: (p ∧ q) → (p ∨ q) 는 항진명제이다 (다이어그램 1개)
> - 제2부: 드모르간 법칙 ¬(P ∨ Q) ↔ (¬P ∧ ¬Q) (다이어그램 2개: 정방향, 역방향)

---

---

# 제1부: (p ∧ q) → (p ∨ q) 는 항진명제이다

---

## 1-1. 전체 대비 다이어그램

<svg width="100%" viewBox="0 0 680 900" xmlns="http://www.w3.org/2000/svg" style="max-width:680px; font-family: system-ui, -apple-system, sans-serif;">
<style>
  .th1 { font-size: 14px; font-weight: 500; fill: #1a1a1a; }
  .ts1 { font-size: 12px; font-weight: 400; fill: #666; }
  .bx-purple1 { fill: #EEEDFE; stroke: #534AB7; } .tx-purple1 { fill: #3C3489; }
  .bx-gray1 { fill: #F1EFE8; stroke: #888780; } .tx-gray1 { fill: #444441; }
  .bx-teal1 { fill: #E1F5EE; stroke: #0F6E56; } .tx-teal1 { fill: #085041; }
  .bx-coral1 { fill: #FAECE7; stroke: #993C1D; } .tx-coral1 { fill: #712B13; }
  .bx-amber1 { fill: #FAEEDA; stroke: #854F0B; } .tx-amber1 { fill: #633806; }
  .bx-green1 { fill: #EAF3DE; stroke: #3B6D11; } .tx-green1 { fill: #27500A; }
  .sub-coral1 { fill: #993C1D; } .sub-amber1 { fill: #854F0B; } .sub-teal1 { fill: #0F6E56; }
  .ld1 { stroke: #aaa; stroke-width: 0.5; stroke-dasharray: 3 3; }
  .dv1 { stroke: #ccc; stroke-width: 0.5; stroke-dasharray: 4 4; }
  .ar1 { stroke: #888; stroke-width: 1.5; }
</style>
<defs>
<marker id="a1" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
<path d="M2 1L8 5L2 9" fill="none" stroke="context-stroke" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</marker>
</defs>

<text class="th1" x="340" y="28" text-anchor="middle">(p ∧ q) → (p ∨ q) 는 항진명제이다</text>

<text class="th1" x="160" y="60" text-anchor="middle">손 증명 (동치 변환)</text>
<text class="th1" x="510" y="60" text-anchor="middle">Lean 4 (직접 증명)</text>
<line class="dv1" x1="340" y1="50" x2="340" y2="530"/>

<!-- 손 증명 왼쪽 -->
<rect class="bx-gray1" x="30" y="78" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="th1 tx-gray1" x="165" y="98" text-anchor="middle" dominant-baseline="central" style="font-size:12px">(p ∧ q) → (p ∨ q)</text>
<text class="ts1" x="165" y="136" text-anchor="middle">↓  →의 진리표: A→B ≡ ¬A∨B</text>

<rect class="bx-teal1" x="30" y="150" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="th1 tx-teal1" x="165" y="170" text-anchor="middle" dominant-baseline="central" style="font-size:11px">¬(p ∧ q) ∨ (p ∨ q)</text>
<text class="ts1" x="165" y="208" text-anchor="middle">↓  드모르간: ¬(A∧B) ≡ ¬A∨¬B</text>

<rect class="bx-teal1" x="30" y="222" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="th1 tx-teal1" x="165" y="242" text-anchor="middle" dominant-baseline="central" style="font-size:11px">(¬p ∨ ¬q) ∨ (p ∨ q)</text>
<text class="ts1" x="165" y="280" text-anchor="middle">↓  결합 및 교환법칙</text>

<rect class="bx-teal1" x="30" y="294" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="th1 tx-teal1" x="165" y="314" text-anchor="middle" dominant-baseline="central" style="font-size:11px">(¬p ∨ p) ∨ (¬q ∨ q)</text>
<text class="ts1" x="165" y="352" text-anchor="middle">↓  배중률: ¬A∨A ≡ T</text>

<rect class="bx-purple1" x="30" y="366" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="th1 tx-purple1" x="165" y="386" text-anchor="middle" dominant-baseline="central">T ∨ T</text>
<text class="ts1" x="165" y="424" text-anchor="middle">↓  지배 법칙: T∨T ≡ T</text>

<rect class="bx-green1" x="80" y="438" width="170" height="40" rx="8" stroke-width="0.5"/>
<text class="th1 tx-green1" x="165" y="458" text-anchor="middle" dominant-baseline="central">T (항진명제)</text>

<!-- Lean 오른쪽 -->
<rect class="bx-gray1" x="370" y="78" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="th1 tx-gray1" x="505" y="98" text-anchor="middle" dominant-baseline="central" style="font-size:12px">⊢ (p ∧ q) → (p ∨ q)</text>

<line x1="505" y1="118" x2="505" y2="146" class="ar1" marker-end="url(#a1)"/>
<text class="ts1" x="460" y="136" text-anchor="end">intro h</text>

<rect class="bx-coral1" x="370" y="150" width="270" height="52" rx="8" stroke-width="0.5"/>
<text class="th1 tx-coral1" x="505" y="170" text-anchor="middle" dominant-baseline="central" style="font-size:12px">h : p ∧ q</text>
<text class="ts1 sub-coral1" x="505" y="188" text-anchor="middle" dominant-baseline="central">⊢ p ∨ q</text>

<line x1="505" y1="202" x2="505" y2="230" class="ar1" marker-end="url(#a1)"/>
<text class="ts1" x="460" y="220" text-anchor="end">h.left</text>

<rect class="bx-amber1" x="370" y="234" width="270" height="52" rx="8" stroke-width="0.5"/>
<text class="th1 tx-amber1" x="505" y="254" text-anchor="middle" dominant-baseline="central" style="font-size:12px">h.left : p</text>
<text class="ts1 sub-amber1" x="505" y="272" text-anchor="middle" dominant-baseline="central">p를 꺼냄 (단순화)</text>

<line x1="505" y1="286" x2="505" y2="314" class="ar1" marker-end="url(#a1)"/>
<text class="ts1" x="460" y="304" text-anchor="end">Or.inl</text>

<rect class="bx-amber1" x="370" y="318" width="270" height="52" rx="8" stroke-width="0.5"/>
<text class="th1 tx-amber1" x="505" y="338" text-anchor="middle" dominant-baseline="central" style="font-size:12px">Or.inl h.left : p ∨ q</text>
<text class="ts1 sub-amber1" x="505" y="356" text-anchor="middle" dominant-baseline="central">왼쪽 선택 (가산)</text>

<line x1="505" y1="370" x2="505" y2="398" class="ar1" marker-end="url(#a1)"/>
<text class="ts1" x="460" y="388" text-anchor="end">exact</text>

<rect class="bx-green1" x="420" y="402" width="170" height="40" rx="8" stroke-width="0.5"/>
<text class="th1 tx-green1" x="505" y="422" text-anchor="middle" dominant-baseline="central">No goals</text>

<line class="ld1" x1="250" y1="458" x2="420" y2="422"/>

<text class="ts1" x="340" y="505" text-anchor="middle">손 증명: 6단계 동치 변환으로 T에 도달</text>
<text class="ts1" x="340" y="523" text-anchor="middle">Lean 직접 증명: intro → h.left → Or.inl → exact, 2줄</text>

<!-- 대응 관계 표 -->
<text class="th1" x="340" y="560" text-anchor="middle">대응 관계: 손 증명 법칙 = Lean 도구</text>

<rect class="bx-gray1" x="40" y="575" width="600" height="26" rx="6" stroke-width="0.5"/>
<text class="th1 tx-gray1" x="170" y="588" text-anchor="middle" dominant-baseline="central" style="font-size:11px">손 증명 법칙</text>
<text class="th1 tx-gray1" x="410" y="588" text-anchor="middle" dominant-baseline="central" style="font-size:11px">Lean 4</text>
<text class="th1 tx-gray1" x="590" y="588" text-anchor="middle" dominant-baseline="central" style="font-size:11px">추론 규칙</text>

<rect class="bx-teal1" x="40" y="603" width="600" height="24" rx="0" stroke-width="0.3"/>
<text class="ts1 tx-teal1" x="170" y="615" text-anchor="middle" dominant-baseline="central">p ∧ q를 가정</text>
<text class="th1 tx-teal1" x="410" y="615" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro h</text>
<text class="ts1 tx-teal1" x="590" y="615" text-anchor="middle" dominant-baseline="central">가정 도입</text>

<rect x="40" y="629" width="600" height="24" rx="0" fill="none" stroke="#ccc" stroke-width="0.3"/>
<text class="ts1" x="170" y="641" text-anchor="middle" dominant-baseline="central">p ∧ q에서 p 추출</text>
<text class="th1" x="410" y="641" text-anchor="middle" dominant-baseline="central" style="font-size:12px">h.left</text>
<text class="ts1" x="590" y="641" text-anchor="middle" dominant-baseline="central">단순화</text>

<rect class="bx-teal1" x="40" y="655" width="600" height="24" rx="0" stroke-width="0.3"/>
<text class="ts1 tx-teal1" x="170" y="667" text-anchor="middle" dominant-baseline="central">p이면 p ∨ q</text>
<text class="th1 tx-teal1" x="410" y="667" text-anchor="middle" dominant-baseline="central" style="font-size:12px">Or.inl / left</text>
<text class="ts1 tx-teal1" x="590" y="667" text-anchor="middle" dominant-baseline="central">가산</text>

<rect x="40" y="681" width="600" height="24" rx="0" fill="none" stroke="#ccc" stroke-width="0.3"/>
<text class="ts1" x="170" y="693" text-anchor="middle" dominant-baseline="central">A→B ≡ ¬A∨B</text>
<text class="th1" x="410" y="693" text-anchor="middle" dominant-baseline="central" style="font-size:12px">imp_iff_not_or</text>
<text class="ts1" x="590" y="693" text-anchor="middle" dominant-baseline="central">라이브러리</text>

<rect class="bx-teal1" x="40" y="707" width="600" height="24" rx="0" stroke-width="0.3"/>
<text class="ts1 tx-teal1" x="170" y="719" text-anchor="middle" dominant-baseline="central">¬(A∧B) ≡ ¬A∨¬B</text>
<text class="th1 tx-teal1" x="410" y="719" text-anchor="middle" dominant-baseline="central" style="font-size:12px">not_and_or</text>
<text class="ts1 tx-teal1" x="590" y="719" text-anchor="middle" dominant-baseline="central">드모르간</text>

<rect x="40" y="733" width="600" height="24" rx="0" fill="none" stroke="#ccc" stroke-width="0.3"/>
<text class="ts1" x="170" y="745" text-anchor="middle" dominant-baseline="central">¬A∨A ≡ T</text>
<text class="th1" x="410" y="745" text-anchor="middle" dominant-baseline="central" style="font-size:12px">Classical.em</text>
<text class="ts1" x="590" y="745" text-anchor="middle" dominant-baseline="central">배중률</text>

<text class="ts1" x="340" y="790" text-anchor="middle">위 3줄: 직접 증명 전술 / 아래 3줄: 동치 변환 시 라이브러리 정리</text>
<text class="ts1" x="340" y="808" text-anchor="middle">전략은 다르지만 논리는 동일하다.</text>
</svg>

---

## 1-2. 손 증명 (동치 변환)

| 단계 | 손 증명 | 사용한 법칙 | Lean 4 라이브러리 정리 |
|------|---------|-----------|---------------------|
| 0 | $(p \wedge q) \to (p \vee q)$ | 원래 명제 | -- |
| 1 | $\equiv \neg(p \wedge q) \vee (p \vee q)$ | $A \to B \equiv \neg A \vee B$ | `imp_iff_not_or` |
| 2 | $\equiv (\neg p \vee \neg q) \vee (p \vee q)$ | $\neg(A \wedge B) \equiv \neg A \vee \neg B$ | `not_and_or` |
| 3 | $\equiv (\neg p \vee p) \vee (\neg q \vee q)$ | 결합 및 교환법칙 | `or_assoc`, `or_comm` |
| 4 | $\equiv T \vee T$ | 배중률: $\neg A \vee A \equiv T$ | `Classical.em` |
| 5 | $\equiv T$ | $T \vee T \equiv T$ | `or_self` |

## 1-3. Lean 4 직접 증명

```lean
example (p q : Prop) : (p ∧ q) → (p ∨ q) := by
  intro h              -- p ∧ q를 가정한다 (h : p ∧ q)
  exact Or.inl h.left  -- h에서 p를 꺼내서 p ∨ q의 왼쪽에 넣는다
```

| 손 증명의 사고 과정 | Lean 4 코드 | 설명 |
|-------------------|------------|------|
| "p ∧ q가 참이라고 가정하자" | `intro h` | 조건문의 전제를 가정으로 도입 |
| "p ∧ q에서 p를 꺼낸다" | `h.left` | 단순화 논법: p ∧ q이면 p |
| "p가 참이면 p ∨ q도 참이다" | `Or.inl h.left` | 가산 논법: p이면 p ∨ q |
| (증명 완료) | `exact ...` | 목표와 일치하는 증거 제시 |

## 1-4. 각 동치 법칙의 Lean 대응물

```lean
-- 단계 1: A → B ≡ ¬A ∨ B
#check @imp_iff_not_or   -- (a → b) ↔ (¬a ∨ b)

example (p q : Prop) :
    ((p ∧ q) → (p ∨ q)) ↔ (¬(p ∧ q) ∨ (p ∨ q)) := by
  exact imp_iff_not_or

-- 단계 2: ¬(A ∧ B) ≡ ¬A ∨ ¬B (드모르간)
#check @not_and_or       -- ¬(a ∧ b) ↔ (¬a ∨ ¬b)

example (p q : Prop) :
    ¬(p ∧ q) ↔ (¬p ∨ ¬q) := by
  exact not_and_or

-- 단계 3: 결합 및 교환법칙
#check @or_assoc   -- (a ∨ b) ∨ c ↔ a ∨ (b ∨ c)
#check @or_comm    -- a ∨ b ↔ b ∨ a

-- 단계 4: 배중률
#check @Classical.em   -- ∀ (p : Prop), p ∨ ¬p

example (p : Prop) : ¬p ∨ p := by
  rcases Classical.em p with hp | hnp
  · right; exact hp
  · left; exact hnp

-- 단계 5: T ∨ T ≡ T
#check @or_self    -- a ∨ a ↔ a
```

## 1-5. 한 줄 자동 증명

```lean
example (p q : Prop) : (p ∧ q) → (p ∨ q) := by tauto
```

## 1-6. 학생 실습용 빈칸

```lean
example (p q : Prop) : (p ∧ q) → (p ∨ q) := by
  intro ______
  exact Or.inl ______
```

정답: `h`, `h.left`

---

---

# 제2부: 드모르간 법칙 ¬(P ∨ Q) ↔ (¬P ∧ ¬Q)

"또는의 부정 = P도 아니고 Q도 아니다"

↔ 이므로 두 방향을 각각 증명한다. 전체 증명의 첫 줄: `constructor`

---

## 2-1. 정방향 다이어그램: ¬(P ∨ Q) → (¬P ∧ ¬Q)

<svg width="100%" viewBox="0 0 680 680" xmlns="http://www.w3.org/2000/svg" style="max-width:680px; font-family: system-ui, -apple-system, sans-serif;">
<style>
  .th2 { font-size: 14px; font-weight: 500; fill: #1a1a1a; }
  .ts2 { font-size: 12px; font-weight: 400; fill: #666; }
  .bx2-purple { fill: #EEEDFE; stroke: #534AB7; } .tx2-purple { fill: #3C3489; }
  .bx2-gray { fill: #F1EFE8; stroke: #888780; } .tx2-gray { fill: #444441; }
  .bx2-teal { fill: #E1F5EE; stroke: #0F6E56; } .tx2-teal { fill: #085041; }
  .bx2-coral { fill: #FAECE7; stroke: #993C1D; } .tx2-coral { fill: #712B13; } .tx2-sub-coral { fill: #993C1D; }
  .bx2-amber { fill: #FAEEDA; stroke: #854F0B; } .tx2-amber { fill: #633806; } .tx2-sub-amber { fill: #854F0B; }
  .bx2-green { fill: #EAF3DE; stroke: #3B6D11; } .tx2-green { fill: #27500A; }
  .ld2 { stroke: #aaa; stroke-width: 0.5; stroke-dasharray: 3 3; }
  .dv2 { stroke: #ccc; stroke-width: 0.5; stroke-dasharray: 4 4; }
</style>

<text class="th2" x="340" y="24" text-anchor="middle">¬(P ∨ Q) ↔ (¬P ∧ ¬Q)  드모르간 법칙</text>
<text class="ts2" x="340" y="42" text-anchor="middle">"또는의 부정 = P도 아니고 Q도 아니다"</text>

<rect class="bx2-purple" x="40" y="56" width="600" height="28" rx="8" stroke-width="0.5"/>
<text class="th2 tx2-purple" x="340" y="70" text-anchor="middle" dominant-baseline="central" style="font-size:12px">↔ 이므로 두 방향을 각각 증명한다 → constructor</text>

<text class="th2" x="340" y="110" text-anchor="middle">정방향: ¬(P ∨ Q) → (¬P ∧ ¬Q)</text>
<text class="th2" x="165" y="136" text-anchor="middle">손 증명</text>
<text class="th2" x="510" y="136" text-anchor="middle">Lean 4</text>
<line class="dv2" x1="340" y1="128" x2="340" y2="610"/>

<rect class="bx2-gray" x="40" y="150" width="260" height="36" rx="6" stroke-width="0.5"/>
<text class="ts2 tx2-gray" x="170" y="168" text-anchor="middle" dominant-baseline="central">¬(P ∨ Q)를 가정한다</text>
<rect class="bx2-gray" x="370" y="150" width="270" height="36" rx="6" stroke-width="0.5"/>
<text class="th2 tx2-gray" x="505" y="168" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro h</text>
<line class="ld2" x1="300" y1="168" x2="368" y2="168"/>

<text class="ts2" x="170" y="205" text-anchor="middle">¬P, ¬Q를 각각 보인다</text>
<rect class="bx2-teal" x="370" y="195" width="270" height="30" rx="6" stroke-width="0.5"/>
<text class="th2 tx2-teal" x="505" y="210" text-anchor="middle" dominant-baseline="central" style="font-size:12px">constructor</text>

<!-- ¬P 증명 -->
<rect class="bx2-coral" x="40" y="240" width="260" height="130" rx="8" stroke-width="0.5"/>
<text class="th2 tx2-coral" x="170" y="260" text-anchor="middle" dominant-baseline="central" style="font-size:12px">¬P 증명</text>
<text class="ts2 tx2-sub-coral" x="170" y="282" text-anchor="middle" dominant-baseline="central">P를 가정한다</text>
<text class="ts2 tx2-sub-coral" x="170" y="300" text-anchor="middle" dominant-baseline="central">(¬P를 보이므로 목표: False)</text>
<text class="ts2 tx2-sub-coral" x="170" y="322" text-anchor="middle" dominant-baseline="central">P ∨ Q가 성립 (왼쪽)</text>
<text class="ts2 tx2-sub-coral" x="170" y="344" text-anchor="middle" dominant-baseline="central">¬(P∨Q)와 모순 → ¬P</text>

<rect class="bx2-coral" x="370" y="240" width="270" height="130" rx="8" stroke-width="0.5"/>
<text class="th2 tx2-coral" x="505" y="260" text-anchor="middle" dominant-baseline="central" style="font-size:12px">첫째 목표: ⊢ ¬P</text>
<text class="th2 tx2-coral" x="505" y="284" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro hp</text>
<text class="ts2 tx2-sub-coral" x="505" y="302" text-anchor="middle" dominant-baseline="central">hp : P, 목표: False</text>
<text class="th2 tx2-coral" x="505" y="324" text-anchor="middle" dominant-baseline="central" style="font-size:12px">apply h</text>
<text class="ts2 tx2-sub-coral" x="505" y="342" text-anchor="middle" dominant-baseline="central">목표 False → P ∨ Q로 변경</text>
<text class="th2 tx2-coral" x="505" y="364" text-anchor="middle" dominant-baseline="central" style="font-size:12px">left; exact hp</text>
<line class="ld2" x1="300" y1="302" x2="368" y2="302"/>

<!-- ¬Q 증명 -->
<rect class="bx2-amber" x="40" y="386" width="260" height="130" rx="8" stroke-width="0.5"/>
<text class="th2 tx2-amber" x="170" y="406" text-anchor="middle" dominant-baseline="central" style="font-size:12px">¬Q 증명</text>
<text class="ts2 tx2-sub-amber" x="170" y="428" text-anchor="middle" dominant-baseline="central">Q를 가정한다</text>
<text class="ts2 tx2-sub-amber" x="170" y="446" text-anchor="middle" dominant-baseline="central">(¬Q를 보이므로 목표: False)</text>
<text class="ts2 tx2-sub-amber" x="170" y="468" text-anchor="middle" dominant-baseline="central">P ∨ Q가 성립 (오른쪽)</text>
<text class="ts2 tx2-sub-amber" x="170" y="490" text-anchor="middle" dominant-baseline="central">¬(P∨Q)와 모순 → ¬Q</text>

<rect class="bx2-amber" x="370" y="386" width="270" height="130" rx="8" stroke-width="0.5"/>
<text class="th2 tx2-amber" x="505" y="406" text-anchor="middle" dominant-baseline="central" style="font-size:12px">둘째 목표: ⊢ ¬Q</text>
<text class="th2 tx2-amber" x="505" y="430" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro hq</text>
<text class="ts2 tx2-sub-amber" x="505" y="448" text-anchor="middle" dominant-baseline="central">hq : Q, 목표: False</text>
<text class="th2 tx2-amber" x="505" y="470" text-anchor="middle" dominant-baseline="central" style="font-size:12px">apply h</text>
<text class="ts2 tx2-sub-amber" x="505" y="488" text-anchor="middle" dominant-baseline="central">목표 False → P ∨ Q로 변경</text>
<text class="th2 tx2-amber" x="505" y="510" text-anchor="middle" dominant-baseline="central" style="font-size:12px">right; exact hq</text>
<line class="ld2" x1="300" y1="448" x2="368" y2="448"/>

<rect class="bx2-green" x="160" y="532" width="360" height="32" rx="8" stroke-width="0.5"/>
<text class="th2 tx2-green" x="340" y="548" text-anchor="middle" dominant-baseline="central">정방향 완료: ¬P ∧ ¬Q 증명됨</text>
</svg>

---

## 2-2. 역방향 다이어그램: (¬P ∧ ¬Q) → ¬(P ∨ Q) + 핵심 패턴

<svg width="100%" viewBox="0 0 680 700" xmlns="http://www.w3.org/2000/svg" style="max-width:680px; font-family: system-ui, -apple-system, sans-serif;">
<style>
  .th3 { font-size: 14px; font-weight: 500; fill: #1a1a1a; }
  .ts3 { font-size: 12px; font-weight: 400; fill: #666; }
  .bx3-gray { fill: #F1EFE8; stroke: #888780; } .tx3-gray { fill: #444441; }
  .bx3-teal { fill: #E1F5EE; stroke: #0F6E56; } .tx3-teal { fill: #085041; }
  .bx3-coral { fill: #FAECE7; stroke: #993C1D; } .tx3-coral { fill: #712B13; } .tx3-sub-coral { fill: #993C1D; }
  .bx3-amber { fill: #FAEEDA; stroke: #854F0B; } .tx3-amber { fill: #633806; } .tx3-sub-amber { fill: #854F0B; }
  .bx3-green { fill: #EAF3DE; stroke: #3B6D11; } .tx3-green { fill: #27500A; }
  .bx3-purple { fill: #EEEDFE; stroke: #534AB7; } .tx3-purple { fill: #3C3489; }
  .ld3 { stroke: #aaa; stroke-width: 0.5; stroke-dasharray: 3 3; }
  .dv3 { stroke: #ccc; stroke-width: 0.5; stroke-dasharray: 4 4; }
</style>

<text class="th3" x="340" y="24" text-anchor="middle">역방향: (¬P ∧ ¬Q) → ¬(P ∨ Q)</text>
<text class="th3" x="165" y="52" text-anchor="middle">손 증명</text>
<text class="th3" x="510" y="52" text-anchor="middle">Lean 4</text>
<line class="dv3" x1="340" y1="44" x2="340" y2="420"/>

<rect class="bx3-gray" x="40" y="66" width="260" height="52" rx="6" stroke-width="0.5"/>
<text class="ts3 tx3-gray" x="170" y="82" text-anchor="middle" dominant-baseline="central">h : ¬P ∧ ¬Q를 가정</text>
<text class="ts3 tx3-gray" x="170" y="102" text-anchor="middle" dominant-baseline="central">¬(P∨Q) 증명 위해 hpq : P∨Q 가정</text>
<rect class="bx3-gray" x="370" y="66" width="270" height="52" rx="6" stroke-width="0.5"/>
<text class="th3 tx3-gray" x="505" y="82" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro h hpq</text>
<text class="ts3 tx3-gray" x="505" y="102" text-anchor="middle" dominant-baseline="central">h : ¬P∧¬Q, hpq : P∨Q</text>
<line class="ld3" x1="300" y1="92" x2="368" y2="92"/>

<rect class="bx3-teal" x="40" y="134" width="260" height="30" rx="6" stroke-width="0.5"/>
<text class="ts3 tx3-teal" x="170" y="149" text-anchor="middle" dominant-baseline="central">P ∨ Q이므로 경우를 나눈다</text>
<rect class="bx3-teal" x="370" y="134" width="270" height="30" rx="6" stroke-width="0.5"/>
<text class="th3 tx3-teal" x="505" y="149" text-anchor="middle" dominant-baseline="central" style="font-size:12px">cases hpq with</text>
<line class="ld3" x1="300" y1="149" x2="368" y2="149"/>

<!-- 경우 1 -->
<rect class="bx3-coral" x="40" y="180" width="260" height="80" rx="8" stroke-width="0.5"/>
<text class="th3 tx3-coral" x="170" y="200" text-anchor="middle" dominant-baseline="central" style="font-size:12px">경우 1: hp : P</text>
<text class="ts3 tx3-sub-coral" x="170" y="220" text-anchor="middle" dominant-baseline="central">h.left : ¬P</text>
<text class="ts3 tx3-sub-coral" x="170" y="240" text-anchor="middle" dominant-baseline="central">h.left hp : False</text>

<rect class="bx3-coral" x="370" y="180" width="270" height="80" rx="8" stroke-width="0.5"/>
<text class="th3 tx3-coral" x="505" y="200" text-anchor="middle" dominant-baseline="central" style="font-size:12px">| inl hp =></text>
<text class="th3 tx3-coral" x="505" y="224" text-anchor="middle" dominant-baseline="central" style="font-size:12px">exact h.left hp</text>
<text class="ts3 tx3-sub-coral" x="505" y="246" text-anchor="middle" dominant-baseline="central">h.left hp : False</text>
<line class="ld3" x1="300" y1="220" x2="368" y2="220"/>

<!-- 경우 2 -->
<rect class="bx3-amber" x="40" y="276" width="260" height="80" rx="8" stroke-width="0.5"/>
<text class="th3 tx3-amber" x="170" y="296" text-anchor="middle" dominant-baseline="central" style="font-size:12px">경우 2: hq : Q</text>
<text class="ts3 tx3-sub-amber" x="170" y="316" text-anchor="middle" dominant-baseline="central">h.right : ¬Q</text>
<text class="ts3 tx3-sub-amber" x="170" y="336" text-anchor="middle" dominant-baseline="central">h.right hq : False</text>

<rect class="bx3-amber" x="370" y="276" width="270" height="80" rx="8" stroke-width="0.5"/>
<text class="th3 tx3-amber" x="505" y="296" text-anchor="middle" dominant-baseline="central" style="font-size:12px">| inr hq =></text>
<text class="th3 tx3-amber" x="505" y="320" text-anchor="middle" dominant-baseline="central" style="font-size:12px">exact h.right hq</text>
<text class="ts3 tx3-sub-amber" x="505" y="342" text-anchor="middle" dominant-baseline="central">h.right hq : False</text>
<line class="ld3" x1="300" y1="316" x2="368" y2="316"/>

<rect class="bx3-green" x="160" y="372" width="360" height="32" rx="8" stroke-width="0.5"/>
<text class="th3 tx3-green" x="340" y="388" text-anchor="middle" dominant-baseline="central">역방향 완료: ¬(P ∨ Q) 증명됨</text>

<!-- 핵심 패턴 3가지 -->
<text class="th3" x="340" y="440" text-anchor="middle">핵심 패턴 3가지</text>

<rect class="bx3-purple" x="40" y="458" width="600" height="52" rx="8" stroke-width="0.5"/>
<text class="th3 tx3-purple" x="55" y="476" text-anchor="start" dominant-baseline="central" style="font-size:12px">¬X 증명</text>
<text class="ts3" x="55" y="498" text-anchor="start" dominant-baseline="central">목표가 ¬X이면 → intro hx 후 목표는 False</text>

<rect class="bx3-teal" x="40" y="516" width="600" height="52" rx="8" stroke-width="0.5"/>
<text class="th3 tx3-teal" x="55" y="534" text-anchor="start" dominant-baseline="central" style="font-size:12px">¬X 사용</text>
<text class="ts3" x="55" y="556" text-anchor="start" dominant-baseline="central">목표가 False이고 hnx : ¬X, hx : X이면 → exact hnx hx</text>

<rect class="bx3-coral" x="40" y="574" width="600" height="52" rx="8" stroke-width="0.5"/>
<text class="th3 tx3-coral" x="55" y="592" text-anchor="start" dominant-baseline="central" style="font-size:12px">apply h (역방향 추론)</text>
<text class="ts3" x="55" y="614" text-anchor="start" dominant-baseline="central">목표가 False이고 h : A→False이면 → apply h 후 목표가 A</text>
</svg>

---

## 2-3. 정방향 상세: ¬(P ∨ Q) → (¬P ∧ ¬Q)

### 손 증명

```
1. ¬(P ∨ Q)를 가정한다.                             ← 전제 가정
2. ¬P ∧ ¬Q를 보이기 위해 ¬P, ¬Q를 각각 보인다.      ← constructor로 분해
3. ¬P 증명:
   3a. P를 가정한다. (¬P를 보이기 위해 목표가 False가 됨)
   3b. 그러면 P ∨ Q가 성립한다. (왼쪽 경우)
   3c. 이는 가정 ¬(P ∨ Q)와 모순이다.
   3d. 따라서 ¬P.
4. ¬Q 증명:
   4a. Q를 가정한다. (¬Q를 보이기 위해 목표가 False가 됨)
   4b. 그러면 P ∨ Q가 성립한다. (오른쪽 경우)
   4c. 이는 가정 ¬(P ∨ Q)와 모순이다.
   4d. 따라서 ¬Q.
5. 그러므로 ¬P ∧ ¬Q.
```

### Lean 4 코드

```lean
· intro h           -- 1. h : ¬(P ∨ Q) 가정
  constructor       -- 2. 목표를 ¬P와 ¬Q 두 개로 분해
  · intro hp        -- 3a. hp : P 가정 (¬P = P → False이므로 목표: False)
    apply h         -- 3c. 목표 False, h : (P∨Q)→False이므로 목표가 P ∨ Q로 변경
    left            -- 3b. 왼쪽 선택, 목표: P
    exact hp        -- 3b. hp가 바로 P
  · intro hq        -- 4a. hq : Q 가정 (¬Q = Q → False이므로 목표: False)
    apply h         -- 4c. 목표가 P ∨ Q로 변경
    right           -- 4b. 오른쪽 선택, 목표: Q
    exact hq        -- 4b. hq가 바로 Q
```

### 1:1 대비표

| 단계 | 손 증명 | Lean 4 | InfoView 상태 변화 |
|------|---------|--------|-------------------|
| 1 | ¬(P ∨ Q)를 가정 | `intro h` | h : ¬(P ∨ Q) 등장, 목표: ¬P ∧ ¬Q |
| 2 | ¬P와 ¬Q를 각각 보인다 | `constructor` | 목표 2개로 분리: ⊢ ¬P, ⊢ ¬Q |
| 3a | P를 가정 (목표가 False) | `intro hp` | hp : P 등장, 목표: False |
| 3c | ¬(P∨Q)와 모순 유도 | `apply h` | 목표 False에서 P ∨ Q로 변경 |
| 3b | P → P ∨ Q (왼쪽) | `left; exact hp` | P 제시 → h가 받아서 False |
| 4a | Q를 가정 (목표가 False) | `intro hq` | hq : Q 등장, 목표: False |
| 4c | ¬(P∨Q)와 모순 유도 | `apply h` | 목표 False에서 P ∨ Q로 변경 |
| 4b | Q → P ∨ Q (오른쪽) | `right; exact hq` | Q 제시 → h가 받아서 False |

---

## 2-4. 역방향 상세: (¬P ∧ ¬Q) → ¬(P ∨ Q)

### 손 증명

```
1. h : ¬P ∧ ¬Q를 가정한다.                          ← 전제 가정
2. ¬(P ∨ Q)를 보이기 위해 hpq : P ∨ Q를 가정한다.   ← ¬의 정의: (P∨Q) → False
3. P ∨ Q이므로 경우를 나눈다.
   경우 1: hp : P
     h.left : ¬P
     따라서 h.left hp : False                        ← ¬P에 P를 대입
   경우 2: hq : Q
     h.right : ¬Q
     따라서 h.right hq : False                       ← ¬Q에 Q를 대입
4. 모든 경우에서 모순이므로 ¬(P ∨ Q).
```

### Lean 4 코드

```lean
· intro h hpq       -- 1. h : ¬P ∧ ¬Q,  2. hpq : P ∨ Q 가정 (목표: False)
  cases hpq with    -- 3. P ∨ Q를 경우별로 분해
  | inl hp =>       -- 경우 1: hp : P
    exact h.left hp --   h.left hp : False  (¬P에 P 대입)
  | inr hq =>       -- 경우 2: hq : Q
    exact h.right hq--   h.right hq : False (¬Q에 Q 대입)
```

### 1:1 대비표

| 단계 | 손 증명 | Lean 4 | InfoView 상태 변화 |
|------|---------|--------|-------------------|
| 1~2 | h : ¬P∧¬Q 가정, hpq : P∨Q 가정 | `intro h hpq` | h : ¬P ∧ ¬Q, hpq : P ∨ Q, 목표: False |
| 3 | P ∨ Q를 경우별로 나눔 | `cases hpq with` | 2개의 하위 목표로 분기 |
| 경우1 | h.left hp : False | `exact h.left hp` | h.left : ¬P, hp : P, 결과: False |
| 경우2 | h.right hq : False | `exact h.right hq` | h.right : ¬Q, hq : Q, 결과: False |

---

## 2-5. 전체 Lean 4 코드 (복사용)

```lean
example (P Q : Prop) :
    ¬(P ∨ Q) ↔ (¬P ∧ ¬Q) := by
  constructor
  -- 정방향: ¬(P ∨ Q) → (¬P ∧ ¬Q)
  · intro h
    constructor
    · intro hp
      apply h
      left
      exact hp
    · intro hq
      apply h
      right
      exact hq
  -- 역방향: (¬P ∧ ¬Q) → ¬(P ∨ Q)
  · intro h hpq
    cases hpq with
    | inl hp =>
        exact h.left hp
    | inr hq =>
        exact h.right hq
```

---

## 2-6. 핵심 패턴 3가지

### ¬X 증명하기

```
목표가 ¬X이면 → intro hx 후 목표는 False
```

¬X는 X → False로 정의되어 있으므로, intro로 X를 가정하면 목표가 자동으로 False가 된다.

### ¬X 사용하기

```
목표가 False이고, hnx : ¬X와 hx : X가 있으면 → exact hnx hx
```

¬X는 X → False이므로, hnx에 hx를 넣으면 False가 나온다. 목표가 False일 때 바로 닫힌다.

### apply h (역방향 추론)

```
현재 목표가 False이고, h : A → False이면 → apply h 후 목표가 A로 바뀜
```

apply h는 "h의 결론이 현재 목표와 같으므로, h의 입력을 제시하겠다"는 선언이다.

---

## 부록: ¬ 증명 vs 귀류법 -- 이 둘은 다르다

| | ¬X 증명 (부정의 정의) | X 증명 (귀류법) |
|---|---|---|
| 증명 대상 | ¬X | X |
| 가정하는 것 | X | ¬X |
| 모순 도출 후 | ¬X 성립 (정의 그대로) | X 성립 (배중률 필요) |
| Lean 전술 | `intro hx` | `by_contra hnx` |
| 논리 체계 | 직관주의에서도 가능 | 고전 논리 필요 |

이 문서의 모든 증명에서 "P를 가정한다 → 모순"은 귀류법이 아니라 ¬P의 정의를 직접 사용하는 것이다.

---

## 참고: 드모르간 법칙 쌍

| 법칙 | 식 | 손 증명 핵심 | Lean 핵심 전술 |
|------|---|-----------|-------------|
| ¬(P∨Q) ↔ ¬P∧¬Q | 또는의 부정 | 각 원소를 가정 → P∨Q 만들어 모순 | intro + apply h + left/right |
| ¬(P∧Q) ↔ ¬P∨¬Q | 그리고의 부정 | by_cases로 P 여부 나눔 | by_cases + right/left |

---
