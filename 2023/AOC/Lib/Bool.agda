open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Bool where
  open import AOC.Lib.Unit
    using (⊤; by)
  open import AOC.Lib.Conditional
    using (Conditional; conditional_choose:_)

  data Bool : Type where
    false : Bool
    true  : Bool
  {-# BUILTIN BOOL  Bool  #-}
  {-# BUILTIN TRUE  true  #-}
  {-# BUILTIN FALSE false #-}

  instance
    Bool-conditional : Conditional Bool
    Bool-conditional = conditional by
      choose: λ
        { true  x _ → x
        ; false _ y → y
        }
