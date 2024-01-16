open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Bool where
  open import AOC.Lib.Unit
    using (⊤; by)
  open import AOC.Lib.Void
    using (⊥; ⊥-elim)
  open import AOC.Lib.Equality
    using (_≡_; refl)

  data Bool : Type where
    false : Bool
    true  : Bool
  {-# BUILTIN BOOL  Bool  #-}
  {-# BUILTIN TRUE  true  #-}
  {-# BUILTIN FALSE false #-}

  !_ : Bool → Bool
  !_ false = true
  !_ true  = false

  _∧_ : Bool → Bool → Bool
  false ∧ _     = false
  true  ∧ false = false
  true  ∧ true  = true

  _∨_ : Bool → Bool → Bool
  true  ∨ _     = true
  false ∨ true  = true
  false ∨ false = false

  x≢b⇒x≡!b : ∀{x b} → ((x ≡ b) → ⊥) → (x ≡ (! b))
  x≢b⇒x≡!b {false} {false} p = ⊥-elim _ (p refl)
  x≢b⇒x≡!b {false} {true}  _ = refl
  x≢b⇒x≡!b {true}  {false} _ = refl
  x≢b⇒x≡!b {true}  {true}  p = ⊥-elim _ (p refl)
