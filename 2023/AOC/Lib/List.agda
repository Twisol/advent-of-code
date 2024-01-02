open import Agda.Primitive using (_⊔_; lzero; lsuc) renaming (Set to Type)

module AOC.Lib.List where
  open import AOC.Lib.Composable
    using (Monoid; composable_id:_seq:_; id; _;_)
  open import AOC.Lib.Conditional
    using (if_then_else_)
  open import AOC.Lib.Decidable
    using (Decidable₁; _is_??; Dec-conditional)

  open import AOC.Lib.Unit
    using (⊤; are; by)
  open import AOC.Lib.Maybe
    using (Maybe; nothing; just)
  open import AOC.Lib.Product
    using (_×_; _,_)
  open import AOC.Lib.Functions
    using (Fun-composable)

  data List (A : Type) : Type where
    [] : List A
    _∷_ : (x : A) → (xs : List A) → List A
  {-# BUILTIN LIST List #-}

  case_nil:_cons:_ : {A B : Type} → List A → B → (A → B → B) → B
  case []     nil: z cons: m = z
  case x ∷ xs nil: z cons: m = m x (case xs nil: z cons: m)

  cases_nil:_cons:_ : ⊤ → {A B : Type} → B → (A → B → B) → (List A → B)
  cases are nil: z cons: m = case_nil: z cons: m

  reverse : {A : Type} → List A → List A
  reverse xs =
    let xs' = case xs
                nil: id _
                cons: (λ x ys → (x ∷_) ; ys) in
    xs' []

  cons : {A : Type} → (A × List A) → List A
  cons (x , xs) = x ∷ xs

  _++_ : {A : Type} → List A → List A → List A
  xs ++ ys = case xs nil: ys cons: _∷_

  map : {A B : Type} → (A → B) → (List A → List B)
  map f = cases are nil: [] cons: (λ a bs → f a ∷ bs)

  bind : {A B : Type} → (A → List B) → (List A → List B)
  bind f = cases are nil: [] cons: (λ a bs → f a ++ bs)

  filter : {A : Type} (P : A → Type) {{_ : Decidable₁ P}}
         → (List A → List A)
  filter Keep = cases are nil: [] cons: λ
    { a as →
        if a is Keep ??
          then (a ∷ as)
          else as
    }

  splitAll : {A : Type} (P : A → Type) {{_ : Decidable₁ P}}
           → List A → (List A × List (List A))
  splitAll Snip = cases are nil: ([] , []) cons: λ
    { x (l , rs) →
        if x is Snip ??
          then ([] , (l ∷ rs))
          else ((x ∷ l) , rs)
    }

  splitAll' : {A : Type} (P : A → Type) {{_ : Decidable₁ P}}
            → List A → List (List A)
  splitAll' Snip = splitAll Snip ; cons

  catMaybes : {A : Type} → List (Maybe A) → List A
  catMaybes = cases are nil: [] cons: λ
    { nothing  as → as
    ; (just a) as → a ∷ as
    }

  instance
    List-composable : {A : Type} → Monoid (List A)
    List-composable = composable by
      id: (λ _ → [])
      seq: _++_
