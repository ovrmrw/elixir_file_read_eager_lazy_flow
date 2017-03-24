defmodule MyTime do
  def timestamp do
    :os.system_time(:milli_seconds)
  end
end
