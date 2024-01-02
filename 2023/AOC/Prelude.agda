module AOC.Prelude where
  import AOC.Lib.Bool
  import AOC.Lib.Composable
  import AOC.Lib.Conditional
  import AOC.Lib.Decidable
  import AOC.Lib.Equality
  import AOC.Lib.Functions
  import AOC.Lib.IO
  import AOC.Lib.List
  import AOC.Lib.Maybe
  import AOC.Lib.Natural
  import AOC.Lib.Product
  import AOC.Lib.Showable
  import AOC.Lib.String
  import AOC.Lib.Unit
  import AOC.Lib.Void

  open import Agda.Primitive public
    using ()
    renaming (Set to Type)

  -- Typeclasses & syntax sugar
  open AOC.Lib.Unit public
    using (are; by)
  open AOC.Lib.Composable public
    using (Composable; composable_id:_seq:_; id; _;_; _∘_)
  open AOC.Lib.Conditional public
    using (Conditional; conditional_choose:_; if_then_else_)
  open AOC.Lib.Decidable public
    using (Decidable₁; decidable₁_answer:_reason:_; _is_??; _is_?ᵇ; _is_?ᵖ)
    using (Decidable₂; decidable₂_decide:_; _≟_; _≟ᵇ_; _≟ᵖ_)
    using (DecidableEquality)
  open AOC.Lib.Showable public
    using (Showable; showable_show:_; show)
  open AOC.Lib.String public
    using (IsString; toPacked; fromPacked)

  -- Common instances
  open AOC.Lib.Bool      public using (Bool-conditional)
  open AOC.Lib.Decidable public using (Dec-conditional; BoolFun₁-decidable)
                                using (≡ˡ-decidable; ≡ʳ-decidable)
  open AOC.Lib.Equality  public using (≡-composable)
  open AOC.Lib.Functions public using (Fun-composable)
  open AOC.Lib.IO        public using (IOAct-composable)
  open AOC.Lib.List      public using (List-composable)
  open AOC.Lib.Natural   public using (ℕ-decidable)
  open AOC.Lib.Showable  public using (ℕ-showable; String-showable; Packed-showable)
  open AOC.Lib.String    public using (String-isString; Packed-isString; Char-decidable)

  open module Bool = AOC.Lib.Bool public
    using (Bool; true; false)
    hiding (module Bool)
  open module Dec = AOC.Lib.Decidable public
    using (Dec; _because_)
    hiding (module Dec)
  open module Eq = AOC.Lib.Equality public
    using (_≡_; refl; cong; sym; trans)
  open module Fun = AOC.Lib.Functions public
    using (_⦊_)
  open module IO = AOC.Lib.IO public
    using (IO; _>>_; _>>=_; return)
  open module List = AOC.Lib.List public
    using (List)
    hiding (module List)
  open module Maybe = AOC.Lib.Maybe public
    using (Maybe; nothing; just)
    hiding (module Maybe)
  open module Nat = AOC.Lib.Natural public
    using (ℕ; zero; succ; _+_; _∸_; _⋆_)
  open module Product = AOC.Lib.Product public
    using (Σ; _×_; _,_; left; right)
  open module String  = AOC.Lib.String public
    using (String; Digit)
  open module Unit = AOC.Lib.Unit public
    using (⊤; tt; are; by)
  open module Void = AOC.Lib.Void public
    using (⊥; ⊥-elim)
