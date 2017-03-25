defmodule Reader do  
  import Utils

  def read(type, rows \\ 300000) when is_atom(type) and is_integer(rows) do
    start_time = timestamp()

    file = "RandomUsers/names_#{rows}.json"

    list = 
      case type do
        :eager -> eager(file)
        :lazy -> lazy(file)
        :flow -> flow(file)
        _ -> raise "set type as :eager, :lazy, or :flow"
      end
    
    IO.inspect list
    IO.puts "type: #{type}"
    IO.puts "names: #{Enum.count(list)}"
    IO.puts "processing: #{(timestamp() - start_time) / 1000} s"
    :ok
  end


  def eager(file) when is_bitstring(file) do
    File.stream!(file)
    |> Enum.map(&decode &1)
    |> Enum.map(fn person -> 
      %{name: %{first: first}} = person 
      first
    end)
    |> Enum.reduce(%{}, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)
    |> Enum.sort(fn {_, count1}, {_, count2} -> count1 >= count2 end)
    # |> Enum.to_list
  end


  def lazy(file) when is_bitstring(file) do    
    File.stream!(file)
    |> Stream.map(&decode &1)
    |> Stream.map(fn person -> 
      %{name: %{first: first}} = person 
      first
    end)
    |> Enum.reduce(%{}, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)
    |> Enum.sort(fn {_, count1}, {_, count2} -> count1 >= count2 end)
    # |> Enum.to_list
  end


  def flow(file) when is_bitstring(file) do    
    File.stream!(file)
    |> Flow.from_enumerable
    |> Flow.map(&decode &1)
    |> Flow.map(fn person -> 
      %{name: %{first: first}} = person 
      first
    end)
    |> Flow.partition
    |> Flow.reduce(fn -> %{} end, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)      
    |> Enum.sort(fn {_, count1}, {_, count2} -> count1 >= count2 end)
    # |> Enum.to_list
  end
end
