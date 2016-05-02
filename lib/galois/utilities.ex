defmodule Galois.Utilities do
@moduledoc """
Contains utility functions.
"""

@doc "The integer modulo operation missing in Elixir."
def modulo(dividend, divisor) when divisor != 0,
do: rem(rem(dividend, divisor) + divisor, divisor)

end
