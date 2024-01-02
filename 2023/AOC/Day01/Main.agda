open import AOC.Prelude

module AOC.Day01.Main where
  aoc : ∀{A} {{_ : Showable A}} → (String → A) → IO ⊤
  aoc f =
      IO.readFile "input"
    ⦊ IO.map f
    ⦊ IO.bind (show ; IO.putStrLn)

  findBoundingDigits : String → Maybe (ℕ × ℕ)
  findBoundingDigits = List.cases are
    nil: nothing
    cons: λ x → Maybe.cases are
      nothing:
          String.tryToDigit x
        ⦊ Maybe.map Product.Δ
      just: λ (l , r) →
        let l' = String.tryToDigit x
               ⦊ Maybe.orElse l in
        just (l' , r)

  star1 : String → ℕ
  star1 input =
      List.splitAll' ('\n' ≡_) input
    ⦊ List.map findBoundingDigits
    ⦊ List.catMaybes
    ⦊ List.map (λ (l , r) → (l ⋆ 10) + r)
    ⦊ List.cases are nil: 0 cons: _+_

  main : IO ⊤
  main = aoc star1
