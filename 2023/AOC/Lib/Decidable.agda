open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Decidable where
  open import AOC.Lib.Equality
    using (_≡_; refl)
  open import AOC.Lib.Unit
    using (⊤; by)
  open import AOC.Lib.Void
    using (⊥)
  open import AOC.Lib.Functions
    using (Fun-composable)
  open import AOC.Lib.Composable
    using (_;_)
  open import AOC.Lib.Conditional
    using (Conditional; conditional_choose:_; if_then_else_)
  open import AOC.Lib.Bool
    using (Bool; true; false; Bool-conditional)

  data Reflects (A : Type) : Bool → Type where
    present : ( p : A    ) → Reflects A true
    absent  : (¬p : A → ⊥) → Reflects A false

  record Dec (P : Type) : Type where
    constructor _because_
    field answer : Bool
    field reason : Reflects P answer
  open Dec public using (answer; reason)

  instance
    Dec-conditional : {P : Type} → Conditional (Dec P)
    Dec-conditional {P} = conditional by
      choose: answer ; if_then_else_

  map : {A B : Type} → (A → B) → (B → A) → (Dec A → Dec B)
  answer (map f g x) = answer x
  reason (map f g (_ because present p)) = present (f p)
  reason (map f g (_ because absent ¬p)) = absent  (λ b → ¬p (g b))


  record Decidable₀ (P : Type) : Type where
    constructor decidable₀
    field decide₀ : Dec P
  open Decidable₀ {{...}} public using (decide₀)

  record Decidable₁ {I₁ : Type} (P : I₁ → Type) : Type where
    constructor decidable₁
    field decide₁ : ∀ i₁ → Dec (P i₁)
  open Decidable₁ {{...}} public using (decide₁)

  record Decidable₂ {I₁ I₂ : Type} (P : I₁ → I₂ → Type) : Type where
    constructor decidable₂
    field decide₂ : ∀ i₁ i₂ → Dec (P i₁ i₂)
  open Decidable₂ {{...}} public using (decide₂)

  decidable₀_decide:_ : ⊤ → {P : Type}
                      → Dec P
                      → Decidable₀ P
  decidable₀ by decide: d = decidable₀ d

  decidable₁_decide:_ : ⊤ → {I₁ : Type} {P : I₁ → Type}
                      → (∀ i₁ → Dec (P i₁))
                      → Decidable₁ P
  decidable₁ by decide: d = decidable₁ d

  decidable₁_answer:_reason:_ : ⊤ → {I₁ : Type} {P : I₁ → Type}
                              → (answer : I₁ → Bool)
                              → (reason : ∀ i₁ → Reflects (P i₁) (answer i₁))
                              → Decidable₁ P
  decidable₁ by answer: a reason: r = decidable₁ (λ i₁ → a i₁ because r i₁)

  decidable₂_decide:_ : ⊤ → {I₁ I₂ : Type} {P : I₁ → I₂ → Type}
                      → (∀ i₁ i₂ → Dec (P i₁ i₂))
                      → Decidable₂ P
  decidable₂ by decide: d = decidable₂ d

  module _ {I : Type} where
    _is_?? : (i : I) → (P : I → Type) {{_ : Decidable₁ P}} → Dec (P i)
    i is P ?? = decide₁ i

    _is_?ᵇ : I → (P : I → Type) {{_ : Decidable₁ P}} → Bool
    i is P ?ᵇ = Dec.answer (i is P ??)

    _is_?ᵖ : (i : I) → (P : I → Type) {{_ : Decidable₁ P}} → Reflects (P i) (i is P ?ᵇ)
    i is P ?ᵖ = Dec.reason (i is P ??)

  DecidableEquality : Type → Type
  DecidableEquality A = Decidable₂ (_≡_ {_} {A})

  module _ {A : Type} {{_ : DecidableEquality A}} where
    _≟_ : (x y : A) → Dec (x ≡ y)
    _≟_ = decide₂

    _≟ᵇ_ : A → A → Bool
    x ≟ᵇ y = Dec.answer (x ≟ y)

    _≟ᵖ_ : (x y : A) → Reflects (x ≡ y) (x ≟ᵇ y)
    x ≟ᵖ y = Dec.reason (x ≟ y)

    instance
      ≡ʳ-decidable : {x : A} → Decidable₁ (x ≡_)
      ≡ʳ-decidable {x} = decidable₁ by decide: (x ≟_)

    instance
      ≡ˡ-decidable : {x : A} → Decidable₁ (_≡ x)
      ≡ˡ-decidable {x} = decidable₁ by decide: (_≟ x)

  -- Every boolean function `A → Bool` yields a decidable predicate.
  instance
    BoolFun₁-decidable : {A : Type} {f : A → Bool} → Decidable₁ (λ a → f a ≡ true)
    BoolFun₁-decidable {A} {f} = decidable₁ by
      answer: f
      reason: r
      where
        r : (a : A) → Reflects (f a ≡ true) (f a)
        r a with f a
        ... | false = absent  λ()
        ... | true  = present refl

