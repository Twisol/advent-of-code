open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Void where
  data ⊥ : Type where
    -- nothing!

  ⊥-elim : (A : Type) → ⊥ → A
  ⊥-elim A ()
