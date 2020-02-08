defmodule Macchinista.Macros do
  defmacro prepend(left, right) do
    quote do
      [unquote(right) | unquote(left)]
    end
  end
end
