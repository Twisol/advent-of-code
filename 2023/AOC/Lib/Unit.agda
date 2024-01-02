open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Unit where
  record ⊤ : Type where
    instance constructor tt
  {-# BUILTIN UNIT ⊤                #-}
  {-# COMPILE GHC  ⊤ = data () (()) #-}

  -- Used for some syntax tricks, as in `List.cases are nil: [] cons: _∷_`.
  pattern are = tt
  pattern by  = tt
