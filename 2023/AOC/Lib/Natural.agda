open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Natural where
  open import AOC.Lib.Unit
    using (by)
  open import AOC.Lib.Bool
    using (Bool; true; false)
  open import AOC.Lib.Equality
    using (_≡_; refl; cong)
  open import AOC.Lib.Decidable
    as Dec
    using (Decidable₂; decidable₂_answer:_reason:_; Reflects)
    using (Dec; _because_)
    using (present; absent)

  data ℕ : Type where
    zero : ℕ
    succ : ℕ → ℕ
  {-# BUILTIN NATURAL ℕ #-}

  _≡?ᵇ_ : (x y : ℕ) → Bool
  zero   ≡?ᵇ zero   = true
  zero   ≡?ᵇ succ y = false
  succ x ≡?ᵇ zero   = false
  succ x ≡?ᵇ succ y = x ≡?ᵇ y
  {-# BUILTIN NATEQUALS _≡?ᵇ_ #-}

  instance
    ℕ-decidable : Decidable₂ (_≡_ {_} {ℕ})
    ℕ-decidable = decidable₂ by answer: _≡?ᵇ_ reason: _≡?ʳ_
      where
        _≡?ʳ_ : (x y : ℕ) → Reflects (x ≡ y) (x ≡?ᵇ y)
        zero   ≡?ʳ zero   = present refl
        zero   ≡?ʳ succ y = absent  λ()
        succ x ≡?ʳ zero   = absent  λ()
        succ x ≡?ʳ succ y = Dec.map' (cong succ) (λ{refl → refl}) _ (x ≡?ʳ y)

  _+_ : ℕ → ℕ → ℕ
  zero   + y = y
  succ x + y = succ (x + y)
  {-# BUILTIN NATPLUS _+_ #-}

  _∸_ : ℕ → ℕ → ℕ
  zero   ∸      y = zero
  succ x ∸ zero   = succ x
  succ x ∸ succ y = x ∸ y
  {-# BUILTIN NATMINUS _∸_ #-}

  _⋆_ : ℕ → ℕ → ℕ
  x ⋆ zero   = zero
  x ⋆ succ y = x + (x ⋆ y)
  {-# BUILTIN NATTIMES _⋆_ #-}
