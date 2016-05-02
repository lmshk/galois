defmodule Galois.Field.Binary do
  @moduledoc """
  Implements the `Galois.Field` protocol for Galois fields of characteristic 2,
  i.e. GF(2<sup>n</sup>).

  The members of these binary fields are represented as integers, which
  correspond to polynomials with binary coefficients (with the most significant
  coefficients in the most significant bits). The dimension *p* of the field is
  supplied at construction, and it determines the degree of the member
  polynomials (i.e. their maximal bit count). The field's values are the
  integer range \[0, 2<sup>p</sup> - 1\].

  In Galois fields of characteristic 2, addition and subtraction are equivalent.
  Multiplication, division and exponentiation are done modulo a reducing
  polynomial, which is also supplied at costruction. This *modulus* needs to be
  of degree *p* and determines the concrete instantiation of the field. (All
  Galois fields of the same order (i.e., size) are isomorphic, and the modulus
  determines for each member which concrete polynomial/integer it is represented
  by.) The modulus must be an
  [irreducible polynomial]
  (https://en.wikipedia.org/wiki/Irreducible_polynomial).
  (For low dimensions, some such polynomials are supplied in
  `Galois.Data.PrimitiveBinaryPolynomials`.) For more information, see
  [here](https://en.wikipedia.org/wiki/Finite_field_arithmetic).

  In this module, two `Galois.Field` implementations are provided.
  `Galois.Field.Binary.Simple` calculates multiplication, division and
  exponentiation ad-hoc, while `Galois.Field.Binary.Tabled` pre-calculates log-
  and exp-tables at construction, so that these operations become efficient
  look-ups.
  """
end
