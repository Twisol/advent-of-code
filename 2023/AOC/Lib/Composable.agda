open import Agda.Primitive using (_⊔_) renaming (Set to Type)

module AOC.Lib.Composable where
  open import AOC.Lib.Unit
    using (⊤; by)

  record Composable {α β} {O : Type α} (_↝_ : O → O → Type β) : Type (α ⊔ β) where
    constructor composable
    infixl 21 _;_
    field id : ∀ a → (a ↝ a)
    field _;_ : ∀{a b c} → (a ↝ b) → (b ↝ c) → (a ↝ c)
  open Composable {{...}} public using (id; _;_)

  infixr 21 _∘_
  _∘_ : ∀{α β} {O : Type α} {_↝_ : O → O → Type β} → {{Composable _↝_}}
      → ∀{a b c} → (b ↝ c) → (a ↝ b) → (a ↝ c)
  g ∘ f = f ; g

  composable_id:_seq:_ : ⊤ → ∀{α β} {O : Type α} {_↝_ : O → O → Type β}
                       → (∀ a → (a ↝ a))
                       → (∀{a b c} → (a ↝ b) → (b ↝ c) → (a ↝ c))
                       → Composable _↝_
  composable by id: id seq: seq = composable id seq

  Monoid : ∀{α} → Type α → Type α
  Monoid T = Composable {_} {_} {⊤} (λ _ _ → T)
