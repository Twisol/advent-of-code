open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Functions where
  open import AOC.Lib.Unit
    using (by)
  open import AOC.Lib.Composable
    using (Composable; composable_id:_seq:_)
  open import AOC.Lib.Product
    using (Σ; _×_; _,_)

  Fun : ∀{ℓ} → Type ℓ → Type ℓ → Type ℓ
  Fun A B = A → B

  infixl 19 _⦊_
  _⦊_ : ∀{α β} {A : Type α} {B : Type β} → A → (A → B) → B
  x ⦊ f = f x

  map : ∀{α β δ} {A : Type α} {B : Type β} {C : Type δ}
      → (B → C) → ((A → B) → (A → C))
  map g f x = g (f x)

  pair : ∀{A B C} → ((A → B) × (A → C)) → (A → (B × C))
  pair (f , g) a = (f a , g a)

  curry : {A B C : Type} → ((A × B) → C) → (A → (B → C))
  curry f a b = f (a , b)

  curry' : {A : Type} {B : A → Type} {C : Σ A B → Type}
         → ((ab : Σ A B) → C ab) → ((a : A) → (b : B a) → C (a , b))
  curry' f a b = f (a , b)

  uncurry : {A B C : Type} → (A → (B → C)) → ((A × B) → C)
  uncurry f (a , b) = f a b

  uncurry' : {A : Type} {B : A → Type} {C : Σ A B → Type}
           → ((a : A) → (b : B a) → C (a , b)) → ((ab : Σ A B) → C ab)
  uncurry' f (a , b) = f a b

  instance
    Fun-composable : ∀{ℓ} → Composable (Fun {ℓ})
    Fun-composable = composable by
      id:  (λ _ ■ → ■)
      seq: (λ f g x → g (f x))
