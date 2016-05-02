defmodule Galois.Data.BinaryPrimitivePolynomials do
  @moduledoc """
  Contains definitions of the default (irreducible) polynomials used when
  constructing a `Galois.Field.Binary`.
  """

  @defaults %{
    1 => 0b11,
    2 => 0b111,
    3 => 0b1011,
    4 => 0b10011,
    5 => 0b100101,
    6 => 0b1000011,
    7 => 0b10001001,
    8 => 0b100011101,
    9 => 0b1000010001,
    10 => 0b10000001001,
    11 => 0b100000000101,
    12 => 0b1000001010011,
    13 => 0b10000000011011,
    14 => 0b100010001000011,
    15 => 0b1000000000000011,
    16 => 0b10001000000001011
  }

  @doc """
  Returns an irreducible binary polynomial of degree `n`.

  In fact, all of these are primitive polynomials
  (which implies that they are irreducible).
  The polynomial is represented as an integer,
  as the `Galois.Field.Binary` constructors expect it.
  """
  def default_of_degree(n), do: @defaults[n]
end
