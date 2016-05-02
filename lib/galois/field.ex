defprotocol Galois.Field do
  @moduledoc """
  A [finite field](https://en.wikipedia.org/wiki/Finite_field).

  The representation of the elements is defined by the implementations of this
  protocol. Currently, the only supported field type is `Galois.Field.Binary`,
  which represents binary polynomials as integers.

  Trivial fields are excluded, i.e. for all `Galois.Field`s `field` we have
  `zero(field) != one(field)`.
  """

  @doc """
  The number of elements in `field`.

  For all `Galois.Field`s `field` we have `order(field) >= 2`, because
  `zero(field) != one(field)`.
  """
  def order(field)

  @doc """
  The additive identity element of `field`.

  It is guaranteed that `add(field, zero(field), x) == x` and
  `add(field, x, zero(field)) == x` for all `Galois.Field`s `field` and all
  elements of that field `x`.
  """
  def zero(field)

  @doc """
  The multiplicative identity element of `field`.

  It is guaranteed that `product(field, one(field), x) == x` and
  `product(field, x, one(field)) == x` for all `Galois.Field`s `field` and all
  elements of that field `x`.
  """
  def one(field)

  @doc """
  The sum of `augend` and `addend` in `field`.

  This is the addition operation on the field. Both `augend` and `addend` must
  be elements of `field`. It is guaranteed that
  `add(field, x, y) == add(field, y, x)` for all `Galois.Field`s `field` and all
  elements of that field `x` and `y`.
  """
  def sum(field, augend, addend)

  @doc """
  The difference of `minuend` and `subtrahend` in `field`.

  This is the inverse of the addition operation on `field`. Both `minuend` and
  `subtrahend` must be elements of `field`. It is guaranteed that
  `difference(field, sum(field, x, y), y) == x` for all `Galois.Field`s `field`
  and all elements of that field `x` and `y`.
  """
  def difference(field, minuend, subtrahend)

  @doc """
  The product of `multiplier` and `multiplicand` in `field`.

  This is the multiplication operation on `field`. Both `multiplier` and
  `multiplicand` must be elements of `field`. It is guaranteed that
  `product(field, x, y) == product(field, y, x)` for all `Galois.Field`s `field`
  and all elements of that field `x` and `y`.
  """
  def product(field, multiplier, multiplicand)

  @doc """
  The quotient of `dividend` and `divisor` in `field`.

  This is the inverse of the multiplication operation on `field`. Both
  `dividend` and `divisor` must be elements of `field`, and
  `divisor != zero(field)` must hold. It is guaranteed that
  `quotient(field, product(field, x, y), y) == x` for all `Galois.Field`s
  `field` and all elements of that field `x` and `y`.
  """
  def quotient(field, dividend, divisor)

  @doc """
  The power of `base` raised to `exponent` in `field`.

  `base` must be an element of `field`, and `exponent` must be an integer. If
  `0 <= exponent and exponent < order(field) - 1`, the power is equal to
  `one(field)` multiplied by `base` `exponent` times in `field`. Otherwise,
  `exponent` is taken modulo `order(field) - 1`, i.e., the result is equal to
  `power(field, base, rem(rem(exponent, order - 1) + order - 1, order - 1))`.

  This makes sense if `base` is a
  [primitive element]
  (https://en.wikipedia.org/wiki/Primitive_element_%28finite_field%29)
  of `field`, in which case
  `power(field, base, 0) == 1 and 1 == power(field, base, order - 1)`, and
  `power(field, base, -1)` = `power(field, base, order - 2)` is the
  multiplicative inverse of `base` in `field`.
  """
  def power(field, base, exponent)

end
