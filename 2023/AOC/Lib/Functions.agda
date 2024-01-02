open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Functions where
  open import AOC.Lib.Unit
    using (by)
  open import AOC.Lib.Composable
    using (Composable; composable_id:_seq:_)

  Fun : ∀{ℓ} → Type ℓ → Type ℓ → Type ℓ
  Fun A B = A → B

  infixl 19 _⦊_
  _⦊_ : ∀{α β} {A : Type α} {B : Type β} → A → (A → B) → B
  x ⦊ f = f x

  instance
    Fun-composable : ∀{ℓ} → Composable (Fun {ℓ})
    Fun-composable = composable by
      id:  (λ _ ■ → ■)
      seq: (λ f g x → g (f x))
