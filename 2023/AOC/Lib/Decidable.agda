open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Decidable where
  open import AOC.Lib.Equality
    using (_≡_; refl)
  open import AOC.Lib.Unit
    using (⊤; by; tt)
  open import AOC.Lib.Void
    using (⊥; ⊥-elim; ⊥-pair)
  open import AOC.Lib.Functions
    using (Fun-composable; _⦊_)
  open import AOC.Lib.Composable
    using (_;_; id)
  open import AOC.Lib.Bool
    using (Bool; true; false; _∧_)
  open import AOC.Lib.Product
    using (_×_; _,_; right; left; bimap)

  data Reflects (A : Type) : Bool → Type where
    present : ( p : A    ) → Reflects A true
    absent  : (¬p : A → ⊥) → Reflects A false

  record Dec (P : Type) : Type where
    constructor _because_
    field answer : Bool
    field reason : Reflects P answer
  open Dec public using (answer; reason)

  map' : {A B : Type} → (A → B) → (B → A) → (b : Bool) → (Reflects A b → Reflects B b)
  map' f g false (absent ¬p) = absent (g ; ¬p)
  map' f g true  (present p) = present (f p)

  map : {A B : Type} → (A → B) → (B → A) → (Dec A → Dec B)
  answer (map f g x) = answer x
  reason (map f g (b because r)) = map' f g b r

  pair : {A B : Type} → Dec A → Dec B → Dec (A × B)
  answer (pair x y) = answer x ∧ answer y
  reason (pair (true  because present p) (true  because present q)) =
    present (p , q)
  reason (pair (true  because present p) (false because absent ¬q)) =
    absent (right ; ¬q)
  reason (pair (false because absent ¬p) (true  because present q)) =
    absent (left ; ¬p)
  reason (pair (false because absent ¬p) (false because absent ¬q)) =
    absent (bimap ¬p ¬q ; ⊥-pair)

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

  decidable₂_answer:_reason:_ : ⊤ → {I₁ I₂ : Type} {P : I₁ → I₂ → Type}
                              → (answer : I₁ → I₂ → Bool)
                              → (reason : ∀ i₁ i₂ → Reflects (P i₁ i₂) (answer i₁ i₂))
                              → Decidable₂ P
  decidable₂ by answer: a reason: r = decidable₂ (λ i₁ i₂ → a i₁ i₂ because r i₁ i₂)

  Decidable₁↓ : ∀{I} {P : I → Type} (_ : Decidable₁ P)
              → ∀{i} → Decidable₀ (P i)
  Decidable₁↓ ⟨P⟩ = decidable₀ by decide: decide₁ {{⟨P⟩}} _

  Decidable₂↓ : ∀{I₁ I₂} {P : I₁ → I₂ → Type} (_ : Decidable₂ P)
              → ∀{i₁} → Decidable₁ (P i₁)
  Decidable₂↓ ⟨P⟩ = decidable₁ by decide: decide₂ {{⟨P⟩}} _

  infix 18 _?? _?ᵇ _?ᵖ

  _?? : (P : Type) {{_ : Decidable₀ P}} → Dec P
  P ?? = decide₀

  _?ᵇ : (P : Type) {{_ : Decidable₀ P}} → Bool
  P ?ᵇ = Dec.answer (P ??)

  _?ᵖ : (P : Type) {{_ : Decidable₀ P}} → Reflects P (P ?ᵇ)
  P ?ᵖ = Dec.reason (P ??)

  module _ {I : Type} where
    infix 19 _is_
    _is_ : (i : I) → (P : I → Type) → Type
    i is P = P i

    {- deprecated in favor of _is'_ and _?? -}
    _is'_??' : (i : I) → (P : I → Type) {{_ : Decidable₁ P}} → Dec (P i)
    i is' P ??' = decide₁ i

    {- deprecated in favor of _is'_ and _?ᵇ -}
    _is'_?ᵇ' : I → (P : I → Type) {{_ : Decidable₁ P}} → Bool
    i is' P ?ᵇ' = Dec.answer (i is' P ??')

    {- deprecated in favor of _is'_ and _?ᵖ -}
    _is'_?ᵖ' : (i : I) → (P : I → Type) {{_ : Decidable₁ P}} → Reflects (P i) (i is' P ?ᵇ')
    i is' P ?ᵖ' = Dec.reason (i is' P ??')

  DecidableEquality : Type → Type
  DecidableEquality A = Decidable₂ (_≡_ {_} {A})

  module _ {A : Type} {{⟨A⟩ : DecidableEquality A}} where
    _≟_ : (x y : A) → Dec (x ≡ y)
    _≟_ = decide₂

    _≟ᵇ_ : A → A → Bool
    x ≟ᵇ y = Dec.answer (x ≟ y)

    _≟ᵖ_ : (x y : A) → Reflects (x ≡ y) (x ≟ᵇ y)
    x ≟ᵖ y = Dec.reason (x ≟ y)

    instance
      ≡-decidable₁ˡ : {x : A} → Decidable₁ (x ≡_)
      ≡-decidable₁ˡ {x} = decidable₁ by decide: (x ≟_)

      ≡-decidable₁ʳ : {y : A} → Decidable₁ (_≡ y)
      ≡-decidable₁ʳ {y} = decidable₁ by decide: (_≟ y)

      ≡-decidable₀ : {x y : A} → Decidable₀ (x ≡ y)
      ≡-decidable₀ {x} {y} = decidable₀ by decide: (x ≟ y)

  instance
    Bool-decidable : DecidableEquality Bool
    Bool-decidable = decidable₂ by
      decide: λ
        { false false → true  because present refl
        ; false true  → false because absent  (λ ())
        ; true  false → false because absent  (λ ())
        ; true  true  → true  because present refl
        }

  instance
    ×-decidable : ∀{A} {{_ : Decidable₀ A}}
                → ∀{B} {{_ : Decidable₀ B}}
                → Decidable₀ (A × B)
    ×-decidable = decidable₀ by
      decide: pair decide₀ decide₀

  instance
    ⊤-decidable : Decidable₀ ⊤
    ⊤-decidable = decidable₀ by
      decide: (true because present tt)

  instance
    ⊥-decidable : Decidable₀ ⊥
    ⊥-decidable = decidable₀ by
      decide: (false because absent (id _))

  if_then_else_ : {A : Type}
                → (Pred : Type) {{_ : Decidable₀ Pred}}
                → (ift : {{Pred}} → A)
                → (iff : {{Pred → ⊥}} → A)
                → A
  if Pred then ift else iff with Pred ??
  ... | false because absent ¬p = iff {{¬p}}
  ... | true  because present p = ift {{p}}

  -- Bad instances -- these overlap often, causing instance search to fail.
  -- Use Decidable₁↓ etc. to explicitly construct instances for specific predicates.
{-
  instance
    Decidable₁-decidable : ∀{I} {P : I → Type} {{_ : Decidable₁ P}}
                         → ∀{i} → Decidable₀ (P i)
    Decidable₁-decidable = decidable₀ by decide: decide₁ _

  instance
    Decidable₂-decidable : ∀{I₁ I₂} {P : I₁ → I₂ → Type} {{_ : Decidable₂ P}}
                         → ∀{i₁} → Decidable₁ (P i₁)
    Decidable₂-decidable = decidable₁ by decide: decide₂ _
-}
