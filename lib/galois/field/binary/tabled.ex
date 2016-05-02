defmodule Galois.Field.Binary.Tabled do
@moduledoc """
A `Galois.Field` implementation that uses precomputed tables for efficient
multiplication, division and exponentiation.

Instances can be constructed using `new/2`, which prepares exponential and
logarithm tables with respect to a specified generator. This enables
multiplication, division and exponentiation using simple table look-ups. The
tables require memory in the order of `Galois.Field.order/1` of this field.

There is also the `static/2` macro to move table generation ahead to compile
time.
"""

defstruct [:order, :modulus, :powers, :logarithms]

use Bitwise

@doc """
Constructs a new `Galois.Field.Binary.Tabled` representing a
GF(2<sup>`dimension`</sup>).

The keyword argument `modulus` defines the modulus polynomial used for
multiplication. It must be of degree `dimension` (this is checked), and
irreducible (this is not checked). The keyword argument `generator` specifies
generator element to be used for the multiplication chain. It must be a valid
generator for `modulus`. (This is checked, but only after the tables have been
computed.)

## Example
    iex> f = Galois.Field.Binary.Tabled.new(8, modulus: 283, generator: 3)
    iex> Galois.Field.product(f, 42, 23)
    64
"""
def new(dimension, modulus: modulus, generator: generator) when
  (1 <<< dimension) <= modulus and modulus < (2 <<< dimension)
do
  helper = Galois.Field.Binary.Simple.new(dimension, modulus: modulus)
  %Galois.Field.Binary.Tabled{
    order: 1 <<< dimension,
    modulus: modulus,
    powers: powers(helper, generator),
    logarithms: logarithms(helper, generator)
  }
end

@doc """
Convenience constructor that uses a default `modulus` of the required degree,
along with a matching `generator`.

## Example
    iex> f = Galois.Field.Binary.Tabled.new(8)
    iex> Galois.Field.product(f, 42, 23)
    76
"""
def new(dimension),
do: new(
  dimension,
  modulus: Galois.Data.BinaryPrimitivePolynomials.default_of_degree(dimension),
  generator: 2
)

@doc """
Constructs an instance at compile time and inlines it at the call site.

## Example
    iex> f = Galois.Field.Binary.Tabled.static(8, modulus: 283, generator: 3)
    iex> Galois.Field.product(f, 42, 23)
    64
"""
defmacro static(dimension, options) do
  Macro.escape(new(dimension, options))
end

defp powers(field, generator) do
  generator
  |> Stream.iterate(&(Galois.Field.product(field, &1, generator)))
  |> Stream.take_while(&(&1 != 1))
  |> Enum.to_list
  |> fn list -> [1 | list] end.()
  |> List.to_tuple
  |> fn result ->
    cycle_length = tuple_size(result)
    maximal_cycle_length = Galois.Field.order(field) - 1
    if cycle_length == maximal_cycle_length do
      result
    else
      raise "Invalid generator for this field: it enumerates only" <>
        " #{cycle_length} of #{maximal_cycle_length} non-zero elements."
    end
  end.()
end

defp logarithms(field, generator) do
  generator
  |> Stream.iterate(&Galois.Field.product(field, &1, generator))
  |> Stream.take_while(&(&1 != 1))
  |> Stream.with_index(1)
  |> Enum.reduce(
    :array.new,
    fn {element, logarithm}, array ->
      :array.set(element - 1, logarithm, array)
    end
  )
  |> (fn array -> :array.set(0, 0, array) end).()
  |> :array.to_list
  |> List.to_tuple
end

end

defimpl Galois.Field, for: Galois.Field.Binary.Tabled do

alias Galois.Field.Binary.Tabled

use Bitwise
import Galois.Utilities, only: [modulo: 2]

def order(%Tabled{order: order}), do: order

def zero(%Tabled{}), do: 0

def one(%Tabled{}), do: 1

def sum(%Tabled{order: order}, augend, addend) when
  0 <= augend and augend < order and
  0 <= addend and addend < order,
do: augend ^^^ addend

def difference(%Tabled{order: order}, minuend, subtrahend) when
  0 <= minuend and minuend < order and
  0 <= subtrahend and subtrahend < order,
do: minuend ^^^ subtrahend

def product(%Tabled{order: order} = field, multiplier, multiplicand) when
  0 <= multiplier and multiplier < order and
  0 <= multiplicand and multiplicand < order
do
  case {multiplier, multiplicand} do
    {0, _} -> 0
    {_, 0} -> 0
    _ -> power(
      field,
      logarithm(field, multiplier) + logarithm(field, multiplicand)
      |> rem(order - 1)
    )
  end
end

def quotient(%Tabled{order: order} = field, dividend, divisor) when
  0 <= dividend and dividend < order and
  0 < divisor and divisor < order
do
  if dividend == 0 do
    0
  else
    power(
      field,
      logarithm(field, dividend) - logarithm(field, divisor)
      |> modulo(order - 1)
    )
  end
end

def power(%Tabled{}, 0, _), do: 0
def power(%Tabled{order: order} = field, base, exponent) when
  0 <= base and base < order,
do: power(field, exponent * logarithm(field, base) |> modulo(order - 1))

defp power(%Tabled{powers: powers}, exponent),
do: elem(powers, exponent)

# note: result is not in field domain
defp logarithm(%Tabled{logarithms: logarithms}, antilogarithm),
do: elem(logarithms, antilogarithm - 1)

end
