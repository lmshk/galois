defmodule Galois.FieldTest do
  @moduledoc """
  Defines ExCheck properties that should hold for all `Galois.Field`s.

  This module is `use`d inside submodules of the field implementations' specific tests,
  which injects the `property` (macro) calls into those modules.
  (This is because I have found no better way of sharing `property` definitions
  across all implementations of a protocol. It seems dirty, though.
  Pull requests welcome.)
  """

  @doc """
  When `use`d, this module defines ExCheck properties on a concrete field in the current scope.

  The field to test is passed in the `with` argument,
  and `generator` must be an (ExCheck) generator expression
  describing how to generate random field elements.
  """
  defmacro __using__(with: field, generator: generator) do
    quote do
      use ExUnit.Case, async: false
      use ExCheck

      import Galois.Field

      # Define some shortcuts.
      def order, do: order(unquote(field))
      def zero, do: zero(unquote(field))
      def one, do: one(unquote(field))
      def sum(augend, addend), do: sum(unquote(field), augend, addend)
      def difference(minuend, subtrahend), do: difference(unquote(field), minuend, subtrahend)
      def product(multiplier, multiplicand), do: product(unquote(field), multiplier, multiplicand)
      def quotient(dividend, divisor), do: quotient(unquote(field), dividend, divisor)
      def power(base, exponent), do: power(unquote(field), base, exponent)

      property "zero is additive identity element" do
        for_all x in unquote(generator) do
          sum(zero, x) == x and sum(x, zero) == x
        end
      end

      property "commutativity of addition" do
        for_all {x, y} in {unquote(generator), unquote(generator)} do
          sum(x, y) == sum(y, x)
        end
      end

      property "associativity of addition" do
        for_all {x, y, z} in {unquote(generator), unquote(generator), unquote(generator)} do
          sum(sum(x, y), z) == sum(x, sum(y, z))
        end
      end

      property "subtraction inverts addition" do
        for_all {x, y} in {unquote(generator), unquote(generator)} do
          difference(sum(x, y), y) == x
        end
      end

      property "one is multiplicative identity element" do
        for_all x in unquote(generator) do
          product(one, x) == x and product(x, one) == x
        end
      end

      property "commutativity of multiplication" do
        for_all {x, y} in {unquote(generator), unquote(generator)} do
          product(x, y) == product(y, x)
        end
      end

      property "associativity of multiplication" do
        for_all {x, y, z} in {unquote(generator), unquote(generator), unquote(generator)} do
          product(product(x, y), z) == product(x, product(y, z))
        end
      end

      property "distributivity of multiplication over addition" do
        for_all {x, y, z} in {unquote(generator), unquote(generator), unquote(generator)} do
          product(x, sum(y, z)) == sum(product(x, y), product(x, z))
        end
      end

      property "division inverts multiplication" do
        for_all {x, y} in {unquote(generator), unquote(generator)} do
          quotient(product(x, y), y) == x
        end
      end

      property "existence of power cycle with field order" do
        for_all x in unquote(generator) do
          power(x, order) == x
        end
      end

      property "all members are roots of unity" do
        for_all x in unquote(generator) do
          power(x, order - 1) == one
        end
      end
    end
  end

end
