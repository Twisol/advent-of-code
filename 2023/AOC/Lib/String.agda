open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.String where
  open import AOC.Lib.Unit
    using (⊤; by)
  open import AOC.Lib.Bool
    using (Bool; true; false)
  open import AOC.Lib.Maybe
    using (Maybe; nothing; just)
  open import AOC.Lib.Natural
    using (ℕ; _∸_; ℕ-decidable)
  open import AOC.Lib.Integer
    using (ℤ)
  open import AOC.Lib.List
    using (List)
  open import AOC.Lib.Functions
    using (Fun-composable)
  open import AOC.Lib.Equality
    as Eq
    using (_≡_)

  open import AOC.Lib.Decidable
    as Dec
    using (if_then_else_; decidable₀_decide:_; ≡-decidable₀)
    using (_is_)
    using (DecidableEquality; _≟_)
    using (Bool-decidable)
  open import AOC.Lib.Composable
    using (id)

  postulate          Char : Type
  {-# BUILTIN CHAR   Char   #-}
  postulate          Packed : Type
  {-# BUILTIN STRING Packed #-}

  String : Type
  String = List Char

  private
    primitive primStringToList   : Packed → String
    primitive primStringFromList : String → Packed
    primitive primIsDigit        : Char   → Bool
    primitive primCharToNat      : Char   → ℕ

    primitive primCharToNatInjective : (a b : Char)
                                     → (primCharToNat a ≡ primCharToNat b)
                                     → (a ≡ b)

  charCode : Char → ℕ
  charCode = primCharToNat

  charCode-injective : ∀ a b → (charCode a ≡ charCode b) → (a ≡ b)
  charCode-injective = primCharToNatInjective

  instance
    Char-decidable : DecidableEquality Char
    Char-decidable = Dec.decidable₂ by
      decide: λ x y → Dec.map (primCharToNatInjective x y)
                              (Eq.cong primCharToNat)
                              (charCode x ≟ charCode y)

  Digit : (c : Char) → Type
  Digit c = primIsDigit c ≡ true

  toDigit : (c : Char) → {{Digit c}} → ℕ
  toDigit c = primCharToNat c ∸ 48

  tryToDigit : (c : Char) → Maybe ℕ
  tryToDigit c =
    if c is Digit
       then just (toDigit c)  -- i can't believe this just works
       else nothing


  record IsString (A : Type) : Type₁ where
    field fromPacked : Packed → A
    field toPacked   : A → Packed
  open IsString {{...}} public using (fromPacked; toPacked)
  {-# BUILTIN FROMSTRING fromPacked #-}

  isString_fromPacked:_toPacked:_
    : ⊤ → {A : Type}
    → (fromPacked : Packed → A)
    → (toPacked : A → Packed)
    → IsString A
  isString by fromPacked: f toPacked: g
    = record { fromPacked = f; toPacked = g }

  instance
    Packed-isString : IsString Packed
    Packed-isString = isString by
      fromPacked: id _
      toPacked:   id _

  instance
    String-isString : IsString String
    String-isString = isString by
      fromPacked: primStringToList
      toPacked:   primStringFromList
