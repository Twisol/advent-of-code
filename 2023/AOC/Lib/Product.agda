open import Agda.Primitive using (_⊔_) renaming (Set to Type)

module AOC.Lib.Product where
  infixl 10 _,_
  record Σ {α β} (A : Type α) (B : A → Type β) : Type (α ⊔ β) where
    constructor _,_
    field left : A
    field right : B left
  {-# BUILTIN SIGMA Σ #-}

  open Σ public using (left; right)

  _×_ : (A B : Type) → Type
  A × B = Σ A (λ _ → B)

  Δ : {A : Type} → A → A × A
  Δ x = (x , x)

  bimap : {A B C D : Type} → (A → C) → (B → D) → ((A × B) → (C × D))
  bimap f g (a , b) = (f a , g b)

  bimap' : {A B C D : Type} → ((A → C) × (B → D)) → ((A × B) → (C × D))
  bimap' (f , g) = bimap f g
