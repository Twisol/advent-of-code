open import Agda.Primitive using (_⊔_; lzero; lsuc) renaming (Set to Type)

module AOC.Lib.List where
  open import AOC.Lib.Composable
    using (Monoid; composable_id:_seq:_; id; _;_)
  open import AOC.Lib.Decidable
    using (if_then_else_; Decidable₁; Decidable₁↓)

  open import AOC.Lib.Unit
    using (⊤; are; by)
  open import AOC.Lib.Maybe
    using (Maybe; nothing; just)
  open import AOC.Lib.Product
    using (Σ; _×_; _,_)
  open import AOC.Lib.Functions
    using (Fun-composable)

  infixr 20 _∷_
  data List (A : Type) : Type where
    [] : List A
    _∷_ : (x : A) → (xs : List A) → List A
  {-# BUILTIN LIST List #-}

  case_nil:_cons:_ : ∀{ℓ} {A : Type} {B : Type ℓ} → List A → B → (A → B → B) → B
  case []     nil: z cons: m = z
  case x ∷ xs nil: z cons: m = m x (case xs nil: z cons: m)

  cases_nil:_cons:_ : ⊤ → ∀{ℓ} {A : Type} {B : Type ℓ} → B → (A → B → B) → (List A → B)
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

  filter : {A : Type} (P : A → Type) {{⟨P⟩ : Decidable₁ P}}
         → (List A → List A)
  filter Keep {{⟨P⟩}} = cases are nil: [] cons: λ
    { a as →
        if Keep a
          then (a ∷ as)
          else as
    }
    where
      instance _ = Decidable₁↓ ⟨P⟩

  splitAll : {A : Type} (P : A → Type) {{⟨P⟩ : Decidable₁ P}}
           → List A → (List A × List (List A))
  splitAll Snip {{⟨P⟩}} = cases are nil: ([] , []) cons: λ
    { x (l , rs) →
        if Snip x
          then ([] , (l ∷ rs))
          else ((x ∷ l) , rs)
    }
    where
      instance _ = Decidable₁↓ ⟨P⟩

  splitAll' : {A : Type} (P : A → Type) {{_ : Decidable₁ P}}
            → List A → List (List A)
  splitAll' Snip = splitAll Snip ; cons

  first : {A : Type} → List A → Maybe A
  first [] = nothing
  first (x ∷ _) = just x

  last : {A : Type} → List A → Maybe A
  last []           = nothing
  last (x ∷ [])     = just x
  last (_ ∷ x ∷ xs) = last (x ∷ xs)

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


  data _∈_ {A : Type} (x : A) : List A → Type where
    here  : (xs : List A) → x ∈ (x ∷ xs)
    there : {xs : List A} (x' : A) → (x ∈ xs) → x ∈ (x' ∷ xs)

  Index : {A : Type} → List A → Type
  Index xs = Σ _ (_∈ xs)

  lookup : {A : Type} → {xs : List A} → Index xs → A
  lookup = Σ.left

  map-index⁻¹ : {A B : Type} {f : A → B} {xs : List A} → Index (map f xs) → Index xs
  map-index⁻¹ (_ , ix) = map-∈ _ ix
    where
      map-∈ : {A B : Type} {f : A → B} {x : B} → (xs : List A) → (x ∈ map f xs) → Index xs
      map-∈ (x ∷ xs) (here     _) = x , here xs
      map-∈ (x ∷ xs) (there _ ix) = let (x' , ix') = map-∈ xs ix in (x' , there _ ix')

  map-index : {A B : Type} {f : A → B} {xs : List A} → Index xs → Index (map f xs)
  map-index (_ , ix) = (_ , map-∈ _ ix)
    where
      map-∈ : {A B : Type} {f : A → B} {x : A} → (xs : List A) → (x ∈ xs) → f x ∈ map f xs
      map-∈ (x ∷ xs) (here     _) = here _
      map-∈ (x ∷ xs) (there _ ix) = there _ (map-∈ xs ix)
