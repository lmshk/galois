defmodule Galois.Field.Binary.EquivalenceTest do
  use ExUnit.Case, async: false
  use ExCheck

  def f1, do: Galois.Field.Binary.Simple.new(8)
  def f2, do: Galois.Field.Binary.Tabled.new(8)

  test "order" do
    assert Galois.Field.order(f1) == 256
    assert Galois.Field.order(f2) == 256
  end

  test "zero" do
    assert Galois.Field.zero(f1) == 0
    assert Galois.Field.zero(f2) == 0
  end

  test "one" do
    assert Galois.Field.one(f1) == 1
    assert Galois.Field.one(f2) == 1
  end

  property "equivalence of addition" do
    for_all {x, y} in {int(0, 255), int(0, 255)} do
      Galois.Field.sum(f1, x, y) == Galois.Field.sum(f2, x, y)
      # Galois.Field.power(f1, x, y) == Galois.Field.power(f2, x, y)
      # Galois.Field.logarithm(f1, x, y) == Galois.Field.logarithm(f2, x, y)
    end
  end

  property "equivalence of subtraction" do
    for_all {x, y} in {int(0, 255), int(0, 255)} do
      Galois.Field.difference(f1, x, y) == Galois.Field.difference(f2, x, y)
    end
  end

  property "equivalence of multiplication" do
    for_all {x, y} in {int(0, 255), int(0, 255)} do
      Galois.Field.product(f1, x, y) == Galois.Field.product(f2, x, y)
    end
  end

  property "equivalence of division" do
    for_all {x, y} in {int(0, 255), int(0, 255)} do
      implies y != 0 do
        Galois.Field.quotient(f1, x, y) == Galois.Field.quotient(f2, x, y)
      end
    end
  end

  property "equivalence of power" do
    for_all {x, y} in {int(0, 255), int(-300, 300)} do
      Galois.Field.power(f1, x, y) == Galois.Field.power(f2, x, y)
    end
  end
end
