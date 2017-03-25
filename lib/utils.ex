defmodule Utils do
  def timestamp do
    :os.system_time(:milli_seconds)
  end

  def decode(json) when is_bitstring(json) do
    Poison.Parser.parse!(json, keys: :atoms)
  end
end
