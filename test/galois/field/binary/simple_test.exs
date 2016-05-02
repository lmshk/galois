defmodule Galois.Field.Binary.SimpleTest do
  use ExUnit.Case

  doctest Galois.Field.Binary.Simple

  defmodule Trivial do
    def field, do: Galois.Field.Binary.Simple.new(1)
    use Galois.FieldTest, with: field, generator: int(0, 1)
  end

  defmodule Default do
    def field, do: Galois.Field.Binary.Simple.new(8)
    use Galois.FieldTest, with: field, generator: int(0, 255)
  end

  defmodule Rijndael do
    def field, do: Galois.Field.Binary.Simple.new(8, modulus: 0b100011011)
    use Galois.FieldTest, with: field, generator: int(0, 255)

    test "fixed vectors" do
      assert Galois.Field.product(field, 11, 7) == 49
      assert Galois.Field.product(field, 83, 202) == 1
      assert Galois.Field.product(field, 83, 182) == 54
    end
  end

  defmodule GF65536 do
    def field, do: Galois.Field.Binary.Simple.new(16)
    use Galois.FieldTest, with: field, generator: int(0, 65535)
  end

end
