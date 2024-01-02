open import Agda.Primitive using () renaming (Set to Type)

module AOC.Lib.Showable where
  open import AOC.Lib.Functions
    using (Fun-composable)
  open import AOC.Lib.Composable
    using (_∘_)
  open import AOC.Lib.Unit
    using (⊤; by)
  open import AOC.Lib.Natural
    using (ℕ)
  open import AOC.Lib.Integer
    using (ℤ)
  open import AOC.Lib.String
    using (String; Packed; toPacked; fromPacked; String-isString)

  record Showable (A : Type) : Type where
    field show : A → String
  open Showable {{...}} public using (show)

  showable_show:_ : ⊤ → {A : Type} → (A → String) → Showable A
  showable by show: s = record { show = s }


  private
    primitive primShowString     : Packed → Packed
    primitive primShowInteger    : ℤ      → Packed

  instance
    ℤ-showable : Showable ℤ
    ℤ-showable = showable by
      show: fromPacked ∘ primShowInteger

  instance
    ℕ-showable : Showable ℕ
    ℕ-showable = showable by
      show: show ∘ ℤ.pos

  instance
    Packed-showable : Showable Packed
    Packed-showable = showable by
      show: fromPacked ∘ primShowString

  instance
    String-showable : Showable String
    String-showable = showable by
      show: show ∘ toPacked

