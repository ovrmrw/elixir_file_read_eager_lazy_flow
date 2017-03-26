defmodule Utils do
  def timestamp do
    :os.system_time(:milli_seconds)
  end

  def json_parse(json) when is_bitstring(json) do
    Poison.Parser.parse!(json, keys: :atoms)
  end
end
