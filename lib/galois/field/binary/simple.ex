defmodule Galois.Field.Binary.Simple do
@moduledoc """
A `Galois.Field` implementation that uses ad-hoc calculation for its operations.

Instances can be constructed using `new/2`. Multiplication is implemented using
[peasant multiplication]
(https://en.wikipedia.org/wiki/Finite_field_arithmetic#Multiplication),
exponentiation is done
[by squaring](https://en.wikipedia.org/wiki/Exponentiation_by_squaring), and
division first uses exponentiation to determine the multiplicative inverse. See
also `Galois.Field.Binary`.

*Note:* This implementation is used to precompute the tables of
`Galois.Field.Binary.Tabled`.
"""

defstruct [:order, :modulus]

use Bitwise

@doc """
Constructs a new `Galois.Field.Binary.Simple` representing a
GF(2<sup>`dimension`</sup>).

The keyword argument `modulus` defines the modulus polynomial used for
multiplication. It must be of degree `dimension` (this is checked), and
irreducible (this is not checked). See also `new/1`.

## Example
  iex> f = Galois.Field.Binary.Simple.new(8, modulus: 283)
  iex> Galois.Field.product(f, 42, 23)
  64
"""
def new(dimension, modulus: modulus) when
  (1 <<< dimension) <= modulus and modulus < (2 <<< dimension),
do: %Galois.Field.Binary.Simple{order: 1 <<< dimension, modulus: modulus}

@doc """
Convenience constructor that uses a default modulus of the required degree.

## Example
  iex> f = Galois.Field.Binary.Simple.new(8)
  iex> Galois.Field.product(f, 42, 23)
  76
"""
def new(dimension),
do: new(
  dimension,
  modulus: Galois.Data.BinaryPrimitivePolynomials.default_of_degree(dimension)
)

end


defimpl Galois.Field, for: Galois.Field.Binary.Simple do

alias Galois.Field.Binary.Simple

use Bitwise
import Galois.Utilities, only: [modulo: 2]

def order(%Simple{order: order}), do: order

def zero(%Simple{}), do: 0

def one(%Simple{}), do: 1

def sum(%Simple{order: order}, augend, addend) when
  0 <= augend and augend < order and
  0 <= addend and addend < order,
do: augend ^^^ addend

def difference(%Simple{order: order}, minuend, subtrahend) when
  0 <= minuend and minuend < order and
  0 <= subtrahend and subtrahend < order,
do: minuend ^^^ subtrahend

def product(%Simple{order: order} = field, multiplier, multiplicand) when
  0 <= multiplier and multiplier < order and
  0 <= multiplicand and multiplicand < order,
do: do_product(field, multiplier, multiplicand, 0)

defp do_product(_, 0, _, accumulator), do: accumulator
defp do_product(
  %Simple{order: order, modulus: modulus} = field,
  multiplier,
  multiplicand,
  accumulator
) do
  # TODO fix scopes for Elixir 1.3
  if (multiplier &&& 1) != 0, do: accumulator = accumulator ^^^ multiplicand
  multiplier = multiplier >>> 1
  multiplicand = multiplicand <<< 1
  if (multiplicand &&& order) != 0, do: multiplicand = multiplicand ^^^ modulus

  do_product(field, multiplier, multiplicand, accumulator)
end

def quotient(%Simple{} = field, dividend, divisor) when
  divisor != 0,
do: product(field, dividend, power(field, divisor, -1))

def power(%Simple{order: order} = field, base, exponent) when
  0 <= base and base < order,
do: do_power(field, base, exponent |> modulo(order - 1), 1)

defp do_power(_, 0, _, _), do: 0
defp do_power(_, _, 0, accumulator), do: accumulator
defp do_power(field, base, exponent, accumulator) do
  even? = (exponent &&& 1) == 0
  do_power(
    field,
    product(field, base, base),
    exponent >>> 1,
    (if even?, do: accumulator, else: product(field, accumulator, base))
  )
end

end
