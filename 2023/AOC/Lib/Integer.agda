open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Integer where
  open import AOC.Lib.Natural
    using (ℕ)

  data ℤ : Type where
    pos     : ℕ → ℤ
    negsucc : ℕ → ℤ
  {-# BUILTIN INTEGER       ℤ       #-}
  {-# BUILTIN INTEGERPOS    pos     #-}
  {-# BUILTIN INTEGERNEGSUC negsucc #-}
