open import AOC.Prelude

module AOC.Day01.Main where
  aoc : ∀{A} {{_ : Showable A}} → (String → A) → IO ⊤
  aoc f =
      IO.readFile "input"
    ⦊ IO.map f
    ⦊ IO.bind (show ; IO.putStrLn)

  -- old solution for star 1 only
  module StarOneOnly where
    findBoundingDigits : String → Maybe (ℕ × ℕ)
    findBoundingDigits =
      List.cases are
        nil: nothing
        cons: λ x → Maybe.cases are
          nothing:
              String.tryToDigit x
            ⦊ Maybe.map Product.Δ
          just: λ (l , r) →
            let l' = String.tryToDigit x
                   ⦊ Maybe.orElse l in
            just (l' , r)

  BeginsWith : String → (String → Type)
  BeginsWith []       _  = ⊤
  BeginsWith (_ ∷ _)  [] = ⊥
  BeginsWith (x ∷ xs) (y ∷ ys) = (x ≡ y) × BeginsWith xs ys

  -- TODO: Figure out a way to derive this whole instance
  -- from the definition of `BeginsWith`.
  instance
    BeginsWith-decidable₂ : Dec.Decidable₂ BeginsWith
    BeginsWith-decidable₂ = decidable₂ by decide: decide
      where
        decide : ∀ needle subject → Dec (BeginsWith needle subject)
        decide []       _        = decide₀
        decide (_ ∷ _)  []       = decide₀
        decide (x ∷ xs) (y ∷ ys) = Dec.pair (decide₂ x y) (decide xs ys)

    BeginsWith-decidable₁ : ∀{i} → Dec.Decidable₁ (BeginsWith i)
    BeginsWith-decidable₁ = Dec.Decidable₂↓ BeginsWith-decidable₂

    BeginsWith-decidable₀ : ∀{i₁ i₂} → Dec.Decidable₀ (BeginsWith i₁ i₂)
    BeginsWith-decidable₀ = Dec.Decidable₁↓ BeginsWith-decidable₁

  findOne : (words : List String) → String → Maybe (List.Index words)
  findOne [] subject = nothing
  findOne (word ∷ words) subject =
    if subject is BeginsWith word
      then just (word , List.here words)
      else ( findOne words subject
           ⦊ Maybe.map λ{(word , ix) → (word , List.there _ ix)} )

  findFirst : (words : List String) → String → Maybe (List.Index words)
  findFirst words [] = nothing
  findFirst words (c ∷ rest) = findOne words (c ∷ rest) ; findFirst words rest

  findLast : (words : List String) → String → Maybe (List.Index words)
  findLast words [] = nothing
  findLast words (c ∷ rest) = findLast words rest ; findOne words (c ∷ rest)

  findBounding : (words : List String) → String → Maybe (List.Index words × List.Index words)
  findBounding words subject = Maybe.pair (findFirst words subject , findLast words subject)

  valueOf : (mapping : List (String × ℕ)) → List.Index (List.map left mapping) → ℕ
  valueOf mapping =
      List.map-index⁻¹ {f = left}  {xs = mapping}
    ; List.map-index   {f = right}
    ; List.lookup

  foo : List (String × ℕ) → String → Maybe (ℕ × ℕ)
  foo mapping subject =
      findBounding (List.map left mapping) subject
    ⦊ Maybe.map (λ{(x , y) → (valueOf mapping x , valueOf mapping y)})

  _&&&_ : {A B C : Type} → (A → B) → (A → C) → (A → (B × C))
  (f &&& g) a = (f a , g a)

  main : IO ⊤
  main = aoc
    ( List.splitAll' ('\n' ≡_)
    ; (   List.map (foo star1-mapping) {- StarOneOnly.findBoundingDigits -}
      &&& List.map (foo star2-mapping) )
    ; Product.bimap' (Product.Δ
      ( List.catMaybes
      ; List.map (λ (l , r) → (l ⋆ 10) + r)
      ; (List.cases are nil: 0 cons: _+_) ) ) )
    where
      star1-mapping star2-mapping : List (String × ℕ)
      star1-mapping = ("0"     , 0)
                    ∷ ("1"     , 1)
                    ∷ ("2"     , 2)
                    ∷ ("3"     , 3)
                    ∷ ("4"     , 4)
                    ∷ ("5"     , 5)
                    ∷ ("6"     , 6)
                    ∷ ("7"     , 7)
                    ∷ ("8"     , 8)
                    ∷ ("9"     , 9)
                    ∷ []
      star2-mapping = ("zero"  , 0)
                    ∷ ("one"   , 1)
                    ∷ ("two"   , 2)
                    ∷ ("three" , 3)
                    ∷ ("four"  , 4)
                    ∷ ("five"  , 5)
                    ∷ ("six"   , 6)
                    ∷ ("seven" , 7)
                    ∷ ("eight" , 8)
                    ∷ ("nine"  , 9)
                    ∷ star1-mapping
