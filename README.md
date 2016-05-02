# Galois

Provides a pure Elixir implementation of
[finite field arithmetic](https://en.wikipedia.org/wiki/Finite_field_arithmetic)
on Galois fields of characteristic 2, i.e. GF(2<sup>p</sup>), which is defined
in terms of a `Galois.Field` protocol.
For example:

    iex> f = Galois.Field.Binary.Simple.new(8) # Create an instance of GF(256)
    iex> Galois.Field.order(f)
    256
    iex> Galois.Field.product(f, 42, 23)
    76

Supported operations are addition, subtraction, multiplication, division and
exponentiation.


## Usage

`Galois.Field.Binary.Simple.new/1` automatically picks a reducing polynomial
(from a small, predefined set of primitive polynomials). To obtain a specific
field representation, the reducing polynomial can also be provided on
construction:

    iex> rijndael = Galois.Field.Binary.Simple.new(8, modulus: 285)
    iex> Galois.Field.product(rijndael, 42, 23)
    64

The `Galois.Field.Binary.Simple` implementation calculates the product ad-hoc,
using peasant multiplication (modulo the reducing polynomial). There is also
another implementation, `Galois.Field.Binary.Tabled`, that precomputes
log-tables on construction, which makes multiplication an efficient look-up:

    iex> f = Galois.Field.Binary.Tabled.new(8)
    iex> Galois.Field.product(f, 42, 23)
    76

The discrete logarithm is taken with respect to a generator element, which can
also be specified explicitly:

    iex> rijndael = Galois.Field.Binary.Tabled.new(
    ...>  8,
    ...>  modulus: 285,
    ...>  generator: 3
    ...> )
    iex> Galois.Field.product(rijndael, 42, 23)
    64

For the `Tabled` implementation, there is also a macro `static/2` that allows
the precomputation to happen at compile time if the parameters are fixed:

    iex> rijndael = Galois.Field.Binary.Tabled.static(
    ...>  8,
    ...>  modulus: 285,
    ...>  generator: 3
    ...> )
    iex> Galois.Field.product(rijndael, 42, 23)
    64
This will inline the complete `Tabled` instance at the call site, including the
log-tables. Note that this requires memory in the order of
`Galois.Field.order/1` for that field.


## Why?

I wanted to try out some things in Elixir, specifically:

* protocols
* property based (randomized) testing
* compile-time precalculation using macros

This library could e.g. be used to:

* implement
  [Shamir secret sharing](http://dl.acm.org/citation.cfm?doid=359168.359176)
* cross-check a more efficient native implementation
* just play around with finite field arithmetic in Elixir

Pull requests welcome.
