open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Void where
  open import AOC.Lib.Product
    using (_×_; _,_)

  data ⊥ : Type where
    -- nothing!

  ⊥-elim : (A : Type) → ⊥ → A
  ⊥-elim A ()

  ⊥-pair : ⊥ × ⊥ → ⊥
  ⊥-pair (() , ())

