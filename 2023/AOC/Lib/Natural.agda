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
    using (Decidable₂; decidable₂_decide:_)
    using (Dec; _because_)
    using (present; absent)

  data ℕ : Type where
    zero : ℕ
    succ : ℕ → ℕ
  {-# BUILTIN NATURAL ℕ #-}

  instance
    ℕ-decidable : Decidable₂ (_≡_ {_} {ℕ})
    ℕ-decidable = decidable₂ by decide: _≡?_
      where
        _≡?_ : (x y : ℕ) → Dec (x ≡ y)
        zero   ≡? zero   = true  because present refl
        zero   ≡? succ y = false because absent  λ()
        succ x ≡? zero   = false because absent  λ()
        succ x ≡? succ y = Dec.map (cong succ) (λ{refl → refl}) (x ≡? y)

  _+_ : ℕ → ℕ → ℕ
  zero   + y = y
  succ x + y = succ (x + y)

  _∸_ : ℕ → ℕ → ℕ
  zero   ∸      y = zero
  succ x ∸ zero   = succ x
  succ x ∸ succ y = x ∸ y

  _⋆_ : ℕ → ℕ → ℕ
  x ⋆ zero   = zero
  x ⋆ succ y = x + (x ⋆ y)

