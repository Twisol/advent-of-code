open import Agda.Primitive using (_⊔_; lzero; lsuc) renaming (Set to Type)

module AOC.Lib.Equality where
  open import AOC.Lib.Unit
    using (by)
  open import AOC.Lib.Composable
    using (Composable; composable_id:_seq:_)

  data _≡_ {α} {A : Type α} (x : A) : A → Type α where
    instance refl : x ≡ x
  {-# BUILTIN EQUALITY _≡_ #-}

  cong : ∀{α β} {A : Type α} {B : Type β} {x y : A} (f : A → B) → (x ≡ y) → (f x ≡ f y)
  cong _ refl = refl

  sym : ∀{α} {A : Type α} {x y : A} → (x ≡ y) → (y ≡ x)
  sym refl = refl

  trans : ∀{α} {A : Type α} {x y z : A} → (x ≡ y) → (y ≡ z) → (x ≡ z)
  trans refl y≡z = y≡z

  trans-idʳ : ∀{α} {A : Type α} {x y z : A} → (x≡y : x ≡ y) → (trans x≡y refl ≡ x≡y)
  trans-idʳ refl = refl

  instance
    ≡-composable : ∀{ℓ} {A : Type ℓ} → Composable (_≡_ {_} {A})
    ≡-composable = composable by
      id:  (λ _ → refl)
      seq: trans
