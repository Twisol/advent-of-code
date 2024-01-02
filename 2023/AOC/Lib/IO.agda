open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.IO where
  open import AOC.Lib.Unit
    using (by)
  open import AOC.Lib.Functions
    using (Fun-composable)
  open import AOC.Lib.Composable
    using (Composable; composable_id:_seq:_; _;_)

  postulate       IO : Type → Type
  {-# BUILTIN IO  IO #-}
  {-# COMPILE GHC IO = type IO #-}

  postulate       pure : ∀{A} → A → IO A
  {-# COMPILE GHC pure = \_ -> pure #-}

  postulate       bind : ∀{A B} → (A → IO B) → (IO A → IO B)
  {-# COMPILE GHC bind = \_ _ -> (=<<) #-}

  return : {A : Type} → A → IO A
  return = pure

  _>>=_ : {A B : Type} → IO A → (A → IO B) → IO B
  x >>= f = bind f x

  _>>_ : {A B : Type} → IO A → IO B → IO B
  x >> y = bind (λ _ → y) x

  lift : {A B : Type} → (A → B) → (A → IO B)
  lift f = f ; pure

  map : {A B : Type} → (A → B) → (IO A → IO B)
  map = lift ; bind

  IOAct : Type → Type → Type
  IOAct A B = A → IO B

  instance
    IOAct-composable : Composable IOAct
    IOAct-composable = composable by
      id:  (λ _ → pure)
      seq: (λ f g → f ; bind g)


  open import AOC.Lib.Unit
    using (⊤)
  open import AOC.Lib.String
    using (String)

  postulate       putStrLn : String → IO ⊤
  {-# COMPILE GHC putStrLn = putStrLn #-}
  postulate       putStr : String → IO ⊤
  {-# COMPILE GHC putStr = putStr #-}
  postulate       readFile : String → IO String
  {-# COMPILE GHC readFile = readFile #-}
