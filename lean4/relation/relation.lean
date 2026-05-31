import Mathlib



-- A × B 는 곱 타입. (a, b) 는 그 타입의 값이다.
def p : Nat × Nat := (3, 5)

-- .1 은 첫째 성분, .2 는 둘째 성분을 꺼낸다.
example : p.1 = 3 := rfl
example : p.2 = 5 := rfl

-- 곱 타입은 세 개 이상으로도 중첩된다: Nat × Nat × Nat
def t : Nat × Nat × Nat := (3, 4, 27)


example (a c b d : Nat) :
    ((a, b) = (c, d))
      ↔ (a = c ∧ b = d) := by
  -- 정의에 해당하는 정리로 재서술
  rw [Prod.mk.injEq]


example (x y : Int)
    (h : ((2*x + 1, (5:Int)) = (7, y + 3))) :
    x = 3 ∧ y = 2 := by
  -- (1) 순서쌍 상등으로 성분별 등식 두 개를 얻는다
  rw [Prod.mk.injEq] at h
  -- 이제 h : 2*x + 1 = 7 ∧ 5 = y + 3
  obtain ⟨h1, h2⟩ := h
  -- (2) 각 성분의 결론을 산술로 닫는다
  constructor
  · omega
  · omega


-- 관계: 두 인수를 받아 명제를 돌려주는 함수
def Le : Nat → Nat → Prop := fun a b => a ≤ b

-- a R b 는 Lean 에서 R a b 로 쓴다.
example : Le 1 3 := by
  show 1 ≤ 3
  omega

-- 항등관계
def IdRel (A : Type) :
    A → A → Prop :=
  fun x y => x = y

-- 모든 x 에 대해 x 는 자기 자신과 항등관계에 있다
example (x : Nat) :
    IdRel Nat x x := by
  show x = x
  rfl


-- 합성: a 에서 b 로 R, b 에서 c 로 S 면, a 에서 c 로 S∘R
def Comp {A : Type} (R S : A → A → Prop) :
    A → A → Prop :=
  fun a c => ∃ b, R a b ∧ S b c

-- R 의 제곱: R 을 두 번 합성
def RPow2 {A : Type} (R : A → A → Prop) :
    A → A → Prop :=
  Comp R R


example {A : Type}
    (R : A → A → Prop)
    (a b c : A)
    (hab : R a b)
    (hbc : R b c) :
    Comp R R a c := by
  -- 목표: ∃ m, R a m ∧ R m c
  -- 중간 정점으로 b 를 제시
  exact ⟨b, hab, hbc⟩


example {A : Type} (R S T : A → A → Prop) (a d : A) :
    Comp (Comp R S) T a d ↔ Comp R (Comp S T) a d := by
  constructor
  · rintro ⟨c, ⟨b, hRab, hSbc⟩, hTcd⟩
    -- 왼쪽 묶음을 풀면 b, c 라는 두 중간 정점이 나온다
    exact ⟨b, hRab, c, hSbc, hTcd⟩
  · rintro ⟨b, hRab, c, hSbc, hTcd⟩
    -- 오른쪽 묶음을 풀어 같은 b, c 로 왼쪽을 구성
    exact ⟨c, ⟨b, hRab, hSbc⟩, hTcd⟩


variable {A : Type}

def Refl  (R : A → A → Prop) : Prop := ∀ a, R a a
def Symm  (R : A → A → Prop) : Prop := ∀ a b, R a b → R b a
def Trans1 (R : A → A → Prop) : Prop :=
  ∀ a b c, R a b → R b c → R a c
def Antisymm (R : A → A → Prop) : Prop :=
  ∀ a b, R a b → R b a → a = b

-- 동치관계: 세 성질을 ∧ 로 묶는다
def Equiv1 (R : A → A → Prop) : Prop :=
  Refl R ∧ Symm R ∧ Trans1 R


def Le1 : Nat → Nat → Prop :=
  fun a b => a ≤ b

-- Le 는 반사관계
example : Refl Le := by
  -- 목표: ∀ a, Le a a
  intro a
  show a ≤ a
  omega


def EqR (A : Type) :
    A → A → Prop :=
  fun a b => a = b


example {A : Type} :
    Symm (EqR A) := by
  -- ∀ a b, a=b → b=a
  intro a b h
  show b = a
  exact h.symm


example : Trans1 Le1 := by
  -- ∀ a b c, Le1 a b → Le1 b c → Le1 a c
  intro a b c hab hbc
  -- hab : Le1 a b
  -- hbc : Le1 b c
  unfold Le1 at hab hbc
  -- 이제 hab : a ≤ b, hbc : b ≤ c
  show a ≤ c
  omega


example {A : Type} : Equiv1 (EqR A) := by
  -- 목표: Refl (EqR A) ∧ Symm (EqR A) ∧ Trans1 (EqR A)
  constructor
  · intro a
    show a = a
    rfl
  · constructor
    · intro a b h
      show b = a
      exact h.symm
    · intro a b c hab hbc
      show a = c
      exact Eq.trans hab hbc


example : Antisymm Le := by
  -- 목표: ∀ a b, Le a b → Le b a → a = b
  intro a b hab hba
  -- hab : a ≤ b, hba : b ≤ a 가 되도록 Le 의 정의를 펼친다
  unfold Le at hab hba
  show a = b
  omega


variable {A : Type}

-- 역관계: a 와 b 의 자리를 바꾼다
def Inv1 (R : A → A → Prop) : A → A → Prop :=
  fun a b => R b a

-- 여관계: 관계의 부정
def Compl1 (R : A → A → Prop) : A → A → Prop :=
  fun a b => ¬ R a b


example (R : A → A → Prop)
    (a b : A) :
    Inv1 (Inv1 R) a b ↔ R a b := by
  -- Inv1 (Inv1 R) a b
  --   = Inv1 R b a
  --   = R a b
  rfl


def R1 : Nat → Nat → Prop := fun a b => a = 1 ∧ b = 2
def S1 : Nat → Nat → Prop := fun a b => a = 2 ∧ b = 3

-- (1,3) 은 S∘R 에 있다: 중간 원소 2 를 거친다
example : Comp R1 S1 1 3 :=
  ⟨2, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

-- (1,3) 은 R∘S 에는 없다
example : ¬ Comp S1 R1 1 3 := by
  rintro ⟨b, ⟨h1, h2⟩, h3⟩
  omega


variable {A : Type}

-- 반사폐포: R 에 항등관계를 합한다
def ReflClosure (R : A → A → Prop) : A → A → Prop :=
  fun a b => R a b ∨ a = b

-- 대칭폐포: R 에 역관계를 합한다
def SymmClosure (R : A → A → Prop) : A → A → Prop :=
  fun a b => R a b ∨ R b a


example (R : A → A → Prop) (a b : A) (h : R a b) :
    ReflClosure R a b := by
  left
  exact h


example (R : A → A → Prop) : Symm (SymmClosure R) := by
  intro a b h
  cases h with
  | inl hab =>
      right
      exact hab
  | inr hba =>
      left
      exact hba


