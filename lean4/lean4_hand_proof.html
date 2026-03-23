<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>손 증명과 Lean 4 코드 1:1 대비 자료</title>
<style>
  body { font-family: 'Pretendard', system-ui, -apple-system, sans-serif; max-width: 720px; margin: 0 auto; padding: 2rem 1rem; line-height: 1.7; color: #1a1a1a; background: #fff; }
  h1 { font-size: 1.5rem; border-bottom: 2px solid #534AB7; padding-bottom: 0.5rem; }
  h2 { font-size: 1.25rem; color: #534AB7; margin-top: 2.5rem; }
  h3 { font-size: 1.1rem; margin-top: 1.5rem; }
  h4 { font-size: 1rem; margin-top: 1rem; color: #444; }
  hr { border: none; border-top: 1px solid #ddd; margin: 2rem 0; }
  pre { background: #f8f8f6; border: 1px solid #e0ddd5; border-radius: 6px; padding: 1rem; overflow-x: auto; font-size: 13px; line-height: 1.5; }
  code { font-family: 'JetBrains Mono', 'Fira Code', monospace; font-size: 13px; background: #f0efe8; padding: 1px 5px; border-radius: 3px; }
  pre code { background: none; padding: 0; }
  table { border-collapse: collapse; width: 100%; margin: 1rem 0; font-size: 14px; }
  th, td { border: 1px solid #ddd; padding: 6px 10px; text-align: left; }
  th { background: #f4f3ee; font-weight: 500; }
  tr:nth-child(even) { background: #fafaf8; }
  .note { background: #f0efe8; border-left: 3px solid #534AB7; padding: 0.75rem 1rem; margin: 1rem 0; border-radius: 0 6px 6px 0; font-size: 14px; }
  .diagram-wrap { margin: 1.5rem 0; background: #fefefe; border: 1px solid #e8e6de; border-radius: 8px; padding: 1rem; }
  svg text { font-family: system-ui, -apple-system, sans-serif; }
  .dg-th { font-size: 14px; font-weight: 500; fill: #1a1a1a; }
  .dg-ts { font-size: 12px; font-weight: 400; fill: #666; }
  .dg-purple  { fill: #EEEDFE; stroke: #534AB7; }  .dg-t-purple  { fill: #3C3489; }
  .dg-gray    { fill: #F1EFE8; stroke: #888780; }  .dg-t-gray    { fill: #444441; }
  .dg-teal    { fill: #E1F5EE; stroke: #0F6E56; }  .dg-t-teal    { fill: #085041; }
  .dg-coral   { fill: #FAECE7; stroke: #993C1D; }  .dg-t-coral   { fill: #712B13; }
  .dg-amber   { fill: #FAEEDA; stroke: #854F0B; }  .dg-t-amber   { fill: #633806; }
  .dg-green   { fill: #EAF3DE; stroke: #3B6D11; }  .dg-t-green   { fill: #27500A; }
  .dg-s-coral { fill: #993C1D; } .dg-s-amber { fill: #854F0B; } .dg-s-teal { fill: #0F6E56; }
  .dg-leader  { stroke: #aaa; stroke-width: 0.5; stroke-dasharray: 3 3; }
  .dg-divider { stroke: #ccc; stroke-width: 0.5; stroke-dasharray: 4 4; }
  .dg-arrow   { stroke: #888; stroke-width: 1.5; }
  .part-divider { border: none; border-top: 3px solid #534AB7; margin: 3rem 0; }
</style>
</head>
<body>

<h1>손 증명과 Lean 4 코드 1:1 대비 자료</h1>

<div class="note">
이 문서에는 두 가지 증명의 다이어그램과 상세 풀이가 포함되어 있다.<br>
- 제1부: (p ∧ q) → (p ∨ q) 는 항진명제이다 (다이어그램 1개)<br>
- 제2부: 드모르간 법칙 ¬(P ∨ Q) ↔ (¬P ∧ ¬Q) (다이어그램 2개)
</div>

<hr class="part-divider">

<!-- ============================================ -->
<!-- 제1부: 항진명제 -->
<!-- ============================================ -->

<h1>제1부: (p ∧ q) → (p ∨ q) 는 항진명제이다</h1>

<h2>1-1. 전체 대비 다이어그램</h2>

<div class="diagram-wrap">
<svg width="100%" viewBox="0 0 680 820" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
<path d="M2 1L8 5L2 9" fill="none" stroke="context-stroke" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</marker>
</defs>

<text class="dg-th" x="340" y="28" text-anchor="middle">(p ∧ q) → (p ∨ q) 는 항진명제이다</text>
<text class="dg-th" x="160" y="60" text-anchor="middle">손 증명 (동치 변환)</text>
<text class="dg-th" x="510" y="60" text-anchor="middle">Lean 4 (직접 증명)</text>
<line class="dg-divider" x1="340" y1="50" x2="340" y2="530"/>

<rect class="dg-gray" x="30" y="78" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-gray" x="165" y="98" text-anchor="middle" dominant-baseline="central" style="font-size:12px">(p ∧ q) → (p ∨ q)</text>
<text class="dg-ts" x="165" y="136" text-anchor="middle">↓  →의 진리표: A→B ≡ ¬A∨B</text>

<rect class="dg-teal" x="30" y="150" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-teal" x="165" y="170" text-anchor="middle" dominant-baseline="central" style="font-size:11px">¬(p ∧ q) ∨ (p ∨ q)</text>
<text class="dg-ts" x="165" y="208" text-anchor="middle">↓  드모르간: ¬(A∧B) ≡ ¬A∨¬B</text>

<rect class="dg-teal" x="30" y="222" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-teal" x="165" y="242" text-anchor="middle" dominant-baseline="central" style="font-size:11px">(¬p ∨ ¬q) ∨ (p ∨ q)</text>
<text class="dg-ts" x="165" y="280" text-anchor="middle">↓  결합 및 교환법칙</text>

<rect class="dg-teal" x="30" y="294" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-teal" x="165" y="314" text-anchor="middle" dominant-baseline="central" style="font-size:11px">(¬p ∨ p) ∨ (¬q ∨ q)</text>
<text class="dg-ts" x="165" y="352" text-anchor="middle">↓  배중률: ¬A∨A ≡ T</text>

<rect class="dg-purple" x="30" y="366" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-purple" x="165" y="386" text-anchor="middle" dominant-baseline="central">T ∨ T</text>
<text class="dg-ts" x="165" y="424" text-anchor="middle">↓  지배 법칙: T∨T ≡ T</text>

<rect class="dg-green" x="80" y="438" width="170" height="40" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-green" x="165" y="458" text-anchor="middle" dominant-baseline="central">T (항진명제)</text>

<!-- Lean 쪽 -->
<rect class="dg-gray" x="370" y="78" width="270" height="40" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-gray" x="505" y="98" text-anchor="middle" dominant-baseline="central" style="font-size:12px">⊢ (p ∧ q) → (p ∨ q)</text>

<line x1="505" y1="118" x2="505" y2="146" class="dg-arrow" marker-end="url(#arr)"/>
<text class="dg-ts" x="460" y="136" text-anchor="end">intro h</text>

<rect class="dg-coral" x="370" y="150" width="270" height="52" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-coral" x="505" y="170" text-anchor="middle" dominant-baseline="central" style="font-size:12px">h : p ∧ q</text>
<text class="dg-ts dg-s-coral" x="505" y="188" text-anchor="middle" dominant-baseline="central">⊢ p ∨ q</text>

<line x1="505" y1="202" x2="505" y2="230" class="dg-arrow" marker-end="url(#arr)"/>
<text class="dg-ts" x="460" y="220" text-anchor="end">h.left</text>

<rect class="dg-amber" x="370" y="234" width="270" height="52" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-amber" x="505" y="254" text-anchor="middle" dominant-baseline="central" style="font-size:12px">h.left : p</text>
<text class="dg-ts dg-s-amber" x="505" y="272" text-anchor="middle" dominant-baseline="central">p를 꺼냄 (단순화)</text>

<line x1="505" y1="286" x2="505" y2="314" class="dg-arrow" marker-end="url(#arr)"/>
<text class="dg-ts" x="460" y="304" text-anchor="end">Or.inl</text>

<rect class="dg-amber" x="370" y="318" width="270" height="52" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-amber" x="505" y="338" text-anchor="middle" dominant-baseline="central" style="font-size:12px">Or.inl h.left : p ∨ q</text>
<text class="dg-ts dg-s-amber" x="505" y="356" text-anchor="middle" dominant-baseline="central">왼쪽 선택 (가산)</text>

<line x1="505" y1="370" x2="505" y2="398" class="dg-arrow" marker-end="url(#arr)"/>
<text class="dg-ts" x="460" y="388" text-anchor="end">exact</text>

<rect class="dg-green" x="420" y="402" width="170" height="40" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-green" x="505" y="422" text-anchor="middle" dominant-baseline="central">No goals</text>

<line class="dg-leader" x1="250" y1="458" x2="420" y2="422"/>

<text class="dg-ts" x="340" y="505" text-anchor="middle">손 증명: 6단계 동치 변환으로 T에 도달</text>
<text class="dg-ts" x="340" y="523" text-anchor="middle">Lean 직접 증명: intro → h.left → Or.inl → exact, 2줄</text>

<!-- 대응 관계 표 -->
<text class="dg-th" x="340" y="560" text-anchor="middle">대응 관계: 손 증명 법칙 = Lean 도구</text>

<rect class="dg-gray" x="40" y="575" width="600" height="26" rx="6" stroke-width="0.5"/>
<text class="dg-th dg-t-gray" x="170" y="588" text-anchor="middle" dominant-baseline="central" style="font-size:11px">손 증명 법칙</text>
<text class="dg-th dg-t-gray" x="410" y="588" text-anchor="middle" dominant-baseline="central" style="font-size:11px">Lean 4</text>
<text class="dg-th dg-t-gray" x="590" y="588" text-anchor="middle" dominant-baseline="central" style="font-size:11px">추론 규칙</text>

<rect class="dg-teal" x="40" y="603" width="600" height="24" rx="0" stroke-width="0.3"/>
<text class="dg-ts dg-t-teal" x="170" y="615" text-anchor="middle" dominant-baseline="central">p ∧ q를 가정</text>
<text class="dg-th dg-t-teal" x="410" y="615" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro h</text>
<text class="dg-ts dg-t-teal" x="590" y="615" text-anchor="middle" dominant-baseline="central">가정 도입</text>

<rect x="40" y="629" width="600" height="24" rx="0" fill="none" stroke="#ccc" stroke-width="0.3"/>
<text class="dg-ts" x="170" y="641" text-anchor="middle" dominant-baseline="central">p ∧ q에서 p 추출</text>
<text class="dg-th" x="410" y="641" text-anchor="middle" dominant-baseline="central" style="font-size:12px">h.left</text>
<text class="dg-ts" x="590" y="641" text-anchor="middle" dominant-baseline="central">단순화</text>

<rect class="dg-teal" x="40" y="655" width="600" height="24" rx="0" stroke-width="0.3"/>
<text class="dg-ts dg-t-teal" x="170" y="667" text-anchor="middle" dominant-baseline="central">p이면 p ∨ q</text>
<text class="dg-th dg-t-teal" x="410" y="667" text-anchor="middle" dominant-baseline="central" style="font-size:12px">Or.inl / left</text>
<text class="dg-ts dg-t-teal" x="590" y="667" text-anchor="middle" dominant-baseline="central">가산</text>

<rect x="40" y="681" width="600" height="24" rx="0" fill="none" stroke="#ccc" stroke-width="0.3"/>
<text class="dg-ts" x="170" y="693" text-anchor="middle" dominant-baseline="central">A→B ≡ ¬A∨B</text>
<text class="dg-th" x="410" y="693" text-anchor="middle" dominant-baseline="central" style="font-size:12px">imp_iff_not_or</text>
<text class="dg-ts" x="590" y="693" text-anchor="middle" dominant-baseline="central">라이브러리</text>

<rect class="dg-teal" x="40" y="707" width="600" height="24" rx="0" stroke-width="0.3"/>
<text class="dg-ts dg-t-teal" x="170" y="719" text-anchor="middle" dominant-baseline="central">¬(A∧B) ≡ ¬A∨¬B</text>
<text class="dg-th dg-t-teal" x="410" y="719" text-anchor="middle" dominant-baseline="central" style="font-size:12px">not_and_or</text>
<text class="dg-ts dg-t-teal" x="590" y="719" text-anchor="middle" dominant-baseline="central">드모르간</text>

<rect x="40" y="733" width="600" height="24" rx="0" fill="none" stroke="#ccc" stroke-width="0.3"/>
<text class="dg-ts" x="170" y="745" text-anchor="middle" dominant-baseline="central">¬A∨A ≡ T</text>
<text class="dg-th" x="410" y="745" text-anchor="middle" dominant-baseline="central" style="font-size:12px">Classical.em</text>
<text class="dg-ts" x="590" y="745" text-anchor="middle" dominant-baseline="central">배중률</text>

<text class="dg-ts" x="340" y="790" text-anchor="middle">위 3줄: 직접 증명 전술 / 아래 3줄: 동치 변환 시 라이브러리 정리</text>
</svg>
</div>

<h2>1-2. 손 증명 (동치 변환)</h2>

<table>
<tr><th>단계</th><th>손 증명</th><th>사용한 법칙</th><th>Lean 4 라이브러리</th></tr>
<tr><td>0</td><td>(p ∧ q) → (p ∨ q)</td><td>원래 명제</td><td>--</td></tr>
<tr><td>1</td><td>≡ ¬(p ∧ q) ∨ (p ∨ q)</td><td>A → B ≡ ¬A ∨ B</td><td><code>imp_iff_not_or</code></td></tr>
<tr><td>2</td><td>≡ (¬p ∨ ¬q) ∨ (p ∨ q)</td><td>¬(A ∧ B) ≡ ¬A ∨ ¬B</td><td><code>not_and_or</code></td></tr>
<tr><td>3</td><td>≡ (¬p ∨ p) ∨ (¬q ∨ q)</td><td>결합 및 교환법칙</td><td><code>or_assoc</code>, <code>or_comm</code></td></tr>
<tr><td>4</td><td>≡ T ∨ T</td><td>배중률: ¬A ∨ A ≡ T</td><td><code>Classical.em</code></td></tr>
<tr><td>5</td><td>≡ T</td><td>T ∨ T ≡ T</td><td><code>or_self</code></td></tr>
</table>

<h2>1-3. Lean 4 직접 증명</h2>

<pre><code>example (p q : Prop) : (p ∧ q) → (p ∨ q) := by
  intro h              -- p ∧ q를 가정한다 (h : p ∧ q)
  exact Or.inl h.left  -- h에서 p를 꺼내서 p ∨ q의 왼쪽에 넣는다</code></pre>

<table>
<tr><th>손 증명의 사고 과정</th><th>Lean 4 코드</th><th>설명</th></tr>
<tr><td>"p ∧ q가 참이라고 가정하자"</td><td><code>intro h</code></td><td>조건문의 전제를 가정으로 도입</td></tr>
<tr><td>"p ∧ q에서 p를 꺼낸다"</td><td><code>h.left</code></td><td>단순화 논법: p ∧ q이면 p</td></tr>
<tr><td>"p가 참이면 p ∨ q도 참이다"</td><td><code>Or.inl h.left</code></td><td>가산 논법: p이면 p ∨ q</td></tr>
<tr><td>(증명 완료)</td><td><code>exact ...</code></td><td>목표와 일치하는 증거 제시</td></tr>
</table>

<h2>1-4. 각 동치 법칙의 Lean 대응물</h2>

<pre><code>-- 단계 1: A → B ≡ ¬A ∨ B
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
#check @or_self    -- a ∨ a ↔ a</code></pre>

<h2>1-5. 한 줄 자동 증명 / 학생 실습</h2>

<pre><code>-- 한 줄 자동 증명
example (p q : Prop) : (p ∧ q) → (p ∨ q) := by tauto

-- 학생 실습: 빈칸을 채우시오
example (p q : Prop) : (p ∧ q) → (p ∨ q) := by
  intro ______
  exact Or.inl ______
-- 정답: h, h.left</code></pre>

<hr class="part-divider">

<!-- ============================================ -->
<!-- 제2부: 드모르간 법칙 -->
<!-- ============================================ -->

<h1>제2부: 드모르간 법칙 ¬(P ∨ Q) ↔ (¬P ∧ ¬Q)</h1>

<div class="note">
"또는의 부정 = P도 아니고 Q도 아니다"<br>
↔ 이므로 두 방향을 각각 증명한다. 전체 증명의 첫 줄: <code>constructor</code>
</div>

<h2>2-1. 정방향 다이어그램: ¬(P ∨ Q) → (¬P ∧ ¬Q)</h2>

<div class="diagram-wrap">
<svg width="100%" viewBox="0 0 680 600" xmlns="http://www.w3.org/2000/svg">

<text class="dg-th" x="340" y="24" text-anchor="middle">¬(P ∨ Q) ↔ (¬P ∧ ¬Q)  드모르간 법칙</text>
<text class="dg-ts" x="340" y="42" text-anchor="middle">"또는의 부정 = P도 아니고 Q도 아니다"</text>

<rect class="dg-purple" x="40" y="56" width="600" height="28" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-purple" x="340" y="70" text-anchor="middle" dominant-baseline="central" style="font-size:12px">↔ 이므로 두 방향을 각각 증명한다 → constructor</text>

<text class="dg-th" x="340" y="108" text-anchor="middle">정방향: ¬(P ∨ Q) → (¬P ∧ ¬Q)</text>
<text class="dg-th" x="165" y="134" text-anchor="middle">손 증명</text>
<text class="dg-th" x="510" y="134" text-anchor="middle">Lean 4</text>
<line class="dg-divider" x1="340" y1="126" x2="340" y2="570"/>

<!-- 가정 -->
<rect class="dg-gray" x="40" y="148" width="260" height="36" rx="6" stroke-width="0.5"/>
<text class="dg-ts dg-t-gray" x="170" y="166" text-anchor="middle" dominant-baseline="central">¬(P ∨ Q)를 가정한다</text>
<rect class="dg-gray" x="370" y="148" width="270" height="36" rx="6" stroke-width="0.5"/>
<text class="dg-th dg-t-gray" x="505" y="166" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro h</text>
<line class="dg-leader" x1="300" y1="166" x2="368" y2="166"/>

<!-- constructor -->
<text class="dg-ts" x="170" y="202" text-anchor="middle">¬P, ¬Q를 각각 보인다</text>
<rect class="dg-teal" x="370" y="192" width="270" height="28" rx="6" stroke-width="0.5"/>
<text class="dg-th dg-t-teal" x="505" y="206" text-anchor="middle" dominant-baseline="central" style="font-size:12px">constructor</text>

<!-- ¬P -->
<rect class="dg-coral" x="40" y="232" width="260" height="120" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-coral" x="170" y="252" text-anchor="middle" dominant-baseline="central" style="font-size:12px">¬P 증명</text>
<text class="dg-ts dg-s-coral" x="170" y="274" text-anchor="middle" dominant-baseline="central">P를 가정한다</text>
<text class="dg-ts dg-s-coral" x="170" y="292" text-anchor="middle" dominant-baseline="central">(¬P를 보이므로 목표: False)</text>
<text class="dg-ts dg-s-coral" x="170" y="314" text-anchor="middle" dominant-baseline="central">P ∨ Q가 성립 (왼쪽)</text>
<text class="dg-ts dg-s-coral" x="170" y="334" text-anchor="middle" dominant-baseline="central">¬(P∨Q)와 모순 → ¬P</text>

<rect class="dg-coral" x="370" y="232" width="270" height="120" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-coral" x="505" y="252" text-anchor="middle" dominant-baseline="central" style="font-size:12px">첫째 목표: ⊢ ¬P</text>
<text class="dg-th dg-t-coral" x="505" y="276" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro hp</text>
<text class="dg-ts dg-s-coral" x="505" y="294" text-anchor="middle" dominant-baseline="central">hp : P, 목표: False</text>
<text class="dg-th dg-t-coral" x="505" y="316" text-anchor="middle" dominant-baseline="central" style="font-size:12px">apply h</text>
<text class="dg-ts dg-s-coral" x="505" y="334" text-anchor="middle" dominant-baseline="central">목표 False → P ∨ Q로 변경</text>
<text class="dg-th dg-t-coral" x="505" y="348" text-anchor="middle" dominant-baseline="central" style="font-size:12px">left; exact hp</text>
<line class="dg-leader" x1="300" y1="292" x2="368" y2="292"/>

<!-- ¬Q -->
<rect class="dg-amber" x="40" y="368" width="260" height="120" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-amber" x="170" y="388" text-anchor="middle" dominant-baseline="central" style="font-size:12px">¬Q 증명</text>
<text class="dg-ts dg-s-amber" x="170" y="410" text-anchor="middle" dominant-baseline="central">Q를 가정한다</text>
<text class="dg-ts dg-s-amber" x="170" y="428" text-anchor="middle" dominant-baseline="central">(¬Q를 보이므로 목표: False)</text>
<text class="dg-ts dg-s-amber" x="170" y="450" text-anchor="middle" dominant-baseline="central">P ∨ Q가 성립 (오른쪽)</text>
<text class="dg-ts dg-s-amber" x="170" y="470" text-anchor="middle" dominant-baseline="central">¬(P∨Q)와 모순 → ¬Q</text>

<rect class="dg-amber" x="370" y="368" width="270" height="120" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-amber" x="505" y="388" text-anchor="middle" dominant-baseline="central" style="font-size:12px">둘째 목표: ⊢ ¬Q</text>
<text class="dg-th dg-t-amber" x="505" y="412" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro hq</text>
<text class="dg-ts dg-s-amber" x="505" y="430" text-anchor="middle" dominant-baseline="central">hq : Q, 목표: False</text>
<text class="dg-th dg-t-amber" x="505" y="452" text-anchor="middle" dominant-baseline="central" style="font-size:12px">apply h</text>
<text class="dg-ts dg-s-amber" x="505" y="470" text-anchor="middle" dominant-baseline="central">목표 False → P ∨ Q로 변경</text>
<text class="dg-th dg-t-amber" x="505" y="484" text-anchor="middle" dominant-baseline="central" style="font-size:12px">right; exact hq</text>
<line class="dg-leader" x1="300" y1="430" x2="368" y2="430"/>

<!-- 완료 -->
<rect class="dg-green" x="160" y="504" width="360" height="32" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-green" x="340" y="520" text-anchor="middle" dominant-baseline="central">정방향 완료: ¬P ∧ ¬Q 증명됨</text>
</svg>
</div>

<h2>2-2. 역방향 다이어그램: (¬P ∧ ¬Q) → ¬(P ∨ Q) + 핵심 패턴</h2>

<div class="diagram-wrap">
<svg width="100%" viewBox="0 0 680 660" xmlns="http://www.w3.org/2000/svg">

<text class="dg-th" x="340" y="24" text-anchor="middle">역방향: (¬P ∧ ¬Q) → ¬(P ∨ Q)</text>
<text class="dg-th" x="165" y="52" text-anchor="middle">손 증명</text>
<text class="dg-th" x="510" y="52" text-anchor="middle">Lean 4</text>
<line class="dg-divider" x1="340" y1="44" x2="340" y2="400"/>

<!-- 가정 -->
<rect class="dg-gray" x="40" y="66" width="260" height="50" rx="6" stroke-width="0.5"/>
<text class="dg-ts dg-t-gray" x="170" y="82" text-anchor="middle" dominant-baseline="central">h : ¬P ∧ ¬Q를 가정</text>
<text class="dg-ts dg-t-gray" x="170" y="100" text-anchor="middle" dominant-baseline="central">¬(P∨Q) 증명 위해 hpq : P∨Q 가정</text>

<rect class="dg-gray" x="370" y="66" width="270" height="50" rx="6" stroke-width="0.5"/>
<text class="dg-th dg-t-gray" x="505" y="82" text-anchor="middle" dominant-baseline="central" style="font-size:12px">intro h hpq</text>
<text class="dg-ts dg-t-gray" x="505" y="100" text-anchor="middle" dominant-baseline="central">h : ¬P∧¬Q, hpq : P∨Q</text>
<line class="dg-leader" x1="300" y1="91" x2="368" y2="91"/>

<!-- cases -->
<rect class="dg-teal" x="40" y="130" width="260" height="28" rx="6" stroke-width="0.5"/>
<text class="dg-ts dg-t-teal" x="170" y="144" text-anchor="middle" dominant-baseline="central">P ∨ Q이므로 경우를 나눈다</text>
<rect class="dg-teal" x="370" y="130" width="270" height="28" rx="6" stroke-width="0.5"/>
<text class="dg-th dg-t-teal" x="505" y="144" text-anchor="middle" dominant-baseline="central" style="font-size:12px">cases hpq with</text>
<line class="dg-leader" x1="300" y1="144" x2="368" y2="144"/>

<!-- 경우 1 -->
<rect class="dg-coral" x="40" y="172" width="260" height="76" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-coral" x="170" y="192" text-anchor="middle" dominant-baseline="central" style="font-size:12px">경우 1: hp : P</text>
<text class="dg-ts dg-s-coral" x="170" y="212" text-anchor="middle" dominant-baseline="central">h.left : ¬P</text>
<text class="dg-ts dg-s-coral" x="170" y="232" text-anchor="middle" dominant-baseline="central">h.left hp : False</text>

<rect class="dg-coral" x="370" y="172" width="270" height="76" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-coral" x="505" y="192" text-anchor="middle" dominant-baseline="central" style="font-size:12px">| inl hp =></text>
<text class="dg-th dg-t-coral" x="505" y="216" text-anchor="middle" dominant-baseline="central" style="font-size:12px">exact h.left hp</text>
<text class="dg-ts dg-s-coral" x="505" y="236" text-anchor="middle" dominant-baseline="central">h.left hp : False</text>
<line class="dg-leader" x1="300" y1="212" x2="368" y2="212"/>

<!-- 경우 2 -->
<rect class="dg-amber" x="40" y="262" width="260" height="76" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-amber" x="170" y="282" text-anchor="middle" dominant-baseline="central" style="font-size:12px">경우 2: hq : Q</text>
<text class="dg-ts dg-s-amber" x="170" y="302" text-anchor="middle" dominant-baseline="central">h.right : ¬Q</text>
<text class="dg-ts dg-s-amber" x="170" y="322" text-anchor="middle" dominant-baseline="central">h.right hq : False</text>

<rect class="dg-amber" x="370" y="262" width="270" height="76" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-amber" x="505" y="282" text-anchor="middle" dominant-baseline="central" style="font-size:12px">| inr hq =></text>
<text class="dg-th dg-t-amber" x="505" y="306" text-anchor="middle" dominant-baseline="central" style="font-size:12px">exact h.right hq</text>
<text class="dg-ts dg-s-amber" x="505" y="326" text-anchor="middle" dominant-baseline="central">h.right hq : False</text>
<line class="dg-leader" x1="300" y1="302" x2="368" y2="302"/>

<!-- 완료 -->
<rect class="dg-green" x="160" y="354" width="360" height="32" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-green" x="340" y="370" text-anchor="middle" dominant-baseline="central">역방향 완료: ¬(P ∨ Q) 증명됨</text>

<!-- 핵심 패턴 -->
<text class="dg-th" x="340" y="420" text-anchor="middle">핵심 패턴 3가지</text>

<rect class="dg-purple" x="40" y="438" width="600" height="50" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-purple" x="55" y="456" text-anchor="start" dominant-baseline="central" style="font-size:12px">¬X 증명</text>
<text class="dg-ts" x="55" y="476" text-anchor="start" dominant-baseline="central">목표가 ¬X이면 → intro hx 후 목표는 False</text>

<rect class="dg-teal" x="40" y="494" width="600" height="50" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-teal" x="55" y="512" text-anchor="start" dominant-baseline="central" style="font-size:12px">¬X 사용</text>
<text class="dg-ts" x="55" y="532" text-anchor="start" dominant-baseline="central">목표가 False이고 hnx : ¬X, hx : X이면 → exact hnx hx</text>

<rect class="dg-coral" x="40" y="550" width="600" height="50" rx="8" stroke-width="0.5"/>
<text class="dg-th dg-t-coral" x="55" y="568" text-anchor="start" dominant-baseline="central" style="font-size:12px">apply h (역방향 추론)</text>
<text class="dg-ts" x="55" y="588" text-anchor="start" dominant-baseline="central">목표가 False이고 h : A→False이면 → apply h 후 목표가 A</text>
</svg>
</div>

<h2>2-3. 전체 Lean 4 코드 (복사용)</h2>

<pre><code>example (P Q : Prop) :
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
        exact h.right hq</code></pre>

<h2>2-4. 핵심 패턴 상세</h2>

<h3>¬X 증명하기</h3>
<pre><code>목표가 ¬X이면 → intro hx 후 목표는 False</code></pre>
<p>¬X는 X → False로 정의되어 있으므로, intro로 X를 가정하면 목표가 자동으로 False가 된다.</p>

<h3>¬X 사용하기</h3>
<pre><code>목표가 False이고, hnx : ¬X와 hx : X가 있으면 → exact hnx hx</code></pre>
<p>¬X는 X → False이므로, hnx에 hx를 넣으면 False가 나온다. 목표가 False일 때 바로 닫힌다.</p>

<h3>apply h (역방향 추론)</h3>
<pre><code>현재 목표가 False이고, h : A → False이면 → apply h 후 목표가 A로 바뀜</code></pre>
<p>apply h는 "h의 결론이 현재 목표와 같으므로, h의 입력을 제시하겠다"는 선언이다.</p>

<hr>

<h2>부록: ¬ 증명 vs 귀류법 -- 이 둘은 다르다</h2>

<table>
<tr><th></th><th>¬X 증명 (부정의 정의)</th><th>X 증명 (귀류법)</th></tr>
<tr><td>증명 대상</td><td>¬X</td><td>X</td></tr>
<tr><td>가정하는 것</td><td>X</td><td>¬X</td></tr>
<tr><td>모순 도출 후</td><td>¬X 성립 (정의 그대로)</td><td>X 성립 (배중률 필요)</td></tr>
<tr><td>Lean 전술</td><td><code>intro hx</code></td><td><code>by_contra hnx</code></td></tr>
<tr><td>논리 체계</td><td>직관주의에서도 가능</td><td>고전 논리 필요</td></tr>
</table>

<p>이 문서의 모든 증명에서 "P를 가정한다 → 모순"은 귀류법이 아니라 ¬P의 정의(P → False)를 직접 사용하는 것이다.</p>

<hr>

<h2>참고: 드모르간 법칙 쌍</h2>

<table>
<tr><th>법칙</th><th>식</th><th>손 증명 핵심</th><th>Lean 핵심 전술</th></tr>
<tr><td>¬(P∨Q) ↔ ¬P∧¬Q</td><td>또는의 부정</td><td>각 원소를 가정 → P∨Q 만들어 모순</td><td>intro + apply h + left/right</td></tr>
<tr><td>¬(P∧Q) ↔ ¬P∨¬Q</td><td>그리고의 부정</td><td>by_cases로 P 여부 나눔</td><td>by_cases + right/left</td></tr>
</table>

</body>
</html>
