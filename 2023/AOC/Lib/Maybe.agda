open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Maybe where
  open import AOC.Lib.Unit
    using (⊤; are)
  open import AOC.Lib.Composable
    using (id; _;_)
  open import AOC.Lib.Functions
    using (Fun-composable)

  data Maybe (A : Type) : Type where
    nothing :     Maybe A
    just    : A → Maybe A

  case_nothing:_just:_ : {A B : Type} → Maybe A → B → (A → B) → B
  case nothing nothing: n just: j = n
  case just a  nothing: n just: j = j a

  cases_nothing:_just:_ : ⊤ → {A B : Type} → B → (A → B) → Maybe A → B
  cases are nothing: n just: j = case_nothing: n just: j

  map : {A B : Type} → (A → B) → (Maybe A → Maybe B)
  map f = cases are nothing: nothing just: (f ; just)

  orElse : {A : Type} → A → (Maybe A → A)
  orElse x = cases are nothing: x just: id _
