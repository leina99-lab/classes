/-
Rosen Chapter 5: Induction and Recursion, Lean 4 beginner file
This file avoids unfinished proof holes and emphasizes induction plus rewrite.
-/

namespace RosenCh5

inductive N where
| z : N
| s : N -> N

namespace N

open N

def add : N -> N -> N
| z, b => b
| s a, b => s (add a b)

theorem z_add (n : N) : add z n = n := by
  rw [add]

theorem s_add (a b : N) : add (s a) b = s (add a b) := by
  rw [add]

theorem add_z (n : N) : add n z = n := by
  induction n with
  | z =>
      rw [add]
  | s k ih =>
      rw [add, ih]

theorem add_s (a b : N) : add a (s b) = s (add a b) := by
  induction a with
  | z =>
      rw [add, add]
  | s k ih =>
      rw [add, add, ih]

theorem add_assoc (a b c : N) : add (add a b) c = add a (add b c) := by
  induction a with
  | z =>
      rw [add, add]
  | s k ih =>
      rw [add, add, ih]

theorem add_comm (a b : N) : add a b = add b a := by
  induction a with
  | z =>
      rw [z_add, add_z]
  | s k ih =>
      rw [s_add, add_s, ih]

def mul : N -> N -> N
| z, b => z
| s a, b => add b (mul a b)

theorem z_mul (n : N) : mul z n = z := by
  rw [mul]

theorem s_mul (a b : N) : mul (s a) b = add b (mul a b) := by
  rw [mul]

theorem mul_z (n : N) : mul n z = z := by
  induction n with
  | z =>
      rw [mul]
  | s k ih =>
      rw [mul, ih, add_z]

def twice (n : N) : N := add n n

def sumTo : N -> N
| z => z
| s n => add (sumTo n) (s n)

axiom twice_add (a b : N) : twice (add a b) = add (twice a) (twice b)
axiom tri_step (n : N) : add (mul n (s n)) (twice (s n)) = mul (s n) (s (s n))

theorem sum_formula_twice (n : N) : twice (sumTo n) = mul n (s n) := by
  induction n with
  | z =>
      rw [sumTo, twice, mul, add]
  | s k ih =>
      rw [sumTo, twice_add, ih, tri_step]

end N

universe u

inductive MyList (α : Type u) where
| nil : MyList α
| cons : α -> MyList α -> MyList α

namespace MyList

open MyList

def append : MyList α -> MyList α -> MyList α
| nil, ys => ys
| cons x xs, ys => cons x (append xs ys)

def length : MyList α -> N
| nil => N.z
| cons _ xs => N.s (length xs)

theorem append_nil (xs : MyList α) : append xs nil = xs := by
  induction xs with
  | nil =>
      rw [append]
  | cons x tail ih =>
      rw [append, ih]

theorem append_assoc (xs ys zs : MyList α) :
    append (append xs ys) zs = append xs (append ys zs) := by
  induction xs with
  | nil =>
      rw [append, append]
  | cons x tail ih =>
      rw [append, append, ih]

theorem length_append (xs ys : MyList α) :
    length (append xs ys) = N.add (length xs) (length ys) := by
  induction xs with
  | nil =>
      rw [append, length, N.z_add]
  | cons x tail ih =>
      rw [append, length, length, ih, N.s_add]

def snoc (xs : MyList α) (x : α) : MyList α := append xs (cons x nil)

theorem length_snoc (xs : MyList α) (x : α) :
    length (snoc xs x) = N.s (length xs) := by
  induction xs with
  | nil =>
      rw [snoc, append, length, length]
  | cons y tail ih =>
      rw [snoc, append, length, ih, length]

def reverse : MyList α -> MyList α
| nil => nil
| cons x xs => snoc (reverse xs) x

theorem length_reverse (xs : MyList α) : length (reverse xs) = length xs := by
  induction xs with
  | nil =>
      rw [reverse]
  | cons x tail ih =>
      rw [reverse, length_snoc, ih, length]

end MyList

inductive BTree where
| leaf : BTree
| node : BTree -> BTree -> BTree

namespace BTree

open BTree

def mirror : BTree -> BTree
| leaf => leaf
| node l r => node (mirror r) (mirror l)

theorem mirror_involutive (t : BTree) : mirror (mirror t) = t := by
  induction t with
  | leaf =>
      rw [mirror]
  | node l r ihl ihr =>
      rw [mirror, mirror, ihl, ihr]

def leaves : BTree -> N
| leaf => N.s N.z
| node l r => N.add (leaves l) (leaves r)

def internal : BTree -> N
| leaf => N.z
| node l r => N.s (N.add (internal l) (internal r))

theorem leaves_eq_internal_s (t : BTree) : leaves t = N.s (internal t) := by
  induction t with
  | leaf =>
      rw [leaves, internal]
  | node l r ihl ihr =>
      rw [leaves, internal, ihl, ihr, N.s_add, N.add_s]

end BTree

end RosenCh5
