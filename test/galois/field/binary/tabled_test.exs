defmodule Galois.Field.Binary.TabledTest do
  use ExUnit.Case

  doctest Galois.Field.Binary.Tabled

  defmodule Smallest do
    def field, do: Galois.Field.Binary.Tabled.new(2)
    use Galois.FieldTest, with: field, generator: int(0, 3)
  end

  defmodule Default do
    def field, do: Galois.Field.Binary.Tabled.new(8)
    use Galois.FieldTest, with: field, generator: int(0, 255)
  end

  defmodule Rijndael do
    def field, do: Galois.Field.Binary.Tabled.new(8, modulus: 0b100011011, generator: 3)
    use Galois.FieldTest, with: field, generator: int(0, 255)

    test "fixed vectors" do
      assert Galois.Field.product(field, 11, 7) == 49
      assert Galois.Field.product(field, 83, 202) == 1
      assert Galois.Field.product(field, 83, 182) == 54
    end
  end

  defmodule RijndaelStatic do
    def field, do: Galois.Field.Binary.Tabled.static(8, modulus: 0b100011011, generator: 3)
    use Galois.FieldTest, with: field, generator: int(0, 255)
  end

  test "generator is checked" do
    assert_raise(
      RuntimeError,
      ~r/^Invalid generator for this field/,
      fn -> Galois.Field.Binary.Tabled.new(
        8,
        modulus: 0b100011011,
        generator: 2
      ) end
    )
  end

end
