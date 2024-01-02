open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Conditional where
  open import AOC.Lib.Unit
    using (⊤; by)

  record Conditional (C : Type) : Type₁ where
    constructor conditional
    field if_then_else_ : {B : Type} → C → B → B → B
  open Conditional {{...}} public using (if_then_else_)

  conditional_choose:_ : ⊤ → {C : Type} → ({B : Type} → C → B → B → B) → Conditional C
  conditional by choose: cond = conditional cond
